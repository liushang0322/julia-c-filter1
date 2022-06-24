mutable struct filter_test_struct
    data::Ptr{Cvoid}
    size::Ptr{Cvoid}
    allocatedSize::Cint
    numDimensions::Cint
    canFreeData::UInt8
end
const julia_filter_2out5in = joinpath(@__DIR__, "julia_filter_2out5in.so") ### 索引
function filter1(b, a, x, zi = [])
    ############# b封装 #############
    data_b = Array{Cdouble}(b)## 分配内存
    size_b = Array{Cint}([size(b, 1), 1]) ## 分配内存
    allocatedSize_b = length(data_b) * sizeof(Cdouble)
    numDimensions_ab = Cint(2)
    canFreeData = UInt8(0)
    st_b = filter_test_struct(pointer(data_b), pointer(size_b), allocatedSize_b, numDimensions_ab, canFreeData)
    ############# a封装 #############
    if isa(a, Number)
        a = [a]
        data_a = Array{Cdouble}(a)
        size_a = Array{Cint}([1, 1])
    else
        data_a = Array{Cdouble}(a)## 分配内存
        size_a = Array{Cint}([size(a, 1), 1]) ## 分配内存
    end
    allocatedSize_a = length(data_a) * sizeof(Cdouble)
    st_a = filter_test_struct(pointer(data_a), pointer(size_a), allocatedSize_a, numDimensions_ab, canFreeData)
    ############# x封装 #############
    data_x = Cdouble.(x)
    if isa(x, Vector)
        size_x = Vector{Cint}([size(x, 1), 1]) ## 分配内存
    else
        size_x = Cint.(collect(size(x)))
        # sizex = size(x)
        # sizexl = length(sizex)
        # size_x = ones(Cint, sizexl)
        # for i = 1:sizexl
        #     size_x[i] = sizex[i]
        # end
        if size_x[1] == 1
            size_x = reverse(size_x)
        end
        # size_x = Vector{Cint}([length(x), 1])
    end
    allocatedSize_x = length(data_x) * sizeof(Cdouble)
    if isa(x, Vector)
        numDimensions_x = 2
    else
        numDimensions_x = Cint(ndims(x))
    end
    st_x = filter_test_struct(pointer(data_x), pointer(size_x), allocatedSize_x, numDimensions_x, canFreeData)

    ############# zi封装 #############
    if zi == []
        sizezi = size(x)
        # sizezf[1] = max(length(a), length(b)) - 1
        if isa(x, Vector)
            data_zi = Vector{Cdouble}(undef, max(length(a), length(b)) - 1)
            size_zi = Vector{Cint}([max(length(a), length(b)) - 1, 1])
        else
            # data_zf = Array{Vector{Cdouble}(undef, max(length(a), length(b)) - 1)}(undef, size(x, 2))  ### 列向量数组？
            data_zi = Array{Cdouble}(undef, max(length(a), length(b)) - 1)
            data_zi_tmp = copy(data_zi)
            for i = 1:size(x, 2)-1
                data_zi = hcat(data_zi, data_zi_tmp)
            end
            # size_zi = ones(Cint, length(size(data_zi)))
            size_zi = Cint.(collect(size(data_zi)))
            # for i = 1:length(size_zi)
            #     size_zi[i] = sizezi[i]
            # end
            # size_zi[1] = max(length(a), length(b)) - 1
        end

        allocatedSize_zi = length(data_zi) * sizeof(Cdouble)
        if isa(data_zi, Vector)
            numDimensions_zi = 2
        else
            numDimensions_zi = Cint(ndims(zi))
        end
        st_zi = filter_test_struct(pointer(data_zi), pointer(size_zi), allocatedSize_zi, numDimensions_zi, canFreeData)
    else
        data_zi = Array{Cdouble}(zi)
        data_zi_tmp = copy(data_zi)
        for i = 1:size(x, 2)-1
            data_zi = hcat(data_zi, data_zi_tmp)
        end
        if isa(zi, Vector)
            size_zi = Cint.([size(data_zi, 1), 1])
        else
            size_zi = Cint.(collect(size(data_zi)))
        end
        allocatedSize_zi = length(data_zi) * sizeof(Cdouble)
        if isa(data_zi, Vector)
            numDimensions_zi = 2
        else
            numDimensions_zi = Cint(ndims(zi))
        end
        st_zi = filter_test_struct(pointer(data_zi), pointer(size_zi), allocatedSize_zi, numDimensions_zi, canFreeData)

    end

    ############# y封装 #############
    data_y = Array{Cdouble}(undef, size(x))
    if isa(data_y, Vector)
        size_y = Vector{Cint}([size(x, 1), 1]) ## 分配内存
    else
        size_y = Cint.(collect(size(x)))
        # sizey = size(x)
        # sizely = length(sizey)
        # size_y = ones(Cint, sizely)
        # for i = 1:sizely
        #     size_y[i] = sizey[i]
        # end
        if size_y[1] == 1
            size_y = reverse(size_y)
        end
        # size_y = reverse(size_y)
        # size_res = Vector{Cint}([length(x), 1])
    end
    allocatedSize_y = length(data_y) * sizeof(Cdouble)
    if isa(x, Vector)
        numDimensions_y = Cint(2)
    else
        numDimensions_y = Cint(ndims(data_y))
    end
    st_y = filter_test_struct(pointer(data_y), pointer(size_y), allocatedSize_y, numDimensions_y, canFreeData)
    ############# zf封装 #############
    sizezf = size(x)
    # sizezf[1] = max(length(a), length(b)) - 1
    if isa(x, Vector)
        data_zf = Vector{Cdouble}(undef, max(length(a), length(b)) - 1)
        size_zf = Vector{Cint}([max(length(a), length(b)) - 1, 1])
    else
        # data_zf = Array{Vector{Cdouble}(undef, max(length(a), length(b)) - 1)}(undef, size(x, 2))  ### 列向量数组？
        data_zf = Array{Cdouble}(undef, max(length(a), length(b)) - 1)
        data_zf_tmp = copy(data_zf)
        for i = 1:size(x, 2)-1
            data_zf = hcat(data_zf, data_zf_tmp)
        end
        size_zf = collect(size(data_zf))
        # size_zf = ones(Cint, length(size(data_zf)))
        # for i = 1:length(size_zf)
        #     size_zf[i] = sizezf[i]
        # end
        # size_zf[1] = max(length(a), length(b)) - 1
    end

    allocatedSize_zf = length(data_zf) * sizeof(Cdouble)
    if isa(data_zf, Vector)
        numDimensions_zf = 2
    else
        numDimensions_zf = Cint(ndims(data_zf))
    end
    st_zf = filter_test_struct(pointer(data_zf), pointer(size_zf), allocatedSize_zf, numDimensions_zf, canFreeData)



    # ccall((:filter1, "TyMath/filter/filter1.so"), Cvoid, (Ref{filter_test_struct}, Ref{filter_test_struct}, Ref{filter_test_struct}, Ref{filter_test_struct}, Ref{filter_test_struct}), st_b, st_a, st_x, st_y, st_zf)

    ccall((:julia_filter_2out4in, julia_filter_2out5in), Cvoid, (Ref{filter_test_struct}, Ref{filter_test_struct}, Ref{filter_test_struct}, Ref{filter_test_struct}, Ref{filter_test_struct}, Ref{filter_test_struct}), st_b, st_a, st_x, st_zi, st_y, st_zf)

    return data_y, data_zf
