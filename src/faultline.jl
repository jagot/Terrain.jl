simplestep(s) = d -> d>0 ? s : -s
sinstep(s,w) = d -> (abs(d) < w ? sin(π/2*d/w) : sign(d))*s

function faultline!(hf::Heightfield, iters, step::Function)
    nx,nz = size(hf.y)
    x = linspace(-1,1,nx)*hf.w/2
    z = linspace(-1,1,nz)*hf.h/2
    d = sqrt(hf.w^2 + hf.h^2)
    for i = 1:iters
        v = 2π*rand()
        a,b = sin(v),cos(v)
        c = (2rand()-1)*d/2
        
        for xi = eachindex(x)
            for zi = eachindex(z)
                hf.y[xi,zi] += step(a*x[xi] + b*z[zi] - c)
            end
        end
    end
end

export faultline!, simplestep, sinstep
