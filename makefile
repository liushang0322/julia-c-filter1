CC       = gcc 
CFLAGS   = -Wall -g -O -fPIC 

INCLUDE  = -I ./inc -I ../comm/inc
TARGET   = libspline.so

vpath %.h ./inc

SRCS     = bearch.c julia_spline.c julia_spline_data.c julia_spline_emxAPI.c julia_spline_emxutil.c julia_spline_initialize.c julia_spline_terminate.c ppval.c rtGetInf.c rtGetNaN.c rt_nonfinite.c 

$(OBJS):$(SRCS)
14    $(CC) $(CFLAGS) $(INCLUDE) -c $^

all:$(OBJS)
   $(CC) -shared -fPIC -o $(TARGET) $(OBJS)  
    mv $(TARGET) $(LIBPATH)
	
clean:
	rm -f *.o
	rm -f $(LIBPATH)*