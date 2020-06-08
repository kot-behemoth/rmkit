#ifndef FB_CPY
#include <fcntl.h>
#include <string.h>
#include <unistd.h>
#include <sys/mman.h>
#include <sys/ioctl.h>

// for parsing virtual_size of framebuffer
#include <fstream>
#include <iostream>

#include "defines.h"
#include "mxcfb.h"
#include "text.h"

using namespace std

class FBRect:
  public:
  int x0, y0, x1, y1

typedef struct rect rect

void do_nothing(int x, y):
  pass

#define remarkable_color uint16_t

class FB:
  private:

  public:
  int width, height, fd
  int byte_size, dirty
  int update_marker = 1
  remarkable_color* fbmem
  FBRect dirty_area

  FB():
    width, height = self.get_size()
    self.width = width
    self.height = height

    printf("W: %i H: %i\n", width, height)
    size = width*height*sizeof(remarkable_color)
    self.byte_size = size

    #ifndef DEV
    self.fd = open("/dev/fb0", O_RDWR)
    fbmem = (remarkable_color*) mmap(NULL, size, PROT_WRITE, MAP_SHARED, self.fd, 0)

    auto_update_mode = AUTO_UPDATE_MODE_AUTOMATIC_MODE
    ioctl(self.fd, MXCFB_SET_AUTO_UPDATE_MODE, &auto_update_mode);

    fb_var_screeninfo vinfo;
    if (ioctl(self.fd, FBIOGET_VSCREENINFO, &vinfo)):
      printf("Could not get screen vinfo for %s\n", "/dev/fb0")
      return

    print "XRES", vinfo.xres, "YRES", vinfo.yres, "BPP", vinfo.bits_per_pixel




    #else
    // make an empty file of the right size
    std::ofstream ofs("fb.raw", std::ios::binary | std::ios::out);
    ofs.seekp(size);
    ofs.write("", 1);
    ofs.close()

    self.fd = open("./fb.raw", O_RDWR)
    fbmem = (remarkable_color*) mmap(NULL, size, PROT_WRITE, MAP_SHARED, self.fd, 0)
    #endif
    return

  FB(const FB &copy):
    printf("COPY CONSTRUCTOR CALLED\n")
    throw

  ~FB():
    close(self.fd)

  def wait_for_redraw(uint32_t update_marker):
    #ifdef REMARKABLE
    mxcfb_update_marker_data mdata = { update_marker, 0 }
    ioctl(self.fd, MXCFB_WAIT_FOR_UPDATE_COMPLETE, &mdata)
    #endif
    return


  def redraw_screen(bool full_screen=false, wait_for_refresh=false):
    if dirty == 0:
      return 0

    dirty = 0
    um = 0

    if dirty_area.y1 == 0 || dirty_area.x1 == 0:
      return 0

    #ifdef DEV
    msync(self.fbmem, self.byte_size, MS_SYNC)
    self.save_pnm()
    #endif

    #ifdef REMARKABLE
    mxcfb_update_data update_data
    mxcfb_rect update_rect

    if !full_screen:
      update_rect.top = dirty_area.y0
      update_rect.left = dirty_area.x0
      update_rect.width = dirty_area.x1 - dirty_area.x0
      update_rect.height = dirty_area.y1 - dirty_area.y0
    else:
      update_rect.top = 0
      update_rect.left = 0
      update_rect.width = DISPLAYWIDTH
      update_rect.height = DISPLAYHEIGHT

    update_data.update_region = update_rect
    update_data.waveform_mode = WAVEFORM_MODE_DU
    update_data.update_mode = UPDATE_MODE_PARTIAL
    update_data.dither_mode = EPDC_FLAG_EXP1
    update_data.temp = TEMP_USE_REMARKABLE_DRAW
    update_data.flags = 0

    update_data.update_marker = 0
    if wait_for_refresh:
      update_data.update_marker = self.update_marker++

    ioctl(self.fd, MXCFB_SEND_UPDATE, &update_data)
    um = update_data.update_marker

    self.reset_dirty()
    #endif
    return um

  def redraw_if_dirty():
    if self.dirty:
      self.redraw_screen()

  tuple<int,int> get_size():
    size_f = ifstream("/sys/class/graphics/fb0/virtual_size")
    string width_s, height_s
    char delim = ',';
    getline(size_f, width_s, delim)
    getline(size_f, height_s, delim)

    width = stoi(width_s)
    height = stoi(height_s)

    f = 1
    #ifdef REMARKABLE
    #endif

    return width/f, height/f

  inline void update_dirty(int x, y):
    dirty_area.x0 = min(x, dirty_area.x0)
    dirty_area.y0 = min(y, dirty_area.y0)
    dirty_area.x0 = max(0, dirty_area.x0)
    dirty_area.y0 = max(0, dirty_area.y0)
    dirty_area.x1 = max(dirty_area.x1, x)
    dirty_area.y1 = max(dirty_area.y1, y)
    dirty_area.x1 = min(dirty_area.x1, int(DISPLAYWIDTH)-1)
    dirty_area.y1 = min(dirty_area.y1, int(DISPLAYHEIGHT)-1)

  void reset_dirty():
    dirty_area.x0 = DISPLAYWIDTH
    dirty_area.y0 = DISPLAYHEIGHT
    dirty_area.x1 = 0
    dirty_area.y1 = 0

  inline void draw_rect(int o_x, o_y, w, h, color, fill=true):
    self.dirty = 1
    remarkable_color* ptr = self.fbmem
    #ifdef DEBUG_FB
    printf("DRAWING RECT X: %i Y: %i W: %i H: %i, COLOR: %i\n", o_x, o_y, w, h, color)
    #endif

    ptr += (o_x + o_y * self.width)

    update_dirty(o_x, o_y)
    update_dirty(o_x+w, o_y+h)

    for j 0 h:
      if j+o_y >= self.height:
        break

      for i 0 w:
        if i+o_x >= self.width:
          break

        if fill || (j == 0 || i == 0 || j == h-1 || i == w-1):
          ptr[i] = color
      ptr += self.width

  def draw_bitmap(freetype::image_data image, int o_x, int o_y):
    remarkable_color* ptr = self.fbmem
    ptr += (o_x + o_y * self.width)
    src = image.buffer

    update_dirty(o_x, o_y)
    update_dirty(o_x+image.w, o_y+image.h)

    for j 0 image.h:
      for i 0 image.w:
        ptr[i] = (remarkable_color) src[i]
      ptr += self.width
      src += image.w

  def draw_text(string text, int x, int y, freetype::image_data image):
    freetype::render_text((char*)text.c_str(), x, y, image)
    draw_bitmap(image, x, y)

  void save_pnm():
    // save the buffer to pnm format
    fd = open("fb.pnm", O_CREAT|O_RDWR, 0755)
    lseek(fd, 0, 0)
    char c[100];
    i = sprintf(c, "P6%d %d\n255\n", self.width, self.height)
    wrote = write(fd, c, i-1)
    if wrote == -1:
      printf("ERROR %i", errno)
    char buf[self.width * self.height * 4]
    ptr = &buf[0]

    for y 0 self.height:
      for x 0 self.width:
        d = (short) self.fbmem[y*self.width + x]
        buf[i++] = (d & 0xf800) >> 8
        buf[i++] = (d & 0x7e0) >> 3
        buf[i++] = (d & 0x1f) << 3
    buf[i] = 0

    wrote = write(fd, buf, i-1)
    if wrote == -1:
      printf("ERROR %i", errno)
    close(fd)

    ret = system("pnmtopng fb.pnm > fb.png 2>/dev/null")

  def draw_line(int x0,y0,x1,y1,width,color):
    #ifdef DEBUG_FB
    printf("DRAWING LINE %i %i %i %i\n", x0, y0, x1, y1)
    #endif
    self.dirty = 1
    dx =  abs(x1-x0)
    sx = x0<x1 ? 1 : -1
    dy = -abs(y1-y0)
    sy = y0<y1 ? 1 : -1
    err = dx+dy  /* error value e_xy */
    while (true):   /* loop */
      self.draw_rect(x0, y0, width, width, color)
      // self.fbmem[y0*self.width + x0] = color
      if (x0==x1 && y0==y1) break;
      e2 = 2*err
      if (e2 >= dy):
        err += dy /* e_xy+e_x > 0 */
        x0 += sx
      if (e2 <= dx): /* e_xy+e_y < 0 */
        err += dx
        y0 += sy

#endif
