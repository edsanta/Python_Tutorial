function [minim,difusiv,efusiv,phi,beta,tiempo] = DE_ajuste(m,bL,bU,Cr,gmax,fob)
  tic;
  
  n = length(bL);
  % Población ------------------------------------------
  X = [rand(m,n).*(bU-bL) + bL];
  %
  for g = 0:gmax
    g++;
    % Mutantes -----------------------------------------
    V = zeros(m,n);
    for i = 1:m
      r = randperm(m,3);
      al = rand();
      V(i,:) = X(r(1),:) + al * (X(r(2),:) - X(r(3),:));
      if(any(V(i,:) < bL) || any(V(i,:) > bU))
        for j = 1:n
          V(i,j) = bL(j) + rand() * (bU(j) - bL(j));
        endfor
      endif
    endfor
    % Cruza --------------------------------------------
    U = zeros(m,n);
    for i = 1:m
      for j = 1:n
        jrand = rand();
        if(jrand <= Cr || j == jrand)
          U(i,j) = V(i,j);
        else
          U(i,j) = X(i,j);
        endif
      endfor
    endfor
    % Selección ---------------------------------------
    S = zeros(m,n);
    for i = 1:m
      if(fob(U(i,:)) <= fob(X(i,:)))
        S(i,:) = U(i,:);
      else
        S(i,:) = X(i,:);
      endif
    endfor
    X = S;
    % Mejor -------------------------------------------
    fval = zeros(m,1);
    for k = 1:m
      fval(k) = fob(X(k,:));
    endfor
    [minim,indic] = min(fval);
    difusiv = X(indic,1);
    efusiv = X(indic,2);
    phi=X(indic,3);
    beta=X(indic,4);
  endfor
  %
  tiempo = toc;
endfunction