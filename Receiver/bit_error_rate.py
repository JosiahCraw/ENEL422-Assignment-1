import comms_utils
import matplotlib.pyplot as plt
import numpy as np
import matplotlib

# --------------------------------------------------
# Sets displying figure vs generating Latex pgfplot
# --------------------------------------------------
generating_figure = True

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
    data_length = 5000 # 10000bits / 2 for symbol rate
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

    # Generate dB options
    db_vals = [db for db in np.arange(1, 11, 1)]

    # Plot the bit error rate to dB
    if (generating_figure == True):
        comms_utils.plot.bit_errors(signal, comb_function, pulse, db_vals,
            pgf_plot='bit-error-10000.pgf')
    else:
        comms_utils.plot.bit_errors(signal, comb_function, pulse, db_vals)