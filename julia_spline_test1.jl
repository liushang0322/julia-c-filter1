mutable struct _SPLINE
    data::Ptr{Cvoid}
    size::Ptr{Cvoid}
    allocatedSize::Cint
    numDimensions::Cint
    canFreeData::UInt8
end
const julia_spline_path = joinpath(__DIR__,"julia_filter1.so")
"""
spline - 三次样条数据插值
    此Syslab函数 返回与 xq 中的查询点对应的插值 s 的向量。s 的值由 x 和 y 的三次样条
    插值确定。

    s = spline(x,y,xq)


    输入参数
        x - x 坐标
            向量
        y - x 坐标处的函数值
            向量 | 矩阵 | 数组
        xq - 查询点
            标量 | 向量 | 矩阵 | 数组
"""
function spline(x, y, xq)
    canFreeData = UInt8(0)
    ### x
    data_x = Array{Cdouble}(x)
    if isa(x, Vector) || typeof(x) <: UnitRange
        size_x = Array{Cint}([length(x), 1])
    else
        size_x = Array{Cint}(collect(size(x)))
        if size_x[1] == 1
            size_x = reverse(size_x)
        end
    end
    allocatedSize_x = sizeof(Cdouble) * length(data_x)
    if isa(x, Vector) || typeof(x) <: UnitRange
        numDimensions_x = Cint(2)
    else
        numDimensions_x = Cint.(ndims(x))
    end

    st_x = _SPLINE(pointer(data_x), pointer(size_x), allocatedSize_x, numDimensions_x, canFreeData)

    ### y
    data_y = Array{Cdouble}(y)
    if isa(data_y, Vector) || typeof(data_y) <: UnitRange || (ndims(data_y) == 2 && size(data_y, 2) == 1)
        size_y = Cint.([1, length(data_y)])
    else
        size_y = Cint.(collect(size(data_y)))
        #=         if size_y[1] == 1
                                                                                                                                            
                end =#
    end
    # size_y = reverse(size_y)
    allocatedSize_y = sizeof(Cdouble) * length(data_y)
    if isa(data_y, Vector) || typeof(data_y) <: UnitRange
        numDimensions_y = Cint(2)
    else
        numDimensions_y = Cint.(ndims(data_y))
    end
    # canFreeData = UInt8(0)
    st_y = _SPLINE(pointer(data_y), pointer(size_y), allocatedSize_y, numDimensions_y, canFreeData)

    ### xq
    if isa(xq, Number)
        data_xq = Array{Cdouble}([xq])
    else
        data_xq = Array{Cdouble}(xq)
    end
    if isa(data_xq, Vector) || typeof(data_xq) <: UnitRange
        size_xq = Cint.([length(data_xq), 1])
    else
        size_xq = Cint.(collect(size(data_xq)))
    end
    allocatedSize_xq = sizeof(Cdouble) * length(data_xq)
    if isa(data_xq, Vector) || typeof(data_xq) <: UnitRange
        numDimensions_xq = Cint(2)
    else
        numDimensions_xq = Cint.(ndims(data_xq))
    end
    # canFreeData = UInt8(0)
    st_xq = _SPLINE(pointer(data_xq), pointer(size_xq), allocatedSize_xq, numDimensions_xq, canFreeData)

    ### p 
    Ny = collect(size(y))
    if isa(y, Vector) || (ndims(y) == 2 && (size(y, 1) == 1 || size(y, 2) == 1))
        data_p = Array{Cdouble}(undef, size(data_xq))
    else
        if length(xq) == 1 || isa(xq, Number) || (isa(xq, Vector) || (ndims(xq) == 2 && (size(xq, 1) == 1 || size(xq, 2) == 1)))
            data_p = Array{Cdouble}(undef, Tuple([Ny[1:end-1]; length(xq)]))
        else
            data_p = Array{Cdouble}(undef, Tuple([Ny[1:end-1]; collect(size(xq))]))
        end
    end

    if isa(data_p, Vector)
        size_p = [length(data_p), 1]
    else
        size_p = Cint.(collect(size(data_p)))
        if size_p[1] == 1
            size_p = reverse(size_p)
        end
    end
    allocatedSize_p = length(data_p) * sizeof(Cdouble)
    numDimensions_p = ndims(data_p) < 2 ? 2 : ndims(data_p)
    st_p = _SPLINE(pointer(data_p), pointer(size_p), allocatedSize_p, numDimensions_p, canFreeData)

    ### ccall
    ccall((:julia_spline, julia_spline_path), Cvoid, (Ref{_SPLINE}, Ref{_SPLINE}, Ref{_SPLINE}, Ref{_SPLINE}), st_x, st_y, st_xq, st_p)
    # print(st_p.size)
    return if length(data_p) == 1
        data_p[1]
    else
        data_p
    end
end
