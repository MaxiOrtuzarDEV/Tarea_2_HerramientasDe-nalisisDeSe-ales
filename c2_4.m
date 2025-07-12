den_orig = [1 40 623 5344 28672 70056];
num = [834 15846 70056];
k_vals = -1e5:10:1e5;
estables = [];

for k = k_vals
    den_k = den_orig;
    den_k(end) = den_k(end) + k;
    polos = roots(den_k);
    if all(real(polos) < 0)
        estables(end+1) = k;
    end
end

if isempty(estables)
    disp('No se encontraron valores de k para los que el sistema sea estable.');
else
    k_min = min(estables);
    k_max = max(estables);
    fprintf('El sistema es estable para k en el rango:\n');
    fprintf('%.2f <= k <= %.2f\n', k_min, k_max);
end

figure;
plot(estables, zeros(size(estables)), 'g.');
xlabel('Valor de k');
ylabel('Estabilidad');
title('Rango de k para el cual el sistema es estable');
grid on;
