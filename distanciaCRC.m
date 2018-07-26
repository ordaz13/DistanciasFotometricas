function d = distanciaCRC(z)
%Esta función calcula la distancia a la que se encuentra un objeto a partir
%del corrimiento al rojo cosmologico
%   z - Corrimiento al rojo cosmologico
%   d - Distancia a la que se encuentra el objeto en kilometros
%   H0 = 70 Mpc*s^-1*km^-1 (Constante de Hubble en MegaParsec por segundo
%   por kilometro)
%   c = 3e5 km*s^-1 (Velocidad de la luz en kilometros por segundo)

%Definimos las constantes
H0 = 70; c = 3e5;
if z < 0.4
    %Calculamos la velocidad recesional
    vr = z*c;
else
    %Calculamos la velocidad recesional
    vr = (c*z^2 + 2*c*z)/(z^2 + 2*z + 2);
end
%Calculamos la distancia (esta en Mpc)
d = vr/H0;
%Convertimos a kilometros
d = d*3.08567758128e+19;
end