end
# filter1_tmp(dim) = filter1(b,a,x,zi,dim)
function filter1(b::Vector, a::Vector, x, zi, dim::Integer)
    if isa(x, Vector)
        if dim > 3
            error("dim超过x的维度")
        end
        if dim == 2
            y = Array{Union{Any}}(missing, length(x))
            zf = Array{Union{Any}}(missing, length(x))
            for i = 1:length(x)
                y[i], zf[i] = filter1(b, a, [x[i]], zi)
            end
            return y, zf
        end
    else
        if dim > ndims(x)
            error("dim超过x的维度")
        end
    end

    # x = collect(Array.(eachslice(x,dims = dim)))
    # y = Array{Union{Any}}(missing, length(x))
    # zf = Array{Union{Any}}(missing, length(x))
    # for i = 1:length(x)
    #     y[i], zf[i] = filter1(b, a, x[i], zi)
    # end
    y = mapslices(x -> filter1_y(b, a, x, zi), x, dims = dim)
    zf = mapslices(x -> filter1_zf(b, a, x, zi), x, dims = dim)
    return y, zf
end



function filter1_y(b, a, x, zi = [])
    ############# b封装 #############
    data_b = Array{Cdouble}(b)## 分配内存
    size_b = Array{Cint}([size(b, 1), 1]) ## 分配内存
    allocatedSize_b = length(data_b) * sizeof(Cdouble)
    numDimensions_ab = Cint(2)
    canFreeData = UInt8(0)
    st_b = filter_test_struct(pointer(data_b), pointer(size_b), allocatedSize_b, numDimensions_ab, canFreeData)
    ############# a封装 #############
    if isa(a, Number)
        data_a = [a]
        size_a = [1, 1]
    else
        data_a = Array{Cdouble}(a)## 分配内存
        size_a = Array{Cint}([size(a, 1), 1]) ## 分配内存
    end
    allocatedSize_a = length(data_a) * sizeof(Cdouble)
    st_a = filter_test_struct(pointer(data_a), pointer(size_a), allocatedSize_a, numDimensions_ab, canFreeData)
    ############# x封装 #############
    data_x = Cdouble.(x)
    if isa(x, Vector)
        size_x = Vector{Cint}([size(x, 1), 1]) ## 分配内存
    else
        size_x = Cint.(collect(size(x)))
        # sizex = size(x)
        # sizexl = length(sizex)
        # size_x = ones(Cint, sizexl)
        # for i = 1:sizexl
        #     size_x[i] = sizex[i]
        # end
        if size_x[1] == 1
            size_x = reverse(size_x)
        end
        # size_x = Vector{Cint}([length(x), 1])
    end
    allocatedSize_x = length(data_x) * sizeof(Cdouble)
    if isa(x, Vector)
        numDimensions_x = 2
    else
        numDimensions_x = Cint(ndims(x))
    end
    st_x = filter_test_struct(pointer(data_x), pointer(size_x), allocatedSize_x, numDimensions_x, canFreeData)

    ############# zi封装 #############
    if zi == []
        sizezi = size(x)
        # sizezf[1] = max(length(a), length(b)) - 1
        if isa(x, Vector)
            data_zi = Vector{Cdouble}(undef, max(length(a), length(b)) - 1)
            size_zi = Vector{Cint}([max(length(a), length(b)) - 1, 1])
        else
            # data_zf = Array{Vector{Cdouble}(undef, max(length(a), length(b)) - 1)}(undef, size(x, 2))  ### 列向量数组？
            data_zi = Array{Cdouble}(undef, max(length(a), length(b)) - 1)
            data_zi_tmp = copy(data_zi)
            for i = 1:size(x, 2)-1
                data_zi = hcat(data_zi, data_zi_tmp)
            end
            # size_zi = ones(Cint, length(size(data_zi)))
            size_zi = Cint.(collect(size(data_zi)))
            # for i = 1:length(size_zi)
            #     size_zi[i] = sizezi[i]
            # end
            # size_zi[1] = max(length(a), length(b)) - 1
        end

        allocatedSize_zi = length(data_zi) * sizeof(Cdouble)
        if isa(data_zi, Vector)
            numDimensions_zi = 2
        else
            numDimensions_zi = Cint(ndims(zi))
        end
        st_zi = filter_test_struct(pointer(data_zi), pointer(size_zi), allocatedSize_zi, numDimensions_zi, canFreeData)
    end

    ############# y封装 #############
    data_y = Array{Cdouble}(undef, size(x))
    if isa(data_y, Vector)
        size_y = Vector{Cint}([size(x, 1), 1]) ## 分配内存
    else
        size_y = Cint.(collect(size(x)))
        # sizey = size(x)
        # sizely = length(sizey)
        # size_y = ones(Cint, sizely)
        # for i = 1:sizely
        #     size_y[i] = sizey[i]
        # end
        if size_y[1] == 1
            size_y = reverse(size_y)
        end
        # size_y = reverse(size_y)
        # size_res = Vector{Cint}([length(x), 1])
    end
    allocatedSize_y = length(data_y) * sizeof(Cdouble)
    if isa(x, Vector)
        numDimensions_y = Cint(2)
    else
        numDimensions_y = Cint(ndims(data_y))
    end
    st_y = filter_test_struct(pointer(data_y), pointer(size_y), allocatedSize_y, numDimensions_y, canFreeData)
    ############# zf封装 #############
    sizezf = size(x)
    # sizezf[1] = max(length(a), length(b)) - 1
    if isa(x, Vector)
        data_zf = Vector{Cdouble}(undef, max(length(a), length(b)) - 1)
        size_zf = Vector{Cint}([max(length(a), length(b)) - 1, 1])
    else
        # data_zf = Array{Vector{Cdouble}(undef, max(length(a), length(b)) - 1)}(undef, size(x, 2))  ### 列向量数组？
        data_zf = Array{Cdouble}(undef, max(length(a), length(b)) - 1)
        data_zf_tmp = copy(data_zf)
        for i = 1:size(x, 2)-1
            data_zf = hcat(data_zf, data_zf_tmp)
        end
        size_zf = collect(size(data_zf))
        # size_zf = ones(Cint, length(size(data_zf)))
        # for i = 1:length(size_zf)
        #     size_zf[i] = sizezf[i]
        # end
        # size_zf[1] = max(length(a), length(b)) - 1
    end

    allocatedSize_zf = length(data_zf) * sizeof(Cdouble)
    if isa(data_zf, Vector)
        numDimensions_zf = 2
    else
        numDimensions_zf = Cint(ndims(data_zf))
    end
    st_zf = filter_test_struct(pointer(data_zf), pointer(size_zf), allocatedSize_zf, numDimensions_zf, canFreeData)



    # ccall((:filter1, "TyMath/filter/filter1.so"), Cvoid, (Ref{filter_test_struct}, Ref{filter_test_struct}, Ref{filter_test_struct}, Ref{filter_test_struct}, Ref{filter_test_struct}), st_b, st_a, st_x, st_y, st_zf)

    ccall((:julia_filter_2out4in, julia_filter_2out5in), Cvoid, (Ref{filter_test_struct}, Ref{filter_test_struct}, Ref{filter_test_struct}, Ref{filter_test_struct}, Ref{filter_test_struct}, Ref{filter_test_struct}), st_b, st_a, st_x, st_zi, st_y, st_zf)

    return data_y
