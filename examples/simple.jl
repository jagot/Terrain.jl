using Terrain
using Rayly, FixedSizeArrays, ColorTypes
using Images

function shade(i::Intersection)
    f = abs(dot(normal(i), i.ray.dir))
    RGB(f,f,f)
end

background = RGB(0.,0,0)

dd = -0.3

cam = SimpleCamera(Point{3}(0.,-1,-3),
                   Vec{3}(0.,1,1dd),
                   Vec{3}(0.,-1dd,1),
                   1.0, 1.0, 1.0,
                   400, 400)

hf = Terrain.Heightfield(1.,1.,100,100)
Terrain.faultline!(hf, 500, Terrain.sinstep(0.1,0.1))

compress(a::AbstractArray, mi, ma) = (a - minimum(a))*(ma-mi)/(maximum(a)-minimum(a)) + mi

hf2 = Heightfield(hf)
hf2.y = compress(hf2.y, -0.2, 0.2)
tris = Terrain.triangle_list(hf2)

acc = ListAccelerator()
add_tris!(acc, tris...)

@time img = render(cam) do ray::Ray
    hit = Rayly.intersect(acc, ray)
    hit != nothing ? shade(hit) : background
end

save_clamped("simple.png", img)
