% create pulse shape

y = prcos( 0.5, 5, 10);

% data
a = [ 1 1 1 0 0 1 0 1 1 0 0 0 ];

% zero pad the data
b = a * 2-1;
b0 = kron(b, [1 0 0 0 0 0 0 0 0 0 ]);

% pulse shape

z = conv( b0, y );

% cut off tail

zt = z( 47:end-45 );

% plot

figure
plot( zt, 'LineWidth',2);

hold on;

% sample intervals
ii = 5:10:length(zt);
plot(ii,zt(ii),'*', 'MarkerSize',5,'LineWidth',2);

% set up grid lines

set(gca,'XTick',[0:10:length(zt)]);

set(gca,'XLim',[0 119]);

set(gca,'YTick', [-1 0 1] );

grid on;

set(gca,'XtickLabel',[]);


set(gca,'YLim',[-1.5, 2.4] );

text(4,1.8,'1');
text(14,1.8,'1');
text(24,1.8,'1');
text(34,1.8,'0');
text(44,1.8,'0');
text(54,1.8,'1');
text(64,1.8,'0');
text(74,1.8,'1');
text(84,1.8,'1');
text(94,1.8,'0');
text(104,1.8,'0');
text(114,1.8,'0');

xlabel('Time');
ylabel('Amplitude              ');

 pbaspect([4,1,1]);