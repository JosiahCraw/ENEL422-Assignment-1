import comms_utils
import numpy as np
import matplotlib.pyplot as plt

def closest(lst, K): 
    lst = np.asarray(lst) 
    idx = (np.abs(lst - K)).argmin() 
    return idx

if __name__ == "__main__":
    Tb = 0.000002
    pulse = comms_utils.pulse.Rect(Tb)
    message = comms_utils.ak.AK(levels=2, n=100)
    print(message)
    sy = comms_utils.psd.SY(pulse, Tb, message)
    rn = comms_utils.rn.RN(message)
    limit = (6*np.pi) / Tb
    x = [i for i in np.arange(-limit, limit, limit/5000)]
    y = comms_utils.threaded.sy(sy, x)
    markers = [-(6*np.pi/Tb), -(4*np.pi/Tb), -(2*np.pi/Tb), (2*np.pi/Tb), (4*np.pi/Tb), (6*np.pi/Tb)]
    # maker_labels = [r"$\frac{-6\pi}{T_b}$", r"$\frac{-4\pi}{T_b}$", r"$\frac{-2\pi}{T_b}$", r"$\frac{2\pi}{T_b}$", r"$\frac{4\pi}{T_b}$", r"$\frac{6\pi}{T_b}$"]
    marker_index = [closest(x, n) for n in markers]
    # y = [sy[n] for n in x]
    plot = plt.plot(x, y, '-gD', markevery=marker_index)
    plt.show()
