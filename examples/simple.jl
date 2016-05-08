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

hf = Heightfield(1.,1.,0.05rand(10,10))
tris = Terrain.triangle_list(hf)

acc = ListAccelerator()
add_tris!(acc, tris...)

@time img = render(cam, JitteredSampler(9)) do ray::Ray
    hit = Rayly.intersect(acc, ray)
    hit != nothing ? shade(hit) : background
end

save_clamped("simple.png", img)
