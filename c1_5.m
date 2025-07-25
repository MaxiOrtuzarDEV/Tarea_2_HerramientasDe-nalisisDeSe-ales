% Planta original F2(s)
num_F2 = [15 285 1260];
den_F2 = [1 40 623 4510 12826];

F2 = tf(num_F2, den_F2);

% Agregar polo en el origen (multiplicar por 1/s)
G = tf(num_F2, conv([1 0], den_F2));

% Rango de K a probar
K_vals = 0.1:0.5:200;

% Requisitos
ess_target = 3.5;
ess_tol = 1.0;

mejor_error = inf;
mejor_K = NaN;
mejor_info = struct();
mejor_ess = NaN;

for K = K_vals
    H = feedback(K*G, 1);  % Lazo cerrado

    info = stepinfo(H);
    ess = dcgain(H) * ess_target; % Ajustar ganancia para escalón de 3.5
    os = info.Overshoot;
    ts = info.SettlingTime;
    tr = info.RiseTime;

    % Penalización para valores fuera de los rangos deseados
    error_total = abs(ess - ess_target) + ...
                  penalty(os, 20, 30) + ...
                  penalty(ts, 0, 80) + ...
                  penalty(tr, 0, 15);

    if error_total < mejor_error
        mejor_error = error_total;
        mejor_K = K;
        mejor_info = info;
        mejor_ess = ess;
    end

    if abs(ess - ess_target) <= ess_tol && ...
       os >= 20 && os <= 30 && ...
       ts < 80 && tr < 15
        fprintf('\n✅ ¡Solución exacta encontrada con K = %.2f!\n', K);
        fprintf('Valor estacionario: %.2f\n', ess);
        fprintf('Sobreimpulso: %.2f%%\n', os);
        fprintf('Tiempo de asentamiento: %.2f s\n', ts);
        fprintf('Tiempo de subida: %.2f s\n', tr);
        figure;
        step(ess_target * H); % Escalón de 3.5
        title(sprintf('Respuesta al escalón con K = %.2f', K));
        grid on;
        return;
    end
end

% Si no encuentra combinación exacta, mostrar la mejor
fprintf('\n⚠️ No se encontró combinación exacta. Mejor combinación:\n');
fprintf('K = %.2f\n', mejor_K);
fprintf('Valor estacionario: %.2f\n', mejor_ess);
fprintf('Sobreimpulso: %.2f%%\n', mejor_info.Overshoot);
fprintf('Tiempo de asentamiento: %.2f s\n', mejor_info.SettlingTime);
fprintf('Tiempo de subida: %.2f s\n', mejor_info.RiseTime);

H_mejor = feedback(mejor_K * G, 1);
figure;
step(ess_target * H_mejor);
title(sprintf('Mejor respuesta con K = %.2f', mejor_K));
grid on;

% Función penalización auxiliar
function p = penalty(val, minVal, maxVal)
    if val < minVal
        p = abs(minVal - val);
    elseif val > maxVal
        p = abs(val - maxVal);
    else
        p = 0;
    end
end