end


function filter1_zf(b, a, x, zi = [])
    ############# b封装 #############
    data_b = Array{Cdouble}(b)## 分配内存
    size_b = Array{Cint}([size(b, 1), 1]) ## 分配内存
    allocatedSize_b = length(data_b) * sizeof(Cdouble)
    numDimensions_ab = Cint(2)
    canFreeData = UInt8(0)
    st_b = filter_test_struct(pointer(data_b), pointer(size_b), allocatedSize_b, numDimensions_ab, canFreeData)
    ############# a封装 #############
    if isa(a, Number)
        data_a = [a]
        size_a = [1, 1]
    else
        data_a = Array{Cdouble}(a)## 分配内存
        size_a = Array{Cint}([size(a, 1), 1]) ## 分配内存
    end
    allocatedSize_a = length(data_a) * sizeof(Cdouble)
    st_a = filter_test_struct(pointer(data_a), pointer(size_a), allocatedSize_a, numDimensions_ab, canFreeData)
    ############# x封装 #############
    data_x = Cdouble.(x)
    if isa(x, Vector)
        size_x = Vector{Cint}([size(x, 1), 1]) ## 分配内存
    else
        size_x = Cint.(collect(size(x)))
        # sizex = size(x)
        # sizexl = length(sizex)
        # size_x = ones(Cint, sizexl)
        # for i = 1:sizexl
        #     size_x[i] = sizex[i]
        # end
        if size_x[1] == 1
            size_x = reverse(size_x)
        end
        # size_x = Vector{Cint}([length(x), 1])
    end
    allocatedSize_x = length(data_x) * sizeof(Cdouble)
    if isa(x, Vector)
        numDimensions_x = 2
    else
        numDimensions_x = Cint(ndims(x))
    end
    st_x = filter_test_struct(pointer(data_x), pointer(size_x), allocatedSize_x, numDimensions_x, canFreeData)

    ############# zi封装 #############
    if zi == []
        sizezi = size(x)
        # sizezf[1] = max(length(a), length(b)) - 1
        if isa(x, Vector)
            data_zi = Vector{Cdouble}(undef, max(length(a), length(b)) - 1)
            size_zi = Vector{Cint}([max(length(a), length(b)) - 1, 1])
        else
            # data_zf = Array{Vector{Cdouble}(undef, max(length(a), length(b)) - 1)}(undef, size(x, 2))  ### 列向量数组？
            data_zi = Array{Cdouble}(undef, max(length(a), length(b)) - 1)
            data_zi_tmp = copy(data_zi)
            for i = 1:size(x, 2)-1
                data_zi = hcat(data_zi, data_zi_tmp)
            end
            # size_zi = ones(Cint, length(size(data_zi)))
            size_zi = Cint.(collect(size(data_zi)))
            # for i = 1:length(size_zi)
            #     size_zi[i] = sizezi[i]
            # end
            # size_zi[1] = max(length(a), length(b)) - 1
        end

        allocatedSize_zi = length(data_zi) * sizeof(Cdouble)
        if isa(data_zi, Vector)
            numDimensions_zi = 2
        else
            numDimensions_zi = Cint(ndims(zi))
        end
        st_zi = filter_test_struct(pointer(data_zi), pointer(size_zi), allocatedSize_zi, numDimensions_zi, canFreeData)
    end

    ############# y封装 #############
    data_y = Array{Cdouble}(undef, size(x))
    if isa(data_y, Vector)
        size_y = Vector{Cint}([size(x, 1), 1]) ## 分配内存
    else
        size_y = Cint.(collect(size(x)))
        # sizey = size(x)
        # sizely = length(sizey)
        # size_y = ones(Cint, sizely)
        # for i = 1:sizely
        #     size_y[i] = sizey[i]
        # end
        if size_y[1] == 1
            size_y = reverse(size_y)
        end
        # size_y = reverse(size_y)
        # size_res = Vector{Cint}([length(x), 1])
    end
    allocatedSize_y = length(data_y) * sizeof(Cdouble)
    if isa(x, Vector)
        numDimensions_y = Cint(2)
    else
        numDimensions_y = Cint(ndims(data_y))
    end
    st_y = filter_test_struct(pointer(data_y), pointer(size_y), allocatedSize_y, numDimensions_y, canFreeData)
    ############# zf封装 #############
    sizezf = size(x)
    # sizezf[1] = max(length(a), length(b)) - 1
    if isa(x, Vector)
        data_zf = Vector{Cdouble}(undef, max(length(a), length(b)) - 1)
        size_zf = Vector{Cint}([max(length(a), length(b)) - 1, 1])
    else
        # data_zf = Array{Vector{Cdouble}(undef, max(length(a), length(b)) - 1)}(undef, size(x, 2))  ### 列向量数组？
        data_zf = Array{Cdouble}(undef, max(length(a), length(b)) - 1)
        data_zf_tmp = copy(data_zf)
        for i = 1:size(x, 2)-1
            data_zf = hcat(data_zf, data_zf_tmp)
        end
        size_zf = collect(size(data_zf))
        # size_zf = ones(Cint, length(size(data_zf)))
        # for i = 1:length(size_zf)
        #     size_zf[i] = sizezf[i]
        # end
        # size_zf[1] = max(length(a), length(b)) - 1
    end

    allocatedSize_zf = length(data_zf) * sizeof(Cdouble)
    if isa(data_zf, Vector)
        numDimensions_zf = 2
    else
        numDimensions_zf = Cint(ndims(data_zf))
    end
    st_zf = filter_test_struct(pointer(data_zf), pointer(size_zf), allocatedSize_zf, numDimensions_zf, canFreeData)



    # ccall((:filter1, "TyMath/filter/filter1.so"), Cvoid, (Ref{filter_test_struct}, Ref{filter_test_struct}, Ref{filter_test_struct}, Ref{filter_test_struct}, Ref{filter_test_struct}), st_b, st_a, st_x, st_y, st_zf)

    ccall((:julia_filter_2out4in, julia_filter_2out5in), Cvoid, (Ref{filter_test_struct}, Ref{filter_test_struct}, Ref{filter_test_struct}, Ref{filter_test_struct}, Ref{filter_test_struct}, Ref{filter_test_struct}), st_b, st_a, st_x, st_zi, st_y, st_zf)

    return data_zf
end