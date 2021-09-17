gputime = [1573.77, 691.804, 3851.44, 3113.64, 5210.49, 1536.54];
cputime = [2184.4, 913.958, 5408.99, 4398.04, 7626.99, 2198.88];
speedup = gputime./cputime;
x = 1:6;
plot(x,cputime, 'b*', x,gputime,'r*')
xlim([0,7])
xlabel("image number")
ylabel("time used in ms")
legend(["CPU", "GPU"])
title("time used by GPU and CPU")