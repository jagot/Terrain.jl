using FixedSizeArrays

type Heightfield
    w::Float64
    h::Float64
    y::Matrix{Float64}
end

Heightfield(w::Float64,h::Float64, nx::Integer, nz::Integer) =
    Heightfield(w, h, zeros(Float64, nx, nz))

function triangle_list(hf::Heightfield)
    nx,nz = size(hf.y)
    x = linspace(-1,1,nx)*hf.w/2
    z = linspace(-1,1,nz)*hf.h/2
    dx = hf.w/(nx-1)
    dz = hf.h/(nz-1)

    vertices = Vector{Point{3,Float64}}()
    for xi in 1:nx
        for zi in 1:nz
            push!(vertices, Point(x[xi], hf.y[xi,zi], z[zi]))
        end
    end

    Dx = Tridiagonal(-ones(nx-1),zeros(nx),ones(nx-1))
    Dz = Tridiagonal(-ones(nz-1),zeros(nz),ones(nz-1))

    dydx = Dx*hf.y
    dydz = (Dz*hf.y')'

    normals = Vector{Vec{3,Float64}}()
    for xi in 1:nx
        for zi in 1:nz
            a = Vec(2dx, dydx[xi,zi], 0.)
            b = Vec(0., dydz[xi,zi], 2dz)
            push!(normals, -normalize(cross(a,b)))
        end
    end

    faces = Vector{Tuple}()
    for xi in 0:nx-2
        for zi in 1:nz-1
            push!(faces, (zi + xi*nz, zi + (xi+1)*nz, zi + 1 + (xi+1)*nz))
            push!(faces, (zi + xi*nz, zi + 1 + (xi+1)*nz, zi + 1 + xi*nz))
        end
    end

    vertices, normals, faces
end

export Heightfield, view, triangle_list
