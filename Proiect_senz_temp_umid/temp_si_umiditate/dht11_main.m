function dht11_main()
% Monitor DHT11 cu grafice semnal colectat și semnal filtrat


% --- Setări port serial ---
port     = "COM3"; 
baudRate = 9600;

% --- Variabile globale ---
global s t running tempData humData filtTemp filtHum
tempData = [];
humData  = [];
filtTemp = [];
filtHum  = [];
running  = false;

% --- Creează fereastra GUI ---
fig = figure('Name', 'DHT11 Raw & Filtrat', ...
             'NumberTitle', 'off', ...
             'Position', [300 200 700 500], ...
             'CloseRequestFcn', @closeGUI);

% --- Butoane Start / Stop ---
uicontrol('Style','pushbutton','String','Start', ...
    'Position',[50 450 100 40],'FontSize',12, ...
    'Callback',@startReading);
uicontrol('Style','pushbutton','String','Stop', ...
    'Position',[170 450 100 40],'FontSize',12, ...
    'Callback',@stopReading);

% --- Etichete valori curente ---
tempLbl = uicontrol('Style','text','Position',[50 410 300 25], ...
    'FontSize',11,'String','Temp brută: -- °C  |  Temp filtrată: -- °C');
humLbl  = uicontrol('Style','text','Position',[380 410 300 25], ...
    'FontSize',11,'String','Umid brută: -- %  |  Umid filtrată: -- %');

% --- Axes pentru grafice ---
    axRaw   = subplot(2,1,1);  % grafic semnal brut
title(axRaw,'Semnal brut');
xlabel(axRaw,'Număr citiri');
ylabel(axRaw,'Valori');
hold(axRaw,'on'); grid(axRaw,'on');

axFilt  = subplot(2,1,2);  % grafic semnal filtrat
title(axFilt,'Semnal filtrat (medie mobilă N=5)');
xlabel(axFilt,'Număr citiri');
ylabel(axFilt,'Valori');
hold(axFilt,'on'); grid(axFilt,'on');

% --- Închide port serial existent ---
if exist('s','var')
    try clear s; pause(0.5); catch; end
end

% --- Deschide portul serial ---
try
    s = serialport(port, baudRate);
    configureTerminator(s,"LF");
    flush(s);
catch ME
    errordlg("Nu pot deschide portul " + port + ": " + ME.message);
    return;
end

% --- Timer pentru citire periodică ---
t = timer('ExecutionMode','fixedSpacing', ...
          'Period',1, ...
          'TimerFcn',@timerCallback);

% ==== CALLBACK-URI ====

function startReading(~,~)
    if ~running
        running   = true;
        tempData  = [];
        humData   = [];
        filtTemp  = [];
        filtHum   = [];
        cla(axRaw);  cla(axFilt);
        start(t);
    end
end

function stopReading(~,~)
    if running
        running = false;
        stop(t);
    end
end

function timerCallback(~,~)
    if s.NumBytesAvailable > 0
        line = readline(s);
        vals = str2double(split(line,','));
        if numel(vals)==2 && all(~isnan(vals))
            % actualizează date brute
            tempData(end+1) = vals(1);
            humData(end+1)  = vals(2);
            % aplică filtru medie mobilă pe ultimele 5
            w = min(length(tempData),5);
            filtTemp(end+1) = mean(tempData(end-w+1:end));
            filtHum(end+1)  = mean(humData(end-w+1:end));

            % update etichete curente
            set(tempLbl,'String',sprintf(
                'Temp brută: %.2f °C  |  Temp filtrată: %.2f °C',...
                 vals(1), filtTemp(end)));
            set(humLbl,'String',sprintf(
                'Umid brută: %.2f %%  |  Umid filtrată: %.2f %%',...
                 vals(2), filtHum(end)));

            % plot semnal brut
            cla(axRaw);
            plot(axRaw,tempData,'-r');
            plot(axRaw,humData ,'--b');
            legend(axRaw,{'Temperatură','Umiditate'},'Location','best');

            % plot semnal filtrat
            cla(axFilt);
            plot(axFilt,filtTemp,'-r');
            plot(axFilt,filtHum ,'--b');
            legend(axFilt,{'Temperatură','Umiditate'},'Location','best');

            drawnow;
        end
    end
end

function closeGUI(~,~)
    try stop(t); delete(t); catch; end
    try clear s;       catch; end
    delete(fig);
end
```

end
