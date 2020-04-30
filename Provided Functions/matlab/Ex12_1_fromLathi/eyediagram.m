% function hout = eyediagram (x, n, xper, xoff, str, h)
%
% Plot the eye-diagram of x. 
%
%- This version modified from the Octave Communications library for 
%- use with Matlab when the Matlab communications toolbox is unavailable
%
% The signal x can be either in one of three forms:
%
% A real vector
%    In this case the signal is assumed to be real and represented by the vector
%    x. A single eye-diagram representing this signal is plotted.
%
% A complex vector
%    In this case the in-phase and quadrature components of the signal are
%    plotted separately.
%
% A matrix with two columns
%    In this case the first column represents the in-phase and the second the
%    quadrature components of a complex signal.
%
% Each line of the eye-diagram has n elements and the period is assumed
% to be given by xper. The time axis is then [-xper/2 xper/2].
% By default xper is 1.
%
% By default the signal is assumed to start at -xper/2. This can be
% overridden by the xoff variable, which gives the number of samples
% to delay the signal.
%
% The string str is a plot style string (example 'r+'),
% and by default is the default gnuplot line style.
%
% The figure handle to use can be defined by h. If h is not
% given, then the next available figure handle is used. The figure handle
% used in returned on hout.
%
%# Copyright (C) 2003 David Bateman
%#
%# This program is free software; you can redistribute it and/or modify it under
%# the terms of the GNU General Public License as published by the Free Software
%# Foundation; either version 3 of the License, or (at your option) any later
%# version.
%#
%# This program is distributed in the hope that it will be useful, but WITHOUT
%# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
%# FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
%# details.
%#
%# You should have received a copy of the GNU General Public License along with
%# this program; if not, see <http://www.gnu.org/licenses/>.


function hout = eyediagram (x, n, xper, xoff, str, h)

  if (nargin < 2 || nargin > 6)
    print_usage ();
  end

  if (isreal (x))
    if (min (size (x)) == 1)
      signal = 'real';
      xr = x(:);
    elseif (size (x, 2) == 2)
      signal = 'complex';
      xr = x(:,1);
      xi = x(:,2);
    else
      error ('eyediagram: real X must be a vector or a 2-column matrix');
    end
  else
    signal = 'complex';
    if (min (size (x)) ~= 1)
      error ('eyediagram: complex X must be a vector');
    end
    xr = real (x(:));
    xi = imag (x(:));
  end

  if (isempty(xr))
    error ('eyediagram: X must not be empty');
  end

  if (~ (isscalar (n) && isreal (n) && n == fix (n) && n > 0))
    error ('eyediagram: N must be a positive integer');
  end

  if (nargin > 2)
    if (isempty (xper))
      per = 1;
    elseif (isscalar (xper) && isreal (xper))
      per = xper;
    else
      error ('eyediagram: PER must be a real scalar');
    end
  else
    per = 1;
  end

  if (nargin > 3)
    if (isempty (xoff))
      off = 0;
    elseif (~(isscalar(xoff) && isreal(xoff) && xoff == fix(xoff) && xoff >= 0 && xoff < n))
      error('eyediagram: OFF must be an integer in the range [0,N-1]');
    else
      off = xoff;
    end
  else
    off = 0;
  end

  if (nargin > 4)
    if (isempty (str))
      fmt = '-';
    elseif (ischar (str))
      fmt = str;
    else
      error ('eyediagram: STR must be a string');
    end
  else
    fmt = '-';
  end

  if (nargin > 5)
    if (isempty (h))
      hout = figure ();
    elseif (isfigure (h) && strcmp (get (h, 'tag'), 'eyediagram'))
      hout = h;
    else
      error ('eyediagram: H must be an eyediagram figure handle');
    end
  else
    hout = figure ();
  end
  set (hout, 'tag', 'eyediagram');
  set (hout, 'name', 'Eye Diagram');
  set (0, 'currentfigure', hout);

  horiz = (per*(0:n)/n - per/2)';
  if (n/2 ~= fix (n/2))
    horiz = horiz - per / n / 2;
  end
  lx = length (xr);
  off = mod (off + ceil (n/2), n);
  Nn = ceil ((off + lx) / n);
  post = Nn*n - off - lx;
  xr = reshape ([NaN * ones(off, 1); xr; NaN * ones(post, 1)], n, Nn);
  xr = [xr ; [xr(1,2:end), NaN]];
  xr = [xr; NaN * ones(1, Nn)];
  if (all (isnan (xr(2:end,end))))
    xr(:,end) = [];
    horiz = [repmat(horiz(1:n+1), 1, Nn-1); NaN * ones(1, Nn - 1)];
    horiz = horiz(:);
  else
    horiz = [repmat(horiz(1:n+1), 1, Nn); NaN * ones(1, Nn)];
    horiz = horiz(:);
  end

  if (strcmp(signal,'complex'))
    xi = reshape([NaN * ones(off,1); xi; NaN * ones(post, 1)], n, Nn);
    xi = [xi ; [xi(1,2:end), NaN]];
    xi = [xi; NaN * ones(1, Nn)];
    if (all (isnan (xi(2:end,end))))
      xi(:,end) = [];
    end
  end

  if (strcmp (signal, 'complex'))
    subplot (2, 1, 1);
    plot (horiz, xr(:), fmt);
    xlim ([horiz(1), horiz(end-1)]);
    title ('Eye-diagram for in-phase signal');
    xlabel ('Time');
    ylabel ('Amplitude');
    subplot (2, 1, 2);
    plot (horiz, xi(:), fmt);
    xlim ([horiz(1), horiz(end-1)]);
    title ('Eye-diagram for quadrature signal');
    xlabel ('Time');
    ylabel ('Amplitude');
  else
    plot (horiz, xr(:), fmt);
    xlim ([horiz(1), horiz(end-1)]);
    title ('Eye-diagram for signal');
    xlabel ('Time');
    ylabel ('Amplitude');
  end

end
