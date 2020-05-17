import comms_utils
import matplotlib.pyplot as plt
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
    message = '0010110111'
    levels = 4
    oversample_factor = 8

    bandwidth = 500000
    tb = 1/bandwidth
    ts = tb*2

    alpha = 1

    # This encodes a binary string to a list of amplitude values
    encoded = comms_utils.encode.bin_to_pam(message, levels)
    
    # Defining the Niquist Pulse
    pulse = comms_utils.pulse.RCos(ts, alpha)

    # Declaring a new ak with the encoded data
    ak = comms_utils.ak.AK(data=encoded, levels=levels)
    # Generating a driac comb using the ak values with an 8x oversample
    comb_function = comms_utils.comb.Comb(ak, ts, oversample_factor)
    # Pulse shaping the frac comb with the Niquist pulse
    signal = comb_function.pulse_shape(pulse)

    # Plot the resulting signal
    signal.plot()
    signal.plot_psd()

    # ------------------------------------------
    # This part generates the graph with guides
    # ------------------------------------------

    # This oversamples the ak, effectively 8x ing the data generating 
    # rectangle pulse
    ak.oversample(oversample_factor)
    # Gets the shaped signal data
    signal_data, signal_time = signal.get_data()

    # Gets the oversampled ak data
    original_data = ak.get_data()
    # Applies the delay created by the pulse shaping
    original_data = pulse.apply_conv_delay(len(signal_data), original_data)

    # Plot both of the datasets
    plot_shaped = plt.plot(signal_time, signal_data, '-b')
    plt.title("Nyquist Pulse shaped Signal")
    plt.xlabel("Time (s)")
    plt.ylabel("Amplitude")
    plt.grid(True)
    plot_original = plt.plot(signal_time, original_data, '--r')

    if (generating_figure == True):
        plt.savefig('pulse_shape.pgf')
    plt.show()
    