import comms_utils
import matplotlib.pyplot as plt
import matplotlib

if __name__ == "__main__":
    # Variable declaration
    data_length = 1000
    levels = 4
    oversample_factor = 8

    bandwidth = 1
    tb = 1/bandwidth
    ts = tb*2

    alpha = 0.5

    snr_db = 0
    
    # Defining the Root Raised Cosine Pulse
    pulse = comms_utils.pulse.Rect(ts)

    # Declaring a new ak with a length of `data_length` data
    ak = comms_utils.ak.AK(n=data_length, levels=levels)
    # Generating a driac comb using the ak values with an 8x oversample
    comb_function = comms_utils.comb.Comb(ak, ts, oversample_factor)
    # Pulse shaping the frac comb with the Niquist pulse
    signal = comb_function.pulse_shape(pulse)

    # Apply noise to transmitted signal
    signal.add_noise(snr_db)
    signal.plot_psd()