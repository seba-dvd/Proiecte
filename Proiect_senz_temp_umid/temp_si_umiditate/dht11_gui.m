function dht11_gui()
    % Interfață simplă pentru citire DHT11 de pe Arduino

    % === Configurare port serial ===
    port = "COM3";     
    baudRate = 9600;

    try
        s = serialport(port, baudRate);
        configureTerminator(s, "LF");
        flush(s);
    catch
        error("Nu s-a putut conecta la %s. Verifică dacă Arduino e conectat și portul e corect.", port);
    end

    % === Inițializare GUI ===
    fig = figure('Name', 'DHT11 GUI Simplu', ...
                 'NumberTitle', 'off', ...
                 'Position', [300 300 600 400]);

    % Buton de citire
    uicontrol('Style', 'pushbutton', 'String', 'Citește', ...
              'Position', [250 320 100 40], ...
              'FontSize', 12, ...
              'Callback', @citesteDate);

    % Axes pentru grafic
    ax = axes('Parent', fig, 'Position', [0.1 0.2 0.8 0.4]);
    title(ax, 'Temperatură și umiditate');
    xlabel(ax, 'Citiri');
    ylabel(ax, 'Valori');
    grid(ax, 'on');
    
    % Variabile pentru stocare temporară
    tempVec = [];
    humVec = [];

    % === Funcție de citire din serial și afișare ===
    function citesteDate(~, ~)
        if s.NumBytesAvailable > 0
            str = readline(s);
            valori = str2double(split(str, ","));
            if length(valori) == 2 && all(~isnan(valori))
                t = valori(1);
                h = valori(2);
                tempVec(end+1) = t;
                humVec(end+1) = h;

                % Filtru simplu: medie mobilă pe 5 puncte
                t_filt = movmean(tempVec, 5);
                h_filt = movmean(humVec, 5);

                % Actualizează grafic
                cla(ax);
                plot(ax, tempVec, '-or'); hold on;
                plot(ax, t_filt, '-r', 'LineWidth', 1.5);
                plot(ax, humVec, '-ob');
                plot(ax, h_filt, '-b', 'LineWidth', 1.5);
                legend('Temp','Temp filtrată','Umid','Umid filtrată');
                drawnow;

                % Afișare în consolă
                fprintf("Temperatură: %.1f °C | Umiditate: %.1f %%\n", t, h);
            else
                disp("Date invalide citite.");
            end
        else
            disp("Nu sunt date disponibile.");
        end
    end
end
