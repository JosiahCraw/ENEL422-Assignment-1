import comms_utils
import matplotlib.pyplot as plt
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
    data_length = 1000
    levels = 4
    oversample_factor = 8

    bandwidth = 1
    tb = 1/bandwidth
    ts = tb*2

    alpha = 1

    snr_db = 10
    
    # Defining the Root Raised Cosine Pulse
    pulse = comms_utils.pulse.RRCos(ts, alpha)

    # Declaring a new ak with a length of `data_length` data
    ak = comms_utils.ak.AK(n=data_length, levels=levels)
    # Generating a driac comb using the ak values with an 8x oversample
    comb_function = comms_utils.comb.Comb(ak, ts, oversample_factor)
    # Pulse shaping the frac comb with the Niquist pulse
    signal = comb_function.pulse_shape(pulse)

    # Apply noise to transmitted signal
    signal.add_noise(snr_db)

    # Convolve the sent signal with the rrcos pulse
    recived = signal.convolve(pulse)

    # Apply the convolution dealay to the driac timing comb
    delayed_comb = pulse.apply_conv_delay(len(signal), comb_function.get_clock_comb())

    # Plot the resulting eye diagram
    if (generating_figure == True):
        comms_utils.plot.eye_diagram(recived, pulse, delayed_comb, num_periods=3,
        plot_sample_lines=True, pgf_plot='eye_noise.pgf')
    else:
        comms_utils.plot.eye_diagram(recived, pulse, delayed_comb, num_periods=3,
            plot_sample_lines=True)
    