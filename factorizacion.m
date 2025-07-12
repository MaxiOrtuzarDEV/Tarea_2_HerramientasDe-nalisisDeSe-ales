syms s

% Datos originales de F2(s)
num = [15 285 1260];
den = [1 40 623 4510 12826];
F2 = tf(num, den);

% Factorización numérica
[z, p, k] = tf2zp(num, den);

% Construcción simbólica
numerador_sim = k;
for i = 1:length(z)
    numerador_sim = numerador_sim * (s - z(i));
end

denominador_sim = 1;
for i = 1:length(p)
    denominador_sim = denominador_sim * (s - p(i));
end

% Función factorizada simbólica
F2_symbolic = simplify(numerador_sim / denominador_sim);

% Mostrar resultado
disp('--- F2(s) expresada simbólicamente como producto de factores ---');
pretty(F2_symbolic)
