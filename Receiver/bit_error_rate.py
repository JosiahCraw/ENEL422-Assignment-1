import comms_utils
import matplotlib.pyplot as plt
import numpy as np
import matplotlib

# --------------------------------------------------
# Sets displying figure vs generating Latex pgfplot
# --------------------------------------------------
generating_figure = False

if (generating_figure == True):
    matplotlib.use("pgf")
    matplotlib.rcParams.update({
        "pgf.texsystem": "pdflatex",
        'font.family': 'serif',
        'text.usetex': True,
        'pgf.rcfonts': False,
    })


if __name__ == "__main__":
    # Variable declaration
    data_length = 50000 # 10000bits / 2 for symbol rate
    levels = 4
    oversample_factor = 8

    bandwidth = 1
    tb = 1/bandwidth
    ts = tb*2

    alpha = 1
    
    # Defining the Root Raised Cosine Pulse
    pulse = comms_utils.pulse.RRCos(ts, alpha)

    # Declaring a new ak with a length of `data_length` data
    ak = comms_utils.ak.AK(n=data_length, levels=levels)
    # Generating a driac comb using the ak values with an 8x oversample
    comb_function = comms_utils.comb.Comb(ak, ts, oversample_factor)

    # Pulse shaping the frac comb with the Niquist pulse
    signal = comb_function.pulse_shape(pulse)
    comb_function.delay_clock_comb(pulse, len(signal))

    signal.add_noise(10)
    
    # Convolve the sent signal with the rrcos pulse
    recived = signal.convolve(pulse)
    comb_function.delay_clock_comb(pulse, len(recived))

    decoded = comms_utils.decode.decode_pam(recived*comb_function.get_clock_comb(), levels)

    # Generate dB options
    db_vals = [db for db in np.arange(0, 10, 1)]

    # Plot the bit error rate to dB
    if (generating_figure == True):
        comms_utils.plot.bit_errors(recived, comb_function, db_vals,
            pgf_plot='bit-error.pgf')
    else:
        comms_utils.plot.bit_errors(recived, comb_function, db_vals)