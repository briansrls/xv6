
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4 0f                	in     $0xf,%al

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 70 d6 10 80       	mov    $0x8010d670,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 fc 37 10 80       	mov    $0x801037fc,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	c7 44 24 04 14 89 10 	movl   $0x80108914,0x4(%esp)
80100041:	80 
80100042:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
80100049:	e8 f0 4e 00 00       	call   80104f3e <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004e:	c7 05 90 15 11 80 84 	movl   $0x80111584,0x80111590
80100055:	15 11 80 
  bcache.head.next = &bcache.head;
80100058:	c7 05 94 15 11 80 84 	movl   $0x80111584,0x80111594
8010005f:	15 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100062:	c7 45 f4 b4 d6 10 80 	movl   $0x8010d6b4,-0xc(%ebp)
80100069:	eb 3a                	jmp    801000a5 <binit+0x71>
    b->next = bcache.head.next;
8010006b:	8b 15 94 15 11 80    	mov    0x80111594,%edx
80100071:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100074:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100077:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007a:	c7 40 0c 84 15 11 80 	movl   $0x80111584,0xc(%eax)
    b->dev = -1;
80100081:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100084:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008b:	a1 94 15 11 80       	mov    0x80111594,%eax
80100090:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100093:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100096:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100099:	a3 94 15 11 80       	mov    %eax,0x80111594

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009e:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a5:	b8 84 15 11 80       	mov    $0x80111584,%eax
801000aa:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801000ad:	72 bc                	jb     8010006b <binit+0x37>
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000af:	c9                   	leave  
801000b0:	c3                   	ret    

801000b1 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint blockno)
{
801000b1:	55                   	push   %ebp
801000b2:	89 e5                	mov    %esp,%ebp
801000b4:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000b7:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
801000be:	e8 9c 4e 00 00       	call   80104f5f <acquire>

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c3:	a1 94 15 11 80       	mov    0x80111594,%eax
801000c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000cb:	eb 63                	jmp    80100130 <bget+0x7f>
    if(b->dev == dev && b->blockno == blockno){
801000cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000d0:	8b 40 04             	mov    0x4(%eax),%eax
801000d3:	3b 45 08             	cmp    0x8(%ebp),%eax
801000d6:	75 4f                	jne    80100127 <bget+0x76>
801000d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000db:	8b 40 08             	mov    0x8(%eax),%eax
801000de:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000e1:	75 44                	jne    80100127 <bget+0x76>
      if(!(b->flags & B_BUSY)){
801000e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e6:	8b 00                	mov    (%eax),%eax
801000e8:	83 e0 01             	and    $0x1,%eax
801000eb:	85 c0                	test   %eax,%eax
801000ed:	75 23                	jne    80100112 <bget+0x61>
        b->flags |= B_BUSY;
801000ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f2:	8b 00                	mov    (%eax),%eax
801000f4:	89 c2                	mov    %eax,%edx
801000f6:	83 ca 01             	or     $0x1,%edx
801000f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000fc:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
801000fe:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
80100105:	e8 b6 4e 00 00       	call   80104fc0 <release>
        return b;
8010010a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010d:	e9 93 00 00 00       	jmp    801001a5 <bget+0xf4>
      }
      sleep(b, &bcache.lock);
80100112:	c7 44 24 04 80 d6 10 	movl   $0x8010d680,0x4(%esp)
80100119:	80 
8010011a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010011d:	89 04 24             	mov    %eax,(%esp)
80100120:	e8 5f 4b 00 00       	call   80104c84 <sleep>
      goto loop;
80100125:	eb 9c                	jmp    801000c3 <bget+0x12>

  acquire(&bcache.lock);

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100127:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010012a:	8b 40 10             	mov    0x10(%eax),%eax
8010012d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100130:	81 7d f4 84 15 11 80 	cmpl   $0x80111584,-0xc(%ebp)
80100137:	75 94                	jne    801000cd <bget+0x1c>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100139:	a1 90 15 11 80       	mov    0x80111590,%eax
8010013e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100141:	eb 4d                	jmp    80100190 <bget+0xdf>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
80100143:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100146:	8b 00                	mov    (%eax),%eax
80100148:	83 e0 01             	and    $0x1,%eax
8010014b:	85 c0                	test   %eax,%eax
8010014d:	75 38                	jne    80100187 <bget+0xd6>
8010014f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100152:	8b 00                	mov    (%eax),%eax
80100154:	83 e0 04             	and    $0x4,%eax
80100157:	85 c0                	test   %eax,%eax
80100159:	75 2c                	jne    80100187 <bget+0xd6>
      b->dev = dev;
8010015b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015e:	8b 55 08             	mov    0x8(%ebp),%edx
80100161:	89 50 04             	mov    %edx,0x4(%eax)
      b->blockno = blockno;
80100164:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100167:	8b 55 0c             	mov    0xc(%ebp),%edx
8010016a:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
8010016d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100170:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
80100176:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
8010017d:	e8 3e 4e 00 00       	call   80104fc0 <release>
      return b;
80100182:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100185:	eb 1e                	jmp    801001a5 <bget+0xf4>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100187:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010018a:	8b 40 0c             	mov    0xc(%eax),%eax
8010018d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100190:	81 7d f4 84 15 11 80 	cmpl   $0x80111584,-0xc(%ebp)
80100197:	75 aa                	jne    80100143 <bget+0x92>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100199:	c7 04 24 1b 89 10 80 	movl   $0x8010891b,(%esp)
801001a0:	e8 98 03 00 00       	call   8010053d <panic>
}
801001a5:	c9                   	leave  
801001a6:	c3                   	ret    

801001a7 <bread>:

// Return a B_BUSY buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801001a7:	55                   	push   %ebp
801001a8:	89 e5                	mov    %esp,%ebp
801001aa:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  b = bget(dev, blockno);
801001ad:	8b 45 0c             	mov    0xc(%ebp),%eax
801001b0:	89 44 24 04          	mov    %eax,0x4(%esp)
801001b4:	8b 45 08             	mov    0x8(%ebp),%eax
801001b7:	89 04 24             	mov    %eax,(%esp)
801001ba:	e8 f2 fe ff ff       	call   801000b1 <bget>
801001bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID)) {
801001c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001c5:	8b 00                	mov    (%eax),%eax
801001c7:	83 e0 02             	and    $0x2,%eax
801001ca:	85 c0                	test   %eax,%eax
801001cc:	75 0b                	jne    801001d9 <bread+0x32>
    iderw(b);
801001ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d1:	89 04 24             	mov    %eax,(%esp)
801001d4:	e8 a8 26 00 00       	call   80102881 <iderw>
  }
  return b;
801001d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001dc:	c9                   	leave  
801001dd:	c3                   	ret    

801001de <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001de:	55                   	push   %ebp
801001df:	89 e5                	mov    %esp,%ebp
801001e1:	83 ec 18             	sub    $0x18,%esp
  if((b->flags & B_BUSY) == 0)
801001e4:	8b 45 08             	mov    0x8(%ebp),%eax
801001e7:	8b 00                	mov    (%eax),%eax
801001e9:	83 e0 01             	and    $0x1,%eax
801001ec:	85 c0                	test   %eax,%eax
801001ee:	75 0c                	jne    801001fc <bwrite+0x1e>
    panic("bwrite");
801001f0:	c7 04 24 2c 89 10 80 	movl   $0x8010892c,(%esp)
801001f7:	e8 41 03 00 00       	call   8010053d <panic>
  b->flags |= B_DIRTY;
801001fc:	8b 45 08             	mov    0x8(%ebp),%eax
801001ff:	8b 00                	mov    (%eax),%eax
80100201:	89 c2                	mov    %eax,%edx
80100203:	83 ca 04             	or     $0x4,%edx
80100206:	8b 45 08             	mov    0x8(%ebp),%eax
80100209:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010020b:	8b 45 08             	mov    0x8(%ebp),%eax
8010020e:	89 04 24             	mov    %eax,(%esp)
80100211:	e8 6b 26 00 00       	call   80102881 <iderw>
}
80100216:	c9                   	leave  
80100217:	c3                   	ret    

80100218 <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
80100218:	55                   	push   %ebp
80100219:	89 e5                	mov    %esp,%ebp
8010021b:	83 ec 18             	sub    $0x18,%esp
  if((b->flags & B_BUSY) == 0)
8010021e:	8b 45 08             	mov    0x8(%ebp),%eax
80100221:	8b 00                	mov    (%eax),%eax
80100223:	83 e0 01             	and    $0x1,%eax
80100226:	85 c0                	test   %eax,%eax
80100228:	75 0c                	jne    80100236 <brelse+0x1e>
    panic("brelse");
8010022a:	c7 04 24 33 89 10 80 	movl   $0x80108933,(%esp)
80100231:	e8 07 03 00 00       	call   8010053d <panic>

  acquire(&bcache.lock);
80100236:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
8010023d:	e8 1d 4d 00 00       	call   80104f5f <acquire>

  b->next->prev = b->prev;
80100242:	8b 45 08             	mov    0x8(%ebp),%eax
80100245:	8b 40 10             	mov    0x10(%eax),%eax
80100248:	8b 55 08             	mov    0x8(%ebp),%edx
8010024b:	8b 52 0c             	mov    0xc(%edx),%edx
8010024e:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
80100251:	8b 45 08             	mov    0x8(%ebp),%eax
80100254:	8b 40 0c             	mov    0xc(%eax),%eax
80100257:	8b 55 08             	mov    0x8(%ebp),%edx
8010025a:	8b 52 10             	mov    0x10(%edx),%edx
8010025d:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
80100260:	8b 15 94 15 11 80    	mov    0x80111594,%edx
80100266:	8b 45 08             	mov    0x8(%ebp),%eax
80100269:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
8010026c:	8b 45 08             	mov    0x8(%ebp),%eax
8010026f:	c7 40 0c 84 15 11 80 	movl   $0x80111584,0xc(%eax)
  bcache.head.next->prev = b;
80100276:	a1 94 15 11 80       	mov    0x80111594,%eax
8010027b:	8b 55 08             	mov    0x8(%ebp),%edx
8010027e:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
80100281:	8b 45 08             	mov    0x8(%ebp),%eax
80100284:	a3 94 15 11 80       	mov    %eax,0x80111594

  b->flags &= ~B_BUSY;
80100289:	8b 45 08             	mov    0x8(%ebp),%eax
8010028c:	8b 00                	mov    (%eax),%eax
8010028e:	89 c2                	mov    %eax,%edx
80100290:	83 e2 fe             	and    $0xfffffffe,%edx
80100293:	8b 45 08             	mov    0x8(%ebp),%eax
80100296:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80100298:	8b 45 08             	mov    0x8(%ebp),%eax
8010029b:	89 04 24             	mov    %eax,(%esp)
8010029e:	e8 be 4a 00 00       	call   80104d61 <wakeup>

  release(&bcache.lock);
801002a3:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
801002aa:	e8 11 4d 00 00       	call   80104fc0 <release>
}
801002af:	c9                   	leave  
801002b0:	c3                   	ret    
801002b1:	00 00                	add    %al,(%eax)
	...

801002b4 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801002b4:	55                   	push   %ebp
801002b5:	89 e5                	mov    %esp,%ebp
801002b7:	83 ec 14             	sub    $0x14,%esp
801002ba:	8b 45 08             	mov    0x8(%ebp),%eax
801002bd:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002c1:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801002c5:	89 c2                	mov    %eax,%edx
801002c7:	ec                   	in     (%dx),%al
801002c8:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801002cb:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801002cf:	c9                   	leave  
801002d0:	c3                   	ret    

801002d1 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002d1:	55                   	push   %ebp
801002d2:	89 e5                	mov    %esp,%ebp
801002d4:	83 ec 08             	sub    $0x8,%esp
801002d7:	8b 55 08             	mov    0x8(%ebp),%edx
801002da:	8b 45 0c             	mov    0xc(%ebp),%eax
801002dd:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801002e1:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801002e4:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801002e8:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801002ec:	ee                   	out    %al,(%dx)
}
801002ed:	c9                   	leave  
801002ee:	c3                   	ret    

801002ef <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
801002ef:	55                   	push   %ebp
801002f0:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
801002f2:	fa                   	cli    
}
801002f3:	5d                   	pop    %ebp
801002f4:	c3                   	ret    

801002f5 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
801002f5:	55                   	push   %ebp
801002f6:	89 e5                	mov    %esp,%ebp
801002f8:	53                   	push   %ebx
801002f9:	83 ec 44             	sub    $0x44,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
801002fc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100300:	74 19                	je     8010031b <printint+0x26>
80100302:	8b 45 08             	mov    0x8(%ebp),%eax
80100305:	c1 e8 1f             	shr    $0x1f,%eax
80100308:	89 45 10             	mov    %eax,0x10(%ebp)
8010030b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010030f:	74 0a                	je     8010031b <printint+0x26>
    x = -xx;
80100311:	8b 45 08             	mov    0x8(%ebp),%eax
80100314:	f7 d8                	neg    %eax
80100316:	89 45 f4             	mov    %eax,-0xc(%ebp)
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100319:	eb 06                	jmp    80100321 <printint+0x2c>
    x = -xx;
  else
    x = xx;
8010031b:	8b 45 08             	mov    0x8(%ebp),%eax
8010031e:	89 45 f4             	mov    %eax,-0xc(%ebp)

  i = 0;
80100321:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  do{
    buf[i++] = digits[x % base];
80100328:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010032b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010032e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100331:	ba 00 00 00 00       	mov    $0x0,%edx
80100336:	f7 f3                	div    %ebx
80100338:	89 d0                	mov    %edx,%eax
8010033a:	0f b6 80 04 a0 10 80 	movzbl -0x7fef5ffc(%eax),%eax
80100341:	88 44 0d e0          	mov    %al,-0x20(%ebp,%ecx,1)
80100345:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  }while((x /= base) != 0);
80100349:	8b 45 0c             	mov    0xc(%ebp),%eax
8010034c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
8010034f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100352:	ba 00 00 00 00       	mov    $0x0,%edx
80100357:	f7 75 d4             	divl   -0x2c(%ebp)
8010035a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010035d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100361:	75 c5                	jne    80100328 <printint+0x33>

  if(sign)
80100363:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100367:	74 23                	je     8010038c <printint+0x97>
    buf[i++] = '-';
80100369:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010036c:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)
80100371:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)

  while(--i >= 0)
80100375:	eb 16                	jmp    8010038d <printint+0x98>
    consputc(buf[i]);
80100377:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010037a:	0f b6 44 05 e0       	movzbl -0x20(%ebp,%eax,1),%eax
8010037f:	0f be c0             	movsbl %al,%eax
80100382:	89 04 24             	mov    %eax,(%esp)
80100385:	e8 e2 03 00 00       	call   8010076c <consputc>
8010038a:	eb 01                	jmp    8010038d <printint+0x98>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
8010038c:	90                   	nop
8010038d:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
80100391:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100395:	79 e0                	jns    80100377 <printint+0x82>
    consputc(buf[i]);
}
80100397:	83 c4 44             	add    $0x44,%esp
8010039a:	5b                   	pop    %ebx
8010039b:	5d                   	pop    %ebp
8010039c:	c3                   	ret    

8010039d <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
8010039d:	55                   	push   %ebp
8010039e:	89 e5                	mov    %esp,%ebp
801003a0:	83 ec 38             	sub    $0x38,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003a3:	a1 14 c6 10 80       	mov    0x8010c614,%eax
801003a8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(locking)
801003ab:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801003af:	74 0c                	je     801003bd <cprintf+0x20>
    acquire(&cons.lock);
801003b1:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
801003b8:	e8 a2 4b 00 00       	call   80104f5f <acquire>

  if (fmt == 0)
801003bd:	8b 45 08             	mov    0x8(%ebp),%eax
801003c0:	85 c0                	test   %eax,%eax
801003c2:	75 0c                	jne    801003d0 <cprintf+0x33>
    panic("null fmt");
801003c4:	c7 04 24 3a 89 10 80 	movl   $0x8010893a,(%esp)
801003cb:	e8 6d 01 00 00       	call   8010053d <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003d0:	8d 45 08             	lea    0x8(%ebp),%eax
801003d3:	83 c0 04             	add    $0x4,%eax
801003d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801003d9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801003e0:	e9 20 01 00 00       	jmp    80100505 <cprintf+0x168>
    if(c != '%'){
801003e5:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
801003e9:	74 10                	je     801003fb <cprintf+0x5e>
      consputc(c);
801003eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
801003ee:	89 04 24             	mov    %eax,(%esp)
801003f1:	e8 76 03 00 00       	call   8010076c <consputc>
      continue;
801003f6:	e9 06 01 00 00       	jmp    80100501 <cprintf+0x164>
    }
    c = fmt[++i] & 0xff;
801003fb:	8b 55 08             	mov    0x8(%ebp),%edx
801003fe:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100402:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100405:	8d 04 02             	lea    (%edx,%eax,1),%eax
80100408:	0f b6 00             	movzbl (%eax),%eax
8010040b:	0f be c0             	movsbl %al,%eax
8010040e:	25 ff 00 00 00       	and    $0xff,%eax
80100413:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(c == 0)
80100416:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010041a:	0f 84 08 01 00 00    	je     80100528 <cprintf+0x18b>
      break;
    switch(c){
80100420:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100423:	83 f8 70             	cmp    $0x70,%eax
80100426:	74 4d                	je     80100475 <cprintf+0xd8>
80100428:	83 f8 70             	cmp    $0x70,%eax
8010042b:	7f 13                	jg     80100440 <cprintf+0xa3>
8010042d:	83 f8 25             	cmp    $0x25,%eax
80100430:	0f 84 a6 00 00 00    	je     801004dc <cprintf+0x13f>
80100436:	83 f8 64             	cmp    $0x64,%eax
80100439:	74 14                	je     8010044f <cprintf+0xb2>
8010043b:	e9 aa 00 00 00       	jmp    801004ea <cprintf+0x14d>
80100440:	83 f8 73             	cmp    $0x73,%eax
80100443:	74 53                	je     80100498 <cprintf+0xfb>
80100445:	83 f8 78             	cmp    $0x78,%eax
80100448:	74 2b                	je     80100475 <cprintf+0xd8>
8010044a:	e9 9b 00 00 00       	jmp    801004ea <cprintf+0x14d>
    case 'd':
      printint(*argp++, 10, 1);
8010044f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100452:	8b 00                	mov    (%eax),%eax
80100454:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
80100458:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
8010045f:	00 
80100460:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80100467:	00 
80100468:	89 04 24             	mov    %eax,(%esp)
8010046b:	e8 85 fe ff ff       	call   801002f5 <printint>
      break;
80100470:	e9 8c 00 00 00       	jmp    80100501 <cprintf+0x164>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
80100475:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100478:	8b 00                	mov    (%eax),%eax
8010047a:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
8010047e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100485:	00 
80100486:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
8010048d:	00 
8010048e:	89 04 24             	mov    %eax,(%esp)
80100491:	e8 5f fe ff ff       	call   801002f5 <printint>
      break;
80100496:	eb 69                	jmp    80100501 <cprintf+0x164>
    case 's':
      if((s = (char*)*argp++) == 0)
80100498:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010049b:	8b 00                	mov    (%eax),%eax
8010049d:	89 45 f4             	mov    %eax,-0xc(%ebp)
801004a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801004a4:	0f 94 c0             	sete   %al
801004a7:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
801004ab:	84 c0                	test   %al,%al
801004ad:	74 20                	je     801004cf <cprintf+0x132>
        s = "(null)";
801004af:	c7 45 f4 43 89 10 80 	movl   $0x80108943,-0xc(%ebp)
      for(; *s; s++)
801004b6:	eb 18                	jmp    801004d0 <cprintf+0x133>
        consputc(*s);
801004b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801004bb:	0f b6 00             	movzbl (%eax),%eax
801004be:	0f be c0             	movsbl %al,%eax
801004c1:	89 04 24             	mov    %eax,(%esp)
801004c4:	e8 a3 02 00 00       	call   8010076c <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801004c9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801004cd:	eb 01                	jmp    801004d0 <cprintf+0x133>
801004cf:	90                   	nop
801004d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801004d3:	0f b6 00             	movzbl (%eax),%eax
801004d6:	84 c0                	test   %al,%al
801004d8:	75 de                	jne    801004b8 <cprintf+0x11b>
        consputc(*s);
      break;
801004da:	eb 25                	jmp    80100501 <cprintf+0x164>
    case '%':
      consputc('%');
801004dc:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004e3:	e8 84 02 00 00       	call   8010076c <consputc>
      break;
801004e8:	eb 17                	jmp    80100501 <cprintf+0x164>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
801004ea:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004f1:	e8 76 02 00 00       	call   8010076c <consputc>
      consputc(c);
801004f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
801004f9:	89 04 24             	mov    %eax,(%esp)
801004fc:	e8 6b 02 00 00       	call   8010076c <consputc>

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100501:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100505:	8b 55 08             	mov    0x8(%ebp),%edx
80100508:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010050b:	8d 04 02             	lea    (%edx,%eax,1),%eax
8010050e:	0f b6 00             	movzbl (%eax),%eax
80100511:	0f be c0             	movsbl %al,%eax
80100514:	25 ff 00 00 00       	and    $0xff,%eax
80100519:	89 45 e8             	mov    %eax,-0x18(%ebp)
8010051c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100520:	0f 85 bf fe ff ff    	jne    801003e5 <cprintf+0x48>
80100526:	eb 01                	jmp    80100529 <cprintf+0x18c>
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
80100528:	90                   	nop
      consputc(c);
      break;
    }
  }

  if(locking)
80100529:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010052d:	74 0c                	je     8010053b <cprintf+0x19e>
    release(&cons.lock);
8010052f:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100536:	e8 85 4a 00 00       	call   80104fc0 <release>
}
8010053b:	c9                   	leave  
8010053c:	c3                   	ret    

8010053d <panic>:

void
panic(char *s)
{
8010053d:	55                   	push   %ebp
8010053e:	89 e5                	mov    %esp,%ebp
80100540:	83 ec 48             	sub    $0x48,%esp
  int i;
  uint pcs[10];
  
  cli();
80100543:	e8 a7 fd ff ff       	call   801002ef <cli>
  cons.locking = 0;
80100548:	c7 05 14 c6 10 80 00 	movl   $0x0,0x8010c614
8010054f:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
80100552:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100558:	0f b6 00             	movzbl (%eax),%eax
8010055b:	0f b6 c0             	movzbl %al,%eax
8010055e:	89 44 24 04          	mov    %eax,0x4(%esp)
80100562:	c7 04 24 4a 89 10 80 	movl   $0x8010894a,(%esp)
80100569:	e8 2f fe ff ff       	call   8010039d <cprintf>
  cprintf(s);
8010056e:	8b 45 08             	mov    0x8(%ebp),%eax
80100571:	89 04 24             	mov    %eax,(%esp)
80100574:	e8 24 fe ff ff       	call   8010039d <cprintf>
  cprintf("\n");
80100579:	c7 04 24 59 89 10 80 	movl   $0x80108959,(%esp)
80100580:	e8 18 fe ff ff       	call   8010039d <cprintf>
  getcallerpcs(&s, pcs);
80100585:	8d 45 cc             	lea    -0x34(%ebp),%eax
80100588:	89 44 24 04          	mov    %eax,0x4(%esp)
8010058c:	8d 45 08             	lea    0x8(%ebp),%eax
8010058f:	89 04 24             	mov    %eax,(%esp)
80100592:	e8 78 4a 00 00       	call   8010500f <getcallerpcs>
  for(i=0; i<10; i++)
80100597:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010059e:	eb 1b                	jmp    801005bb <panic+0x7e>
    cprintf(" %p", pcs[i]);
801005a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005a3:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005a7:	89 44 24 04          	mov    %eax,0x4(%esp)
801005ab:	c7 04 24 5b 89 10 80 	movl   $0x8010895b,(%esp)
801005b2:	e8 e6 fd ff ff       	call   8010039d <cprintf>
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801005b7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801005bb:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005bf:	7e df                	jle    801005a0 <panic+0x63>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801005c1:	c7 05 c0 c5 10 80 01 	movl   $0x1,0x8010c5c0
801005c8:	00 00 00 
  for(;;)
    ;
801005cb:	eb fe                	jmp    801005cb <panic+0x8e>

801005cd <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
801005cd:	55                   	push   %ebp
801005ce:	89 e5                	mov    %esp,%ebp
801005d0:	83 ec 28             	sub    $0x28,%esp
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
801005d3:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801005da:	00 
801005db:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
801005e2:	e8 ea fc ff ff       	call   801002d1 <outb>
  pos = inb(CRTPORT+1) << 8;
801005e7:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
801005ee:	e8 c1 fc ff ff       	call   801002b4 <inb>
801005f3:	0f b6 c0             	movzbl %al,%eax
801005f6:	c1 e0 08             	shl    $0x8,%eax
801005f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
801005fc:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80100603:	00 
80100604:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
8010060b:	e8 c1 fc ff ff       	call   801002d1 <outb>
  pos |= inb(CRTPORT+1);
80100610:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100617:	e8 98 fc ff ff       	call   801002b4 <inb>
8010061c:	0f b6 c0             	movzbl %al,%eax
8010061f:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
80100622:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100626:	75 30                	jne    80100658 <cgaputc+0x8b>
    pos += 80 - pos%80;
80100628:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010062b:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100630:	89 c8                	mov    %ecx,%eax
80100632:	f7 ea                	imul   %edx
80100634:	c1 fa 05             	sar    $0x5,%edx
80100637:	89 c8                	mov    %ecx,%eax
80100639:	c1 f8 1f             	sar    $0x1f,%eax
8010063c:	29 c2                	sub    %eax,%edx
8010063e:	89 d0                	mov    %edx,%eax
80100640:	c1 e0 02             	shl    $0x2,%eax
80100643:	01 d0                	add    %edx,%eax
80100645:	c1 e0 04             	shl    $0x4,%eax
80100648:	89 ca                	mov    %ecx,%edx
8010064a:	29 c2                	sub    %eax,%edx
8010064c:	b8 50 00 00 00       	mov    $0x50,%eax
80100651:	29 d0                	sub    %edx,%eax
80100653:	01 45 f4             	add    %eax,-0xc(%ebp)
80100656:	eb 33                	jmp    8010068b <cgaputc+0xbe>
  else if(c == BACKSPACE){
80100658:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010065f:	75 0c                	jne    8010066d <cgaputc+0xa0>
    if(pos > 0) --pos;
80100661:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100665:	7e 24                	jle    8010068b <cgaputc+0xbe>
80100667:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
8010066b:	eb 1e                	jmp    8010068b <cgaputc+0xbe>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010066d:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80100672:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100675:	01 d2                	add    %edx,%edx
80100677:	8d 14 10             	lea    (%eax,%edx,1),%edx
8010067a:	8b 45 08             	mov    0x8(%ebp),%eax
8010067d:	66 25 ff 00          	and    $0xff,%ax
80100681:	80 cc 07             	or     $0x7,%ah
80100684:	66 89 02             	mov    %ax,(%edx)
80100687:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  if(pos < 0 || pos > 25*80)
8010068b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010068f:	78 09                	js     8010069a <cgaputc+0xcd>
80100691:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
80100698:	7e 0c                	jle    801006a6 <cgaputc+0xd9>
    panic("pos under/overflow");
8010069a:	c7 04 24 5f 89 10 80 	movl   $0x8010895f,(%esp)
801006a1:	e8 97 fe ff ff       	call   8010053d <panic>
  
  if((pos/80) >= 24){  // Scroll up.
801006a6:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
801006ad:	7e 53                	jle    80100702 <cgaputc+0x135>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801006af:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006b4:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
801006ba:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006bf:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801006c6:	00 
801006c7:	89 54 24 04          	mov    %edx,0x4(%esp)
801006cb:	89 04 24             	mov    %eax,(%esp)
801006ce:	e8 b6 4b 00 00       	call   80105289 <memmove>
    pos -= 80;
801006d3:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801006d7:	b8 80 07 00 00       	mov    $0x780,%eax
801006dc:	2b 45 f4             	sub    -0xc(%ebp),%eax
801006df:	8d 14 00             	lea    (%eax,%eax,1),%edx
801006e2:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006e7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801006ea:	01 c9                	add    %ecx,%ecx
801006ec:	01 c8                	add    %ecx,%eax
801006ee:	89 54 24 08          	mov    %edx,0x8(%esp)
801006f2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801006f9:	00 
801006fa:	89 04 24             	mov    %eax,(%esp)
801006fd:	e8 b4 4a 00 00       	call   801051b6 <memset>
  }
  
  outb(CRTPORT, 14);
80100702:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
80100709:	00 
8010070a:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100711:	e8 bb fb ff ff       	call   801002d1 <outb>
  outb(CRTPORT+1, pos>>8);
80100716:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100719:	c1 f8 08             	sar    $0x8,%eax
8010071c:	0f b6 c0             	movzbl %al,%eax
8010071f:	89 44 24 04          	mov    %eax,0x4(%esp)
80100723:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
8010072a:	e8 a2 fb ff ff       	call   801002d1 <outb>
  outb(CRTPORT, 15);
8010072f:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80100736:	00 
80100737:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
8010073e:	e8 8e fb ff ff       	call   801002d1 <outb>
  outb(CRTPORT+1, pos);
80100743:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100746:	0f b6 c0             	movzbl %al,%eax
80100749:	89 44 24 04          	mov    %eax,0x4(%esp)
8010074d:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100754:	e8 78 fb ff ff       	call   801002d1 <outb>
  crt[pos] = ' ' | 0x0700;
80100759:	a1 00 a0 10 80       	mov    0x8010a000,%eax
8010075e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100761:	01 d2                	add    %edx,%edx
80100763:	01 d0                	add    %edx,%eax
80100765:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
8010076a:	c9                   	leave  
8010076b:	c3                   	ret    

8010076c <consputc>:

void
consputc(int c)
{
8010076c:	55                   	push   %ebp
8010076d:	89 e5                	mov    %esp,%ebp
8010076f:	83 ec 18             	sub    $0x18,%esp
  if(panicked){
80100772:	a1 c0 c5 10 80       	mov    0x8010c5c0,%eax
80100777:	85 c0                	test   %eax,%eax
80100779:	74 07                	je     80100782 <consputc+0x16>
    cli();
8010077b:	e8 6f fb ff ff       	call   801002ef <cli>
    for(;;)
      ;
80100780:	eb fe                	jmp    80100780 <consputc+0x14>
  }

  if(c == BACKSPACE){
80100782:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
80100789:	75 26                	jne    801007b1 <consputc+0x45>
    uartputc('\b'); uartputc(' '); uartputc('\b');
8010078b:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100792:	e8 cd 67 00 00       	call   80106f64 <uartputc>
80100797:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
8010079e:	e8 c1 67 00 00       	call   80106f64 <uartputc>
801007a3:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801007aa:	e8 b5 67 00 00       	call   80106f64 <uartputc>
801007af:	eb 0b                	jmp    801007bc <consputc+0x50>
  } else
    uartputc(c);
801007b1:	8b 45 08             	mov    0x8(%ebp),%eax
801007b4:	89 04 24             	mov    %eax,(%esp)
801007b7:	e8 a8 67 00 00       	call   80106f64 <uartputc>
  cgaputc(c);
801007bc:	8b 45 08             	mov    0x8(%ebp),%eax
801007bf:	89 04 24             	mov    %eax,(%esp)
801007c2:	e8 06 fe ff ff       	call   801005cd <cgaputc>
}
801007c7:	c9                   	leave  
801007c8:	c3                   	ret    

801007c9 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007c9:	55                   	push   %ebp
801007ca:	89 e5                	mov    %esp,%ebp
801007cc:	83 ec 28             	sub    $0x28,%esp
  int c, doprocdump = 0;
801007cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&cons.lock);
801007d6:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
801007dd:	e8 7d 47 00 00       	call   80104f5f <acquire>
  while((c = getc()) >= 0){
801007e2:	e9 40 01 00 00       	jmp    80100927 <consoleintr+0x15e>
    switch(c){
801007e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801007ea:	83 f8 10             	cmp    $0x10,%eax
801007ed:	74 1e                	je     8010080d <consoleintr+0x44>
801007ef:	83 f8 10             	cmp    $0x10,%eax
801007f2:	7f 0a                	jg     801007fe <consoleintr+0x35>
801007f4:	83 f8 08             	cmp    $0x8,%eax
801007f7:	74 6a                	je     80100863 <consoleintr+0x9a>
801007f9:	e9 96 00 00 00       	jmp    80100894 <consoleintr+0xcb>
801007fe:	83 f8 15             	cmp    $0x15,%eax
80100801:	74 31                	je     80100834 <consoleintr+0x6b>
80100803:	83 f8 7f             	cmp    $0x7f,%eax
80100806:	74 5b                	je     80100863 <consoleintr+0x9a>
80100808:	e9 87 00 00 00       	jmp    80100894 <consoleintr+0xcb>
    case C('P'):  // Process listing.
      doprocdump = 1;   // procdump() locks cons.lock indirectly; invoke later
8010080d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
      break;
80100814:	e9 0e 01 00 00       	jmp    80100927 <consoleintr+0x15e>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100819:	a1 28 18 11 80       	mov    0x80111828,%eax
8010081e:	83 e8 01             	sub    $0x1,%eax
80100821:	a3 28 18 11 80       	mov    %eax,0x80111828
        consputc(BACKSPACE);
80100826:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
8010082d:	e8 3a ff ff ff       	call   8010076c <consputc>
80100832:	eb 01                	jmp    80100835 <consoleintr+0x6c>
    switch(c){
    case C('P'):  // Process listing.
      doprocdump = 1;   // procdump() locks cons.lock indirectly; invoke later
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100834:	90                   	nop
80100835:	8b 15 28 18 11 80    	mov    0x80111828,%edx
8010083b:	a1 24 18 11 80       	mov    0x80111824,%eax
80100840:	39 c2                	cmp    %eax,%edx
80100842:	0f 84 db 00 00 00    	je     80100923 <consoleintr+0x15a>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100848:	a1 28 18 11 80       	mov    0x80111828,%eax
8010084d:	83 e8 01             	sub    $0x1,%eax
80100850:	83 e0 7f             	and    $0x7f,%eax
80100853:	0f b6 80 a0 17 11 80 	movzbl -0x7feee860(%eax),%eax
    switch(c){
    case C('P'):  // Process listing.
      doprocdump = 1;   // procdump() locks cons.lock indirectly; invoke later
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010085a:	3c 0a                	cmp    $0xa,%al
8010085c:	75 bb                	jne    80100819 <consoleintr+0x50>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
8010085e:	e9 c4 00 00 00       	jmp    80100927 <consoleintr+0x15e>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100863:	8b 15 28 18 11 80    	mov    0x80111828,%edx
80100869:	a1 24 18 11 80       	mov    0x80111824,%eax
8010086e:	39 c2                	cmp    %eax,%edx
80100870:	0f 84 b0 00 00 00    	je     80100926 <consoleintr+0x15d>
        input.e--;
80100876:	a1 28 18 11 80       	mov    0x80111828,%eax
8010087b:	83 e8 01             	sub    $0x1,%eax
8010087e:	a3 28 18 11 80       	mov    %eax,0x80111828
        consputc(BACKSPACE);
80100883:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
8010088a:	e8 dd fe ff ff       	call   8010076c <consputc>
      }
      break;
8010088f:	e9 93 00 00 00       	jmp    80100927 <consoleintr+0x15e>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100894:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100898:	0f 84 89 00 00 00    	je     80100927 <consoleintr+0x15e>
8010089e:	8b 15 28 18 11 80    	mov    0x80111828,%edx
801008a4:	a1 20 18 11 80       	mov    0x80111820,%eax
801008a9:	89 d1                	mov    %edx,%ecx
801008ab:	29 c1                	sub    %eax,%ecx
801008ad:	89 c8                	mov    %ecx,%eax
801008af:	83 f8 7f             	cmp    $0x7f,%eax
801008b2:	77 73                	ja     80100927 <consoleintr+0x15e>
        c = (c == '\r') ? '\n' : c;
801008b4:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801008b8:	74 05                	je     801008bf <consoleintr+0xf6>
801008ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
801008bd:	eb 05                	jmp    801008c4 <consoleintr+0xfb>
801008bf:	b8 0a 00 00 00       	mov    $0xa,%eax
801008c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
801008c7:	a1 28 18 11 80       	mov    0x80111828,%eax
801008cc:	89 c1                	mov    %eax,%ecx
801008ce:	83 e1 7f             	and    $0x7f,%ecx
801008d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
801008d4:	88 91 a0 17 11 80    	mov    %dl,-0x7feee860(%ecx)
801008da:	83 c0 01             	add    $0x1,%eax
801008dd:	a3 28 18 11 80       	mov    %eax,0x80111828
        consputc(c);
801008e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801008e5:	89 04 24             	mov    %eax,(%esp)
801008e8:	e8 7f fe ff ff       	call   8010076c <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008ed:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
801008f1:	74 18                	je     8010090b <consoleintr+0x142>
801008f3:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
801008f7:	74 12                	je     8010090b <consoleintr+0x142>
801008f9:	a1 28 18 11 80       	mov    0x80111828,%eax
801008fe:	8b 15 20 18 11 80    	mov    0x80111820,%edx
80100904:	83 ea 80             	sub    $0xffffff80,%edx
80100907:	39 d0                	cmp    %edx,%eax
80100909:	75 1c                	jne    80100927 <consoleintr+0x15e>
          input.w = input.e;
8010090b:	a1 28 18 11 80       	mov    0x80111828,%eax
80100910:	a3 24 18 11 80       	mov    %eax,0x80111824
          wakeup(&input.r);
80100915:	c7 04 24 20 18 11 80 	movl   $0x80111820,(%esp)
8010091c:	e8 40 44 00 00       	call   80104d61 <wakeup>
80100921:	eb 04                	jmp    80100927 <consoleintr+0x15e>
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
80100923:	90                   	nop
80100924:	eb 01                	jmp    80100927 <consoleintr+0x15e>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
80100926:	90                   	nop
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100927:	8b 45 08             	mov    0x8(%ebp),%eax
8010092a:	ff d0                	call   *%eax
8010092c:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010092f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100933:	0f 89 ae fe ff ff    	jns    801007e7 <consoleintr+0x1e>
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100939:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100940:	e8 7b 46 00 00       	call   80104fc0 <release>
  if(doprocdump) {
80100945:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100949:	74 05                	je     80100950 <consoleintr+0x187>
    procdump();  // now call procdump() wo. cons.lock held
8010094b:	e8 b8 44 00 00       	call   80104e08 <procdump>
  }
}
80100950:	c9                   	leave  
80100951:	c3                   	ret    

80100952 <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
80100952:	55                   	push   %ebp
80100953:	89 e5                	mov    %esp,%ebp
80100955:	83 ec 28             	sub    $0x28,%esp
  uint target;
  int c;

  iunlock(ip);
80100958:	8b 45 08             	mov    0x8(%ebp),%eax
8010095b:	89 04 24             	mov    %eax,(%esp)
8010095e:	e8 f5 10 00 00       	call   80101a58 <iunlock>
  target = n;
80100963:	8b 45 10             	mov    0x10(%ebp),%eax
80100966:	89 45 f0             	mov    %eax,-0x10(%ebp)
  acquire(&cons.lock);
80100969:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100970:	e8 ea 45 00 00       	call   80104f5f <acquire>
  while(n > 0){
80100975:	e9 a8 00 00 00       	jmp    80100a22 <consoleread+0xd0>
    while(input.r == input.w){
      if(proc->killed){
8010097a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100980:	8b 40 24             	mov    0x24(%eax),%eax
80100983:	85 c0                	test   %eax,%eax
80100985:	74 21                	je     801009a8 <consoleread+0x56>
        release(&cons.lock);
80100987:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
8010098e:	e8 2d 46 00 00       	call   80104fc0 <release>
        ilock(ip);
80100993:	8b 45 08             	mov    0x8(%ebp),%eax
80100996:	89 04 24             	mov    %eax,(%esp)
80100999:	e8 63 0f 00 00       	call   80101901 <ilock>
        return -1;
8010099e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801009a3:	e9 a9 00 00 00       	jmp    80100a51 <consoleread+0xff>
      }
      sleep(&input.r, &cons.lock);
801009a8:	c7 44 24 04 e0 c5 10 	movl   $0x8010c5e0,0x4(%esp)
801009af:	80 
801009b0:	c7 04 24 20 18 11 80 	movl   $0x80111820,(%esp)
801009b7:	e8 c8 42 00 00       	call   80104c84 <sleep>
801009bc:	eb 01                	jmp    801009bf <consoleread+0x6d>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
801009be:	90                   	nop
801009bf:	8b 15 20 18 11 80    	mov    0x80111820,%edx
801009c5:	a1 24 18 11 80       	mov    0x80111824,%eax
801009ca:	39 c2                	cmp    %eax,%edx
801009cc:	74 ac                	je     8010097a <consoleread+0x28>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
801009ce:	a1 20 18 11 80       	mov    0x80111820,%eax
801009d3:	89 c2                	mov    %eax,%edx
801009d5:	83 e2 7f             	and    $0x7f,%edx
801009d8:	0f b6 92 a0 17 11 80 	movzbl -0x7feee860(%edx),%edx
801009df:	0f be d2             	movsbl %dl,%edx
801009e2:	89 55 f4             	mov    %edx,-0xc(%ebp)
801009e5:	83 c0 01             	add    $0x1,%eax
801009e8:	a3 20 18 11 80       	mov    %eax,0x80111820
    if(c == C('D')){  // EOF
801009ed:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
801009f1:	75 17                	jne    80100a0a <consoleread+0xb8>
      if(n < target){
801009f3:	8b 45 10             	mov    0x10(%ebp),%eax
801009f6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801009f9:	73 2f                	jae    80100a2a <consoleread+0xd8>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
801009fb:	a1 20 18 11 80       	mov    0x80111820,%eax
80100a00:	83 e8 01             	sub    $0x1,%eax
80100a03:	a3 20 18 11 80       	mov    %eax,0x80111820
      }
      break;
80100a08:	eb 24                	jmp    80100a2e <consoleread+0xdc>
    }
    *dst++ = c;
80100a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100a0d:	89 c2                	mov    %eax,%edx
80100a0f:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a12:	88 10                	mov    %dl,(%eax)
80100a14:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    --n;
80100a18:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
80100a1c:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
80100a20:	74 0b                	je     80100a2d <consoleread+0xdb>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100a22:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100a26:	7f 96                	jg     801009be <consoleread+0x6c>
80100a28:	eb 04                	jmp    80100a2e <consoleread+0xdc>
      if(n < target){
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
80100a2a:	90                   	nop
80100a2b:	eb 01                	jmp    80100a2e <consoleread+0xdc>
    }
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
80100a2d:	90                   	nop
  }
  release(&cons.lock);
80100a2e:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100a35:	e8 86 45 00 00       	call   80104fc0 <release>
  ilock(ip);
80100a3a:	8b 45 08             	mov    0x8(%ebp),%eax
80100a3d:	89 04 24             	mov    %eax,(%esp)
80100a40:	e8 bc 0e 00 00       	call   80101901 <ilock>

  return target - n;
80100a45:	8b 45 10             	mov    0x10(%ebp),%eax
80100a48:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100a4b:	89 d1                	mov    %edx,%ecx
80100a4d:	29 c1                	sub    %eax,%ecx
80100a4f:	89 c8                	mov    %ecx,%eax
}
80100a51:	c9                   	leave  
80100a52:	c3                   	ret    

80100a53 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100a53:	55                   	push   %ebp
80100a54:	89 e5                	mov    %esp,%ebp
80100a56:	83 ec 28             	sub    $0x28,%esp
  int i;

  iunlock(ip);
80100a59:	8b 45 08             	mov    0x8(%ebp),%eax
80100a5c:	89 04 24             	mov    %eax,(%esp)
80100a5f:	e8 f4 0f 00 00       	call   80101a58 <iunlock>
  acquire(&cons.lock);
80100a64:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100a6b:	e8 ef 44 00 00       	call   80104f5f <acquire>
  for(i = 0; i < n; i++)
80100a70:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100a77:	eb 1d                	jmp    80100a96 <consolewrite+0x43>
    consputc(buf[i] & 0xff);
80100a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100a7c:	03 45 0c             	add    0xc(%ebp),%eax
80100a7f:	0f b6 00             	movzbl (%eax),%eax
80100a82:	0f be c0             	movsbl %al,%eax
80100a85:	25 ff 00 00 00       	and    $0xff,%eax
80100a8a:	89 04 24             	mov    %eax,(%esp)
80100a8d:	e8 da fc ff ff       	call   8010076c <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100a92:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100a96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100a99:	3b 45 10             	cmp    0x10(%ebp),%eax
80100a9c:	7c db                	jl     80100a79 <consolewrite+0x26>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100a9e:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100aa5:	e8 16 45 00 00       	call   80104fc0 <release>
  ilock(ip);
80100aaa:	8b 45 08             	mov    0x8(%ebp),%eax
80100aad:	89 04 24             	mov    %eax,(%esp)
80100ab0:	e8 4c 0e 00 00       	call   80101901 <ilock>

  return n;
80100ab5:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100ab8:	c9                   	leave  
80100ab9:	c3                   	ret    

80100aba <consoleinit>:

void
consoleinit(void)
{
80100aba:	55                   	push   %ebp
80100abb:	89 e5                	mov    %esp,%ebp
80100abd:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100ac0:	c7 44 24 04 72 89 10 	movl   $0x80108972,0x4(%esp)
80100ac7:	80 
80100ac8:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100acf:	e8 6a 44 00 00       	call   80104f3e <initlock>

  devsw[CONSOLE].write = consolewrite;
80100ad4:	c7 05 ec 21 11 80 53 	movl   $0x80100a53,0x801121ec
80100adb:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100ade:	c7 05 e8 21 11 80 52 	movl   $0x80100952,0x801121e8
80100ae5:	09 10 80 
  cons.locking = 1;
80100ae8:	c7 05 14 c6 10 80 01 	movl   $0x1,0x8010c614
80100aef:	00 00 00 

  picenable(IRQ_KBD);
80100af2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100af9:	e8 97 33 00 00       	call   80103e95 <picenable>
  ioapicenable(IRQ_KBD, 0);
80100afe:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100b05:	00 
80100b06:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100b0d:	e8 30 1f 00 00       	call   80102a42 <ioapicenable>
}
80100b12:	c9                   	leave  
80100b13:	c3                   	ret    

80100b14 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100b14:	55                   	push   %ebp
80100b15:	89 e5                	mov    %esp,%ebp
80100b17:	81 ec 38 01 00 00    	sub    $0x138,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
80100b1d:	e8 d4 29 00 00       	call   801034f6 <begin_op>
  if((ip = namei(path)) == 0){
80100b22:	8b 45 08             	mov    0x8(%ebp),%eax
80100b25:	89 04 24             	mov    %eax,(%esp)
80100b28:	e8 82 19 00 00       	call   801024af <namei>
80100b2d:	89 45 ec             	mov    %eax,-0x14(%ebp)
80100b30:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80100b34:	75 0f                	jne    80100b45 <exec+0x31>
    end_op();
80100b36:	e8 3d 2a 00 00       	call   80103578 <end_op>
    return -1;
80100b3b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b40:	e9 e2 03 00 00       	jmp    80100f27 <exec+0x413>
  }
  ilock(ip);
80100b45:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100b48:	89 04 24             	mov    %eax,(%esp)
80100b4b:	e8 b1 0d 00 00       	call   80101901 <ilock>
  pgdir = 0;
80100b50:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100b57:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100b5d:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
80100b64:	00 
80100b65:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100b6c:	00 
80100b6d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b71:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100b74:	89 04 24             	mov    %eax,(%esp)
80100b77:	e8 84 12 00 00       	call   80101e00 <readi>
80100b7c:	83 f8 33             	cmp    $0x33,%eax
80100b7f:	0f 86 57 03 00 00    	jbe    80100edc <exec+0x3c8>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100b85:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b8b:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100b90:	0f 85 49 03 00 00    	jne    80100edf <exec+0x3cb>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100b96:	e8 0e 75 00 00       	call   801080a9 <setupkvm>
80100b9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100b9e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100ba2:	0f 84 3a 03 00 00    	je     80100ee2 <exec+0x3ce>
    goto bad;

  // Load program into memory.
  sz = 0;
80100ba8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100baf:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
80100bb6:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100bbc:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100bbf:	e9 ca 00 00 00       	jmp    80100c8e <exec+0x17a>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bc4:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100bc7:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100bcd:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100bd4:	00 
80100bd5:	89 54 24 08          	mov    %edx,0x8(%esp)
80100bd9:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bdd:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100be0:	89 04 24             	mov    %eax,(%esp)
80100be3:	e8 18 12 00 00       	call   80101e00 <readi>
80100be8:	83 f8 20             	cmp    $0x20,%eax
80100beb:	0f 85 f4 02 00 00    	jne    80100ee5 <exec+0x3d1>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100bf1:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100bf7:	83 f8 01             	cmp    $0x1,%eax
80100bfa:	0f 85 80 00 00 00    	jne    80100c80 <exec+0x16c>
      continue;
    if(ph.memsz < ph.filesz)
80100c00:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100c06:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100c0c:	39 c2                	cmp    %eax,%edx
80100c0e:	0f 82 d4 02 00 00    	jb     80100ee8 <exec+0x3d4>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100c14:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100c1a:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100c20:	8d 04 02             	lea    (%edx,%eax,1),%eax
80100c23:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100c2a:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100c31:	89 04 24             	mov    %eax,(%esp)
80100c34:	e8 44 78 00 00       	call   8010847d <allocuvm>
80100c39:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100c3c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100c40:	0f 84 a5 02 00 00    	je     80100eeb <exec+0x3d7>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c46:	8b 8d fc fe ff ff    	mov    -0x104(%ebp),%ecx
80100c4c:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100c52:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100c58:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80100c5c:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100c60:	8b 55 ec             	mov    -0x14(%ebp),%edx
80100c63:	89 54 24 08          	mov    %edx,0x8(%esp)
80100c67:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100c6e:	89 04 24             	mov    %eax,(%esp)
80100c71:	e8 17 77 00 00       	call   8010838d <loaduvm>
80100c76:	85 c0                	test   %eax,%eax
80100c78:	0f 88 70 02 00 00    	js     80100eee <exec+0x3da>
80100c7e:	eb 01                	jmp    80100c81 <exec+0x16d>
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
      continue;
80100c80:	90                   	nop
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c81:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
80100c85:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100c88:	83 c0 20             	add    $0x20,%eax
80100c8b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100c8e:	0f b7 85 38 ff ff ff 	movzwl -0xc8(%ebp),%eax
80100c95:	0f b7 c0             	movzwl %ax,%eax
80100c98:	3b 45 d8             	cmp    -0x28(%ebp),%eax
80100c9b:	0f 8f 23 ff ff ff    	jg     80100bc4 <exec+0xb0>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100ca1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100ca4:	89 04 24             	mov    %eax,(%esp)
80100ca7:	e8 e2 0e 00 00       	call   80101b8e <iunlockput>
  end_op();
80100cac:	e8 c7 28 00 00       	call   80103578 <end_op>
  ip = 0;
80100cb1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100cb8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100cbb:	05 ff 0f 00 00       	add    $0xfff,%eax
80100cc0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100cc5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100cc8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ccb:	05 00 20 00 00       	add    $0x2000,%eax
80100cd0:	89 44 24 08          	mov    %eax,0x8(%esp)
80100cd4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100cd7:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100cde:	89 04 24             	mov    %eax,(%esp)
80100ce1:	e8 97 77 00 00       	call   8010847d <allocuvm>
80100ce6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100ce9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100ced:	0f 84 fe 01 00 00    	je     80100ef1 <exec+0x3dd>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cf3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100cf6:	2d 00 20 00 00       	sub    $0x2000,%eax
80100cfb:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100d02:	89 04 24             	mov    %eax,(%esp)
80100d05:	e8 97 79 00 00       	call   801086a1 <clearpteu>
  sp = sz;
80100d0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d0d:	89 45 e8             	mov    %eax,-0x18(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d10:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80100d17:	e9 81 00 00 00       	jmp    80100d9d <exec+0x289>
    if(argc >= MAXARG)
80100d1c:	83 7d e0 1f          	cmpl   $0x1f,-0x20(%ebp)
80100d20:	0f 87 ce 01 00 00    	ja     80100ef4 <exec+0x3e0>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d26:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d29:	c1 e0 02             	shl    $0x2,%eax
80100d2c:	03 45 0c             	add    0xc(%ebp),%eax
80100d2f:	8b 00                	mov    (%eax),%eax
80100d31:	89 04 24             	mov    %eax,(%esp)
80100d34:	e8 fe 46 00 00       	call   80105437 <strlen>
80100d39:	f7 d0                	not    %eax
80100d3b:	03 45 e8             	add    -0x18(%ebp),%eax
80100d3e:	83 e0 fc             	and    $0xfffffffc,%eax
80100d41:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d44:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d47:	c1 e0 02             	shl    $0x2,%eax
80100d4a:	03 45 0c             	add    0xc(%ebp),%eax
80100d4d:	8b 00                	mov    (%eax),%eax
80100d4f:	89 04 24             	mov    %eax,(%esp)
80100d52:	e8 e0 46 00 00       	call   80105437 <strlen>
80100d57:	83 c0 01             	add    $0x1,%eax
80100d5a:	89 c2                	mov    %eax,%edx
80100d5c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d5f:	c1 e0 02             	shl    $0x2,%eax
80100d62:	03 45 0c             	add    0xc(%ebp),%eax
80100d65:	8b 00                	mov    (%eax),%eax
80100d67:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100d6b:	89 44 24 08          	mov    %eax,0x8(%esp)
80100d6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100d72:	89 44 24 04          	mov    %eax,0x4(%esp)
80100d76:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100d79:	89 04 24             	mov    %eax,(%esp)
80100d7c:	e8 e5 7a 00 00       	call   80108866 <copyout>
80100d81:	85 c0                	test   %eax,%eax
80100d83:	0f 88 6e 01 00 00    	js     80100ef7 <exec+0x3e3>
      goto bad;
    ustack[3+argc] = sp;
80100d89:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d8c:	8d 50 03             	lea    0x3(%eax),%edx
80100d8f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100d92:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d99:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
80100d9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100da0:	c1 e0 02             	shl    $0x2,%eax
80100da3:	03 45 0c             	add    0xc(%ebp),%eax
80100da6:	8b 00                	mov    (%eax),%eax
80100da8:	85 c0                	test   %eax,%eax
80100daa:	0f 85 6c ff ff ff    	jne    80100d1c <exec+0x208>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100db0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100db3:	83 c0 03             	add    $0x3,%eax
80100db6:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100dbd:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100dc1:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100dc8:	ff ff ff 
  ustack[1] = argc;
80100dcb:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100dce:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100dd4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100dd7:	83 c0 01             	add    $0x1,%eax
80100dda:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100de1:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100de4:	29 d0                	sub    %edx,%eax
80100de6:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100dec:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100def:	83 c0 04             	add    $0x4,%eax
80100df2:	c1 e0 02             	shl    $0x2,%eax
80100df5:	29 45 e8             	sub    %eax,-0x18(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100df8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100dfb:	83 c0 04             	add    $0x4,%eax
80100dfe:	c1 e0 02             	shl    $0x2,%eax
80100e01:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100e05:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100e0b:	89 44 24 08          	mov    %eax,0x8(%esp)
80100e0f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100e12:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e16:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100e19:	89 04 24             	mov    %eax,(%esp)
80100e1c:	e8 45 7a 00 00       	call   80108866 <copyout>
80100e21:	85 c0                	test   %eax,%eax
80100e23:	0f 88 d1 00 00 00    	js     80100efa <exec+0x3e6>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e29:	8b 45 08             	mov    0x8(%ebp),%eax
80100e2c:	89 45 d0             	mov    %eax,-0x30(%ebp)
80100e2f:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100e32:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100e35:	eb 17                	jmp    80100e4e <exec+0x33a>
    if(*s == '/')
80100e37:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100e3a:	0f b6 00             	movzbl (%eax),%eax
80100e3d:	3c 2f                	cmp    $0x2f,%al
80100e3f:	75 09                	jne    80100e4a <exec+0x336>
      last = s+1;
80100e41:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100e44:	83 c0 01             	add    $0x1,%eax
80100e47:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e4a:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
80100e4e:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100e51:	0f b6 00             	movzbl (%eax),%eax
80100e54:	84 c0                	test   %al,%al
80100e56:	75 df                	jne    80100e37 <exec+0x323>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100e58:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e5e:	8d 50 6c             	lea    0x6c(%eax),%edx
80100e61:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100e68:	00 
80100e69:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100e6c:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e70:	89 14 24             	mov    %edx,(%esp)
80100e73:	e8 71 45 00 00       	call   801053e9 <safestrcpy>

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100e78:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e7e:	8b 40 04             	mov    0x4(%eax),%eax
80100e81:	89 45 f4             	mov    %eax,-0xc(%ebp)
  proc->pgdir = pgdir;
80100e84:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e8a:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100e8d:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100e90:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e96:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100e99:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100e9b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ea1:	8b 40 18             	mov    0x18(%eax),%eax
80100ea4:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100eaa:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100ead:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100eb3:	8b 40 18             	mov    0x18(%eax),%eax
80100eb6:	8b 55 e8             	mov    -0x18(%ebp),%edx
80100eb9:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100ebc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ec2:	89 04 24             	mov    %eax,(%esp)
80100ec5:	e8 d1 72 00 00       	call   8010819b <switchuvm>
  freevm(oldpgdir);
80100eca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ecd:	89 04 24             	mov    %eax,(%esp)
80100ed0:	e8 3e 77 00 00       	call   80108613 <freevm>
  return 0;
80100ed5:	b8 00 00 00 00       	mov    $0x0,%eax
80100eda:	eb 4b                	jmp    80100f27 <exec+0x413>
  ilock(ip);
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
    goto bad;
80100edc:	90                   	nop
80100edd:	eb 1c                	jmp    80100efb <exec+0x3e7>
  if(elf.magic != ELF_MAGIC)
    goto bad;
80100edf:	90                   	nop
80100ee0:	eb 19                	jmp    80100efb <exec+0x3e7>

  if((pgdir = setupkvm()) == 0)
    goto bad;
80100ee2:	90                   	nop
80100ee3:	eb 16                	jmp    80100efb <exec+0x3e7>

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
80100ee5:	90                   	nop
80100ee6:	eb 13                	jmp    80100efb <exec+0x3e7>
    if(ph.type != ELF_PROG_LOAD)
      continue;
    if(ph.memsz < ph.filesz)
      goto bad;
80100ee8:	90                   	nop
80100ee9:	eb 10                	jmp    80100efb <exec+0x3e7>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
80100eeb:	90                   	nop
80100eec:	eb 0d                	jmp    80100efb <exec+0x3e7>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
80100eee:	90                   	nop
80100eef:	eb 0a                	jmp    80100efb <exec+0x3e7>

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
80100ef1:	90                   	nop
80100ef2:	eb 07                	jmp    80100efb <exec+0x3e7>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
80100ef4:	90                   	nop
80100ef5:	eb 04                	jmp    80100efb <exec+0x3e7>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
80100ef7:	90                   	nop
80100ef8:	eb 01                	jmp    80100efb <exec+0x3e7>
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;
80100efa:	90                   	nop
  switchuvm(proc);
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
80100efb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100eff:	74 0b                	je     80100f0c <exec+0x3f8>
    freevm(pgdir);
80100f01:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100f04:	89 04 24             	mov    %eax,(%esp)
80100f07:	e8 07 77 00 00       	call   80108613 <freevm>
  if(ip){
80100f0c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80100f10:	74 10                	je     80100f22 <exec+0x40e>
    iunlockput(ip);
80100f12:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100f15:	89 04 24             	mov    %eax,(%esp)
80100f18:	e8 71 0c 00 00       	call   80101b8e <iunlockput>
    end_op();
80100f1d:	e8 56 26 00 00       	call   80103578 <end_op>
  }
  return -1;
80100f22:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f27:	c9                   	leave  
80100f28:	c3                   	ret    
80100f29:	00 00                	add    %al,(%eax)
	...

80100f2c <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f2c:	55                   	push   %ebp
80100f2d:	89 e5                	mov    %esp,%ebp
80100f2f:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100f32:	c7 44 24 04 7a 89 10 	movl   $0x8010897a,0x4(%esp)
80100f39:	80 
80100f3a:	c7 04 24 40 18 11 80 	movl   $0x80111840,(%esp)
80100f41:	e8 f8 3f 00 00       	call   80104f3e <initlock>
}
80100f46:	c9                   	leave  
80100f47:	c3                   	ret    

80100f48 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f48:	55                   	push   %ebp
80100f49:	89 e5                	mov    %esp,%ebp
80100f4b:	83 ec 28             	sub    $0x28,%esp
  struct file *f;

  acquire(&ftable.lock);
80100f4e:	c7 04 24 40 18 11 80 	movl   $0x80111840,(%esp)
80100f55:	e8 05 40 00 00       	call   80104f5f <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f5a:	c7 45 f4 74 18 11 80 	movl   $0x80111874,-0xc(%ebp)
80100f61:	eb 29                	jmp    80100f8c <filealloc+0x44>
    if(f->ref == 0){
80100f63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f66:	8b 40 04             	mov    0x4(%eax),%eax
80100f69:	85 c0                	test   %eax,%eax
80100f6b:	75 1b                	jne    80100f88 <filealloc+0x40>
      f->ref = 1;
80100f6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f70:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80100f77:	c7 04 24 40 18 11 80 	movl   $0x80111840,(%esp)
80100f7e:	e8 3d 40 00 00       	call   80104fc0 <release>
      return f;
80100f83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f86:	eb 1f                	jmp    80100fa7 <filealloc+0x5f>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f88:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100f8c:	b8 d4 21 11 80       	mov    $0x801121d4,%eax
80100f91:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80100f94:	72 cd                	jb     80100f63 <filealloc+0x1b>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100f96:	c7 04 24 40 18 11 80 	movl   $0x80111840,(%esp)
80100f9d:	e8 1e 40 00 00       	call   80104fc0 <release>
  return 0;
80100fa2:	b8 00 00 00 00       	mov    $0x0,%eax
}
80100fa7:	c9                   	leave  
80100fa8:	c3                   	ret    

80100fa9 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100fa9:	55                   	push   %ebp
80100faa:	89 e5                	mov    %esp,%ebp
80100fac:	83 ec 18             	sub    $0x18,%esp
  acquire(&ftable.lock);
80100faf:	c7 04 24 40 18 11 80 	movl   $0x80111840,(%esp)
80100fb6:	e8 a4 3f 00 00       	call   80104f5f <acquire>
  if(f->ref < 1)
80100fbb:	8b 45 08             	mov    0x8(%ebp),%eax
80100fbe:	8b 40 04             	mov    0x4(%eax),%eax
80100fc1:	85 c0                	test   %eax,%eax
80100fc3:	7f 0c                	jg     80100fd1 <filedup+0x28>
    panic("filedup");
80100fc5:	c7 04 24 81 89 10 80 	movl   $0x80108981,(%esp)
80100fcc:	e8 6c f5 ff ff       	call   8010053d <panic>
  f->ref++;
80100fd1:	8b 45 08             	mov    0x8(%ebp),%eax
80100fd4:	8b 40 04             	mov    0x4(%eax),%eax
80100fd7:	8d 50 01             	lea    0x1(%eax),%edx
80100fda:	8b 45 08             	mov    0x8(%ebp),%eax
80100fdd:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80100fe0:	c7 04 24 40 18 11 80 	movl   $0x80111840,(%esp)
80100fe7:	e8 d4 3f 00 00       	call   80104fc0 <release>
  return f;
80100fec:	8b 45 08             	mov    0x8(%ebp),%eax
}
80100fef:	c9                   	leave  
80100ff0:	c3                   	ret    

80100ff1 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ff1:	55                   	push   %ebp
80100ff2:	89 e5                	mov    %esp,%ebp
80100ff4:	83 ec 38             	sub    $0x38,%esp
  struct file ff;

  acquire(&ftable.lock);
80100ff7:	c7 04 24 40 18 11 80 	movl   $0x80111840,(%esp)
80100ffe:	e8 5c 3f 00 00       	call   80104f5f <acquire>
  if(f->ref < 1)
80101003:	8b 45 08             	mov    0x8(%ebp),%eax
80101006:	8b 40 04             	mov    0x4(%eax),%eax
80101009:	85 c0                	test   %eax,%eax
8010100b:	7f 0c                	jg     80101019 <fileclose+0x28>
    panic("fileclose");
8010100d:	c7 04 24 89 89 10 80 	movl   $0x80108989,(%esp)
80101014:	e8 24 f5 ff ff       	call   8010053d <panic>
  if(--f->ref > 0){
80101019:	8b 45 08             	mov    0x8(%ebp),%eax
8010101c:	8b 40 04             	mov    0x4(%eax),%eax
8010101f:	8d 50 ff             	lea    -0x1(%eax),%edx
80101022:	8b 45 08             	mov    0x8(%ebp),%eax
80101025:	89 50 04             	mov    %edx,0x4(%eax)
80101028:	8b 45 08             	mov    0x8(%ebp),%eax
8010102b:	8b 40 04             	mov    0x4(%eax),%eax
8010102e:	85 c0                	test   %eax,%eax
80101030:	7e 11                	jle    80101043 <fileclose+0x52>
    release(&ftable.lock);
80101032:	c7 04 24 40 18 11 80 	movl   $0x80111840,(%esp)
80101039:	e8 82 3f 00 00       	call   80104fc0 <release>
    return;
8010103e:	e9 82 00 00 00       	jmp    801010c5 <fileclose+0xd4>
  }
  ff = *f;
80101043:	8b 45 08             	mov    0x8(%ebp),%eax
80101046:	8b 10                	mov    (%eax),%edx
80101048:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010104b:	8b 50 04             	mov    0x4(%eax),%edx
8010104e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101051:	8b 50 08             	mov    0x8(%eax),%edx
80101054:	89 55 e8             	mov    %edx,-0x18(%ebp)
80101057:	8b 50 0c             	mov    0xc(%eax),%edx
8010105a:	89 55 ec             	mov    %edx,-0x14(%ebp)
8010105d:	8b 50 10             	mov    0x10(%eax),%edx
80101060:	89 55 f0             	mov    %edx,-0x10(%ebp)
80101063:	8b 40 14             	mov    0x14(%eax),%eax
80101066:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
80101069:	8b 45 08             	mov    0x8(%ebp),%eax
8010106c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
80101073:	8b 45 08             	mov    0x8(%ebp),%eax
80101076:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
8010107c:	c7 04 24 40 18 11 80 	movl   $0x80111840,(%esp)
80101083:	e8 38 3f 00 00       	call   80104fc0 <release>
  
  if(ff.type == FD_PIPE)
80101088:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010108b:	83 f8 01             	cmp    $0x1,%eax
8010108e:	75 18                	jne    801010a8 <fileclose+0xb7>
    pipeclose(ff.pipe, ff.writable);
80101090:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
80101094:	0f be d0             	movsbl %al,%edx
80101097:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010109a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010109e:	89 04 24             	mov    %eax,(%esp)
801010a1:	e8 a9 30 00 00       	call   8010414f <pipeclose>
801010a6:	eb 1d                	jmp    801010c5 <fileclose+0xd4>
  else if(ff.type == FD_INODE){
801010a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010ab:	83 f8 02             	cmp    $0x2,%eax
801010ae:	75 15                	jne    801010c5 <fileclose+0xd4>
    begin_op();
801010b0:	e8 41 24 00 00       	call   801034f6 <begin_op>
    iput(ff.ip);
801010b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801010b8:	89 04 24             	mov    %eax,(%esp)
801010bb:	e8 fd 09 00 00       	call   80101abd <iput>
    end_op();
801010c0:	e8 b3 24 00 00       	call   80103578 <end_op>
  }
}
801010c5:	c9                   	leave  
801010c6:	c3                   	ret    

801010c7 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801010c7:	55                   	push   %ebp
801010c8:	89 e5                	mov    %esp,%ebp
801010ca:	83 ec 18             	sub    $0x18,%esp
  if(f->type == FD_INODE){
801010cd:	8b 45 08             	mov    0x8(%ebp),%eax
801010d0:	8b 00                	mov    (%eax),%eax
801010d2:	83 f8 02             	cmp    $0x2,%eax
801010d5:	75 38                	jne    8010110f <filestat+0x48>
    ilock(f->ip);
801010d7:	8b 45 08             	mov    0x8(%ebp),%eax
801010da:	8b 40 10             	mov    0x10(%eax),%eax
801010dd:	89 04 24             	mov    %eax,(%esp)
801010e0:	e8 1c 08 00 00       	call   80101901 <ilock>
    stati(f->ip, st);
801010e5:	8b 45 08             	mov    0x8(%ebp),%eax
801010e8:	8b 40 10             	mov    0x10(%eax),%eax
801010eb:	8b 55 0c             	mov    0xc(%ebp),%edx
801010ee:	89 54 24 04          	mov    %edx,0x4(%esp)
801010f2:	89 04 24             	mov    %eax,(%esp)
801010f5:	e8 c1 0c 00 00       	call   80101dbb <stati>
    iunlock(f->ip);
801010fa:	8b 45 08             	mov    0x8(%ebp),%eax
801010fd:	8b 40 10             	mov    0x10(%eax),%eax
80101100:	89 04 24             	mov    %eax,(%esp)
80101103:	e8 50 09 00 00       	call   80101a58 <iunlock>
    return 0;
80101108:	b8 00 00 00 00       	mov    $0x0,%eax
8010110d:	eb 05                	jmp    80101114 <filestat+0x4d>
  }
  return -1;
8010110f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101114:	c9                   	leave  
80101115:	c3                   	ret    

80101116 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101116:	55                   	push   %ebp
80101117:	89 e5                	mov    %esp,%ebp
80101119:	83 ec 28             	sub    $0x28,%esp
  int r;

  if(f->readable == 0)
8010111c:	8b 45 08             	mov    0x8(%ebp),%eax
8010111f:	0f b6 40 08          	movzbl 0x8(%eax),%eax
80101123:	84 c0                	test   %al,%al
80101125:	75 0a                	jne    80101131 <fileread+0x1b>
    return -1;
80101127:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010112c:	e9 9f 00 00 00       	jmp    801011d0 <fileread+0xba>
  if(f->type == FD_PIPE)
80101131:	8b 45 08             	mov    0x8(%ebp),%eax
80101134:	8b 00                	mov    (%eax),%eax
80101136:	83 f8 01             	cmp    $0x1,%eax
80101139:	75 1e                	jne    80101159 <fileread+0x43>
    return piperead(f->pipe, addr, n);
8010113b:	8b 45 08             	mov    0x8(%ebp),%eax
8010113e:	8b 40 0c             	mov    0xc(%eax),%eax
80101141:	8b 55 10             	mov    0x10(%ebp),%edx
80101144:	89 54 24 08          	mov    %edx,0x8(%esp)
80101148:	8b 55 0c             	mov    0xc(%ebp),%edx
8010114b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010114f:	89 04 24             	mov    %eax,(%esp)
80101152:	e8 7a 31 00 00       	call   801042d1 <piperead>
80101157:	eb 77                	jmp    801011d0 <fileread+0xba>
  if(f->type == FD_INODE){
80101159:	8b 45 08             	mov    0x8(%ebp),%eax
8010115c:	8b 00                	mov    (%eax),%eax
8010115e:	83 f8 02             	cmp    $0x2,%eax
80101161:	75 61                	jne    801011c4 <fileread+0xae>
    ilock(f->ip);
80101163:	8b 45 08             	mov    0x8(%ebp),%eax
80101166:	8b 40 10             	mov    0x10(%eax),%eax
80101169:	89 04 24             	mov    %eax,(%esp)
8010116c:	e8 90 07 00 00       	call   80101901 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101171:	8b 4d 10             	mov    0x10(%ebp),%ecx
80101174:	8b 45 08             	mov    0x8(%ebp),%eax
80101177:	8b 50 14             	mov    0x14(%eax),%edx
8010117a:	8b 45 08             	mov    0x8(%ebp),%eax
8010117d:	8b 40 10             	mov    0x10(%eax),%eax
80101180:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101184:	89 54 24 08          	mov    %edx,0x8(%esp)
80101188:	8b 55 0c             	mov    0xc(%ebp),%edx
8010118b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010118f:	89 04 24             	mov    %eax,(%esp)
80101192:	e8 69 0c 00 00       	call   80101e00 <readi>
80101197:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010119a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010119e:	7e 11                	jle    801011b1 <fileread+0x9b>
      f->off += r;
801011a0:	8b 45 08             	mov    0x8(%ebp),%eax
801011a3:	8b 50 14             	mov    0x14(%eax),%edx
801011a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011a9:	01 c2                	add    %eax,%edx
801011ab:	8b 45 08             	mov    0x8(%ebp),%eax
801011ae:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
801011b1:	8b 45 08             	mov    0x8(%ebp),%eax
801011b4:	8b 40 10             	mov    0x10(%eax),%eax
801011b7:	89 04 24             	mov    %eax,(%esp)
801011ba:	e8 99 08 00 00       	call   80101a58 <iunlock>
    return r;
801011bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011c2:	eb 0c                	jmp    801011d0 <fileread+0xba>
  }
  panic("fileread");
801011c4:	c7 04 24 93 89 10 80 	movl   $0x80108993,(%esp)
801011cb:	e8 6d f3 ff ff       	call   8010053d <panic>
}
801011d0:	c9                   	leave  
801011d1:	c3                   	ret    

801011d2 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801011d2:	55                   	push   %ebp
801011d3:	89 e5                	mov    %esp,%ebp
801011d5:	53                   	push   %ebx
801011d6:	83 ec 24             	sub    $0x24,%esp
  int r;

  if(f->writable == 0)
801011d9:	8b 45 08             	mov    0x8(%ebp),%eax
801011dc:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801011e0:	84 c0                	test   %al,%al
801011e2:	75 0a                	jne    801011ee <filewrite+0x1c>
    return -1;
801011e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011e9:	e9 23 01 00 00       	jmp    80101311 <filewrite+0x13f>
  if(f->type == FD_PIPE)
801011ee:	8b 45 08             	mov    0x8(%ebp),%eax
801011f1:	8b 00                	mov    (%eax),%eax
801011f3:	83 f8 01             	cmp    $0x1,%eax
801011f6:	75 21                	jne    80101219 <filewrite+0x47>
    return pipewrite(f->pipe, addr, n);
801011f8:	8b 45 08             	mov    0x8(%ebp),%eax
801011fb:	8b 40 0c             	mov    0xc(%eax),%eax
801011fe:	8b 55 10             	mov    0x10(%ebp),%edx
80101201:	89 54 24 08          	mov    %edx,0x8(%esp)
80101205:	8b 55 0c             	mov    0xc(%ebp),%edx
80101208:	89 54 24 04          	mov    %edx,0x4(%esp)
8010120c:	89 04 24             	mov    %eax,(%esp)
8010120f:	e8 cd 2f 00 00       	call   801041e1 <pipewrite>
80101214:	e9 f8 00 00 00       	jmp    80101311 <filewrite+0x13f>
  if(f->type == FD_INODE){
80101219:	8b 45 08             	mov    0x8(%ebp),%eax
8010121c:	8b 00                	mov    (%eax),%eax
8010121e:	83 f8 02             	cmp    $0x2,%eax
80101221:	0f 85 de 00 00 00    	jne    80101305 <filewrite+0x133>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
80101227:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
8010122e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    while(i < n){
80101235:	e9 a8 00 00 00       	jmp    801012e2 <filewrite+0x110>
      int n1 = n - i;
8010123a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010123d:	8b 55 10             	mov    0x10(%ebp),%edx
80101240:	89 d1                	mov    %edx,%ecx
80101242:	29 c1                	sub    %eax,%ecx
80101244:	89 c8                	mov    %ecx,%eax
80101246:	89 45 f4             	mov    %eax,-0xc(%ebp)
      if(n1 > max)
80101249:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010124c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010124f:	7e 06                	jle    80101257 <filewrite+0x85>
        n1 = max;
80101251:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101254:	89 45 f4             	mov    %eax,-0xc(%ebp)

      begin_op();
80101257:	e8 9a 22 00 00       	call   801034f6 <begin_op>
      ilock(f->ip);
8010125c:	8b 45 08             	mov    0x8(%ebp),%eax
8010125f:	8b 40 10             	mov    0x10(%eax),%eax
80101262:	89 04 24             	mov    %eax,(%esp)
80101265:	e8 97 06 00 00       	call   80101901 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010126a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010126d:	8b 45 08             	mov    0x8(%ebp),%eax
80101270:	8b 48 14             	mov    0x14(%eax),%ecx
80101273:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101276:	89 c2                	mov    %eax,%edx
80101278:	03 55 0c             	add    0xc(%ebp),%edx
8010127b:	8b 45 08             	mov    0x8(%ebp),%eax
8010127e:	8b 40 10             	mov    0x10(%eax),%eax
80101281:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
80101285:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80101289:	89 54 24 04          	mov    %edx,0x4(%esp)
8010128d:	89 04 24             	mov    %eax,(%esp)
80101290:	e8 d7 0c 00 00       	call   80101f6c <writei>
80101295:	89 45 e8             	mov    %eax,-0x18(%ebp)
80101298:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010129c:	7e 11                	jle    801012af <filewrite+0xdd>
        f->off += r;
8010129e:	8b 45 08             	mov    0x8(%ebp),%eax
801012a1:	8b 50 14             	mov    0x14(%eax),%edx
801012a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012a7:	01 c2                	add    %eax,%edx
801012a9:	8b 45 08             	mov    0x8(%ebp),%eax
801012ac:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
801012af:	8b 45 08             	mov    0x8(%ebp),%eax
801012b2:	8b 40 10             	mov    0x10(%eax),%eax
801012b5:	89 04 24             	mov    %eax,(%esp)
801012b8:	e8 9b 07 00 00       	call   80101a58 <iunlock>
      end_op();
801012bd:	e8 b6 22 00 00       	call   80103578 <end_op>

      if(r < 0)
801012c2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801012c6:	78 28                	js     801012f0 <filewrite+0x11e>
        break;
      if(r != n1)
801012c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012cb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801012ce:	74 0c                	je     801012dc <filewrite+0x10a>
        panic("short filewrite");
801012d0:	c7 04 24 9c 89 10 80 	movl   $0x8010899c,(%esp)
801012d7:	e8 61 f2 ff ff       	call   8010053d <panic>
      i += r;
801012dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012df:	01 45 f0             	add    %eax,-0x10(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801012e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801012e5:	3b 45 10             	cmp    0x10(%ebp),%eax
801012e8:	0f 8c 4c ff ff ff    	jl     8010123a <filewrite+0x68>
801012ee:	eb 01                	jmp    801012f1 <filewrite+0x11f>
        f->off += r;
      iunlock(f->ip);
      end_op();

      if(r < 0)
        break;
801012f0:	90                   	nop
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801012f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801012f4:	3b 45 10             	cmp    0x10(%ebp),%eax
801012f7:	75 05                	jne    801012fe <filewrite+0x12c>
801012f9:	8b 45 10             	mov    0x10(%ebp),%eax
801012fc:	eb 05                	jmp    80101303 <filewrite+0x131>
801012fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101303:	eb 0c                	jmp    80101311 <filewrite+0x13f>
  }
  panic("filewrite");
80101305:	c7 04 24 ac 89 10 80 	movl   $0x801089ac,(%esp)
8010130c:	e8 2c f2 ff ff       	call   8010053d <panic>
}
80101311:	83 c4 24             	add    $0x24,%esp
80101314:	5b                   	pop    %ebx
80101315:	5d                   	pop    %ebp
80101316:	c3                   	ret    
	...

80101318 <readsb>:
struct superblock sb;   // there should be one per dev, but we run with one dev

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101318:	55                   	push   %ebp
80101319:	89 e5                	mov    %esp,%ebp
8010131b:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
8010131e:	8b 45 08             	mov    0x8(%ebp),%eax
80101321:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80101328:	00 
80101329:	89 04 24             	mov    %eax,(%esp)
8010132c:	e8 76 ee ff ff       	call   801001a7 <bread>
80101331:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
80101334:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101337:	83 c0 18             	add    $0x18,%eax
8010133a:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
80101341:	00 
80101342:	89 44 24 04          	mov    %eax,0x4(%esp)
80101346:	8b 45 0c             	mov    0xc(%ebp),%eax
80101349:	89 04 24             	mov    %eax,(%esp)
8010134c:	e8 38 3f 00 00       	call   80105289 <memmove>
  brelse(bp);
80101351:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101354:	89 04 24             	mov    %eax,(%esp)
80101357:	e8 bc ee ff ff       	call   80100218 <brelse>
}
8010135c:	c9                   	leave  
8010135d:	c3                   	ret    

8010135e <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
8010135e:	55                   	push   %ebp
8010135f:	89 e5                	mov    %esp,%ebp
80101361:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
80101364:	8b 55 0c             	mov    0xc(%ebp),%edx
80101367:	8b 45 08             	mov    0x8(%ebp),%eax
8010136a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010136e:	89 04 24             	mov    %eax,(%esp)
80101371:	e8 31 ee ff ff       	call   801001a7 <bread>
80101376:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
80101379:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010137c:	83 c0 18             	add    $0x18,%eax
8010137f:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80101386:	00 
80101387:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010138e:	00 
8010138f:	89 04 24             	mov    %eax,(%esp)
80101392:	e8 1f 3e 00 00       	call   801051b6 <memset>
  log_write(bp);
80101397:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010139a:	89 04 24             	mov    %eax,(%esp)
8010139d:	e8 5a 23 00 00       	call   801036fc <log_write>
  brelse(bp);
801013a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013a5:	89 04 24             	mov    %eax,(%esp)
801013a8:	e8 6b ee ff ff       	call   80100218 <brelse>
}
801013ad:	c9                   	leave  
801013ae:	c3                   	ret    

801013af <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801013af:	55                   	push   %ebp
801013b0:	89 e5                	mov    %esp,%ebp
801013b2:	53                   	push   %ebx
801013b3:	83 ec 24             	sub    $0x24,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
801013b6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801013bd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
801013c4:	e9 16 01 00 00       	jmp    801014df <balloc+0x130>
    bp = bread(dev, BBLOCK(b, sb));
801013c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
801013cc:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801013d2:	85 c0                	test   %eax,%eax
801013d4:	0f 48 c2             	cmovs  %edx,%eax
801013d7:	c1 f8 0c             	sar    $0xc,%eax
801013da:	89 c2                	mov    %eax,%edx
801013dc:	a1 58 22 11 80       	mov    0x80112258,%eax
801013e1:	8d 04 02             	lea    (%edx,%eax,1),%eax
801013e4:	89 44 24 04          	mov    %eax,0x4(%esp)
801013e8:	8b 45 08             	mov    0x8(%ebp),%eax
801013eb:	89 04 24             	mov    %eax,(%esp)
801013ee:	e8 b4 ed ff ff       	call   801001a7 <bread>
801013f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801013f6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
801013fd:	e9 aa 00 00 00       	jmp    801014ac <balloc+0xfd>
      m = 1 << (bi % 8);
80101402:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101405:	89 c2                	mov    %eax,%edx
80101407:	c1 fa 1f             	sar    $0x1f,%edx
8010140a:	c1 ea 1d             	shr    $0x1d,%edx
8010140d:	01 d0                	add    %edx,%eax
8010140f:	83 e0 07             	and    $0x7,%eax
80101412:	29 d0                	sub    %edx,%eax
80101414:	ba 01 00 00 00       	mov    $0x1,%edx
80101419:	89 d3                	mov    %edx,%ebx
8010141b:	89 c1                	mov    %eax,%ecx
8010141d:	d3 e3                	shl    %cl,%ebx
8010141f:	89 d8                	mov    %ebx,%eax
80101421:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101424:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101427:	8d 50 07             	lea    0x7(%eax),%edx
8010142a:	85 c0                	test   %eax,%eax
8010142c:	0f 48 c2             	cmovs  %edx,%eax
8010142f:	c1 f8 03             	sar    $0x3,%eax
80101432:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101435:	0f b6 44 02 18       	movzbl 0x18(%edx,%eax,1),%eax
8010143a:	0f b6 c0             	movzbl %al,%eax
8010143d:	23 45 f0             	and    -0x10(%ebp),%eax
80101440:	85 c0                	test   %eax,%eax
80101442:	75 64                	jne    801014a8 <balloc+0xf9>
        bp->data[bi/8] |= m;  // Mark block in use.
80101444:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101447:	8d 50 07             	lea    0x7(%eax),%edx
8010144a:	85 c0                	test   %eax,%eax
8010144c:	0f 48 c2             	cmovs  %edx,%eax
8010144f:	c1 f8 03             	sar    $0x3,%eax
80101452:	89 c2                	mov    %eax,%edx
80101454:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80101457:	0f b6 44 01 18       	movzbl 0x18(%ecx,%eax,1),%eax
8010145c:	89 c1                	mov    %eax,%ecx
8010145e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101461:	09 c8                	or     %ecx,%eax
80101463:	89 c1                	mov    %eax,%ecx
80101465:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101468:	88 4c 10 18          	mov    %cl,0x18(%eax,%edx,1)
        log_write(bp);
8010146c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010146f:	89 04 24             	mov    %eax,(%esp)
80101472:	e8 85 22 00 00       	call   801036fc <log_write>
        brelse(bp);
80101477:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010147a:	89 04 24             	mov    %eax,(%esp)
8010147d:	e8 96 ed ff ff       	call   80100218 <brelse>
        bzero(dev, b + bi);
80101482:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101485:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101488:	01 c2                	add    %eax,%edx
8010148a:	8b 45 08             	mov    0x8(%ebp),%eax
8010148d:	89 54 24 04          	mov    %edx,0x4(%esp)
80101491:	89 04 24             	mov    %eax,(%esp)
80101494:	e8 c5 fe ff ff       	call   8010135e <bzero>
        return b + bi;
80101499:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010149c:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010149f:	8d 04 02             	lea    (%edx,%eax,1),%eax
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
801014a2:	83 c4 24             	add    $0x24,%esp
801014a5:	5b                   	pop    %ebx
801014a6:	5d                   	pop    %ebp
801014a7:	c3                   	ret    
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801014a8:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801014ac:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
801014b3:	7f 18                	jg     801014cd <balloc+0x11e>
801014b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801014b8:	8b 55 e8             	mov    -0x18(%ebp),%edx
801014bb:	8d 04 02             	lea    (%edx,%eax,1),%eax
801014be:	89 c2                	mov    %eax,%edx
801014c0:	a1 40 22 11 80       	mov    0x80112240,%eax
801014c5:	39 c2                	cmp    %eax,%edx
801014c7:	0f 82 35 ff ff ff    	jb     80101402 <balloc+0x53>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801014cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801014d0:	89 04 24             	mov    %eax,(%esp)
801014d3:	e8 40 ed ff ff       	call   80100218 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801014d8:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)
801014df:	8b 55 e8             	mov    -0x18(%ebp),%edx
801014e2:	a1 40 22 11 80       	mov    0x80112240,%eax
801014e7:	39 c2                	cmp    %eax,%edx
801014e9:	0f 82 da fe ff ff    	jb     801013c9 <balloc+0x1a>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801014ef:	c7 04 24 b8 89 10 80 	movl   $0x801089b8,(%esp)
801014f6:	e8 42 f0 ff ff       	call   8010053d <panic>

801014fb <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801014fb:	55                   	push   %ebp
801014fc:	89 e5                	mov    %esp,%ebp
801014fe:	53                   	push   %ebx
801014ff:	83 ec 24             	sub    $0x24,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
80101502:	c7 44 24 04 40 22 11 	movl   $0x80112240,0x4(%esp)
80101509:	80 
8010150a:	8b 45 08             	mov    0x8(%ebp),%eax
8010150d:	89 04 24             	mov    %eax,(%esp)
80101510:	e8 03 fe ff ff       	call   80101318 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101515:	8b 45 0c             	mov    0xc(%ebp),%eax
80101518:	89 c2                	mov    %eax,%edx
8010151a:	c1 ea 0c             	shr    $0xc,%edx
8010151d:	a1 58 22 11 80       	mov    0x80112258,%eax
80101522:	01 c2                	add    %eax,%edx
80101524:	8b 45 08             	mov    0x8(%ebp),%eax
80101527:	89 54 24 04          	mov    %edx,0x4(%esp)
8010152b:	89 04 24             	mov    %eax,(%esp)
8010152e:	e8 74 ec ff ff       	call   801001a7 <bread>
80101533:	89 45 ec             	mov    %eax,-0x14(%ebp)
  bi = b % BPB;
80101536:	8b 45 0c             	mov    0xc(%ebp),%eax
80101539:	25 ff 0f 00 00       	and    $0xfff,%eax
8010153e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
80101541:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101544:	89 c2                	mov    %eax,%edx
80101546:	c1 fa 1f             	sar    $0x1f,%edx
80101549:	c1 ea 1d             	shr    $0x1d,%edx
8010154c:	01 d0                	add    %edx,%eax
8010154e:	83 e0 07             	and    $0x7,%eax
80101551:	29 d0                	sub    %edx,%eax
80101553:	ba 01 00 00 00       	mov    $0x1,%edx
80101558:	89 d3                	mov    %edx,%ebx
8010155a:	89 c1                	mov    %eax,%ecx
8010155c:	d3 e3                	shl    %cl,%ebx
8010155e:	89 d8                	mov    %ebx,%eax
80101560:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((bp->data[bi/8] & m) == 0)
80101563:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101566:	8d 50 07             	lea    0x7(%eax),%edx
80101569:	85 c0                	test   %eax,%eax
8010156b:	0f 48 c2             	cmovs  %edx,%eax
8010156e:	c1 f8 03             	sar    $0x3,%eax
80101571:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101574:	0f b6 44 02 18       	movzbl 0x18(%edx,%eax,1),%eax
80101579:	0f b6 c0             	movzbl %al,%eax
8010157c:	23 45 f4             	and    -0xc(%ebp),%eax
8010157f:	85 c0                	test   %eax,%eax
80101581:	75 0c                	jne    8010158f <bfree+0x94>
    panic("freeing free block");
80101583:	c7 04 24 ce 89 10 80 	movl   $0x801089ce,(%esp)
8010158a:	e8 ae ef ff ff       	call   8010053d <panic>
  bp->data[bi/8] &= ~m;
8010158f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101592:	8d 50 07             	lea    0x7(%eax),%edx
80101595:	85 c0                	test   %eax,%eax
80101597:	0f 48 c2             	cmovs  %edx,%eax
8010159a:	c1 f8 03             	sar    $0x3,%eax
8010159d:	89 c2                	mov    %eax,%edx
8010159f:	8b 4d ec             	mov    -0x14(%ebp),%ecx
801015a2:	0f b6 44 01 18       	movzbl 0x18(%ecx,%eax,1),%eax
801015a7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801015aa:	f7 d1                	not    %ecx
801015ac:	21 c8                	and    %ecx,%eax
801015ae:	89 c1                	mov    %eax,%ecx
801015b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801015b3:	88 4c 10 18          	mov    %cl,0x18(%eax,%edx,1)
  log_write(bp);
801015b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801015ba:	89 04 24             	mov    %eax,(%esp)
801015bd:	e8 3a 21 00 00       	call   801036fc <log_write>
  brelse(bp);
801015c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801015c5:	89 04 24             	mov    %eax,(%esp)
801015c8:	e8 4b ec ff ff       	call   80100218 <brelse>
}
801015cd:	83 c4 24             	add    $0x24,%esp
801015d0:	5b                   	pop    %ebx
801015d1:	5d                   	pop    %ebp
801015d2:	c3                   	ret    

801015d3 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
801015d3:	55                   	push   %ebp
801015d4:	89 e5                	mov    %esp,%ebp
801015d6:	57                   	push   %edi
801015d7:	56                   	push   %esi
801015d8:	53                   	push   %ebx
801015d9:	83 ec 4c             	sub    $0x4c,%esp
  initlock(&icache.lock, "icache");
801015dc:	c7 44 24 04 e1 89 10 	movl   $0x801089e1,0x4(%esp)
801015e3:	80 
801015e4:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
801015eb:	e8 4e 39 00 00       	call   80104f3e <initlock>
  readsb(dev, &sb);
801015f0:	c7 44 24 04 40 22 11 	movl   $0x80112240,0x4(%esp)
801015f7:	80 
801015f8:	8b 45 08             	mov    0x8(%ebp),%eax
801015fb:	89 04 24             	mov    %eax,(%esp)
801015fe:	e8 15 fd ff ff       	call   80101318 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d inodestart %d bmap start %d\n", sb.size,
80101603:	a1 58 22 11 80       	mov    0x80112258,%eax
80101608:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010160b:	8b 3d 54 22 11 80    	mov    0x80112254,%edi
80101611:	8b 35 50 22 11 80    	mov    0x80112250,%esi
80101617:	8b 1d 4c 22 11 80    	mov    0x8011224c,%ebx
8010161d:	8b 0d 48 22 11 80    	mov    0x80112248,%ecx
80101623:	8b 15 44 22 11 80    	mov    0x80112244,%edx
80101629:	a1 40 22 11 80       	mov    0x80112240,%eax
8010162e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80101631:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101634:	89 44 24 1c          	mov    %eax,0x1c(%esp)
80101638:	89 7c 24 18          	mov    %edi,0x18(%esp)
8010163c:	89 74 24 14          	mov    %esi,0x14(%esp)
80101640:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80101644:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101648:	89 54 24 08          	mov    %edx,0x8(%esp)
8010164c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010164f:	89 44 24 04          	mov    %eax,0x4(%esp)
80101653:	c7 04 24 e8 89 10 80 	movl   $0x801089e8,(%esp)
8010165a:	e8 3e ed ff ff       	call   8010039d <cprintf>
          sb.nblocks, sb.ninodes, sb.nlog, sb.logstart, sb.inodestart, sb.bmapstart);
}
8010165f:	83 c4 4c             	add    $0x4c,%esp
80101662:	5b                   	pop    %ebx
80101663:	5e                   	pop    %esi
80101664:	5f                   	pop    %edi
80101665:	5d                   	pop    %ebp
80101666:	c3                   	ret    

80101667 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
80101667:	55                   	push   %ebp
80101668:	89 e5                	mov    %esp,%ebp
8010166a:	83 ec 38             	sub    $0x38,%esp
8010166d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101670:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101674:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
8010167b:	e9 9f 00 00 00       	jmp    8010171f <ialloc+0xb8>
    bp = bread(dev, IBLOCK(inum, sb));
80101680:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101683:	89 c2                	mov    %eax,%edx
80101685:	c1 ea 03             	shr    $0x3,%edx
80101688:	a1 54 22 11 80       	mov    0x80112254,%eax
8010168d:	8d 04 02             	lea    (%edx,%eax,1),%eax
80101690:	89 44 24 04          	mov    %eax,0x4(%esp)
80101694:	8b 45 08             	mov    0x8(%ebp),%eax
80101697:	89 04 24             	mov    %eax,(%esp)
8010169a:	e8 08 eb ff ff       	call   801001a7 <bread>
8010169f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
801016a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016a5:	83 c0 18             	add    $0x18,%eax
801016a8:	8b 55 ec             	mov    -0x14(%ebp),%edx
801016ab:	83 e2 07             	and    $0x7,%edx
801016ae:	c1 e2 06             	shl    $0x6,%edx
801016b1:	01 d0                	add    %edx,%eax
801016b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(dip->type == 0){  // a free inode
801016b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016b9:	0f b7 00             	movzwl (%eax),%eax
801016bc:	66 85 c0             	test   %ax,%ax
801016bf:	75 4f                	jne    80101710 <ialloc+0xa9>
      memset(dip, 0, sizeof(*dip));
801016c1:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
801016c8:	00 
801016c9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801016d0:	00 
801016d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016d4:	89 04 24             	mov    %eax,(%esp)
801016d7:	e8 da 3a 00 00       	call   801051b6 <memset>
      dip->type = type;
801016dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016df:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
801016e3:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
801016e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016e9:	89 04 24             	mov    %eax,(%esp)
801016ec:	e8 0b 20 00 00       	call   801036fc <log_write>
      brelse(bp);
801016f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016f4:	89 04 24             	mov    %eax,(%esp)
801016f7:	e8 1c eb ff ff       	call   80100218 <brelse>
      return iget(dev, inum);
801016fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801016ff:	89 44 24 04          	mov    %eax,0x4(%esp)
80101703:	8b 45 08             	mov    0x8(%ebp),%eax
80101706:	89 04 24             	mov    %eax,(%esp)
80101709:	e8 ee 00 00 00       	call   801017fc <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
8010170e:	c9                   	leave  
8010170f:	c3                   	ret    
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101710:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101713:	89 04 24             	mov    %eax,(%esp)
80101716:	e8 fd ea ff ff       	call   80100218 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010171b:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
8010171f:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101722:	a1 48 22 11 80       	mov    0x80112248,%eax
80101727:	39 c2                	cmp    %eax,%edx
80101729:	0f 82 51 ff ff ff    	jb     80101680 <ialloc+0x19>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
8010172f:	c7 04 24 3b 8a 10 80 	movl   $0x80108a3b,(%esp)
80101736:	e8 02 ee ff ff       	call   8010053d <panic>

8010173b <iupdate>:
}

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
8010173b:	55                   	push   %ebp
8010173c:	89 e5                	mov    %esp,%ebp
8010173e:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101741:	8b 45 08             	mov    0x8(%ebp),%eax
80101744:	8b 40 04             	mov    0x4(%eax),%eax
80101747:	89 c2                	mov    %eax,%edx
80101749:	c1 ea 03             	shr    $0x3,%edx
8010174c:	a1 54 22 11 80       	mov    0x80112254,%eax
80101751:	01 c2                	add    %eax,%edx
80101753:	8b 45 08             	mov    0x8(%ebp),%eax
80101756:	8b 00                	mov    (%eax),%eax
80101758:	89 54 24 04          	mov    %edx,0x4(%esp)
8010175c:	89 04 24             	mov    %eax,(%esp)
8010175f:	e8 43 ea ff ff       	call   801001a7 <bread>
80101764:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101767:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010176a:	83 c0 18             	add    $0x18,%eax
8010176d:	89 c2                	mov    %eax,%edx
8010176f:	8b 45 08             	mov    0x8(%ebp),%eax
80101772:	8b 40 04             	mov    0x4(%eax),%eax
80101775:	83 e0 07             	and    $0x7,%eax
80101778:	c1 e0 06             	shl    $0x6,%eax
8010177b:	8d 04 02             	lea    (%edx,%eax,1),%eax
8010177e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip->type = ip->type;
80101781:	8b 45 08             	mov    0x8(%ebp),%eax
80101784:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101788:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010178b:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010178e:	8b 45 08             	mov    0x8(%ebp),%eax
80101791:	0f b7 50 12          	movzwl 0x12(%eax),%edx
80101795:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101798:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
8010179c:	8b 45 08             	mov    0x8(%ebp),%eax
8010179f:	0f b7 50 14          	movzwl 0x14(%eax),%edx
801017a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017a6:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
801017aa:	8b 45 08             	mov    0x8(%ebp),%eax
801017ad:	0f b7 50 16          	movzwl 0x16(%eax),%edx
801017b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017b4:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
801017b8:	8b 45 08             	mov    0x8(%ebp),%eax
801017bb:	8b 50 18             	mov    0x18(%eax),%edx
801017be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017c1:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017c4:	8b 45 08             	mov    0x8(%ebp),%eax
801017c7:	8d 50 1c             	lea    0x1c(%eax),%edx
801017ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017cd:	83 c0 0c             	add    $0xc,%eax
801017d0:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
801017d7:	00 
801017d8:	89 54 24 04          	mov    %edx,0x4(%esp)
801017dc:	89 04 24             	mov    %eax,(%esp)
801017df:	e8 a5 3a 00 00       	call   80105289 <memmove>
  log_write(bp);
801017e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017e7:	89 04 24             	mov    %eax,(%esp)
801017ea:	e8 0d 1f 00 00       	call   801036fc <log_write>
  brelse(bp);
801017ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017f2:	89 04 24             	mov    %eax,(%esp)
801017f5:	e8 1e ea ff ff       	call   80100218 <brelse>
}
801017fa:	c9                   	leave  
801017fb:	c3                   	ret    

801017fc <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801017fc:	55                   	push   %ebp
801017fd:	89 e5                	mov    %esp,%ebp
801017ff:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101802:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80101809:	e8 51 37 00 00       	call   80104f5f <acquire>

  // Is the inode already cached?
  empty = 0;
8010180e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101815:	c7 45 f0 94 22 11 80 	movl   $0x80112294,-0x10(%ebp)
8010181c:	eb 59                	jmp    80101877 <iget+0x7b>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010181e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101821:	8b 40 08             	mov    0x8(%eax),%eax
80101824:	85 c0                	test   %eax,%eax
80101826:	7e 35                	jle    8010185d <iget+0x61>
80101828:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010182b:	8b 00                	mov    (%eax),%eax
8010182d:	3b 45 08             	cmp    0x8(%ebp),%eax
80101830:	75 2b                	jne    8010185d <iget+0x61>
80101832:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101835:	8b 40 04             	mov    0x4(%eax),%eax
80101838:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010183b:	75 20                	jne    8010185d <iget+0x61>
      ip->ref++;
8010183d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101840:	8b 40 08             	mov    0x8(%eax),%eax
80101843:	8d 50 01             	lea    0x1(%eax),%edx
80101846:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101849:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
8010184c:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80101853:	e8 68 37 00 00       	call   80104fc0 <release>
      return ip;
80101858:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010185b:	eb 70                	jmp    801018cd <iget+0xd1>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
8010185d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101861:	75 10                	jne    80101873 <iget+0x77>
80101863:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101866:	8b 40 08             	mov    0x8(%eax),%eax
80101869:	85 c0                	test   %eax,%eax
8010186b:	75 06                	jne    80101873 <iget+0x77>
      empty = ip;
8010186d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101870:	89 45 f4             	mov    %eax,-0xc(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101873:	83 45 f0 50          	addl   $0x50,-0x10(%ebp)
80101877:	b8 34 32 11 80       	mov    $0x80113234,%eax
8010187c:	39 45 f0             	cmp    %eax,-0x10(%ebp)
8010187f:	72 9d                	jb     8010181e <iget+0x22>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101881:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101885:	75 0c                	jne    80101893 <iget+0x97>
    panic("iget: no inodes");
80101887:	c7 04 24 4d 8a 10 80 	movl   $0x80108a4d,(%esp)
8010188e:	e8 aa ec ff ff       	call   8010053d <panic>

  ip = empty;
80101893:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101896:	89 45 f0             	mov    %eax,-0x10(%ebp)
  ip->dev = dev;
80101899:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010189c:	8b 55 08             	mov    0x8(%ebp),%edx
8010189f:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
801018a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018a4:	8b 55 0c             	mov    0xc(%ebp),%edx
801018a7:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
801018aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018ad:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
801018b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018b7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
801018be:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
801018c5:	e8 f6 36 00 00       	call   80104fc0 <release>

  return ip;
801018ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801018cd:	c9                   	leave  
801018ce:	c3                   	ret    

801018cf <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
801018cf:	55                   	push   %ebp
801018d0:	89 e5                	mov    %esp,%ebp
801018d2:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
801018d5:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
801018dc:	e8 7e 36 00 00       	call   80104f5f <acquire>
  ip->ref++;
801018e1:	8b 45 08             	mov    0x8(%ebp),%eax
801018e4:	8b 40 08             	mov    0x8(%eax),%eax
801018e7:	8d 50 01             	lea    0x1(%eax),%edx
801018ea:	8b 45 08             	mov    0x8(%ebp),%eax
801018ed:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
801018f0:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
801018f7:	e8 c4 36 00 00       	call   80104fc0 <release>
  return ip;
801018fc:	8b 45 08             	mov    0x8(%ebp),%eax
}
801018ff:	c9                   	leave  
80101900:	c3                   	ret    

80101901 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101901:	55                   	push   %ebp
80101902:	89 e5                	mov    %esp,%ebp
80101904:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101907:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010190b:	74 0a                	je     80101917 <ilock+0x16>
8010190d:	8b 45 08             	mov    0x8(%ebp),%eax
80101910:	8b 40 08             	mov    0x8(%eax),%eax
80101913:	85 c0                	test   %eax,%eax
80101915:	7f 0c                	jg     80101923 <ilock+0x22>
    panic("ilock");
80101917:	c7 04 24 5d 8a 10 80 	movl   $0x80108a5d,(%esp)
8010191e:	e8 1a ec ff ff       	call   8010053d <panic>

  acquire(&icache.lock);
80101923:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
8010192a:	e8 30 36 00 00       	call   80104f5f <acquire>
  while(ip->flags & I_BUSY)
8010192f:	eb 13                	jmp    80101944 <ilock+0x43>
    sleep(ip, &icache.lock);
80101931:	c7 44 24 04 60 22 11 	movl   $0x80112260,0x4(%esp)
80101938:	80 
80101939:	8b 45 08             	mov    0x8(%ebp),%eax
8010193c:	89 04 24             	mov    %eax,(%esp)
8010193f:	e8 40 33 00 00       	call   80104c84 <sleep>

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
80101944:	8b 45 08             	mov    0x8(%ebp),%eax
80101947:	8b 40 0c             	mov    0xc(%eax),%eax
8010194a:	83 e0 01             	and    $0x1,%eax
8010194d:	84 c0                	test   %al,%al
8010194f:	75 e0                	jne    80101931 <ilock+0x30>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
80101951:	8b 45 08             	mov    0x8(%ebp),%eax
80101954:	8b 40 0c             	mov    0xc(%eax),%eax
80101957:	89 c2                	mov    %eax,%edx
80101959:	83 ca 01             	or     $0x1,%edx
8010195c:	8b 45 08             	mov    0x8(%ebp),%eax
8010195f:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
80101962:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80101969:	e8 52 36 00 00       	call   80104fc0 <release>

  if(!(ip->flags & I_VALID)){
8010196e:	8b 45 08             	mov    0x8(%ebp),%eax
80101971:	8b 40 0c             	mov    0xc(%eax),%eax
80101974:	83 e0 02             	and    $0x2,%eax
80101977:	85 c0                	test   %eax,%eax
80101979:	0f 85 d7 00 00 00    	jne    80101a56 <ilock+0x155>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010197f:	8b 45 08             	mov    0x8(%ebp),%eax
80101982:	8b 40 04             	mov    0x4(%eax),%eax
80101985:	89 c2                	mov    %eax,%edx
80101987:	c1 ea 03             	shr    $0x3,%edx
8010198a:	a1 54 22 11 80       	mov    0x80112254,%eax
8010198f:	01 c2                	add    %eax,%edx
80101991:	8b 45 08             	mov    0x8(%ebp),%eax
80101994:	8b 00                	mov    (%eax),%eax
80101996:	89 54 24 04          	mov    %edx,0x4(%esp)
8010199a:	89 04 24             	mov    %eax,(%esp)
8010199d:	e8 05 e8 ff ff       	call   801001a7 <bread>
801019a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801019a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019a8:	83 c0 18             	add    $0x18,%eax
801019ab:	89 c2                	mov    %eax,%edx
801019ad:	8b 45 08             	mov    0x8(%ebp),%eax
801019b0:	8b 40 04             	mov    0x4(%eax),%eax
801019b3:	83 e0 07             	and    $0x7,%eax
801019b6:	c1 e0 06             	shl    $0x6,%eax
801019b9:	8d 04 02             	lea    (%edx,%eax,1),%eax
801019bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    ip->type = dip->type;
801019bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019c2:	0f b7 10             	movzwl (%eax),%edx
801019c5:	8b 45 08             	mov    0x8(%ebp),%eax
801019c8:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
801019cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019cf:	0f b7 50 02          	movzwl 0x2(%eax),%edx
801019d3:	8b 45 08             	mov    0x8(%ebp),%eax
801019d6:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
801019da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019dd:	0f b7 50 04          	movzwl 0x4(%eax),%edx
801019e1:	8b 45 08             	mov    0x8(%ebp),%eax
801019e4:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
801019e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019eb:	0f b7 50 06          	movzwl 0x6(%eax),%edx
801019ef:	8b 45 08             	mov    0x8(%ebp),%eax
801019f2:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
801019f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019f9:	8b 50 08             	mov    0x8(%eax),%edx
801019fc:	8b 45 08             	mov    0x8(%ebp),%eax
801019ff:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101a02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a05:	8d 50 0c             	lea    0xc(%eax),%edx
80101a08:	8b 45 08             	mov    0x8(%ebp),%eax
80101a0b:	83 c0 1c             	add    $0x1c,%eax
80101a0e:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101a15:	00 
80101a16:	89 54 24 04          	mov    %edx,0x4(%esp)
80101a1a:	89 04 24             	mov    %eax,(%esp)
80101a1d:	e8 67 38 00 00       	call   80105289 <memmove>
    brelse(bp);
80101a22:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a25:	89 04 24             	mov    %eax,(%esp)
80101a28:	e8 eb e7 ff ff       	call   80100218 <brelse>
    ip->flags |= I_VALID;
80101a2d:	8b 45 08             	mov    0x8(%ebp),%eax
80101a30:	8b 40 0c             	mov    0xc(%eax),%eax
80101a33:	89 c2                	mov    %eax,%edx
80101a35:	83 ca 02             	or     $0x2,%edx
80101a38:	8b 45 08             	mov    0x8(%ebp),%eax
80101a3b:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
80101a3e:	8b 45 08             	mov    0x8(%ebp),%eax
80101a41:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101a45:	66 85 c0             	test   %ax,%ax
80101a48:	75 0c                	jne    80101a56 <ilock+0x155>
      panic("ilock: no type");
80101a4a:	c7 04 24 63 8a 10 80 	movl   $0x80108a63,(%esp)
80101a51:	e8 e7 ea ff ff       	call   8010053d <panic>
  }
}
80101a56:	c9                   	leave  
80101a57:	c3                   	ret    

80101a58 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101a58:	55                   	push   %ebp
80101a59:	89 e5                	mov    %esp,%ebp
80101a5b:	83 ec 18             	sub    $0x18,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
80101a5e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101a62:	74 17                	je     80101a7b <iunlock+0x23>
80101a64:	8b 45 08             	mov    0x8(%ebp),%eax
80101a67:	8b 40 0c             	mov    0xc(%eax),%eax
80101a6a:	83 e0 01             	and    $0x1,%eax
80101a6d:	85 c0                	test   %eax,%eax
80101a6f:	74 0a                	je     80101a7b <iunlock+0x23>
80101a71:	8b 45 08             	mov    0x8(%ebp),%eax
80101a74:	8b 40 08             	mov    0x8(%eax),%eax
80101a77:	85 c0                	test   %eax,%eax
80101a79:	7f 0c                	jg     80101a87 <iunlock+0x2f>
    panic("iunlock");
80101a7b:	c7 04 24 72 8a 10 80 	movl   $0x80108a72,(%esp)
80101a82:	e8 b6 ea ff ff       	call   8010053d <panic>

  acquire(&icache.lock);
80101a87:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80101a8e:	e8 cc 34 00 00       	call   80104f5f <acquire>
  ip->flags &= ~I_BUSY;
80101a93:	8b 45 08             	mov    0x8(%ebp),%eax
80101a96:	8b 40 0c             	mov    0xc(%eax),%eax
80101a99:	89 c2                	mov    %eax,%edx
80101a9b:	83 e2 fe             	and    $0xfffffffe,%edx
80101a9e:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa1:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101aa4:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa7:	89 04 24             	mov    %eax,(%esp)
80101aaa:	e8 b2 32 00 00       	call   80104d61 <wakeup>
  release(&icache.lock);
80101aaf:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80101ab6:	e8 05 35 00 00       	call   80104fc0 <release>
}
80101abb:	c9                   	leave  
80101abc:	c3                   	ret    

80101abd <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101abd:	55                   	push   %ebp
80101abe:	89 e5                	mov    %esp,%ebp
80101ac0:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80101ac3:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80101aca:	e8 90 34 00 00       	call   80104f5f <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101acf:	8b 45 08             	mov    0x8(%ebp),%eax
80101ad2:	8b 40 08             	mov    0x8(%eax),%eax
80101ad5:	83 f8 01             	cmp    $0x1,%eax
80101ad8:	0f 85 93 00 00 00    	jne    80101b71 <iput+0xb4>
80101ade:	8b 45 08             	mov    0x8(%ebp),%eax
80101ae1:	8b 40 0c             	mov    0xc(%eax),%eax
80101ae4:	83 e0 02             	and    $0x2,%eax
80101ae7:	85 c0                	test   %eax,%eax
80101ae9:	0f 84 82 00 00 00    	je     80101b71 <iput+0xb4>
80101aef:	8b 45 08             	mov    0x8(%ebp),%eax
80101af2:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101af6:	66 85 c0             	test   %ax,%ax
80101af9:	75 76                	jne    80101b71 <iput+0xb4>
    // inode has no links and no other references: truncate and free.
    if(ip->flags & I_BUSY)
80101afb:	8b 45 08             	mov    0x8(%ebp),%eax
80101afe:	8b 40 0c             	mov    0xc(%eax),%eax
80101b01:	83 e0 01             	and    $0x1,%eax
80101b04:	84 c0                	test   %al,%al
80101b06:	74 0c                	je     80101b14 <iput+0x57>
      panic("iput busy");
80101b08:	c7 04 24 7a 8a 10 80 	movl   $0x80108a7a,(%esp)
80101b0f:	e8 29 ea ff ff       	call   8010053d <panic>
    ip->flags |= I_BUSY;
80101b14:	8b 45 08             	mov    0x8(%ebp),%eax
80101b17:	8b 40 0c             	mov    0xc(%eax),%eax
80101b1a:	89 c2                	mov    %eax,%edx
80101b1c:	83 ca 01             	or     $0x1,%edx
80101b1f:	8b 45 08             	mov    0x8(%ebp),%eax
80101b22:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101b25:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80101b2c:	e8 8f 34 00 00       	call   80104fc0 <release>
    itrunc(ip);
80101b31:	8b 45 08             	mov    0x8(%ebp),%eax
80101b34:	89 04 24             	mov    %eax,(%esp)
80101b37:	e8 72 01 00 00       	call   80101cae <itrunc>
    ip->type = 0;
80101b3c:	8b 45 08             	mov    0x8(%ebp),%eax
80101b3f:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101b45:	8b 45 08             	mov    0x8(%ebp),%eax
80101b48:	89 04 24             	mov    %eax,(%esp)
80101b4b:	e8 eb fb ff ff       	call   8010173b <iupdate>
    acquire(&icache.lock);
80101b50:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80101b57:	e8 03 34 00 00       	call   80104f5f <acquire>
    ip->flags = 0;
80101b5c:	8b 45 08             	mov    0x8(%ebp),%eax
80101b5f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101b66:	8b 45 08             	mov    0x8(%ebp),%eax
80101b69:	89 04 24             	mov    %eax,(%esp)
80101b6c:	e8 f0 31 00 00       	call   80104d61 <wakeup>
  }
  ip->ref--;
80101b71:	8b 45 08             	mov    0x8(%ebp),%eax
80101b74:	8b 40 08             	mov    0x8(%eax),%eax
80101b77:	8d 50 ff             	lea    -0x1(%eax),%edx
80101b7a:	8b 45 08             	mov    0x8(%ebp),%eax
80101b7d:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101b80:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80101b87:	e8 34 34 00 00       	call   80104fc0 <release>
}
80101b8c:	c9                   	leave  
80101b8d:	c3                   	ret    

80101b8e <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101b8e:	55                   	push   %ebp
80101b8f:	89 e5                	mov    %esp,%ebp
80101b91:	83 ec 18             	sub    $0x18,%esp
  iunlock(ip);
80101b94:	8b 45 08             	mov    0x8(%ebp),%eax
80101b97:	89 04 24             	mov    %eax,(%esp)
80101b9a:	e8 b9 fe ff ff       	call   80101a58 <iunlock>
  iput(ip);
80101b9f:	8b 45 08             	mov    0x8(%ebp),%eax
80101ba2:	89 04 24             	mov    %eax,(%esp)
80101ba5:	e8 13 ff ff ff       	call   80101abd <iput>
}
80101baa:	c9                   	leave  
80101bab:	c3                   	ret    

80101bac <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101bac:	55                   	push   %ebp
80101bad:	89 e5                	mov    %esp,%ebp
80101baf:	53                   	push   %ebx
80101bb0:	83 ec 24             	sub    $0x24,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101bb3:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101bb7:	77 3e                	ja     80101bf7 <bmap+0x4b>
    if((addr = ip->addrs[bn]) == 0)
80101bb9:	8b 55 0c             	mov    0xc(%ebp),%edx
80101bbc:	8b 45 08             	mov    0x8(%ebp),%eax
80101bbf:	83 c2 04             	add    $0x4,%edx
80101bc2:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101bc6:	89 45 ec             	mov    %eax,-0x14(%ebp)
80101bc9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80101bcd:	75 20                	jne    80101bef <bmap+0x43>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101bcf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80101bd2:	8b 45 08             	mov    0x8(%ebp),%eax
80101bd5:	8b 00                	mov    (%eax),%eax
80101bd7:	89 04 24             	mov    %eax,(%esp)
80101bda:	e8 d0 f7 ff ff       	call   801013af <balloc>
80101bdf:	89 45 ec             	mov    %eax,-0x14(%ebp)
80101be2:	8b 45 08             	mov    0x8(%ebp),%eax
80101be5:	8d 4b 04             	lea    0x4(%ebx),%ecx
80101be8:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101beb:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101bef:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101bf2:	e9 b1 00 00 00       	jmp    80101ca8 <bmap+0xfc>
  }
  bn -= NDIRECT;
80101bf7:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101bfb:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101bff:	0f 87 97 00 00 00    	ja     80101c9c <bmap+0xf0>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101c05:	8b 45 08             	mov    0x8(%ebp),%eax
80101c08:	8b 40 4c             	mov    0x4c(%eax),%eax
80101c0b:	89 45 ec             	mov    %eax,-0x14(%ebp)
80101c0e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80101c12:	75 19                	jne    80101c2d <bmap+0x81>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101c14:	8b 45 08             	mov    0x8(%ebp),%eax
80101c17:	8b 00                	mov    (%eax),%eax
80101c19:	89 04 24             	mov    %eax,(%esp)
80101c1c:	e8 8e f7 ff ff       	call   801013af <balloc>
80101c21:	89 45 ec             	mov    %eax,-0x14(%ebp)
80101c24:	8b 45 08             	mov    0x8(%ebp),%eax
80101c27:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101c2a:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101c2d:	8b 45 08             	mov    0x8(%ebp),%eax
80101c30:	8b 00                	mov    (%eax),%eax
80101c32:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101c35:	89 54 24 04          	mov    %edx,0x4(%esp)
80101c39:	89 04 24             	mov    %eax,(%esp)
80101c3c:	e8 66 e5 ff ff       	call   801001a7 <bread>
80101c41:	89 45 f4             	mov    %eax,-0xc(%ebp)
    a = (uint*)bp->data;
80101c44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c47:	83 c0 18             	add    $0x18,%eax
80101c4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((addr = a[bn]) == 0){
80101c4d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c50:	c1 e0 02             	shl    $0x2,%eax
80101c53:	03 45 f0             	add    -0x10(%ebp),%eax
80101c56:	8b 00                	mov    (%eax),%eax
80101c58:	89 45 ec             	mov    %eax,-0x14(%ebp)
80101c5b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80101c5f:	75 2b                	jne    80101c8c <bmap+0xe0>
      a[bn] = addr = balloc(ip->dev);
80101c61:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c64:	c1 e0 02             	shl    $0x2,%eax
80101c67:	89 c3                	mov    %eax,%ebx
80101c69:	03 5d f0             	add    -0x10(%ebp),%ebx
80101c6c:	8b 45 08             	mov    0x8(%ebp),%eax
80101c6f:	8b 00                	mov    (%eax),%eax
80101c71:	89 04 24             	mov    %eax,(%esp)
80101c74:	e8 36 f7 ff ff       	call   801013af <balloc>
80101c79:	89 45 ec             	mov    %eax,-0x14(%ebp)
80101c7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101c7f:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c84:	89 04 24             	mov    %eax,(%esp)
80101c87:	e8 70 1a 00 00       	call   801036fc <log_write>
    }
    brelse(bp);
80101c8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c8f:	89 04 24             	mov    %eax,(%esp)
80101c92:	e8 81 e5 ff ff       	call   80100218 <brelse>
    return addr;
80101c97:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101c9a:	eb 0c                	jmp    80101ca8 <bmap+0xfc>
  }

  panic("bmap: out of range");
80101c9c:	c7 04 24 84 8a 10 80 	movl   $0x80108a84,(%esp)
80101ca3:	e8 95 e8 ff ff       	call   8010053d <panic>
}
80101ca8:	83 c4 24             	add    $0x24,%esp
80101cab:	5b                   	pop    %ebx
80101cac:	5d                   	pop    %ebp
80101cad:	c3                   	ret    

80101cae <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101cae:	55                   	push   %ebp
80101caf:	89 e5                	mov    %esp,%ebp
80101cb1:	83 ec 28             	sub    $0x28,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101cb4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
80101cbb:	eb 44                	jmp    80101d01 <itrunc+0x53>
    if(ip->addrs[i]){
80101cbd:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101cc0:	8b 45 08             	mov    0x8(%ebp),%eax
80101cc3:	83 c2 04             	add    $0x4,%edx
80101cc6:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101cca:	85 c0                	test   %eax,%eax
80101ccc:	74 2f                	je     80101cfd <itrunc+0x4f>
      bfree(ip->dev, ip->addrs[i]);
80101cce:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101cd1:	8b 45 08             	mov    0x8(%ebp),%eax
80101cd4:	83 c2 04             	add    $0x4,%edx
80101cd7:	8b 54 90 0c          	mov    0xc(%eax,%edx,4),%edx
80101cdb:	8b 45 08             	mov    0x8(%ebp),%eax
80101cde:	8b 00                	mov    (%eax),%eax
80101ce0:	89 54 24 04          	mov    %edx,0x4(%esp)
80101ce4:	89 04 24             	mov    %eax,(%esp)
80101ce7:	e8 0f f8 ff ff       	call   801014fb <bfree>
      ip->addrs[i] = 0;
80101cec:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101cef:	8b 45 08             	mov    0x8(%ebp),%eax
80101cf2:	83 c2 04             	add    $0x4,%edx
80101cf5:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101cfc:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101cfd:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
80101d01:	83 7d e8 0b          	cmpl   $0xb,-0x18(%ebp)
80101d05:	7e b6                	jle    80101cbd <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101d07:	8b 45 08             	mov    0x8(%ebp),%eax
80101d0a:	8b 40 4c             	mov    0x4c(%eax),%eax
80101d0d:	85 c0                	test   %eax,%eax
80101d0f:	0f 84 8f 00 00 00    	je     80101da4 <itrunc+0xf6>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101d15:	8b 45 08             	mov    0x8(%ebp),%eax
80101d18:	8b 50 4c             	mov    0x4c(%eax),%edx
80101d1b:	8b 45 08             	mov    0x8(%ebp),%eax
80101d1e:	8b 00                	mov    (%eax),%eax
80101d20:	89 54 24 04          	mov    %edx,0x4(%esp)
80101d24:	89 04 24             	mov    %eax,(%esp)
80101d27:	e8 7b e4 ff ff       	call   801001a7 <bread>
80101d2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101d2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d32:	83 c0 18             	add    $0x18,%eax
80101d35:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101d38:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80101d3f:	eb 2f                	jmp    80101d70 <itrunc+0xc2>
      if(a[j])
80101d41:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d44:	c1 e0 02             	shl    $0x2,%eax
80101d47:	03 45 f4             	add    -0xc(%ebp),%eax
80101d4a:	8b 00                	mov    (%eax),%eax
80101d4c:	85 c0                	test   %eax,%eax
80101d4e:	74 1c                	je     80101d6c <itrunc+0xbe>
        bfree(ip->dev, a[j]);
80101d50:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d53:	c1 e0 02             	shl    $0x2,%eax
80101d56:	03 45 f4             	add    -0xc(%ebp),%eax
80101d59:	8b 10                	mov    (%eax),%edx
80101d5b:	8b 45 08             	mov    0x8(%ebp),%eax
80101d5e:	8b 00                	mov    (%eax),%eax
80101d60:	89 54 24 04          	mov    %edx,0x4(%esp)
80101d64:	89 04 24             	mov    %eax,(%esp)
80101d67:	e8 8f f7 ff ff       	call   801014fb <bfree>
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101d6c:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80101d70:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d73:	83 f8 7f             	cmp    $0x7f,%eax
80101d76:	76 c9                	jbe    80101d41 <itrunc+0x93>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101d78:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d7b:	89 04 24             	mov    %eax,(%esp)
80101d7e:	e8 95 e4 ff ff       	call   80100218 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101d83:	8b 45 08             	mov    0x8(%ebp),%eax
80101d86:	8b 50 4c             	mov    0x4c(%eax),%edx
80101d89:	8b 45 08             	mov    0x8(%ebp),%eax
80101d8c:	8b 00                	mov    (%eax),%eax
80101d8e:	89 54 24 04          	mov    %edx,0x4(%esp)
80101d92:	89 04 24             	mov    %eax,(%esp)
80101d95:	e8 61 f7 ff ff       	call   801014fb <bfree>
    ip->addrs[NDIRECT] = 0;
80101d9a:	8b 45 08             	mov    0x8(%ebp),%eax
80101d9d:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101da4:	8b 45 08             	mov    0x8(%ebp),%eax
80101da7:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101dae:	8b 45 08             	mov    0x8(%ebp),%eax
80101db1:	89 04 24             	mov    %eax,(%esp)
80101db4:	e8 82 f9 ff ff       	call   8010173b <iupdate>
}
80101db9:	c9                   	leave  
80101dba:	c3                   	ret    

80101dbb <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101dbb:	55                   	push   %ebp
80101dbc:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101dbe:	8b 45 08             	mov    0x8(%ebp),%eax
80101dc1:	8b 00                	mov    (%eax),%eax
80101dc3:	89 c2                	mov    %eax,%edx
80101dc5:	8b 45 0c             	mov    0xc(%ebp),%eax
80101dc8:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101dcb:	8b 45 08             	mov    0x8(%ebp),%eax
80101dce:	8b 50 04             	mov    0x4(%eax),%edx
80101dd1:	8b 45 0c             	mov    0xc(%ebp),%eax
80101dd4:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101dd7:	8b 45 08             	mov    0x8(%ebp),%eax
80101dda:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101dde:	8b 45 0c             	mov    0xc(%ebp),%eax
80101de1:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101de4:	8b 45 08             	mov    0x8(%ebp),%eax
80101de7:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101deb:	8b 45 0c             	mov    0xc(%ebp),%eax
80101dee:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101df2:	8b 45 08             	mov    0x8(%ebp),%eax
80101df5:	8b 50 18             	mov    0x18(%eax),%edx
80101df8:	8b 45 0c             	mov    0xc(%ebp),%eax
80101dfb:	89 50 10             	mov    %edx,0x10(%eax)
}
80101dfe:	5d                   	pop    %ebp
80101dff:	c3                   	ret    

80101e00 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101e00:	55                   	push   %ebp
80101e01:	89 e5                	mov    %esp,%ebp
80101e03:	53                   	push   %ebx
80101e04:	83 ec 24             	sub    $0x24,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101e07:	8b 45 08             	mov    0x8(%ebp),%eax
80101e0a:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101e0e:	66 83 f8 03          	cmp    $0x3,%ax
80101e12:	75 60                	jne    80101e74 <readi+0x74>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101e14:	8b 45 08             	mov    0x8(%ebp),%eax
80101e17:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101e1b:	66 85 c0             	test   %ax,%ax
80101e1e:	78 20                	js     80101e40 <readi+0x40>
80101e20:	8b 45 08             	mov    0x8(%ebp),%eax
80101e23:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101e27:	66 83 f8 09          	cmp    $0x9,%ax
80101e2b:	7f 13                	jg     80101e40 <readi+0x40>
80101e2d:	8b 45 08             	mov    0x8(%ebp),%eax
80101e30:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101e34:	98                   	cwtl   
80101e35:	8b 04 c5 e0 21 11 80 	mov    -0x7feede20(,%eax,8),%eax
80101e3c:	85 c0                	test   %eax,%eax
80101e3e:	75 0a                	jne    80101e4a <readi+0x4a>
      return -1;
80101e40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e45:	e9 1c 01 00 00       	jmp    80101f66 <readi+0x166>
    return devsw[ip->major].read(ip, dst, n);
80101e4a:	8b 45 08             	mov    0x8(%ebp),%eax
80101e4d:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101e51:	98                   	cwtl   
80101e52:	8b 14 c5 e0 21 11 80 	mov    -0x7feede20(,%eax,8),%edx
80101e59:	8b 45 14             	mov    0x14(%ebp),%eax
80101e5c:	89 44 24 08          	mov    %eax,0x8(%esp)
80101e60:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e63:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e67:	8b 45 08             	mov    0x8(%ebp),%eax
80101e6a:	89 04 24             	mov    %eax,(%esp)
80101e6d:	ff d2                	call   *%edx
80101e6f:	e9 f2 00 00 00       	jmp    80101f66 <readi+0x166>
  }

  if(off > ip->size || off + n < off)
80101e74:	8b 45 08             	mov    0x8(%ebp),%eax
80101e77:	8b 40 18             	mov    0x18(%eax),%eax
80101e7a:	3b 45 10             	cmp    0x10(%ebp),%eax
80101e7d:	72 0e                	jb     80101e8d <readi+0x8d>
80101e7f:	8b 45 14             	mov    0x14(%ebp),%eax
80101e82:	8b 55 10             	mov    0x10(%ebp),%edx
80101e85:	8d 04 02             	lea    (%edx,%eax,1),%eax
80101e88:	3b 45 10             	cmp    0x10(%ebp),%eax
80101e8b:	73 0a                	jae    80101e97 <readi+0x97>
    return -1;
80101e8d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e92:	e9 cf 00 00 00       	jmp    80101f66 <readi+0x166>
  if(off + n > ip->size)
80101e97:	8b 45 14             	mov    0x14(%ebp),%eax
80101e9a:	8b 55 10             	mov    0x10(%ebp),%edx
80101e9d:	01 c2                	add    %eax,%edx
80101e9f:	8b 45 08             	mov    0x8(%ebp),%eax
80101ea2:	8b 40 18             	mov    0x18(%eax),%eax
80101ea5:	39 c2                	cmp    %eax,%edx
80101ea7:	76 0c                	jbe    80101eb5 <readi+0xb5>
    n = ip->size - off;
80101ea9:	8b 45 08             	mov    0x8(%ebp),%eax
80101eac:	8b 40 18             	mov    0x18(%eax),%eax
80101eaf:	2b 45 10             	sub    0x10(%ebp),%eax
80101eb2:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101eb5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80101ebc:	e9 96 00 00 00       	jmp    80101f57 <readi+0x157>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ec1:	8b 45 10             	mov    0x10(%ebp),%eax
80101ec4:	c1 e8 09             	shr    $0x9,%eax
80101ec7:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ecb:	8b 45 08             	mov    0x8(%ebp),%eax
80101ece:	89 04 24             	mov    %eax,(%esp)
80101ed1:	e8 d6 fc ff ff       	call   80101bac <bmap>
80101ed6:	8b 55 08             	mov    0x8(%ebp),%edx
80101ed9:	8b 12                	mov    (%edx),%edx
80101edb:	89 44 24 04          	mov    %eax,0x4(%esp)
80101edf:	89 14 24             	mov    %edx,(%esp)
80101ee2:	e8 c0 e2 ff ff       	call   801001a7 <bread>
80101ee7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101eea:	8b 45 10             	mov    0x10(%ebp),%eax
80101eed:	89 c2                	mov    %eax,%edx
80101eef:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80101ef5:	b8 00 02 00 00       	mov    $0x200,%eax
80101efa:	89 c1                	mov    %eax,%ecx
80101efc:	29 d1                	sub    %edx,%ecx
80101efe:	89 ca                	mov    %ecx,%edx
80101f00:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f03:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101f06:	89 cb                	mov    %ecx,%ebx
80101f08:	29 c3                	sub    %eax,%ebx
80101f0a:	89 d8                	mov    %ebx,%eax
80101f0c:	39 c2                	cmp    %eax,%edx
80101f0e:	0f 46 c2             	cmovbe %edx,%eax
80101f11:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101f14:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101f17:	8d 50 18             	lea    0x18(%eax),%edx
80101f1a:	8b 45 10             	mov    0x10(%ebp),%eax
80101f1d:	25 ff 01 00 00       	and    $0x1ff,%eax
80101f22:	01 c2                	add    %eax,%edx
80101f24:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f27:	89 44 24 08          	mov    %eax,0x8(%esp)
80101f2b:	89 54 24 04          	mov    %edx,0x4(%esp)
80101f2f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f32:	89 04 24             	mov    %eax,(%esp)
80101f35:	e8 4f 33 00 00       	call   80105289 <memmove>
    brelse(bp);
80101f3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101f3d:	89 04 24             	mov    %eax,(%esp)
80101f40:	e8 d3 e2 ff ff       	call   80100218 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101f45:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f48:	01 45 ec             	add    %eax,-0x14(%ebp)
80101f4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f4e:	01 45 10             	add    %eax,0x10(%ebp)
80101f51:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f54:	01 45 0c             	add    %eax,0xc(%ebp)
80101f57:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f5a:	3b 45 14             	cmp    0x14(%ebp),%eax
80101f5d:	0f 82 5e ff ff ff    	jb     80101ec1 <readi+0xc1>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101f63:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101f66:	83 c4 24             	add    $0x24,%esp
80101f69:	5b                   	pop    %ebx
80101f6a:	5d                   	pop    %ebp
80101f6b:	c3                   	ret    

80101f6c <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101f6c:	55                   	push   %ebp
80101f6d:	89 e5                	mov    %esp,%ebp
80101f6f:	53                   	push   %ebx
80101f70:	83 ec 24             	sub    $0x24,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101f73:	8b 45 08             	mov    0x8(%ebp),%eax
80101f76:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101f7a:	66 83 f8 03          	cmp    $0x3,%ax
80101f7e:	75 60                	jne    80101fe0 <writei+0x74>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101f80:	8b 45 08             	mov    0x8(%ebp),%eax
80101f83:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f87:	66 85 c0             	test   %ax,%ax
80101f8a:	78 20                	js     80101fac <writei+0x40>
80101f8c:	8b 45 08             	mov    0x8(%ebp),%eax
80101f8f:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f93:	66 83 f8 09          	cmp    $0x9,%ax
80101f97:	7f 13                	jg     80101fac <writei+0x40>
80101f99:	8b 45 08             	mov    0x8(%ebp),%eax
80101f9c:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101fa0:	98                   	cwtl   
80101fa1:	8b 04 c5 e4 21 11 80 	mov    -0x7feede1c(,%eax,8),%eax
80101fa8:	85 c0                	test   %eax,%eax
80101faa:	75 0a                	jne    80101fb6 <writei+0x4a>
      return -1;
80101fac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fb1:	e9 48 01 00 00       	jmp    801020fe <writei+0x192>
    return devsw[ip->major].write(ip, src, n);
80101fb6:	8b 45 08             	mov    0x8(%ebp),%eax
80101fb9:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101fbd:	98                   	cwtl   
80101fbe:	8b 14 c5 e4 21 11 80 	mov    -0x7feede1c(,%eax,8),%edx
80101fc5:	8b 45 14             	mov    0x14(%ebp),%eax
80101fc8:	89 44 24 08          	mov    %eax,0x8(%esp)
80101fcc:	8b 45 0c             	mov    0xc(%ebp),%eax
80101fcf:	89 44 24 04          	mov    %eax,0x4(%esp)
80101fd3:	8b 45 08             	mov    0x8(%ebp),%eax
80101fd6:	89 04 24             	mov    %eax,(%esp)
80101fd9:	ff d2                	call   *%edx
80101fdb:	e9 1e 01 00 00       	jmp    801020fe <writei+0x192>
  }

  if(off > ip->size || off + n < off)
80101fe0:	8b 45 08             	mov    0x8(%ebp),%eax
80101fe3:	8b 40 18             	mov    0x18(%eax),%eax
80101fe6:	3b 45 10             	cmp    0x10(%ebp),%eax
80101fe9:	72 0e                	jb     80101ff9 <writei+0x8d>
80101feb:	8b 45 14             	mov    0x14(%ebp),%eax
80101fee:	8b 55 10             	mov    0x10(%ebp),%edx
80101ff1:	8d 04 02             	lea    (%edx,%eax,1),%eax
80101ff4:	3b 45 10             	cmp    0x10(%ebp),%eax
80101ff7:	73 0a                	jae    80102003 <writei+0x97>
    return -1;
80101ff9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ffe:	e9 fb 00 00 00       	jmp    801020fe <writei+0x192>
  if(off + n > MAXFILE*BSIZE)
80102003:	8b 45 14             	mov    0x14(%ebp),%eax
80102006:	8b 55 10             	mov    0x10(%ebp),%edx
80102009:	8d 04 02             	lea    (%edx,%eax,1),%eax
8010200c:	3d 00 18 01 00       	cmp    $0x11800,%eax
80102011:	76 0a                	jbe    8010201d <writei+0xb1>
    return -1;
80102013:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102018:	e9 e1 00 00 00       	jmp    801020fe <writei+0x192>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010201d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80102024:	e9 a1 00 00 00       	jmp    801020ca <writei+0x15e>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102029:	8b 45 10             	mov    0x10(%ebp),%eax
8010202c:	c1 e8 09             	shr    $0x9,%eax
8010202f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102033:	8b 45 08             	mov    0x8(%ebp),%eax
80102036:	89 04 24             	mov    %eax,(%esp)
80102039:	e8 6e fb ff ff       	call   80101bac <bmap>
8010203e:	8b 55 08             	mov    0x8(%ebp),%edx
80102041:	8b 12                	mov    (%edx),%edx
80102043:	89 44 24 04          	mov    %eax,0x4(%esp)
80102047:	89 14 24             	mov    %edx,(%esp)
8010204a:	e8 58 e1 ff ff       	call   801001a7 <bread>
8010204f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102052:	8b 45 10             	mov    0x10(%ebp),%eax
80102055:	89 c2                	mov    %eax,%edx
80102057:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010205d:	b8 00 02 00 00       	mov    $0x200,%eax
80102062:	89 c1                	mov    %eax,%ecx
80102064:	29 d1                	sub    %edx,%ecx
80102066:	89 ca                	mov    %ecx,%edx
80102068:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010206b:	8b 4d 14             	mov    0x14(%ebp),%ecx
8010206e:	89 cb                	mov    %ecx,%ebx
80102070:	29 c3                	sub    %eax,%ebx
80102072:	89 d8                	mov    %ebx,%eax
80102074:	39 c2                	cmp    %eax,%edx
80102076:	0f 46 c2             	cmovbe %edx,%eax
80102079:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
8010207c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010207f:	8d 50 18             	lea    0x18(%eax),%edx
80102082:	8b 45 10             	mov    0x10(%ebp),%eax
80102085:	25 ff 01 00 00       	and    $0x1ff,%eax
8010208a:	01 c2                	add    %eax,%edx
8010208c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010208f:	89 44 24 08          	mov    %eax,0x8(%esp)
80102093:	8b 45 0c             	mov    0xc(%ebp),%eax
80102096:	89 44 24 04          	mov    %eax,0x4(%esp)
8010209a:	89 14 24             	mov    %edx,(%esp)
8010209d:	e8 e7 31 00 00       	call   80105289 <memmove>
    log_write(bp);
801020a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801020a5:	89 04 24             	mov    %eax,(%esp)
801020a8:	e8 4f 16 00 00       	call   801036fc <log_write>
    brelse(bp);
801020ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801020b0:	89 04 24             	mov    %eax,(%esp)
801020b3:	e8 60 e1 ff ff       	call   80100218 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801020b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801020bb:	01 45 ec             	add    %eax,-0x14(%ebp)
801020be:	8b 45 f0             	mov    -0x10(%ebp),%eax
801020c1:	01 45 10             	add    %eax,0x10(%ebp)
801020c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801020c7:	01 45 0c             	add    %eax,0xc(%ebp)
801020ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020cd:	3b 45 14             	cmp    0x14(%ebp),%eax
801020d0:	0f 82 53 ff ff ff    	jb     80102029 <writei+0xbd>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
801020d6:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801020da:	74 1f                	je     801020fb <writei+0x18f>
801020dc:	8b 45 08             	mov    0x8(%ebp),%eax
801020df:	8b 40 18             	mov    0x18(%eax),%eax
801020e2:	3b 45 10             	cmp    0x10(%ebp),%eax
801020e5:	73 14                	jae    801020fb <writei+0x18f>
    ip->size = off;
801020e7:	8b 45 08             	mov    0x8(%ebp),%eax
801020ea:	8b 55 10             	mov    0x10(%ebp),%edx
801020ed:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
801020f0:	8b 45 08             	mov    0x8(%ebp),%eax
801020f3:	89 04 24             	mov    %eax,(%esp)
801020f6:	e8 40 f6 ff ff       	call   8010173b <iupdate>
  }
  return n;
801020fb:	8b 45 14             	mov    0x14(%ebp),%eax
}
801020fe:	83 c4 24             	add    $0x24,%esp
80102101:	5b                   	pop    %ebx
80102102:	5d                   	pop    %ebp
80102103:	c3                   	ret    

80102104 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102104:	55                   	push   %ebp
80102105:	89 e5                	mov    %esp,%ebp
80102107:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
8010210a:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80102111:	00 
80102112:	8b 45 0c             	mov    0xc(%ebp),%eax
80102115:	89 44 24 04          	mov    %eax,0x4(%esp)
80102119:	8b 45 08             	mov    0x8(%ebp),%eax
8010211c:	89 04 24             	mov    %eax,(%esp)
8010211f:	e8 0d 32 00 00       	call   80105331 <strncmp>
}
80102124:	c9                   	leave  
80102125:	c3                   	ret    

80102126 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102126:	55                   	push   %ebp
80102127:	89 e5                	mov    %esp,%ebp
80102129:	83 ec 38             	sub    $0x38,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
8010212c:	8b 45 08             	mov    0x8(%ebp),%eax
8010212f:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102133:	66 83 f8 01          	cmp    $0x1,%ax
80102137:	74 0c                	je     80102145 <dirlookup+0x1f>
    panic("dirlookup not DIR");
80102139:	c7 04 24 97 8a 10 80 	movl   $0x80108a97,(%esp)
80102140:	e8 f8 e3 ff ff       	call   8010053d <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
80102145:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010214c:	e9 87 00 00 00       	jmp    801021d8 <dirlookup+0xb2>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102151:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102154:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
8010215b:	00 
8010215c:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010215f:	89 54 24 08          	mov    %edx,0x8(%esp)
80102163:	89 44 24 04          	mov    %eax,0x4(%esp)
80102167:	8b 45 08             	mov    0x8(%ebp),%eax
8010216a:	89 04 24             	mov    %eax,(%esp)
8010216d:	e8 8e fc ff ff       	call   80101e00 <readi>
80102172:	83 f8 10             	cmp    $0x10,%eax
80102175:	74 0c                	je     80102183 <dirlookup+0x5d>
      panic("dirlink read");
80102177:	c7 04 24 a9 8a 10 80 	movl   $0x80108aa9,(%esp)
8010217e:	e8 ba e3 ff ff       	call   8010053d <panic>
    if(de.inum == 0)
80102183:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102187:	66 85 c0             	test   %ax,%ax
8010218a:	74 47                	je     801021d3 <dirlookup+0xad>
      continue;
    if(namecmp(name, de.name) == 0){
8010218c:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010218f:	83 c0 02             	add    $0x2,%eax
80102192:	89 44 24 04          	mov    %eax,0x4(%esp)
80102196:	8b 45 0c             	mov    0xc(%ebp),%eax
80102199:	89 04 24             	mov    %eax,(%esp)
8010219c:	e8 63 ff ff ff       	call   80102104 <namecmp>
801021a1:	85 c0                	test   %eax,%eax
801021a3:	75 2f                	jne    801021d4 <dirlookup+0xae>
      // entry matches path element
      if(poff)
801021a5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801021a9:	74 08                	je     801021b3 <dirlookup+0x8d>
        *poff = off;
801021ab:	8b 45 10             	mov    0x10(%ebp),%eax
801021ae:	8b 55 f0             	mov    -0x10(%ebp),%edx
801021b1:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
801021b3:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801021b7:	0f b7 c0             	movzwl %ax,%eax
801021ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return iget(dp->dev, inum);
801021bd:	8b 45 08             	mov    0x8(%ebp),%eax
801021c0:	8b 00                	mov    (%eax),%eax
801021c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801021c5:	89 54 24 04          	mov    %edx,0x4(%esp)
801021c9:	89 04 24             	mov    %eax,(%esp)
801021cc:	e8 2b f6 ff ff       	call   801017fc <iget>
801021d1:	eb 19                	jmp    801021ec <dirlookup+0xc6>

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
801021d3:	90                   	nop
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
801021d4:	83 45 f0 10          	addl   $0x10,-0x10(%ebp)
801021d8:	8b 45 08             	mov    0x8(%ebp),%eax
801021db:	8b 40 18             	mov    0x18(%eax),%eax
801021de:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801021e1:	0f 87 6a ff ff ff    	ja     80102151 <dirlookup+0x2b>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
801021e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
801021ec:	c9                   	leave  
801021ed:	c3                   	ret    

801021ee <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
801021ee:	55                   	push   %ebp
801021ef:	89 e5                	mov    %esp,%ebp
801021f1:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
801021f4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801021fb:	00 
801021fc:	8b 45 0c             	mov    0xc(%ebp),%eax
801021ff:	89 44 24 04          	mov    %eax,0x4(%esp)
80102203:	8b 45 08             	mov    0x8(%ebp),%eax
80102206:	89 04 24             	mov    %eax,(%esp)
80102209:	e8 18 ff ff ff       	call   80102126 <dirlookup>
8010220e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102211:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102215:	74 15                	je     8010222c <dirlink+0x3e>
    iput(ip);
80102217:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010221a:	89 04 24             	mov    %eax,(%esp)
8010221d:	e8 9b f8 ff ff       	call   80101abd <iput>
    return -1;
80102222:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102227:	e9 b8 00 00 00       	jmp    801022e4 <dirlink+0xf6>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
8010222c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80102233:	eb 44                	jmp    80102279 <dirlink+0x8b>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102235:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102238:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010223b:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80102242:	00 
80102243:	89 54 24 08          	mov    %edx,0x8(%esp)
80102247:	89 44 24 04          	mov    %eax,0x4(%esp)
8010224b:	8b 45 08             	mov    0x8(%ebp),%eax
8010224e:	89 04 24             	mov    %eax,(%esp)
80102251:	e8 aa fb ff ff       	call   80101e00 <readi>
80102256:	83 f8 10             	cmp    $0x10,%eax
80102259:	74 0c                	je     80102267 <dirlink+0x79>
      panic("dirlink read");
8010225b:	c7 04 24 a9 8a 10 80 	movl   $0x80108aa9,(%esp)
80102262:	e8 d6 e2 ff ff       	call   8010053d <panic>
    if(de.inum == 0)
80102267:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010226b:	66 85 c0             	test   %ax,%ax
8010226e:	74 18                	je     80102288 <dirlink+0x9a>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102270:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102273:	83 c0 10             	add    $0x10,%eax
80102276:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102279:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010227c:	8b 45 08             	mov    0x8(%ebp),%eax
8010227f:	8b 40 18             	mov    0x18(%eax),%eax
80102282:	39 c2                	cmp    %eax,%edx
80102284:	72 af                	jb     80102235 <dirlink+0x47>
80102286:	eb 01                	jmp    80102289 <dirlink+0x9b>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      break;
80102288:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
80102289:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80102290:	00 
80102291:	8b 45 0c             	mov    0xc(%ebp),%eax
80102294:	89 44 24 04          	mov    %eax,0x4(%esp)
80102298:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010229b:	83 c0 02             	add    $0x2,%eax
8010229e:	89 04 24             	mov    %eax,(%esp)
801022a1:	e8 e3 30 00 00       	call   80105389 <strncpy>
  de.inum = inum;
801022a6:	8b 45 10             	mov    0x10(%ebp),%eax
801022a9:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801022ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
801022b0:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022b3:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801022ba:	00 
801022bb:	89 54 24 08          	mov    %edx,0x8(%esp)
801022bf:	89 44 24 04          	mov    %eax,0x4(%esp)
801022c3:	8b 45 08             	mov    0x8(%ebp),%eax
801022c6:	89 04 24             	mov    %eax,(%esp)
801022c9:	e8 9e fc ff ff       	call   80101f6c <writei>
801022ce:	83 f8 10             	cmp    $0x10,%eax
801022d1:	74 0c                	je     801022df <dirlink+0xf1>
    panic("dirlink");
801022d3:	c7 04 24 b6 8a 10 80 	movl   $0x80108ab6,(%esp)
801022da:	e8 5e e2 ff ff       	call   8010053d <panic>
  
  return 0;
801022df:	b8 00 00 00 00       	mov    $0x0,%eax
}
801022e4:	c9                   	leave  
801022e5:	c3                   	ret    

801022e6 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
801022e6:	55                   	push   %ebp
801022e7:	89 e5                	mov    %esp,%ebp
801022e9:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int len;

  while(*path == '/')
801022ec:	eb 04                	jmp    801022f2 <skipelem+0xc>
    path++;
801022ee:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
801022f2:	8b 45 08             	mov    0x8(%ebp),%eax
801022f5:	0f b6 00             	movzbl (%eax),%eax
801022f8:	3c 2f                	cmp    $0x2f,%al
801022fa:	74 f2                	je     801022ee <skipelem+0x8>
    path++;
  if(*path == 0)
801022fc:	8b 45 08             	mov    0x8(%ebp),%eax
801022ff:	0f b6 00             	movzbl (%eax),%eax
80102302:	84 c0                	test   %al,%al
80102304:	75 0a                	jne    80102310 <skipelem+0x2a>
    return 0;
80102306:	b8 00 00 00 00       	mov    $0x0,%eax
8010230b:	e9 86 00 00 00       	jmp    80102396 <skipelem+0xb0>
  s = path;
80102310:	8b 45 08             	mov    0x8(%ebp),%eax
80102313:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while(*path != '/' && *path != 0)
80102316:	eb 04                	jmp    8010231c <skipelem+0x36>
    path++;
80102318:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
8010231c:	8b 45 08             	mov    0x8(%ebp),%eax
8010231f:	0f b6 00             	movzbl (%eax),%eax
80102322:	3c 2f                	cmp    $0x2f,%al
80102324:	74 0a                	je     80102330 <skipelem+0x4a>
80102326:	8b 45 08             	mov    0x8(%ebp),%eax
80102329:	0f b6 00             	movzbl (%eax),%eax
8010232c:	84 c0                	test   %al,%al
8010232e:	75 e8                	jne    80102318 <skipelem+0x32>
    path++;
  len = path - s;
80102330:	8b 55 08             	mov    0x8(%ebp),%edx
80102333:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102336:	89 d1                	mov    %edx,%ecx
80102338:	29 c1                	sub    %eax,%ecx
8010233a:	89 c8                	mov    %ecx,%eax
8010233c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(len >= DIRSIZ)
8010233f:	83 7d f4 0d          	cmpl   $0xd,-0xc(%ebp)
80102343:	7e 1c                	jle    80102361 <skipelem+0x7b>
    memmove(name, s, DIRSIZ);
80102345:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
8010234c:	00 
8010234d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102350:	89 44 24 04          	mov    %eax,0x4(%esp)
80102354:	8b 45 0c             	mov    0xc(%ebp),%eax
80102357:	89 04 24             	mov    %eax,(%esp)
8010235a:	e8 2a 2f 00 00       	call   80105289 <memmove>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
8010235f:	eb 28                	jmp    80102389 <skipelem+0xa3>
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80102361:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102364:	89 44 24 08          	mov    %eax,0x8(%esp)
80102368:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010236b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010236f:	8b 45 0c             	mov    0xc(%ebp),%eax
80102372:	89 04 24             	mov    %eax,(%esp)
80102375:	e8 0f 2f 00 00       	call   80105289 <memmove>
    name[len] = 0;
8010237a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010237d:	03 45 0c             	add    0xc(%ebp),%eax
80102380:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
80102383:	eb 04                	jmp    80102389 <skipelem+0xa3>
    path++;
80102385:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80102389:	8b 45 08             	mov    0x8(%ebp),%eax
8010238c:	0f b6 00             	movzbl (%eax),%eax
8010238f:	3c 2f                	cmp    $0x2f,%al
80102391:	74 f2                	je     80102385 <skipelem+0x9f>
    path++;
  return path;
80102393:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102396:	c9                   	leave  
80102397:	c3                   	ret    

80102398 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102398:	55                   	push   %ebp
80102399:	89 e5                	mov    %esp,%ebp
8010239b:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010239e:	8b 45 08             	mov    0x8(%ebp),%eax
801023a1:	0f b6 00             	movzbl (%eax),%eax
801023a4:	3c 2f                	cmp    $0x2f,%al
801023a6:	75 1c                	jne    801023c4 <namex+0x2c>
    ip = iget(ROOTDEV, ROOTINO);
801023a8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801023af:	00 
801023b0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801023b7:	e8 40 f4 ff ff       	call   801017fc <iget>
801023bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
801023bf:	e9 af 00 00 00       	jmp    80102473 <namex+0xdb>
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
801023c4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801023ca:	8b 40 68             	mov    0x68(%eax),%eax
801023cd:	89 04 24             	mov    %eax,(%esp)
801023d0:	e8 fa f4 ff ff       	call   801018cf <idup>
801023d5:	89 45 f0             	mov    %eax,-0x10(%ebp)

  while((path = skipelem(path, name)) != 0){
801023d8:	e9 96 00 00 00       	jmp    80102473 <namex+0xdb>
    ilock(ip);
801023dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023e0:	89 04 24             	mov    %eax,(%esp)
801023e3:	e8 19 f5 ff ff       	call   80101901 <ilock>
    if(ip->type != T_DIR){
801023e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023eb:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801023ef:	66 83 f8 01          	cmp    $0x1,%ax
801023f3:	74 15                	je     8010240a <namex+0x72>
      iunlockput(ip);
801023f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023f8:	89 04 24             	mov    %eax,(%esp)
801023fb:	e8 8e f7 ff ff       	call   80101b8e <iunlockput>
      return 0;
80102400:	b8 00 00 00 00       	mov    $0x0,%eax
80102405:	e9 a3 00 00 00       	jmp    801024ad <namex+0x115>
    }
    if(nameiparent && *path == '\0'){
8010240a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010240e:	74 1d                	je     8010242d <namex+0x95>
80102410:	8b 45 08             	mov    0x8(%ebp),%eax
80102413:	0f b6 00             	movzbl (%eax),%eax
80102416:	84 c0                	test   %al,%al
80102418:	75 13                	jne    8010242d <namex+0x95>
      // Stop one level early.
      iunlock(ip);
8010241a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010241d:	89 04 24             	mov    %eax,(%esp)
80102420:	e8 33 f6 ff ff       	call   80101a58 <iunlock>
      return ip;
80102425:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102428:	e9 80 00 00 00       	jmp    801024ad <namex+0x115>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
8010242d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80102434:	00 
80102435:	8b 45 10             	mov    0x10(%ebp),%eax
80102438:	89 44 24 04          	mov    %eax,0x4(%esp)
8010243c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010243f:	89 04 24             	mov    %eax,(%esp)
80102442:	e8 df fc ff ff       	call   80102126 <dirlookup>
80102447:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010244a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010244e:	75 12                	jne    80102462 <namex+0xca>
      iunlockput(ip);
80102450:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102453:	89 04 24             	mov    %eax,(%esp)
80102456:	e8 33 f7 ff ff       	call   80101b8e <iunlockput>
      return 0;
8010245b:	b8 00 00 00 00       	mov    $0x0,%eax
80102460:	eb 4b                	jmp    801024ad <namex+0x115>
    }
    iunlockput(ip);
80102462:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102465:	89 04 24             	mov    %eax,(%esp)
80102468:	e8 21 f7 ff ff       	call   80101b8e <iunlockput>
    ip = next;
8010246d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102470:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
80102473:	8b 45 10             	mov    0x10(%ebp),%eax
80102476:	89 44 24 04          	mov    %eax,0x4(%esp)
8010247a:	8b 45 08             	mov    0x8(%ebp),%eax
8010247d:	89 04 24             	mov    %eax,(%esp)
80102480:	e8 61 fe ff ff       	call   801022e6 <skipelem>
80102485:	89 45 08             	mov    %eax,0x8(%ebp)
80102488:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010248c:	0f 85 4b ff ff ff    	jne    801023dd <namex+0x45>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102492:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102496:	74 12                	je     801024aa <namex+0x112>
    iput(ip);
80102498:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010249b:	89 04 24             	mov    %eax,(%esp)
8010249e:	e8 1a f6 ff ff       	call   80101abd <iput>
    return 0;
801024a3:	b8 00 00 00 00       	mov    $0x0,%eax
801024a8:	eb 03                	jmp    801024ad <namex+0x115>
  }
  return ip;
801024aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801024ad:	c9                   	leave  
801024ae:	c3                   	ret    

801024af <namei>:

struct inode*
namei(char *path)
{
801024af:	55                   	push   %ebp
801024b0:	89 e5                	mov    %esp,%ebp
801024b2:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
801024b5:	8d 45 ea             	lea    -0x16(%ebp),%eax
801024b8:	89 44 24 08          	mov    %eax,0x8(%esp)
801024bc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801024c3:	00 
801024c4:	8b 45 08             	mov    0x8(%ebp),%eax
801024c7:	89 04 24             	mov    %eax,(%esp)
801024ca:	e8 c9 fe ff ff       	call   80102398 <namex>
}
801024cf:	c9                   	leave  
801024d0:	c3                   	ret    

801024d1 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801024d1:	55                   	push   %ebp
801024d2:	89 e5                	mov    %esp,%ebp
801024d4:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 1, name);
801024d7:	8b 45 0c             	mov    0xc(%ebp),%eax
801024da:	89 44 24 08          	mov    %eax,0x8(%esp)
801024de:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801024e5:	00 
801024e6:	8b 45 08             	mov    0x8(%ebp),%eax
801024e9:	89 04 24             	mov    %eax,(%esp)
801024ec:	e8 a7 fe ff ff       	call   80102398 <namex>
}
801024f1:	c9                   	leave  
801024f2:	c3                   	ret    
	...

801024f4 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801024f4:	55                   	push   %ebp
801024f5:	89 e5                	mov    %esp,%ebp
801024f7:	83 ec 14             	sub    $0x14,%esp
801024fa:	8b 45 08             	mov    0x8(%ebp),%eax
801024fd:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102501:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102505:	89 c2                	mov    %eax,%edx
80102507:	ec                   	in     (%dx),%al
80102508:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010250b:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
8010250f:	c9                   	leave  
80102510:	c3                   	ret    

80102511 <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
80102511:	55                   	push   %ebp
80102512:	89 e5                	mov    %esp,%ebp
80102514:	57                   	push   %edi
80102515:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
80102516:	8b 55 08             	mov    0x8(%ebp),%edx
80102519:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010251c:	8b 45 10             	mov    0x10(%ebp),%eax
8010251f:	89 cb                	mov    %ecx,%ebx
80102521:	89 df                	mov    %ebx,%edi
80102523:	89 c1                	mov    %eax,%ecx
80102525:	fc                   	cld    
80102526:	f3 6d                	rep insl (%dx),%es:(%edi)
80102528:	89 c8                	mov    %ecx,%eax
8010252a:	89 fb                	mov    %edi,%ebx
8010252c:	89 5d 0c             	mov    %ebx,0xc(%ebp)
8010252f:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
80102532:	5b                   	pop    %ebx
80102533:	5f                   	pop    %edi
80102534:	5d                   	pop    %ebp
80102535:	c3                   	ret    

80102536 <outb>:

static inline void
outb(ushort port, uchar data)
{
80102536:	55                   	push   %ebp
80102537:	89 e5                	mov    %esp,%ebp
80102539:	83 ec 08             	sub    $0x8,%esp
8010253c:	8b 55 08             	mov    0x8(%ebp),%edx
8010253f:	8b 45 0c             	mov    0xc(%ebp),%eax
80102542:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102546:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102549:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010254d:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102551:	ee                   	out    %al,(%dx)
}
80102552:	c9                   	leave  
80102553:	c3                   	ret    

80102554 <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
80102554:	55                   	push   %ebp
80102555:	89 e5                	mov    %esp,%ebp
80102557:	56                   	push   %esi
80102558:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
80102559:	8b 55 08             	mov    0x8(%ebp),%edx
8010255c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010255f:	8b 45 10             	mov    0x10(%ebp),%eax
80102562:	89 cb                	mov    %ecx,%ebx
80102564:	89 de                	mov    %ebx,%esi
80102566:	89 c1                	mov    %eax,%ecx
80102568:	fc                   	cld    
80102569:	f3 6f                	rep outsl %ds:(%esi),(%dx)
8010256b:	89 c8                	mov    %ecx,%eax
8010256d:	89 f3                	mov    %esi,%ebx
8010256f:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102572:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
80102575:	5b                   	pop    %ebx
80102576:	5e                   	pop    %esi
80102577:	5d                   	pop    %ebp
80102578:	c3                   	ret    

80102579 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80102579:	55                   	push   %ebp
8010257a:	89 e5                	mov    %esp,%ebp
8010257c:	83 ec 14             	sub    $0x14,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
8010257f:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102586:	e8 69 ff ff ff       	call   801024f4 <inb>
8010258b:	0f b6 c0             	movzbl %al,%eax
8010258e:	89 45 fc             	mov    %eax,-0x4(%ebp)
80102591:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102594:	25 c0 00 00 00       	and    $0xc0,%eax
80102599:	83 f8 40             	cmp    $0x40,%eax
8010259c:	75 e1                	jne    8010257f <idewait+0x6>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010259e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801025a2:	74 11                	je     801025b5 <idewait+0x3c>
801025a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
801025a7:	83 e0 21             	and    $0x21,%eax
801025aa:	85 c0                	test   %eax,%eax
801025ac:	74 07                	je     801025b5 <idewait+0x3c>
    return -1;
801025ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801025b3:	eb 05                	jmp    801025ba <idewait+0x41>
  return 0;
801025b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
801025ba:	c9                   	leave  
801025bb:	c3                   	ret    

801025bc <ideinit>:

void
ideinit(void)
{
801025bc:	55                   	push   %ebp
801025bd:	89 e5                	mov    %esp,%ebp
801025bf:	83 ec 28             	sub    $0x28,%esp
  int i;
  
  initlock(&idelock, "ide");
801025c2:	c7 44 24 04 be 8a 10 	movl   $0x80108abe,0x4(%esp)
801025c9:	80 
801025ca:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
801025d1:	e8 68 29 00 00       	call   80104f3e <initlock>
  picenable(IRQ_IDE);
801025d6:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
801025dd:	e8 b3 18 00 00       	call   80103e95 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
801025e2:	a1 60 39 11 80       	mov    0x80113960,%eax
801025e7:	83 e8 01             	sub    $0x1,%eax
801025ea:	89 44 24 04          	mov    %eax,0x4(%esp)
801025ee:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
801025f5:	e8 48 04 00 00       	call   80102a42 <ioapicenable>
  idewait(0);
801025fa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80102601:	e8 73 ff ff ff       	call   80102579 <idewait>
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
80102606:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
8010260d:	00 
8010260e:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
80102615:	e8 1c ff ff ff       	call   80102536 <outb>
  for(i=0; i<1000; i++){
8010261a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102621:	eb 20                	jmp    80102643 <ideinit+0x87>
    if(inb(0x1f7) != 0){
80102623:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
8010262a:	e8 c5 fe ff ff       	call   801024f4 <inb>
8010262f:	84 c0                	test   %al,%al
80102631:	74 0c                	je     8010263f <ideinit+0x83>
      havedisk1 = 1;
80102633:	c7 05 58 c6 10 80 01 	movl   $0x1,0x8010c658
8010263a:	00 00 00 
      break;
8010263d:	eb 0d                	jmp    8010264c <ideinit+0x90>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
8010263f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102643:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
8010264a:	7e d7                	jle    80102623 <ideinit+0x67>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
8010264c:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
80102653:	00 
80102654:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
8010265b:	e8 d6 fe ff ff       	call   80102536 <outb>
}
80102660:	c9                   	leave  
80102661:	c3                   	ret    

80102662 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102662:	55                   	push   %ebp
80102663:	89 e5                	mov    %esp,%ebp
80102665:	83 ec 28             	sub    $0x28,%esp
  if(b == 0)
80102668:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010266c:	75 0c                	jne    8010267a <idestart+0x18>
    panic("idestart");
8010266e:	c7 04 24 c2 8a 10 80 	movl   $0x80108ac2,(%esp)
80102675:	e8 c3 de ff ff       	call   8010053d <panic>
  if(b->blockno >= FSSIZE)
8010267a:	8b 45 08             	mov    0x8(%ebp),%eax
8010267d:	8b 40 08             	mov    0x8(%eax),%eax
80102680:	3d e7 03 00 00       	cmp    $0x3e7,%eax
80102685:	76 0c                	jbe    80102693 <idestart+0x31>
    panic("incorrect blockno");
80102687:	c7 04 24 cb 8a 10 80 	movl   $0x80108acb,(%esp)
8010268e:	e8 aa de ff ff       	call   8010053d <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
80102693:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  int sector = b->blockno * sector_per_block;
8010269a:	8b 45 08             	mov    0x8(%ebp),%eax
8010269d:	8b 50 08             	mov    0x8(%eax),%edx
801026a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801026a3:	0f af c2             	imul   %edx,%eax
801026a6:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if (sector_per_block > 7) panic("idestart");
801026a9:	83 7d f0 07          	cmpl   $0x7,-0x10(%ebp)
801026ad:	7e 0c                	jle    801026bb <idestart+0x59>
801026af:	c7 04 24 c2 8a 10 80 	movl   $0x80108ac2,(%esp)
801026b6:	e8 82 de ff ff       	call   8010053d <panic>
  
  idewait(0);
801026bb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801026c2:	e8 b2 fe ff ff       	call   80102579 <idewait>
  outb(0x3f6, 0);  // generate interrupt
801026c7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801026ce:	00 
801026cf:	c7 04 24 f6 03 00 00 	movl   $0x3f6,(%esp)
801026d6:	e8 5b fe ff ff       	call   80102536 <outb>
  outb(0x1f2, sector_per_block);  // number of sectors
801026db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801026de:	0f b6 c0             	movzbl %al,%eax
801026e1:	89 44 24 04          	mov    %eax,0x4(%esp)
801026e5:	c7 04 24 f2 01 00 00 	movl   $0x1f2,(%esp)
801026ec:	e8 45 fe ff ff       	call   80102536 <outb>
  outb(0x1f3, sector & 0xff);
801026f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801026f4:	0f b6 c0             	movzbl %al,%eax
801026f7:	89 44 24 04          	mov    %eax,0x4(%esp)
801026fb:	c7 04 24 f3 01 00 00 	movl   $0x1f3,(%esp)
80102702:	e8 2f fe ff ff       	call   80102536 <outb>
  outb(0x1f4, (sector >> 8) & 0xff);
80102707:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010270a:	c1 f8 08             	sar    $0x8,%eax
8010270d:	0f b6 c0             	movzbl %al,%eax
80102710:	89 44 24 04          	mov    %eax,0x4(%esp)
80102714:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
8010271b:	e8 16 fe ff ff       	call   80102536 <outb>
  outb(0x1f5, (sector >> 16) & 0xff);
80102720:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102723:	c1 f8 10             	sar    $0x10,%eax
80102726:	0f b6 c0             	movzbl %al,%eax
80102729:	89 44 24 04          	mov    %eax,0x4(%esp)
8010272d:	c7 04 24 f5 01 00 00 	movl   $0x1f5,(%esp)
80102734:	e8 fd fd ff ff       	call   80102536 <outb>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80102739:	8b 45 08             	mov    0x8(%ebp),%eax
8010273c:	8b 40 04             	mov    0x4(%eax),%eax
8010273f:	83 e0 01             	and    $0x1,%eax
80102742:	89 c2                	mov    %eax,%edx
80102744:	c1 e2 04             	shl    $0x4,%edx
80102747:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010274a:	c1 f8 18             	sar    $0x18,%eax
8010274d:	83 e0 0f             	and    $0xf,%eax
80102750:	09 d0                	or     %edx,%eax
80102752:	83 c8 e0             	or     $0xffffffe0,%eax
80102755:	0f b6 c0             	movzbl %al,%eax
80102758:	89 44 24 04          	mov    %eax,0x4(%esp)
8010275c:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
80102763:	e8 ce fd ff ff       	call   80102536 <outb>
  if(b->flags & B_DIRTY){
80102768:	8b 45 08             	mov    0x8(%ebp),%eax
8010276b:	8b 00                	mov    (%eax),%eax
8010276d:	83 e0 04             	and    $0x4,%eax
80102770:	85 c0                	test   %eax,%eax
80102772:	74 34                	je     801027a8 <idestart+0x146>
    outb(0x1f7, IDE_CMD_WRITE);
80102774:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
8010277b:	00 
8010277c:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102783:	e8 ae fd ff ff       	call   80102536 <outb>
    outsl(0x1f0, b->data, BSIZE/4);
80102788:	8b 45 08             	mov    0x8(%ebp),%eax
8010278b:	83 c0 18             	add    $0x18,%eax
8010278e:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80102795:	00 
80102796:	89 44 24 04          	mov    %eax,0x4(%esp)
8010279a:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
801027a1:	e8 ae fd ff ff       	call   80102554 <outsl>
801027a6:	eb 14                	jmp    801027bc <idestart+0x15a>
  } else {
    outb(0x1f7, IDE_CMD_READ);
801027a8:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
801027af:	00 
801027b0:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801027b7:	e8 7a fd ff ff       	call   80102536 <outb>
  }
}
801027bc:	c9                   	leave  
801027bd:	c3                   	ret    

801027be <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801027be:	55                   	push   %ebp
801027bf:	89 e5                	mov    %esp,%ebp
801027c1:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801027c4:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
801027cb:	e8 8f 27 00 00       	call   80104f5f <acquire>
  if((b = idequeue) == 0){
801027d0:	a1 54 c6 10 80       	mov    0x8010c654,%eax
801027d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801027d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801027dc:	75 11                	jne    801027ef <ideintr+0x31>
    release(&idelock);
801027de:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
801027e5:	e8 d6 27 00 00       	call   80104fc0 <release>
    // cprintf("spurious IDE interrupt\n");
    return;
801027ea:	e9 90 00 00 00       	jmp    8010287f <ideintr+0xc1>
  }
  idequeue = b->qnext;
801027ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027f2:	8b 40 14             	mov    0x14(%eax),%eax
801027f5:	a3 54 c6 10 80       	mov    %eax,0x8010c654

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801027fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027fd:	8b 00                	mov    (%eax),%eax
801027ff:	83 e0 04             	and    $0x4,%eax
80102802:	85 c0                	test   %eax,%eax
80102804:	75 2e                	jne    80102834 <ideintr+0x76>
80102806:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010280d:	e8 67 fd ff ff       	call   80102579 <idewait>
80102812:	85 c0                	test   %eax,%eax
80102814:	78 1e                	js     80102834 <ideintr+0x76>
    insl(0x1f0, b->data, BSIZE/4);
80102816:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102819:	83 c0 18             	add    $0x18,%eax
8010281c:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80102823:	00 
80102824:	89 44 24 04          	mov    %eax,0x4(%esp)
80102828:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
8010282f:	e8 dd fc ff ff       	call   80102511 <insl>
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102834:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102837:	8b 00                	mov    (%eax),%eax
80102839:	89 c2                	mov    %eax,%edx
8010283b:	83 ca 02             	or     $0x2,%edx
8010283e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102841:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102843:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102846:	8b 00                	mov    (%eax),%eax
80102848:	89 c2                	mov    %eax,%edx
8010284a:	83 e2 fb             	and    $0xfffffffb,%edx
8010284d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102850:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102852:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102855:	89 04 24             	mov    %eax,(%esp)
80102858:	e8 04 25 00 00       	call   80104d61 <wakeup>
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
8010285d:	a1 54 c6 10 80       	mov    0x8010c654,%eax
80102862:	85 c0                	test   %eax,%eax
80102864:	74 0d                	je     80102873 <ideintr+0xb5>
    idestart(idequeue);
80102866:	a1 54 c6 10 80       	mov    0x8010c654,%eax
8010286b:	89 04 24             	mov    %eax,(%esp)
8010286e:	e8 ef fd ff ff       	call   80102662 <idestart>

  release(&idelock);
80102873:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
8010287a:	e8 41 27 00 00       	call   80104fc0 <release>
}
8010287f:	c9                   	leave  
80102880:	c3                   	ret    

80102881 <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102881:	55                   	push   %ebp
80102882:	89 e5                	mov    %esp,%ebp
80102884:	83 ec 28             	sub    $0x28,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
80102887:	8b 45 08             	mov    0x8(%ebp),%eax
8010288a:	8b 00                	mov    (%eax),%eax
8010288c:	83 e0 01             	and    $0x1,%eax
8010288f:	85 c0                	test   %eax,%eax
80102891:	75 0c                	jne    8010289f <iderw+0x1e>
    panic("iderw: buf not busy");
80102893:	c7 04 24 dd 8a 10 80 	movl   $0x80108add,(%esp)
8010289a:	e8 9e dc ff ff       	call   8010053d <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010289f:	8b 45 08             	mov    0x8(%ebp),%eax
801028a2:	8b 00                	mov    (%eax),%eax
801028a4:	83 e0 06             	and    $0x6,%eax
801028a7:	83 f8 02             	cmp    $0x2,%eax
801028aa:	75 0c                	jne    801028b8 <iderw+0x37>
    panic("iderw: nothing to do");
801028ac:	c7 04 24 f1 8a 10 80 	movl   $0x80108af1,(%esp)
801028b3:	e8 85 dc ff ff       	call   8010053d <panic>
  if(b->dev != 0 && !havedisk1)
801028b8:	8b 45 08             	mov    0x8(%ebp),%eax
801028bb:	8b 40 04             	mov    0x4(%eax),%eax
801028be:	85 c0                	test   %eax,%eax
801028c0:	74 15                	je     801028d7 <iderw+0x56>
801028c2:	a1 58 c6 10 80       	mov    0x8010c658,%eax
801028c7:	85 c0                	test   %eax,%eax
801028c9:	75 0c                	jne    801028d7 <iderw+0x56>
    panic("iderw: ide disk 1 not present");
801028cb:	c7 04 24 06 8b 10 80 	movl   $0x80108b06,(%esp)
801028d2:	e8 66 dc ff ff       	call   8010053d <panic>

  acquire(&idelock);  //DOC:acquire-lock
801028d7:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
801028de:	e8 7c 26 00 00       	call   80104f5f <acquire>

  // Append b to idequeue.
  b->qnext = 0;
801028e3:	8b 45 08             	mov    0x8(%ebp),%eax
801028e6:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801028ed:	c7 45 f4 54 c6 10 80 	movl   $0x8010c654,-0xc(%ebp)
801028f4:	eb 0b                	jmp    80102901 <iderw+0x80>
801028f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028f9:	8b 00                	mov    (%eax),%eax
801028fb:	83 c0 14             	add    $0x14,%eax
801028fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102901:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102904:	8b 00                	mov    (%eax),%eax
80102906:	85 c0                	test   %eax,%eax
80102908:	75 ec                	jne    801028f6 <iderw+0x75>
    ;
  *pp = b;
8010290a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010290d:	8b 55 08             	mov    0x8(%ebp),%edx
80102910:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
80102912:	a1 54 c6 10 80       	mov    0x8010c654,%eax
80102917:	3b 45 08             	cmp    0x8(%ebp),%eax
8010291a:	75 22                	jne    8010293e <iderw+0xbd>
    idestart(b);
8010291c:	8b 45 08             	mov    0x8(%ebp),%eax
8010291f:	89 04 24             	mov    %eax,(%esp)
80102922:	e8 3b fd ff ff       	call   80102662 <idestart>
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102927:	eb 16                	jmp    8010293f <iderw+0xbe>
    sleep(b, &idelock);
80102929:	c7 44 24 04 20 c6 10 	movl   $0x8010c620,0x4(%esp)
80102930:	80 
80102931:	8b 45 08             	mov    0x8(%ebp),%eax
80102934:	89 04 24             	mov    %eax,(%esp)
80102937:	e8 48 23 00 00       	call   80104c84 <sleep>
8010293c:	eb 01                	jmp    8010293f <iderw+0xbe>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010293e:	90                   	nop
8010293f:	8b 45 08             	mov    0x8(%ebp),%eax
80102942:	8b 00                	mov    (%eax),%eax
80102944:	83 e0 06             	and    $0x6,%eax
80102947:	83 f8 02             	cmp    $0x2,%eax
8010294a:	75 dd                	jne    80102929 <iderw+0xa8>
    sleep(b, &idelock);
  }

  release(&idelock);
8010294c:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
80102953:	e8 68 26 00 00       	call   80104fc0 <release>
}
80102958:	c9                   	leave  
80102959:	c3                   	ret    
	...

8010295c <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
8010295c:	55                   	push   %ebp
8010295d:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
8010295f:	a1 34 32 11 80       	mov    0x80113234,%eax
80102964:	8b 55 08             	mov    0x8(%ebp),%edx
80102967:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102969:	a1 34 32 11 80       	mov    0x80113234,%eax
8010296e:	8b 40 10             	mov    0x10(%eax),%eax
}
80102971:	5d                   	pop    %ebp
80102972:	c3                   	ret    

80102973 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102973:	55                   	push   %ebp
80102974:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102976:	a1 34 32 11 80       	mov    0x80113234,%eax
8010297b:	8b 55 08             	mov    0x8(%ebp),%edx
8010297e:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102980:	a1 34 32 11 80       	mov    0x80113234,%eax
80102985:	8b 55 0c             	mov    0xc(%ebp),%edx
80102988:	89 50 10             	mov    %edx,0x10(%eax)
}
8010298b:	5d                   	pop    %ebp
8010298c:	c3                   	ret    

8010298d <ioapicinit>:

void
ioapicinit(void)
{
8010298d:	55                   	push   %ebp
8010298e:	89 e5                	mov    %esp,%ebp
80102990:	83 ec 28             	sub    $0x28,%esp
  int i, id, maxintr;

  if(!ismp)
80102993:	a1 64 33 11 80       	mov    0x80113364,%eax
80102998:	85 c0                	test   %eax,%eax
8010299a:	0f 84 9f 00 00 00    	je     80102a3f <ioapicinit+0xb2>
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
801029a0:	c7 05 34 32 11 80 00 	movl   $0xfec00000,0x80113234
801029a7:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801029aa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801029b1:	e8 a6 ff ff ff       	call   8010295c <ioapicread>
801029b6:	c1 e8 10             	shr    $0x10,%eax
801029b9:	25 ff 00 00 00       	and    $0xff,%eax
801029be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  id = ioapicread(REG_ID) >> 24;
801029c1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801029c8:	e8 8f ff ff ff       	call   8010295c <ioapicread>
801029cd:	c1 e8 18             	shr    $0x18,%eax
801029d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(id != ioapicid)
801029d3:	0f b6 05 60 33 11 80 	movzbl 0x80113360,%eax
801029da:	0f b6 c0             	movzbl %al,%eax
801029dd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801029e0:	74 0c                	je     801029ee <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801029e2:	c7 04 24 24 8b 10 80 	movl   $0x80108b24,(%esp)
801029e9:	e8 af d9 ff ff       	call   8010039d <cprintf>

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801029ee:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
801029f5:	eb 3e                	jmp    80102a35 <ioapicinit+0xa8>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801029f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801029fa:	83 c0 20             	add    $0x20,%eax
801029fd:	0d 00 00 01 00       	or     $0x10000,%eax
80102a02:	8b 55 ec             	mov    -0x14(%ebp),%edx
80102a05:	83 c2 08             	add    $0x8,%edx
80102a08:	01 d2                	add    %edx,%edx
80102a0a:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a0e:	89 14 24             	mov    %edx,(%esp)
80102a11:	e8 5d ff ff ff       	call   80102973 <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102a16:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102a19:	83 c0 08             	add    $0x8,%eax
80102a1c:	01 c0                	add    %eax,%eax
80102a1e:	83 c0 01             	add    $0x1,%eax
80102a21:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102a28:	00 
80102a29:	89 04 24             	mov    %eax,(%esp)
80102a2c:	e8 42 ff ff ff       	call   80102973 <ioapicwrite>
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102a31:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80102a35:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102a38:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80102a3b:	7e ba                	jle    801029f7 <ioapicinit+0x6a>
80102a3d:	eb 01                	jmp    80102a40 <ioapicinit+0xb3>
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
    return;
80102a3f:	90                   	nop
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102a40:	c9                   	leave  
80102a41:	c3                   	ret    

80102a42 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102a42:	55                   	push   %ebp
80102a43:	89 e5                	mov    %esp,%ebp
80102a45:	83 ec 08             	sub    $0x8,%esp
  if(!ismp)
80102a48:	a1 64 33 11 80       	mov    0x80113364,%eax
80102a4d:	85 c0                	test   %eax,%eax
80102a4f:	74 39                	je     80102a8a <ioapicenable+0x48>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102a51:	8b 45 08             	mov    0x8(%ebp),%eax
80102a54:	83 c0 20             	add    $0x20,%eax
80102a57:	8b 55 08             	mov    0x8(%ebp),%edx
80102a5a:	83 c2 08             	add    $0x8,%edx
80102a5d:	01 d2                	add    %edx,%edx
80102a5f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a63:	89 14 24             	mov    %edx,(%esp)
80102a66:	e8 08 ff ff ff       	call   80102973 <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102a6b:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a6e:	c1 e0 18             	shl    $0x18,%eax
80102a71:	8b 55 08             	mov    0x8(%ebp),%edx
80102a74:	83 c2 08             	add    $0x8,%edx
80102a77:	01 d2                	add    %edx,%edx
80102a79:	83 c2 01             	add    $0x1,%edx
80102a7c:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a80:	89 14 24             	mov    %edx,(%esp)
80102a83:	e8 eb fe ff ff       	call   80102973 <ioapicwrite>
80102a88:	eb 01                	jmp    80102a8b <ioapicenable+0x49>

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
    return;
80102a8a:	90                   	nop
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80102a8b:	c9                   	leave  
80102a8c:	c3                   	ret    
80102a8d:	00 00                	add    %al,(%eax)
	...

80102a90 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80102a90:	55                   	push   %ebp
80102a91:	89 e5                	mov    %esp,%ebp
80102a93:	8b 45 08             	mov    0x8(%ebp),%eax
80102a96:	2d 00 00 00 80       	sub    $0x80000000,%eax
80102a9b:	5d                   	pop    %ebp
80102a9c:	c3                   	ret    

80102a9d <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102a9d:	55                   	push   %ebp
80102a9e:	89 e5                	mov    %esp,%ebp
80102aa0:	83 ec 18             	sub    $0x18,%esp
  initlock(&kmem.lock, "kmem");
80102aa3:	c7 44 24 04 56 8b 10 	movl   $0x80108b56,0x4(%esp)
80102aaa:	80 
80102aab:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
80102ab2:	e8 87 24 00 00       	call   80104f3e <initlock>
  kmem.use_lock = 0;
80102ab7:	c7 05 74 32 11 80 00 	movl   $0x0,0x80113274
80102abe:	00 00 00 
  freerange(vstart, vend);
80102ac1:	8b 45 0c             	mov    0xc(%ebp),%eax
80102ac4:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ac8:	8b 45 08             	mov    0x8(%ebp),%eax
80102acb:	89 04 24             	mov    %eax,(%esp)
80102ace:	e8 26 00 00 00       	call   80102af9 <freerange>
}
80102ad3:	c9                   	leave  
80102ad4:	c3                   	ret    

80102ad5 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102ad5:	55                   	push   %ebp
80102ad6:	89 e5                	mov    %esp,%ebp
80102ad8:	83 ec 18             	sub    $0x18,%esp
  freerange(vstart, vend);
80102adb:	8b 45 0c             	mov    0xc(%ebp),%eax
80102ade:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ae2:	8b 45 08             	mov    0x8(%ebp),%eax
80102ae5:	89 04 24             	mov    %eax,(%esp)
80102ae8:	e8 0c 00 00 00       	call   80102af9 <freerange>
  kmem.use_lock = 1;
80102aed:	c7 05 74 32 11 80 01 	movl   $0x1,0x80113274
80102af4:	00 00 00 
}
80102af7:	c9                   	leave  
80102af8:	c3                   	ret    

80102af9 <freerange>:

void
freerange(void *vstart, void *vend)
{
80102af9:	55                   	push   %ebp
80102afa:	89 e5                	mov    %esp,%ebp
80102afc:	83 ec 28             	sub    $0x28,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102aff:	8b 45 08             	mov    0x8(%ebp),%eax
80102b02:	05 ff 0f 00 00       	add    $0xfff,%eax
80102b07:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102b0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b0f:	eb 12                	jmp    80102b23 <freerange+0x2a>
    kfree(p);
80102b11:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b14:	89 04 24             	mov    %eax,(%esp)
80102b17:	e8 19 00 00 00       	call   80102b35 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b1c:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102b23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b26:	8d 90 00 10 00 00    	lea    0x1000(%eax),%edx
80102b2c:	8b 45 0c             	mov    0xc(%ebp),%eax
80102b2f:	39 c2                	cmp    %eax,%edx
80102b31:	76 de                	jbe    80102b11 <freerange+0x18>
    kfree(p);
}
80102b33:	c9                   	leave  
80102b34:	c3                   	ret    

80102b35 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102b35:	55                   	push   %ebp
80102b36:	89 e5                	mov    %esp,%ebp
80102b38:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102b3b:	8b 45 08             	mov    0x8(%ebp),%eax
80102b3e:	25 ff 0f 00 00       	and    $0xfff,%eax
80102b43:	85 c0                	test   %eax,%eax
80102b45:	75 1b                	jne    80102b62 <kfree+0x2d>
80102b47:	81 7d 08 5c 84 11 80 	cmpl   $0x8011845c,0x8(%ebp)
80102b4e:	72 12                	jb     80102b62 <kfree+0x2d>
80102b50:	8b 45 08             	mov    0x8(%ebp),%eax
80102b53:	89 04 24             	mov    %eax,(%esp)
80102b56:	e8 35 ff ff ff       	call   80102a90 <v2p>
80102b5b:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102b60:	76 0c                	jbe    80102b6e <kfree+0x39>
    panic("kfree");
80102b62:	c7 04 24 5b 8b 10 80 	movl   $0x80108b5b,(%esp)
80102b69:	e8 cf d9 ff ff       	call   8010053d <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102b6e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80102b75:	00 
80102b76:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102b7d:	00 
80102b7e:	8b 45 08             	mov    0x8(%ebp),%eax
80102b81:	89 04 24             	mov    %eax,(%esp)
80102b84:	e8 2d 26 00 00       	call   801051b6 <memset>

  if(kmem.use_lock)
80102b89:	a1 74 32 11 80       	mov    0x80113274,%eax
80102b8e:	85 c0                	test   %eax,%eax
80102b90:	74 0c                	je     80102b9e <kfree+0x69>
    acquire(&kmem.lock);
80102b92:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
80102b99:	e8 c1 23 00 00       	call   80104f5f <acquire>
  r = (struct run*)v;
80102b9e:	8b 45 08             	mov    0x8(%ebp),%eax
80102ba1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102ba4:	8b 15 78 32 11 80    	mov    0x80113278,%edx
80102baa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bad:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bb2:	a3 78 32 11 80       	mov    %eax,0x80113278
  if(kmem.use_lock)
80102bb7:	a1 74 32 11 80       	mov    0x80113274,%eax
80102bbc:	85 c0                	test   %eax,%eax
80102bbe:	74 0c                	je     80102bcc <kfree+0x97>
    release(&kmem.lock);
80102bc0:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
80102bc7:	e8 f4 23 00 00       	call   80104fc0 <release>
}
80102bcc:	c9                   	leave  
80102bcd:	c3                   	ret    

80102bce <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102bce:	55                   	push   %ebp
80102bcf:	89 e5                	mov    %esp,%ebp
80102bd1:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if(kmem.use_lock)
80102bd4:	a1 74 32 11 80       	mov    0x80113274,%eax
80102bd9:	85 c0                	test   %eax,%eax
80102bdb:	74 0c                	je     80102be9 <kalloc+0x1b>
    acquire(&kmem.lock);
80102bdd:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
80102be4:	e8 76 23 00 00       	call   80104f5f <acquire>
  r = kmem.freelist;
80102be9:	a1 78 32 11 80       	mov    0x80113278,%eax
80102bee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102bf1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102bf5:	74 0a                	je     80102c01 <kalloc+0x33>
    kmem.freelist = r->next;
80102bf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bfa:	8b 00                	mov    (%eax),%eax
80102bfc:	a3 78 32 11 80       	mov    %eax,0x80113278
  if(kmem.use_lock)
80102c01:	a1 74 32 11 80       	mov    0x80113274,%eax
80102c06:	85 c0                	test   %eax,%eax
80102c08:	74 0c                	je     80102c16 <kalloc+0x48>
    release(&kmem.lock);
80102c0a:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
80102c11:	e8 aa 23 00 00       	call   80104fc0 <release>
  return (char*)r;
80102c16:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102c19:	c9                   	leave  
80102c1a:	c3                   	ret    
	...

80102c1c <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102c1c:	55                   	push   %ebp
80102c1d:	89 e5                	mov    %esp,%ebp
80102c1f:	83 ec 14             	sub    $0x14,%esp
80102c22:	8b 45 08             	mov    0x8(%ebp),%eax
80102c25:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c29:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102c2d:	89 c2                	mov    %eax,%edx
80102c2f:	ec                   	in     (%dx),%al
80102c30:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102c33:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102c37:	c9                   	leave  
80102c38:	c3                   	ret    

80102c39 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102c39:	55                   	push   %ebp
80102c3a:	89 e5                	mov    %esp,%ebp
80102c3c:	83 ec 14             	sub    $0x14,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102c3f:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102c46:	e8 d1 ff ff ff       	call   80102c1c <inb>
80102c4b:	0f b6 c0             	movzbl %al,%eax
80102c4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102c51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c54:	83 e0 01             	and    $0x1,%eax
80102c57:	85 c0                	test   %eax,%eax
80102c59:	75 0a                	jne    80102c65 <kbdgetc+0x2c>
    return -1;
80102c5b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102c60:	e9 20 01 00 00       	jmp    80102d85 <kbdgetc+0x14c>
  data = inb(KBDATAP);
80102c65:	c7 04 24 60 00 00 00 	movl   $0x60,(%esp)
80102c6c:	e8 ab ff ff ff       	call   80102c1c <inb>
80102c71:	0f b6 c0             	movzbl %al,%eax
80102c74:	89 45 f8             	mov    %eax,-0x8(%ebp)

  if(data == 0xE0){
80102c77:	81 7d f8 e0 00 00 00 	cmpl   $0xe0,-0x8(%ebp)
80102c7e:	75 17                	jne    80102c97 <kbdgetc+0x5e>
    shift |= E0ESC;
80102c80:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c85:	83 c8 40             	or     $0x40,%eax
80102c88:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
    return 0;
80102c8d:	b8 00 00 00 00       	mov    $0x0,%eax
80102c92:	e9 ee 00 00 00       	jmp    80102d85 <kbdgetc+0x14c>
  } else if(data & 0x80){
80102c97:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102c9a:	25 80 00 00 00       	and    $0x80,%eax
80102c9f:	85 c0                	test   %eax,%eax
80102ca1:	74 44                	je     80102ce7 <kbdgetc+0xae>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102ca3:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102ca8:	83 e0 40             	and    $0x40,%eax
80102cab:	85 c0                	test   %eax,%eax
80102cad:	75 08                	jne    80102cb7 <kbdgetc+0x7e>
80102caf:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102cb2:	83 e0 7f             	and    $0x7f,%eax
80102cb5:	eb 03                	jmp    80102cba <kbdgetc+0x81>
80102cb7:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102cba:	89 45 f8             	mov    %eax,-0x8(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102cbd:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102cc0:	0f b6 80 20 a0 10 80 	movzbl -0x7fef5fe0(%eax),%eax
80102cc7:	83 c8 40             	or     $0x40,%eax
80102cca:	0f b6 c0             	movzbl %al,%eax
80102ccd:	f7 d0                	not    %eax
80102ccf:	89 c2                	mov    %eax,%edx
80102cd1:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102cd6:	21 d0                	and    %edx,%eax
80102cd8:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
    return 0;
80102cdd:	b8 00 00 00 00       	mov    $0x0,%eax
80102ce2:	e9 9e 00 00 00       	jmp    80102d85 <kbdgetc+0x14c>
  } else if(shift & E0ESC){
80102ce7:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102cec:	83 e0 40             	and    $0x40,%eax
80102cef:	85 c0                	test   %eax,%eax
80102cf1:	74 14                	je     80102d07 <kbdgetc+0xce>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102cf3:	81 4d f8 80 00 00 00 	orl    $0x80,-0x8(%ebp)
    shift &= ~E0ESC;
80102cfa:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102cff:	83 e0 bf             	and    $0xffffffbf,%eax
80102d02:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  }

  shift |= shiftcode[data];
80102d07:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102d0a:	0f b6 80 20 a0 10 80 	movzbl -0x7fef5fe0(%eax),%eax
80102d11:	0f b6 d0             	movzbl %al,%edx
80102d14:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102d19:	09 d0                	or     %edx,%eax
80102d1b:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  shift ^= togglecode[data];
80102d20:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102d23:	0f b6 80 20 a1 10 80 	movzbl -0x7fef5ee0(%eax),%eax
80102d2a:	0f b6 d0             	movzbl %al,%edx
80102d2d:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102d32:	31 d0                	xor    %edx,%eax
80102d34:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  c = charcode[shift & (CTL | SHIFT)][data];
80102d39:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102d3e:	83 e0 03             	and    $0x3,%eax
80102d41:	8b 04 85 20 a5 10 80 	mov    -0x7fef5ae0(,%eax,4),%eax
80102d48:	03 45 f8             	add    -0x8(%ebp),%eax
80102d4b:	0f b6 00             	movzbl (%eax),%eax
80102d4e:	0f b6 c0             	movzbl %al,%eax
80102d51:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(shift & CAPSLOCK){
80102d54:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102d59:	83 e0 08             	and    $0x8,%eax
80102d5c:	85 c0                	test   %eax,%eax
80102d5e:	74 22                	je     80102d82 <kbdgetc+0x149>
    if('a' <= c && c <= 'z')
80102d60:	83 7d fc 60          	cmpl   $0x60,-0x4(%ebp)
80102d64:	76 0c                	jbe    80102d72 <kbdgetc+0x139>
80102d66:	83 7d fc 7a          	cmpl   $0x7a,-0x4(%ebp)
80102d6a:	77 06                	ja     80102d72 <kbdgetc+0x139>
      c += 'A' - 'a';
80102d6c:	83 6d fc 20          	subl   $0x20,-0x4(%ebp)

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
80102d70:	eb 10                	jmp    80102d82 <kbdgetc+0x149>
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
80102d72:	83 7d fc 40          	cmpl   $0x40,-0x4(%ebp)
80102d76:	76 0a                	jbe    80102d82 <kbdgetc+0x149>
80102d78:	83 7d fc 5a          	cmpl   $0x5a,-0x4(%ebp)
80102d7c:	77 04                	ja     80102d82 <kbdgetc+0x149>
      c += 'a' - 'A';
80102d7e:	83 45 fc 20          	addl   $0x20,-0x4(%ebp)
  }
  return c;
80102d82:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102d85:	c9                   	leave  
80102d86:	c3                   	ret    

80102d87 <kbdintr>:

void
kbdintr(void)
{
80102d87:	55                   	push   %ebp
80102d88:	89 e5                	mov    %esp,%ebp
80102d8a:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
80102d8d:	c7 04 24 39 2c 10 80 	movl   $0x80102c39,(%esp)
80102d94:	e8 30 da ff ff       	call   801007c9 <consoleintr>
}
80102d99:	c9                   	leave  
80102d9a:	c3                   	ret    
	...

80102d9c <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102d9c:	55                   	push   %ebp
80102d9d:	89 e5                	mov    %esp,%ebp
80102d9f:	83 ec 14             	sub    $0x14,%esp
80102da2:	8b 45 08             	mov    0x8(%ebp),%eax
80102da5:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102da9:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102dad:	89 c2                	mov    %eax,%edx
80102daf:	ec                   	in     (%dx),%al
80102db0:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102db3:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102db7:	c9                   	leave  
80102db8:	c3                   	ret    

80102db9 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102db9:	55                   	push   %ebp
80102dba:	89 e5                	mov    %esp,%ebp
80102dbc:	83 ec 08             	sub    $0x8,%esp
80102dbf:	8b 55 08             	mov    0x8(%ebp),%edx
80102dc2:	8b 45 0c             	mov    0xc(%ebp),%eax
80102dc5:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102dc9:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dcc:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102dd0:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102dd4:	ee                   	out    %al,(%dx)
}
80102dd5:	c9                   	leave  
80102dd6:	c3                   	ret    

80102dd7 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80102dd7:	55                   	push   %ebp
80102dd8:	89 e5                	mov    %esp,%ebp
80102dda:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102ddd:	9c                   	pushf  
80102dde:	58                   	pop    %eax
80102ddf:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80102de2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102de5:	c9                   	leave  
80102de6:	c3                   	ret    

80102de7 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102de7:	55                   	push   %ebp
80102de8:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102dea:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102def:	8b 55 08             	mov    0x8(%ebp),%edx
80102df2:	c1 e2 02             	shl    $0x2,%edx
80102df5:	8d 14 10             	lea    (%eax,%edx,1),%edx
80102df8:	8b 45 0c             	mov    0xc(%ebp),%eax
80102dfb:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102dfd:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102e02:	83 c0 20             	add    $0x20,%eax
80102e05:	8b 00                	mov    (%eax),%eax
}
80102e07:	5d                   	pop    %ebp
80102e08:	c3                   	ret    

80102e09 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
80102e09:	55                   	push   %ebp
80102e0a:	89 e5                	mov    %esp,%ebp
80102e0c:	83 ec 08             	sub    $0x8,%esp
  if(!lapic) 
80102e0f:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102e14:	85 c0                	test   %eax,%eax
80102e16:	0f 84 46 01 00 00    	je     80102f62 <lapicinit+0x159>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102e1c:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
80102e23:	00 
80102e24:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
80102e2b:	e8 b7 ff ff ff       	call   80102de7 <lapicw>

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102e30:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
80102e37:	00 
80102e38:	c7 04 24 f8 00 00 00 	movl   $0xf8,(%esp)
80102e3f:	e8 a3 ff ff ff       	call   80102de7 <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102e44:	c7 44 24 04 20 00 02 	movl   $0x20020,0x4(%esp)
80102e4b:	00 
80102e4c:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102e53:	e8 8f ff ff ff       	call   80102de7 <lapicw>
  lapicw(TICR, 10000000); 
80102e58:	c7 44 24 04 80 96 98 	movl   $0x989680,0x4(%esp)
80102e5f:	00 
80102e60:	c7 04 24 e0 00 00 00 	movl   $0xe0,(%esp)
80102e67:	e8 7b ff ff ff       	call   80102de7 <lapicw>

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102e6c:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102e73:	00 
80102e74:	c7 04 24 d4 00 00 00 	movl   $0xd4,(%esp)
80102e7b:	e8 67 ff ff ff       	call   80102de7 <lapicw>
  lapicw(LINT1, MASKED);
80102e80:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102e87:	00 
80102e88:	c7 04 24 d8 00 00 00 	movl   $0xd8,(%esp)
80102e8f:	e8 53 ff ff ff       	call   80102de7 <lapicw>

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102e94:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102e99:	83 c0 30             	add    $0x30,%eax
80102e9c:	8b 00                	mov    (%eax),%eax
80102e9e:	c1 e8 10             	shr    $0x10,%eax
80102ea1:	25 ff 00 00 00       	and    $0xff,%eax
80102ea6:	83 f8 03             	cmp    $0x3,%eax
80102ea9:	76 14                	jbe    80102ebf <lapicinit+0xb6>
    lapicw(PCINT, MASKED);
80102eab:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102eb2:	00 
80102eb3:	c7 04 24 d0 00 00 00 	movl   $0xd0,(%esp)
80102eba:	e8 28 ff ff ff       	call   80102de7 <lapicw>

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102ebf:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
80102ec6:	00 
80102ec7:	c7 04 24 dc 00 00 00 	movl   $0xdc,(%esp)
80102ece:	e8 14 ff ff ff       	call   80102de7 <lapicw>

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102ed3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102eda:	00 
80102edb:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102ee2:	e8 00 ff ff ff       	call   80102de7 <lapicw>
  lapicw(ESR, 0);
80102ee7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102eee:	00 
80102eef:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102ef6:	e8 ec fe ff ff       	call   80102de7 <lapicw>

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102efb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102f02:	00 
80102f03:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102f0a:	e8 d8 fe ff ff       	call   80102de7 <lapicw>

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102f0f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102f16:	00 
80102f17:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102f1e:	e8 c4 fe ff ff       	call   80102de7 <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102f23:	c7 44 24 04 00 85 08 	movl   $0x88500,0x4(%esp)
80102f2a:	00 
80102f2b:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102f32:	e8 b0 fe ff ff       	call   80102de7 <lapicw>
  while(lapic[ICRLO] & DELIVS)
80102f37:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102f3c:	05 00 03 00 00       	add    $0x300,%eax
80102f41:	8b 00                	mov    (%eax),%eax
80102f43:	25 00 10 00 00       	and    $0x1000,%eax
80102f48:	85 c0                	test   %eax,%eax
80102f4a:	75 eb                	jne    80102f37 <lapicinit+0x12e>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102f4c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102f53:	00 
80102f54:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80102f5b:	e8 87 fe ff ff       	call   80102de7 <lapicw>
80102f60:	eb 01                	jmp    80102f63 <lapicinit+0x15a>

void
lapicinit(void)
{
  if(!lapic) 
    return;
80102f62:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102f63:	c9                   	leave  
80102f64:	c3                   	ret    

80102f65 <cpunum>:

int
cpunum(void)
{
80102f65:	55                   	push   %ebp
80102f66:	89 e5                	mov    %esp,%ebp
80102f68:	83 ec 18             	sub    $0x18,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80102f6b:	e8 67 fe ff ff       	call   80102dd7 <readeflags>
80102f70:	25 00 02 00 00       	and    $0x200,%eax
80102f75:	85 c0                	test   %eax,%eax
80102f77:	74 29                	je     80102fa2 <cpunum+0x3d>
    static int n;
    if(n++ == 0)
80102f79:	a1 60 c6 10 80       	mov    0x8010c660,%eax
80102f7e:	85 c0                	test   %eax,%eax
80102f80:	0f 94 c2             	sete   %dl
80102f83:	83 c0 01             	add    $0x1,%eax
80102f86:	a3 60 c6 10 80       	mov    %eax,0x8010c660
80102f8b:	84 d2                	test   %dl,%dl
80102f8d:	74 13                	je     80102fa2 <cpunum+0x3d>
      cprintf("cpu called from %x with interrupts enabled\n",
80102f8f:	8b 45 04             	mov    0x4(%ebp),%eax
80102f92:	89 44 24 04          	mov    %eax,0x4(%esp)
80102f96:	c7 04 24 64 8b 10 80 	movl   $0x80108b64,(%esp)
80102f9d:	e8 fb d3 ff ff       	call   8010039d <cprintf>
        __builtin_return_address(0));
  }

  if(lapic)
80102fa2:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102fa7:	85 c0                	test   %eax,%eax
80102fa9:	74 0f                	je     80102fba <cpunum+0x55>
    return lapic[ID]>>24;
80102fab:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102fb0:	83 c0 20             	add    $0x20,%eax
80102fb3:	8b 00                	mov    (%eax),%eax
80102fb5:	c1 e8 18             	shr    $0x18,%eax
80102fb8:	eb 05                	jmp    80102fbf <cpunum+0x5a>
  return 0;
80102fba:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102fbf:	c9                   	leave  
80102fc0:	c3                   	ret    

80102fc1 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102fc1:	55                   	push   %ebp
80102fc2:	89 e5                	mov    %esp,%ebp
80102fc4:	83 ec 08             	sub    $0x8,%esp
  if(lapic)
80102fc7:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102fcc:	85 c0                	test   %eax,%eax
80102fce:	74 14                	je     80102fe4 <lapiceoi+0x23>
    lapicw(EOI, 0);
80102fd0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102fd7:	00 
80102fd8:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102fdf:	e8 03 fe ff ff       	call   80102de7 <lapicw>
}
80102fe4:	c9                   	leave  
80102fe5:	c3                   	ret    

80102fe6 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102fe6:	55                   	push   %ebp
80102fe7:	89 e5                	mov    %esp,%ebp
}
80102fe9:	5d                   	pop    %ebp
80102fea:	c3                   	ret    

80102feb <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102feb:	55                   	push   %ebp
80102fec:	89 e5                	mov    %esp,%ebp
80102fee:	83 ec 1c             	sub    $0x1c,%esp
80102ff1:	8b 45 08             	mov    0x8(%ebp),%eax
80102ff4:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
80102ff7:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80102ffe:	00 
80102fff:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
80103006:	e8 ae fd ff ff       	call   80102db9 <outb>
  outb(CMOS_PORT+1, 0x0A);
8010300b:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103012:	00 
80103013:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
8010301a:	e8 9a fd ff ff       	call   80102db9 <outb>
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
8010301f:	c7 45 fc 67 04 00 80 	movl   $0x80000467,-0x4(%ebp)
  wrv[0] = 0;
80103026:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103029:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
8010302e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103031:	8d 50 02             	lea    0x2(%eax),%edx
80103034:	8b 45 0c             	mov    0xc(%ebp),%eax
80103037:	c1 e8 04             	shr    $0x4,%eax
8010303a:	66 89 02             	mov    %ax,(%edx)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
8010303d:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103041:	c1 e0 18             	shl    $0x18,%eax
80103044:	89 44 24 04          	mov    %eax,0x4(%esp)
80103048:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
8010304f:	e8 93 fd ff ff       	call   80102de7 <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80103054:	c7 44 24 04 00 c5 00 	movl   $0xc500,0x4(%esp)
8010305b:	00 
8010305c:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80103063:	e8 7f fd ff ff       	call   80102de7 <lapicw>
  microdelay(200);
80103068:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
8010306f:	e8 72 ff ff ff       	call   80102fe6 <microdelay>
  lapicw(ICRLO, INIT | LEVEL);
80103074:	c7 44 24 04 00 85 00 	movl   $0x8500,0x4(%esp)
8010307b:	00 
8010307c:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80103083:	e8 5f fd ff ff       	call   80102de7 <lapicw>
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80103088:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
8010308f:	e8 52 ff ff ff       	call   80102fe6 <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103094:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
8010309b:	eb 40                	jmp    801030dd <lapicstartap+0xf2>
    lapicw(ICRHI, apicid<<24);
8010309d:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
801030a1:	c1 e0 18             	shl    $0x18,%eax
801030a4:	89 44 24 04          	mov    %eax,0x4(%esp)
801030a8:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
801030af:	e8 33 fd ff ff       	call   80102de7 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
801030b4:	8b 45 0c             	mov    0xc(%ebp),%eax
801030b7:	c1 e8 0c             	shr    $0xc,%eax
801030ba:	80 cc 06             	or     $0x6,%ah
801030bd:	89 44 24 04          	mov    %eax,0x4(%esp)
801030c1:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
801030c8:	e8 1a fd ff ff       	call   80102de7 <lapicw>
    microdelay(200);
801030cd:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
801030d4:	e8 0d ff ff ff       	call   80102fe6 <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
801030d9:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801030dd:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
801030e1:	7e ba                	jle    8010309d <lapicstartap+0xb2>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
801030e3:	c9                   	leave  
801030e4:	c3                   	ret    

801030e5 <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
801030e5:	55                   	push   %ebp
801030e6:	89 e5                	mov    %esp,%ebp
801030e8:	83 ec 08             	sub    $0x8,%esp
  outb(CMOS_PORT,  reg);
801030eb:	8b 45 08             	mov    0x8(%ebp),%eax
801030ee:	0f b6 c0             	movzbl %al,%eax
801030f1:	89 44 24 04          	mov    %eax,0x4(%esp)
801030f5:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
801030fc:	e8 b8 fc ff ff       	call   80102db9 <outb>
  microdelay(200);
80103101:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80103108:	e8 d9 fe ff ff       	call   80102fe6 <microdelay>

  return inb(CMOS_RETURN);
8010310d:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
80103114:	e8 83 fc ff ff       	call   80102d9c <inb>
80103119:	0f b6 c0             	movzbl %al,%eax
}
8010311c:	c9                   	leave  
8010311d:	c3                   	ret    

8010311e <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
8010311e:	55                   	push   %ebp
8010311f:	89 e5                	mov    %esp,%ebp
80103121:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
80103124:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010312b:	e8 b5 ff ff ff       	call   801030e5 <cmos_read>
80103130:	8b 55 08             	mov    0x8(%ebp),%edx
80103133:	89 02                	mov    %eax,(%edx)
  r->minute = cmos_read(MINS);
80103135:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
8010313c:	e8 a4 ff ff ff       	call   801030e5 <cmos_read>
80103141:	8b 55 08             	mov    0x8(%ebp),%edx
80103144:	89 42 04             	mov    %eax,0x4(%edx)
  r->hour   = cmos_read(HOURS);
80103147:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
8010314e:	e8 92 ff ff ff       	call   801030e5 <cmos_read>
80103153:	8b 55 08             	mov    0x8(%ebp),%edx
80103156:	89 42 08             	mov    %eax,0x8(%edx)
  r->day    = cmos_read(DAY);
80103159:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
80103160:	e8 80 ff ff ff       	call   801030e5 <cmos_read>
80103165:	8b 55 08             	mov    0x8(%ebp),%edx
80103168:	89 42 0c             	mov    %eax,0xc(%edx)
  r->month  = cmos_read(MONTH);
8010316b:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80103172:	e8 6e ff ff ff       	call   801030e5 <cmos_read>
80103177:	8b 55 08             	mov    0x8(%ebp),%edx
8010317a:	89 42 10             	mov    %eax,0x10(%edx)
  r->year   = cmos_read(YEAR);
8010317d:	c7 04 24 09 00 00 00 	movl   $0x9,(%esp)
80103184:	e8 5c ff ff ff       	call   801030e5 <cmos_read>
80103189:	8b 55 08             	mov    0x8(%ebp),%edx
8010318c:	89 42 14             	mov    %eax,0x14(%edx)
}
8010318f:	c9                   	leave  
80103190:	c3                   	ret    

80103191 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80103191:	55                   	push   %ebp
80103192:	89 e5                	mov    %esp,%ebp
80103194:	83 ec 58             	sub    $0x58,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
80103197:	c7 04 24 0b 00 00 00 	movl   $0xb,(%esp)
8010319e:	e8 42 ff ff ff       	call   801030e5 <cmos_read>
801031a3:	89 45 f0             	mov    %eax,-0x10(%ebp)

  bcd = (sb & (1 << 2)) == 0;
801031a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801031a9:	83 e0 04             	and    $0x4,%eax
801031ac:	85 c0                	test   %eax,%eax
801031ae:	0f 94 c0             	sete   %al
801031b1:	0f b6 c0             	movzbl %al,%eax
801031b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801031b7:	eb 01                	jmp    801031ba <cmostime+0x29>
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
801031b9:	90                   	nop

  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
801031ba:	8d 45 d8             	lea    -0x28(%ebp),%eax
801031bd:	89 04 24             	mov    %eax,(%esp)
801031c0:	e8 59 ff ff ff       	call   8010311e <fill_rtcdate>
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
801031c5:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
801031cc:	e8 14 ff ff ff       	call   801030e5 <cmos_read>
801031d1:	25 80 00 00 00       	and    $0x80,%eax
801031d6:	85 c0                	test   %eax,%eax
801031d8:	74 03                	je     801031dd <cmostime+0x4c>
        continue;
801031da:	90                   	nop
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
801031db:	eb dd                	jmp    801031ba <cmostime+0x29>
  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
801031dd:	8d 45 c0             	lea    -0x40(%ebp),%eax
801031e0:	89 04 24             	mov    %eax,(%esp)
801031e3:	e8 36 ff ff ff       	call   8010311e <fill_rtcdate>
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
801031e8:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
801031ef:	00 
801031f0:	8d 45 c0             	lea    -0x40(%ebp),%eax
801031f3:	89 44 24 04          	mov    %eax,0x4(%esp)
801031f7:	8d 45 d8             	lea    -0x28(%ebp),%eax
801031fa:	89 04 24             	mov    %eax,(%esp)
801031fd:	e8 2b 20 00 00       	call   8010522d <memcmp>
80103202:	85 c0                	test   %eax,%eax
80103204:	75 b3                	jne    801031b9 <cmostime+0x28>
      break;
80103206:	90                   	nop
  }

  // convert
  if (bcd) {
80103207:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010320b:	0f 84 a8 00 00 00    	je     801032b9 <cmostime+0x128>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103211:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103214:	89 c2                	mov    %eax,%edx
80103216:	c1 ea 04             	shr    $0x4,%edx
80103219:	89 d0                	mov    %edx,%eax
8010321b:	c1 e0 02             	shl    $0x2,%eax
8010321e:	01 d0                	add    %edx,%eax
80103220:	01 c0                	add    %eax,%eax
80103222:	8b 55 d8             	mov    -0x28(%ebp),%edx
80103225:	83 e2 0f             	and    $0xf,%edx
80103228:	01 d0                	add    %edx,%eax
8010322a:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
8010322d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103230:	89 c2                	mov    %eax,%edx
80103232:	c1 ea 04             	shr    $0x4,%edx
80103235:	89 d0                	mov    %edx,%eax
80103237:	c1 e0 02             	shl    $0x2,%eax
8010323a:	01 d0                	add    %edx,%eax
8010323c:	01 c0                	add    %eax,%eax
8010323e:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103241:	83 e2 0f             	and    $0xf,%edx
80103244:	01 d0                	add    %edx,%eax
80103246:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
80103249:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010324c:	89 c2                	mov    %eax,%edx
8010324e:	c1 ea 04             	shr    $0x4,%edx
80103251:	89 d0                	mov    %edx,%eax
80103253:	c1 e0 02             	shl    $0x2,%eax
80103256:	01 d0                	add    %edx,%eax
80103258:	01 c0                	add    %eax,%eax
8010325a:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010325d:	83 e2 0f             	and    $0xf,%edx
80103260:	01 d0                	add    %edx,%eax
80103262:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
80103265:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103268:	89 c2                	mov    %eax,%edx
8010326a:	c1 ea 04             	shr    $0x4,%edx
8010326d:	89 d0                	mov    %edx,%eax
8010326f:	c1 e0 02             	shl    $0x2,%eax
80103272:	01 d0                	add    %edx,%eax
80103274:	01 c0                	add    %eax,%eax
80103276:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103279:	83 e2 0f             	and    $0xf,%edx
8010327c:	01 d0                	add    %edx,%eax
8010327e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
80103281:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103284:	89 c2                	mov    %eax,%edx
80103286:	c1 ea 04             	shr    $0x4,%edx
80103289:	89 d0                	mov    %edx,%eax
8010328b:	c1 e0 02             	shl    $0x2,%eax
8010328e:	01 d0                	add    %edx,%eax
80103290:	01 c0                	add    %eax,%eax
80103292:	8b 55 e8             	mov    -0x18(%ebp),%edx
80103295:	83 e2 0f             	and    $0xf,%edx
80103298:	01 d0                	add    %edx,%eax
8010329a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
8010329d:	8b 45 ec             	mov    -0x14(%ebp),%eax
801032a0:	89 c2                	mov    %eax,%edx
801032a2:	c1 ea 04             	shr    $0x4,%edx
801032a5:	89 d0                	mov    %edx,%eax
801032a7:	c1 e0 02             	shl    $0x2,%eax
801032aa:	01 d0                	add    %edx,%eax
801032ac:	01 c0                	add    %eax,%eax
801032ae:	8b 55 ec             	mov    -0x14(%ebp),%edx
801032b1:	83 e2 0f             	and    $0xf,%edx
801032b4:	01 d0                	add    %edx,%eax
801032b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
801032b9:	8b 45 08             	mov    0x8(%ebp),%eax
801032bc:	8b 55 d8             	mov    -0x28(%ebp),%edx
801032bf:	89 10                	mov    %edx,(%eax)
801032c1:	8b 55 dc             	mov    -0x24(%ebp),%edx
801032c4:	89 50 04             	mov    %edx,0x4(%eax)
801032c7:	8b 55 e0             	mov    -0x20(%ebp),%edx
801032ca:	89 50 08             	mov    %edx,0x8(%eax)
801032cd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801032d0:	89 50 0c             	mov    %edx,0xc(%eax)
801032d3:	8b 55 e8             	mov    -0x18(%ebp),%edx
801032d6:	89 50 10             	mov    %edx,0x10(%eax)
801032d9:	8b 55 ec             	mov    -0x14(%ebp),%edx
801032dc:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
801032df:	8b 45 08             	mov    0x8(%ebp),%eax
801032e2:	8b 40 14             	mov    0x14(%eax),%eax
801032e5:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
801032eb:	8b 45 08             	mov    0x8(%ebp),%eax
801032ee:	89 50 14             	mov    %edx,0x14(%eax)
}
801032f1:	c9                   	leave  
801032f2:	c3                   	ret    
	...

801032f4 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
801032f4:	55                   	push   %ebp
801032f5:	89 e5                	mov    %esp,%ebp
801032f7:	83 ec 38             	sub    $0x38,%esp
  if (sizeof(struct logheader) >= BSIZE)
801032fa:	90                   	nop
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
801032fb:	c7 44 24 04 90 8b 10 	movl   $0x80108b90,0x4(%esp)
80103302:	80 
80103303:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
8010330a:	e8 2f 1c 00 00       	call   80104f3e <initlock>
  readsb(dev, &sb);
8010330f:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103312:	89 44 24 04          	mov    %eax,0x4(%esp)
80103316:	8b 45 08             	mov    0x8(%ebp),%eax
80103319:	89 04 24             	mov    %eax,(%esp)
8010331c:	e8 f7 df ff ff       	call   80101318 <readsb>
  log.start = sb.logstart;
80103321:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103324:	a3 b4 32 11 80       	mov    %eax,0x801132b4
  log.size = sb.nlog;
80103329:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010332c:	a3 b8 32 11 80       	mov    %eax,0x801132b8
  log.dev = dev;
80103331:	8b 45 08             	mov    0x8(%ebp),%eax
80103334:	a3 c4 32 11 80       	mov    %eax,0x801132c4
  recover_from_log();
80103339:	e8 97 01 00 00       	call   801034d5 <recover_from_log>
}
8010333e:	c9                   	leave  
8010333f:	c3                   	ret    

80103340 <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
80103340:	55                   	push   %ebp
80103341:	89 e5                	mov    %esp,%ebp
80103343:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103346:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
8010334d:	e9 89 00 00 00       	jmp    801033db <install_trans+0x9b>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103352:	a1 b4 32 11 80       	mov    0x801132b4,%eax
80103357:	03 45 ec             	add    -0x14(%ebp),%eax
8010335a:	83 c0 01             	add    $0x1,%eax
8010335d:	89 c2                	mov    %eax,%edx
8010335f:	a1 c4 32 11 80       	mov    0x801132c4,%eax
80103364:	89 54 24 04          	mov    %edx,0x4(%esp)
80103368:	89 04 24             	mov    %eax,(%esp)
8010336b:	e8 37 ce ff ff       	call   801001a7 <bread>
80103370:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103373:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103376:	83 c0 10             	add    $0x10,%eax
80103379:	8b 04 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%eax
80103380:	89 c2                	mov    %eax,%edx
80103382:	a1 c4 32 11 80       	mov    0x801132c4,%eax
80103387:	89 54 24 04          	mov    %edx,0x4(%esp)
8010338b:	89 04 24             	mov    %eax,(%esp)
8010338e:	e8 14 ce ff ff       	call   801001a7 <bread>
80103393:	89 45 f4             	mov    %eax,-0xc(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103396:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103399:	8d 50 18             	lea    0x18(%eax),%edx
8010339c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010339f:	83 c0 18             	add    $0x18,%eax
801033a2:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801033a9:	00 
801033aa:	89 54 24 04          	mov    %edx,0x4(%esp)
801033ae:	89 04 24             	mov    %eax,(%esp)
801033b1:	e8 d3 1e 00 00       	call   80105289 <memmove>
    bwrite(dbuf);  // write dst to disk
801033b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801033b9:	89 04 24             	mov    %eax,(%esp)
801033bc:	e8 1d ce ff ff       	call   801001de <bwrite>
    brelse(lbuf); 
801033c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801033c4:	89 04 24             	mov    %eax,(%esp)
801033c7:	e8 4c ce ff ff       	call   80100218 <brelse>
    brelse(dbuf);
801033cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801033cf:	89 04 24             	mov    %eax,(%esp)
801033d2:	e8 41 ce ff ff       	call   80100218 <brelse>
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801033d7:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801033db:	a1 c8 32 11 80       	mov    0x801132c8,%eax
801033e0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801033e3:	0f 8f 69 ff ff ff    	jg     80103352 <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
801033e9:	c9                   	leave  
801033ea:	c3                   	ret    

801033eb <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
801033eb:	55                   	push   %ebp
801033ec:	89 e5                	mov    %esp,%ebp
801033ee:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
801033f1:	a1 b4 32 11 80       	mov    0x801132b4,%eax
801033f6:	89 c2                	mov    %eax,%edx
801033f8:	a1 c4 32 11 80       	mov    0x801132c4,%eax
801033fd:	89 54 24 04          	mov    %edx,0x4(%esp)
80103401:	89 04 24             	mov    %eax,(%esp)
80103404:	e8 9e cd ff ff       	call   801001a7 <bread>
80103409:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
8010340c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010340f:	83 c0 18             	add    $0x18,%eax
80103412:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int i;
  log.lh.n = lh->n;
80103415:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103418:	8b 00                	mov    (%eax),%eax
8010341a:	a3 c8 32 11 80       	mov    %eax,0x801132c8
  for (i = 0; i < log.lh.n; i++) {
8010341f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103426:	eb 1b                	jmp    80103443 <read_head+0x58>
    log.lh.block[i] = lh->block[i];
80103428:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010342b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010342e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103431:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80103435:	8d 51 10             	lea    0x10(%ecx),%edx
80103438:	89 04 95 8c 32 11 80 	mov    %eax,-0x7feecd74(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
8010343f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103443:	a1 c8 32 11 80       	mov    0x801132c8,%eax
80103448:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010344b:	7f db                	jg     80103428 <read_head+0x3d>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
8010344d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103450:	89 04 24             	mov    %eax,(%esp)
80103453:	e8 c0 cd ff ff       	call   80100218 <brelse>
}
80103458:	c9                   	leave  
80103459:	c3                   	ret    

8010345a <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
8010345a:	55                   	push   %ebp
8010345b:	89 e5                	mov    %esp,%ebp
8010345d:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
80103460:	a1 b4 32 11 80       	mov    0x801132b4,%eax
80103465:	89 c2                	mov    %eax,%edx
80103467:	a1 c4 32 11 80       	mov    0x801132c4,%eax
8010346c:	89 54 24 04          	mov    %edx,0x4(%esp)
80103470:	89 04 24             	mov    %eax,(%esp)
80103473:	e8 2f cd ff ff       	call   801001a7 <bread>
80103478:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
8010347b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010347e:	83 c0 18             	add    $0x18,%eax
80103481:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int i;
  hb->n = log.lh.n;
80103484:	8b 15 c8 32 11 80    	mov    0x801132c8,%edx
8010348a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010348d:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
8010348f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103496:	eb 1b                	jmp    801034b3 <write_head+0x59>
    hb->block[i] = log.lh.block[i];
80103498:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010349b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010349e:	83 c0 10             	add    $0x10,%eax
801034a1:	8b 0c 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%ecx
801034a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801034ab:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
801034af:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801034b3:	a1 c8 32 11 80       	mov    0x801132c8,%eax
801034b8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801034bb:	7f db                	jg     80103498 <write_head+0x3e>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
801034bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
801034c0:	89 04 24             	mov    %eax,(%esp)
801034c3:	e8 16 cd ff ff       	call   801001de <bwrite>
  brelse(buf);
801034c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801034cb:	89 04 24             	mov    %eax,(%esp)
801034ce:	e8 45 cd ff ff       	call   80100218 <brelse>
}
801034d3:	c9                   	leave  
801034d4:	c3                   	ret    

801034d5 <recover_from_log>:

static void
recover_from_log(void)
{
801034d5:	55                   	push   %ebp
801034d6:	89 e5                	mov    %esp,%ebp
801034d8:	83 ec 08             	sub    $0x8,%esp
  read_head();      
801034db:	e8 0b ff ff ff       	call   801033eb <read_head>
  install_trans(); // if committed, copy from log to disk
801034e0:	e8 5b fe ff ff       	call   80103340 <install_trans>
  log.lh.n = 0;
801034e5:	c7 05 c8 32 11 80 00 	movl   $0x0,0x801132c8
801034ec:	00 00 00 
  write_head(); // clear the log
801034ef:	e8 66 ff ff ff       	call   8010345a <write_head>
}
801034f4:	c9                   	leave  
801034f5:	c3                   	ret    

801034f6 <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
801034f6:	55                   	push   %ebp
801034f7:	89 e5                	mov    %esp,%ebp
801034f9:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
801034fc:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
80103503:	e8 57 1a 00 00       	call   80104f5f <acquire>
  while(1){
    if(log.committing){
80103508:	a1 c0 32 11 80       	mov    0x801132c0,%eax
8010350d:	85 c0                	test   %eax,%eax
8010350f:	74 16                	je     80103527 <begin_op+0x31>
      sleep(&log, &log.lock);
80103511:	c7 44 24 04 80 32 11 	movl   $0x80113280,0x4(%esp)
80103518:	80 
80103519:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
80103520:	e8 5f 17 00 00       	call   80104c84 <sleep>
    } else {
      log.outstanding += 1;
      release(&log.lock);
      break;
    }
  }
80103525:	eb e1                	jmp    80103508 <begin_op+0x12>
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103527:	8b 0d c8 32 11 80    	mov    0x801132c8,%ecx
8010352d:	a1 bc 32 11 80       	mov    0x801132bc,%eax
80103532:	8d 50 01             	lea    0x1(%eax),%edx
80103535:	89 d0                	mov    %edx,%eax
80103537:	c1 e0 02             	shl    $0x2,%eax
8010353a:	01 d0                	add    %edx,%eax
8010353c:	01 c0                	add    %eax,%eax
8010353e:	8d 04 01             	lea    (%ecx,%eax,1),%eax
80103541:	83 f8 1e             	cmp    $0x1e,%eax
80103544:	7e 16                	jle    8010355c <begin_op+0x66>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
80103546:	c7 44 24 04 80 32 11 	movl   $0x80113280,0x4(%esp)
8010354d:	80 
8010354e:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
80103555:	e8 2a 17 00 00       	call   80104c84 <sleep>
    } else {
      log.outstanding += 1;
      release(&log.lock);
      break;
    }
  }
8010355a:	eb ac                	jmp    80103508 <begin_op+0x12>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
8010355c:	a1 bc 32 11 80       	mov    0x801132bc,%eax
80103561:	83 c0 01             	add    $0x1,%eax
80103564:	a3 bc 32 11 80       	mov    %eax,0x801132bc
      release(&log.lock);
80103569:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
80103570:	e8 4b 1a 00 00       	call   80104fc0 <release>
      break;
80103575:	90                   	nop
    }
  }
}
80103576:	c9                   	leave  
80103577:	c3                   	ret    

80103578 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103578:	55                   	push   %ebp
80103579:	89 e5                	mov    %esp,%ebp
8010357b:	83 ec 28             	sub    $0x28,%esp
  int do_commit = 0;
8010357e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
80103585:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
8010358c:	e8 ce 19 00 00       	call   80104f5f <acquire>
  log.outstanding -= 1;
80103591:	a1 bc 32 11 80       	mov    0x801132bc,%eax
80103596:	83 e8 01             	sub    $0x1,%eax
80103599:	a3 bc 32 11 80       	mov    %eax,0x801132bc
  if(log.committing)
8010359e:	a1 c0 32 11 80       	mov    0x801132c0,%eax
801035a3:	85 c0                	test   %eax,%eax
801035a5:	74 0c                	je     801035b3 <end_op+0x3b>
    panic("log.committing");
801035a7:	c7 04 24 94 8b 10 80 	movl   $0x80108b94,(%esp)
801035ae:	e8 8a cf ff ff       	call   8010053d <panic>
  if(log.outstanding == 0){
801035b3:	a1 bc 32 11 80       	mov    0x801132bc,%eax
801035b8:	85 c0                	test   %eax,%eax
801035ba:	75 13                	jne    801035cf <end_op+0x57>
    do_commit = 1;
801035bc:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
801035c3:	c7 05 c0 32 11 80 01 	movl   $0x1,0x801132c0
801035ca:	00 00 00 
801035cd:	eb 0c                	jmp    801035db <end_op+0x63>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
801035cf:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
801035d6:	e8 86 17 00 00       	call   80104d61 <wakeup>
  }
  release(&log.lock);
801035db:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
801035e2:	e8 d9 19 00 00       	call   80104fc0 <release>

  if(do_commit){
801035e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801035eb:	74 33                	je     80103620 <end_op+0xa8>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
801035ed:	e8 db 00 00 00       	call   801036cd <commit>
    acquire(&log.lock);
801035f2:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
801035f9:	e8 61 19 00 00       	call   80104f5f <acquire>
    log.committing = 0;
801035fe:	c7 05 c0 32 11 80 00 	movl   $0x0,0x801132c0
80103605:	00 00 00 
    wakeup(&log);
80103608:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
8010360f:	e8 4d 17 00 00       	call   80104d61 <wakeup>
    release(&log.lock);
80103614:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
8010361b:	e8 a0 19 00 00       	call   80104fc0 <release>
  }
}
80103620:	c9                   	leave  
80103621:	c3                   	ret    

80103622 <write_log>:

// Copy modified blocks from cache to log.
static void 
write_log(void)
{
80103622:	55                   	push   %ebp
80103623:	89 e5                	mov    %esp,%ebp
80103625:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103628:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
8010362f:	e9 89 00 00 00       	jmp    801036bd <write_log+0x9b>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103634:	a1 b4 32 11 80       	mov    0x801132b4,%eax
80103639:	03 45 ec             	add    -0x14(%ebp),%eax
8010363c:	83 c0 01             	add    $0x1,%eax
8010363f:	89 c2                	mov    %eax,%edx
80103641:	a1 c4 32 11 80       	mov    0x801132c4,%eax
80103646:	89 54 24 04          	mov    %edx,0x4(%esp)
8010364a:	89 04 24             	mov    %eax,(%esp)
8010364d:	e8 55 cb ff ff       	call   801001a7 <bread>
80103652:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103655:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103658:	83 c0 10             	add    $0x10,%eax
8010365b:	8b 04 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%eax
80103662:	89 c2                	mov    %eax,%edx
80103664:	a1 c4 32 11 80       	mov    0x801132c4,%eax
80103669:	89 54 24 04          	mov    %edx,0x4(%esp)
8010366d:	89 04 24             	mov    %eax,(%esp)
80103670:	e8 32 cb ff ff       	call   801001a7 <bread>
80103675:	89 45 f4             	mov    %eax,-0xc(%ebp)
    memmove(to->data, from->data, BSIZE);
80103678:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010367b:	8d 50 18             	lea    0x18(%eax),%edx
8010367e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103681:	83 c0 18             	add    $0x18,%eax
80103684:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
8010368b:	00 
8010368c:	89 54 24 04          	mov    %edx,0x4(%esp)
80103690:	89 04 24             	mov    %eax,(%esp)
80103693:	e8 f1 1b 00 00       	call   80105289 <memmove>
    bwrite(to);  // write the log
80103698:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010369b:	89 04 24             	mov    %eax,(%esp)
8010369e:	e8 3b cb ff ff       	call   801001de <bwrite>
    brelse(from); 
801036a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036a6:	89 04 24             	mov    %eax,(%esp)
801036a9:	e8 6a cb ff ff       	call   80100218 <brelse>
    brelse(to);
801036ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
801036b1:	89 04 24             	mov    %eax,(%esp)
801036b4:	e8 5f cb ff ff       	call   80100218 <brelse>
static void 
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801036b9:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801036bd:	a1 c8 32 11 80       	mov    0x801132c8,%eax
801036c2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801036c5:	0f 8f 69 ff ff ff    	jg     80103634 <write_log+0x12>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from); 
    brelse(to);
  }
}
801036cb:	c9                   	leave  
801036cc:	c3                   	ret    

801036cd <commit>:

static void
commit()
{
801036cd:	55                   	push   %ebp
801036ce:	89 e5                	mov    %esp,%ebp
801036d0:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
801036d3:	a1 c8 32 11 80       	mov    0x801132c8,%eax
801036d8:	85 c0                	test   %eax,%eax
801036da:	7e 1e                	jle    801036fa <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
801036dc:	e8 41 ff ff ff       	call   80103622 <write_log>
    write_head();    // Write header to disk -- the real commit
801036e1:	e8 74 fd ff ff       	call   8010345a <write_head>
    install_trans(); // Now install writes to home locations
801036e6:	e8 55 fc ff ff       	call   80103340 <install_trans>
    log.lh.n = 0; 
801036eb:	c7 05 c8 32 11 80 00 	movl   $0x0,0x801132c8
801036f2:	00 00 00 
    write_head();    // Erase the transaction from the log
801036f5:	e8 60 fd ff ff       	call   8010345a <write_head>
  }
}
801036fa:	c9                   	leave  
801036fb:	c3                   	ret    

801036fc <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801036fc:	55                   	push   %ebp
801036fd:	89 e5                	mov    %esp,%ebp
801036ff:	83 ec 28             	sub    $0x28,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103702:	a1 c8 32 11 80       	mov    0x801132c8,%eax
80103707:	83 f8 1d             	cmp    $0x1d,%eax
8010370a:	7f 12                	jg     8010371e <log_write+0x22>
8010370c:	a1 c8 32 11 80       	mov    0x801132c8,%eax
80103711:	8b 15 b8 32 11 80    	mov    0x801132b8,%edx
80103717:	83 ea 01             	sub    $0x1,%edx
8010371a:	39 d0                	cmp    %edx,%eax
8010371c:	7c 0c                	jl     8010372a <log_write+0x2e>
    panic("too big a transaction");
8010371e:	c7 04 24 a3 8b 10 80 	movl   $0x80108ba3,(%esp)
80103725:	e8 13 ce ff ff       	call   8010053d <panic>
  if (log.outstanding < 1)
8010372a:	a1 bc 32 11 80       	mov    0x801132bc,%eax
8010372f:	85 c0                	test   %eax,%eax
80103731:	7f 0c                	jg     8010373f <log_write+0x43>
    panic("log_write outside of trans");
80103733:	c7 04 24 b9 8b 10 80 	movl   $0x80108bb9,(%esp)
8010373a:	e8 fe cd ff ff       	call   8010053d <panic>

  acquire(&log.lock);
8010373f:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
80103746:	e8 14 18 00 00       	call   80104f5f <acquire>
  for (i = 0; i < log.lh.n; i++) {
8010374b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103752:	eb 1d                	jmp    80103771 <log_write+0x75>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103754:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103757:	83 c0 10             	add    $0x10,%eax
8010375a:	8b 04 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%eax
80103761:	89 c2                	mov    %eax,%edx
80103763:	8b 45 08             	mov    0x8(%ebp),%eax
80103766:	8b 40 08             	mov    0x8(%eax),%eax
80103769:	39 c2                	cmp    %eax,%edx
8010376b:	74 10                	je     8010377d <log_write+0x81>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
8010376d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103771:	a1 c8 32 11 80       	mov    0x801132c8,%eax
80103776:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103779:	7f d9                	jg     80103754 <log_write+0x58>
8010377b:	eb 01                	jmp    8010377e <log_write+0x82>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
8010377d:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
8010377e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103781:	8b 45 08             	mov    0x8(%ebp),%eax
80103784:	8b 40 08             	mov    0x8(%eax),%eax
80103787:	83 c2 10             	add    $0x10,%edx
8010378a:	89 04 95 8c 32 11 80 	mov    %eax,-0x7feecd74(,%edx,4)
  if (i == log.lh.n)
80103791:	a1 c8 32 11 80       	mov    0x801132c8,%eax
80103796:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103799:	75 0d                	jne    801037a8 <log_write+0xac>
    log.lh.n++;
8010379b:	a1 c8 32 11 80       	mov    0x801132c8,%eax
801037a0:	83 c0 01             	add    $0x1,%eax
801037a3:	a3 c8 32 11 80       	mov    %eax,0x801132c8
  b->flags |= B_DIRTY; // prevent eviction
801037a8:	8b 45 08             	mov    0x8(%ebp),%eax
801037ab:	8b 00                	mov    (%eax),%eax
801037ad:	89 c2                	mov    %eax,%edx
801037af:	83 ca 04             	or     $0x4,%edx
801037b2:	8b 45 08             	mov    0x8(%ebp),%eax
801037b5:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
801037b7:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
801037be:	e8 fd 17 00 00       	call   80104fc0 <release>
}
801037c3:	c9                   	leave  
801037c4:	c3                   	ret    
801037c5:	00 00                	add    %al,(%eax)
	...

801037c8 <v2p>:
801037c8:	55                   	push   %ebp
801037c9:	89 e5                	mov    %esp,%ebp
801037cb:	8b 45 08             	mov    0x8(%ebp),%eax
801037ce:	2d 00 00 00 80       	sub    $0x80000000,%eax
801037d3:	5d                   	pop    %ebp
801037d4:	c3                   	ret    

801037d5 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
801037d5:	55                   	push   %ebp
801037d6:	89 e5                	mov    %esp,%ebp
801037d8:	8b 45 08             	mov    0x8(%ebp),%eax
801037db:	2d 00 00 00 80       	sub    $0x80000000,%eax
801037e0:	5d                   	pop    %ebp
801037e1:	c3                   	ret    

801037e2 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
801037e2:	55                   	push   %ebp
801037e3:	89 e5                	mov    %esp,%ebp
801037e5:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801037e8:	8b 55 08             	mov    0x8(%ebp),%edx
801037eb:	8b 45 0c             	mov    0xc(%ebp),%eax
801037ee:	8b 4d 08             	mov    0x8(%ebp),%ecx
801037f1:	f0 87 02             	lock xchg %eax,(%edx)
801037f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
801037f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801037fa:	c9                   	leave  
801037fb:	c3                   	ret    

801037fc <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
801037fc:	55                   	push   %ebp
801037fd:	89 e5                	mov    %esp,%ebp
801037ff:	83 e4 f0             	and    $0xfffffff0,%esp
80103802:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103805:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
8010380c:	80 
8010380d:	c7 04 24 5c 84 11 80 	movl   $0x8011845c,(%esp)
80103814:	e8 84 f2 ff ff       	call   80102a9d <kinit1>
  kvmalloc();      // kernel page table
80103819:	e8 49 49 00 00       	call   80108167 <kvmalloc>
  mpinit();        // collect info about this machine
8010381e:	e8 41 04 00 00       	call   80103c64 <mpinit>
  lapicinit();
80103823:	e8 e1 f5 ff ff       	call   80102e09 <lapicinit>
  seginit();       // set up segments
80103828:	e8 dc 42 00 00       	call   80107b09 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
8010382d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103833:	0f b6 00             	movzbl (%eax),%eax
80103836:	0f b6 c0             	movzbl %al,%eax
80103839:	89 44 24 04          	mov    %eax,0x4(%esp)
8010383d:	c7 04 24 d4 8b 10 80 	movl   $0x80108bd4,(%esp)
80103844:	e8 54 cb ff ff       	call   8010039d <cprintf>
  picinit();       // interrupt controller
80103849:	e8 7c 06 00 00       	call   80103eca <picinit>
  ioapicinit();    // another interrupt controller
8010384e:	e8 3a f1 ff ff       	call   8010298d <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
80103853:	e8 62 d2 ff ff       	call   80100aba <consoleinit>
  uartinit();      // serial port
80103858:	e8 f6 35 00 00       	call   80106e53 <uartinit>
  pinit();         // process table
8010385d:	e8 78 0b 00 00       	call   801043da <pinit>
  tvinit();        // trap vectors
80103862:	e8 f7 2e 00 00       	call   8010675e <tvinit>
  binit();         // buffer cache
80103867:	e8 c8 c7 ff ff       	call   80100034 <binit>
  fileinit();      // file table
8010386c:	e8 bb d6 ff ff       	call   80100f2c <fileinit>
  ideinit();       // disk
80103871:	e8 46 ed ff ff       	call   801025bc <ideinit>
  if(!ismp)
80103876:	a1 64 33 11 80       	mov    0x80113364,%eax
8010387b:	85 c0                	test   %eax,%eax
8010387d:	75 05                	jne    80103884 <main+0x88>
    timerinit();   // uniprocessor timer
8010387f:	e8 22 2e 00 00       	call   801066a6 <timerinit>
  startothers();   // start other processors
80103884:	e8 7f 00 00 00       	call   80103908 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103889:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80103890:	8e 
80103891:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80103898:	e8 38 f2 ff ff       	call   80102ad5 <kinit2>
  userinit();      // first user process
8010389d:	e8 a9 0c 00 00       	call   8010454b <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
801038a2:	e8 1a 00 00 00       	call   801038c1 <mpmain>

801038a7 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
801038a7:	55                   	push   %ebp
801038a8:	89 e5                	mov    %esp,%ebp
801038aa:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
801038ad:	e8 cc 48 00 00       	call   8010817e <switchkvm>
  seginit();
801038b2:	e8 52 42 00 00       	call   80107b09 <seginit>
  lapicinit();
801038b7:	e8 4d f5 ff ff       	call   80102e09 <lapicinit>
  mpmain();
801038bc:	e8 00 00 00 00       	call   801038c1 <mpmain>

801038c1 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801038c1:	55                   	push   %ebp
801038c2:	89 e5                	mov    %esp,%ebp
801038c4:	83 ec 18             	sub    $0x18,%esp
  cprintf("cpu%d: starting\n", cpu->id);
801038c7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801038cd:	0f b6 00             	movzbl (%eax),%eax
801038d0:	0f b6 c0             	movzbl %al,%eax
801038d3:	89 44 24 04          	mov    %eax,0x4(%esp)
801038d7:	c7 04 24 eb 8b 10 80 	movl   $0x80108beb,(%esp)
801038de:	e8 ba ca ff ff       	call   8010039d <cprintf>
  idtinit();       // load idt register
801038e3:	e8 e6 2f 00 00       	call   801068ce <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
801038e8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801038ee:	05 a8 00 00 00       	add    $0xa8,%eax
801038f3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801038fa:	00 
801038fb:	89 04 24             	mov    %eax,(%esp)
801038fe:	e8 df fe ff ff       	call   801037e2 <xchg>
  scheduler();     // start running processes
80103903:	e8 bc 11 00 00       	call   80104ac4 <scheduler>

80103908 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103908:	55                   	push   %ebp
80103909:	89 e5                	mov    %esp,%ebp
8010390b:	53                   	push   %ebx
8010390c:	83 ec 24             	sub    $0x24,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
8010390f:	c7 04 24 00 70 00 00 	movl   $0x7000,(%esp)
80103916:	e8 ba fe ff ff       	call   801037d5 <p2v>
8010391b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
8010391e:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103923:	89 44 24 08          	mov    %eax,0x8(%esp)
80103927:	c7 44 24 04 2c c5 10 	movl   $0x8010c52c,0x4(%esp)
8010392e:	80 
8010392f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103932:	89 04 24             	mov    %eax,(%esp)
80103935:	e8 4f 19 00 00       	call   80105289 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010393a:	c7 45 f0 80 33 11 80 	movl   $0x80113380,-0x10(%ebp)
80103941:	e9 85 00 00 00       	jmp    801039cb <startothers+0xc3>
    if(c == cpus+cpunum())  // We've started already.
80103946:	e8 1a f6 ff ff       	call   80102f65 <cpunum>
8010394b:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103951:	05 80 33 11 80       	add    $0x80113380,%eax
80103956:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80103959:	74 68                	je     801039c3 <startothers+0xbb>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
8010395b:	e8 6e f2 ff ff       	call   80102bce <kalloc>
80103960:	89 45 f4             	mov    %eax,-0xc(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103963:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103966:	83 e8 04             	sub    $0x4,%eax
80103969:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010396c:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103972:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103974:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103977:	83 e8 08             	sub    $0x8,%eax
8010397a:	c7 00 a7 38 10 80    	movl   $0x801038a7,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
80103980:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103983:	8d 58 f4             	lea    -0xc(%eax),%ebx
80103986:	c7 04 24 00 b0 10 80 	movl   $0x8010b000,(%esp)
8010398d:	e8 36 fe ff ff       	call   801037c8 <v2p>
80103992:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
80103994:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103997:	89 04 24             	mov    %eax,(%esp)
8010399a:	e8 29 fe ff ff       	call   801037c8 <v2p>
8010399f:	8b 55 f0             	mov    -0x10(%ebp),%edx
801039a2:	0f b6 12             	movzbl (%edx),%edx
801039a5:	0f b6 d2             	movzbl %dl,%edx
801039a8:	89 44 24 04          	mov    %eax,0x4(%esp)
801039ac:	89 14 24             	mov    %edx,(%esp)
801039af:	e8 37 f6 ff ff       	call   80102feb <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801039b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801039b7:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801039bd:	85 c0                	test   %eax,%eax
801039bf:	74 f3                	je     801039b4 <startothers+0xac>
801039c1:	eb 01                	jmp    801039c4 <startothers+0xbc>
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
    if(c == cpus+cpunum())  // We've started already.
      continue;
801039c3:	90                   	nop
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
801039c4:	81 45 f0 bc 00 00 00 	addl   $0xbc,-0x10(%ebp)
801039cb:	a1 60 39 11 80       	mov    0x80113960,%eax
801039d0:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801039d6:	05 80 33 11 80       	add    $0x80113380,%eax
801039db:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801039de:	0f 87 62 ff ff ff    	ja     80103946 <startothers+0x3e>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
801039e4:	83 c4 24             	add    $0x24,%esp
801039e7:	5b                   	pop    %ebx
801039e8:	5d                   	pop    %ebp
801039e9:	c3                   	ret    
	...

801039ec <p2v>:
801039ec:	55                   	push   %ebp
801039ed:	89 e5                	mov    %esp,%ebp
801039ef:	8b 45 08             	mov    0x8(%ebp),%eax
801039f2:	2d 00 00 00 80       	sub    $0x80000000,%eax
801039f7:	5d                   	pop    %ebp
801039f8:	c3                   	ret    

801039f9 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801039f9:	55                   	push   %ebp
801039fa:	89 e5                	mov    %esp,%ebp
801039fc:	83 ec 14             	sub    $0x14,%esp
801039ff:	8b 45 08             	mov    0x8(%ebp),%eax
80103a02:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103a06:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103a0a:	89 c2                	mov    %eax,%edx
80103a0c:	ec                   	in     (%dx),%al
80103a0d:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103a10:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103a14:	c9                   	leave  
80103a15:	c3                   	ret    

80103a16 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103a16:	55                   	push   %ebp
80103a17:	89 e5                	mov    %esp,%ebp
80103a19:	83 ec 08             	sub    $0x8,%esp
80103a1c:	8b 55 08             	mov    0x8(%ebp),%edx
80103a1f:	8b 45 0c             	mov    0xc(%ebp),%eax
80103a22:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103a26:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103a29:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103a2d:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103a31:	ee                   	out    %al,(%dx)
}
80103a32:	c9                   	leave  
80103a33:	c3                   	ret    

80103a34 <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80103a34:	55                   	push   %ebp
80103a35:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103a37:	a1 64 c6 10 80       	mov    0x8010c664,%eax
80103a3c:	89 c2                	mov    %eax,%edx
80103a3e:	b8 80 33 11 80       	mov    $0x80113380,%eax
80103a43:	89 d1                	mov    %edx,%ecx
80103a45:	29 c1                	sub    %eax,%ecx
80103a47:	89 c8                	mov    %ecx,%eax
80103a49:	c1 f8 02             	sar    $0x2,%eax
80103a4c:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
80103a52:	5d                   	pop    %ebp
80103a53:	c3                   	ret    

80103a54 <sum>:

static uchar
sum(uchar *addr, int len)
{
80103a54:	55                   	push   %ebp
80103a55:	89 e5                	mov    %esp,%ebp
80103a57:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103a5a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  for(i=0; i<len; i++)
80103a61:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80103a68:	eb 13                	jmp    80103a7d <sum+0x29>
    sum += addr[i];
80103a6a:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103a6d:	03 45 08             	add    0x8(%ebp),%eax
80103a70:	0f b6 00             	movzbl (%eax),%eax
80103a73:	0f b6 c0             	movzbl %al,%eax
80103a76:	01 45 fc             	add    %eax,-0x4(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
80103a79:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80103a7d:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103a80:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103a83:	7c e5                	jl     80103a6a <sum+0x16>
    sum += addr[i];
  return sum;
80103a85:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103a88:	c9                   	leave  
80103a89:	c3                   	ret    

80103a8a <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103a8a:	55                   	push   %ebp
80103a8b:	89 e5                	mov    %esp,%ebp
80103a8d:	83 ec 28             	sub    $0x28,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
80103a90:	8b 45 08             	mov    0x8(%ebp),%eax
80103a93:	89 04 24             	mov    %eax,(%esp)
80103a96:	e8 51 ff ff ff       	call   801039ec <p2v>
80103a9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  e = addr+len;
80103a9e:	8b 45 0c             	mov    0xc(%ebp),%eax
80103aa1:	03 45 f4             	add    -0xc(%ebp),%eax
80103aa4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103aaa:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103aad:	eb 3f                	jmp    80103aee <mpsearch1+0x64>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103aaf:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103ab6:	00 
80103ab7:	c7 44 24 04 fc 8b 10 	movl   $0x80108bfc,0x4(%esp)
80103abe:	80 
80103abf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ac2:	89 04 24             	mov    %eax,(%esp)
80103ac5:	e8 63 17 00 00       	call   8010522d <memcmp>
80103aca:	85 c0                	test   %eax,%eax
80103acc:	75 1c                	jne    80103aea <mpsearch1+0x60>
80103ace:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
80103ad5:	00 
80103ad6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ad9:	89 04 24             	mov    %eax,(%esp)
80103adc:	e8 73 ff ff ff       	call   80103a54 <sum>
80103ae1:	84 c0                	test   %al,%al
80103ae3:	75 05                	jne    80103aea <mpsearch1+0x60>
      return (struct mp*)p;
80103ae5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ae8:	eb 11                	jmp    80103afb <mpsearch1+0x71>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103aea:	83 45 f0 10          	addl   $0x10,-0x10(%ebp)
80103aee:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103af1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103af4:	72 b9                	jb     80103aaf <mpsearch1+0x25>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103af6:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103afb:	c9                   	leave  
80103afc:	c3                   	ret    

80103afd <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103afd:	55                   	push   %ebp
80103afe:	89 e5                	mov    %esp,%ebp
80103b00:	83 ec 28             	sub    $0x28,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103b03:	c7 45 ec 00 04 00 80 	movl   $0x80000400,-0x14(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103b0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b0d:	83 c0 0f             	add    $0xf,%eax
80103b10:	0f b6 00             	movzbl (%eax),%eax
80103b13:	0f b6 c0             	movzbl %al,%eax
80103b16:	89 c2                	mov    %eax,%edx
80103b18:	c1 e2 08             	shl    $0x8,%edx
80103b1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b1e:	83 c0 0e             	add    $0xe,%eax
80103b21:	0f b6 00             	movzbl (%eax),%eax
80103b24:	0f b6 c0             	movzbl %al,%eax
80103b27:	09 d0                	or     %edx,%eax
80103b29:	c1 e0 04             	shl    $0x4,%eax
80103b2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103b2f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103b33:	74 21                	je     80103b56 <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103b35:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103b3c:	00 
80103b3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b40:	89 04 24             	mov    %eax,(%esp)
80103b43:	e8 42 ff ff ff       	call   80103a8a <mpsearch1>
80103b48:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103b4b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103b4f:	74 50                	je     80103ba1 <mpsearch+0xa4>
      return mp;
80103b51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b54:	eb 5f                	jmp    80103bb5 <mpsearch+0xb8>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103b56:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b59:	83 c0 14             	add    $0x14,%eax
80103b5c:	0f b6 00             	movzbl (%eax),%eax
80103b5f:	0f b6 c0             	movzbl %al,%eax
80103b62:	89 c2                	mov    %eax,%edx
80103b64:	c1 e2 08             	shl    $0x8,%edx
80103b67:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b6a:	83 c0 13             	add    $0x13,%eax
80103b6d:	0f b6 00             	movzbl (%eax),%eax
80103b70:	0f b6 c0             	movzbl %al,%eax
80103b73:	09 d0                	or     %edx,%eax
80103b75:	c1 e0 0a             	shl    $0xa,%eax
80103b78:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103b7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b7e:	2d 00 04 00 00       	sub    $0x400,%eax
80103b83:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103b8a:	00 
80103b8b:	89 04 24             	mov    %eax,(%esp)
80103b8e:	e8 f7 fe ff ff       	call   80103a8a <mpsearch1>
80103b93:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103b96:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103b9a:	74 05                	je     80103ba1 <mpsearch+0xa4>
      return mp;
80103b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b9f:	eb 14                	jmp    80103bb5 <mpsearch+0xb8>
  }
  return mpsearch1(0xF0000, 0x10000);
80103ba1:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80103ba8:	00 
80103ba9:	c7 04 24 00 00 0f 00 	movl   $0xf0000,(%esp)
80103bb0:	e8 d5 fe ff ff       	call   80103a8a <mpsearch1>
}
80103bb5:	c9                   	leave  
80103bb6:	c3                   	ret    

80103bb7 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103bb7:	55                   	push   %ebp
80103bb8:	89 e5                	mov    %esp,%ebp
80103bba:	83 ec 28             	sub    $0x28,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103bbd:	e8 3b ff ff ff       	call   80103afd <mpsearch>
80103bc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103bc5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103bc9:	74 0a                	je     80103bd5 <mpconfig+0x1e>
80103bcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bce:	8b 40 04             	mov    0x4(%eax),%eax
80103bd1:	85 c0                	test   %eax,%eax
80103bd3:	75 0a                	jne    80103bdf <mpconfig+0x28>
    return 0;
80103bd5:	b8 00 00 00 00       	mov    $0x0,%eax
80103bda:	e9 83 00 00 00       	jmp    80103c62 <mpconfig+0xab>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
80103bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103be2:	8b 40 04             	mov    0x4(%eax),%eax
80103be5:	89 04 24             	mov    %eax,(%esp)
80103be8:	e8 ff fd ff ff       	call   801039ec <p2v>
80103bed:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103bf0:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103bf7:	00 
80103bf8:	c7 44 24 04 01 8c 10 	movl   $0x80108c01,0x4(%esp)
80103bff:	80 
80103c00:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c03:	89 04 24             	mov    %eax,(%esp)
80103c06:	e8 22 16 00 00       	call   8010522d <memcmp>
80103c0b:	85 c0                	test   %eax,%eax
80103c0d:	74 07                	je     80103c16 <mpconfig+0x5f>
    return 0;
80103c0f:	b8 00 00 00 00       	mov    $0x0,%eax
80103c14:	eb 4c                	jmp    80103c62 <mpconfig+0xab>
  if(conf->version != 1 && conf->version != 4)
80103c16:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c19:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103c1d:	3c 01                	cmp    $0x1,%al
80103c1f:	74 12                	je     80103c33 <mpconfig+0x7c>
80103c21:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c24:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103c28:	3c 04                	cmp    $0x4,%al
80103c2a:	74 07                	je     80103c33 <mpconfig+0x7c>
    return 0;
80103c2c:	b8 00 00 00 00       	mov    $0x0,%eax
80103c31:	eb 2f                	jmp    80103c62 <mpconfig+0xab>
  if(sum((uchar*)conf, conf->length) != 0)
80103c33:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c36:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103c3a:	0f b7 d0             	movzwl %ax,%edx
80103c3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c40:	89 54 24 04          	mov    %edx,0x4(%esp)
80103c44:	89 04 24             	mov    %eax,(%esp)
80103c47:	e8 08 fe ff ff       	call   80103a54 <sum>
80103c4c:	84 c0                	test   %al,%al
80103c4e:	74 07                	je     80103c57 <mpconfig+0xa0>
    return 0;
80103c50:	b8 00 00 00 00       	mov    $0x0,%eax
80103c55:	eb 0b                	jmp    80103c62 <mpconfig+0xab>
  *pmp = mp;
80103c57:	8b 45 08             	mov    0x8(%ebp),%eax
80103c5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103c5d:	89 10                	mov    %edx,(%eax)
  return conf;
80103c5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103c62:	c9                   	leave  
80103c63:	c3                   	ret    

80103c64 <mpinit>:

void
mpinit(void)
{
80103c64:	55                   	push   %ebp
80103c65:	89 e5                	mov    %esp,%ebp
80103c67:	83 ec 38             	sub    $0x38,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103c6a:	c7 05 64 c6 10 80 80 	movl   $0x80113380,0x8010c664
80103c71:	33 11 80 
  if((conf = mpconfig(&mp)) == 0)
80103c74:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103c77:	89 04 24             	mov    %eax,(%esp)
80103c7a:	e8 38 ff ff ff       	call   80103bb7 <mpconfig>
80103c7f:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103c82:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103c86:	0f 84 9d 01 00 00    	je     80103e29 <mpinit+0x1c5>
    return;
  ismp = 1;
80103c8c:	c7 05 64 33 11 80 01 	movl   $0x1,0x80113364
80103c93:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103c96:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103c99:	8b 40 24             	mov    0x24(%eax),%eax
80103c9c:	a3 7c 32 11 80       	mov    %eax,0x8011327c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103ca1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103ca4:	83 c0 2c             	add    $0x2c,%eax
80103ca7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103caa:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103cad:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103cb0:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103cb4:	0f b7 c0             	movzwl %ax,%eax
80103cb7:	8d 04 02             	lea    (%edx,%eax,1),%eax
80103cba:	89 45 e8             	mov    %eax,-0x18(%ebp)
80103cbd:	e9 f2 00 00 00       	jmp    80103db4 <mpinit+0x150>
    switch(*p){
80103cc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103cc5:	0f b6 00             	movzbl (%eax),%eax
80103cc8:	0f b6 c0             	movzbl %al,%eax
80103ccb:	83 f8 04             	cmp    $0x4,%eax
80103cce:	0f 87 bd 00 00 00    	ja     80103d91 <mpinit+0x12d>
80103cd4:	8b 04 85 44 8c 10 80 	mov    -0x7fef73bc(,%eax,4),%eax
80103cdb:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103cdd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103ce0:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(ncpu != proc->apicid){
80103ce3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ce6:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103cea:	0f b6 d0             	movzbl %al,%edx
80103ced:	a1 60 39 11 80       	mov    0x80113960,%eax
80103cf2:	39 c2                	cmp    %eax,%edx
80103cf4:	74 2d                	je     80103d23 <mpinit+0xbf>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80103cf6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cf9:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103cfd:	0f b6 d0             	movzbl %al,%edx
80103d00:	a1 60 39 11 80       	mov    0x80113960,%eax
80103d05:	89 54 24 08          	mov    %edx,0x8(%esp)
80103d09:	89 44 24 04          	mov    %eax,0x4(%esp)
80103d0d:	c7 04 24 06 8c 10 80 	movl   $0x80108c06,(%esp)
80103d14:	e8 84 c6 ff ff       	call   8010039d <cprintf>
        ismp = 0;
80103d19:	c7 05 64 33 11 80 00 	movl   $0x0,0x80113364
80103d20:	00 00 00 
      }
      if(proc->flags & MPBOOT)
80103d23:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d26:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80103d2a:	0f b6 c0             	movzbl %al,%eax
80103d2d:	83 e0 02             	and    $0x2,%eax
80103d30:	85 c0                	test   %eax,%eax
80103d32:	74 15                	je     80103d49 <mpinit+0xe5>
        bcpu = &cpus[ncpu];
80103d34:	a1 60 39 11 80       	mov    0x80113960,%eax
80103d39:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103d3f:	05 80 33 11 80       	add    $0x80113380,%eax
80103d44:	a3 64 c6 10 80       	mov    %eax,0x8010c664
      cpus[ncpu].id = ncpu;
80103d49:	a1 60 39 11 80       	mov    0x80113960,%eax
80103d4e:	8b 15 60 39 11 80    	mov    0x80113960,%edx
80103d54:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103d5a:	88 90 80 33 11 80    	mov    %dl,-0x7feecc80(%eax)
      ncpu++;
80103d60:	a1 60 39 11 80       	mov    0x80113960,%eax
80103d65:	83 c0 01             	add    $0x1,%eax
80103d68:	a3 60 39 11 80       	mov    %eax,0x80113960
      p += sizeof(struct mpproc);
80103d6d:	83 45 e4 14          	addl   $0x14,-0x1c(%ebp)
      continue;
80103d71:	eb 41                	jmp    80103db4 <mpinit+0x150>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103d73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103d76:	89 45 f4             	mov    %eax,-0xc(%ebp)
      ioapicid = ioapic->apicno;
80103d79:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d7c:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103d80:	a2 60 33 11 80       	mov    %al,0x80113360
      p += sizeof(struct mpioapic);
80103d85:	83 45 e4 08          	addl   $0x8,-0x1c(%ebp)
      continue;
80103d89:	eb 29                	jmp    80103db4 <mpinit+0x150>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103d8b:	83 45 e4 08          	addl   $0x8,-0x1c(%ebp)
      continue;
80103d8f:	eb 23                	jmp    80103db4 <mpinit+0x150>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80103d91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103d94:	0f b6 00             	movzbl (%eax),%eax
80103d97:	0f b6 c0             	movzbl %al,%eax
80103d9a:	89 44 24 04          	mov    %eax,0x4(%esp)
80103d9e:	c7 04 24 24 8c 10 80 	movl   $0x80108c24,(%esp)
80103da5:	e8 f3 c5 ff ff       	call   8010039d <cprintf>
      ismp = 0;
80103daa:	c7 05 64 33 11 80 00 	movl   $0x0,0x80113364
80103db1:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103db4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103db7:	3b 45 e8             	cmp    -0x18(%ebp),%eax
80103dba:	0f 82 02 ff ff ff    	jb     80103cc2 <mpinit+0x5e>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
80103dc0:	a1 64 33 11 80       	mov    0x80113364,%eax
80103dc5:	85 c0                	test   %eax,%eax
80103dc7:	75 1d                	jne    80103de6 <mpinit+0x182>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103dc9:	c7 05 60 39 11 80 01 	movl   $0x1,0x80113960
80103dd0:	00 00 00 
    lapic = 0;
80103dd3:	c7 05 7c 32 11 80 00 	movl   $0x0,0x8011327c
80103dda:	00 00 00 
    ioapicid = 0;
80103ddd:	c6 05 60 33 11 80 00 	movb   $0x0,0x80113360
    return;
80103de4:	eb 44                	jmp    80103e2a <mpinit+0x1c6>
  }

  if(mp->imcrp){
80103de6:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103de9:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103ded:	84 c0                	test   %al,%al
80103def:	74 39                	je     80103e2a <mpinit+0x1c6>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103df1:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
80103df8:	00 
80103df9:	c7 04 24 22 00 00 00 	movl   $0x22,(%esp)
80103e00:	e8 11 fc ff ff       	call   80103a16 <outb>
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103e05:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103e0c:	e8 e8 fb ff ff       	call   801039f9 <inb>
80103e11:	83 c8 01             	or     $0x1,%eax
80103e14:	0f b6 c0             	movzbl %al,%eax
80103e17:	89 44 24 04          	mov    %eax,0x4(%esp)
80103e1b:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103e22:	e8 ef fb ff ff       	call   80103a16 <outb>
80103e27:	eb 01                	jmp    80103e2a <mpinit+0x1c6>
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
80103e29:	90                   	nop
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
80103e2a:	c9                   	leave  
80103e2b:	c3                   	ret    

80103e2c <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103e2c:	55                   	push   %ebp
80103e2d:	89 e5                	mov    %esp,%ebp
80103e2f:	83 ec 08             	sub    $0x8,%esp
80103e32:	8b 55 08             	mov    0x8(%ebp),%edx
80103e35:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e38:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103e3c:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103e3f:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103e43:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103e47:	ee                   	out    %al,(%dx)
}
80103e48:	c9                   	leave  
80103e49:	c3                   	ret    

80103e4a <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103e4a:	55                   	push   %ebp
80103e4b:	89 e5                	mov    %esp,%ebp
80103e4d:	83 ec 0c             	sub    $0xc,%esp
80103e50:	8b 45 08             	mov    0x8(%ebp),%eax
80103e53:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103e57:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103e5b:	66 a3 00 c0 10 80    	mov    %ax,0x8010c000
  outb(IO_PIC1+1, mask);
80103e61:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103e65:	0f b6 c0             	movzbl %al,%eax
80103e68:	89 44 24 04          	mov    %eax,0x4(%esp)
80103e6c:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103e73:	e8 b4 ff ff ff       	call   80103e2c <outb>
  outb(IO_PIC2+1, mask >> 8);
80103e78:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103e7c:	66 c1 e8 08          	shr    $0x8,%ax
80103e80:	0f b6 c0             	movzbl %al,%eax
80103e83:	89 44 24 04          	mov    %eax,0x4(%esp)
80103e87:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103e8e:	e8 99 ff ff ff       	call   80103e2c <outb>
}
80103e93:	c9                   	leave  
80103e94:	c3                   	ret    

80103e95 <picenable>:

void
picenable(int irq)
{
80103e95:	55                   	push   %ebp
80103e96:	89 e5                	mov    %esp,%ebp
80103e98:	53                   	push   %ebx
80103e99:	83 ec 04             	sub    $0x4,%esp
  picsetmask(irqmask & ~(1<<irq));
80103e9c:	8b 45 08             	mov    0x8(%ebp),%eax
80103e9f:	ba 01 00 00 00       	mov    $0x1,%edx
80103ea4:	89 d3                	mov    %edx,%ebx
80103ea6:	89 c1                	mov    %eax,%ecx
80103ea8:	d3 e3                	shl    %cl,%ebx
80103eaa:	89 d8                	mov    %ebx,%eax
80103eac:	89 c2                	mov    %eax,%edx
80103eae:	f7 d2                	not    %edx
80103eb0:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103eb7:	21 d0                	and    %edx,%eax
80103eb9:	0f b7 c0             	movzwl %ax,%eax
80103ebc:	89 04 24             	mov    %eax,(%esp)
80103ebf:	e8 86 ff ff ff       	call   80103e4a <picsetmask>
}
80103ec4:	83 c4 04             	add    $0x4,%esp
80103ec7:	5b                   	pop    %ebx
80103ec8:	5d                   	pop    %ebp
80103ec9:	c3                   	ret    

80103eca <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103eca:	55                   	push   %ebp
80103ecb:	89 e5                	mov    %esp,%ebp
80103ecd:	83 ec 08             	sub    $0x8,%esp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103ed0:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103ed7:	00 
80103ed8:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103edf:	e8 48 ff ff ff       	call   80103e2c <outb>
  outb(IO_PIC2+1, 0xFF);
80103ee4:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103eeb:	00 
80103eec:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103ef3:	e8 34 ff ff ff       	call   80103e2c <outb>

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80103ef8:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103eff:	00 
80103f00:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103f07:	e8 20 ff ff ff       	call   80103e2c <outb>

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80103f0c:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
80103f13:	00 
80103f14:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103f1b:	e8 0c ff ff ff       	call   80103e2c <outb>

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80103f20:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
80103f27:	00 
80103f28:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103f2f:	e8 f8 fe ff ff       	call   80103e2c <outb>
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80103f34:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103f3b:	00 
80103f3c:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103f43:	e8 e4 fe ff ff       	call   80103e2c <outb>

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80103f48:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103f4f:	00 
80103f50:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103f57:	e8 d0 fe ff ff       	call   80103e2c <outb>
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80103f5c:	c7 44 24 04 28 00 00 	movl   $0x28,0x4(%esp)
80103f63:	00 
80103f64:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103f6b:	e8 bc fe ff ff       	call   80103e2c <outb>
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80103f70:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80103f77:	00 
80103f78:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103f7f:	e8 a8 fe ff ff       	call   80103e2c <outb>
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80103f84:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103f8b:	00 
80103f8c:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103f93:	e8 94 fe ff ff       	call   80103e2c <outb>

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80103f98:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103f9f:	00 
80103fa0:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103fa7:	e8 80 fe ff ff       	call   80103e2c <outb>
  outb(IO_PIC1, 0x0a);             // read IRR by default
80103fac:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103fb3:	00 
80103fb4:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103fbb:	e8 6c fe ff ff       	call   80103e2c <outb>

  outb(IO_PIC2, 0x68);             // OCW3
80103fc0:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103fc7:	00 
80103fc8:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103fcf:	e8 58 fe ff ff       	call   80103e2c <outb>
  outb(IO_PIC2, 0x0a);             // OCW3
80103fd4:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103fdb:	00 
80103fdc:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103fe3:	e8 44 fe ff ff       	call   80103e2c <outb>

  if(irqmask != 0xFFFF)
80103fe8:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103fef:	66 83 f8 ff          	cmp    $0xffffffff,%ax
80103ff3:	74 12                	je     80104007 <picinit+0x13d>
    picsetmask(irqmask);
80103ff5:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103ffc:	0f b7 c0             	movzwl %ax,%eax
80103fff:	89 04 24             	mov    %eax,(%esp)
80104002:	e8 43 fe ff ff       	call   80103e4a <picsetmask>
}
80104007:	c9                   	leave  
80104008:	c3                   	ret    
80104009:	00 00                	add    %al,(%eax)
	...

8010400c <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
8010400c:	55                   	push   %ebp
8010400d:	89 e5                	mov    %esp,%ebp
8010400f:	83 ec 28             	sub    $0x28,%esp
  struct pipe *p;

  p = 0;
80104012:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80104019:	8b 45 0c             	mov    0xc(%ebp),%eax
8010401c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104022:	8b 45 0c             	mov    0xc(%ebp),%eax
80104025:	8b 10                	mov    (%eax),%edx
80104027:	8b 45 08             	mov    0x8(%ebp),%eax
8010402a:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010402c:	e8 17 cf ff ff       	call   80100f48 <filealloc>
80104031:	8b 55 08             	mov    0x8(%ebp),%edx
80104034:	89 02                	mov    %eax,(%edx)
80104036:	8b 45 08             	mov    0x8(%ebp),%eax
80104039:	8b 00                	mov    (%eax),%eax
8010403b:	85 c0                	test   %eax,%eax
8010403d:	0f 84 c8 00 00 00    	je     8010410b <pipealloc+0xff>
80104043:	e8 00 cf ff ff       	call   80100f48 <filealloc>
80104048:	8b 55 0c             	mov    0xc(%ebp),%edx
8010404b:	89 02                	mov    %eax,(%edx)
8010404d:	8b 45 0c             	mov    0xc(%ebp),%eax
80104050:	8b 00                	mov    (%eax),%eax
80104052:	85 c0                	test   %eax,%eax
80104054:	0f 84 b1 00 00 00    	je     8010410b <pipealloc+0xff>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
8010405a:	e8 6f eb ff ff       	call   80102bce <kalloc>
8010405f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104062:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104066:	0f 84 9e 00 00 00    	je     8010410a <pipealloc+0xfe>
    goto bad;
  p->readopen = 1;
8010406c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010406f:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80104076:	00 00 00 
  p->writeopen = 1;
80104079:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010407c:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80104083:	00 00 00 
  p->nwrite = 0;
80104086:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104089:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80104090:	00 00 00 
  p->nread = 0;
80104093:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104096:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
8010409d:	00 00 00 
  initlock(&p->lock, "pipe");
801040a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040a3:	c7 44 24 04 58 8c 10 	movl   $0x80108c58,0x4(%esp)
801040aa:	80 
801040ab:	89 04 24             	mov    %eax,(%esp)
801040ae:	e8 8b 0e 00 00       	call   80104f3e <initlock>
  (*f0)->type = FD_PIPE;
801040b3:	8b 45 08             	mov    0x8(%ebp),%eax
801040b6:	8b 00                	mov    (%eax),%eax
801040b8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801040be:	8b 45 08             	mov    0x8(%ebp),%eax
801040c1:	8b 00                	mov    (%eax),%eax
801040c3:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801040c7:	8b 45 08             	mov    0x8(%ebp),%eax
801040ca:	8b 00                	mov    (%eax),%eax
801040cc:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801040d0:	8b 45 08             	mov    0x8(%ebp),%eax
801040d3:	8b 00                	mov    (%eax),%eax
801040d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801040d8:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
801040db:	8b 45 0c             	mov    0xc(%ebp),%eax
801040de:	8b 00                	mov    (%eax),%eax
801040e0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801040e6:	8b 45 0c             	mov    0xc(%ebp),%eax
801040e9:	8b 00                	mov    (%eax),%eax
801040eb:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801040ef:	8b 45 0c             	mov    0xc(%ebp),%eax
801040f2:	8b 00                	mov    (%eax),%eax
801040f4:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801040f8:	8b 45 0c             	mov    0xc(%ebp),%eax
801040fb:	8b 00                	mov    (%eax),%eax
801040fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104100:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80104103:	b8 00 00 00 00       	mov    $0x0,%eax
80104108:	eb 43                	jmp    8010414d <pipealloc+0x141>
  p = 0;
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
8010410a:	90                   	nop
  (*f1)->pipe = p;
  return 0;

//PAGEBREAK: 20
 bad:
  if(p)
8010410b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010410f:	74 0b                	je     8010411c <pipealloc+0x110>
    kfree((char*)p);
80104111:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104114:	89 04 24             	mov    %eax,(%esp)
80104117:	e8 19 ea ff ff       	call   80102b35 <kfree>
  if(*f0)
8010411c:	8b 45 08             	mov    0x8(%ebp),%eax
8010411f:	8b 00                	mov    (%eax),%eax
80104121:	85 c0                	test   %eax,%eax
80104123:	74 0d                	je     80104132 <pipealloc+0x126>
    fileclose(*f0);
80104125:	8b 45 08             	mov    0x8(%ebp),%eax
80104128:	8b 00                	mov    (%eax),%eax
8010412a:	89 04 24             	mov    %eax,(%esp)
8010412d:	e8 bf ce ff ff       	call   80100ff1 <fileclose>
  if(*f1)
80104132:	8b 45 0c             	mov    0xc(%ebp),%eax
80104135:	8b 00                	mov    (%eax),%eax
80104137:	85 c0                	test   %eax,%eax
80104139:	74 0d                	je     80104148 <pipealloc+0x13c>
    fileclose(*f1);
8010413b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010413e:	8b 00                	mov    (%eax),%eax
80104140:	89 04 24             	mov    %eax,(%esp)
80104143:	e8 a9 ce ff ff       	call   80100ff1 <fileclose>
  return -1;
80104148:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010414d:	c9                   	leave  
8010414e:	c3                   	ret    

8010414f <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
8010414f:	55                   	push   %ebp
80104150:	89 e5                	mov    %esp,%ebp
80104152:	83 ec 18             	sub    $0x18,%esp
  acquire(&p->lock);
80104155:	8b 45 08             	mov    0x8(%ebp),%eax
80104158:	89 04 24             	mov    %eax,(%esp)
8010415b:	e8 ff 0d 00 00       	call   80104f5f <acquire>
  if(writable){
80104160:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104164:	74 1f                	je     80104185 <pipeclose+0x36>
    p->writeopen = 0;
80104166:	8b 45 08             	mov    0x8(%ebp),%eax
80104169:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80104170:	00 00 00 
    wakeup(&p->nread);
80104173:	8b 45 08             	mov    0x8(%ebp),%eax
80104176:	05 34 02 00 00       	add    $0x234,%eax
8010417b:	89 04 24             	mov    %eax,(%esp)
8010417e:	e8 de 0b 00 00       	call   80104d61 <wakeup>
80104183:	eb 1d                	jmp    801041a2 <pipeclose+0x53>
  } else {
    p->readopen = 0;
80104185:	8b 45 08             	mov    0x8(%ebp),%eax
80104188:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
8010418f:	00 00 00 
    wakeup(&p->nwrite);
80104192:	8b 45 08             	mov    0x8(%ebp),%eax
80104195:	05 38 02 00 00       	add    $0x238,%eax
8010419a:	89 04 24             	mov    %eax,(%esp)
8010419d:	e8 bf 0b 00 00       	call   80104d61 <wakeup>
  }
  if(p->readopen == 0 && p->writeopen == 0){
801041a2:	8b 45 08             	mov    0x8(%ebp),%eax
801041a5:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
801041ab:	85 c0                	test   %eax,%eax
801041ad:	75 25                	jne    801041d4 <pipeclose+0x85>
801041af:	8b 45 08             	mov    0x8(%ebp),%eax
801041b2:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
801041b8:	85 c0                	test   %eax,%eax
801041ba:	75 18                	jne    801041d4 <pipeclose+0x85>
    release(&p->lock);
801041bc:	8b 45 08             	mov    0x8(%ebp),%eax
801041bf:	89 04 24             	mov    %eax,(%esp)
801041c2:	e8 f9 0d 00 00       	call   80104fc0 <release>
    kfree((char*)p);
801041c7:	8b 45 08             	mov    0x8(%ebp),%eax
801041ca:	89 04 24             	mov    %eax,(%esp)
801041cd:	e8 63 e9 ff ff       	call   80102b35 <kfree>
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801041d2:	eb 0b                	jmp    801041df <pipeclose+0x90>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801041d4:	8b 45 08             	mov    0x8(%ebp),%eax
801041d7:	89 04 24             	mov    %eax,(%esp)
801041da:	e8 e1 0d 00 00       	call   80104fc0 <release>
}
801041df:	c9                   	leave  
801041e0:	c3                   	ret    

801041e1 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801041e1:	55                   	push   %ebp
801041e2:	89 e5                	mov    %esp,%ebp
801041e4:	53                   	push   %ebx
801041e5:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
801041e8:	8b 45 08             	mov    0x8(%ebp),%eax
801041eb:	89 04 24             	mov    %eax,(%esp)
801041ee:	e8 6c 0d 00 00       	call   80104f5f <acquire>
  for(i = 0; i < n; i++){
801041f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801041fa:	e9 a6 00 00 00       	jmp    801042a5 <pipewrite+0xc4>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
801041ff:	8b 45 08             	mov    0x8(%ebp),%eax
80104202:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104208:	85 c0                	test   %eax,%eax
8010420a:	74 0d                	je     80104219 <pipewrite+0x38>
8010420c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104212:	8b 40 24             	mov    0x24(%eax),%eax
80104215:	85 c0                	test   %eax,%eax
80104217:	74 15                	je     8010422e <pipewrite+0x4d>
        release(&p->lock);
80104219:	8b 45 08             	mov    0x8(%ebp),%eax
8010421c:	89 04 24             	mov    %eax,(%esp)
8010421f:	e8 9c 0d 00 00       	call   80104fc0 <release>
        return -1;
80104224:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104229:	e9 9d 00 00 00       	jmp    801042cb <pipewrite+0xea>
      }
      wakeup(&p->nread);
8010422e:	8b 45 08             	mov    0x8(%ebp),%eax
80104231:	05 34 02 00 00       	add    $0x234,%eax
80104236:	89 04 24             	mov    %eax,(%esp)
80104239:	e8 23 0b 00 00       	call   80104d61 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010423e:	8b 45 08             	mov    0x8(%ebp),%eax
80104241:	8b 55 08             	mov    0x8(%ebp),%edx
80104244:	81 c2 38 02 00 00    	add    $0x238,%edx
8010424a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010424e:	89 14 24             	mov    %edx,(%esp)
80104251:	e8 2e 0a 00 00       	call   80104c84 <sleep>
80104256:	eb 01                	jmp    80104259 <pipewrite+0x78>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104258:	90                   	nop
80104259:	8b 45 08             	mov    0x8(%ebp),%eax
8010425c:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80104262:	8b 45 08             	mov    0x8(%ebp),%eax
80104265:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
8010426b:	05 00 02 00 00       	add    $0x200,%eax
80104270:	39 c2                	cmp    %eax,%edx
80104272:	74 8b                	je     801041ff <pipewrite+0x1e>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80104274:	8b 45 08             	mov    0x8(%ebp),%eax
80104277:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010427d:	89 c3                	mov    %eax,%ebx
8010427f:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80104285:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104288:	03 55 0c             	add    0xc(%ebp),%edx
8010428b:	0f b6 0a             	movzbl (%edx),%ecx
8010428e:	8b 55 08             	mov    0x8(%ebp),%edx
80104291:	88 4c 1a 34          	mov    %cl,0x34(%edx,%ebx,1)
80104295:	8d 50 01             	lea    0x1(%eax),%edx
80104298:	8b 45 08             	mov    0x8(%ebp),%eax
8010429b:	89 90 38 02 00 00    	mov    %edx,0x238(%eax)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
801042a1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801042a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042a8:	3b 45 10             	cmp    0x10(%ebp),%eax
801042ab:	7c ab                	jl     80104258 <pipewrite+0x77>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801042ad:	8b 45 08             	mov    0x8(%ebp),%eax
801042b0:	05 34 02 00 00       	add    $0x234,%eax
801042b5:	89 04 24             	mov    %eax,(%esp)
801042b8:	e8 a4 0a 00 00       	call   80104d61 <wakeup>
  release(&p->lock);
801042bd:	8b 45 08             	mov    0x8(%ebp),%eax
801042c0:	89 04 24             	mov    %eax,(%esp)
801042c3:	e8 f8 0c 00 00       	call   80104fc0 <release>
  return n;
801042c8:	8b 45 10             	mov    0x10(%ebp),%eax
}
801042cb:	83 c4 24             	add    $0x24,%esp
801042ce:	5b                   	pop    %ebx
801042cf:	5d                   	pop    %ebp
801042d0:	c3                   	ret    

801042d1 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801042d1:	55                   	push   %ebp
801042d2:	89 e5                	mov    %esp,%ebp
801042d4:	53                   	push   %ebx
801042d5:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
801042d8:	8b 45 08             	mov    0x8(%ebp),%eax
801042db:	89 04 24             	mov    %eax,(%esp)
801042de:	e8 7c 0c 00 00       	call   80104f5f <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801042e3:	eb 3a                	jmp    8010431f <piperead+0x4e>
    if(proc->killed){
801042e5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042eb:	8b 40 24             	mov    0x24(%eax),%eax
801042ee:	85 c0                	test   %eax,%eax
801042f0:	74 15                	je     80104307 <piperead+0x36>
      release(&p->lock);
801042f2:	8b 45 08             	mov    0x8(%ebp),%eax
801042f5:	89 04 24             	mov    %eax,(%esp)
801042f8:	e8 c3 0c 00 00       	call   80104fc0 <release>
      return -1;
801042fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104302:	e9 b6 00 00 00       	jmp    801043bd <piperead+0xec>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80104307:	8b 45 08             	mov    0x8(%ebp),%eax
8010430a:	8b 55 08             	mov    0x8(%ebp),%edx
8010430d:	81 c2 34 02 00 00    	add    $0x234,%edx
80104313:	89 44 24 04          	mov    %eax,0x4(%esp)
80104317:	89 14 24             	mov    %edx,(%esp)
8010431a:	e8 65 09 00 00       	call   80104c84 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010431f:	8b 45 08             	mov    0x8(%ebp),%eax
80104322:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104328:	8b 45 08             	mov    0x8(%ebp),%eax
8010432b:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104331:	39 c2                	cmp    %eax,%edx
80104333:	75 0d                	jne    80104342 <piperead+0x71>
80104335:	8b 45 08             	mov    0x8(%ebp),%eax
80104338:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
8010433e:	85 c0                	test   %eax,%eax
80104340:	75 a3                	jne    801042e5 <piperead+0x14>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104342:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104349:	eb 49                	jmp    80104394 <piperead+0xc3>
    if(p->nread == p->nwrite)
8010434b:	8b 45 08             	mov    0x8(%ebp),%eax
8010434e:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104354:	8b 45 08             	mov    0x8(%ebp),%eax
80104357:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010435d:	39 c2                	cmp    %eax,%edx
8010435f:	74 3d                	je     8010439e <piperead+0xcd>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80104361:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104364:	89 c2                	mov    %eax,%edx
80104366:	03 55 0c             	add    0xc(%ebp),%edx
80104369:	8b 45 08             	mov    0x8(%ebp),%eax
8010436c:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104372:	89 c3                	mov    %eax,%ebx
80104374:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010437a:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010437d:	0f b6 4c 19 34       	movzbl 0x34(%ecx,%ebx,1),%ecx
80104382:	88 0a                	mov    %cl,(%edx)
80104384:	8d 50 01             	lea    0x1(%eax),%edx
80104387:	8b 45 08             	mov    0x8(%ebp),%eax
8010438a:	89 90 34 02 00 00    	mov    %edx,0x234(%eax)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104390:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104394:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104397:	3b 45 10             	cmp    0x10(%ebp),%eax
8010439a:	7c af                	jl     8010434b <piperead+0x7a>
8010439c:	eb 01                	jmp    8010439f <piperead+0xce>
    if(p->nread == p->nwrite)
      break;
8010439e:	90                   	nop
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010439f:	8b 45 08             	mov    0x8(%ebp),%eax
801043a2:	05 38 02 00 00       	add    $0x238,%eax
801043a7:	89 04 24             	mov    %eax,(%esp)
801043aa:	e8 b2 09 00 00       	call   80104d61 <wakeup>
  release(&p->lock);
801043af:	8b 45 08             	mov    0x8(%ebp),%eax
801043b2:	89 04 24             	mov    %eax,(%esp)
801043b5:	e8 06 0c 00 00       	call   80104fc0 <release>
  return i;
801043ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801043bd:	83 c4 24             	add    $0x24,%esp
801043c0:	5b                   	pop    %ebx
801043c1:	5d                   	pop    %ebp
801043c2:	c3                   	ret    
	...

801043c4 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
801043c4:	55                   	push   %ebp
801043c5:	89 e5                	mov    %esp,%ebp
801043c7:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801043ca:	9c                   	pushf  
801043cb:	58                   	pop    %eax
801043cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801043cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801043d2:	c9                   	leave  
801043d3:	c3                   	ret    

801043d4 <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
801043d4:	55                   	push   %ebp
801043d5:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801043d7:	fb                   	sti    
}
801043d8:	5d                   	pop    %ebp
801043d9:	c3                   	ret    

801043da <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
801043da:	55                   	push   %ebp
801043db:	89 e5                	mov    %esp,%ebp
801043dd:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
801043e0:	c7 44 24 04 5d 8c 10 	movl   $0x80108c5d,0x4(%esp)
801043e7:	80 
801043e8:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
801043ef:	e8 4a 0b 00 00       	call   80104f3e <initlock>
}
801043f4:	c9                   	leave  
801043f5:	c3                   	ret    

801043f6 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801043f6:	55                   	push   %ebp
801043f7:	89 e5                	mov    %esp,%ebp
801043f9:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
801043fc:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104403:	e8 57 0b 00 00       	call   80104f5f <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104408:	c7 45 ec b4 39 11 80 	movl   $0x801139b4,-0x14(%ebp)
8010440f:	eb 11                	jmp    80104422 <allocproc+0x2c>
    if(p->state == UNUSED)
80104411:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104414:	8b 40 0c             	mov    0xc(%eax),%eax
80104417:	85 c0                	test   %eax,%eax
80104419:	74 27                	je     80104442 <allocproc+0x4c>
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010441b:	81 45 ec 08 01 00 00 	addl   $0x108,-0x14(%ebp)
80104422:	b8 b4 7b 11 80       	mov    $0x80117bb4,%eax
80104427:	39 45 ec             	cmp    %eax,-0x14(%ebp)
8010442a:	72 e5                	jb     80104411 <allocproc+0x1b>
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
8010442c:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104433:	e8 88 0b 00 00       	call   80104fc0 <release>
  return 0;
80104438:	b8 00 00 00 00       	mov    $0x0,%eax
8010443d:	e9 07 01 00 00       	jmp    80104549 <allocproc+0x153>
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
80104442:	90                   	nop
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
80104443:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104446:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
8010444d:	a1 04 c0 10 80       	mov    0x8010c004,%eax
80104452:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104455:	89 42 10             	mov    %eax,0x10(%edx)
80104458:	83 c0 01             	add    $0x1,%eax
8010445b:	a3 04 c0 10 80       	mov    %eax,0x8010c004

  // Signal Handling
  int i = 0;
80104460:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  for(i = 0; i < 32; i++) // For the array of signal handlers
80104467:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010446e:	eb 15                	jmp    80104485 <allocproc+0x8f>
	p->handlers[i] = -1; // Initialize them all to -1
80104470:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104473:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104476:	83 c2 1c             	add    $0x1c,%edx
80104479:	c7 44 90 0c ff ff ff 	movl   $0xffffffff,0xc(%eax,%edx,4)
80104480:	ff 
  p->state = EMBRYO;
  p->pid = nextpid++;

  // Signal Handling
  int i = 0;
  for(i = 0; i < 32; i++) // For the array of signal handlers
80104481:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104485:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%ebp)
80104489:	7e e5                	jle    80104470 <allocproc+0x7a>
	p->handlers[i] = -1; // Initialize them all to -1
  release(&ptable.lock);
8010448b:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104492:	e8 29 0b 00 00       	call   80104fc0 <release>


  // Alarm Signal Call 
  p->numberOfTicks = 0; // Initialize the number of ticks to 0
80104497:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010449a:	c7 80 00 01 00 00 00 	movl   $0x0,0x100(%eax)
801044a1:	00 00 00 
  p->alarmState = -1; // Initial the alarm state
801044a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801044a7:	c7 80 fc 00 00 00 ff 	movl   $0xffffffff,0xfc(%eax)
801044ae:	ff ff ff 
  p->trampoline = -1; 
801044b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801044b4:	c7 80 04 01 00 00 ff 	movl   $0xffffffff,0x104(%eax)
801044bb:	ff ff ff 

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801044be:	e8 0b e7 ff ff       	call   80102bce <kalloc>
801044c3:	8b 55 ec             	mov    -0x14(%ebp),%edx
801044c6:	89 42 08             	mov    %eax,0x8(%edx)
801044c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801044cc:	8b 40 08             	mov    0x8(%eax),%eax
801044cf:	85 c0                	test   %eax,%eax
801044d1:	75 11                	jne    801044e4 <allocproc+0xee>
    p->state = UNUSED;
801044d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801044d6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
801044dd:	b8 00 00 00 00       	mov    $0x0,%eax
801044e2:	eb 65                	jmp    80104549 <allocproc+0x153>
  }
  sp = p->kstack + KSTACKSIZE;
801044e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801044e7:	8b 40 08             	mov    0x8(%eax),%eax
801044ea:	05 00 10 00 00       	add    $0x1000,%eax
801044ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801044f2:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
801044f6:	8b 55 f0             	mov    -0x10(%ebp),%edx
801044f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801044fc:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
801044ff:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
80104503:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104506:	ba 18 67 10 80       	mov    $0x80106718,%edx
8010450b:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
8010450d:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
80104511:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104514:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104517:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
8010451a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010451d:	8b 40 1c             	mov    0x1c(%eax),%eax
80104520:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104527:	00 
80104528:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010452f:	00 
80104530:	89 04 24             	mov    %eax,(%esp)
80104533:	e8 7e 0c 00 00       	call   801051b6 <memset>
  p->context->eip = (uint)forkret;
80104538:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010453b:	8b 40 1c             	mov    0x1c(%eax),%eax
8010453e:	ba 45 4c 10 80       	mov    $0x80104c45,%edx
80104543:	89 50 10             	mov    %edx,0x10(%eax)



  return p;
80104546:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80104549:	c9                   	leave  
8010454a:	c3                   	ret    

8010454b <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
8010454b:	55                   	push   %ebp
8010454c:	89 e5                	mov    %esp,%ebp
8010454e:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
80104551:	e8 a0 fe ff ff       	call   801043f6 <allocproc>
80104556:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
80104559:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010455c:	a3 68 c6 10 80       	mov    %eax,0x8010c668
  if((p->pgdir = setupkvm()) == 0)
80104561:	e8 43 3b 00 00       	call   801080a9 <setupkvm>
80104566:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104569:	89 42 04             	mov    %eax,0x4(%edx)
8010456c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010456f:	8b 40 04             	mov    0x4(%eax),%eax
80104572:	85 c0                	test   %eax,%eax
80104574:	75 0c                	jne    80104582 <userinit+0x37>
    panic("userinit: out of memory?");
80104576:	c7 04 24 64 8c 10 80 	movl   $0x80108c64,(%esp)
8010457d:	e8 bb bf ff ff       	call   8010053d <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104582:	ba 2c 00 00 00       	mov    $0x2c,%edx
80104587:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010458a:	8b 40 04             	mov    0x4(%eax),%eax
8010458d:	89 54 24 08          	mov    %edx,0x8(%esp)
80104591:	c7 44 24 04 00 c5 10 	movl   $0x8010c500,0x4(%esp)
80104598:	80 
80104599:	89 04 24             	mov    %eax,(%esp)
8010459c:	e8 61 3d 00 00       	call   80108302 <inituvm>
  p->sz = PGSIZE;
801045a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045a4:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
801045aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045ad:	8b 40 18             	mov    0x18(%eax),%eax
801045b0:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
801045b7:	00 
801045b8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801045bf:	00 
801045c0:	89 04 24             	mov    %eax,(%esp)
801045c3:	e8 ee 0b 00 00       	call   801051b6 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801045c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045cb:	8b 40 18             	mov    0x18(%eax),%eax
801045ce:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801045d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045d7:	8b 40 18             	mov    0x18(%eax),%eax
801045da:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
801045e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045e3:	8b 40 18             	mov    0x18(%eax),%eax
801045e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801045e9:	8b 52 18             	mov    0x18(%edx),%edx
801045ec:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801045f0:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801045f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045f7:	8b 40 18             	mov    0x18(%eax),%eax
801045fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
801045fd:	8b 52 18             	mov    0x18(%edx),%edx
80104600:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104604:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80104608:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010460b:	8b 40 18             	mov    0x18(%eax),%eax
8010460e:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104615:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104618:	8b 40 18             	mov    0x18(%eax),%eax
8010461b:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104622:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104625:	8b 40 18             	mov    0x18(%eax),%eax
80104628:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
8010462f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104632:	83 c0 6c             	add    $0x6c,%eax
80104635:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
8010463c:	00 
8010463d:	c7 44 24 04 7d 8c 10 	movl   $0x80108c7d,0x4(%esp)
80104644:	80 
80104645:	89 04 24             	mov    %eax,(%esp)
80104648:	e8 9c 0d 00 00       	call   801053e9 <safestrcpy>
  p->cwd = namei("/");
8010464d:	c7 04 24 86 8c 10 80 	movl   $0x80108c86,(%esp)
80104654:	e8 56 de ff ff       	call   801024af <namei>
80104659:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010465c:	89 42 68             	mov    %eax,0x68(%edx)

  p->state = RUNNABLE;
8010465f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104662:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
}
80104669:	c9                   	leave  
8010466a:	c3                   	ret    

8010466b <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
8010466b:	55                   	push   %ebp
8010466c:	89 e5                	mov    %esp,%ebp
8010466e:	83 ec 28             	sub    $0x28,%esp
  uint sz;
  
  sz = proc->sz;
80104671:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104677:	8b 00                	mov    (%eax),%eax
80104679:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
8010467c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104680:	7e 34                	jle    801046b6 <growproc+0x4b>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80104682:	8b 45 08             	mov    0x8(%ebp),%eax
80104685:	89 c2                	mov    %eax,%edx
80104687:	03 55 f4             	add    -0xc(%ebp),%edx
8010468a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104690:	8b 40 04             	mov    0x4(%eax),%eax
80104693:	89 54 24 08          	mov    %edx,0x8(%esp)
80104697:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010469a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010469e:	89 04 24             	mov    %eax,(%esp)
801046a1:	e8 d7 3d 00 00       	call   8010847d <allocuvm>
801046a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801046a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801046ad:	75 41                	jne    801046f0 <growproc+0x85>
      return -1;
801046af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046b4:	eb 58                	jmp    8010470e <growproc+0xa3>
  } else if(n < 0){
801046b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801046ba:	79 34                	jns    801046f0 <growproc+0x85>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
801046bc:	8b 45 08             	mov    0x8(%ebp),%eax
801046bf:	89 c2                	mov    %eax,%edx
801046c1:	03 55 f4             	add    -0xc(%ebp),%edx
801046c4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046ca:	8b 40 04             	mov    0x4(%eax),%eax
801046cd:	89 54 24 08          	mov    %edx,0x8(%esp)
801046d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801046d4:	89 54 24 04          	mov    %edx,0x4(%esp)
801046d8:	89 04 24             	mov    %eax,(%esp)
801046db:	e8 77 3e 00 00       	call   80108557 <deallocuvm>
801046e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801046e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801046e7:	75 07                	jne    801046f0 <growproc+0x85>
      return -1;
801046e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046ee:	eb 1e                	jmp    8010470e <growproc+0xa3>
  }
  proc->sz = sz;
801046f0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801046f9:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
801046fb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104701:	89 04 24             	mov    %eax,(%esp)
80104704:	e8 92 3a 00 00       	call   8010819b <switchuvm>
  return 0;
80104709:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010470e:	c9                   	leave  
8010470f:	c3                   	ret    

80104710 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80104710:	55                   	push   %ebp
80104711:	89 e5                	mov    %esp,%ebp
80104713:	57                   	push   %edi
80104714:	56                   	push   %esi
80104715:	53                   	push   %ebx
80104716:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
80104719:	e8 d8 fc ff ff       	call   801043f6 <allocproc>
8010471e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104721:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80104725:	75 0a                	jne    80104731 <fork+0x21>
    return -1;
80104727:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010472c:	e9 52 01 00 00       	jmp    80104883 <fork+0x173>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80104731:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104737:	8b 10                	mov    (%eax),%edx
80104739:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010473f:	8b 40 04             	mov    0x4(%eax),%eax
80104742:	89 54 24 04          	mov    %edx,0x4(%esp)
80104746:	89 04 24             	mov    %eax,(%esp)
80104749:	e8 99 3f 00 00       	call   801086e7 <copyuvm>
8010474e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104751:	89 42 04             	mov    %eax,0x4(%edx)
80104754:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104757:	8b 40 04             	mov    0x4(%eax),%eax
8010475a:	85 c0                	test   %eax,%eax
8010475c:	75 2c                	jne    8010478a <fork+0x7a>
    kfree(np->kstack);
8010475e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104761:	8b 40 08             	mov    0x8(%eax),%eax
80104764:	89 04 24             	mov    %eax,(%esp)
80104767:	e8 c9 e3 ff ff       	call   80102b35 <kfree>
    np->kstack = 0;
8010476c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010476f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
80104776:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104779:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
80104780:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104785:	e9 f9 00 00 00       	jmp    80104883 <fork+0x173>
  }
  np->sz = proc->sz;
8010478a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104790:	8b 10                	mov    (%eax),%edx
80104792:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104795:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
80104797:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010479e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801047a1:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
801047a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801047a7:	8b 50 18             	mov    0x18(%eax),%edx
801047aa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047b0:	8b 40 18             	mov    0x18(%eax),%eax
801047b3:	89 c3                	mov    %eax,%ebx
801047b5:	b8 13 00 00 00       	mov    $0x13,%eax
801047ba:	89 d7                	mov    %edx,%edi
801047bc:	89 de                	mov    %ebx,%esi
801047be:	89 c1                	mov    %eax,%ecx
801047c0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
801047c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801047c5:	8b 40 18             	mov    0x18(%eax),%eax
801047c8:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
801047cf:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
801047d6:	eb 3d                	jmp    80104815 <fork+0x105>
    if(proc->ofile[i])
801047d8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047de:	8b 55 dc             	mov    -0x24(%ebp),%edx
801047e1:	83 c2 08             	add    $0x8,%edx
801047e4:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801047e8:	85 c0                	test   %eax,%eax
801047ea:	74 25                	je     80104811 <fork+0x101>
      np->ofile[i] = filedup(proc->ofile[i]);
801047ec:	8b 5d dc             	mov    -0x24(%ebp),%ebx
801047ef:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047f5:	8b 55 dc             	mov    -0x24(%ebp),%edx
801047f8:	83 c2 08             	add    $0x8,%edx
801047fb:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801047ff:	89 04 24             	mov    %eax,(%esp)
80104802:	e8 a2 c7 ff ff       	call   80100fa9 <filedup>
80104807:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010480a:	8d 4b 08             	lea    0x8(%ebx),%ecx
8010480d:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80104811:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
80104815:	83 7d dc 0f          	cmpl   $0xf,-0x24(%ebp)
80104819:	7e bd                	jle    801047d8 <fork+0xc8>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
8010481b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104821:	8b 40 68             	mov    0x68(%eax),%eax
80104824:	89 04 24             	mov    %eax,(%esp)
80104827:	e8 a3 d0 ff ff       	call   801018cf <idup>
8010482c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010482f:	89 42 68             	mov    %eax,0x68(%edx)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80104832:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104838:	8d 50 6c             	lea    0x6c(%eax),%edx
8010483b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010483e:	83 c0 6c             	add    $0x6c,%eax
80104841:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104848:	00 
80104849:	89 54 24 04          	mov    %edx,0x4(%esp)
8010484d:	89 04 24             	mov    %eax,(%esp)
80104850:	e8 94 0b 00 00       	call   801053e9 <safestrcpy>
 
  pid = np->pid;
80104855:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104858:	8b 40 10             	mov    0x10(%eax),%eax
8010485b:	89 45 e0             	mov    %eax,-0x20(%ebp)

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
8010485e:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104865:	e8 f5 06 00 00       	call   80104f5f <acquire>
  np->state = RUNNABLE;
8010486a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010486d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  release(&ptable.lock);
80104874:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
8010487b:	e8 40 07 00 00       	call   80104fc0 <release>
  
  return pid;
80104880:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80104883:	83 c4 2c             	add    $0x2c,%esp
80104886:	5b                   	pop    %ebx
80104887:	5e                   	pop    %esi
80104888:	5f                   	pop    %edi
80104889:	5d                   	pop    %ebp
8010488a:	c3                   	ret    

8010488b <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
8010488b:	55                   	push   %ebp
8010488c:	89 e5                	mov    %esp,%ebp
8010488e:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
80104891:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104898:	a1 68 c6 10 80       	mov    0x8010c668,%eax
8010489d:	39 c2                	cmp    %eax,%edx
8010489f:	75 0c                	jne    801048ad <exit+0x22>
    panic("init exiting");
801048a1:	c7 04 24 88 8c 10 80 	movl   $0x80108c88,(%esp)
801048a8:	e8 90 bc ff ff       	call   8010053d <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
801048ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801048b4:	eb 44                	jmp    801048fa <exit+0x6f>
    if(proc->ofile[fd]){
801048b6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801048bf:	83 c2 08             	add    $0x8,%edx
801048c2:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801048c6:	85 c0                	test   %eax,%eax
801048c8:	74 2c                	je     801048f6 <exit+0x6b>
      fileclose(proc->ofile[fd]);
801048ca:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801048d3:	83 c2 08             	add    $0x8,%edx
801048d6:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801048da:	89 04 24             	mov    %eax,(%esp)
801048dd:	e8 0f c7 ff ff       	call   80100ff1 <fileclose>
      proc->ofile[fd] = 0;
801048e2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801048eb:	83 c2 08             	add    $0x8,%edx
801048ee:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801048f5:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
801048f6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801048fa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801048fe:	7e b6                	jle    801048b6 <exit+0x2b>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
80104900:	e8 f1 eb ff ff       	call   801034f6 <begin_op>
  iput(proc->cwd);
80104905:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010490b:	8b 40 68             	mov    0x68(%eax),%eax
8010490e:	89 04 24             	mov    %eax,(%esp)
80104911:	e8 a7 d1 ff ff       	call   80101abd <iput>
  end_op();
80104916:	e8 5d ec ff ff       	call   80103578 <end_op>
  proc->cwd = 0;
8010491b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104921:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104928:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
8010492f:	e8 2b 06 00 00       	call   80104f5f <acquire>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104934:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010493a:	8b 40 14             	mov    0x14(%eax),%eax
8010493d:	89 04 24             	mov    %eax,(%esp)
80104940:	e8 da 03 00 00       	call   80104d1f <wakeup1>

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104945:	c7 45 f0 b4 39 11 80 	movl   $0x801139b4,-0x10(%ebp)
8010494c:	eb 3b                	jmp    80104989 <exit+0xfe>
    if(p->parent == proc){
8010494e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104951:	8b 50 14             	mov    0x14(%eax),%edx
80104954:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010495a:	39 c2                	cmp    %eax,%edx
8010495c:	75 24                	jne    80104982 <exit+0xf7>
      p->parent = initproc;
8010495e:	8b 15 68 c6 10 80    	mov    0x8010c668,%edx
80104964:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104967:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
8010496a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010496d:	8b 40 0c             	mov    0xc(%eax),%eax
80104970:	83 f8 05             	cmp    $0x5,%eax
80104973:	75 0d                	jne    80104982 <exit+0xf7>
        wakeup1(initproc);
80104975:	a1 68 c6 10 80       	mov    0x8010c668,%eax
8010497a:	89 04 24             	mov    %eax,(%esp)
8010497d:	e8 9d 03 00 00       	call   80104d1f <wakeup1>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104982:	81 45 f0 08 01 00 00 	addl   $0x108,-0x10(%ebp)
80104989:	b8 b4 7b 11 80       	mov    $0x80117bb4,%eax
8010498e:	39 45 f0             	cmp    %eax,-0x10(%ebp)
80104991:	72 bb                	jb     8010494e <exit+0xc3>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80104993:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104999:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
801049a0:	e8 bc 01 00 00       	call   80104b61 <sched>
  panic("zombie exit");
801049a5:	c7 04 24 95 8c 10 80 	movl   $0x80108c95,(%esp)
801049ac:	e8 8c bb ff ff       	call   8010053d <panic>

801049b1 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
801049b1:	55                   	push   %ebp
801049b2:	89 e5                	mov    %esp,%ebp
801049b4:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
801049b7:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
801049be:	e8 9c 05 00 00       	call   80104f5f <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
801049c3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049ca:	c7 45 ec b4 39 11 80 	movl   $0x801139b4,-0x14(%ebp)
801049d1:	e9 9d 00 00 00       	jmp    80104a73 <wait+0xc2>
      if(p->parent != proc)
801049d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801049d9:	8b 50 14             	mov    0x14(%eax),%edx
801049dc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049e2:	39 c2                	cmp    %eax,%edx
801049e4:	0f 85 81 00 00 00    	jne    80104a6b <wait+0xba>
        continue;
      havekids = 1;
801049ea:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
801049f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801049f4:	8b 40 0c             	mov    0xc(%eax),%eax
801049f7:	83 f8 05             	cmp    $0x5,%eax
801049fa:	75 70                	jne    80104a6c <wait+0xbb>
        // Found one.
        pid = p->pid;
801049fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801049ff:	8b 40 10             	mov    0x10(%eax),%eax
80104a02:	89 45 f4             	mov    %eax,-0xc(%ebp)
        kfree(p->kstack);
80104a05:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a08:	8b 40 08             	mov    0x8(%eax),%eax
80104a0b:	89 04 24             	mov    %eax,(%esp)
80104a0e:	e8 22 e1 ff ff       	call   80102b35 <kfree>
        p->kstack = 0;
80104a13:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a16:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104a1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a20:	8b 40 04             	mov    0x4(%eax),%eax
80104a23:	89 04 24             	mov    %eax,(%esp)
80104a26:	e8 e8 3b 00 00       	call   80108613 <freevm>
        p->state = UNUSED;
80104a2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a2e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
80104a35:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a38:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104a3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a42:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104a49:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a4c:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104a50:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a53:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
80104a5a:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104a61:	e8 5a 05 00 00       	call   80104fc0 <release>
        return pid;
80104a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a69:	eb 57                	jmp    80104ac2 <wait+0x111>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
80104a6b:	90                   	nop

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a6c:	81 45 ec 08 01 00 00 	addl   $0x108,-0x14(%ebp)
80104a73:	b8 b4 7b 11 80       	mov    $0x80117bb4,%eax
80104a78:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80104a7b:	0f 82 55 ff ff ff    	jb     801049d6 <wait+0x25>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104a81:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104a85:	74 0d                	je     80104a94 <wait+0xe3>
80104a87:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a8d:	8b 40 24             	mov    0x24(%eax),%eax
80104a90:	85 c0                	test   %eax,%eax
80104a92:	74 13                	je     80104aa7 <wait+0xf6>
      release(&ptable.lock);
80104a94:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104a9b:	e8 20 05 00 00       	call   80104fc0 <release>
      return -1;
80104aa0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104aa5:	eb 1b                	jmp    80104ac2 <wait+0x111>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104aa7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104aad:	c7 44 24 04 80 39 11 	movl   $0x80113980,0x4(%esp)
80104ab4:	80 
80104ab5:	89 04 24             	mov    %eax,(%esp)
80104ab8:	e8 c7 01 00 00       	call   80104c84 <sleep>
  }
80104abd:	e9 01 ff ff ff       	jmp    801049c3 <wait+0x12>
}
80104ac2:	c9                   	leave  
80104ac3:	c3                   	ret    

80104ac4 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80104ac4:	55                   	push   %ebp
80104ac5:	89 e5                	mov    %esp,%ebp
80104ac7:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  for(;;){
    // Enable interrupts on this processor.
    sti();
80104aca:	e8 05 f9 ff ff       	call   801043d4 <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104acf:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104ad6:	e8 84 04 00 00       	call   80104f5f <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104adb:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104ae2:	eb 62                	jmp    80104b46 <scheduler+0x82>
      if(p->state != RUNNABLE)
80104ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ae7:	8b 40 0c             	mov    0xc(%eax),%eax
80104aea:	83 f8 03             	cmp    $0x3,%eax
80104aed:	75 4f                	jne    80104b3e <scheduler+0x7a>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
80104aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104af2:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
80104af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104afb:	89 04 24             	mov    %eax,(%esp)
80104afe:	e8 98 36 00 00       	call   8010819b <switchuvm>
      p->state = RUNNING;
80104b03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b06:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
      swtch(&cpu->scheduler, proc->context);
80104b0d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b13:	8b 40 1c             	mov    0x1c(%eax),%eax
80104b16:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104b1d:	83 c2 04             	add    $0x4,%edx
80104b20:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b24:	89 14 24             	mov    %edx,(%esp)
80104b27:	e8 30 09 00 00       	call   8010545c <swtch>
      switchkvm();
80104b2c:	e8 4d 36 00 00       	call   8010817e <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80104b31:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104b38:	00 00 00 00 
80104b3c:	eb 01                	jmp    80104b3f <scheduler+0x7b>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;
80104b3e:	90                   	nop
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b3f:	81 45 f4 08 01 00 00 	addl   $0x108,-0xc(%ebp)
80104b46:	b8 b4 7b 11 80       	mov    $0x80117bb4,%eax
80104b4b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80104b4e:	72 94                	jb     80104ae4 <scheduler+0x20>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
80104b50:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104b57:	e8 64 04 00 00       	call   80104fc0 <release>

  }
80104b5c:	e9 69 ff ff ff       	jmp    80104aca <scheduler+0x6>

80104b61 <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
80104b61:	55                   	push   %ebp
80104b62:	89 e5                	mov    %esp,%ebp
80104b64:	83 ec 28             	sub    $0x28,%esp
  int intena;

  if(!holding(&ptable.lock))
80104b67:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104b6e:	e8 14 05 00 00       	call   80105087 <holding>
80104b73:	85 c0                	test   %eax,%eax
80104b75:	75 0c                	jne    80104b83 <sched+0x22>
    panic("sched ptable.lock");
80104b77:	c7 04 24 a1 8c 10 80 	movl   $0x80108ca1,(%esp)
80104b7e:	e8 ba b9 ff ff       	call   8010053d <panic>
  if(cpu->ncli != 1)
80104b83:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104b89:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104b8f:	83 f8 01             	cmp    $0x1,%eax
80104b92:	74 0c                	je     80104ba0 <sched+0x3f>
    panic("sched locks");
80104b94:	c7 04 24 b3 8c 10 80 	movl   $0x80108cb3,(%esp)
80104b9b:	e8 9d b9 ff ff       	call   8010053d <panic>
  if(proc->state == RUNNING)
80104ba0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ba6:	8b 40 0c             	mov    0xc(%eax),%eax
80104ba9:	83 f8 04             	cmp    $0x4,%eax
80104bac:	75 0c                	jne    80104bba <sched+0x59>
    panic("sched running");
80104bae:	c7 04 24 bf 8c 10 80 	movl   $0x80108cbf,(%esp)
80104bb5:	e8 83 b9 ff ff       	call   8010053d <panic>
  if(readeflags()&FL_IF)
80104bba:	e8 05 f8 ff ff       	call   801043c4 <readeflags>
80104bbf:	25 00 02 00 00       	and    $0x200,%eax
80104bc4:	85 c0                	test   %eax,%eax
80104bc6:	74 0c                	je     80104bd4 <sched+0x73>
    panic("sched interruptible");
80104bc8:	c7 04 24 cd 8c 10 80 	movl   $0x80108ccd,(%esp)
80104bcf:	e8 69 b9 ff ff       	call   8010053d <panic>
  intena = cpu->intena;
80104bd4:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104bda:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104be0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
80104be3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104be9:	8b 40 04             	mov    0x4(%eax),%eax
80104bec:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104bf3:	83 c2 1c             	add    $0x1c,%edx
80104bf6:	89 44 24 04          	mov    %eax,0x4(%esp)
80104bfa:	89 14 24             	mov    %edx,(%esp)
80104bfd:	e8 5a 08 00 00       	call   8010545c <swtch>
  cpu->intena = intena;
80104c02:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104c08:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104c0b:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104c11:	c9                   	leave  
80104c12:	c3                   	ret    

80104c13 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104c13:	55                   	push   %ebp
80104c14:	89 e5                	mov    %esp,%ebp
80104c16:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104c19:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104c20:	e8 3a 03 00 00       	call   80104f5f <acquire>
  proc->state = RUNNABLE;
80104c25:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c2b:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104c32:	e8 2a ff ff ff       	call   80104b61 <sched>
  release(&ptable.lock);
80104c37:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104c3e:	e8 7d 03 00 00       	call   80104fc0 <release>
}
80104c43:	c9                   	leave  
80104c44:	c3                   	ret    

80104c45 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104c45:	55                   	push   %ebp
80104c46:	89 e5                	mov    %esp,%ebp
80104c48:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104c4b:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104c52:	e8 69 03 00 00       	call   80104fc0 <release>

  if (first) {
80104c57:	a1 20 c0 10 80       	mov    0x8010c020,%eax
80104c5c:	85 c0                	test   %eax,%eax
80104c5e:	74 22                	je     80104c82 <forkret+0x3d>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
80104c60:	c7 05 20 c0 10 80 00 	movl   $0x0,0x8010c020
80104c67:	00 00 00 
    iinit(ROOTDEV);
80104c6a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104c71:	e8 5d c9 ff ff       	call   801015d3 <iinit>
    initlog(ROOTDEV);
80104c76:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104c7d:	e8 72 e6 ff ff       	call   801032f4 <initlog>
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
80104c82:	c9                   	leave  
80104c83:	c3                   	ret    

80104c84 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104c84:	55                   	push   %ebp
80104c85:	89 e5                	mov    %esp,%ebp
80104c87:	83 ec 18             	sub    $0x18,%esp
  if(proc == 0)
80104c8a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c90:	85 c0                	test   %eax,%eax
80104c92:	75 0c                	jne    80104ca0 <sleep+0x1c>
    panic("sleep");
80104c94:	c7 04 24 e1 8c 10 80 	movl   $0x80108ce1,(%esp)
80104c9b:	e8 9d b8 ff ff       	call   8010053d <panic>

  if(lk == 0)
80104ca0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104ca4:	75 0c                	jne    80104cb2 <sleep+0x2e>
    panic("sleep without lk");
80104ca6:	c7 04 24 e7 8c 10 80 	movl   $0x80108ce7,(%esp)
80104cad:	e8 8b b8 ff ff       	call   8010053d <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104cb2:	81 7d 0c 80 39 11 80 	cmpl   $0x80113980,0xc(%ebp)
80104cb9:	74 17                	je     80104cd2 <sleep+0x4e>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104cbb:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104cc2:	e8 98 02 00 00       	call   80104f5f <acquire>
    release(lk);
80104cc7:	8b 45 0c             	mov    0xc(%ebp),%eax
80104cca:	89 04 24             	mov    %eax,(%esp)
80104ccd:	e8 ee 02 00 00       	call   80104fc0 <release>
  }

  // Go to sleep.
  proc->chan = chan;
80104cd2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cd8:	8b 55 08             	mov    0x8(%ebp),%edx
80104cdb:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
80104cde:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ce4:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80104ceb:	e8 71 fe ff ff       	call   80104b61 <sched>

  // Tidy up.
  proc->chan = 0;
80104cf0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cf6:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104cfd:	81 7d 0c 80 39 11 80 	cmpl   $0x80113980,0xc(%ebp)
80104d04:	74 17                	je     80104d1d <sleep+0x99>
    release(&ptable.lock);
80104d06:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104d0d:	e8 ae 02 00 00       	call   80104fc0 <release>
    acquire(lk);
80104d12:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d15:	89 04 24             	mov    %eax,(%esp)
80104d18:	e8 42 02 00 00       	call   80104f5f <acquire>
  }
}
80104d1d:	c9                   	leave  
80104d1e:	c3                   	ret    

80104d1f <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104d1f:	55                   	push   %ebp
80104d20:	89 e5                	mov    %esp,%ebp
80104d22:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d25:	c7 45 fc b4 39 11 80 	movl   $0x801139b4,-0x4(%ebp)
80104d2c:	eb 27                	jmp    80104d55 <wakeup1+0x36>
    if(p->state == SLEEPING && p->chan == chan)
80104d2e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d31:	8b 40 0c             	mov    0xc(%eax),%eax
80104d34:	83 f8 02             	cmp    $0x2,%eax
80104d37:	75 15                	jne    80104d4e <wakeup1+0x2f>
80104d39:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d3c:	8b 40 20             	mov    0x20(%eax),%eax
80104d3f:	3b 45 08             	cmp    0x8(%ebp),%eax
80104d42:	75 0a                	jne    80104d4e <wakeup1+0x2f>
      p->state = RUNNABLE;
80104d44:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d47:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d4e:	81 45 fc 08 01 00 00 	addl   $0x108,-0x4(%ebp)
80104d55:	b8 b4 7b 11 80       	mov    $0x80117bb4,%eax
80104d5a:	39 45 fc             	cmp    %eax,-0x4(%ebp)
80104d5d:	72 cf                	jb     80104d2e <wakeup1+0xf>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
80104d5f:	c9                   	leave  
80104d60:	c3                   	ret    

80104d61 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104d61:	55                   	push   %ebp
80104d62:	89 e5                	mov    %esp,%ebp
80104d64:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80104d67:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104d6e:	e8 ec 01 00 00       	call   80104f5f <acquire>
  wakeup1(chan);
80104d73:	8b 45 08             	mov    0x8(%ebp),%eax
80104d76:	89 04 24             	mov    %eax,(%esp)
80104d79:	e8 a1 ff ff ff       	call   80104d1f <wakeup1>
  release(&ptable.lock);
80104d7e:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104d85:	e8 36 02 00 00       	call   80104fc0 <release>
}
80104d8a:	c9                   	leave  
80104d8b:	c3                   	ret    

80104d8c <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104d8c:	55                   	push   %ebp
80104d8d:	89 e5                	mov    %esp,%ebp
80104d8f:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104d92:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104d99:	e8 c1 01 00 00       	call   80104f5f <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d9e:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104da5:	eb 44                	jmp    80104deb <kill+0x5f>
    if(p->pid == pid){
80104da7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104daa:	8b 40 10             	mov    0x10(%eax),%eax
80104dad:	3b 45 08             	cmp    0x8(%ebp),%eax
80104db0:	75 32                	jne    80104de4 <kill+0x58>
      p->killed = 1;
80104db2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104db5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dbf:	8b 40 0c             	mov    0xc(%eax),%eax
80104dc2:	83 f8 02             	cmp    $0x2,%eax
80104dc5:	75 0a                	jne    80104dd1 <kill+0x45>
        p->state = RUNNABLE;
80104dc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dca:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104dd1:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104dd8:	e8 e3 01 00 00       	call   80104fc0 <release>
      return 0;
80104ddd:	b8 00 00 00 00       	mov    $0x0,%eax
80104de2:	eb 22                	jmp    80104e06 <kill+0x7a>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104de4:	81 45 f4 08 01 00 00 	addl   $0x108,-0xc(%ebp)
80104deb:	b8 b4 7b 11 80       	mov    $0x80117bb4,%eax
80104df0:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80104df3:	72 b2                	jb     80104da7 <kill+0x1b>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104df5:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104dfc:	e8 bf 01 00 00       	call   80104fc0 <release>
  return -1;
80104e01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e06:	c9                   	leave  
80104e07:	c3                   	ret    

80104e08 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104e08:	55                   	push   %ebp
80104e09:	89 e5                	mov    %esp,%ebp
80104e0b:	83 ec 58             	sub    $0x58,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e0e:	c7 45 f0 b4 39 11 80 	movl   $0x801139b4,-0x10(%ebp)
80104e15:	e9 db 00 00 00       	jmp    80104ef5 <procdump+0xed>
    if(p->state == UNUSED)
80104e1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e1d:	8b 40 0c             	mov    0xc(%eax),%eax
80104e20:	85 c0                	test   %eax,%eax
80104e22:	0f 84 c5 00 00 00    	je     80104eed <procdump+0xe5>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104e28:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e2b:	8b 40 0c             	mov    0xc(%eax),%eax
80104e2e:	83 f8 05             	cmp    $0x5,%eax
80104e31:	77 23                	ja     80104e56 <procdump+0x4e>
80104e33:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e36:	8b 40 0c             	mov    0xc(%eax),%eax
80104e39:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
80104e40:	85 c0                	test   %eax,%eax
80104e42:	74 12                	je     80104e56 <procdump+0x4e>
      state = states[p->state];
80104e44:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e47:	8b 40 0c             	mov    0xc(%eax),%eax
80104e4a:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
80104e51:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104e54:	eb 07                	jmp    80104e5d <procdump+0x55>
      state = states[p->state];
    else
      state = "???";
80104e56:	c7 45 f4 f8 8c 10 80 	movl   $0x80108cf8,-0xc(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80104e5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e60:	8d 50 6c             	lea    0x6c(%eax),%edx
80104e63:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e66:	8b 40 10             	mov    0x10(%eax),%eax
80104e69:	89 54 24 0c          	mov    %edx,0xc(%esp)
80104e6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e70:	89 54 24 08          	mov    %edx,0x8(%esp)
80104e74:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e78:	c7 04 24 fc 8c 10 80 	movl   $0x80108cfc,(%esp)
80104e7f:	e8 19 b5 ff ff       	call   8010039d <cprintf>
    if(p->state == SLEEPING){
80104e84:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e87:	8b 40 0c             	mov    0xc(%eax),%eax
80104e8a:	83 f8 02             	cmp    $0x2,%eax
80104e8d:	75 50                	jne    80104edf <procdump+0xd7>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104e8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e92:	8b 40 1c             	mov    0x1c(%eax),%eax
80104e95:	8b 40 0c             	mov    0xc(%eax),%eax
80104e98:	83 c0 08             	add    $0x8,%eax
80104e9b:	8d 55 c4             	lea    -0x3c(%ebp),%edx
80104e9e:	89 54 24 04          	mov    %edx,0x4(%esp)
80104ea2:	89 04 24             	mov    %eax,(%esp)
80104ea5:	e8 65 01 00 00       	call   8010500f <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104eaa:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80104eb1:	eb 1b                	jmp    80104ece <procdump+0xc6>
        cprintf(" %p", pc[i]);
80104eb3:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104eb6:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104eba:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ebe:	c7 04 24 05 8d 10 80 	movl   $0x80108d05,(%esp)
80104ec5:	e8 d3 b4 ff ff       	call   8010039d <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104eca:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80104ece:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
80104ed2:	7f 0b                	jg     80104edf <procdump+0xd7>
80104ed4:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104ed7:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104edb:	85 c0                	test   %eax,%eax
80104edd:	75 d4                	jne    80104eb3 <procdump+0xab>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104edf:	c7 04 24 09 8d 10 80 	movl   $0x80108d09,(%esp)
80104ee6:	e8 b2 b4 ff ff       	call   8010039d <cprintf>
80104eeb:	eb 01                	jmp    80104eee <procdump+0xe6>
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
80104eed:	90                   	nop
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104eee:	81 45 f0 08 01 00 00 	addl   $0x108,-0x10(%ebp)
80104ef5:	b8 b4 7b 11 80       	mov    $0x80117bb4,%eax
80104efa:	39 45 f0             	cmp    %eax,-0x10(%ebp)
80104efd:	0f 82 17 ff ff ff    	jb     80104e1a <procdump+0x12>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104f03:	c9                   	leave  
80104f04:	c3                   	ret    
80104f05:	00 00                	add    %al,(%eax)
	...

80104f08 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80104f08:	55                   	push   %ebp
80104f09:	89 e5                	mov    %esp,%ebp
80104f0b:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104f0e:	9c                   	pushf  
80104f0f:	58                   	pop    %eax
80104f10:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80104f13:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104f16:	c9                   	leave  
80104f17:	c3                   	ret    

80104f18 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80104f18:	55                   	push   %ebp
80104f19:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80104f1b:	fa                   	cli    
}
80104f1c:	5d                   	pop    %ebp
80104f1d:	c3                   	ret    

80104f1e <sti>:

static inline void
sti(void)
{
80104f1e:	55                   	push   %ebp
80104f1f:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104f21:	fb                   	sti    
}
80104f22:	5d                   	pop    %ebp
80104f23:	c3                   	ret    

80104f24 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80104f24:	55                   	push   %ebp
80104f25:	89 e5                	mov    %esp,%ebp
80104f27:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104f2a:	8b 55 08             	mov    0x8(%ebp),%edx
80104f2d:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f30:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104f33:	f0 87 02             	lock xchg %eax,(%edx)
80104f36:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80104f39:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104f3c:	c9                   	leave  
80104f3d:	c3                   	ret    

80104f3e <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104f3e:	55                   	push   %ebp
80104f3f:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80104f41:	8b 45 08             	mov    0x8(%ebp),%eax
80104f44:	8b 55 0c             	mov    0xc(%ebp),%edx
80104f47:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80104f4a:	8b 45 08             	mov    0x8(%ebp),%eax
80104f4d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80104f53:	8b 45 08             	mov    0x8(%ebp),%eax
80104f56:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104f5d:	5d                   	pop    %ebp
80104f5e:	c3                   	ret    

80104f5f <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104f5f:	55                   	push   %ebp
80104f60:	89 e5                	mov    %esp,%ebp
80104f62:	83 ec 18             	sub    $0x18,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104f65:	e8 47 01 00 00       	call   801050b1 <pushcli>
  if(holding(lk))
80104f6a:	8b 45 08             	mov    0x8(%ebp),%eax
80104f6d:	89 04 24             	mov    %eax,(%esp)
80104f70:	e8 12 01 00 00       	call   80105087 <holding>
80104f75:	85 c0                	test   %eax,%eax
80104f77:	74 0c                	je     80104f85 <acquire+0x26>
    panic("acquire");
80104f79:	c7 04 24 35 8d 10 80 	movl   $0x80108d35,(%esp)
80104f80:	e8 b8 b5 ff ff       	call   8010053d <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80104f85:	8b 45 08             	mov    0x8(%ebp),%eax
80104f88:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80104f8f:	00 
80104f90:	89 04 24             	mov    %eax,(%esp)
80104f93:	e8 8c ff ff ff       	call   80104f24 <xchg>
80104f98:	85 c0                	test   %eax,%eax
80104f9a:	75 e9                	jne    80104f85 <acquire+0x26>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80104f9c:	8b 45 08             	mov    0x8(%ebp),%eax
80104f9f:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104fa6:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80104fa9:	8b 45 08             	mov    0x8(%ebp),%eax
80104fac:	83 c0 0c             	add    $0xc,%eax
80104faf:	89 44 24 04          	mov    %eax,0x4(%esp)
80104fb3:	8d 45 08             	lea    0x8(%ebp),%eax
80104fb6:	89 04 24             	mov    %eax,(%esp)
80104fb9:	e8 51 00 00 00       	call   8010500f <getcallerpcs>
}
80104fbe:	c9                   	leave  
80104fbf:	c3                   	ret    

80104fc0 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80104fc0:	55                   	push   %ebp
80104fc1:	89 e5                	mov    %esp,%ebp
80104fc3:	83 ec 18             	sub    $0x18,%esp
  if(!holding(lk))
80104fc6:	8b 45 08             	mov    0x8(%ebp),%eax
80104fc9:	89 04 24             	mov    %eax,(%esp)
80104fcc:	e8 b6 00 00 00       	call   80105087 <holding>
80104fd1:	85 c0                	test   %eax,%eax
80104fd3:	75 0c                	jne    80104fe1 <release+0x21>
    panic("release");
80104fd5:	c7 04 24 3d 8d 10 80 	movl   $0x80108d3d,(%esp)
80104fdc:	e8 5c b5 ff ff       	call   8010053d <panic>

  lk->pcs[0] = 0;
80104fe1:	8b 45 08             	mov    0x8(%ebp),%eax
80104fe4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80104feb:	8b 45 08             	mov    0x8(%ebp),%eax
80104fee:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
80104ff5:	8b 45 08             	mov    0x8(%ebp),%eax
80104ff8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104fff:	00 
80105000:	89 04 24             	mov    %eax,(%esp)
80105003:	e8 1c ff ff ff       	call   80104f24 <xchg>

  popcli();
80105008:	e8 ec 00 00 00       	call   801050f9 <popcli>
}
8010500d:	c9                   	leave  
8010500e:	c3                   	ret    

8010500f <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
8010500f:	55                   	push   %ebp
80105010:	89 e5                	mov    %esp,%ebp
80105012:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
80105015:	8b 45 08             	mov    0x8(%ebp),%eax
80105018:	83 e8 08             	sub    $0x8,%eax
8010501b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(i = 0; i < 10; i++){
8010501e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105025:	eb 34                	jmp    8010505b <getcallerpcs+0x4c>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105027:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
8010502b:	74 4b                	je     80105078 <getcallerpcs+0x69>
8010502d:	81 7d f8 ff ff ff 7f 	cmpl   $0x7fffffff,-0x8(%ebp)
80105034:	76 45                	jbe    8010507b <getcallerpcs+0x6c>
80105036:	83 7d f8 ff          	cmpl   $0xffffffff,-0x8(%ebp)
8010503a:	74 42                	je     8010507e <getcallerpcs+0x6f>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010503c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010503f:	c1 e0 02             	shl    $0x2,%eax
80105042:	03 45 0c             	add    0xc(%ebp),%eax
80105045:	8b 55 f8             	mov    -0x8(%ebp),%edx
80105048:	83 c2 04             	add    $0x4,%edx
8010504b:	8b 12                	mov    (%edx),%edx
8010504d:	89 10                	mov    %edx,(%eax)
    ebp = (uint*)ebp[0]; // saved %ebp
8010504f:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105052:	8b 00                	mov    (%eax),%eax
80105054:	89 45 f8             	mov    %eax,-0x8(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105057:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010505b:	83 7d fc 09          	cmpl   $0x9,-0x4(%ebp)
8010505f:	7e c6                	jle    80105027 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80105061:	eb 1c                	jmp    8010507f <getcallerpcs+0x70>
    pcs[i] = 0;
80105063:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105066:	c1 e0 02             	shl    $0x2,%eax
80105069:	03 45 0c             	add    0xc(%ebp),%eax
8010506c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80105072:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105076:	eb 07                	jmp    8010507f <getcallerpcs+0x70>
80105078:	90                   	nop
80105079:	eb 04                	jmp    8010507f <getcallerpcs+0x70>
8010507b:	90                   	nop
8010507c:	eb 01                	jmp    8010507f <getcallerpcs+0x70>
8010507e:	90                   	nop
8010507f:	83 7d fc 09          	cmpl   $0x9,-0x4(%ebp)
80105083:	7e de                	jle    80105063 <getcallerpcs+0x54>
    pcs[i] = 0;
}
80105085:	c9                   	leave  
80105086:	c3                   	ret    

80105087 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80105087:	55                   	push   %ebp
80105088:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
8010508a:	8b 45 08             	mov    0x8(%ebp),%eax
8010508d:	8b 00                	mov    (%eax),%eax
8010508f:	85 c0                	test   %eax,%eax
80105091:	74 17                	je     801050aa <holding+0x23>
80105093:	8b 45 08             	mov    0x8(%ebp),%eax
80105096:	8b 50 08             	mov    0x8(%eax),%edx
80105099:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010509f:	39 c2                	cmp    %eax,%edx
801050a1:	75 07                	jne    801050aa <holding+0x23>
801050a3:	b8 01 00 00 00       	mov    $0x1,%eax
801050a8:	eb 05                	jmp    801050af <holding+0x28>
801050aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
801050af:	5d                   	pop    %ebp
801050b0:	c3                   	ret    

801050b1 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801050b1:	55                   	push   %ebp
801050b2:	89 e5                	mov    %esp,%ebp
801050b4:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
801050b7:	e8 4c fe ff ff       	call   80104f08 <readeflags>
801050bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
801050bf:	e8 54 fe ff ff       	call   80104f18 <cli>
  if(cpu->ncli++ == 0)
801050c4:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801050ca:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
801050d0:	85 d2                	test   %edx,%edx
801050d2:	0f 94 c1             	sete   %cl
801050d5:	83 c2 01             	add    $0x1,%edx
801050d8:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
801050de:	84 c9                	test   %cl,%cl
801050e0:	74 15                	je     801050f7 <pushcli+0x46>
    cpu->intena = eflags & FL_IF;
801050e2:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801050e8:	8b 55 fc             	mov    -0x4(%ebp),%edx
801050eb:	81 e2 00 02 00 00    	and    $0x200,%edx
801050f1:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
801050f7:	c9                   	leave  
801050f8:	c3                   	ret    

801050f9 <popcli>:

void
popcli(void)
{
801050f9:	55                   	push   %ebp
801050fa:	89 e5                	mov    %esp,%ebp
801050fc:	83 ec 18             	sub    $0x18,%esp
  if(readeflags()&FL_IF)
801050ff:	e8 04 fe ff ff       	call   80104f08 <readeflags>
80105104:	25 00 02 00 00       	and    $0x200,%eax
80105109:	85 c0                	test   %eax,%eax
8010510b:	74 0c                	je     80105119 <popcli+0x20>
    panic("popcli - interruptible");
8010510d:	c7 04 24 45 8d 10 80 	movl   $0x80108d45,(%esp)
80105114:	e8 24 b4 ff ff       	call   8010053d <panic>
  if(--cpu->ncli < 0)
80105119:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010511f:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80105125:	83 ea 01             	sub    $0x1,%edx
80105128:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
8010512e:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105134:	85 c0                	test   %eax,%eax
80105136:	79 0c                	jns    80105144 <popcli+0x4b>
    panic("popcli");
80105138:	c7 04 24 5c 8d 10 80 	movl   $0x80108d5c,(%esp)
8010513f:	e8 f9 b3 ff ff       	call   8010053d <panic>
  if(cpu->ncli == 0 && cpu->intena)
80105144:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010514a:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105150:	85 c0                	test   %eax,%eax
80105152:	75 15                	jne    80105169 <popcli+0x70>
80105154:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010515a:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80105160:	85 c0                	test   %eax,%eax
80105162:	74 05                	je     80105169 <popcli+0x70>
    sti();
80105164:	e8 b5 fd ff ff       	call   80104f1e <sti>
}
80105169:	c9                   	leave  
8010516a:	c3                   	ret    
	...

8010516c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
8010516c:	55                   	push   %ebp
8010516d:	89 e5                	mov    %esp,%ebp
8010516f:	57                   	push   %edi
80105170:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80105171:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105174:	8b 55 10             	mov    0x10(%ebp),%edx
80105177:	8b 45 0c             	mov    0xc(%ebp),%eax
8010517a:	89 cb                	mov    %ecx,%ebx
8010517c:	89 df                	mov    %ebx,%edi
8010517e:	89 d1                	mov    %edx,%ecx
80105180:	fc                   	cld    
80105181:	f3 aa                	rep stos %al,%es:(%edi)
80105183:	89 ca                	mov    %ecx,%edx
80105185:	89 fb                	mov    %edi,%ebx
80105187:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010518a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
8010518d:	5b                   	pop    %ebx
8010518e:	5f                   	pop    %edi
8010518f:	5d                   	pop    %ebp
80105190:	c3                   	ret    

80105191 <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
80105191:	55                   	push   %ebp
80105192:	89 e5                	mov    %esp,%ebp
80105194:	57                   	push   %edi
80105195:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80105196:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105199:	8b 55 10             	mov    0x10(%ebp),%edx
8010519c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010519f:	89 cb                	mov    %ecx,%ebx
801051a1:	89 df                	mov    %ebx,%edi
801051a3:	89 d1                	mov    %edx,%ecx
801051a5:	fc                   	cld    
801051a6:	f3 ab                	rep stos %eax,%es:(%edi)
801051a8:	89 ca                	mov    %ecx,%edx
801051aa:	89 fb                	mov    %edi,%ebx
801051ac:	89 5d 08             	mov    %ebx,0x8(%ebp)
801051af:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
801051b2:	5b                   	pop    %ebx
801051b3:	5f                   	pop    %edi
801051b4:	5d                   	pop    %ebp
801051b5:	c3                   	ret    

801051b6 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801051b6:	55                   	push   %ebp
801051b7:	89 e5                	mov    %esp,%ebp
801051b9:	83 ec 0c             	sub    $0xc,%esp
  if ((int)dst%4 == 0 && n%4 == 0){
801051bc:	8b 45 08             	mov    0x8(%ebp),%eax
801051bf:	83 e0 03             	and    $0x3,%eax
801051c2:	85 c0                	test   %eax,%eax
801051c4:	75 49                	jne    8010520f <memset+0x59>
801051c6:	8b 45 10             	mov    0x10(%ebp),%eax
801051c9:	83 e0 03             	and    $0x3,%eax
801051cc:	85 c0                	test   %eax,%eax
801051ce:	75 3f                	jne    8010520f <memset+0x59>
    c &= 0xFF;
801051d0:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801051d7:	8b 45 10             	mov    0x10(%ebp),%eax
801051da:	c1 e8 02             	shr    $0x2,%eax
801051dd:	89 c2                	mov    %eax,%edx
801051df:	8b 45 0c             	mov    0xc(%ebp),%eax
801051e2:	89 c1                	mov    %eax,%ecx
801051e4:	c1 e1 18             	shl    $0x18,%ecx
801051e7:	8b 45 0c             	mov    0xc(%ebp),%eax
801051ea:	c1 e0 10             	shl    $0x10,%eax
801051ed:	09 c1                	or     %eax,%ecx
801051ef:	8b 45 0c             	mov    0xc(%ebp),%eax
801051f2:	c1 e0 08             	shl    $0x8,%eax
801051f5:	09 c8                	or     %ecx,%eax
801051f7:	0b 45 0c             	or     0xc(%ebp),%eax
801051fa:	89 54 24 08          	mov    %edx,0x8(%esp)
801051fe:	89 44 24 04          	mov    %eax,0x4(%esp)
80105202:	8b 45 08             	mov    0x8(%ebp),%eax
80105205:	89 04 24             	mov    %eax,(%esp)
80105208:	e8 84 ff ff ff       	call   80105191 <stosl>
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
8010520d:	eb 19                	jmp    80105228 <memset+0x72>
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
8010520f:	8b 45 10             	mov    0x10(%ebp),%eax
80105212:	89 44 24 08          	mov    %eax,0x8(%esp)
80105216:	8b 45 0c             	mov    0xc(%ebp),%eax
80105219:	89 44 24 04          	mov    %eax,0x4(%esp)
8010521d:	8b 45 08             	mov    0x8(%ebp),%eax
80105220:	89 04 24             	mov    %eax,(%esp)
80105223:	e8 44 ff ff ff       	call   8010516c <stosb>
  return dst;
80105228:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010522b:	c9                   	leave  
8010522c:	c3                   	ret    

8010522d <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
8010522d:	55                   	push   %ebp
8010522e:	89 e5                	mov    %esp,%ebp
80105230:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
80105233:	8b 45 08             	mov    0x8(%ebp),%eax
80105236:	89 45 f8             	mov    %eax,-0x8(%ebp)
  s2 = v2;
80105239:	8b 45 0c             	mov    0xc(%ebp),%eax
8010523c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0){
8010523f:	eb 32                	jmp    80105273 <memcmp+0x46>
    if(*s1 != *s2)
80105241:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105244:	0f b6 10             	movzbl (%eax),%edx
80105247:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010524a:	0f b6 00             	movzbl (%eax),%eax
8010524d:	38 c2                	cmp    %al,%dl
8010524f:	74 1a                	je     8010526b <memcmp+0x3e>
      return *s1 - *s2;
80105251:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105254:	0f b6 00             	movzbl (%eax),%eax
80105257:	0f b6 d0             	movzbl %al,%edx
8010525a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010525d:	0f b6 00             	movzbl (%eax),%eax
80105260:	0f b6 c0             	movzbl %al,%eax
80105263:	89 d1                	mov    %edx,%ecx
80105265:	29 c1                	sub    %eax,%ecx
80105267:	89 c8                	mov    %ecx,%eax
80105269:	eb 1c                	jmp    80105287 <memcmp+0x5a>
    s1++, s2++;
8010526b:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010526f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80105273:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105277:	0f 95 c0             	setne  %al
8010527a:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
8010527e:	84 c0                	test   %al,%al
80105280:	75 bf                	jne    80105241 <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80105282:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105287:	c9                   	leave  
80105288:	c3                   	ret    

80105289 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105289:	55                   	push   %ebp
8010528a:	89 e5                	mov    %esp,%ebp
8010528c:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
8010528f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105292:	89 45 f8             	mov    %eax,-0x8(%ebp)
  d = dst;
80105295:	8b 45 08             	mov    0x8(%ebp),%eax
80105298:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(s < d && s + n > d){
8010529b:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010529e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
801052a1:	73 55                	jae    801052f8 <memmove+0x6f>
801052a3:	8b 45 10             	mov    0x10(%ebp),%eax
801052a6:	8b 55 f8             	mov    -0x8(%ebp),%edx
801052a9:	8d 04 02             	lea    (%edx,%eax,1),%eax
801052ac:	3b 45 fc             	cmp    -0x4(%ebp),%eax
801052af:	76 4a                	jbe    801052fb <memmove+0x72>
    s += n;
801052b1:	8b 45 10             	mov    0x10(%ebp),%eax
801052b4:	01 45 f8             	add    %eax,-0x8(%ebp)
    d += n;
801052b7:	8b 45 10             	mov    0x10(%ebp),%eax
801052ba:	01 45 fc             	add    %eax,-0x4(%ebp)
    while(n-- > 0)
801052bd:	eb 13                	jmp    801052d2 <memmove+0x49>
      *--d = *--s;
801052bf:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
801052c3:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
801052c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
801052ca:	0f b6 10             	movzbl (%eax),%edx
801052cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
801052d0:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
801052d2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801052d6:	0f 95 c0             	setne  %al
801052d9:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801052dd:	84 c0                	test   %al,%al
801052df:	75 de                	jne    801052bf <memmove+0x36>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801052e1:	eb 28                	jmp    8010530b <memmove+0x82>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
801052e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
801052e6:	0f b6 10             	movzbl (%eax),%edx
801052e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
801052ec:	88 10                	mov    %dl,(%eax)
801052ee:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801052f2:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801052f6:	eb 04                	jmp    801052fc <memmove+0x73>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801052f8:	90                   	nop
801052f9:	eb 01                	jmp    801052fc <memmove+0x73>
801052fb:	90                   	nop
801052fc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105300:	0f 95 c0             	setne  %al
80105303:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105307:	84 c0                	test   %al,%al
80105309:	75 d8                	jne    801052e3 <memmove+0x5a>
      *d++ = *s++;

  return dst;
8010530b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010530e:	c9                   	leave  
8010530f:	c3                   	ret    

80105310 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105310:	55                   	push   %ebp
80105311:	89 e5                	mov    %esp,%ebp
80105313:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
80105316:	8b 45 10             	mov    0x10(%ebp),%eax
80105319:	89 44 24 08          	mov    %eax,0x8(%esp)
8010531d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105320:	89 44 24 04          	mov    %eax,0x4(%esp)
80105324:	8b 45 08             	mov    0x8(%ebp),%eax
80105327:	89 04 24             	mov    %eax,(%esp)
8010532a:	e8 5a ff ff ff       	call   80105289 <memmove>
}
8010532f:	c9                   	leave  
80105330:	c3                   	ret    

80105331 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105331:	55                   	push   %ebp
80105332:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80105334:	eb 0c                	jmp    80105342 <strncmp+0x11>
    n--, p++, q++;
80105336:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
8010533a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
8010533e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80105342:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105346:	74 1a                	je     80105362 <strncmp+0x31>
80105348:	8b 45 08             	mov    0x8(%ebp),%eax
8010534b:	0f b6 00             	movzbl (%eax),%eax
8010534e:	84 c0                	test   %al,%al
80105350:	74 10                	je     80105362 <strncmp+0x31>
80105352:	8b 45 08             	mov    0x8(%ebp),%eax
80105355:	0f b6 10             	movzbl (%eax),%edx
80105358:	8b 45 0c             	mov    0xc(%ebp),%eax
8010535b:	0f b6 00             	movzbl (%eax),%eax
8010535e:	38 c2                	cmp    %al,%dl
80105360:	74 d4                	je     80105336 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
80105362:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105366:	75 07                	jne    8010536f <strncmp+0x3e>
    return 0;
80105368:	b8 00 00 00 00       	mov    $0x0,%eax
8010536d:	eb 18                	jmp    80105387 <strncmp+0x56>
  return (uchar)*p - (uchar)*q;
8010536f:	8b 45 08             	mov    0x8(%ebp),%eax
80105372:	0f b6 00             	movzbl (%eax),%eax
80105375:	0f b6 d0             	movzbl %al,%edx
80105378:	8b 45 0c             	mov    0xc(%ebp),%eax
8010537b:	0f b6 00             	movzbl (%eax),%eax
8010537e:	0f b6 c0             	movzbl %al,%eax
80105381:	89 d1                	mov    %edx,%ecx
80105383:	29 c1                	sub    %eax,%ecx
80105385:	89 c8                	mov    %ecx,%eax
}
80105387:	5d                   	pop    %ebp
80105388:	c3                   	ret    

80105389 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105389:	55                   	push   %ebp
8010538a:	89 e5                	mov    %esp,%ebp
8010538c:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
8010538f:	8b 45 08             	mov    0x8(%ebp),%eax
80105392:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80105395:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105399:	0f 9f c0             	setg   %al
8010539c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801053a0:	84 c0                	test   %al,%al
801053a2:	74 30                	je     801053d4 <strncpy+0x4b>
801053a4:	8b 45 0c             	mov    0xc(%ebp),%eax
801053a7:	0f b6 10             	movzbl (%eax),%edx
801053aa:	8b 45 08             	mov    0x8(%ebp),%eax
801053ad:	88 10                	mov    %dl,(%eax)
801053af:	8b 45 08             	mov    0x8(%ebp),%eax
801053b2:	0f b6 00             	movzbl (%eax),%eax
801053b5:	84 c0                	test   %al,%al
801053b7:	0f 95 c0             	setne  %al
801053ba:	83 45 08 01          	addl   $0x1,0x8(%ebp)
801053be:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
801053c2:	84 c0                	test   %al,%al
801053c4:	75 cf                	jne    80105395 <strncpy+0xc>
    ;
  while(n-- > 0)
801053c6:	eb 0d                	jmp    801053d5 <strncpy+0x4c>
    *s++ = 0;
801053c8:	8b 45 08             	mov    0x8(%ebp),%eax
801053cb:	c6 00 00             	movb   $0x0,(%eax)
801053ce:	83 45 08 01          	addl   $0x1,0x8(%ebp)
801053d2:	eb 01                	jmp    801053d5 <strncpy+0x4c>
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
801053d4:	90                   	nop
801053d5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801053d9:	0f 9f c0             	setg   %al
801053dc:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801053e0:	84 c0                	test   %al,%al
801053e2:	75 e4                	jne    801053c8 <strncpy+0x3f>
    *s++ = 0;
  return os;
801053e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801053e7:	c9                   	leave  
801053e8:	c3                   	ret    

801053e9 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801053e9:	55                   	push   %ebp
801053ea:	89 e5                	mov    %esp,%ebp
801053ec:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
801053ef:	8b 45 08             	mov    0x8(%ebp),%eax
801053f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
801053f5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801053f9:	7f 05                	jg     80105400 <safestrcpy+0x17>
    return os;
801053fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
801053fe:	eb 35                	jmp    80105435 <safestrcpy+0x4c>
  while(--n > 0 && (*s++ = *t++) != 0)
80105400:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105404:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105408:	7e 22                	jle    8010542c <safestrcpy+0x43>
8010540a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010540d:	0f b6 10             	movzbl (%eax),%edx
80105410:	8b 45 08             	mov    0x8(%ebp),%eax
80105413:	88 10                	mov    %dl,(%eax)
80105415:	8b 45 08             	mov    0x8(%ebp),%eax
80105418:	0f b6 00             	movzbl (%eax),%eax
8010541b:	84 c0                	test   %al,%al
8010541d:	0f 95 c0             	setne  %al
80105420:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80105424:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80105428:	84 c0                	test   %al,%al
8010542a:	75 d4                	jne    80105400 <safestrcpy+0x17>
    ;
  *s = 0;
8010542c:	8b 45 08             	mov    0x8(%ebp),%eax
8010542f:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80105432:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105435:	c9                   	leave  
80105436:	c3                   	ret    

80105437 <strlen>:

int
strlen(const char *s)
{
80105437:	55                   	push   %ebp
80105438:	89 e5                	mov    %esp,%ebp
8010543a:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
8010543d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105444:	eb 04                	jmp    8010544a <strlen+0x13>
80105446:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010544a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010544d:	03 45 08             	add    0x8(%ebp),%eax
80105450:	0f b6 00             	movzbl (%eax),%eax
80105453:	84 c0                	test   %al,%al
80105455:	75 ef                	jne    80105446 <strlen+0xf>
    ;
  return n;
80105457:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010545a:	c9                   	leave  
8010545b:	c3                   	ret    

8010545c <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010545c:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105460:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80105464:	55                   	push   %ebp
  pushl %ebx
80105465:	53                   	push   %ebx
  pushl %esi
80105466:	56                   	push   %esi
  pushl %edi
80105467:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105468:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
8010546a:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
8010546c:	5f                   	pop    %edi
  popl %esi
8010546d:	5e                   	pop    %esi
  popl %ebx
8010546e:	5b                   	pop    %ebx
  popl %ebp
8010546f:	5d                   	pop    %ebp
  ret
80105470:	c3                   	ret    
80105471:	00 00                	add    %al,(%eax)
	...

80105474 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105474:	55                   	push   %ebp
80105475:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
80105477:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010547d:	8b 00                	mov    (%eax),%eax
8010547f:	3b 45 08             	cmp    0x8(%ebp),%eax
80105482:	76 12                	jbe    80105496 <fetchint+0x22>
80105484:	8b 45 08             	mov    0x8(%ebp),%eax
80105487:	8d 50 04             	lea    0x4(%eax),%edx
8010548a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105490:	8b 00                	mov    (%eax),%eax
80105492:	39 c2                	cmp    %eax,%edx
80105494:	76 07                	jbe    8010549d <fetchint+0x29>
    return -1;
80105496:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010549b:	eb 0f                	jmp    801054ac <fetchint+0x38>
  *ip = *(int*)(addr);
8010549d:	8b 45 08             	mov    0x8(%ebp),%eax
801054a0:	8b 10                	mov    (%eax),%edx
801054a2:	8b 45 0c             	mov    0xc(%ebp),%eax
801054a5:	89 10                	mov    %edx,(%eax)
  return 0;
801054a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
801054ac:	5d                   	pop    %ebp
801054ad:	c3                   	ret    

801054ae <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801054ae:	55                   	push   %ebp
801054af:	89 e5                	mov    %esp,%ebp
801054b1:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
801054b4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054ba:	8b 00                	mov    (%eax),%eax
801054bc:	3b 45 08             	cmp    0x8(%ebp),%eax
801054bf:	77 07                	ja     801054c8 <fetchstr+0x1a>
    return -1;
801054c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054c6:	eb 48                	jmp    80105510 <fetchstr+0x62>
  *pp = (char*)addr;
801054c8:	8b 55 08             	mov    0x8(%ebp),%edx
801054cb:	8b 45 0c             	mov    0xc(%ebp),%eax
801054ce:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
801054d0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054d6:	8b 00                	mov    (%eax),%eax
801054d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(s = *pp; s < ep; s++)
801054db:	8b 45 0c             	mov    0xc(%ebp),%eax
801054de:	8b 00                	mov    (%eax),%eax
801054e0:	89 45 f8             	mov    %eax,-0x8(%ebp)
801054e3:	eb 1e                	jmp    80105503 <fetchstr+0x55>
    if(*s == 0)
801054e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
801054e8:	0f b6 00             	movzbl (%eax),%eax
801054eb:	84 c0                	test   %al,%al
801054ed:	75 10                	jne    801054ff <fetchstr+0x51>
      return s - *pp;
801054ef:	8b 55 f8             	mov    -0x8(%ebp),%edx
801054f2:	8b 45 0c             	mov    0xc(%ebp),%eax
801054f5:	8b 00                	mov    (%eax),%eax
801054f7:	89 d1                	mov    %edx,%ecx
801054f9:	29 c1                	sub    %eax,%ecx
801054fb:	89 c8                	mov    %ecx,%eax
801054fd:	eb 11                	jmp    80105510 <fetchstr+0x62>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
801054ff:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105503:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105506:	3b 45 fc             	cmp    -0x4(%ebp),%eax
80105509:	72 da                	jb     801054e5 <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
8010550b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105510:	c9                   	leave  
80105511:	c3                   	ret    

80105512 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105512:	55                   	push   %ebp
80105513:	89 e5                	mov    %esp,%ebp
80105515:	83 ec 08             	sub    $0x8,%esp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80105518:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010551e:	8b 40 18             	mov    0x18(%eax),%eax
80105521:	8b 50 44             	mov    0x44(%eax),%edx
80105524:	8b 45 08             	mov    0x8(%ebp),%eax
80105527:	c1 e0 02             	shl    $0x2,%eax
8010552a:	8d 04 02             	lea    (%edx,%eax,1),%eax
8010552d:	8d 50 04             	lea    0x4(%eax),%edx
80105530:	8b 45 0c             	mov    0xc(%ebp),%eax
80105533:	89 44 24 04          	mov    %eax,0x4(%esp)
80105537:	89 14 24             	mov    %edx,(%esp)
8010553a:	e8 35 ff ff ff       	call   80105474 <fetchint>
}
8010553f:	c9                   	leave  
80105540:	c3                   	ret    

80105541 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105541:	55                   	push   %ebp
80105542:	89 e5                	mov    %esp,%ebp
80105544:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  if(argint(n, &i) < 0)
80105547:	8d 45 fc             	lea    -0x4(%ebp),%eax
8010554a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010554e:	8b 45 08             	mov    0x8(%ebp),%eax
80105551:	89 04 24             	mov    %eax,(%esp)
80105554:	e8 b9 ff ff ff       	call   80105512 <argint>
80105559:	85 c0                	test   %eax,%eax
8010555b:	79 07                	jns    80105564 <argptr+0x23>
    return -1;
8010555d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105562:	eb 3d                	jmp    801055a1 <argptr+0x60>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
80105564:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105567:	89 c2                	mov    %eax,%edx
80105569:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010556f:	8b 00                	mov    (%eax),%eax
80105571:	39 c2                	cmp    %eax,%edx
80105573:	73 16                	jae    8010558b <argptr+0x4a>
80105575:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105578:	89 c2                	mov    %eax,%edx
8010557a:	8b 45 10             	mov    0x10(%ebp),%eax
8010557d:	01 c2                	add    %eax,%edx
8010557f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105585:	8b 00                	mov    (%eax),%eax
80105587:	39 c2                	cmp    %eax,%edx
80105589:	76 07                	jbe    80105592 <argptr+0x51>
    return -1;
8010558b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105590:	eb 0f                	jmp    801055a1 <argptr+0x60>
  *pp = (char*)i;
80105592:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105595:	89 c2                	mov    %eax,%edx
80105597:	8b 45 0c             	mov    0xc(%ebp),%eax
8010559a:	89 10                	mov    %edx,(%eax)
  return 0;
8010559c:	b8 00 00 00 00       	mov    $0x0,%eax
}
801055a1:	c9                   	leave  
801055a2:	c3                   	ret    

801055a3 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801055a3:	55                   	push   %ebp
801055a4:	89 e5                	mov    %esp,%ebp
801055a6:	83 ec 18             	sub    $0x18,%esp
  int addr;
  if(argint(n, &addr) < 0)
801055a9:	8d 45 fc             	lea    -0x4(%ebp),%eax
801055ac:	89 44 24 04          	mov    %eax,0x4(%esp)
801055b0:	8b 45 08             	mov    0x8(%ebp),%eax
801055b3:	89 04 24             	mov    %eax,(%esp)
801055b6:	e8 57 ff ff ff       	call   80105512 <argint>
801055bb:	85 c0                	test   %eax,%eax
801055bd:	79 07                	jns    801055c6 <argstr+0x23>
    return -1;
801055bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055c4:	eb 12                	jmp    801055d8 <argstr+0x35>
  return fetchstr(addr, pp);
801055c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
801055c9:	8b 55 0c             	mov    0xc(%ebp),%edx
801055cc:	89 54 24 04          	mov    %edx,0x4(%esp)
801055d0:	89 04 24             	mov    %eax,(%esp)
801055d3:	e8 d6 fe ff ff       	call   801054ae <fetchstr>
}
801055d8:	c9                   	leave  
801055d9:	c3                   	ret    

801055da <syscall>:
[SYS_alarm]   sys_alarm,
};

void
syscall(void)
{
801055da:	55                   	push   %ebp
801055db:	89 e5                	mov    %esp,%ebp
801055dd:	53                   	push   %ebx
801055de:	83 ec 24             	sub    $0x24,%esp
  int num;

  num = proc->tf->eax;
801055e1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055e7:	8b 40 18             	mov    0x18(%eax),%eax
801055ea:	8b 40 1c             	mov    0x1c(%eax),%eax
801055ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801055f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801055f4:	7e 30                	jle    80105626 <syscall+0x4c>
801055f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055f9:	83 f8 18             	cmp    $0x18,%eax
801055fc:	77 28                	ja     80105626 <syscall+0x4c>
801055fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105601:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105608:	85 c0                	test   %eax,%eax
8010560a:	74 1a                	je     80105626 <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
8010560c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105612:	8b 58 18             	mov    0x18(%eax),%ebx
80105615:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105618:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
8010561f:	ff d0                	call   *%eax
80105621:	89 43 1c             	mov    %eax,0x1c(%ebx)
syscall(void)
{
  int num;

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105624:	eb 3d                	jmp    80105663 <syscall+0x89>
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
80105626:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
8010562c:	8d 48 6c             	lea    0x6c(%eax),%ecx
            proc->pid, proc->name, num);
8010562f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80105635:	8b 40 10             	mov    0x10(%eax),%eax
80105638:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010563b:	89 54 24 0c          	mov    %edx,0xc(%esp)
8010563f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105643:	89 44 24 04          	mov    %eax,0x4(%esp)
80105647:	c7 04 24 63 8d 10 80 	movl   $0x80108d63,(%esp)
8010564e:	e8 4a ad ff ff       	call   8010039d <cprintf>
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
80105653:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105659:	8b 40 18             	mov    0x18(%eax),%eax
8010565c:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105663:	83 c4 24             	add    $0x24,%esp
80105666:	5b                   	pop    %ebx
80105667:	5d                   	pop    %ebp
80105668:	c3                   	ret    
80105669:	00 00                	add    %al,(%eax)
	...

8010566c <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
8010566c:	55                   	push   %ebp
8010566d:	89 e5                	mov    %esp,%ebp
8010566f:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105672:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105675:	89 44 24 04          	mov    %eax,0x4(%esp)
80105679:	8b 45 08             	mov    0x8(%ebp),%eax
8010567c:	89 04 24             	mov    %eax,(%esp)
8010567f:	e8 8e fe ff ff       	call   80105512 <argint>
80105684:	85 c0                	test   %eax,%eax
80105686:	79 07                	jns    8010568f <argfd+0x23>
    return -1;
80105688:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010568d:	eb 50                	jmp    801056df <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
8010568f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105692:	85 c0                	test   %eax,%eax
80105694:	78 21                	js     801056b7 <argfd+0x4b>
80105696:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105699:	83 f8 0f             	cmp    $0xf,%eax
8010569c:	7f 19                	jg     801056b7 <argfd+0x4b>
8010569e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056a4:	8b 55 f0             	mov    -0x10(%ebp),%edx
801056a7:	83 c2 08             	add    $0x8,%edx
801056aa:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801056ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
801056b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801056b5:	75 07                	jne    801056be <argfd+0x52>
    return -1;
801056b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056bc:	eb 21                	jmp    801056df <argfd+0x73>
  if(pfd)
801056be:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801056c2:	74 08                	je     801056cc <argfd+0x60>
    *pfd = fd;
801056c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
801056c7:	8b 45 0c             	mov    0xc(%ebp),%eax
801056ca:	89 10                	mov    %edx,(%eax)
  if(pf)
801056cc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801056d0:	74 08                	je     801056da <argfd+0x6e>
    *pf = f;
801056d2:	8b 45 10             	mov    0x10(%ebp),%eax
801056d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801056d8:	89 10                	mov    %edx,(%eax)
  return 0;
801056da:	b8 00 00 00 00       	mov    $0x0,%eax
}
801056df:	c9                   	leave  
801056e0:	c3                   	ret    

801056e1 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
801056e1:	55                   	push   %ebp
801056e2:	89 e5                	mov    %esp,%ebp
801056e4:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801056e7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801056ee:	eb 30                	jmp    80105720 <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
801056f0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056f6:	8b 55 fc             	mov    -0x4(%ebp),%edx
801056f9:	83 c2 08             	add    $0x8,%edx
801056fc:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105700:	85 c0                	test   %eax,%eax
80105702:	75 18                	jne    8010571c <fdalloc+0x3b>
      proc->ofile[fd] = f;
80105704:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010570a:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010570d:	8d 4a 08             	lea    0x8(%edx),%ecx
80105710:	8b 55 08             	mov    0x8(%ebp),%edx
80105713:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105717:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010571a:	eb 0f                	jmp    8010572b <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
8010571c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105720:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80105724:	7e ca                	jle    801056f0 <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80105726:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010572b:	c9                   	leave  
8010572c:	c3                   	ret    

8010572d <sys_dup>:

int
sys_dup(void)
{
8010572d:	55                   	push   %ebp
8010572e:	89 e5                	mov    %esp,%ebp
80105730:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80105733:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105736:	89 44 24 08          	mov    %eax,0x8(%esp)
8010573a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105741:	00 
80105742:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105749:	e8 1e ff ff ff       	call   8010566c <argfd>
8010574e:	85 c0                	test   %eax,%eax
80105750:	79 07                	jns    80105759 <sys_dup+0x2c>
    return -1;
80105752:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105757:	eb 29                	jmp    80105782 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105759:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010575c:	89 04 24             	mov    %eax,(%esp)
8010575f:	e8 7d ff ff ff       	call   801056e1 <fdalloc>
80105764:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105767:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010576b:	79 07                	jns    80105774 <sys_dup+0x47>
    return -1;
8010576d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105772:	eb 0e                	jmp    80105782 <sys_dup+0x55>
  filedup(f);
80105774:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105777:	89 04 24             	mov    %eax,(%esp)
8010577a:	e8 2a b8 ff ff       	call   80100fa9 <filedup>
  return fd;
8010577f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105782:	c9                   	leave  
80105783:	c3                   	ret    

80105784 <sys_read>:

int
sys_read(void)
{
80105784:	55                   	push   %ebp
80105785:	89 e5                	mov    %esp,%ebp
80105787:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010578a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010578d:	89 44 24 08          	mov    %eax,0x8(%esp)
80105791:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105798:	00 
80105799:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801057a0:	e8 c7 fe ff ff       	call   8010566c <argfd>
801057a5:	85 c0                	test   %eax,%eax
801057a7:	78 35                	js     801057de <sys_read+0x5a>
801057a9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801057ac:	89 44 24 04          	mov    %eax,0x4(%esp)
801057b0:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801057b7:	e8 56 fd ff ff       	call   80105512 <argint>
801057bc:	85 c0                	test   %eax,%eax
801057be:	78 1e                	js     801057de <sys_read+0x5a>
801057c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057c3:	89 44 24 08          	mov    %eax,0x8(%esp)
801057c7:	8d 45 ec             	lea    -0x14(%ebp),%eax
801057ca:	89 44 24 04          	mov    %eax,0x4(%esp)
801057ce:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801057d5:	e8 67 fd ff ff       	call   80105541 <argptr>
801057da:	85 c0                	test   %eax,%eax
801057dc:	79 07                	jns    801057e5 <sys_read+0x61>
    return -1;
801057de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057e3:	eb 19                	jmp    801057fe <sys_read+0x7a>
  return fileread(f, p, n);
801057e5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801057e8:	8b 55 ec             	mov    -0x14(%ebp),%edx
801057eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057ee:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801057f2:	89 54 24 04          	mov    %edx,0x4(%esp)
801057f6:	89 04 24             	mov    %eax,(%esp)
801057f9:	e8 18 b9 ff ff       	call   80101116 <fileread>
}
801057fe:	c9                   	leave  
801057ff:	c3                   	ret    

80105800 <sys_write>:

int
sys_write(void)
{
80105800:	55                   	push   %ebp
80105801:	89 e5                	mov    %esp,%ebp
80105803:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105806:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105809:	89 44 24 08          	mov    %eax,0x8(%esp)
8010580d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105814:	00 
80105815:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010581c:	e8 4b fe ff ff       	call   8010566c <argfd>
80105821:	85 c0                	test   %eax,%eax
80105823:	78 35                	js     8010585a <sys_write+0x5a>
80105825:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105828:	89 44 24 04          	mov    %eax,0x4(%esp)
8010582c:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105833:	e8 da fc ff ff       	call   80105512 <argint>
80105838:	85 c0                	test   %eax,%eax
8010583a:	78 1e                	js     8010585a <sys_write+0x5a>
8010583c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010583f:	89 44 24 08          	mov    %eax,0x8(%esp)
80105843:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105846:	89 44 24 04          	mov    %eax,0x4(%esp)
8010584a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105851:	e8 eb fc ff ff       	call   80105541 <argptr>
80105856:	85 c0                	test   %eax,%eax
80105858:	79 07                	jns    80105861 <sys_write+0x61>
    return -1;
8010585a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010585f:	eb 19                	jmp    8010587a <sys_write+0x7a>
  return filewrite(f, p, n);
80105861:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105864:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105867:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010586a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010586e:	89 54 24 04          	mov    %edx,0x4(%esp)
80105872:	89 04 24             	mov    %eax,(%esp)
80105875:	e8 58 b9 ff ff       	call   801011d2 <filewrite>
}
8010587a:	c9                   	leave  
8010587b:	c3                   	ret    

8010587c <sys_close>:

int
sys_close(void)
{
8010587c:	55                   	push   %ebp
8010587d:	89 e5                	mov    %esp,%ebp
8010587f:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
80105882:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105885:	89 44 24 08          	mov    %eax,0x8(%esp)
80105889:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010588c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105890:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105897:	e8 d0 fd ff ff       	call   8010566c <argfd>
8010589c:	85 c0                	test   %eax,%eax
8010589e:	79 07                	jns    801058a7 <sys_close+0x2b>
    return -1;
801058a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058a5:	eb 24                	jmp    801058cb <sys_close+0x4f>
  proc->ofile[fd] = 0;
801058a7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801058ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
801058b0:	83 c2 08             	add    $0x8,%edx
801058b3:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801058ba:	00 
  fileclose(f);
801058bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058be:	89 04 24             	mov    %eax,(%esp)
801058c1:	e8 2b b7 ff ff       	call   80100ff1 <fileclose>
  return 0;
801058c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
801058cb:	c9                   	leave  
801058cc:	c3                   	ret    

801058cd <sys_fstat>:

int
sys_fstat(void)
{
801058cd:	55                   	push   %ebp
801058ce:	89 e5                	mov    %esp,%ebp
801058d0:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801058d3:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058d6:	89 44 24 08          	mov    %eax,0x8(%esp)
801058da:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801058e1:	00 
801058e2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801058e9:	e8 7e fd ff ff       	call   8010566c <argfd>
801058ee:	85 c0                	test   %eax,%eax
801058f0:	78 1f                	js     80105911 <sys_fstat+0x44>
801058f2:	8d 45 f0             	lea    -0x10(%ebp),%eax
801058f5:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
801058fc:	00 
801058fd:	89 44 24 04          	mov    %eax,0x4(%esp)
80105901:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105908:	e8 34 fc ff ff       	call   80105541 <argptr>
8010590d:	85 c0                	test   %eax,%eax
8010590f:	79 07                	jns    80105918 <sys_fstat+0x4b>
    return -1;
80105911:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105916:	eb 12                	jmp    8010592a <sys_fstat+0x5d>
  return filestat(f, st);
80105918:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010591b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010591e:	89 54 24 04          	mov    %edx,0x4(%esp)
80105922:	89 04 24             	mov    %eax,(%esp)
80105925:	e8 9d b7 ff ff       	call   801010c7 <filestat>
}
8010592a:	c9                   	leave  
8010592b:	c3                   	ret    

8010592c <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
8010592c:	55                   	push   %ebp
8010592d:	89 e5                	mov    %esp,%ebp
8010592f:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105932:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105935:	89 44 24 04          	mov    %eax,0x4(%esp)
80105939:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105940:	e8 5e fc ff ff       	call   801055a3 <argstr>
80105945:	85 c0                	test   %eax,%eax
80105947:	78 17                	js     80105960 <sys_link+0x34>
80105949:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010594c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105950:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105957:	e8 47 fc ff ff       	call   801055a3 <argstr>
8010595c:	85 c0                	test   %eax,%eax
8010595e:	79 0a                	jns    8010596a <sys_link+0x3e>
    return -1;
80105960:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105965:	e9 41 01 00 00       	jmp    80105aab <sys_link+0x17f>

  begin_op();
8010596a:	e8 87 db ff ff       	call   801034f6 <begin_op>
  if((ip = namei(old)) == 0){
8010596f:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105972:	89 04 24             	mov    %eax,(%esp)
80105975:	e8 35 cb ff ff       	call   801024af <namei>
8010597a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010597d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105981:	75 0f                	jne    80105992 <sys_link+0x66>
    end_op();
80105983:	e8 f0 db ff ff       	call   80103578 <end_op>
    return -1;
80105988:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010598d:	e9 19 01 00 00       	jmp    80105aab <sys_link+0x17f>
  }

  ilock(ip);
80105992:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105995:	89 04 24             	mov    %eax,(%esp)
80105998:	e8 64 bf ff ff       	call   80101901 <ilock>
  if(ip->type == T_DIR){
8010599d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059a0:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801059a4:	66 83 f8 01          	cmp    $0x1,%ax
801059a8:	75 1a                	jne    801059c4 <sys_link+0x98>
    iunlockput(ip);
801059aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059ad:	89 04 24             	mov    %eax,(%esp)
801059b0:	e8 d9 c1 ff ff       	call   80101b8e <iunlockput>
    end_op();
801059b5:	e8 be db ff ff       	call   80103578 <end_op>
    return -1;
801059ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059bf:	e9 e7 00 00 00       	jmp    80105aab <sys_link+0x17f>
  }

  ip->nlink++;
801059c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059c7:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801059cb:	8d 50 01             	lea    0x1(%eax),%edx
801059ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059d1:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
801059d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059d8:	89 04 24             	mov    %eax,(%esp)
801059db:	e8 5b bd ff ff       	call   8010173b <iupdate>
  iunlock(ip);
801059e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059e3:	89 04 24             	mov    %eax,(%esp)
801059e6:	e8 6d c0 ff ff       	call   80101a58 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
801059eb:	8b 45 dc             	mov    -0x24(%ebp),%eax
801059ee:	8d 55 e2             	lea    -0x1e(%ebp),%edx
801059f1:	89 54 24 04          	mov    %edx,0x4(%esp)
801059f5:	89 04 24             	mov    %eax,(%esp)
801059f8:	e8 d4 ca ff ff       	call   801024d1 <nameiparent>
801059fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105a00:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105a04:	74 68                	je     80105a6e <sys_link+0x142>
    goto bad;
  ilock(dp);
80105a06:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a09:	89 04 24             	mov    %eax,(%esp)
80105a0c:	e8 f0 be ff ff       	call   80101901 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105a11:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a14:	8b 10                	mov    (%eax),%edx
80105a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a19:	8b 00                	mov    (%eax),%eax
80105a1b:	39 c2                	cmp    %eax,%edx
80105a1d:	75 20                	jne    80105a3f <sys_link+0x113>
80105a1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a22:	8b 40 04             	mov    0x4(%eax),%eax
80105a25:	89 44 24 08          	mov    %eax,0x8(%esp)
80105a29:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105a2c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a30:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a33:	89 04 24             	mov    %eax,(%esp)
80105a36:	e8 b3 c7 ff ff       	call   801021ee <dirlink>
80105a3b:	85 c0                	test   %eax,%eax
80105a3d:	79 0d                	jns    80105a4c <sys_link+0x120>
    iunlockput(dp);
80105a3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a42:	89 04 24             	mov    %eax,(%esp)
80105a45:	e8 44 c1 ff ff       	call   80101b8e <iunlockput>
    goto bad;
80105a4a:	eb 23                	jmp    80105a6f <sys_link+0x143>
  }
  iunlockput(dp);
80105a4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a4f:	89 04 24             	mov    %eax,(%esp)
80105a52:	e8 37 c1 ff ff       	call   80101b8e <iunlockput>
  iput(ip);
80105a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a5a:	89 04 24             	mov    %eax,(%esp)
80105a5d:	e8 5b c0 ff ff       	call   80101abd <iput>

  end_op();
80105a62:	e8 11 db ff ff       	call   80103578 <end_op>

  return 0;
80105a67:	b8 00 00 00 00       	mov    $0x0,%eax
80105a6c:	eb 3d                	jmp    80105aab <sys_link+0x17f>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
80105a6e:	90                   	nop
  end_op();

  return 0;

bad:
  ilock(ip);
80105a6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a72:	89 04 24             	mov    %eax,(%esp)
80105a75:	e8 87 be ff ff       	call   80101901 <ilock>
  ip->nlink--;
80105a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a7d:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105a81:	8d 50 ff             	lea    -0x1(%eax),%edx
80105a84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a87:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105a8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a8e:	89 04 24             	mov    %eax,(%esp)
80105a91:	e8 a5 bc ff ff       	call   8010173b <iupdate>
  iunlockput(ip);
80105a96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a99:	89 04 24             	mov    %eax,(%esp)
80105a9c:	e8 ed c0 ff ff       	call   80101b8e <iunlockput>
  end_op();
80105aa1:	e8 d2 da ff ff       	call   80103578 <end_op>
  return -1;
80105aa6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105aab:	c9                   	leave  
80105aac:	c3                   	ret    

80105aad <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105aad:	55                   	push   %ebp
80105aae:	89 e5                	mov    %esp,%ebp
80105ab0:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105ab3:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105aba:	eb 4b                	jmp    80105b07 <isdirempty+0x5a>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105abc:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105abf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105ac2:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105ac9:	00 
80105aca:	89 54 24 08          	mov    %edx,0x8(%esp)
80105ace:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ad2:	8b 45 08             	mov    0x8(%ebp),%eax
80105ad5:	89 04 24             	mov    %eax,(%esp)
80105ad8:	e8 23 c3 ff ff       	call   80101e00 <readi>
80105add:	83 f8 10             	cmp    $0x10,%eax
80105ae0:	74 0c                	je     80105aee <isdirempty+0x41>
      panic("isdirempty: readi");
80105ae2:	c7 04 24 7f 8d 10 80 	movl   $0x80108d7f,(%esp)
80105ae9:	e8 4f aa ff ff       	call   8010053d <panic>
    if(de.inum != 0)
80105aee:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80105af2:	66 85 c0             	test   %ax,%ax
80105af5:	74 07                	je     80105afe <isdirempty+0x51>
      return 0;
80105af7:	b8 00 00 00 00       	mov    $0x0,%eax
80105afc:	eb 1b                	jmp    80105b19 <isdirempty+0x6c>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b01:	83 c0 10             	add    $0x10,%eax
80105b04:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105b07:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105b0a:	8b 45 08             	mov    0x8(%ebp),%eax
80105b0d:	8b 40 18             	mov    0x18(%eax),%eax
80105b10:	39 c2                	cmp    %eax,%edx
80105b12:	72 a8                	jb     80105abc <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80105b14:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105b19:	c9                   	leave  
80105b1a:	c3                   	ret    

80105b1b <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105b1b:	55                   	push   %ebp
80105b1c:	89 e5                	mov    %esp,%ebp
80105b1e:	83 ec 48             	sub    $0x48,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105b21:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105b24:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b28:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105b2f:	e8 6f fa ff ff       	call   801055a3 <argstr>
80105b34:	85 c0                	test   %eax,%eax
80105b36:	79 0a                	jns    80105b42 <sys_unlink+0x27>
    return -1;
80105b38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b3d:	e9 af 01 00 00       	jmp    80105cf1 <sys_unlink+0x1d6>

  begin_op();
80105b42:	e8 af d9 ff ff       	call   801034f6 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105b47:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105b4a:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105b4d:	89 54 24 04          	mov    %edx,0x4(%esp)
80105b51:	89 04 24             	mov    %eax,(%esp)
80105b54:	e8 78 c9 ff ff       	call   801024d1 <nameiparent>
80105b59:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105b5c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105b60:	75 0f                	jne    80105b71 <sys_unlink+0x56>
    end_op();
80105b62:	e8 11 da ff ff       	call   80103578 <end_op>
    return -1;
80105b67:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b6c:	e9 80 01 00 00       	jmp    80105cf1 <sys_unlink+0x1d6>
  }

  ilock(dp);
80105b71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b74:	89 04 24             	mov    %eax,(%esp)
80105b77:	e8 85 bd ff ff       	call   80101901 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105b7c:	c7 44 24 04 91 8d 10 	movl   $0x80108d91,0x4(%esp)
80105b83:	80 
80105b84:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105b87:	89 04 24             	mov    %eax,(%esp)
80105b8a:	e8 75 c5 ff ff       	call   80102104 <namecmp>
80105b8f:	85 c0                	test   %eax,%eax
80105b91:	0f 84 45 01 00 00    	je     80105cdc <sys_unlink+0x1c1>
80105b97:	c7 44 24 04 93 8d 10 	movl   $0x80108d93,0x4(%esp)
80105b9e:	80 
80105b9f:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105ba2:	89 04 24             	mov    %eax,(%esp)
80105ba5:	e8 5a c5 ff ff       	call   80102104 <namecmp>
80105baa:	85 c0                	test   %eax,%eax
80105bac:	0f 84 2a 01 00 00    	je     80105cdc <sys_unlink+0x1c1>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105bb2:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105bb5:	89 44 24 08          	mov    %eax,0x8(%esp)
80105bb9:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105bbc:	89 44 24 04          	mov    %eax,0x4(%esp)
80105bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bc3:	89 04 24             	mov    %eax,(%esp)
80105bc6:	e8 5b c5 ff ff       	call   80102126 <dirlookup>
80105bcb:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105bce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105bd2:	0f 84 03 01 00 00    	je     80105cdb <sys_unlink+0x1c0>
    goto bad;
  ilock(ip);
80105bd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bdb:	89 04 24             	mov    %eax,(%esp)
80105bde:	e8 1e bd ff ff       	call   80101901 <ilock>

  if(ip->nlink < 1)
80105be3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105be6:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105bea:	66 85 c0             	test   %ax,%ax
80105bed:	7f 0c                	jg     80105bfb <sys_unlink+0xe0>
    panic("unlink: nlink < 1");
80105bef:	c7 04 24 96 8d 10 80 	movl   $0x80108d96,(%esp)
80105bf6:	e8 42 a9 ff ff       	call   8010053d <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105bfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bfe:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105c02:	66 83 f8 01          	cmp    $0x1,%ax
80105c06:	75 1f                	jne    80105c27 <sys_unlink+0x10c>
80105c08:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c0b:	89 04 24             	mov    %eax,(%esp)
80105c0e:	e8 9a fe ff ff       	call   80105aad <isdirempty>
80105c13:	85 c0                	test   %eax,%eax
80105c15:	75 10                	jne    80105c27 <sys_unlink+0x10c>
    iunlockput(ip);
80105c17:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c1a:	89 04 24             	mov    %eax,(%esp)
80105c1d:	e8 6c bf ff ff       	call   80101b8e <iunlockput>
    goto bad;
80105c22:	e9 b5 00 00 00       	jmp    80105cdc <sys_unlink+0x1c1>
  }

  memset(&de, 0, sizeof(de));
80105c27:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80105c2e:	00 
80105c2f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105c36:	00 
80105c37:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105c3a:	89 04 24             	mov    %eax,(%esp)
80105c3d:	e8 74 f5 ff ff       	call   801051b6 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105c42:	8b 55 c8             	mov    -0x38(%ebp),%edx
80105c45:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105c48:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105c4f:	00 
80105c50:	89 54 24 08          	mov    %edx,0x8(%esp)
80105c54:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c58:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c5b:	89 04 24             	mov    %eax,(%esp)
80105c5e:	e8 09 c3 ff ff       	call   80101f6c <writei>
80105c63:	83 f8 10             	cmp    $0x10,%eax
80105c66:	74 0c                	je     80105c74 <sys_unlink+0x159>
    panic("unlink: writei");
80105c68:	c7 04 24 a8 8d 10 80 	movl   $0x80108da8,(%esp)
80105c6f:	e8 c9 a8 ff ff       	call   8010053d <panic>
  if(ip->type == T_DIR){
80105c74:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c77:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105c7b:	66 83 f8 01          	cmp    $0x1,%ax
80105c7f:	75 1c                	jne    80105c9d <sys_unlink+0x182>
    dp->nlink--;
80105c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c84:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105c88:	8d 50 ff             	lea    -0x1(%eax),%edx
80105c8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c8e:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80105c92:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c95:	89 04 24             	mov    %eax,(%esp)
80105c98:	e8 9e ba ff ff       	call   8010173b <iupdate>
  }
  iunlockput(dp);
80105c9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ca0:	89 04 24             	mov    %eax,(%esp)
80105ca3:	e8 e6 be ff ff       	call   80101b8e <iunlockput>

  ip->nlink--;
80105ca8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cab:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105caf:	8d 50 ff             	lea    -0x1(%eax),%edx
80105cb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cb5:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105cb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cbc:	89 04 24             	mov    %eax,(%esp)
80105cbf:	e8 77 ba ff ff       	call   8010173b <iupdate>
  iunlockput(ip);
80105cc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cc7:	89 04 24             	mov    %eax,(%esp)
80105cca:	e8 bf be ff ff       	call   80101b8e <iunlockput>

  end_op();
80105ccf:	e8 a4 d8 ff ff       	call   80103578 <end_op>

  return 0;
80105cd4:	b8 00 00 00 00       	mov    $0x0,%eax
80105cd9:	eb 16                	jmp    80105cf1 <sys_unlink+0x1d6>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
80105cdb:	90                   	nop
  end_op();

  return 0;

bad:
  iunlockput(dp);
80105cdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cdf:	89 04 24             	mov    %eax,(%esp)
80105ce2:	e8 a7 be ff ff       	call   80101b8e <iunlockput>
  end_op();
80105ce7:	e8 8c d8 ff ff       	call   80103578 <end_op>
  return -1;
80105cec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cf1:	c9                   	leave  
80105cf2:	c3                   	ret    

80105cf3 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80105cf3:	55                   	push   %ebp
80105cf4:	89 e5                	mov    %esp,%ebp
80105cf6:	83 ec 48             	sub    $0x48,%esp
80105cf9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105cfc:	8b 55 10             	mov    0x10(%ebp),%edx
80105cff:	8b 45 14             	mov    0x14(%ebp),%eax
80105d02:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80105d06:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80105d0a:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105d0e:	8d 45 de             	lea    -0x22(%ebp),%eax
80105d11:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d15:	8b 45 08             	mov    0x8(%ebp),%eax
80105d18:	89 04 24             	mov    %eax,(%esp)
80105d1b:	e8 b1 c7 ff ff       	call   801024d1 <nameiparent>
80105d20:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105d23:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d27:	75 0a                	jne    80105d33 <create+0x40>
    return 0;
80105d29:	b8 00 00 00 00       	mov    $0x0,%eax
80105d2e:	e9 7e 01 00 00       	jmp    80105eb1 <create+0x1be>
  ilock(dp);
80105d33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d36:	89 04 24             	mov    %eax,(%esp)
80105d39:	e8 c3 bb ff ff       	call   80101901 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80105d3e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105d41:	89 44 24 08          	mov    %eax,0x8(%esp)
80105d45:	8d 45 de             	lea    -0x22(%ebp),%eax
80105d48:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d4f:	89 04 24             	mov    %eax,(%esp)
80105d52:	e8 cf c3 ff ff       	call   80102126 <dirlookup>
80105d57:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105d5a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105d5e:	74 47                	je     80105da7 <create+0xb4>
    iunlockput(dp);
80105d60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d63:	89 04 24             	mov    %eax,(%esp)
80105d66:	e8 23 be ff ff       	call   80101b8e <iunlockput>
    ilock(ip);
80105d6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d6e:	89 04 24             	mov    %eax,(%esp)
80105d71:	e8 8b bb ff ff       	call   80101901 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105d76:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105d7b:	75 15                	jne    80105d92 <create+0x9f>
80105d7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d80:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105d84:	66 83 f8 02          	cmp    $0x2,%ax
80105d88:	75 08                	jne    80105d92 <create+0x9f>
      return ip;
80105d8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d8d:	e9 1f 01 00 00       	jmp    80105eb1 <create+0x1be>
    iunlockput(ip);
80105d92:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d95:	89 04 24             	mov    %eax,(%esp)
80105d98:	e8 f1 bd ff ff       	call   80101b8e <iunlockput>
    return 0;
80105d9d:	b8 00 00 00 00       	mov    $0x0,%eax
80105da2:	e9 0a 01 00 00       	jmp    80105eb1 <create+0x1be>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105da7:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80105dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dae:	8b 00                	mov    (%eax),%eax
80105db0:	89 54 24 04          	mov    %edx,0x4(%esp)
80105db4:	89 04 24             	mov    %eax,(%esp)
80105db7:	e8 ab b8 ff ff       	call   80101667 <ialloc>
80105dbc:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105dbf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105dc3:	75 0c                	jne    80105dd1 <create+0xde>
    panic("create: ialloc");
80105dc5:	c7 04 24 b7 8d 10 80 	movl   $0x80108db7,(%esp)
80105dcc:	e8 6c a7 ff ff       	call   8010053d <panic>

  ilock(ip);
80105dd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dd4:	89 04 24             	mov    %eax,(%esp)
80105dd7:	e8 25 bb ff ff       	call   80101901 <ilock>
  ip->major = major;
80105ddc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ddf:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80105de3:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
80105de7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dea:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80105dee:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
80105df2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105df5:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80105dfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dfe:	89 04 24             	mov    %eax,(%esp)
80105e01:	e8 35 b9 ff ff       	call   8010173b <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80105e06:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105e0b:	75 6a                	jne    80105e77 <create+0x184>
    dp->nlink++;  // for ".."
80105e0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e10:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105e14:	8d 50 01             	lea    0x1(%eax),%edx
80105e17:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e1a:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80105e1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e21:	89 04 24             	mov    %eax,(%esp)
80105e24:	e8 12 b9 ff ff       	call   8010173b <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105e29:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e2c:	8b 40 04             	mov    0x4(%eax),%eax
80105e2f:	89 44 24 08          	mov    %eax,0x8(%esp)
80105e33:	c7 44 24 04 91 8d 10 	movl   $0x80108d91,0x4(%esp)
80105e3a:	80 
80105e3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e3e:	89 04 24             	mov    %eax,(%esp)
80105e41:	e8 a8 c3 ff ff       	call   801021ee <dirlink>
80105e46:	85 c0                	test   %eax,%eax
80105e48:	78 21                	js     80105e6b <create+0x178>
80105e4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e4d:	8b 40 04             	mov    0x4(%eax),%eax
80105e50:	89 44 24 08          	mov    %eax,0x8(%esp)
80105e54:	c7 44 24 04 93 8d 10 	movl   $0x80108d93,0x4(%esp)
80105e5b:	80 
80105e5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e5f:	89 04 24             	mov    %eax,(%esp)
80105e62:	e8 87 c3 ff ff       	call   801021ee <dirlink>
80105e67:	85 c0                	test   %eax,%eax
80105e69:	79 0c                	jns    80105e77 <create+0x184>
      panic("create dots");
80105e6b:	c7 04 24 c6 8d 10 80 	movl   $0x80108dc6,(%esp)
80105e72:	e8 c6 a6 ff ff       	call   8010053d <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105e77:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e7a:	8b 40 04             	mov    0x4(%eax),%eax
80105e7d:	89 44 24 08          	mov    %eax,0x8(%esp)
80105e81:	8d 45 de             	lea    -0x22(%ebp),%eax
80105e84:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e8b:	89 04 24             	mov    %eax,(%esp)
80105e8e:	e8 5b c3 ff ff       	call   801021ee <dirlink>
80105e93:	85 c0                	test   %eax,%eax
80105e95:	79 0c                	jns    80105ea3 <create+0x1b0>
    panic("create: dirlink");
80105e97:	c7 04 24 d2 8d 10 80 	movl   $0x80108dd2,(%esp)
80105e9e:	e8 9a a6 ff ff       	call   8010053d <panic>

  iunlockput(dp);
80105ea3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ea6:	89 04 24             	mov    %eax,(%esp)
80105ea9:	e8 e0 bc ff ff       	call   80101b8e <iunlockput>

  return ip;
80105eae:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80105eb1:	c9                   	leave  
80105eb2:	c3                   	ret    

80105eb3 <sys_open>:

int
sys_open(void)
{
80105eb3:	55                   	push   %ebp
80105eb4:	89 e5                	mov    %esp,%ebp
80105eb6:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105eb9:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105ebc:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ec0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105ec7:	e8 d7 f6 ff ff       	call   801055a3 <argstr>
80105ecc:	85 c0                	test   %eax,%eax
80105ece:	78 17                	js     80105ee7 <sys_open+0x34>
80105ed0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105ed3:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ed7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105ede:	e8 2f f6 ff ff       	call   80105512 <argint>
80105ee3:	85 c0                	test   %eax,%eax
80105ee5:	79 0a                	jns    80105ef1 <sys_open+0x3e>
    return -1;
80105ee7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105eec:	e9 5a 01 00 00       	jmp    8010604b <sys_open+0x198>

  begin_op();
80105ef1:	e8 00 d6 ff ff       	call   801034f6 <begin_op>

  if(omode & O_CREATE){
80105ef6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105ef9:	25 00 02 00 00       	and    $0x200,%eax
80105efe:	85 c0                	test   %eax,%eax
80105f00:	74 3b                	je     80105f3d <sys_open+0x8a>
    ip = create(path, T_FILE, 0, 0);
80105f02:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105f05:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80105f0c:	00 
80105f0d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80105f14:	00 
80105f15:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80105f1c:	00 
80105f1d:	89 04 24             	mov    %eax,(%esp)
80105f20:	e8 ce fd ff ff       	call   80105cf3 <create>
80105f25:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
80105f28:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105f2c:	75 6b                	jne    80105f99 <sys_open+0xe6>
      end_op();
80105f2e:	e8 45 d6 ff ff       	call   80103578 <end_op>
      return -1;
80105f33:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f38:	e9 0e 01 00 00       	jmp    8010604b <sys_open+0x198>
    }
  } else {
    if((ip = namei(path)) == 0){
80105f3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105f40:	89 04 24             	mov    %eax,(%esp)
80105f43:	e8 67 c5 ff ff       	call   801024af <namei>
80105f48:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105f4b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105f4f:	75 0f                	jne    80105f60 <sys_open+0xad>
      end_op();
80105f51:	e8 22 d6 ff ff       	call   80103578 <end_op>
      return -1;
80105f56:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f5b:	e9 eb 00 00 00       	jmp    8010604b <sys_open+0x198>
    }
    ilock(ip);
80105f60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f63:	89 04 24             	mov    %eax,(%esp)
80105f66:	e8 96 b9 ff ff       	call   80101901 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105f6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f6e:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105f72:	66 83 f8 01          	cmp    $0x1,%ax
80105f76:	75 21                	jne    80105f99 <sys_open+0xe6>
80105f78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105f7b:	85 c0                	test   %eax,%eax
80105f7d:	74 1a                	je     80105f99 <sys_open+0xe6>
      iunlockput(ip);
80105f7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f82:	89 04 24             	mov    %eax,(%esp)
80105f85:	e8 04 bc ff ff       	call   80101b8e <iunlockput>
      end_op();
80105f8a:	e8 e9 d5 ff ff       	call   80103578 <end_op>
      return -1;
80105f8f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f94:	e9 b2 00 00 00       	jmp    8010604b <sys_open+0x198>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105f99:	e8 aa af ff ff       	call   80100f48 <filealloc>
80105f9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105fa1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105fa5:	74 14                	je     80105fbb <sys_open+0x108>
80105fa7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105faa:	89 04 24             	mov    %eax,(%esp)
80105fad:	e8 2f f7 ff ff       	call   801056e1 <fdalloc>
80105fb2:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105fb5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80105fb9:	79 28                	jns    80105fe3 <sys_open+0x130>
    if(f)
80105fbb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105fbf:	74 0b                	je     80105fcc <sys_open+0x119>
      fileclose(f);
80105fc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fc4:	89 04 24             	mov    %eax,(%esp)
80105fc7:	e8 25 b0 ff ff       	call   80100ff1 <fileclose>
    iunlockput(ip);
80105fcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fcf:	89 04 24             	mov    %eax,(%esp)
80105fd2:	e8 b7 bb ff ff       	call   80101b8e <iunlockput>
    end_op();
80105fd7:	e8 9c d5 ff ff       	call   80103578 <end_op>
    return -1;
80105fdc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fe1:	eb 68                	jmp    8010604b <sys_open+0x198>
  }
  iunlock(ip);
80105fe3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fe6:	89 04 24             	mov    %eax,(%esp)
80105fe9:	e8 6a ba ff ff       	call   80101a58 <iunlock>
  end_op();
80105fee:	e8 85 d5 ff ff       	call   80103578 <end_op>

  f->type = FD_INODE;
80105ff3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ff6:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80105ffc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fff:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106002:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80106005:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106008:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
8010600f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106012:	83 e0 01             	and    $0x1,%eax
80106015:	85 c0                	test   %eax,%eax
80106017:	0f 94 c2             	sete   %dl
8010601a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010601d:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106020:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106023:	83 e0 01             	and    $0x1,%eax
80106026:	84 c0                	test   %al,%al
80106028:	75 0a                	jne    80106034 <sys_open+0x181>
8010602a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010602d:	83 e0 02             	and    $0x2,%eax
80106030:	85 c0                	test   %eax,%eax
80106032:	74 07                	je     8010603b <sys_open+0x188>
80106034:	b8 01 00 00 00       	mov    $0x1,%eax
80106039:	eb 05                	jmp    80106040 <sys_open+0x18d>
8010603b:	b8 00 00 00 00       	mov    $0x0,%eax
80106040:	89 c2                	mov    %eax,%edx
80106042:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106045:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80106048:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
8010604b:	c9                   	leave  
8010604c:	c3                   	ret    

8010604d <sys_mkdir>:

int
sys_mkdir(void)
{
8010604d:	55                   	push   %ebp
8010604e:	89 e5                	mov    %esp,%ebp
80106050:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106053:	e8 9e d4 ff ff       	call   801034f6 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80106058:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010605b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010605f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106066:	e8 38 f5 ff ff       	call   801055a3 <argstr>
8010606b:	85 c0                	test   %eax,%eax
8010606d:	78 2c                	js     8010609b <sys_mkdir+0x4e>
8010606f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106072:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80106079:	00 
8010607a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106081:	00 
80106082:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80106089:	00 
8010608a:	89 04 24             	mov    %eax,(%esp)
8010608d:	e8 61 fc ff ff       	call   80105cf3 <create>
80106092:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106095:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106099:	75 0c                	jne    801060a7 <sys_mkdir+0x5a>
    end_op();
8010609b:	e8 d8 d4 ff ff       	call   80103578 <end_op>
    return -1;
801060a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060a5:	eb 15                	jmp    801060bc <sys_mkdir+0x6f>
  }
  iunlockput(ip);
801060a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060aa:	89 04 24             	mov    %eax,(%esp)
801060ad:	e8 dc ba ff ff       	call   80101b8e <iunlockput>
  end_op();
801060b2:	e8 c1 d4 ff ff       	call   80103578 <end_op>
  return 0;
801060b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
801060bc:	c9                   	leave  
801060bd:	c3                   	ret    

801060be <sys_mknod>:

int
sys_mknod(void)
{
801060be:	55                   	push   %ebp
801060bf:	89 e5                	mov    %esp,%ebp
801060c1:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
801060c4:	e8 2d d4 ff ff       	call   801034f6 <begin_op>
  if((len=argstr(0, &path)) < 0 ||
801060c9:	8d 45 ec             	lea    -0x14(%ebp),%eax
801060cc:	89 44 24 04          	mov    %eax,0x4(%esp)
801060d0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801060d7:	e8 c7 f4 ff ff       	call   801055a3 <argstr>
801060dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
801060df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801060e3:	78 5e                	js     80106143 <sys_mknod+0x85>
     argint(1, &major) < 0 ||
801060e5:	8d 45 e8             	lea    -0x18(%ebp),%eax
801060e8:	89 44 24 04          	mov    %eax,0x4(%esp)
801060ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801060f3:	e8 1a f4 ff ff       	call   80105512 <argint>
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
801060f8:	85 c0                	test   %eax,%eax
801060fa:	78 47                	js     80106143 <sys_mknod+0x85>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801060fc:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801060ff:	89 44 24 04          	mov    %eax,0x4(%esp)
80106103:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
8010610a:	e8 03 f4 ff ff       	call   80105512 <argint>
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
8010610f:	85 c0                	test   %eax,%eax
80106111:	78 30                	js     80106143 <sys_mknod+0x85>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80106113:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106116:	0f bf c8             	movswl %ax,%ecx
80106119:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010611c:	0f bf d0             	movswl %ax,%edx
8010611f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106122:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106126:	89 54 24 08          	mov    %edx,0x8(%esp)
8010612a:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80106131:	00 
80106132:	89 04 24             	mov    %eax,(%esp)
80106135:	e8 b9 fb ff ff       	call   80105cf3 <create>
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
8010613a:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010613d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106141:	75 0c                	jne    8010614f <sys_mknod+0x91>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80106143:	e8 30 d4 ff ff       	call   80103578 <end_op>
    return -1;
80106148:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010614d:	eb 15                	jmp    80106164 <sys_mknod+0xa6>
  }
  iunlockput(ip);
8010614f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106152:	89 04 24             	mov    %eax,(%esp)
80106155:	e8 34 ba ff ff       	call   80101b8e <iunlockput>
  end_op();
8010615a:	e8 19 d4 ff ff       	call   80103578 <end_op>
  return 0;
8010615f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106164:	c9                   	leave  
80106165:	c3                   	ret    

80106166 <sys_chdir>:

int
sys_chdir(void)
{
80106166:	55                   	push   %ebp
80106167:	89 e5                	mov    %esp,%ebp
80106169:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
8010616c:	e8 85 d3 ff ff       	call   801034f6 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106171:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106174:	89 44 24 04          	mov    %eax,0x4(%esp)
80106178:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010617f:	e8 1f f4 ff ff       	call   801055a3 <argstr>
80106184:	85 c0                	test   %eax,%eax
80106186:	78 14                	js     8010619c <sys_chdir+0x36>
80106188:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010618b:	89 04 24             	mov    %eax,(%esp)
8010618e:	e8 1c c3 ff ff       	call   801024af <namei>
80106193:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106196:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010619a:	75 0c                	jne    801061a8 <sys_chdir+0x42>
    end_op();
8010619c:	e8 d7 d3 ff ff       	call   80103578 <end_op>
    return -1;
801061a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061a6:	eb 61                	jmp    80106209 <sys_chdir+0xa3>
  }
  ilock(ip);
801061a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061ab:	89 04 24             	mov    %eax,(%esp)
801061ae:	e8 4e b7 ff ff       	call   80101901 <ilock>
  if(ip->type != T_DIR){
801061b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061b6:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801061ba:	66 83 f8 01          	cmp    $0x1,%ax
801061be:	74 17                	je     801061d7 <sys_chdir+0x71>
    iunlockput(ip);
801061c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061c3:	89 04 24             	mov    %eax,(%esp)
801061c6:	e8 c3 b9 ff ff       	call   80101b8e <iunlockput>
    end_op();
801061cb:	e8 a8 d3 ff ff       	call   80103578 <end_op>
    return -1;
801061d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061d5:	eb 32                	jmp    80106209 <sys_chdir+0xa3>
  }
  iunlock(ip);
801061d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061da:	89 04 24             	mov    %eax,(%esp)
801061dd:	e8 76 b8 ff ff       	call   80101a58 <iunlock>
  iput(proc->cwd);
801061e2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801061e8:	8b 40 68             	mov    0x68(%eax),%eax
801061eb:	89 04 24             	mov    %eax,(%esp)
801061ee:	e8 ca b8 ff ff       	call   80101abd <iput>
  end_op();
801061f3:	e8 80 d3 ff ff       	call   80103578 <end_op>
  proc->cwd = ip;
801061f8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801061fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106201:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80106204:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106209:	c9                   	leave  
8010620a:	c3                   	ret    

8010620b <sys_exec>:

int
sys_exec(void)
{
8010620b:	55                   	push   %ebp
8010620c:	89 e5                	mov    %esp,%ebp
8010620e:	81 ec a8 00 00 00    	sub    $0xa8,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106214:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106217:	89 44 24 04          	mov    %eax,0x4(%esp)
8010621b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106222:	e8 7c f3 ff ff       	call   801055a3 <argstr>
80106227:	85 c0                	test   %eax,%eax
80106229:	78 1a                	js     80106245 <sys_exec+0x3a>
8010622b:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80106231:	89 44 24 04          	mov    %eax,0x4(%esp)
80106235:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010623c:	e8 d1 f2 ff ff       	call   80105512 <argint>
80106241:	85 c0                	test   %eax,%eax
80106243:	79 0a                	jns    8010624f <sys_exec+0x44>
    return -1;
80106245:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010624a:	e9 cd 00 00 00       	jmp    8010631c <sys_exec+0x111>
  }
  memset(argv, 0, sizeof(argv));
8010624f:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80106256:	00 
80106257:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010625e:	00 
8010625f:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106265:	89 04 24             	mov    %eax,(%esp)
80106268:	e8 49 ef ff ff       	call   801051b6 <memset>
  for(i=0;; i++){
8010626d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80106274:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106277:	83 f8 1f             	cmp    $0x1f,%eax
8010627a:	76 0a                	jbe    80106286 <sys_exec+0x7b>
      return -1;
8010627c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106281:	e9 96 00 00 00       	jmp    8010631c <sys_exec+0x111>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106286:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
8010628c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010628f:	c1 e2 02             	shl    $0x2,%edx
80106292:	89 d1                	mov    %edx,%ecx
80106294:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
8010629a:	8d 14 11             	lea    (%ecx,%edx,1),%edx
8010629d:	89 44 24 04          	mov    %eax,0x4(%esp)
801062a1:	89 14 24             	mov    %edx,(%esp)
801062a4:	e8 cb f1 ff ff       	call   80105474 <fetchint>
801062a9:	85 c0                	test   %eax,%eax
801062ab:	79 07                	jns    801062b4 <sys_exec+0xa9>
      return -1;
801062ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062b2:	eb 68                	jmp    8010631c <sys_exec+0x111>
    if(uarg == 0){
801062b4:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801062ba:	85 c0                	test   %eax,%eax
801062bc:	75 26                	jne    801062e4 <sys_exec+0xd9>
      argv[i] = 0;
801062be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062c1:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
801062c8:	00 00 00 00 
      break;
801062cc:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801062cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062d0:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
801062d6:	89 54 24 04          	mov    %edx,0x4(%esp)
801062da:	89 04 24             	mov    %eax,(%esp)
801062dd:	e8 32 a8 ff ff       	call   80100b14 <exec>
801062e2:	eb 38                	jmp    8010631c <sys_exec+0x111>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801062e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062e7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801062ee:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801062f4:	01 d0                	add    %edx,%eax
801062f6:	8b 95 68 ff ff ff    	mov    -0x98(%ebp),%edx
801062fc:	89 44 24 04          	mov    %eax,0x4(%esp)
80106300:	89 14 24             	mov    %edx,(%esp)
80106303:	e8 a6 f1 ff ff       	call   801054ae <fetchstr>
80106308:	85 c0                	test   %eax,%eax
8010630a:	79 07                	jns    80106313 <sys_exec+0x108>
      return -1;
8010630c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106311:	eb 09                	jmp    8010631c <sys_exec+0x111>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80106313:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
80106317:	e9 58 ff ff ff       	jmp    80106274 <sys_exec+0x69>
  return exec(path, argv);
}
8010631c:	c9                   	leave  
8010631d:	c3                   	ret    

8010631e <sys_pipe>:

int
sys_pipe(void)
{
8010631e:	55                   	push   %ebp
8010631f:	89 e5                	mov    %esp,%ebp
80106321:	83 ec 38             	sub    $0x38,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106324:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106327:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
8010632e:	00 
8010632f:	89 44 24 04          	mov    %eax,0x4(%esp)
80106333:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010633a:	e8 02 f2 ff ff       	call   80105541 <argptr>
8010633f:	85 c0                	test   %eax,%eax
80106341:	79 0a                	jns    8010634d <sys_pipe+0x2f>
    return -1;
80106343:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106348:	e9 9b 00 00 00       	jmp    801063e8 <sys_pipe+0xca>
  if(pipealloc(&rf, &wf) < 0)
8010634d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106350:	89 44 24 04          	mov    %eax,0x4(%esp)
80106354:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106357:	89 04 24             	mov    %eax,(%esp)
8010635a:	e8 ad dc ff ff       	call   8010400c <pipealloc>
8010635f:	85 c0                	test   %eax,%eax
80106361:	79 07                	jns    8010636a <sys_pipe+0x4c>
    return -1;
80106363:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106368:	eb 7e                	jmp    801063e8 <sys_pipe+0xca>
  fd0 = -1;
8010636a:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106371:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106374:	89 04 24             	mov    %eax,(%esp)
80106377:	e8 65 f3 ff ff       	call   801056e1 <fdalloc>
8010637c:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010637f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106383:	78 14                	js     80106399 <sys_pipe+0x7b>
80106385:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106388:	89 04 24             	mov    %eax,(%esp)
8010638b:	e8 51 f3 ff ff       	call   801056e1 <fdalloc>
80106390:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106393:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106397:	79 37                	jns    801063d0 <sys_pipe+0xb2>
    if(fd0 >= 0)
80106399:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010639d:	78 14                	js     801063b3 <sys_pipe+0x95>
      proc->ofile[fd0] = 0;
8010639f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801063a5:	8b 55 f0             	mov    -0x10(%ebp),%edx
801063a8:	83 c2 08             	add    $0x8,%edx
801063ab:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801063b2:	00 
    fileclose(rf);
801063b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
801063b6:	89 04 24             	mov    %eax,(%esp)
801063b9:	e8 33 ac ff ff       	call   80100ff1 <fileclose>
    fileclose(wf);
801063be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801063c1:	89 04 24             	mov    %eax,(%esp)
801063c4:	e8 28 ac ff ff       	call   80100ff1 <fileclose>
    return -1;
801063c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063ce:	eb 18                	jmp    801063e8 <sys_pipe+0xca>
  }
  fd[0] = fd0;
801063d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801063d3:	8b 55 f0             	mov    -0x10(%ebp),%edx
801063d6:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
801063d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801063db:	8d 50 04             	lea    0x4(%eax),%edx
801063de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063e1:	89 02                	mov    %eax,(%edx)
  return 0;
801063e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801063e8:	c9                   	leave  
801063e9:	c3                   	ret    
	...

801063ec <outw>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outw(ushort port, ushort data)
{
801063ec:	55                   	push   %ebp
801063ed:	89 e5                	mov    %esp,%ebp
801063ef:	83 ec 08             	sub    $0x8,%esp
801063f2:	8b 55 08             	mov    0x8(%ebp),%edx
801063f5:	8b 45 0c             	mov    0xc(%ebp),%eax
801063f8:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801063fc:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106400:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
80106404:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106408:	66 ef                	out    %ax,(%dx)
}
8010640a:	c9                   	leave  
8010640b:	c3                   	ret    

8010640c <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
8010640c:	55                   	push   %ebp
8010640d:	89 e5                	mov    %esp,%ebp
8010640f:	83 ec 08             	sub    $0x8,%esp
  return fork();
80106412:	e8 f9 e2 ff ff       	call   80104710 <fork>
}
80106417:	c9                   	leave  
80106418:	c3                   	ret    

80106419 <sys_exit>:

int
sys_exit(void)
{
80106419:	55                   	push   %ebp
8010641a:	89 e5                	mov    %esp,%ebp
8010641c:	83 ec 08             	sub    $0x8,%esp
  exit();
8010641f:	e8 67 e4 ff ff       	call   8010488b <exit>
  return 0;  // not reached
80106424:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106429:	c9                   	leave  
8010642a:	c3                   	ret    

8010642b <sys_wait>:

int
sys_wait(void)
{
8010642b:	55                   	push   %ebp
8010642c:	89 e5                	mov    %esp,%ebp
8010642e:	83 ec 08             	sub    $0x8,%esp
  return wait();
80106431:	e8 7b e5 ff ff       	call   801049b1 <wait>
}
80106436:	c9                   	leave  
80106437:	c3                   	ret    

80106438 <sys_kill>:

int
sys_kill(void)
{
80106438:	55                   	push   %ebp
80106439:	89 e5                	mov    %esp,%ebp
8010643b:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010643e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106441:	89 44 24 04          	mov    %eax,0x4(%esp)
80106445:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010644c:	e8 c1 f0 ff ff       	call   80105512 <argint>
80106451:	85 c0                	test   %eax,%eax
80106453:	79 07                	jns    8010645c <sys_kill+0x24>
    return -1;
80106455:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010645a:	eb 0b                	jmp    80106467 <sys_kill+0x2f>
  return kill(pid);
8010645c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010645f:	89 04 24             	mov    %eax,(%esp)
80106462:	e8 25 e9 ff ff       	call   80104d8c <kill>
}
80106467:	c9                   	leave  
80106468:	c3                   	ret    

80106469 <sys_getpid>:

int
sys_getpid(void)
{
80106469:	55                   	push   %ebp
8010646a:	89 e5                	mov    %esp,%ebp
  return proc->pid;
8010646c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106472:	8b 40 10             	mov    0x10(%eax),%eax
}
80106475:	5d                   	pop    %ebp
80106476:	c3                   	ret    

80106477 <sys_sbrk>:

int
sys_sbrk(void)
{
80106477:	55                   	push   %ebp
80106478:	89 e5                	mov    %esp,%ebp
8010647a:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
8010647d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106480:	89 44 24 04          	mov    %eax,0x4(%esp)
80106484:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010648b:	e8 82 f0 ff ff       	call   80105512 <argint>
80106490:	85 c0                	test   %eax,%eax
80106492:	79 07                	jns    8010649b <sys_sbrk+0x24>
    return -1;
80106494:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106499:	eb 24                	jmp    801064bf <sys_sbrk+0x48>
  addr = proc->sz;
8010649b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801064a1:	8b 00                	mov    (%eax),%eax
801064a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
801064a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064a9:	89 04 24             	mov    %eax,(%esp)
801064ac:	e8 ba e1 ff ff       	call   8010466b <growproc>
801064b1:	85 c0                	test   %eax,%eax
801064b3:	79 07                	jns    801064bc <sys_sbrk+0x45>
    return -1;
801064b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064ba:	eb 03                	jmp    801064bf <sys_sbrk+0x48>
  return addr;
801064bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801064bf:	c9                   	leave  
801064c0:	c3                   	ret    

801064c1 <sys_sleep>:

int
sys_sleep(void)
{
801064c1:	55                   	push   %ebp
801064c2:	89 e5                	mov    %esp,%ebp
801064c4:	83 ec 28             	sub    $0x28,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
801064c7:	8d 45 f0             	lea    -0x10(%ebp),%eax
801064ca:	89 44 24 04          	mov    %eax,0x4(%esp)
801064ce:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801064d5:	e8 38 f0 ff ff       	call   80105512 <argint>
801064da:	85 c0                	test   %eax,%eax
801064dc:	79 07                	jns    801064e5 <sys_sleep+0x24>
    return -1;
801064de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064e3:	eb 6c                	jmp    80106551 <sys_sleep+0x90>
  acquire(&tickslock);
801064e5:	c7 04 24 c0 7b 11 80 	movl   $0x80117bc0,(%esp)
801064ec:	e8 6e ea ff ff       	call   80104f5f <acquire>
  ticks0 = ticks;
801064f1:	a1 00 84 11 80       	mov    0x80118400,%eax
801064f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
801064f9:	eb 34                	jmp    8010652f <sys_sleep+0x6e>
    if(proc->killed){
801064fb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106501:	8b 40 24             	mov    0x24(%eax),%eax
80106504:	85 c0                	test   %eax,%eax
80106506:	74 13                	je     8010651b <sys_sleep+0x5a>
      release(&tickslock);
80106508:	c7 04 24 c0 7b 11 80 	movl   $0x80117bc0,(%esp)
8010650f:	e8 ac ea ff ff       	call   80104fc0 <release>
      return -1;
80106514:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106519:	eb 36                	jmp    80106551 <sys_sleep+0x90>
    }
    sleep(&ticks, &tickslock);
8010651b:	c7 44 24 04 c0 7b 11 	movl   $0x80117bc0,0x4(%esp)
80106522:	80 
80106523:	c7 04 24 00 84 11 80 	movl   $0x80118400,(%esp)
8010652a:	e8 55 e7 ff ff       	call   80104c84 <sleep>
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010652f:	a1 00 84 11 80       	mov    0x80118400,%eax
80106534:	89 c2                	mov    %eax,%edx
80106536:	2b 55 f4             	sub    -0xc(%ebp),%edx
80106539:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010653c:	39 c2                	cmp    %eax,%edx
8010653e:	72 bb                	jb     801064fb <sys_sleep+0x3a>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80106540:	c7 04 24 c0 7b 11 80 	movl   $0x80117bc0,(%esp)
80106547:	e8 74 ea ff ff       	call   80104fc0 <release>
  return 0;
8010654c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106551:	c9                   	leave  
80106552:	c3                   	ret    

80106553 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106553:	55                   	push   %ebp
80106554:	89 e5                	mov    %esp,%ebp
80106556:	83 ec 28             	sub    $0x28,%esp
  uint xticks;
  
  acquire(&tickslock);
80106559:	c7 04 24 c0 7b 11 80 	movl   $0x80117bc0,(%esp)
80106560:	e8 fa e9 ff ff       	call   80104f5f <acquire>
  xticks = ticks;
80106565:	a1 00 84 11 80       	mov    0x80118400,%eax
8010656a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
8010656d:	c7 04 24 c0 7b 11 80 	movl   $0x80117bc0,(%esp)
80106574:	e8 47 ea ff ff       	call   80104fc0 <release>
  return xticks;
80106579:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010657c:	c9                   	leave  
8010657d:	c3                   	ret    

8010657e <sys_halt>:
// signal to QEMU.
// Based on: http://pdos.csail.mit.edu/6.828/2012/homework/xv6-syscall.html
// and: https://github.com/t3rm1n4l/pintos/blob/master/devices/shutdown.c
int
sys_halt(void)
{
8010657e:	55                   	push   %ebp
8010657f:	89 e5                	mov    %esp,%ebp
80106581:	83 ec 18             	sub    $0x18,%esp
  char *p = "Shutdown";
80106584:	c7 45 fc e2 8d 10 80 	movl   $0x80108de2,-0x4(%ebp)
  for( ; *p; p++)
8010658b:	eb 18                	jmp    801065a5 <sys_halt+0x27>
    outw(0xB004, 0x2000);
8010658d:	c7 44 24 04 00 20 00 	movl   $0x2000,0x4(%esp)
80106594:	00 
80106595:	c7 04 24 04 b0 00 00 	movl   $0xb004,(%esp)
8010659c:	e8 4b fe ff ff       	call   801063ec <outw>
// and: https://github.com/t3rm1n4l/pintos/blob/master/devices/shutdown.c
int
sys_halt(void)
{
  char *p = "Shutdown";
  for( ; *p; p++)
801065a1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801065a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
801065a8:	0f b6 00             	movzbl (%eax),%eax
801065ab:	84 c0                	test   %al,%al
801065ad:	75 de                	jne    8010658d <sys_halt+0xf>
    outw(0xB004, 0x2000);
  return 0;
801065af:	b8 00 00 00 00       	mov    $0x0,%eax
}
801065b4:	c9                   	leave  
801065b5:	c3                   	ret    

801065b6 <sys_register_signal_handler>:


int sys_register_signal_handler(void)
{
801065b6:	55                   	push   %ebp
801065b7:	89 e5                	mov    %esp,%ebp
801065b9:	83 ec 28             	sub    $0x28,%esp

  int signum; // The number that represents the signal
  int sighandler; // The number that represents the handler
  int trampoline;// This represents the trampoline function

  if(argint(0, &signum) < 0) return -1; // Get the first argument
801065bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
801065bf:	89 44 24 04          	mov    %eax,0x4(%esp)
801065c3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801065ca:	e8 43 ef ff ff       	call   80105512 <argint>
801065cf:	85 c0                	test   %eax,%eax
801065d1:	79 07                	jns    801065da <sys_register_signal_handler+0x24>
801065d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065d8:	eb 61                	jmp    8010663b <sys_register_signal_handler+0x85>
  if(argint(1, &sighandler) < 0) return -1; // Get the second argument
801065da:	8d 45 f0             	lea    -0x10(%ebp),%eax
801065dd:	89 44 24 04          	mov    %eax,0x4(%esp)
801065e1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801065e8:	e8 25 ef ff ff       	call   80105512 <argint>
801065ed:	85 c0                	test   %eax,%eax
801065ef:	79 07                	jns    801065f8 <sys_register_signal_handler+0x42>
801065f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065f6:	eb 43                	jmp    8010663b <sys_register_signal_handler+0x85>
  if(argint(2, &trampoline) < 0) return -1; // Get the third argument
801065f8:	8d 45 ec             	lea    -0x14(%ebp),%eax
801065fb:	89 44 24 04          	mov    %eax,0x4(%esp)
801065ff:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80106606:	e8 07 ef ff ff       	call   80105512 <argint>
8010660b:	85 c0                	test   %eax,%eax
8010660d:	79 07                	jns    80106616 <sys_register_signal_handler+0x60>
8010660f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106614:	eb 25                	jmp    8010663b <sys_register_signal_handler+0x85>

  proc->handlers[signum] = sighandler; // Set the handler for the specific signal
80106616:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010661c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010661f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106622:	83 c1 1c             	add    $0x1c,%ecx
80106625:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
  proc->trampoline = trampoline;
80106629:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010662f:	8b 55 ec             	mov    -0x14(%ebp),%edx
80106632:	89 90 04 01 00 00    	mov    %edx,0x104(%eax)

  return sighandler; // Return the signal handler
80106638:	8b 45 f0             	mov    -0x10(%ebp),%eax

  //return 0;
}
8010663b:	c9                   	leave  
8010663c:	c3                   	ret    

8010663d <sys_alarm>:

int sys_alarm(void)
{
8010663d:	55                   	push   %ebp
8010663e:	89 e5                	mov    %esp,%ebp
80106640:	83 ec 28             	sub    $0x28,%esp

  int seconds; // THe number of seconds for the timer
  if(argint(0, &seconds) < 0) return -1; // Get the first argument
80106643:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106646:	89 44 24 04          	mov    %eax,0x4(%esp)
8010664a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106651:	e8 bc ee ff ff       	call   80105512 <argint>
80106656:	85 c0                	test   %eax,%eax
80106658:	79 07                	jns    80106661 <sys_alarm+0x24>
8010665a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010665f:	eb 24                	jmp    80106685 <sys_alarm+0x48>

  proc->numberOfTicks = seconds; // Get the number of seconds and put it in the proc
80106661:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106667:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010666a:	89 90 00 01 00 00    	mov    %edx,0x100(%eax)
  proc->alarmState = 0; // Set the alarm state to needed, but off
80106670:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106676:	c7 80 fc 00 00 00 00 	movl   $0x0,0xfc(%eax)
8010667d:	00 00 00 
  
  return 0;
80106680:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106685:	c9                   	leave  
80106686:	c3                   	ret    
	...

80106688 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106688:	55                   	push   %ebp
80106689:	89 e5                	mov    %esp,%ebp
8010668b:	83 ec 08             	sub    $0x8,%esp
8010668e:	8b 55 08             	mov    0x8(%ebp),%edx
80106691:	8b 45 0c             	mov    0xc(%ebp),%eax
80106694:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106698:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010669b:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010669f:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801066a3:	ee                   	out    %al,(%dx)
}
801066a4:	c9                   	leave  
801066a5:	c3                   	ret    

801066a6 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
801066a6:	55                   	push   %ebp
801066a7:	89 e5                	mov    %esp,%ebp
801066a9:	83 ec 18             	sub    $0x18,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
801066ac:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
801066b3:	00 
801066b4:	c7 04 24 43 00 00 00 	movl   $0x43,(%esp)
801066bb:	e8 c8 ff ff ff       	call   80106688 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
801066c0:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
801066c7:	00 
801066c8:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
801066cf:	e8 b4 ff ff ff       	call   80106688 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
801066d4:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
801066db:	00 
801066dc:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
801066e3:	e8 a0 ff ff ff       	call   80106688 <outb>
  picenable(IRQ_TIMER);
801066e8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801066ef:	e8 a1 d7 ff ff       	call   80103e95 <picenable>
}
801066f4:	c9                   	leave  
801066f5:	c3                   	ret    
	...

801066f8 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801066f8:	1e                   	push   %ds
  pushl %es
801066f9:	06                   	push   %es
  pushl %fs
801066fa:	0f a0                	push   %fs
  pushl %gs
801066fc:	0f a8                	push   %gs
  pushal
801066fe:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
801066ff:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106703:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106705:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80106707:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
8010670b:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
8010670d:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
8010670f:	54                   	push   %esp
  call trap
80106710:	e8 d5 01 00 00       	call   801068ea <trap>
  addl $4, %esp
80106715:	83 c4 04             	add    $0x4,%esp

80106718 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106718:	61                   	popa   
  popl %gs
80106719:	0f a9                	pop    %gs
  popl %fs
8010671b:	0f a1                	pop    %fs
  popl %es
8010671d:	07                   	pop    %es
  popl %ds
8010671e:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010671f:	83 c4 08             	add    $0x8,%esp
  iret
80106722:	cf                   	iret   
	...

80106724 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80106724:	55                   	push   %ebp
80106725:	89 e5                	mov    %esp,%ebp
80106727:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
8010672a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010672d:	83 e8 01             	sub    $0x1,%eax
80106730:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106734:	8b 45 08             	mov    0x8(%ebp),%eax
80106737:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010673b:	8b 45 08             	mov    0x8(%ebp),%eax
8010673e:	c1 e8 10             	shr    $0x10,%eax
80106741:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80106745:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106748:	0f 01 18             	lidtl  (%eax)
}
8010674b:	c9                   	leave  
8010674c:	c3                   	ret    

8010674d <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
8010674d:	55                   	push   %ebp
8010674e:	89 e5                	mov    %esp,%ebp
80106750:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106753:	0f 20 d0             	mov    %cr2,%eax
80106756:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80106759:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010675c:	c9                   	leave  
8010675d:	c3                   	ret    

8010675e <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
8010675e:	55                   	push   %ebp
8010675f:	89 e5                	mov    %esp,%ebp
80106761:	83 ec 28             	sub    $0x28,%esp
  int i;

  for(i = 0; i < 256; i++)
80106764:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010676b:	e9 bf 00 00 00       	jmp    8010682f <tvinit+0xd1>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106770:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106773:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106776:	8b 14 95 a4 c0 10 80 	mov    -0x7fef3f5c(,%edx,4),%edx
8010677d:	66 89 14 c5 00 7c 11 	mov    %dx,-0x7fee8400(,%eax,8)
80106784:	80 
80106785:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106788:	66 c7 04 c5 02 7c 11 	movw   $0x8,-0x7fee83fe(,%eax,8)
8010678f:	80 08 00 
80106792:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106795:	0f b6 14 c5 04 7c 11 	movzbl -0x7fee83fc(,%eax,8),%edx
8010679c:	80 
8010679d:	83 e2 e0             	and    $0xffffffe0,%edx
801067a0:	88 14 c5 04 7c 11 80 	mov    %dl,-0x7fee83fc(,%eax,8)
801067a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067aa:	0f b6 14 c5 04 7c 11 	movzbl -0x7fee83fc(,%eax,8),%edx
801067b1:	80 
801067b2:	83 e2 1f             	and    $0x1f,%edx
801067b5:	88 14 c5 04 7c 11 80 	mov    %dl,-0x7fee83fc(,%eax,8)
801067bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067bf:	0f b6 14 c5 05 7c 11 	movzbl -0x7fee83fb(,%eax,8),%edx
801067c6:	80 
801067c7:	83 e2 f0             	and    $0xfffffff0,%edx
801067ca:	83 ca 0e             	or     $0xe,%edx
801067cd:	88 14 c5 05 7c 11 80 	mov    %dl,-0x7fee83fb(,%eax,8)
801067d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067d7:	0f b6 14 c5 05 7c 11 	movzbl -0x7fee83fb(,%eax,8),%edx
801067de:	80 
801067df:	83 e2 ef             	and    $0xffffffef,%edx
801067e2:	88 14 c5 05 7c 11 80 	mov    %dl,-0x7fee83fb(,%eax,8)
801067e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067ec:	0f b6 14 c5 05 7c 11 	movzbl -0x7fee83fb(,%eax,8),%edx
801067f3:	80 
801067f4:	83 e2 9f             	and    $0xffffff9f,%edx
801067f7:	88 14 c5 05 7c 11 80 	mov    %dl,-0x7fee83fb(,%eax,8)
801067fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106801:	0f b6 14 c5 05 7c 11 	movzbl -0x7fee83fb(,%eax,8),%edx
80106808:	80 
80106809:	83 ca 80             	or     $0xffffff80,%edx
8010680c:	88 14 c5 05 7c 11 80 	mov    %dl,-0x7fee83fb(,%eax,8)
80106813:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106816:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106819:	8b 14 95 a4 c0 10 80 	mov    -0x7fef3f5c(,%edx,4),%edx
80106820:	c1 ea 10             	shr    $0x10,%edx
80106823:	66 89 14 c5 06 7c 11 	mov    %dx,-0x7fee83fa(,%eax,8)
8010682a:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
8010682b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010682f:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106836:	0f 8e 34 ff ff ff    	jle    80106770 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010683c:	a1 a4 c1 10 80       	mov    0x8010c1a4,%eax
80106841:	66 a3 00 7e 11 80    	mov    %ax,0x80117e00
80106847:	66 c7 05 02 7e 11 80 	movw   $0x8,0x80117e02
8010684e:	08 00 
80106850:	0f b6 05 04 7e 11 80 	movzbl 0x80117e04,%eax
80106857:	83 e0 e0             	and    $0xffffffe0,%eax
8010685a:	a2 04 7e 11 80       	mov    %al,0x80117e04
8010685f:	0f b6 05 04 7e 11 80 	movzbl 0x80117e04,%eax
80106866:	83 e0 1f             	and    $0x1f,%eax
80106869:	a2 04 7e 11 80       	mov    %al,0x80117e04
8010686e:	0f b6 05 05 7e 11 80 	movzbl 0x80117e05,%eax
80106875:	83 c8 0f             	or     $0xf,%eax
80106878:	a2 05 7e 11 80       	mov    %al,0x80117e05
8010687d:	0f b6 05 05 7e 11 80 	movzbl 0x80117e05,%eax
80106884:	83 e0 ef             	and    $0xffffffef,%eax
80106887:	a2 05 7e 11 80       	mov    %al,0x80117e05
8010688c:	0f b6 05 05 7e 11 80 	movzbl 0x80117e05,%eax
80106893:	83 c8 60             	or     $0x60,%eax
80106896:	a2 05 7e 11 80       	mov    %al,0x80117e05
8010689b:	0f b6 05 05 7e 11 80 	movzbl 0x80117e05,%eax
801068a2:	83 c8 80             	or     $0xffffff80,%eax
801068a5:	a2 05 7e 11 80       	mov    %al,0x80117e05
801068aa:	a1 a4 c1 10 80       	mov    0x8010c1a4,%eax
801068af:	c1 e8 10             	shr    $0x10,%eax
801068b2:	66 a3 06 7e 11 80    	mov    %ax,0x80117e06
  
  initlock(&tickslock, "time");
801068b8:	c7 44 24 04 ec 8d 10 	movl   $0x80108dec,0x4(%esp)
801068bf:	80 
801068c0:	c7 04 24 c0 7b 11 80 	movl   $0x80117bc0,(%esp)
801068c7:	e8 72 e6 ff ff       	call   80104f3e <initlock>
}
801068cc:	c9                   	leave  
801068cd:	c3                   	ret    

801068ce <idtinit>:

void
idtinit(void)
{
801068ce:	55                   	push   %ebp
801068cf:	89 e5                	mov    %esp,%ebp
801068d1:	83 ec 08             	sub    $0x8,%esp
  lidt(idt, sizeof(idt));
801068d4:	c7 44 24 04 00 08 00 	movl   $0x800,0x4(%esp)
801068db:	00 
801068dc:	c7 04 24 00 7c 11 80 	movl   $0x80117c00,(%esp)
801068e3:	e8 3c fe ff ff       	call   80106724 <lidt>
}
801068e8:	c9                   	leave  
801068e9:	c3                   	ret    

801068ea <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801068ea:	55                   	push   %ebp
801068eb:	89 e5                	mov    %esp,%ebp
801068ed:	57                   	push   %edi
801068ee:	56                   	push   %esi
801068ef:	53                   	push   %ebx
801068f0:	83 ec 4c             	sub    $0x4c,%esp
  if(tf->trapno == T_SYSCALL){
801068f3:	8b 45 08             	mov    0x8(%ebp),%eax
801068f6:	8b 40 30             	mov    0x30(%eax),%eax
801068f9:	83 f8 40             	cmp    $0x40,%eax
801068fc:	75 3e                	jne    8010693c <trap+0x52>
    if(proc->killed)
801068fe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106904:	8b 40 24             	mov    0x24(%eax),%eax
80106907:	85 c0                	test   %eax,%eax
80106909:	74 05                	je     80106910 <trap+0x26>
      exit();
8010690b:	e8 7b df ff ff       	call   8010488b <exit>
    proc->tf = tf;
80106910:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106916:	8b 55 08             	mov    0x8(%ebp),%edx
80106919:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
8010691c:	e8 b9 ec ff ff       	call   801055da <syscall>
    if(proc->killed)
80106921:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106927:	8b 40 24             	mov    0x24(%eax),%eax
8010692a:	85 c0                	test   %eax,%eax
8010692c:	0f 84 db 04 00 00    	je     80106e0d <trap+0x523>
      exit();
80106932:	e8 54 df ff ff       	call   8010488b <exit>
    return;
80106937:	e9 d2 04 00 00       	jmp    80106e0e <trap+0x524>
  }

  switch(tf->trapno){
8010693c:	8b 45 08             	mov    0x8(%ebp),%eax
8010693f:	8b 40 30             	mov    0x30(%eax),%eax
80106942:	83 f8 3f             	cmp    $0x3f,%eax
80106945:	0f 87 66 03 00 00    	ja     80106cb1 <trap+0x3c7>
8010694b:	8b 04 85 94 8e 10 80 	mov    -0x7fef716c(,%eax,4),%eax
80106952:	ff e0                	jmp    *%eax
  // Alarm related things here?
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
80106954:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010695a:	0f b6 00             	movzbl (%eax),%eax
8010695d:	84 c0                	test   %al,%al
8010695f:	75 31                	jne    80106992 <trap+0xa8>
      acquire(&tickslock);
80106961:	c7 04 24 c0 7b 11 80 	movl   $0x80117bc0,(%esp)
80106968:	e8 f2 e5 ff ff       	call   80104f5f <acquire>
      ticks++;
8010696d:	a1 00 84 11 80       	mov    0x80118400,%eax
80106972:	83 c0 01             	add    $0x1,%eax
80106975:	a3 00 84 11 80       	mov    %eax,0x80118400
      wakeup(&ticks);
8010697a:	c7 04 24 00 84 11 80 	movl   $0x80118400,(%esp)
80106981:	e8 db e3 ff ff       	call   80104d61 <wakeup>
      release(&tickslock);
80106986:	c7 04 24 c0 7b 11 80 	movl   $0x80117bc0,(%esp)
8010698d:	e8 2e e6 ff ff       	call   80104fc0 <release>
    }

  if(proc && proc->alarmState == 0 && (tf->cs&3) == DPL_USER) // If the alarm is off 
80106992:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106998:	85 c0                	test   %eax,%eax
8010699a:	0f 84 82 01 00 00    	je     80106b22 <trap+0x238>
801069a0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801069a6:	8b 80 fc 00 00 00    	mov    0xfc(%eax),%eax
801069ac:	85 c0                	test   %eax,%eax
801069ae:	0f 85 6e 01 00 00    	jne    80106b22 <trap+0x238>
801069b4:	8b 45 08             	mov    0x8(%ebp),%eax
801069b7:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801069bb:	0f b7 c0             	movzwl %ax,%eax
801069be:	83 e0 03             	and    $0x3,%eax
801069c1:	83 f8 03             	cmp    $0x3,%eax
801069c4:	0f 85 58 01 00 00    	jne    80106b22 <trap+0x238>
  {
         proc->numberOfTicks = proc->numberOfTicks - 1; // Decrease the number of ticks
801069ca:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801069d0:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801069d7:	8b 92 00 01 00 00    	mov    0x100(%edx),%edx
801069dd:	83 ea 01             	sub    $0x1,%edx
801069e0:	89 90 00 01 00 00    	mov    %edx,0x100(%eax)
         	if(proc->numberOfTicks == 0) { // Once it reachs 0 
801069e6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801069ec:	8b 80 00 01 00 00    	mov    0x100(%eax),%eax
801069f2:	85 c0                	test   %eax,%eax
801069f4:	0f 85 28 01 00 00    	jne    80106b22 <trap+0x238>
			proc->alarmState = 1; // Turn the alarm on
801069fa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a00:	c7 80 fc 00 00 00 01 	movl   $0x1,0xfc(%eax)
80106a07:	00 00 00 
    			if(proc->handlers[SIGALRM] != -1)  { // If SIGALRM is registered
80106a0a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a10:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80106a16:	83 f8 ff             	cmp    $0xffffffff,%eax
80106a19:	0f 84 03 01 00 00    	je     80106b22 <trap+0x238>
				
				//cprintf("Alarm Address: %d\n", proc->handlers[SIGALRM]);
				int info = SIGALRM;
80106a1f:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)


//				int decrement = sizeof(siginfo_t);
				int decrement = 4;
80106a26:	c7 45 dc 04 00 00 00 	movl   $0x4,-0x24(%ebp)
				*( (int*) (tf->esp - decrement) )  = tf->eip; // 
80106a2d:	8b 45 08             	mov    0x8(%ebp),%eax
80106a30:	8b 50 44             	mov    0x44(%eax),%edx
80106a33:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106a36:	89 d1                	mov    %edx,%ecx
80106a38:	29 c1                	sub    %eax,%ecx
80106a3a:	89 c8                	mov    %ecx,%eax
80106a3c:	8b 55 08             	mov    0x8(%ebp),%edx
80106a3f:	8b 52 38             	mov    0x38(%edx),%edx
80106a42:	89 10                	mov    %edx,(%eax)
				decrement = decrement + 4;
80106a44:	83 45 dc 04          	addl   $0x4,-0x24(%ebp)
				
			
				*( (int*) (tf->esp - decrement) ) = tf->ebp;
80106a48:	8b 45 08             	mov    0x8(%ebp),%eax
80106a4b:	8b 50 44             	mov    0x44(%eax),%edx
80106a4e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106a51:	89 d1                	mov    %edx,%ecx
80106a53:	29 c1                	sub    %eax,%ecx
80106a55:	89 c8                	mov    %ecx,%eax
80106a57:	8b 55 08             	mov    0x8(%ebp),%edx
80106a5a:	8b 52 08             	mov    0x8(%edx),%edx
80106a5d:	89 10                	mov    %edx,(%eax)
				
				tf->ebp = tf->esp - 8;
80106a5f:	8b 45 08             	mov    0x8(%ebp),%eax
80106a62:	8b 40 44             	mov    0x44(%eax),%eax
80106a65:	8d 50 f8             	lea    -0x8(%eax),%edx
80106a68:	8b 45 08             	mov    0x8(%ebp),%eax
80106a6b:	89 50 08             	mov    %edx,0x8(%eax)
				decrement = decrement + 4;
80106a6e:	83 45 dc 04          	addl   $0x4,-0x24(%ebp)
				
				*( (int*) (tf->esp - decrement) )  = tf->eax; // 
80106a72:	8b 45 08             	mov    0x8(%ebp),%eax
80106a75:	8b 50 44             	mov    0x44(%eax),%edx
80106a78:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106a7b:	89 d1                	mov    %edx,%ecx
80106a7d:	29 c1                	sub    %eax,%ecx
80106a7f:	89 c8                	mov    %ecx,%eax
80106a81:	8b 55 08             	mov    0x8(%ebp),%edx
80106a84:	8b 52 1c             	mov    0x1c(%edx),%edx
80106a87:	89 10                	mov    %edx,(%eax)
				decrement = decrement + 4;
80106a89:	83 45 dc 04          	addl   $0x4,-0x24(%ebp)
				
				*( (int*) (tf->esp  - decrement) )  = tf->edx; // 
80106a8d:	8b 45 08             	mov    0x8(%ebp),%eax
80106a90:	8b 50 44             	mov    0x44(%eax),%edx
80106a93:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106a96:	89 d1                	mov    %edx,%ecx
80106a98:	29 c1                	sub    %eax,%ecx
80106a9a:	89 c8                	mov    %ecx,%eax
80106a9c:	8b 55 08             	mov    0x8(%ebp),%edx
80106a9f:	8b 52 14             	mov    0x14(%edx),%edx
80106aa2:	89 10                	mov    %edx,(%eax)
				decrement = decrement + 4;
80106aa4:	83 45 dc 04          	addl   $0x4,-0x24(%ebp)
				*( (int*) (tf->esp - decrement) )  = tf->ecx; // 
80106aa8:	8b 45 08             	mov    0x8(%ebp),%eax
80106aab:	8b 50 44             	mov    0x44(%eax),%edx
80106aae:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106ab1:	89 d1                	mov    %edx,%ecx
80106ab3:	29 c1                	sub    %eax,%ecx
80106ab5:	89 c8                	mov    %ecx,%eax
80106ab7:	8b 55 08             	mov    0x8(%ebp),%edx
80106aba:	8b 52 18             	mov    0x18(%edx),%edx
80106abd:	89 10                	mov    %edx,(%eax)
				decrement = decrement + 4;
80106abf:	83 45 dc 04          	addl   $0x4,-0x24(%ebp)
				
				*( (int*) (tf->esp - decrement) )  = info; // 
80106ac3:	8b 45 08             	mov    0x8(%ebp),%eax
80106ac6:	8b 50 44             	mov    0x44(%eax),%edx
80106ac9:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106acc:	89 d1                	mov    %edx,%ecx
80106ace:	29 c1                	sub    %eax,%ecx
80106ad0:	89 c8                	mov    %ecx,%eax
80106ad2:	8b 55 d8             	mov    -0x28(%ebp),%edx
80106ad5:	89 10                	mov    %edx,(%eax)
				decrement = decrement + 4;
80106ad7:	83 45 dc 04          	addl   $0x4,-0x24(%ebp)
				*( (int*) (tf->esp - decrement) )  = proc->trampoline; // 
80106adb:	8b 45 08             	mov    0x8(%ebp),%eax
80106ade:	8b 50 44             	mov    0x44(%eax),%edx
80106ae1:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106ae4:	89 d1                	mov    %edx,%ecx
80106ae6:	29 c1                	sub    %eax,%ecx
80106ae8:	89 c8                	mov    %ecx,%eax
80106aea:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80106af1:	8b 92 04 01 00 00    	mov    0x104(%edx),%edx
80106af7:	89 10                	mov    %edx,(%eax)

						
				tf->esp = tf->esp - decrement; // Decrease the stack pointer
80106af9:	8b 45 08             	mov    0x8(%ebp),%eax
80106afc:	8b 50 44             	mov    0x44(%eax),%edx
80106aff:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106b02:	29 c2                	sub    %eax,%edx
80106b04:	8b 45 08             	mov    0x8(%ebp),%eax
80106b07:	89 50 44             	mov    %edx,0x44(%eax)
				tf->eip = proc->handlers[info]; // Modify the address to that of the handler
80106b0a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b10:	8b 55 d8             	mov    -0x28(%ebp),%edx
80106b13:	83 c2 1c             	add    $0x1c,%edx
80106b16:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80106b1a:	89 c2                	mov    %eax,%edx
80106b1c:	8b 45 08             	mov    0x8(%ebp),%eax
80106b1f:	89 50 38             	mov    %edx,0x38(%eax)
				// SIG INFO T
				// TRAMPOLINE	
		}
	}
  } 
    lapiceoi();
80106b22:	e8 9a c4 ff ff       	call   80102fc1 <lapiceoi>
    break;
80106b27:	e9 5b 02 00 00       	jmp    80106d87 <trap+0x49d>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106b2c:	e8 8d bc ff ff       	call   801027be <ideintr>
    lapiceoi();
80106b31:	e8 8b c4 ff ff       	call   80102fc1 <lapiceoi>
    break;
80106b36:	e9 4c 02 00 00       	jmp    80106d87 <trap+0x49d>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106b3b:	e8 47 c2 ff ff       	call   80102d87 <kbdintr>
    lapiceoi();
80106b40:	e8 7c c4 ff ff       	call   80102fc1 <lapiceoi>
    break;
80106b45:	e9 3d 02 00 00       	jmp    80106d87 <trap+0x49d>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106b4a:	e8 b8 04 00 00       	call   80107007 <uartintr>
    lapiceoi();
80106b4f:	e8 6d c4 ff ff       	call   80102fc1 <lapiceoi>
    break;
80106b54:	e9 2e 02 00 00       	jmp    80106d87 <trap+0x49d>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106b59:	8b 45 08             	mov    0x8(%ebp),%eax
80106b5c:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80106b5f:	8b 45 08             	mov    0x8(%ebp),%eax
80106b62:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106b66:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80106b69:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106b6f:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106b72:	0f b6 c0             	movzbl %al,%eax
80106b75:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106b79:	89 54 24 08          	mov    %edx,0x8(%esp)
80106b7d:	89 44 24 04          	mov    %eax,0x4(%esp)
80106b81:	c7 04 24 f4 8d 10 80 	movl   $0x80108df4,(%esp)
80106b88:	e8 10 98 ff ff       	call   8010039d <cprintf>
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
80106b8d:	e8 2f c4 ff ff       	call   80102fc1 <lapiceoi>
    break;
80106b92:	e9 f0 01 00 00       	jmp    80106d87 <trap+0x49d>
  case T_DIVIDE:
    if(proc->handlers[SIGFPE] != -1) // If SIGFPE is registered
80106b97:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b9d:	8b 40 7c             	mov    0x7c(%eax),%eax
80106ba0:	83 f8 ff             	cmp    $0xffffffff,%eax
80106ba3:	0f 84 08 01 00 00    	je     80106cb1 <trap+0x3c7>
    {

				int info = SIGFPE;
80106ba9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)


				int decrement = 4;
80106bb0:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
				*( (int*) (tf->esp - decrement) )  = tf->eip; // 
80106bb7:	8b 45 08             	mov    0x8(%ebp),%eax
80106bba:	8b 50 44             	mov    0x44(%eax),%edx
80106bbd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106bc0:	89 d1                	mov    %edx,%ecx
80106bc2:	29 c1                	sub    %eax,%ecx
80106bc4:	89 c8                	mov    %ecx,%eax
80106bc6:	8b 55 08             	mov    0x8(%ebp),%edx
80106bc9:	8b 52 38             	mov    0x38(%edx),%edx
80106bcc:	89 10                	mov    %edx,(%eax)
				decrement = decrement + 4;
80106bce:	83 45 e4 04          	addl   $0x4,-0x1c(%ebp)
				
				
				*( (int*) (tf->esp - decrement) ) = tf->ebp;
80106bd2:	8b 45 08             	mov    0x8(%ebp),%eax
80106bd5:	8b 50 44             	mov    0x44(%eax),%edx
80106bd8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106bdb:	89 d1                	mov    %edx,%ecx
80106bdd:	29 c1                	sub    %eax,%ecx
80106bdf:	89 c8                	mov    %ecx,%eax
80106be1:	8b 55 08             	mov    0x8(%ebp),%edx
80106be4:	8b 52 08             	mov    0x8(%edx),%edx
80106be7:	89 10                	mov    %edx,(%eax)
				
				tf->ebp = tf->esp - 8;
80106be9:	8b 45 08             	mov    0x8(%ebp),%eax
80106bec:	8b 40 44             	mov    0x44(%eax),%eax
80106bef:	8d 50 f8             	lea    -0x8(%eax),%edx
80106bf2:	8b 45 08             	mov    0x8(%ebp),%eax
80106bf5:	89 50 08             	mov    %edx,0x8(%eax)
				decrement = decrement + 4;
80106bf8:	83 45 e4 04          	addl   $0x4,-0x1c(%ebp)
				
				*( (int*) (tf->esp - decrement) )  = tf->eax; // 
80106bfc:	8b 45 08             	mov    0x8(%ebp),%eax
80106bff:	8b 50 44             	mov    0x44(%eax),%edx
80106c02:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c05:	89 d1                	mov    %edx,%ecx
80106c07:	29 c1                	sub    %eax,%ecx
80106c09:	89 c8                	mov    %ecx,%eax
80106c0b:	8b 55 08             	mov    0x8(%ebp),%edx
80106c0e:	8b 52 1c             	mov    0x1c(%edx),%edx
80106c11:	89 10                	mov    %edx,(%eax)
				decrement = decrement + 4;
80106c13:	83 45 e4 04          	addl   $0x4,-0x1c(%ebp)
				
				*( (int*) (tf->esp  - decrement) )  = tf->edx; // 
80106c17:	8b 45 08             	mov    0x8(%ebp),%eax
80106c1a:	8b 50 44             	mov    0x44(%eax),%edx
80106c1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c20:	89 d1                	mov    %edx,%ecx
80106c22:	29 c1                	sub    %eax,%ecx
80106c24:	89 c8                	mov    %ecx,%eax
80106c26:	8b 55 08             	mov    0x8(%ebp),%edx
80106c29:	8b 52 14             	mov    0x14(%edx),%edx
80106c2c:	89 10                	mov    %edx,(%eax)
				decrement = decrement + 4;
80106c2e:	83 45 e4 04          	addl   $0x4,-0x1c(%ebp)
				*( (int*) (tf->esp - decrement) )  = tf->ecx; // 
80106c32:	8b 45 08             	mov    0x8(%ebp),%eax
80106c35:	8b 50 44             	mov    0x44(%eax),%edx
80106c38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c3b:	89 d1                	mov    %edx,%ecx
80106c3d:	29 c1                	sub    %eax,%ecx
80106c3f:	89 c8                	mov    %ecx,%eax
80106c41:	8b 55 08             	mov    0x8(%ebp),%edx
80106c44:	8b 52 18             	mov    0x18(%edx),%edx
80106c47:	89 10                	mov    %edx,(%eax)
				decrement = decrement + 4;
80106c49:	83 45 e4 04          	addl   $0x4,-0x1c(%ebp)
				
				*( (int*) (tf->esp - decrement) )  = info; // 
80106c4d:	8b 45 08             	mov    0x8(%ebp),%eax
80106c50:	8b 50 44             	mov    0x44(%eax),%edx
80106c53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c56:	89 d1                	mov    %edx,%ecx
80106c58:	29 c1                	sub    %eax,%ecx
80106c5a:	89 c8                	mov    %ecx,%eax
80106c5c:	8b 55 e0             	mov    -0x20(%ebp),%edx
80106c5f:	89 10                	mov    %edx,(%eax)
				decrement = decrement + 4;
80106c61:	83 45 e4 04          	addl   $0x4,-0x1c(%ebp)
				
				*( (int*) (tf->esp - decrement) )  = proc->trampoline; // 
80106c65:	8b 45 08             	mov    0x8(%ebp),%eax
80106c68:	8b 50 44             	mov    0x44(%eax),%edx
80106c6b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c6e:	89 d1                	mov    %edx,%ecx
80106c70:	29 c1                	sub    %eax,%ecx
80106c72:	89 c8                	mov    %ecx,%eax
80106c74:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80106c7b:	8b 92 04 01 00 00    	mov    0x104(%edx),%edx
80106c81:	89 10                	mov    %edx,(%eax)

						
				tf->esp = tf->esp - decrement; // Decrease the stack pointer
80106c83:	8b 45 08             	mov    0x8(%ebp),%eax
80106c86:	8b 50 44             	mov    0x44(%eax),%edx
80106c89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c8c:	29 c2                	sub    %eax,%edx
80106c8e:	8b 45 08             	mov    0x8(%ebp),%eax
80106c91:	89 50 44             	mov    %edx,0x44(%eax)
				tf->eip = proc->handlers[info]; // Modify the address to that of the handler
80106c94:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c9a:	8b 55 e0             	mov    -0x20(%ebp),%edx
80106c9d:	83 c2 1c             	add    $0x1c,%edx
80106ca0:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80106ca4:	89 c2                	mov    %eax,%edx
80106ca6:	8b 45 08             	mov    0x8(%ebp),%eax
80106ca9:	89 50 38             	mov    %edx,0x38(%eax)
				// TRAMPOLINE


		
				//cprintf("END OF FPE\n");
				break;
80106cac:	e9 d6 00 00 00       	jmp    80106d87 <trap+0x49d>

    }
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80106cb1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106cb7:	85 c0                	test   %eax,%eax
80106cb9:	74 11                	je     80106ccc <trap+0x3e2>
80106cbb:	8b 45 08             	mov    0x8(%ebp),%eax
80106cbe:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106cc2:	0f b7 c0             	movzwl %ax,%eax
80106cc5:	83 e0 03             	and    $0x3,%eax
80106cc8:	85 c0                	test   %eax,%eax
80106cca:	75 46                	jne    80106d12 <trap+0x428>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106ccc:	e8 7c fa ff ff       	call   8010674d <rcr2>
80106cd1:	8b 55 08             	mov    0x8(%ebp),%edx
80106cd4:	8b 5a 38             	mov    0x38(%edx),%ebx
              tf->trapno, cpu->id, tf->eip, rcr2());
80106cd7:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80106cde:	0f b6 12             	movzbl (%edx),%edx
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106ce1:	0f b6 ca             	movzbl %dl,%ecx
80106ce4:	8b 55 08             	mov    0x8(%ebp),%edx
80106ce7:	8b 52 30             	mov    0x30(%edx),%edx
80106cea:	89 44 24 10          	mov    %eax,0x10(%esp)
80106cee:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
80106cf2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106cf6:	89 54 24 04          	mov    %edx,0x4(%esp)
80106cfa:	c7 04 24 18 8e 10 80 	movl   $0x80108e18,(%esp)
80106d01:	e8 97 96 ff ff       	call   8010039d <cprintf>
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
80106d06:	c7 04 24 4a 8e 10 80 	movl   $0x80108e4a,(%esp)
80106d0d:	e8 2b 98 ff ff       	call   8010053d <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106d12:	e8 36 fa ff ff       	call   8010674d <rcr2>
80106d17:	89 c2                	mov    %eax,%edx
80106d19:	8b 45 08             	mov    0x8(%ebp),%eax
80106d1c:	8b 78 38             	mov    0x38(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106d1f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106d25:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106d28:	0f b6 f0             	movzbl %al,%esi
80106d2b:	8b 45 08             	mov    0x8(%ebp),%eax
80106d2e:	8b 58 34             	mov    0x34(%eax),%ebx
80106d31:	8b 45 08             	mov    0x8(%ebp),%eax
80106d34:	8b 48 30             	mov    0x30(%eax),%ecx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106d37:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106d3d:	83 c0 6c             	add    $0x6c,%eax
80106d40:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106d43:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106d49:	8b 40 10             	mov    0x10(%eax),%eax
80106d4c:	89 54 24 1c          	mov    %edx,0x1c(%esp)
80106d50:	89 7c 24 18          	mov    %edi,0x18(%esp)
80106d54:	89 74 24 14          	mov    %esi,0x14(%esp)
80106d58:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80106d5c:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106d60:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80106d63:	89 54 24 08          	mov    %edx,0x8(%esp)
80106d67:	89 44 24 04          	mov    %eax,0x4(%esp)
80106d6b:	c7 04 24 50 8e 10 80 	movl   $0x80108e50,(%esp)
80106d72:	e8 26 96 ff ff       	call   8010039d <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
80106d77:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d7d:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106d84:	eb 01                	jmp    80106d87 <trap+0x49d>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
80106d86:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106d87:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d8d:	85 c0                	test   %eax,%eax
80106d8f:	74 24                	je     80106db5 <trap+0x4cb>
80106d91:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d97:	8b 40 24             	mov    0x24(%eax),%eax
80106d9a:	85 c0                	test   %eax,%eax
80106d9c:	74 17                	je     80106db5 <trap+0x4cb>
80106d9e:	8b 45 08             	mov    0x8(%ebp),%eax
80106da1:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106da5:	0f b7 c0             	movzwl %ax,%eax
80106da8:	83 e0 03             	and    $0x3,%eax
80106dab:	83 f8 03             	cmp    $0x3,%eax
80106dae:	75 05                	jne    80106db5 <trap+0x4cb>
    exit();
80106db0:	e8 d6 da ff ff       	call   8010488b <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80106db5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106dbb:	85 c0                	test   %eax,%eax
80106dbd:	74 1e                	je     80106ddd <trap+0x4f3>
80106dbf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106dc5:	8b 40 0c             	mov    0xc(%eax),%eax
80106dc8:	83 f8 04             	cmp    $0x4,%eax
80106dcb:	75 10                	jne    80106ddd <trap+0x4f3>
80106dcd:	8b 45 08             	mov    0x8(%ebp),%eax
80106dd0:	8b 40 30             	mov    0x30(%eax),%eax
80106dd3:	83 f8 20             	cmp    $0x20,%eax
80106dd6:	75 05                	jne    80106ddd <trap+0x4f3>
    yield();
80106dd8:	e8 36 de ff ff       	call   80104c13 <yield>


  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106ddd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106de3:	85 c0                	test   %eax,%eax
80106de5:	74 27                	je     80106e0e <trap+0x524>
80106de7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ded:	8b 40 24             	mov    0x24(%eax),%eax
80106df0:	85 c0                	test   %eax,%eax
80106df2:	74 1a                	je     80106e0e <trap+0x524>
80106df4:	8b 45 08             	mov    0x8(%ebp),%eax
80106df7:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106dfb:	0f b7 c0             	movzwl %ax,%eax
80106dfe:	83 e0 03             	and    $0x3,%eax
80106e01:	83 f8 03             	cmp    $0x3,%eax
80106e04:	75 08                	jne    80106e0e <trap+0x524>
    exit();
80106e06:	e8 80 da ff ff       	call   8010488b <exit>
80106e0b:	eb 01                	jmp    80106e0e <trap+0x524>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
80106e0d:	90                   	nop


  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80106e0e:	83 c4 4c             	add    $0x4c,%esp
80106e11:	5b                   	pop    %ebx
80106e12:	5e                   	pop    %esi
80106e13:	5f                   	pop    %edi
80106e14:	5d                   	pop    %ebp
80106e15:	c3                   	ret    
	...

80106e18 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80106e18:	55                   	push   %ebp
80106e19:	89 e5                	mov    %esp,%ebp
80106e1b:	83 ec 14             	sub    $0x14,%esp
80106e1e:	8b 45 08             	mov    0x8(%ebp),%eax
80106e21:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106e25:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80106e29:	89 c2                	mov    %eax,%edx
80106e2b:	ec                   	in     (%dx),%al
80106e2c:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80106e2f:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80106e33:	c9                   	leave  
80106e34:	c3                   	ret    

80106e35 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106e35:	55                   	push   %ebp
80106e36:	89 e5                	mov    %esp,%ebp
80106e38:	83 ec 08             	sub    $0x8,%esp
80106e3b:	8b 55 08             	mov    0x8(%ebp),%edx
80106e3e:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e41:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106e45:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106e48:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106e4c:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106e50:	ee                   	out    %al,(%dx)
}
80106e51:	c9                   	leave  
80106e52:	c3                   	ret    

80106e53 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106e53:	55                   	push   %ebp
80106e54:	89 e5                	mov    %esp,%ebp
80106e56:	83 ec 28             	sub    $0x28,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80106e59:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106e60:	00 
80106e61:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80106e68:	e8 c8 ff ff ff       	call   80106e35 <outb>
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80106e6d:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
80106e74:	00 
80106e75:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80106e7c:	e8 b4 ff ff ff       	call   80106e35 <outb>
  outb(COM1+0, 115200/9600);
80106e81:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
80106e88:	00 
80106e89:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106e90:	e8 a0 ff ff ff       	call   80106e35 <outb>
  outb(COM1+1, 0);
80106e95:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106e9c:	00 
80106e9d:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80106ea4:	e8 8c ff ff ff       	call   80106e35 <outb>
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106ea9:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80106eb0:	00 
80106eb1:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80106eb8:	e8 78 ff ff ff       	call   80106e35 <outb>
  outb(COM1+4, 0);
80106ebd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106ec4:	00 
80106ec5:	c7 04 24 fc 03 00 00 	movl   $0x3fc,(%esp)
80106ecc:	e8 64 ff ff ff       	call   80106e35 <outb>
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80106ed1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80106ed8:	00 
80106ed9:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80106ee0:	e8 50 ff ff ff       	call   80106e35 <outb>

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106ee5:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106eec:	e8 27 ff ff ff       	call   80106e18 <inb>
80106ef1:	3c ff                	cmp    $0xff,%al
80106ef3:	74 6c                	je     80106f61 <uartinit+0x10e>
    return;
  uart = 1;
80106ef5:	c7 05 6c c6 10 80 01 	movl   $0x1,0x8010c66c
80106efc:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80106eff:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80106f06:	e8 0d ff ff ff       	call   80106e18 <inb>
  inb(COM1+0);
80106f0b:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106f12:	e8 01 ff ff ff       	call   80106e18 <inb>
  picenable(IRQ_COM1);
80106f17:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80106f1e:	e8 72 cf ff ff       	call   80103e95 <picenable>
  ioapicenable(IRQ_COM1, 0);
80106f23:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106f2a:	00 
80106f2b:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80106f32:	e8 0b bb ff ff       	call   80102a42 <ioapicenable>
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106f37:	c7 45 f4 94 8f 10 80 	movl   $0x80108f94,-0xc(%ebp)
80106f3e:	eb 15                	jmp    80106f55 <uartinit+0x102>
    uartputc(*p);
80106f40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f43:	0f b6 00             	movzbl (%eax),%eax
80106f46:	0f be c0             	movsbl %al,%eax
80106f49:	89 04 24             	mov    %eax,(%esp)
80106f4c:	e8 13 00 00 00       	call   80106f64 <uartputc>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106f51:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106f55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f58:	0f b6 00             	movzbl (%eax),%eax
80106f5b:	84 c0                	test   %al,%al
80106f5d:	75 e1                	jne    80106f40 <uartinit+0xed>
80106f5f:	eb 01                	jmp    80106f62 <uartinit+0x10f>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
80106f61:	90                   	nop
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
80106f62:	c9                   	leave  
80106f63:	c3                   	ret    

80106f64 <uartputc>:

void
uartputc(int c)
{
80106f64:	55                   	push   %ebp
80106f65:	89 e5                	mov    %esp,%ebp
80106f67:	83 ec 28             	sub    $0x28,%esp
  int i;

  if(!uart)
80106f6a:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
80106f6f:	85 c0                	test   %eax,%eax
80106f71:	74 4d                	je     80106fc0 <uartputc+0x5c>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106f73:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106f7a:	eb 10                	jmp    80106f8c <uartputc+0x28>
    microdelay(10);
80106f7c:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80106f83:	e8 5e c0 ff ff       	call   80102fe6 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106f88:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106f8c:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80106f90:	7f 16                	jg     80106fa8 <uartputc+0x44>
80106f92:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106f99:	e8 7a fe ff ff       	call   80106e18 <inb>
80106f9e:	0f b6 c0             	movzbl %al,%eax
80106fa1:	83 e0 20             	and    $0x20,%eax
80106fa4:	85 c0                	test   %eax,%eax
80106fa6:	74 d4                	je     80106f7c <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
80106fa8:	8b 45 08             	mov    0x8(%ebp),%eax
80106fab:	0f b6 c0             	movzbl %al,%eax
80106fae:	89 44 24 04          	mov    %eax,0x4(%esp)
80106fb2:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106fb9:	e8 77 fe ff ff       	call   80106e35 <outb>
80106fbe:	eb 01                	jmp    80106fc1 <uartputc+0x5d>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
80106fc0:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80106fc1:	c9                   	leave  
80106fc2:	c3                   	ret    

80106fc3 <uartgetc>:

static int
uartgetc(void)
{
80106fc3:	55                   	push   %ebp
80106fc4:	89 e5                	mov    %esp,%ebp
80106fc6:	83 ec 04             	sub    $0x4,%esp
  if(!uart)
80106fc9:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
80106fce:	85 c0                	test   %eax,%eax
80106fd0:	75 07                	jne    80106fd9 <uartgetc+0x16>
    return -1;
80106fd2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106fd7:	eb 2c                	jmp    80107005 <uartgetc+0x42>
  if(!(inb(COM1+5) & 0x01))
80106fd9:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106fe0:	e8 33 fe ff ff       	call   80106e18 <inb>
80106fe5:	0f b6 c0             	movzbl %al,%eax
80106fe8:	83 e0 01             	and    $0x1,%eax
80106feb:	85 c0                	test   %eax,%eax
80106fed:	75 07                	jne    80106ff6 <uartgetc+0x33>
    return -1;
80106fef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ff4:	eb 0f                	jmp    80107005 <uartgetc+0x42>
  return inb(COM1+0);
80106ff6:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106ffd:	e8 16 fe ff ff       	call   80106e18 <inb>
80107002:	0f b6 c0             	movzbl %al,%eax
}
80107005:	c9                   	leave  
80107006:	c3                   	ret    

80107007 <uartintr>:

void
uartintr(void)
{
80107007:	55                   	push   %ebp
80107008:	89 e5                	mov    %esp,%ebp
8010700a:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
8010700d:	c7 04 24 c3 6f 10 80 	movl   $0x80106fc3,(%esp)
80107014:	e8 b0 97 ff ff       	call   801007c9 <consoleintr>
}
80107019:	c9                   	leave  
8010701a:	c3                   	ret    
	...

8010701c <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
8010701c:	6a 00                	push   $0x0
  pushl $0
8010701e:	6a 00                	push   $0x0
  jmp alltraps
80107020:	e9 d3 f6 ff ff       	jmp    801066f8 <alltraps>

80107025 <vector1>:
.globl vector1
vector1:
  pushl $0
80107025:	6a 00                	push   $0x0
  pushl $1
80107027:	6a 01                	push   $0x1
  jmp alltraps
80107029:	e9 ca f6 ff ff       	jmp    801066f8 <alltraps>

8010702e <vector2>:
.globl vector2
vector2:
  pushl $0
8010702e:	6a 00                	push   $0x0
  pushl $2
80107030:	6a 02                	push   $0x2
  jmp alltraps
80107032:	e9 c1 f6 ff ff       	jmp    801066f8 <alltraps>

80107037 <vector3>:
.globl vector3
vector3:
  pushl $0
80107037:	6a 00                	push   $0x0
  pushl $3
80107039:	6a 03                	push   $0x3
  jmp alltraps
8010703b:	e9 b8 f6 ff ff       	jmp    801066f8 <alltraps>

80107040 <vector4>:
.globl vector4
vector4:
  pushl $0
80107040:	6a 00                	push   $0x0
  pushl $4
80107042:	6a 04                	push   $0x4
  jmp alltraps
80107044:	e9 af f6 ff ff       	jmp    801066f8 <alltraps>

80107049 <vector5>:
.globl vector5
vector5:
  pushl $0
80107049:	6a 00                	push   $0x0
  pushl $5
8010704b:	6a 05                	push   $0x5
  jmp alltraps
8010704d:	e9 a6 f6 ff ff       	jmp    801066f8 <alltraps>

80107052 <vector6>:
.globl vector6
vector6:
  pushl $0
80107052:	6a 00                	push   $0x0
  pushl $6
80107054:	6a 06                	push   $0x6
  jmp alltraps
80107056:	e9 9d f6 ff ff       	jmp    801066f8 <alltraps>

8010705b <vector7>:
.globl vector7
vector7:
  pushl $0
8010705b:	6a 00                	push   $0x0
  pushl $7
8010705d:	6a 07                	push   $0x7
  jmp alltraps
8010705f:	e9 94 f6 ff ff       	jmp    801066f8 <alltraps>

80107064 <vector8>:
.globl vector8
vector8:
  pushl $8
80107064:	6a 08                	push   $0x8
  jmp alltraps
80107066:	e9 8d f6 ff ff       	jmp    801066f8 <alltraps>

8010706b <vector9>:
.globl vector9
vector9:
  pushl $0
8010706b:	6a 00                	push   $0x0
  pushl $9
8010706d:	6a 09                	push   $0x9
  jmp alltraps
8010706f:	e9 84 f6 ff ff       	jmp    801066f8 <alltraps>

80107074 <vector10>:
.globl vector10
vector10:
  pushl $10
80107074:	6a 0a                	push   $0xa
  jmp alltraps
80107076:	e9 7d f6 ff ff       	jmp    801066f8 <alltraps>

8010707b <vector11>:
.globl vector11
vector11:
  pushl $11
8010707b:	6a 0b                	push   $0xb
  jmp alltraps
8010707d:	e9 76 f6 ff ff       	jmp    801066f8 <alltraps>

80107082 <vector12>:
.globl vector12
vector12:
  pushl $12
80107082:	6a 0c                	push   $0xc
  jmp alltraps
80107084:	e9 6f f6 ff ff       	jmp    801066f8 <alltraps>

80107089 <vector13>:
.globl vector13
vector13:
  pushl $13
80107089:	6a 0d                	push   $0xd
  jmp alltraps
8010708b:	e9 68 f6 ff ff       	jmp    801066f8 <alltraps>

80107090 <vector14>:
.globl vector14
vector14:
  pushl $14
80107090:	6a 0e                	push   $0xe
  jmp alltraps
80107092:	e9 61 f6 ff ff       	jmp    801066f8 <alltraps>

80107097 <vector15>:
.globl vector15
vector15:
  pushl $0
80107097:	6a 00                	push   $0x0
  pushl $15
80107099:	6a 0f                	push   $0xf
  jmp alltraps
8010709b:	e9 58 f6 ff ff       	jmp    801066f8 <alltraps>

801070a0 <vector16>:
.globl vector16
vector16:
  pushl $0
801070a0:	6a 00                	push   $0x0
  pushl $16
801070a2:	6a 10                	push   $0x10
  jmp alltraps
801070a4:	e9 4f f6 ff ff       	jmp    801066f8 <alltraps>

801070a9 <vector17>:
.globl vector17
vector17:
  pushl $17
801070a9:	6a 11                	push   $0x11
  jmp alltraps
801070ab:	e9 48 f6 ff ff       	jmp    801066f8 <alltraps>

801070b0 <vector18>:
.globl vector18
vector18:
  pushl $0
801070b0:	6a 00                	push   $0x0
  pushl $18
801070b2:	6a 12                	push   $0x12
  jmp alltraps
801070b4:	e9 3f f6 ff ff       	jmp    801066f8 <alltraps>

801070b9 <vector19>:
.globl vector19
vector19:
  pushl $0
801070b9:	6a 00                	push   $0x0
  pushl $19
801070bb:	6a 13                	push   $0x13
  jmp alltraps
801070bd:	e9 36 f6 ff ff       	jmp    801066f8 <alltraps>

801070c2 <vector20>:
.globl vector20
vector20:
  pushl $0
801070c2:	6a 00                	push   $0x0
  pushl $20
801070c4:	6a 14                	push   $0x14
  jmp alltraps
801070c6:	e9 2d f6 ff ff       	jmp    801066f8 <alltraps>

801070cb <vector21>:
.globl vector21
vector21:
  pushl $0
801070cb:	6a 00                	push   $0x0
  pushl $21
801070cd:	6a 15                	push   $0x15
  jmp alltraps
801070cf:	e9 24 f6 ff ff       	jmp    801066f8 <alltraps>

801070d4 <vector22>:
.globl vector22
vector22:
  pushl $0
801070d4:	6a 00                	push   $0x0
  pushl $22
801070d6:	6a 16                	push   $0x16
  jmp alltraps
801070d8:	e9 1b f6 ff ff       	jmp    801066f8 <alltraps>

801070dd <vector23>:
.globl vector23
vector23:
  pushl $0
801070dd:	6a 00                	push   $0x0
  pushl $23
801070df:	6a 17                	push   $0x17
  jmp alltraps
801070e1:	e9 12 f6 ff ff       	jmp    801066f8 <alltraps>

801070e6 <vector24>:
.globl vector24
vector24:
  pushl $0
801070e6:	6a 00                	push   $0x0
  pushl $24
801070e8:	6a 18                	push   $0x18
  jmp alltraps
801070ea:	e9 09 f6 ff ff       	jmp    801066f8 <alltraps>

801070ef <vector25>:
.globl vector25
vector25:
  pushl $0
801070ef:	6a 00                	push   $0x0
  pushl $25
801070f1:	6a 19                	push   $0x19
  jmp alltraps
801070f3:	e9 00 f6 ff ff       	jmp    801066f8 <alltraps>

801070f8 <vector26>:
.globl vector26
vector26:
  pushl $0
801070f8:	6a 00                	push   $0x0
  pushl $26
801070fa:	6a 1a                	push   $0x1a
  jmp alltraps
801070fc:	e9 f7 f5 ff ff       	jmp    801066f8 <alltraps>

80107101 <vector27>:
.globl vector27
vector27:
  pushl $0
80107101:	6a 00                	push   $0x0
  pushl $27
80107103:	6a 1b                	push   $0x1b
  jmp alltraps
80107105:	e9 ee f5 ff ff       	jmp    801066f8 <alltraps>

8010710a <vector28>:
.globl vector28
vector28:
  pushl $0
8010710a:	6a 00                	push   $0x0
  pushl $28
8010710c:	6a 1c                	push   $0x1c
  jmp alltraps
8010710e:	e9 e5 f5 ff ff       	jmp    801066f8 <alltraps>

80107113 <vector29>:
.globl vector29
vector29:
  pushl $0
80107113:	6a 00                	push   $0x0
  pushl $29
80107115:	6a 1d                	push   $0x1d
  jmp alltraps
80107117:	e9 dc f5 ff ff       	jmp    801066f8 <alltraps>

8010711c <vector30>:
.globl vector30
vector30:
  pushl $0
8010711c:	6a 00                	push   $0x0
  pushl $30
8010711e:	6a 1e                	push   $0x1e
  jmp alltraps
80107120:	e9 d3 f5 ff ff       	jmp    801066f8 <alltraps>

80107125 <vector31>:
.globl vector31
vector31:
  pushl $0
80107125:	6a 00                	push   $0x0
  pushl $31
80107127:	6a 1f                	push   $0x1f
  jmp alltraps
80107129:	e9 ca f5 ff ff       	jmp    801066f8 <alltraps>

8010712e <vector32>:
.globl vector32
vector32:
  pushl $0
8010712e:	6a 00                	push   $0x0
  pushl $32
80107130:	6a 20                	push   $0x20
  jmp alltraps
80107132:	e9 c1 f5 ff ff       	jmp    801066f8 <alltraps>

80107137 <vector33>:
.globl vector33
vector33:
  pushl $0
80107137:	6a 00                	push   $0x0
  pushl $33
80107139:	6a 21                	push   $0x21
  jmp alltraps
8010713b:	e9 b8 f5 ff ff       	jmp    801066f8 <alltraps>

80107140 <vector34>:
.globl vector34
vector34:
  pushl $0
80107140:	6a 00                	push   $0x0
  pushl $34
80107142:	6a 22                	push   $0x22
  jmp alltraps
80107144:	e9 af f5 ff ff       	jmp    801066f8 <alltraps>

80107149 <vector35>:
.globl vector35
vector35:
  pushl $0
80107149:	6a 00                	push   $0x0
  pushl $35
8010714b:	6a 23                	push   $0x23
  jmp alltraps
8010714d:	e9 a6 f5 ff ff       	jmp    801066f8 <alltraps>

80107152 <vector36>:
.globl vector36
vector36:
  pushl $0
80107152:	6a 00                	push   $0x0
  pushl $36
80107154:	6a 24                	push   $0x24
  jmp alltraps
80107156:	e9 9d f5 ff ff       	jmp    801066f8 <alltraps>

8010715b <vector37>:
.globl vector37
vector37:
  pushl $0
8010715b:	6a 00                	push   $0x0
  pushl $37
8010715d:	6a 25                	push   $0x25
  jmp alltraps
8010715f:	e9 94 f5 ff ff       	jmp    801066f8 <alltraps>

80107164 <vector38>:
.globl vector38
vector38:
  pushl $0
80107164:	6a 00                	push   $0x0
  pushl $38
80107166:	6a 26                	push   $0x26
  jmp alltraps
80107168:	e9 8b f5 ff ff       	jmp    801066f8 <alltraps>

8010716d <vector39>:
.globl vector39
vector39:
  pushl $0
8010716d:	6a 00                	push   $0x0
  pushl $39
8010716f:	6a 27                	push   $0x27
  jmp alltraps
80107171:	e9 82 f5 ff ff       	jmp    801066f8 <alltraps>

80107176 <vector40>:
.globl vector40
vector40:
  pushl $0
80107176:	6a 00                	push   $0x0
  pushl $40
80107178:	6a 28                	push   $0x28
  jmp alltraps
8010717a:	e9 79 f5 ff ff       	jmp    801066f8 <alltraps>

8010717f <vector41>:
.globl vector41
vector41:
  pushl $0
8010717f:	6a 00                	push   $0x0
  pushl $41
80107181:	6a 29                	push   $0x29
  jmp alltraps
80107183:	e9 70 f5 ff ff       	jmp    801066f8 <alltraps>

80107188 <vector42>:
.globl vector42
vector42:
  pushl $0
80107188:	6a 00                	push   $0x0
  pushl $42
8010718a:	6a 2a                	push   $0x2a
  jmp alltraps
8010718c:	e9 67 f5 ff ff       	jmp    801066f8 <alltraps>

80107191 <vector43>:
.globl vector43
vector43:
  pushl $0
80107191:	6a 00                	push   $0x0
  pushl $43
80107193:	6a 2b                	push   $0x2b
  jmp alltraps
80107195:	e9 5e f5 ff ff       	jmp    801066f8 <alltraps>

8010719a <vector44>:
.globl vector44
vector44:
  pushl $0
8010719a:	6a 00                	push   $0x0
  pushl $44
8010719c:	6a 2c                	push   $0x2c
  jmp alltraps
8010719e:	e9 55 f5 ff ff       	jmp    801066f8 <alltraps>

801071a3 <vector45>:
.globl vector45
vector45:
  pushl $0
801071a3:	6a 00                	push   $0x0
  pushl $45
801071a5:	6a 2d                	push   $0x2d
  jmp alltraps
801071a7:	e9 4c f5 ff ff       	jmp    801066f8 <alltraps>

801071ac <vector46>:
.globl vector46
vector46:
  pushl $0
801071ac:	6a 00                	push   $0x0
  pushl $46
801071ae:	6a 2e                	push   $0x2e
  jmp alltraps
801071b0:	e9 43 f5 ff ff       	jmp    801066f8 <alltraps>

801071b5 <vector47>:
.globl vector47
vector47:
  pushl $0
801071b5:	6a 00                	push   $0x0
  pushl $47
801071b7:	6a 2f                	push   $0x2f
  jmp alltraps
801071b9:	e9 3a f5 ff ff       	jmp    801066f8 <alltraps>

801071be <vector48>:
.globl vector48
vector48:
  pushl $0
801071be:	6a 00                	push   $0x0
  pushl $48
801071c0:	6a 30                	push   $0x30
  jmp alltraps
801071c2:	e9 31 f5 ff ff       	jmp    801066f8 <alltraps>

801071c7 <vector49>:
.globl vector49
vector49:
  pushl $0
801071c7:	6a 00                	push   $0x0
  pushl $49
801071c9:	6a 31                	push   $0x31
  jmp alltraps
801071cb:	e9 28 f5 ff ff       	jmp    801066f8 <alltraps>

801071d0 <vector50>:
.globl vector50
vector50:
  pushl $0
801071d0:	6a 00                	push   $0x0
  pushl $50
801071d2:	6a 32                	push   $0x32
  jmp alltraps
801071d4:	e9 1f f5 ff ff       	jmp    801066f8 <alltraps>

801071d9 <vector51>:
.globl vector51
vector51:
  pushl $0
801071d9:	6a 00                	push   $0x0
  pushl $51
801071db:	6a 33                	push   $0x33
  jmp alltraps
801071dd:	e9 16 f5 ff ff       	jmp    801066f8 <alltraps>

801071e2 <vector52>:
.globl vector52
vector52:
  pushl $0
801071e2:	6a 00                	push   $0x0
  pushl $52
801071e4:	6a 34                	push   $0x34
  jmp alltraps
801071e6:	e9 0d f5 ff ff       	jmp    801066f8 <alltraps>

801071eb <vector53>:
.globl vector53
vector53:
  pushl $0
801071eb:	6a 00                	push   $0x0
  pushl $53
801071ed:	6a 35                	push   $0x35
  jmp alltraps
801071ef:	e9 04 f5 ff ff       	jmp    801066f8 <alltraps>

801071f4 <vector54>:
.globl vector54
vector54:
  pushl $0
801071f4:	6a 00                	push   $0x0
  pushl $54
801071f6:	6a 36                	push   $0x36
  jmp alltraps
801071f8:	e9 fb f4 ff ff       	jmp    801066f8 <alltraps>

801071fd <vector55>:
.globl vector55
vector55:
  pushl $0
801071fd:	6a 00                	push   $0x0
  pushl $55
801071ff:	6a 37                	push   $0x37
  jmp alltraps
80107201:	e9 f2 f4 ff ff       	jmp    801066f8 <alltraps>

80107206 <vector56>:
.globl vector56
vector56:
  pushl $0
80107206:	6a 00                	push   $0x0
  pushl $56
80107208:	6a 38                	push   $0x38
  jmp alltraps
8010720a:	e9 e9 f4 ff ff       	jmp    801066f8 <alltraps>

8010720f <vector57>:
.globl vector57
vector57:
  pushl $0
8010720f:	6a 00                	push   $0x0
  pushl $57
80107211:	6a 39                	push   $0x39
  jmp alltraps
80107213:	e9 e0 f4 ff ff       	jmp    801066f8 <alltraps>

80107218 <vector58>:
.globl vector58
vector58:
  pushl $0
80107218:	6a 00                	push   $0x0
  pushl $58
8010721a:	6a 3a                	push   $0x3a
  jmp alltraps
8010721c:	e9 d7 f4 ff ff       	jmp    801066f8 <alltraps>

80107221 <vector59>:
.globl vector59
vector59:
  pushl $0
80107221:	6a 00                	push   $0x0
  pushl $59
80107223:	6a 3b                	push   $0x3b
  jmp alltraps
80107225:	e9 ce f4 ff ff       	jmp    801066f8 <alltraps>

8010722a <vector60>:
.globl vector60
vector60:
  pushl $0
8010722a:	6a 00                	push   $0x0
  pushl $60
8010722c:	6a 3c                	push   $0x3c
  jmp alltraps
8010722e:	e9 c5 f4 ff ff       	jmp    801066f8 <alltraps>

80107233 <vector61>:
.globl vector61
vector61:
  pushl $0
80107233:	6a 00                	push   $0x0
  pushl $61
80107235:	6a 3d                	push   $0x3d
  jmp alltraps
80107237:	e9 bc f4 ff ff       	jmp    801066f8 <alltraps>

8010723c <vector62>:
.globl vector62
vector62:
  pushl $0
8010723c:	6a 00                	push   $0x0
  pushl $62
8010723e:	6a 3e                	push   $0x3e
  jmp alltraps
80107240:	e9 b3 f4 ff ff       	jmp    801066f8 <alltraps>

80107245 <vector63>:
.globl vector63
vector63:
  pushl $0
80107245:	6a 00                	push   $0x0
  pushl $63
80107247:	6a 3f                	push   $0x3f
  jmp alltraps
80107249:	e9 aa f4 ff ff       	jmp    801066f8 <alltraps>

8010724e <vector64>:
.globl vector64
vector64:
  pushl $0
8010724e:	6a 00                	push   $0x0
  pushl $64
80107250:	6a 40                	push   $0x40
  jmp alltraps
80107252:	e9 a1 f4 ff ff       	jmp    801066f8 <alltraps>

80107257 <vector65>:
.globl vector65
vector65:
  pushl $0
80107257:	6a 00                	push   $0x0
  pushl $65
80107259:	6a 41                	push   $0x41
  jmp alltraps
8010725b:	e9 98 f4 ff ff       	jmp    801066f8 <alltraps>

80107260 <vector66>:
.globl vector66
vector66:
  pushl $0
80107260:	6a 00                	push   $0x0
  pushl $66
80107262:	6a 42                	push   $0x42
  jmp alltraps
80107264:	e9 8f f4 ff ff       	jmp    801066f8 <alltraps>

80107269 <vector67>:
.globl vector67
vector67:
  pushl $0
80107269:	6a 00                	push   $0x0
  pushl $67
8010726b:	6a 43                	push   $0x43
  jmp alltraps
8010726d:	e9 86 f4 ff ff       	jmp    801066f8 <alltraps>

80107272 <vector68>:
.globl vector68
vector68:
  pushl $0
80107272:	6a 00                	push   $0x0
  pushl $68
80107274:	6a 44                	push   $0x44
  jmp alltraps
80107276:	e9 7d f4 ff ff       	jmp    801066f8 <alltraps>

8010727b <vector69>:
.globl vector69
vector69:
  pushl $0
8010727b:	6a 00                	push   $0x0
  pushl $69
8010727d:	6a 45                	push   $0x45
  jmp alltraps
8010727f:	e9 74 f4 ff ff       	jmp    801066f8 <alltraps>

80107284 <vector70>:
.globl vector70
vector70:
  pushl $0
80107284:	6a 00                	push   $0x0
  pushl $70
80107286:	6a 46                	push   $0x46
  jmp alltraps
80107288:	e9 6b f4 ff ff       	jmp    801066f8 <alltraps>

8010728d <vector71>:
.globl vector71
vector71:
  pushl $0
8010728d:	6a 00                	push   $0x0
  pushl $71
8010728f:	6a 47                	push   $0x47
  jmp alltraps
80107291:	e9 62 f4 ff ff       	jmp    801066f8 <alltraps>

80107296 <vector72>:
.globl vector72
vector72:
  pushl $0
80107296:	6a 00                	push   $0x0
  pushl $72
80107298:	6a 48                	push   $0x48
  jmp alltraps
8010729a:	e9 59 f4 ff ff       	jmp    801066f8 <alltraps>

8010729f <vector73>:
.globl vector73
vector73:
  pushl $0
8010729f:	6a 00                	push   $0x0
  pushl $73
801072a1:	6a 49                	push   $0x49
  jmp alltraps
801072a3:	e9 50 f4 ff ff       	jmp    801066f8 <alltraps>

801072a8 <vector74>:
.globl vector74
vector74:
  pushl $0
801072a8:	6a 00                	push   $0x0
  pushl $74
801072aa:	6a 4a                	push   $0x4a
  jmp alltraps
801072ac:	e9 47 f4 ff ff       	jmp    801066f8 <alltraps>

801072b1 <vector75>:
.globl vector75
vector75:
  pushl $0
801072b1:	6a 00                	push   $0x0
  pushl $75
801072b3:	6a 4b                	push   $0x4b
  jmp alltraps
801072b5:	e9 3e f4 ff ff       	jmp    801066f8 <alltraps>

801072ba <vector76>:
.globl vector76
vector76:
  pushl $0
801072ba:	6a 00                	push   $0x0
  pushl $76
801072bc:	6a 4c                	push   $0x4c
  jmp alltraps
801072be:	e9 35 f4 ff ff       	jmp    801066f8 <alltraps>

801072c3 <vector77>:
.globl vector77
vector77:
  pushl $0
801072c3:	6a 00                	push   $0x0
  pushl $77
801072c5:	6a 4d                	push   $0x4d
  jmp alltraps
801072c7:	e9 2c f4 ff ff       	jmp    801066f8 <alltraps>

801072cc <vector78>:
.globl vector78
vector78:
  pushl $0
801072cc:	6a 00                	push   $0x0
  pushl $78
801072ce:	6a 4e                	push   $0x4e
  jmp alltraps
801072d0:	e9 23 f4 ff ff       	jmp    801066f8 <alltraps>

801072d5 <vector79>:
.globl vector79
vector79:
  pushl $0
801072d5:	6a 00                	push   $0x0
  pushl $79
801072d7:	6a 4f                	push   $0x4f
  jmp alltraps
801072d9:	e9 1a f4 ff ff       	jmp    801066f8 <alltraps>

801072de <vector80>:
.globl vector80
vector80:
  pushl $0
801072de:	6a 00                	push   $0x0
  pushl $80
801072e0:	6a 50                	push   $0x50
  jmp alltraps
801072e2:	e9 11 f4 ff ff       	jmp    801066f8 <alltraps>

801072e7 <vector81>:
.globl vector81
vector81:
  pushl $0
801072e7:	6a 00                	push   $0x0
  pushl $81
801072e9:	6a 51                	push   $0x51
  jmp alltraps
801072eb:	e9 08 f4 ff ff       	jmp    801066f8 <alltraps>

801072f0 <vector82>:
.globl vector82
vector82:
  pushl $0
801072f0:	6a 00                	push   $0x0
  pushl $82
801072f2:	6a 52                	push   $0x52
  jmp alltraps
801072f4:	e9 ff f3 ff ff       	jmp    801066f8 <alltraps>

801072f9 <vector83>:
.globl vector83
vector83:
  pushl $0
801072f9:	6a 00                	push   $0x0
  pushl $83
801072fb:	6a 53                	push   $0x53
  jmp alltraps
801072fd:	e9 f6 f3 ff ff       	jmp    801066f8 <alltraps>

80107302 <vector84>:
.globl vector84
vector84:
  pushl $0
80107302:	6a 00                	push   $0x0
  pushl $84
80107304:	6a 54                	push   $0x54
  jmp alltraps
80107306:	e9 ed f3 ff ff       	jmp    801066f8 <alltraps>

8010730b <vector85>:
.globl vector85
vector85:
  pushl $0
8010730b:	6a 00                	push   $0x0
  pushl $85
8010730d:	6a 55                	push   $0x55
  jmp alltraps
8010730f:	e9 e4 f3 ff ff       	jmp    801066f8 <alltraps>

80107314 <vector86>:
.globl vector86
vector86:
  pushl $0
80107314:	6a 00                	push   $0x0
  pushl $86
80107316:	6a 56                	push   $0x56
  jmp alltraps
80107318:	e9 db f3 ff ff       	jmp    801066f8 <alltraps>

8010731d <vector87>:
.globl vector87
vector87:
  pushl $0
8010731d:	6a 00                	push   $0x0
  pushl $87
8010731f:	6a 57                	push   $0x57
  jmp alltraps
80107321:	e9 d2 f3 ff ff       	jmp    801066f8 <alltraps>

80107326 <vector88>:
.globl vector88
vector88:
  pushl $0
80107326:	6a 00                	push   $0x0
  pushl $88
80107328:	6a 58                	push   $0x58
  jmp alltraps
8010732a:	e9 c9 f3 ff ff       	jmp    801066f8 <alltraps>

8010732f <vector89>:
.globl vector89
vector89:
  pushl $0
8010732f:	6a 00                	push   $0x0
  pushl $89
80107331:	6a 59                	push   $0x59
  jmp alltraps
80107333:	e9 c0 f3 ff ff       	jmp    801066f8 <alltraps>

80107338 <vector90>:
.globl vector90
vector90:
  pushl $0
80107338:	6a 00                	push   $0x0
  pushl $90
8010733a:	6a 5a                	push   $0x5a
  jmp alltraps
8010733c:	e9 b7 f3 ff ff       	jmp    801066f8 <alltraps>

80107341 <vector91>:
.globl vector91
vector91:
  pushl $0
80107341:	6a 00                	push   $0x0
  pushl $91
80107343:	6a 5b                	push   $0x5b
  jmp alltraps
80107345:	e9 ae f3 ff ff       	jmp    801066f8 <alltraps>

8010734a <vector92>:
.globl vector92
vector92:
  pushl $0
8010734a:	6a 00                	push   $0x0
  pushl $92
8010734c:	6a 5c                	push   $0x5c
  jmp alltraps
8010734e:	e9 a5 f3 ff ff       	jmp    801066f8 <alltraps>

80107353 <vector93>:
.globl vector93
vector93:
  pushl $0
80107353:	6a 00                	push   $0x0
  pushl $93
80107355:	6a 5d                	push   $0x5d
  jmp alltraps
80107357:	e9 9c f3 ff ff       	jmp    801066f8 <alltraps>

8010735c <vector94>:
.globl vector94
vector94:
  pushl $0
8010735c:	6a 00                	push   $0x0
  pushl $94
8010735e:	6a 5e                	push   $0x5e
  jmp alltraps
80107360:	e9 93 f3 ff ff       	jmp    801066f8 <alltraps>

80107365 <vector95>:
.globl vector95
vector95:
  pushl $0
80107365:	6a 00                	push   $0x0
  pushl $95
80107367:	6a 5f                	push   $0x5f
  jmp alltraps
80107369:	e9 8a f3 ff ff       	jmp    801066f8 <alltraps>

8010736e <vector96>:
.globl vector96
vector96:
  pushl $0
8010736e:	6a 00                	push   $0x0
  pushl $96
80107370:	6a 60                	push   $0x60
  jmp alltraps
80107372:	e9 81 f3 ff ff       	jmp    801066f8 <alltraps>

80107377 <vector97>:
.globl vector97
vector97:
  pushl $0
80107377:	6a 00                	push   $0x0
  pushl $97
80107379:	6a 61                	push   $0x61
  jmp alltraps
8010737b:	e9 78 f3 ff ff       	jmp    801066f8 <alltraps>

80107380 <vector98>:
.globl vector98
vector98:
  pushl $0
80107380:	6a 00                	push   $0x0
  pushl $98
80107382:	6a 62                	push   $0x62
  jmp alltraps
80107384:	e9 6f f3 ff ff       	jmp    801066f8 <alltraps>

80107389 <vector99>:
.globl vector99
vector99:
  pushl $0
80107389:	6a 00                	push   $0x0
  pushl $99
8010738b:	6a 63                	push   $0x63
  jmp alltraps
8010738d:	e9 66 f3 ff ff       	jmp    801066f8 <alltraps>

80107392 <vector100>:
.globl vector100
vector100:
  pushl $0
80107392:	6a 00                	push   $0x0
  pushl $100
80107394:	6a 64                	push   $0x64
  jmp alltraps
80107396:	e9 5d f3 ff ff       	jmp    801066f8 <alltraps>

8010739b <vector101>:
.globl vector101
vector101:
  pushl $0
8010739b:	6a 00                	push   $0x0
  pushl $101
8010739d:	6a 65                	push   $0x65
  jmp alltraps
8010739f:	e9 54 f3 ff ff       	jmp    801066f8 <alltraps>

801073a4 <vector102>:
.globl vector102
vector102:
  pushl $0
801073a4:	6a 00                	push   $0x0
  pushl $102
801073a6:	6a 66                	push   $0x66
  jmp alltraps
801073a8:	e9 4b f3 ff ff       	jmp    801066f8 <alltraps>

801073ad <vector103>:
.globl vector103
vector103:
  pushl $0
801073ad:	6a 00                	push   $0x0
  pushl $103
801073af:	6a 67                	push   $0x67
  jmp alltraps
801073b1:	e9 42 f3 ff ff       	jmp    801066f8 <alltraps>

801073b6 <vector104>:
.globl vector104
vector104:
  pushl $0
801073b6:	6a 00                	push   $0x0
  pushl $104
801073b8:	6a 68                	push   $0x68
  jmp alltraps
801073ba:	e9 39 f3 ff ff       	jmp    801066f8 <alltraps>

801073bf <vector105>:
.globl vector105
vector105:
  pushl $0
801073bf:	6a 00                	push   $0x0
  pushl $105
801073c1:	6a 69                	push   $0x69
  jmp alltraps
801073c3:	e9 30 f3 ff ff       	jmp    801066f8 <alltraps>

801073c8 <vector106>:
.globl vector106
vector106:
  pushl $0
801073c8:	6a 00                	push   $0x0
  pushl $106
801073ca:	6a 6a                	push   $0x6a
  jmp alltraps
801073cc:	e9 27 f3 ff ff       	jmp    801066f8 <alltraps>

801073d1 <vector107>:
.globl vector107
vector107:
  pushl $0
801073d1:	6a 00                	push   $0x0
  pushl $107
801073d3:	6a 6b                	push   $0x6b
  jmp alltraps
801073d5:	e9 1e f3 ff ff       	jmp    801066f8 <alltraps>

801073da <vector108>:
.globl vector108
vector108:
  pushl $0
801073da:	6a 00                	push   $0x0
  pushl $108
801073dc:	6a 6c                	push   $0x6c
  jmp alltraps
801073de:	e9 15 f3 ff ff       	jmp    801066f8 <alltraps>

801073e3 <vector109>:
.globl vector109
vector109:
  pushl $0
801073e3:	6a 00                	push   $0x0
  pushl $109
801073e5:	6a 6d                	push   $0x6d
  jmp alltraps
801073e7:	e9 0c f3 ff ff       	jmp    801066f8 <alltraps>

801073ec <vector110>:
.globl vector110
vector110:
  pushl $0
801073ec:	6a 00                	push   $0x0
  pushl $110
801073ee:	6a 6e                	push   $0x6e
  jmp alltraps
801073f0:	e9 03 f3 ff ff       	jmp    801066f8 <alltraps>

801073f5 <vector111>:
.globl vector111
vector111:
  pushl $0
801073f5:	6a 00                	push   $0x0
  pushl $111
801073f7:	6a 6f                	push   $0x6f
  jmp alltraps
801073f9:	e9 fa f2 ff ff       	jmp    801066f8 <alltraps>

801073fe <vector112>:
.globl vector112
vector112:
  pushl $0
801073fe:	6a 00                	push   $0x0
  pushl $112
80107400:	6a 70                	push   $0x70
  jmp alltraps
80107402:	e9 f1 f2 ff ff       	jmp    801066f8 <alltraps>

80107407 <vector113>:
.globl vector113
vector113:
  pushl $0
80107407:	6a 00                	push   $0x0
  pushl $113
80107409:	6a 71                	push   $0x71
  jmp alltraps
8010740b:	e9 e8 f2 ff ff       	jmp    801066f8 <alltraps>

80107410 <vector114>:
.globl vector114
vector114:
  pushl $0
80107410:	6a 00                	push   $0x0
  pushl $114
80107412:	6a 72                	push   $0x72
  jmp alltraps
80107414:	e9 df f2 ff ff       	jmp    801066f8 <alltraps>

80107419 <vector115>:
.globl vector115
vector115:
  pushl $0
80107419:	6a 00                	push   $0x0
  pushl $115
8010741b:	6a 73                	push   $0x73
  jmp alltraps
8010741d:	e9 d6 f2 ff ff       	jmp    801066f8 <alltraps>

80107422 <vector116>:
.globl vector116
vector116:
  pushl $0
80107422:	6a 00                	push   $0x0
  pushl $116
80107424:	6a 74                	push   $0x74
  jmp alltraps
80107426:	e9 cd f2 ff ff       	jmp    801066f8 <alltraps>

8010742b <vector117>:
.globl vector117
vector117:
  pushl $0
8010742b:	6a 00                	push   $0x0
  pushl $117
8010742d:	6a 75                	push   $0x75
  jmp alltraps
8010742f:	e9 c4 f2 ff ff       	jmp    801066f8 <alltraps>

80107434 <vector118>:
.globl vector118
vector118:
  pushl $0
80107434:	6a 00                	push   $0x0
  pushl $118
80107436:	6a 76                	push   $0x76
  jmp alltraps
80107438:	e9 bb f2 ff ff       	jmp    801066f8 <alltraps>

8010743d <vector119>:
.globl vector119
vector119:
  pushl $0
8010743d:	6a 00                	push   $0x0
  pushl $119
8010743f:	6a 77                	push   $0x77
  jmp alltraps
80107441:	e9 b2 f2 ff ff       	jmp    801066f8 <alltraps>

80107446 <vector120>:
.globl vector120
vector120:
  pushl $0
80107446:	6a 00                	push   $0x0
  pushl $120
80107448:	6a 78                	push   $0x78
  jmp alltraps
8010744a:	e9 a9 f2 ff ff       	jmp    801066f8 <alltraps>

8010744f <vector121>:
.globl vector121
vector121:
  pushl $0
8010744f:	6a 00                	push   $0x0
  pushl $121
80107451:	6a 79                	push   $0x79
  jmp alltraps
80107453:	e9 a0 f2 ff ff       	jmp    801066f8 <alltraps>

80107458 <vector122>:
.globl vector122
vector122:
  pushl $0
80107458:	6a 00                	push   $0x0
  pushl $122
8010745a:	6a 7a                	push   $0x7a
  jmp alltraps
8010745c:	e9 97 f2 ff ff       	jmp    801066f8 <alltraps>

80107461 <vector123>:
.globl vector123
vector123:
  pushl $0
80107461:	6a 00                	push   $0x0
  pushl $123
80107463:	6a 7b                	push   $0x7b
  jmp alltraps
80107465:	e9 8e f2 ff ff       	jmp    801066f8 <alltraps>

8010746a <vector124>:
.globl vector124
vector124:
  pushl $0
8010746a:	6a 00                	push   $0x0
  pushl $124
8010746c:	6a 7c                	push   $0x7c
  jmp alltraps
8010746e:	e9 85 f2 ff ff       	jmp    801066f8 <alltraps>

80107473 <vector125>:
.globl vector125
vector125:
  pushl $0
80107473:	6a 00                	push   $0x0
  pushl $125
80107475:	6a 7d                	push   $0x7d
  jmp alltraps
80107477:	e9 7c f2 ff ff       	jmp    801066f8 <alltraps>

8010747c <vector126>:
.globl vector126
vector126:
  pushl $0
8010747c:	6a 00                	push   $0x0
  pushl $126
8010747e:	6a 7e                	push   $0x7e
  jmp alltraps
80107480:	e9 73 f2 ff ff       	jmp    801066f8 <alltraps>

80107485 <vector127>:
.globl vector127
vector127:
  pushl $0
80107485:	6a 00                	push   $0x0
  pushl $127
80107487:	6a 7f                	push   $0x7f
  jmp alltraps
80107489:	e9 6a f2 ff ff       	jmp    801066f8 <alltraps>

8010748e <vector128>:
.globl vector128
vector128:
  pushl $0
8010748e:	6a 00                	push   $0x0
  pushl $128
80107490:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80107495:	e9 5e f2 ff ff       	jmp    801066f8 <alltraps>

8010749a <vector129>:
.globl vector129
vector129:
  pushl $0
8010749a:	6a 00                	push   $0x0
  pushl $129
8010749c:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801074a1:	e9 52 f2 ff ff       	jmp    801066f8 <alltraps>

801074a6 <vector130>:
.globl vector130
vector130:
  pushl $0
801074a6:	6a 00                	push   $0x0
  pushl $130
801074a8:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801074ad:	e9 46 f2 ff ff       	jmp    801066f8 <alltraps>

801074b2 <vector131>:
.globl vector131
vector131:
  pushl $0
801074b2:	6a 00                	push   $0x0
  pushl $131
801074b4:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801074b9:	e9 3a f2 ff ff       	jmp    801066f8 <alltraps>

801074be <vector132>:
.globl vector132
vector132:
  pushl $0
801074be:	6a 00                	push   $0x0
  pushl $132
801074c0:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801074c5:	e9 2e f2 ff ff       	jmp    801066f8 <alltraps>

801074ca <vector133>:
.globl vector133
vector133:
  pushl $0
801074ca:	6a 00                	push   $0x0
  pushl $133
801074cc:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801074d1:	e9 22 f2 ff ff       	jmp    801066f8 <alltraps>

801074d6 <vector134>:
.globl vector134
vector134:
  pushl $0
801074d6:	6a 00                	push   $0x0
  pushl $134
801074d8:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801074dd:	e9 16 f2 ff ff       	jmp    801066f8 <alltraps>

801074e2 <vector135>:
.globl vector135
vector135:
  pushl $0
801074e2:	6a 00                	push   $0x0
  pushl $135
801074e4:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801074e9:	e9 0a f2 ff ff       	jmp    801066f8 <alltraps>

801074ee <vector136>:
.globl vector136
vector136:
  pushl $0
801074ee:	6a 00                	push   $0x0
  pushl $136
801074f0:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801074f5:	e9 fe f1 ff ff       	jmp    801066f8 <alltraps>

801074fa <vector137>:
.globl vector137
vector137:
  pushl $0
801074fa:	6a 00                	push   $0x0
  pushl $137
801074fc:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80107501:	e9 f2 f1 ff ff       	jmp    801066f8 <alltraps>

80107506 <vector138>:
.globl vector138
vector138:
  pushl $0
80107506:	6a 00                	push   $0x0
  pushl $138
80107508:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
8010750d:	e9 e6 f1 ff ff       	jmp    801066f8 <alltraps>

80107512 <vector139>:
.globl vector139
vector139:
  pushl $0
80107512:	6a 00                	push   $0x0
  pushl $139
80107514:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107519:	e9 da f1 ff ff       	jmp    801066f8 <alltraps>

8010751e <vector140>:
.globl vector140
vector140:
  pushl $0
8010751e:	6a 00                	push   $0x0
  pushl $140
80107520:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80107525:	e9 ce f1 ff ff       	jmp    801066f8 <alltraps>

8010752a <vector141>:
.globl vector141
vector141:
  pushl $0
8010752a:	6a 00                	push   $0x0
  pushl $141
8010752c:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80107531:	e9 c2 f1 ff ff       	jmp    801066f8 <alltraps>

80107536 <vector142>:
.globl vector142
vector142:
  pushl $0
80107536:	6a 00                	push   $0x0
  pushl $142
80107538:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
8010753d:	e9 b6 f1 ff ff       	jmp    801066f8 <alltraps>

80107542 <vector143>:
.globl vector143
vector143:
  pushl $0
80107542:	6a 00                	push   $0x0
  pushl $143
80107544:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107549:	e9 aa f1 ff ff       	jmp    801066f8 <alltraps>

8010754e <vector144>:
.globl vector144
vector144:
  pushl $0
8010754e:	6a 00                	push   $0x0
  pushl $144
80107550:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80107555:	e9 9e f1 ff ff       	jmp    801066f8 <alltraps>

8010755a <vector145>:
.globl vector145
vector145:
  pushl $0
8010755a:	6a 00                	push   $0x0
  pushl $145
8010755c:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80107561:	e9 92 f1 ff ff       	jmp    801066f8 <alltraps>

80107566 <vector146>:
.globl vector146
vector146:
  pushl $0
80107566:	6a 00                	push   $0x0
  pushl $146
80107568:	68 92 00 00 00       	push   $0x92
  jmp alltraps
8010756d:	e9 86 f1 ff ff       	jmp    801066f8 <alltraps>

80107572 <vector147>:
.globl vector147
vector147:
  pushl $0
80107572:	6a 00                	push   $0x0
  pushl $147
80107574:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107579:	e9 7a f1 ff ff       	jmp    801066f8 <alltraps>

8010757e <vector148>:
.globl vector148
vector148:
  pushl $0
8010757e:	6a 00                	push   $0x0
  pushl $148
80107580:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80107585:	e9 6e f1 ff ff       	jmp    801066f8 <alltraps>

8010758a <vector149>:
.globl vector149
vector149:
  pushl $0
8010758a:	6a 00                	push   $0x0
  pushl $149
8010758c:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80107591:	e9 62 f1 ff ff       	jmp    801066f8 <alltraps>

80107596 <vector150>:
.globl vector150
vector150:
  pushl $0
80107596:	6a 00                	push   $0x0
  pushl $150
80107598:	68 96 00 00 00       	push   $0x96
  jmp alltraps
8010759d:	e9 56 f1 ff ff       	jmp    801066f8 <alltraps>

801075a2 <vector151>:
.globl vector151
vector151:
  pushl $0
801075a2:	6a 00                	push   $0x0
  pushl $151
801075a4:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801075a9:	e9 4a f1 ff ff       	jmp    801066f8 <alltraps>

801075ae <vector152>:
.globl vector152
vector152:
  pushl $0
801075ae:	6a 00                	push   $0x0
  pushl $152
801075b0:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801075b5:	e9 3e f1 ff ff       	jmp    801066f8 <alltraps>

801075ba <vector153>:
.globl vector153
vector153:
  pushl $0
801075ba:	6a 00                	push   $0x0
  pushl $153
801075bc:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801075c1:	e9 32 f1 ff ff       	jmp    801066f8 <alltraps>

801075c6 <vector154>:
.globl vector154
vector154:
  pushl $0
801075c6:	6a 00                	push   $0x0
  pushl $154
801075c8:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801075cd:	e9 26 f1 ff ff       	jmp    801066f8 <alltraps>

801075d2 <vector155>:
.globl vector155
vector155:
  pushl $0
801075d2:	6a 00                	push   $0x0
  pushl $155
801075d4:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801075d9:	e9 1a f1 ff ff       	jmp    801066f8 <alltraps>

801075de <vector156>:
.globl vector156
vector156:
  pushl $0
801075de:	6a 00                	push   $0x0
  pushl $156
801075e0:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801075e5:	e9 0e f1 ff ff       	jmp    801066f8 <alltraps>

801075ea <vector157>:
.globl vector157
vector157:
  pushl $0
801075ea:	6a 00                	push   $0x0
  pushl $157
801075ec:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801075f1:	e9 02 f1 ff ff       	jmp    801066f8 <alltraps>

801075f6 <vector158>:
.globl vector158
vector158:
  pushl $0
801075f6:	6a 00                	push   $0x0
  pushl $158
801075f8:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801075fd:	e9 f6 f0 ff ff       	jmp    801066f8 <alltraps>

80107602 <vector159>:
.globl vector159
vector159:
  pushl $0
80107602:	6a 00                	push   $0x0
  pushl $159
80107604:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107609:	e9 ea f0 ff ff       	jmp    801066f8 <alltraps>

8010760e <vector160>:
.globl vector160
vector160:
  pushl $0
8010760e:	6a 00                	push   $0x0
  pushl $160
80107610:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80107615:	e9 de f0 ff ff       	jmp    801066f8 <alltraps>

8010761a <vector161>:
.globl vector161
vector161:
  pushl $0
8010761a:	6a 00                	push   $0x0
  pushl $161
8010761c:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80107621:	e9 d2 f0 ff ff       	jmp    801066f8 <alltraps>

80107626 <vector162>:
.globl vector162
vector162:
  pushl $0
80107626:	6a 00                	push   $0x0
  pushl $162
80107628:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
8010762d:	e9 c6 f0 ff ff       	jmp    801066f8 <alltraps>

80107632 <vector163>:
.globl vector163
vector163:
  pushl $0
80107632:	6a 00                	push   $0x0
  pushl $163
80107634:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107639:	e9 ba f0 ff ff       	jmp    801066f8 <alltraps>

8010763e <vector164>:
.globl vector164
vector164:
  pushl $0
8010763e:	6a 00                	push   $0x0
  pushl $164
80107640:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107645:	e9 ae f0 ff ff       	jmp    801066f8 <alltraps>

8010764a <vector165>:
.globl vector165
vector165:
  pushl $0
8010764a:	6a 00                	push   $0x0
  pushl $165
8010764c:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80107651:	e9 a2 f0 ff ff       	jmp    801066f8 <alltraps>

80107656 <vector166>:
.globl vector166
vector166:
  pushl $0
80107656:	6a 00                	push   $0x0
  pushl $166
80107658:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
8010765d:	e9 96 f0 ff ff       	jmp    801066f8 <alltraps>

80107662 <vector167>:
.globl vector167
vector167:
  pushl $0
80107662:	6a 00                	push   $0x0
  pushl $167
80107664:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107669:	e9 8a f0 ff ff       	jmp    801066f8 <alltraps>

8010766e <vector168>:
.globl vector168
vector168:
  pushl $0
8010766e:	6a 00                	push   $0x0
  pushl $168
80107670:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107675:	e9 7e f0 ff ff       	jmp    801066f8 <alltraps>

8010767a <vector169>:
.globl vector169
vector169:
  pushl $0
8010767a:	6a 00                	push   $0x0
  pushl $169
8010767c:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80107681:	e9 72 f0 ff ff       	jmp    801066f8 <alltraps>

80107686 <vector170>:
.globl vector170
vector170:
  pushl $0
80107686:	6a 00                	push   $0x0
  pushl $170
80107688:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
8010768d:	e9 66 f0 ff ff       	jmp    801066f8 <alltraps>

80107692 <vector171>:
.globl vector171
vector171:
  pushl $0
80107692:	6a 00                	push   $0x0
  pushl $171
80107694:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107699:	e9 5a f0 ff ff       	jmp    801066f8 <alltraps>

8010769e <vector172>:
.globl vector172
vector172:
  pushl $0
8010769e:	6a 00                	push   $0x0
  pushl $172
801076a0:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801076a5:	e9 4e f0 ff ff       	jmp    801066f8 <alltraps>

801076aa <vector173>:
.globl vector173
vector173:
  pushl $0
801076aa:	6a 00                	push   $0x0
  pushl $173
801076ac:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801076b1:	e9 42 f0 ff ff       	jmp    801066f8 <alltraps>

801076b6 <vector174>:
.globl vector174
vector174:
  pushl $0
801076b6:	6a 00                	push   $0x0
  pushl $174
801076b8:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801076bd:	e9 36 f0 ff ff       	jmp    801066f8 <alltraps>

801076c2 <vector175>:
.globl vector175
vector175:
  pushl $0
801076c2:	6a 00                	push   $0x0
  pushl $175
801076c4:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801076c9:	e9 2a f0 ff ff       	jmp    801066f8 <alltraps>

801076ce <vector176>:
.globl vector176
vector176:
  pushl $0
801076ce:	6a 00                	push   $0x0
  pushl $176
801076d0:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801076d5:	e9 1e f0 ff ff       	jmp    801066f8 <alltraps>

801076da <vector177>:
.globl vector177
vector177:
  pushl $0
801076da:	6a 00                	push   $0x0
  pushl $177
801076dc:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801076e1:	e9 12 f0 ff ff       	jmp    801066f8 <alltraps>

801076e6 <vector178>:
.globl vector178
vector178:
  pushl $0
801076e6:	6a 00                	push   $0x0
  pushl $178
801076e8:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801076ed:	e9 06 f0 ff ff       	jmp    801066f8 <alltraps>

801076f2 <vector179>:
.globl vector179
vector179:
  pushl $0
801076f2:	6a 00                	push   $0x0
  pushl $179
801076f4:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801076f9:	e9 fa ef ff ff       	jmp    801066f8 <alltraps>

801076fe <vector180>:
.globl vector180
vector180:
  pushl $0
801076fe:	6a 00                	push   $0x0
  pushl $180
80107700:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107705:	e9 ee ef ff ff       	jmp    801066f8 <alltraps>

8010770a <vector181>:
.globl vector181
vector181:
  pushl $0
8010770a:	6a 00                	push   $0x0
  pushl $181
8010770c:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80107711:	e9 e2 ef ff ff       	jmp    801066f8 <alltraps>

80107716 <vector182>:
.globl vector182
vector182:
  pushl $0
80107716:	6a 00                	push   $0x0
  pushl $182
80107718:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
8010771d:	e9 d6 ef ff ff       	jmp    801066f8 <alltraps>

80107722 <vector183>:
.globl vector183
vector183:
  pushl $0
80107722:	6a 00                	push   $0x0
  pushl $183
80107724:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107729:	e9 ca ef ff ff       	jmp    801066f8 <alltraps>

8010772e <vector184>:
.globl vector184
vector184:
  pushl $0
8010772e:	6a 00                	push   $0x0
  pushl $184
80107730:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107735:	e9 be ef ff ff       	jmp    801066f8 <alltraps>

8010773a <vector185>:
.globl vector185
vector185:
  pushl $0
8010773a:	6a 00                	push   $0x0
  pushl $185
8010773c:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80107741:	e9 b2 ef ff ff       	jmp    801066f8 <alltraps>

80107746 <vector186>:
.globl vector186
vector186:
  pushl $0
80107746:	6a 00                	push   $0x0
  pushl $186
80107748:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
8010774d:	e9 a6 ef ff ff       	jmp    801066f8 <alltraps>

80107752 <vector187>:
.globl vector187
vector187:
  pushl $0
80107752:	6a 00                	push   $0x0
  pushl $187
80107754:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107759:	e9 9a ef ff ff       	jmp    801066f8 <alltraps>

8010775e <vector188>:
.globl vector188
vector188:
  pushl $0
8010775e:	6a 00                	push   $0x0
  pushl $188
80107760:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107765:	e9 8e ef ff ff       	jmp    801066f8 <alltraps>

8010776a <vector189>:
.globl vector189
vector189:
  pushl $0
8010776a:	6a 00                	push   $0x0
  pushl $189
8010776c:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80107771:	e9 82 ef ff ff       	jmp    801066f8 <alltraps>

80107776 <vector190>:
.globl vector190
vector190:
  pushl $0
80107776:	6a 00                	push   $0x0
  pushl $190
80107778:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
8010777d:	e9 76 ef ff ff       	jmp    801066f8 <alltraps>

80107782 <vector191>:
.globl vector191
vector191:
  pushl $0
80107782:	6a 00                	push   $0x0
  pushl $191
80107784:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107789:	e9 6a ef ff ff       	jmp    801066f8 <alltraps>

8010778e <vector192>:
.globl vector192
vector192:
  pushl $0
8010778e:	6a 00                	push   $0x0
  pushl $192
80107790:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107795:	e9 5e ef ff ff       	jmp    801066f8 <alltraps>

8010779a <vector193>:
.globl vector193
vector193:
  pushl $0
8010779a:	6a 00                	push   $0x0
  pushl $193
8010779c:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801077a1:	e9 52 ef ff ff       	jmp    801066f8 <alltraps>

801077a6 <vector194>:
.globl vector194
vector194:
  pushl $0
801077a6:	6a 00                	push   $0x0
  pushl $194
801077a8:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801077ad:	e9 46 ef ff ff       	jmp    801066f8 <alltraps>

801077b2 <vector195>:
.globl vector195
vector195:
  pushl $0
801077b2:	6a 00                	push   $0x0
  pushl $195
801077b4:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801077b9:	e9 3a ef ff ff       	jmp    801066f8 <alltraps>

801077be <vector196>:
.globl vector196
vector196:
  pushl $0
801077be:	6a 00                	push   $0x0
  pushl $196
801077c0:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801077c5:	e9 2e ef ff ff       	jmp    801066f8 <alltraps>

801077ca <vector197>:
.globl vector197
vector197:
  pushl $0
801077ca:	6a 00                	push   $0x0
  pushl $197
801077cc:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801077d1:	e9 22 ef ff ff       	jmp    801066f8 <alltraps>

801077d6 <vector198>:
.globl vector198
vector198:
  pushl $0
801077d6:	6a 00                	push   $0x0
  pushl $198
801077d8:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801077dd:	e9 16 ef ff ff       	jmp    801066f8 <alltraps>

801077e2 <vector199>:
.globl vector199
vector199:
  pushl $0
801077e2:	6a 00                	push   $0x0
  pushl $199
801077e4:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801077e9:	e9 0a ef ff ff       	jmp    801066f8 <alltraps>

801077ee <vector200>:
.globl vector200
vector200:
  pushl $0
801077ee:	6a 00                	push   $0x0
  pushl $200
801077f0:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801077f5:	e9 fe ee ff ff       	jmp    801066f8 <alltraps>

801077fa <vector201>:
.globl vector201
vector201:
  pushl $0
801077fa:	6a 00                	push   $0x0
  pushl $201
801077fc:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80107801:	e9 f2 ee ff ff       	jmp    801066f8 <alltraps>

80107806 <vector202>:
.globl vector202
vector202:
  pushl $0
80107806:	6a 00                	push   $0x0
  pushl $202
80107808:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
8010780d:	e9 e6 ee ff ff       	jmp    801066f8 <alltraps>

80107812 <vector203>:
.globl vector203
vector203:
  pushl $0
80107812:	6a 00                	push   $0x0
  pushl $203
80107814:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107819:	e9 da ee ff ff       	jmp    801066f8 <alltraps>

8010781e <vector204>:
.globl vector204
vector204:
  pushl $0
8010781e:	6a 00                	push   $0x0
  pushl $204
80107820:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107825:	e9 ce ee ff ff       	jmp    801066f8 <alltraps>

8010782a <vector205>:
.globl vector205
vector205:
  pushl $0
8010782a:	6a 00                	push   $0x0
  pushl $205
8010782c:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80107831:	e9 c2 ee ff ff       	jmp    801066f8 <alltraps>

80107836 <vector206>:
.globl vector206
vector206:
  pushl $0
80107836:	6a 00                	push   $0x0
  pushl $206
80107838:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
8010783d:	e9 b6 ee ff ff       	jmp    801066f8 <alltraps>

80107842 <vector207>:
.globl vector207
vector207:
  pushl $0
80107842:	6a 00                	push   $0x0
  pushl $207
80107844:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107849:	e9 aa ee ff ff       	jmp    801066f8 <alltraps>

8010784e <vector208>:
.globl vector208
vector208:
  pushl $0
8010784e:	6a 00                	push   $0x0
  pushl $208
80107850:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107855:	e9 9e ee ff ff       	jmp    801066f8 <alltraps>

8010785a <vector209>:
.globl vector209
vector209:
  pushl $0
8010785a:	6a 00                	push   $0x0
  pushl $209
8010785c:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107861:	e9 92 ee ff ff       	jmp    801066f8 <alltraps>

80107866 <vector210>:
.globl vector210
vector210:
  pushl $0
80107866:	6a 00                	push   $0x0
  pushl $210
80107868:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
8010786d:	e9 86 ee ff ff       	jmp    801066f8 <alltraps>

80107872 <vector211>:
.globl vector211
vector211:
  pushl $0
80107872:	6a 00                	push   $0x0
  pushl $211
80107874:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107879:	e9 7a ee ff ff       	jmp    801066f8 <alltraps>

8010787e <vector212>:
.globl vector212
vector212:
  pushl $0
8010787e:	6a 00                	push   $0x0
  pushl $212
80107880:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107885:	e9 6e ee ff ff       	jmp    801066f8 <alltraps>

8010788a <vector213>:
.globl vector213
vector213:
  pushl $0
8010788a:	6a 00                	push   $0x0
  pushl $213
8010788c:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107891:	e9 62 ee ff ff       	jmp    801066f8 <alltraps>

80107896 <vector214>:
.globl vector214
vector214:
  pushl $0
80107896:	6a 00                	push   $0x0
  pushl $214
80107898:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
8010789d:	e9 56 ee ff ff       	jmp    801066f8 <alltraps>

801078a2 <vector215>:
.globl vector215
vector215:
  pushl $0
801078a2:	6a 00                	push   $0x0
  pushl $215
801078a4:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801078a9:	e9 4a ee ff ff       	jmp    801066f8 <alltraps>

801078ae <vector216>:
.globl vector216
vector216:
  pushl $0
801078ae:	6a 00                	push   $0x0
  pushl $216
801078b0:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801078b5:	e9 3e ee ff ff       	jmp    801066f8 <alltraps>

801078ba <vector217>:
.globl vector217
vector217:
  pushl $0
801078ba:	6a 00                	push   $0x0
  pushl $217
801078bc:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801078c1:	e9 32 ee ff ff       	jmp    801066f8 <alltraps>

801078c6 <vector218>:
.globl vector218
vector218:
  pushl $0
801078c6:	6a 00                	push   $0x0
  pushl $218
801078c8:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801078cd:	e9 26 ee ff ff       	jmp    801066f8 <alltraps>

801078d2 <vector219>:
.globl vector219
vector219:
  pushl $0
801078d2:	6a 00                	push   $0x0
  pushl $219
801078d4:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801078d9:	e9 1a ee ff ff       	jmp    801066f8 <alltraps>

801078de <vector220>:
.globl vector220
vector220:
  pushl $0
801078de:	6a 00                	push   $0x0
  pushl $220
801078e0:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801078e5:	e9 0e ee ff ff       	jmp    801066f8 <alltraps>

801078ea <vector221>:
.globl vector221
vector221:
  pushl $0
801078ea:	6a 00                	push   $0x0
  pushl $221
801078ec:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801078f1:	e9 02 ee ff ff       	jmp    801066f8 <alltraps>

801078f6 <vector222>:
.globl vector222
vector222:
  pushl $0
801078f6:	6a 00                	push   $0x0
  pushl $222
801078f8:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801078fd:	e9 f6 ed ff ff       	jmp    801066f8 <alltraps>

80107902 <vector223>:
.globl vector223
vector223:
  pushl $0
80107902:	6a 00                	push   $0x0
  pushl $223
80107904:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107909:	e9 ea ed ff ff       	jmp    801066f8 <alltraps>

8010790e <vector224>:
.globl vector224
vector224:
  pushl $0
8010790e:	6a 00                	push   $0x0
  pushl $224
80107910:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107915:	e9 de ed ff ff       	jmp    801066f8 <alltraps>

8010791a <vector225>:
.globl vector225
vector225:
  pushl $0
8010791a:	6a 00                	push   $0x0
  pushl $225
8010791c:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107921:	e9 d2 ed ff ff       	jmp    801066f8 <alltraps>

80107926 <vector226>:
.globl vector226
vector226:
  pushl $0
80107926:	6a 00                	push   $0x0
  pushl $226
80107928:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
8010792d:	e9 c6 ed ff ff       	jmp    801066f8 <alltraps>

80107932 <vector227>:
.globl vector227
vector227:
  pushl $0
80107932:	6a 00                	push   $0x0
  pushl $227
80107934:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107939:	e9 ba ed ff ff       	jmp    801066f8 <alltraps>

8010793e <vector228>:
.globl vector228
vector228:
  pushl $0
8010793e:	6a 00                	push   $0x0
  pushl $228
80107940:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107945:	e9 ae ed ff ff       	jmp    801066f8 <alltraps>

8010794a <vector229>:
.globl vector229
vector229:
  pushl $0
8010794a:	6a 00                	push   $0x0
  pushl $229
8010794c:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107951:	e9 a2 ed ff ff       	jmp    801066f8 <alltraps>

80107956 <vector230>:
.globl vector230
vector230:
  pushl $0
80107956:	6a 00                	push   $0x0
  pushl $230
80107958:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
8010795d:	e9 96 ed ff ff       	jmp    801066f8 <alltraps>

80107962 <vector231>:
.globl vector231
vector231:
  pushl $0
80107962:	6a 00                	push   $0x0
  pushl $231
80107964:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107969:	e9 8a ed ff ff       	jmp    801066f8 <alltraps>

8010796e <vector232>:
.globl vector232
vector232:
  pushl $0
8010796e:	6a 00                	push   $0x0
  pushl $232
80107970:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107975:	e9 7e ed ff ff       	jmp    801066f8 <alltraps>

8010797a <vector233>:
.globl vector233
vector233:
  pushl $0
8010797a:	6a 00                	push   $0x0
  pushl $233
8010797c:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107981:	e9 72 ed ff ff       	jmp    801066f8 <alltraps>

80107986 <vector234>:
.globl vector234
vector234:
  pushl $0
80107986:	6a 00                	push   $0x0
  pushl $234
80107988:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
8010798d:	e9 66 ed ff ff       	jmp    801066f8 <alltraps>

80107992 <vector235>:
.globl vector235
vector235:
  pushl $0
80107992:	6a 00                	push   $0x0
  pushl $235
80107994:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107999:	e9 5a ed ff ff       	jmp    801066f8 <alltraps>

8010799e <vector236>:
.globl vector236
vector236:
  pushl $0
8010799e:	6a 00                	push   $0x0
  pushl $236
801079a0:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801079a5:	e9 4e ed ff ff       	jmp    801066f8 <alltraps>

801079aa <vector237>:
.globl vector237
vector237:
  pushl $0
801079aa:	6a 00                	push   $0x0
  pushl $237
801079ac:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801079b1:	e9 42 ed ff ff       	jmp    801066f8 <alltraps>

801079b6 <vector238>:
.globl vector238
vector238:
  pushl $0
801079b6:	6a 00                	push   $0x0
  pushl $238
801079b8:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801079bd:	e9 36 ed ff ff       	jmp    801066f8 <alltraps>

801079c2 <vector239>:
.globl vector239
vector239:
  pushl $0
801079c2:	6a 00                	push   $0x0
  pushl $239
801079c4:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801079c9:	e9 2a ed ff ff       	jmp    801066f8 <alltraps>

801079ce <vector240>:
.globl vector240
vector240:
  pushl $0
801079ce:	6a 00                	push   $0x0
  pushl $240
801079d0:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801079d5:	e9 1e ed ff ff       	jmp    801066f8 <alltraps>

801079da <vector241>:
.globl vector241
vector241:
  pushl $0
801079da:	6a 00                	push   $0x0
  pushl $241
801079dc:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801079e1:	e9 12 ed ff ff       	jmp    801066f8 <alltraps>

801079e6 <vector242>:
.globl vector242
vector242:
  pushl $0
801079e6:	6a 00                	push   $0x0
  pushl $242
801079e8:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801079ed:	e9 06 ed ff ff       	jmp    801066f8 <alltraps>

801079f2 <vector243>:
.globl vector243
vector243:
  pushl $0
801079f2:	6a 00                	push   $0x0
  pushl $243
801079f4:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801079f9:	e9 fa ec ff ff       	jmp    801066f8 <alltraps>

801079fe <vector244>:
.globl vector244
vector244:
  pushl $0
801079fe:	6a 00                	push   $0x0
  pushl $244
80107a00:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107a05:	e9 ee ec ff ff       	jmp    801066f8 <alltraps>

80107a0a <vector245>:
.globl vector245
vector245:
  pushl $0
80107a0a:	6a 00                	push   $0x0
  pushl $245
80107a0c:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107a11:	e9 e2 ec ff ff       	jmp    801066f8 <alltraps>

80107a16 <vector246>:
.globl vector246
vector246:
  pushl $0
80107a16:	6a 00                	push   $0x0
  pushl $246
80107a18:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107a1d:	e9 d6 ec ff ff       	jmp    801066f8 <alltraps>

80107a22 <vector247>:
.globl vector247
vector247:
  pushl $0
80107a22:	6a 00                	push   $0x0
  pushl $247
80107a24:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107a29:	e9 ca ec ff ff       	jmp    801066f8 <alltraps>

80107a2e <vector248>:
.globl vector248
vector248:
  pushl $0
80107a2e:	6a 00                	push   $0x0
  pushl $248
80107a30:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107a35:	e9 be ec ff ff       	jmp    801066f8 <alltraps>

80107a3a <vector249>:
.globl vector249
vector249:
  pushl $0
80107a3a:	6a 00                	push   $0x0
  pushl $249
80107a3c:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107a41:	e9 b2 ec ff ff       	jmp    801066f8 <alltraps>

80107a46 <vector250>:
.globl vector250
vector250:
  pushl $0
80107a46:	6a 00                	push   $0x0
  pushl $250
80107a48:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107a4d:	e9 a6 ec ff ff       	jmp    801066f8 <alltraps>

80107a52 <vector251>:
.globl vector251
vector251:
  pushl $0
80107a52:	6a 00                	push   $0x0
  pushl $251
80107a54:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107a59:	e9 9a ec ff ff       	jmp    801066f8 <alltraps>

80107a5e <vector252>:
.globl vector252
vector252:
  pushl $0
80107a5e:	6a 00                	push   $0x0
  pushl $252
80107a60:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107a65:	e9 8e ec ff ff       	jmp    801066f8 <alltraps>

80107a6a <vector253>:
.globl vector253
vector253:
  pushl $0
80107a6a:	6a 00                	push   $0x0
  pushl $253
80107a6c:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107a71:	e9 82 ec ff ff       	jmp    801066f8 <alltraps>

80107a76 <vector254>:
.globl vector254
vector254:
  pushl $0
80107a76:	6a 00                	push   $0x0
  pushl $254
80107a78:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107a7d:	e9 76 ec ff ff       	jmp    801066f8 <alltraps>

80107a82 <vector255>:
.globl vector255
vector255:
  pushl $0
80107a82:	6a 00                	push   $0x0
  pushl $255
80107a84:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107a89:	e9 6a ec ff ff       	jmp    801066f8 <alltraps>
	...

80107a90 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80107a90:	55                   	push   %ebp
80107a91:	89 e5                	mov    %esp,%ebp
80107a93:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80107a96:	8b 45 0c             	mov    0xc(%ebp),%eax
80107a99:	83 e8 01             	sub    $0x1,%eax
80107a9c:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107aa0:	8b 45 08             	mov    0x8(%ebp),%eax
80107aa3:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107aa7:	8b 45 08             	mov    0x8(%ebp),%eax
80107aaa:	c1 e8 10             	shr    $0x10,%eax
80107aad:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80107ab1:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107ab4:	0f 01 10             	lgdtl  (%eax)
}
80107ab7:	c9                   	leave  
80107ab8:	c3                   	ret    

80107ab9 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80107ab9:	55                   	push   %ebp
80107aba:	89 e5                	mov    %esp,%ebp
80107abc:	83 ec 04             	sub    $0x4,%esp
80107abf:	8b 45 08             	mov    0x8(%ebp),%eax
80107ac2:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107ac6:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107aca:	0f 00 d8             	ltr    %ax
}
80107acd:	c9                   	leave  
80107ace:	c3                   	ret    

80107acf <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80107acf:	55                   	push   %ebp
80107ad0:	89 e5                	mov    %esp,%ebp
80107ad2:	83 ec 04             	sub    $0x4,%esp
80107ad5:	8b 45 08             	mov    0x8(%ebp),%eax
80107ad8:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80107adc:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107ae0:	8e e8                	mov    %eax,%gs
}
80107ae2:	c9                   	leave  
80107ae3:	c3                   	ret    

80107ae4 <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
80107ae4:	55                   	push   %ebp
80107ae5:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107ae7:	8b 45 08             	mov    0x8(%ebp),%eax
80107aea:	0f 22 d8             	mov    %eax,%cr3
}
80107aed:	5d                   	pop    %ebp
80107aee:	c3                   	ret    

80107aef <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80107aef:	55                   	push   %ebp
80107af0:	89 e5                	mov    %esp,%ebp
80107af2:	8b 45 08             	mov    0x8(%ebp),%eax
80107af5:	2d 00 00 00 80       	sub    $0x80000000,%eax
80107afa:	5d                   	pop    %ebp
80107afb:	c3                   	ret    

80107afc <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80107afc:	55                   	push   %ebp
80107afd:	89 e5                	mov    %esp,%ebp
80107aff:	8b 45 08             	mov    0x8(%ebp),%eax
80107b02:	2d 00 00 00 80       	sub    $0x80000000,%eax
80107b07:	5d                   	pop    %ebp
80107b08:	c3                   	ret    

80107b09 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107b09:	55                   	push   %ebp
80107b0a:	89 e5                	mov    %esp,%ebp
80107b0c:	53                   	push   %ebx
80107b0d:	83 ec 24             	sub    $0x24,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80107b10:	e8 50 b4 ff ff       	call   80102f65 <cpunum>
80107b15:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80107b1b:	05 80 33 11 80       	add    $0x80113380,%eax
80107b20:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107b23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b26:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107b2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b2f:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b38:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b3f:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107b43:	83 e2 f0             	and    $0xfffffff0,%edx
80107b46:	83 ca 0a             	or     $0xa,%edx
80107b49:	88 50 7d             	mov    %dl,0x7d(%eax)
80107b4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b4f:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107b53:	83 ca 10             	or     $0x10,%edx
80107b56:	88 50 7d             	mov    %dl,0x7d(%eax)
80107b59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b5c:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107b60:	83 e2 9f             	and    $0xffffff9f,%edx
80107b63:	88 50 7d             	mov    %dl,0x7d(%eax)
80107b66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b69:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107b6d:	83 ca 80             	or     $0xffffff80,%edx
80107b70:	88 50 7d             	mov    %dl,0x7d(%eax)
80107b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b76:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107b7a:	83 ca 0f             	or     $0xf,%edx
80107b7d:	88 50 7e             	mov    %dl,0x7e(%eax)
80107b80:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b83:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107b87:	83 e2 ef             	and    $0xffffffef,%edx
80107b8a:	88 50 7e             	mov    %dl,0x7e(%eax)
80107b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b90:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107b94:	83 e2 df             	and    $0xffffffdf,%edx
80107b97:	88 50 7e             	mov    %dl,0x7e(%eax)
80107b9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b9d:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107ba1:	83 ca 40             	or     $0x40,%edx
80107ba4:	88 50 7e             	mov    %dl,0x7e(%eax)
80107ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107baa:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107bae:	83 ca 80             	or     $0xffffff80,%edx
80107bb1:	88 50 7e             	mov    %dl,0x7e(%eax)
80107bb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bb7:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107bbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bbe:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107bc5:	ff ff 
80107bc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bca:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107bd1:	00 00 
80107bd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bd6:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107bdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107be0:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107be7:	83 e2 f0             	and    $0xfffffff0,%edx
80107bea:	83 ca 02             	or     $0x2,%edx
80107bed:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107bf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bf6:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107bfd:	83 ca 10             	or     $0x10,%edx
80107c00:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107c06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c09:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107c10:	83 e2 9f             	and    $0xffffff9f,%edx
80107c13:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c1c:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107c23:	83 ca 80             	or     $0xffffff80,%edx
80107c26:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107c2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c2f:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107c36:	83 ca 0f             	or     $0xf,%edx
80107c39:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107c3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c42:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107c49:	83 e2 ef             	and    $0xffffffef,%edx
80107c4c:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107c52:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c55:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107c5c:	83 e2 df             	and    $0xffffffdf,%edx
80107c5f:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107c65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c68:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107c6f:	83 ca 40             	or     $0x40,%edx
80107c72:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107c78:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c7b:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107c82:	83 ca 80             	or     $0xffffff80,%edx
80107c85:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107c8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c8e:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107c95:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c98:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80107c9f:	ff ff 
80107ca1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ca4:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107cab:	00 00 
80107cad:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cb0:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107cb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cba:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107cc1:	83 e2 f0             	and    $0xfffffff0,%edx
80107cc4:	83 ca 0a             	or     $0xa,%edx
80107cc7:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107ccd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cd0:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107cd7:	83 ca 10             	or     $0x10,%edx
80107cda:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107ce0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ce3:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107cea:	83 ca 60             	or     $0x60,%edx
80107ced:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107cf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cf6:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107cfd:	83 ca 80             	or     $0xffffff80,%edx
80107d00:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107d06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d09:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107d10:	83 ca 0f             	or     $0xf,%edx
80107d13:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107d19:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d1c:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107d23:	83 e2 ef             	and    $0xffffffef,%edx
80107d26:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107d2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d2f:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107d36:	83 e2 df             	and    $0xffffffdf,%edx
80107d39:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107d3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d42:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107d49:	83 ca 40             	or     $0x40,%edx
80107d4c:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107d52:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d55:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107d5c:	83 ca 80             	or     $0xffffff80,%edx
80107d5f:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107d65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d68:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d72:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80107d79:	ff ff 
80107d7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d7e:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80107d85:	00 00 
80107d87:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d8a:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80107d91:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d94:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107d9b:	83 e2 f0             	and    $0xfffffff0,%edx
80107d9e:	83 ca 02             	or     $0x2,%edx
80107da1:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107da7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107daa:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107db1:	83 ca 10             	or     $0x10,%edx
80107db4:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107dba:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dbd:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107dc4:	83 ca 60             	or     $0x60,%edx
80107dc7:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107dcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dd0:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107dd7:	83 ca 80             	or     $0xffffff80,%edx
80107dda:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107de0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107de3:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107dea:	83 ca 0f             	or     $0xf,%edx
80107ded:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107df3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107df6:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107dfd:	83 e2 ef             	and    $0xffffffef,%edx
80107e00:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107e06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e09:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107e10:	83 e2 df             	and    $0xffffffdf,%edx
80107e13:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107e19:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e1c:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107e23:	83 ca 40             	or     $0x40,%edx
80107e26:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107e2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e2f:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107e36:	83 ca 80             	or     $0xffffff80,%edx
80107e39:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107e3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e42:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80107e49:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e4c:	05 b4 00 00 00       	add    $0xb4,%eax
80107e51:	89 c3                	mov    %eax,%ebx
80107e53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e56:	05 b4 00 00 00       	add    $0xb4,%eax
80107e5b:	c1 e8 10             	shr    $0x10,%eax
80107e5e:	89 c1                	mov    %eax,%ecx
80107e60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e63:	05 b4 00 00 00       	add    $0xb4,%eax
80107e68:	c1 e8 18             	shr    $0x18,%eax
80107e6b:	89 c2                	mov    %eax,%edx
80107e6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e70:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80107e77:	00 00 
80107e79:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e7c:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80107e83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e86:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
80107e8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e8f:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107e96:	83 e1 f0             	and    $0xfffffff0,%ecx
80107e99:	83 c9 02             	or     $0x2,%ecx
80107e9c:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107ea2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ea5:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107eac:	83 c9 10             	or     $0x10,%ecx
80107eaf:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107eb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eb8:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107ebf:	83 e1 9f             	and    $0xffffff9f,%ecx
80107ec2:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107ec8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ecb:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107ed2:	83 c9 80             	or     $0xffffff80,%ecx
80107ed5:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107edb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ede:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107ee5:	83 e1 f0             	and    $0xfffffff0,%ecx
80107ee8:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ef1:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107ef8:	83 e1 ef             	and    $0xffffffef,%ecx
80107efb:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107f01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f04:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107f0b:	83 e1 df             	and    $0xffffffdf,%ecx
80107f0e:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107f14:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f17:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107f1e:	83 c9 40             	or     $0x40,%ecx
80107f21:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107f27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f2a:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107f31:	83 c9 80             	or     $0xffffff80,%ecx
80107f34:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107f3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f3d:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80107f43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f46:	83 c0 70             	add    $0x70,%eax
80107f49:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
80107f50:	00 
80107f51:	89 04 24             	mov    %eax,(%esp)
80107f54:	e8 37 fb ff ff       	call   80107a90 <lgdt>
  loadgs(SEG_KCPU << 3);
80107f59:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
80107f60:	e8 6a fb ff ff       	call   80107acf <loadgs>
  
  // Initialize cpu-local storage.
  cpu = c;
80107f65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f68:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
80107f6e:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80107f75:	00 00 00 00 
}
80107f79:	83 c4 24             	add    $0x24,%esp
80107f7c:	5b                   	pop    %ebx
80107f7d:	5d                   	pop    %ebp
80107f7e:	c3                   	ret    

80107f7f <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107f7f:	55                   	push   %ebp
80107f80:	89 e5                	mov    %esp,%ebp
80107f82:	83 ec 28             	sub    $0x28,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107f85:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f88:	c1 e8 16             	shr    $0x16,%eax
80107f8b:	c1 e0 02             	shl    $0x2,%eax
80107f8e:	03 45 08             	add    0x8(%ebp),%eax
80107f91:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80107f94:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107f97:	8b 00                	mov    (%eax),%eax
80107f99:	83 e0 01             	and    $0x1,%eax
80107f9c:	84 c0                	test   %al,%al
80107f9e:	74 17                	je     80107fb7 <walkpgdir+0x38>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
80107fa0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107fa3:	8b 00                	mov    (%eax),%eax
80107fa5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107faa:	89 04 24             	mov    %eax,(%esp)
80107fad:	e8 4a fb ff ff       	call   80107afc <p2v>
80107fb2:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107fb5:	eb 4b                	jmp    80108002 <walkpgdir+0x83>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107fb7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80107fbb:	74 0e                	je     80107fcb <walkpgdir+0x4c>
80107fbd:	e8 0c ac ff ff       	call   80102bce <kalloc>
80107fc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107fc5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107fc9:	75 07                	jne    80107fd2 <walkpgdir+0x53>
      return 0;
80107fcb:	b8 00 00 00 00       	mov    $0x0,%eax
80107fd0:	eb 41                	jmp    80108013 <walkpgdir+0x94>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80107fd2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107fd9:	00 
80107fda:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107fe1:	00 
80107fe2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fe5:	89 04 24             	mov    %eax,(%esp)
80107fe8:	e8 c9 d1 ff ff       	call   801051b6 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80107fed:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ff0:	89 04 24             	mov    %eax,(%esp)
80107ff3:	e8 f7 fa ff ff       	call   80107aef <v2p>
80107ff8:	89 c2                	mov    %eax,%edx
80107ffa:	83 ca 07             	or     $0x7,%edx
80107ffd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108000:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80108002:	8b 45 0c             	mov    0xc(%ebp),%eax
80108005:	c1 e8 0c             	shr    $0xc,%eax
80108008:	25 ff 03 00 00       	and    $0x3ff,%eax
8010800d:	c1 e0 02             	shl    $0x2,%eax
80108010:	03 45 f4             	add    -0xc(%ebp),%eax
}
80108013:	c9                   	leave  
80108014:	c3                   	ret    

80108015 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80108015:	55                   	push   %ebp
80108016:	89 e5                	mov    %esp,%ebp
80108018:	83 ec 28             	sub    $0x28,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
8010801b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010801e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108023:	89 45 ec             	mov    %eax,-0x14(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80108026:	8b 45 0c             	mov    0xc(%ebp),%eax
80108029:	03 45 10             	add    0x10(%ebp),%eax
8010802c:	83 e8 01             	sub    $0x1,%eax
8010802f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108034:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80108037:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
8010803e:	00 
8010803f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108042:	89 44 24 04          	mov    %eax,0x4(%esp)
80108046:	8b 45 08             	mov    0x8(%ebp),%eax
80108049:	89 04 24             	mov    %eax,(%esp)
8010804c:	e8 2e ff ff ff       	call   80107f7f <walkpgdir>
80108051:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108054:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108058:	75 07                	jne    80108061 <mappages+0x4c>
      return -1;
8010805a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010805f:	eb 46                	jmp    801080a7 <mappages+0x92>
    if(*pte & PTE_P)
80108061:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108064:	8b 00                	mov    (%eax),%eax
80108066:	83 e0 01             	and    $0x1,%eax
80108069:	84 c0                	test   %al,%al
8010806b:	74 0c                	je     80108079 <mappages+0x64>
      panic("remap");
8010806d:	c7 04 24 9c 8f 10 80 	movl   $0x80108f9c,(%esp)
80108074:	e8 c4 84 ff ff       	call   8010053d <panic>
    *pte = pa | perm | PTE_P;
80108079:	8b 45 18             	mov    0x18(%ebp),%eax
8010807c:	0b 45 14             	or     0x14(%ebp),%eax
8010807f:	89 c2                	mov    %eax,%edx
80108081:	83 ca 01             	or     $0x1,%edx
80108084:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108087:	89 10                	mov    %edx,(%eax)
    if(a == last)
80108089:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010808c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010808f:	74 10                	je     801080a1 <mappages+0x8c>
      break;
    a += PGSIZE;
80108091:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
    pa += PGSIZE;
80108098:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
8010809f:	eb 96                	jmp    80108037 <mappages+0x22>
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
801080a1:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
801080a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
801080a7:	c9                   	leave  
801080a8:	c3                   	ret    

801080a9 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
801080a9:	55                   	push   %ebp
801080aa:	89 e5                	mov    %esp,%ebp
801080ac:	53                   	push   %ebx
801080ad:	83 ec 34             	sub    $0x34,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
801080b0:	e8 19 ab ff ff       	call   80102bce <kalloc>
801080b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
801080b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801080bc:	75 0a                	jne    801080c8 <setupkvm+0x1f>
    return 0;
801080be:	b8 00 00 00 00       	mov    $0x0,%eax
801080c3:	e9 99 00 00 00       	jmp    80108161 <setupkvm+0xb8>
  memset(pgdir, 0, PGSIZE);
801080c8:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801080cf:	00 
801080d0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801080d7:	00 
801080d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801080db:	89 04 24             	mov    %eax,(%esp)
801080de:	e8 d3 d0 ff ff       	call   801051b6 <memset>
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
801080e3:	c7 04 24 00 00 00 0e 	movl   $0xe000000,(%esp)
801080ea:	e8 0d fa ff ff       	call   80107afc <p2v>
801080ef:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
801080f4:	76 0c                	jbe    80108102 <setupkvm+0x59>
    panic("PHYSTOP too high");
801080f6:	c7 04 24 a2 8f 10 80 	movl   $0x80108fa2,(%esp)
801080fd:	e8 3b 84 ff ff       	call   8010053d <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108102:	c7 45 f4 c0 c4 10 80 	movl   $0x8010c4c0,-0xc(%ebp)
80108109:	eb 49                	jmp    80108154 <setupkvm+0xab>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
8010810b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010810e:	8b 48 0c             	mov    0xc(%eax),%ecx
80108111:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108114:	8b 50 04             	mov    0x4(%eax),%edx
80108117:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010811a:	8b 58 08             	mov    0x8(%eax),%ebx
8010811d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108120:	8b 40 04             	mov    0x4(%eax),%eax
80108123:	29 c3                	sub    %eax,%ebx
80108125:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108128:	8b 00                	mov    (%eax),%eax
8010812a:	89 4c 24 10          	mov    %ecx,0x10(%esp)
8010812e:	89 54 24 0c          	mov    %edx,0xc(%esp)
80108132:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80108136:	89 44 24 04          	mov    %eax,0x4(%esp)
8010813a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010813d:	89 04 24             	mov    %eax,(%esp)
80108140:	e8 d0 fe ff ff       	call   80108015 <mappages>
80108145:	85 c0                	test   %eax,%eax
80108147:	79 07                	jns    80108150 <setupkvm+0xa7>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
80108149:	b8 00 00 00 00       	mov    $0x0,%eax
8010814e:	eb 11                	jmp    80108161 <setupkvm+0xb8>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108150:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80108154:	b8 00 c5 10 80       	mov    $0x8010c500,%eax
80108159:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010815c:	72 ad                	jb     8010810b <setupkvm+0x62>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
8010815e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80108161:	83 c4 34             	add    $0x34,%esp
80108164:	5b                   	pop    %ebx
80108165:	5d                   	pop    %ebp
80108166:	c3                   	ret    

80108167 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80108167:	55                   	push   %ebp
80108168:	89 e5                	mov    %esp,%ebp
8010816a:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010816d:	e8 37 ff ff ff       	call   801080a9 <setupkvm>
80108172:	a3 58 84 11 80       	mov    %eax,0x80118458
  switchkvm();
80108177:	e8 02 00 00 00       	call   8010817e <switchkvm>
}
8010817c:	c9                   	leave  
8010817d:	c3                   	ret    

8010817e <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
8010817e:	55                   	push   %ebp
8010817f:	89 e5                	mov    %esp,%ebp
80108181:	83 ec 04             	sub    $0x4,%esp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80108184:	a1 58 84 11 80       	mov    0x80118458,%eax
80108189:	89 04 24             	mov    %eax,(%esp)
8010818c:	e8 5e f9 ff ff       	call   80107aef <v2p>
80108191:	89 04 24             	mov    %eax,(%esp)
80108194:	e8 4b f9 ff ff       	call   80107ae4 <lcr3>
}
80108199:	c9                   	leave  
8010819a:	c3                   	ret    

8010819b <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
8010819b:	55                   	push   %ebp
8010819c:	89 e5                	mov    %esp,%ebp
8010819e:	53                   	push   %ebx
8010819f:	83 ec 14             	sub    $0x14,%esp
  pushcli();
801081a2:	e8 0a cf ff ff       	call   801050b1 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
801081a7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801081ad:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801081b4:	83 c2 08             	add    $0x8,%edx
801081b7:	89 d3                	mov    %edx,%ebx
801081b9:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801081c0:	83 c2 08             	add    $0x8,%edx
801081c3:	c1 ea 10             	shr    $0x10,%edx
801081c6:	89 d1                	mov    %edx,%ecx
801081c8:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801081cf:	83 c2 08             	add    $0x8,%edx
801081d2:	c1 ea 18             	shr    $0x18,%edx
801081d5:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
801081dc:	67 00 
801081de:	66 89 98 a2 00 00 00 	mov    %bx,0xa2(%eax)
801081e5:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
801081eb:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
801081f2:	83 e1 f0             	and    $0xfffffff0,%ecx
801081f5:	83 c9 09             	or     $0x9,%ecx
801081f8:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
801081fe:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80108205:	83 c9 10             	or     $0x10,%ecx
80108208:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
8010820e:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80108215:	83 e1 9f             	and    $0xffffff9f,%ecx
80108218:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
8010821e:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80108225:	83 c9 80             	or     $0xffffff80,%ecx
80108228:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
8010822e:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80108235:	83 e1 f0             	and    $0xfffffff0,%ecx
80108238:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
8010823e:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80108245:	83 e1 ef             	and    $0xffffffef,%ecx
80108248:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
8010824e:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80108255:	83 e1 df             	and    $0xffffffdf,%ecx
80108258:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
8010825e:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80108265:	83 c9 40             	or     $0x40,%ecx
80108268:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
8010826e:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80108275:	83 e1 7f             	and    $0x7f,%ecx
80108278:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
8010827e:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80108284:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010828a:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108291:	83 e2 ef             	and    $0xffffffef,%edx
80108294:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
8010829a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801082a0:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
801082a6:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801082ac:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801082b3:	8b 52 08             	mov    0x8(%edx),%edx
801082b6:	81 c2 00 10 00 00    	add    $0x1000,%edx
801082bc:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
801082bf:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
801082c6:	e8 ee f7 ff ff       	call   80107ab9 <ltr>
  if(p->pgdir == 0)
801082cb:	8b 45 08             	mov    0x8(%ebp),%eax
801082ce:	8b 40 04             	mov    0x4(%eax),%eax
801082d1:	85 c0                	test   %eax,%eax
801082d3:	75 0c                	jne    801082e1 <switchuvm+0x146>
    panic("switchuvm: no pgdir");
801082d5:	c7 04 24 b3 8f 10 80 	movl   $0x80108fb3,(%esp)
801082dc:	e8 5c 82 ff ff       	call   8010053d <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
801082e1:	8b 45 08             	mov    0x8(%ebp),%eax
801082e4:	8b 40 04             	mov    0x4(%eax),%eax
801082e7:	89 04 24             	mov    %eax,(%esp)
801082ea:	e8 00 f8 ff ff       	call   80107aef <v2p>
801082ef:	89 04 24             	mov    %eax,(%esp)
801082f2:	e8 ed f7 ff ff       	call   80107ae4 <lcr3>
  popcli();
801082f7:	e8 fd cd ff ff       	call   801050f9 <popcli>
}
801082fc:	83 c4 14             	add    $0x14,%esp
801082ff:	5b                   	pop    %ebx
80108300:	5d                   	pop    %ebp
80108301:	c3                   	ret    

80108302 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80108302:	55                   	push   %ebp
80108303:	89 e5                	mov    %esp,%ebp
80108305:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  
  if(sz >= PGSIZE)
80108308:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
8010830f:	76 0c                	jbe    8010831d <inituvm+0x1b>
    panic("inituvm: more than a page");
80108311:	c7 04 24 c7 8f 10 80 	movl   $0x80108fc7,(%esp)
80108318:	e8 20 82 ff ff       	call   8010053d <panic>
  mem = kalloc();
8010831d:	e8 ac a8 ff ff       	call   80102bce <kalloc>
80108322:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80108325:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010832c:	00 
8010832d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108334:	00 
80108335:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108338:	89 04 24             	mov    %eax,(%esp)
8010833b:	e8 76 ce ff ff       	call   801051b6 <memset>
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80108340:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108343:	89 04 24             	mov    %eax,(%esp)
80108346:	e8 a4 f7 ff ff       	call   80107aef <v2p>
8010834b:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80108352:	00 
80108353:	89 44 24 0c          	mov    %eax,0xc(%esp)
80108357:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010835e:	00 
8010835f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108366:	00 
80108367:	8b 45 08             	mov    0x8(%ebp),%eax
8010836a:	89 04 24             	mov    %eax,(%esp)
8010836d:	e8 a3 fc ff ff       	call   80108015 <mappages>
  memmove(mem, init, sz);
80108372:	8b 45 10             	mov    0x10(%ebp),%eax
80108375:	89 44 24 08          	mov    %eax,0x8(%esp)
80108379:	8b 45 0c             	mov    0xc(%ebp),%eax
8010837c:	89 44 24 04          	mov    %eax,0x4(%esp)
80108380:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108383:	89 04 24             	mov    %eax,(%esp)
80108386:	e8 fe ce ff ff       	call   80105289 <memmove>
}
8010838b:	c9                   	leave  
8010838c:	c3                   	ret    

8010838d <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
8010838d:	55                   	push   %ebp
8010838e:	89 e5                	mov    %esp,%ebp
80108390:	53                   	push   %ebx
80108391:	83 ec 24             	sub    $0x24,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80108394:	8b 45 0c             	mov    0xc(%ebp),%eax
80108397:	25 ff 0f 00 00       	and    $0xfff,%eax
8010839c:	85 c0                	test   %eax,%eax
8010839e:	74 0c                	je     801083ac <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
801083a0:	c7 04 24 e4 8f 10 80 	movl   $0x80108fe4,(%esp)
801083a7:	e8 91 81 ff ff       	call   8010053d <panic>
  for(i = 0; i < sz; i += PGSIZE){
801083ac:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
801083b3:	e9 ae 00 00 00       	jmp    80108466 <loaduvm+0xd9>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801083b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
801083bb:	8b 55 0c             	mov    0xc(%ebp),%edx
801083be:	8d 04 02             	lea    (%edx,%eax,1),%eax
801083c1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801083c8:	00 
801083c9:	89 44 24 04          	mov    %eax,0x4(%esp)
801083cd:	8b 45 08             	mov    0x8(%ebp),%eax
801083d0:	89 04 24             	mov    %eax,(%esp)
801083d3:	e8 a7 fb ff ff       	call   80107f7f <walkpgdir>
801083d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
801083db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801083df:	75 0c                	jne    801083ed <loaduvm+0x60>
      panic("loaduvm: address should exist");
801083e1:	c7 04 24 07 90 10 80 	movl   $0x80109007,(%esp)
801083e8:	e8 50 81 ff ff       	call   8010053d <panic>
    pa = PTE_ADDR(*pte);
801083ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083f0:	8b 00                	mov    (%eax),%eax
801083f2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801083f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(sz - i < PGSIZE)
801083fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
801083fd:	8b 55 18             	mov    0x18(%ebp),%edx
80108400:	89 d1                	mov    %edx,%ecx
80108402:	29 c1                	sub    %eax,%ecx
80108404:	89 c8                	mov    %ecx,%eax
80108406:	3d ff 0f 00 00       	cmp    $0xfff,%eax
8010840b:	77 11                	ja     8010841e <loaduvm+0x91>
      n = sz - i;
8010840d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108410:	8b 55 18             	mov    0x18(%ebp),%edx
80108413:	89 d1                	mov    %edx,%ecx
80108415:	29 c1                	sub    %eax,%ecx
80108417:	89 c8                	mov    %ecx,%eax
80108419:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010841c:	eb 07                	jmp    80108425 <loaduvm+0x98>
    else
      n = PGSIZE;
8010841e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80108425:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108428:	8b 55 14             	mov    0x14(%ebp),%edx
8010842b:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
8010842e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108431:	89 04 24             	mov    %eax,(%esp)
80108434:	e8 c3 f6 ff ff       	call   80107afc <p2v>
80108439:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010843c:	89 54 24 0c          	mov    %edx,0xc(%esp)
80108440:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80108444:	89 44 24 04          	mov    %eax,0x4(%esp)
80108448:	8b 45 10             	mov    0x10(%ebp),%eax
8010844b:	89 04 24             	mov    %eax,(%esp)
8010844e:	e8 ad 99 ff ff       	call   80101e00 <readi>
80108453:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80108456:	74 07                	je     8010845f <loaduvm+0xd2>
      return -1;
80108458:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010845d:	eb 18                	jmp    80108477 <loaduvm+0xea>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
8010845f:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)
80108466:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108469:	3b 45 18             	cmp    0x18(%ebp),%eax
8010846c:	0f 82 46 ff ff ff    	jb     801083b8 <loaduvm+0x2b>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80108472:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108477:	83 c4 24             	add    $0x24,%esp
8010847a:	5b                   	pop    %ebx
8010847b:	5d                   	pop    %ebp
8010847c:	c3                   	ret    

8010847d <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
8010847d:	55                   	push   %ebp
8010847e:	89 e5                	mov    %esp,%ebp
80108480:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80108483:	8b 45 10             	mov    0x10(%ebp),%eax
80108486:	85 c0                	test   %eax,%eax
80108488:	79 0a                	jns    80108494 <allocuvm+0x17>
    return 0;
8010848a:	b8 00 00 00 00       	mov    $0x0,%eax
8010848f:	e9 c1 00 00 00       	jmp    80108555 <allocuvm+0xd8>
  if(newsz < oldsz)
80108494:	8b 45 10             	mov    0x10(%ebp),%eax
80108497:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010849a:	73 08                	jae    801084a4 <allocuvm+0x27>
    return oldsz;
8010849c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010849f:	e9 b1 00 00 00       	jmp    80108555 <allocuvm+0xd8>

  a = PGROUNDUP(oldsz);
801084a4:	8b 45 0c             	mov    0xc(%ebp),%eax
801084a7:	05 ff 0f 00 00       	add    $0xfff,%eax
801084ac:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801084b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
801084b4:	e9 8d 00 00 00       	jmp    80108546 <allocuvm+0xc9>
    mem = kalloc();
801084b9:	e8 10 a7 ff ff       	call   80102bce <kalloc>
801084be:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
801084c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801084c5:	75 2c                	jne    801084f3 <allocuvm+0x76>
      cprintf("allocuvm out of memory\n");
801084c7:	c7 04 24 25 90 10 80 	movl   $0x80109025,(%esp)
801084ce:	e8 ca 7e ff ff       	call   8010039d <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
801084d3:	8b 45 0c             	mov    0xc(%ebp),%eax
801084d6:	89 44 24 08          	mov    %eax,0x8(%esp)
801084da:	8b 45 10             	mov    0x10(%ebp),%eax
801084dd:	89 44 24 04          	mov    %eax,0x4(%esp)
801084e1:	8b 45 08             	mov    0x8(%ebp),%eax
801084e4:	89 04 24             	mov    %eax,(%esp)
801084e7:	e8 6b 00 00 00       	call   80108557 <deallocuvm>
      return 0;
801084ec:	b8 00 00 00 00       	mov    $0x0,%eax
801084f1:	eb 62                	jmp    80108555 <allocuvm+0xd8>
    }
    memset(mem, 0, PGSIZE);
801084f3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801084fa:	00 
801084fb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108502:	00 
80108503:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108506:	89 04 24             	mov    %eax,(%esp)
80108509:	e8 a8 cc ff ff       	call   801051b6 <memset>
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
8010850e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108511:	89 04 24             	mov    %eax,(%esp)
80108514:	e8 d6 f5 ff ff       	call   80107aef <v2p>
80108519:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010851c:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80108523:	00 
80108524:	89 44 24 0c          	mov    %eax,0xc(%esp)
80108528:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010852f:	00 
80108530:	89 54 24 04          	mov    %edx,0x4(%esp)
80108534:	8b 45 08             	mov    0x8(%ebp),%eax
80108537:	89 04 24             	mov    %eax,(%esp)
8010853a:	e8 d6 fa ff ff       	call   80108015 <mappages>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
8010853f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108546:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108549:	3b 45 10             	cmp    0x10(%ebp),%eax
8010854c:	0f 82 67 ff ff ff    	jb     801084b9 <allocuvm+0x3c>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
80108552:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108555:	c9                   	leave  
80108556:	c3                   	ret    

80108557 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108557:	55                   	push   %ebp
80108558:	89 e5                	mov    %esp,%ebp
8010855a:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010855d:	8b 45 10             	mov    0x10(%ebp),%eax
80108560:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108563:	72 08                	jb     8010856d <deallocuvm+0x16>
    return oldsz;
80108565:	8b 45 0c             	mov    0xc(%ebp),%eax
80108568:	e9 a4 00 00 00       	jmp    80108611 <deallocuvm+0xba>

  a = PGROUNDUP(newsz);
8010856d:	8b 45 10             	mov    0x10(%ebp),%eax
80108570:	05 ff 0f 00 00       	add    $0xfff,%eax
80108575:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010857a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010857d:	e9 80 00 00 00       	jmp    80108602 <deallocuvm+0xab>
    pte = walkpgdir(pgdir, (char*)a, 0);
80108582:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108585:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010858c:	00 
8010858d:	89 44 24 04          	mov    %eax,0x4(%esp)
80108591:	8b 45 08             	mov    0x8(%ebp),%eax
80108594:	89 04 24             	mov    %eax,(%esp)
80108597:	e8 e3 f9 ff ff       	call   80107f7f <walkpgdir>
8010859c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(!pte)
8010859f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801085a3:	75 09                	jne    801085ae <deallocuvm+0x57>
      a += (NPTENTRIES - 1) * PGSIZE;
801085a5:	81 45 ec 00 f0 3f 00 	addl   $0x3ff000,-0x14(%ebp)
801085ac:	eb 4d                	jmp    801085fb <deallocuvm+0xa4>
    else if((*pte & PTE_P) != 0){
801085ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
801085b1:	8b 00                	mov    (%eax),%eax
801085b3:	83 e0 01             	and    $0x1,%eax
801085b6:	84 c0                	test   %al,%al
801085b8:	74 41                	je     801085fb <deallocuvm+0xa4>
      pa = PTE_ADDR(*pte);
801085ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
801085bd:	8b 00                	mov    (%eax),%eax
801085bf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801085c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(pa == 0)
801085c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801085cb:	75 0c                	jne    801085d9 <deallocuvm+0x82>
        panic("kfree");
801085cd:	c7 04 24 3d 90 10 80 	movl   $0x8010903d,(%esp)
801085d4:	e8 64 7f ff ff       	call   8010053d <panic>
      char *v = p2v(pa);
801085d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801085dc:	89 04 24             	mov    %eax,(%esp)
801085df:	e8 18 f5 ff ff       	call   80107afc <p2v>
801085e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
      kfree(v);
801085e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085ea:	89 04 24             	mov    %eax,(%esp)
801085ed:	e8 43 a5 ff ff       	call   80102b35 <kfree>
      *pte = 0;
801085f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
801085f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801085fb:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
80108602:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108605:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108608:	0f 82 74 ff ff ff    	jb     80108582 <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
8010860e:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108611:	c9                   	leave  
80108612:	c3                   	ret    

80108613 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108613:	55                   	push   %ebp
80108614:	89 e5                	mov    %esp,%ebp
80108616:	83 ec 28             	sub    $0x28,%esp
  uint i;

  if(pgdir == 0)
80108619:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010861d:	75 0c                	jne    8010862b <freevm+0x18>
    panic("freevm: no pgdir");
8010861f:	c7 04 24 43 90 10 80 	movl   $0x80109043,(%esp)
80108626:	e8 12 7f ff ff       	call   8010053d <panic>
  deallocuvm(pgdir, KERNBASE, 0);
8010862b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108632:	00 
80108633:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
8010863a:	80 
8010863b:	8b 45 08             	mov    0x8(%ebp),%eax
8010863e:	89 04 24             	mov    %eax,(%esp)
80108641:	e8 11 ff ff ff       	call   80108557 <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
80108646:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010864d:	eb 3c                	jmp    8010868b <freevm+0x78>
    if(pgdir[i] & PTE_P){
8010864f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108652:	c1 e0 02             	shl    $0x2,%eax
80108655:	03 45 08             	add    0x8(%ebp),%eax
80108658:	8b 00                	mov    (%eax),%eax
8010865a:	83 e0 01             	and    $0x1,%eax
8010865d:	84 c0                	test   %al,%al
8010865f:	74 26                	je     80108687 <freevm+0x74>
      char * v = p2v(PTE_ADDR(pgdir[i]));
80108661:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108664:	c1 e0 02             	shl    $0x2,%eax
80108667:	03 45 08             	add    0x8(%ebp),%eax
8010866a:	8b 00                	mov    (%eax),%eax
8010866c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108671:	89 04 24             	mov    %eax,(%esp)
80108674:	e8 83 f4 ff ff       	call   80107afc <p2v>
80108679:	89 45 f4             	mov    %eax,-0xc(%ebp)
      kfree(v);
8010867c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010867f:	89 04 24             	mov    %eax,(%esp)
80108682:	e8 ae a4 ff ff       	call   80102b35 <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80108687:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010868b:	81 7d f0 ff 03 00 00 	cmpl   $0x3ff,-0x10(%ebp)
80108692:	76 bb                	jbe    8010864f <freevm+0x3c>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80108694:	8b 45 08             	mov    0x8(%ebp),%eax
80108697:	89 04 24             	mov    %eax,(%esp)
8010869a:	e8 96 a4 ff ff       	call   80102b35 <kfree>
}
8010869f:	c9                   	leave  
801086a0:	c3                   	ret    

801086a1 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801086a1:	55                   	push   %ebp
801086a2:	89 e5                	mov    %esp,%ebp
801086a4:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801086a7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801086ae:	00 
801086af:	8b 45 0c             	mov    0xc(%ebp),%eax
801086b2:	89 44 24 04          	mov    %eax,0x4(%esp)
801086b6:	8b 45 08             	mov    0x8(%ebp),%eax
801086b9:	89 04 24             	mov    %eax,(%esp)
801086bc:	e8 be f8 ff ff       	call   80107f7f <walkpgdir>
801086c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
801086c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801086c8:	75 0c                	jne    801086d6 <clearpteu+0x35>
    panic("clearpteu");
801086ca:	c7 04 24 54 90 10 80 	movl   $0x80109054,(%esp)
801086d1:	e8 67 7e ff ff       	call   8010053d <panic>
  *pte &= ~PTE_U;
801086d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086d9:	8b 00                	mov    (%eax),%eax
801086db:	89 c2                	mov    %eax,%edx
801086dd:	83 e2 fb             	and    $0xfffffffb,%edx
801086e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086e3:	89 10                	mov    %edx,(%eax)
}
801086e5:	c9                   	leave  
801086e6:	c3                   	ret    

801086e7 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801086e7:	55                   	push   %ebp
801086e8:	89 e5                	mov    %esp,%ebp
801086ea:	53                   	push   %ebx
801086eb:	83 ec 44             	sub    $0x44,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801086ee:	e8 b6 f9 ff ff       	call   801080a9 <setupkvm>
801086f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
801086f6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801086fa:	75 0a                	jne    80108706 <copyuvm+0x1f>
    return 0;
801086fc:	b8 00 00 00 00       	mov    $0x0,%eax
80108701:	e9 fd 00 00 00       	jmp    80108803 <copyuvm+0x11c>
  for(i = 0; i < sz; i += PGSIZE){
80108706:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
8010870d:	e9 cc 00 00 00       	jmp    801087de <copyuvm+0xf7>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108712:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108715:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010871c:	00 
8010871d:	89 44 24 04          	mov    %eax,0x4(%esp)
80108721:	8b 45 08             	mov    0x8(%ebp),%eax
80108724:	89 04 24             	mov    %eax,(%esp)
80108727:	e8 53 f8 ff ff       	call   80107f7f <walkpgdir>
8010872c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010872f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80108733:	75 0c                	jne    80108741 <copyuvm+0x5a>
      panic("copyuvm: pte should exist");
80108735:	c7 04 24 5e 90 10 80 	movl   $0x8010905e,(%esp)
8010873c:	e8 fc 7d ff ff       	call   8010053d <panic>
    if(!(*pte & PTE_P))
80108741:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108744:	8b 00                	mov    (%eax),%eax
80108746:	83 e0 01             	and    $0x1,%eax
80108749:	85 c0                	test   %eax,%eax
8010874b:	75 0c                	jne    80108759 <copyuvm+0x72>
      panic("copyuvm: page not present");
8010874d:	c7 04 24 78 90 10 80 	movl   $0x80109078,(%esp)
80108754:	e8 e4 7d ff ff       	call   8010053d <panic>
    pa = PTE_ADDR(*pte);
80108759:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010875c:	8b 00                	mov    (%eax),%eax
8010875e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108763:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80108766:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108769:	8b 00                	mov    (%eax),%eax
8010876b:	25 ff 0f 00 00       	and    $0xfff,%eax
80108770:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mem = kalloc()) == 0)
80108773:	e8 56 a4 ff ff       	call   80102bce <kalloc>
80108778:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010877b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010877f:	74 6e                	je     801087ef <copyuvm+0x108>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
80108781:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108784:	89 04 24             	mov    %eax,(%esp)
80108787:	e8 70 f3 ff ff       	call   80107afc <p2v>
8010878c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108793:	00 
80108794:	89 44 24 04          	mov    %eax,0x4(%esp)
80108798:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010879b:	89 04 24             	mov    %eax,(%esp)
8010879e:	e8 e6 ca ff ff       	call   80105289 <memmove>
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
801087a3:	8b 5d f0             	mov    -0x10(%ebp),%ebx
801087a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087a9:	89 04 24             	mov    %eax,(%esp)
801087ac:	e8 3e f3 ff ff       	call   80107aef <v2p>
801087b1:	8b 55 ec             	mov    -0x14(%ebp),%edx
801087b4:	89 5c 24 10          	mov    %ebx,0x10(%esp)
801087b8:	89 44 24 0c          	mov    %eax,0xc(%esp)
801087bc:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801087c3:	00 
801087c4:	89 54 24 04          	mov    %edx,0x4(%esp)
801087c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801087cb:	89 04 24             	mov    %eax,(%esp)
801087ce:	e8 42 f8 ff ff       	call   80108015 <mappages>
801087d3:	85 c0                	test   %eax,%eax
801087d5:	78 1b                	js     801087f2 <copyuvm+0x10b>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801087d7:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
801087de:	8b 45 ec             	mov    -0x14(%ebp),%eax
801087e1:	3b 45 0c             	cmp    0xc(%ebp),%eax
801087e4:	0f 82 28 ff ff ff    	jb     80108712 <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
801087ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
801087ed:	eb 14                	jmp    80108803 <copyuvm+0x11c>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
801087ef:	90                   	nop
801087f0:	eb 01                	jmp    801087f3 <copyuvm+0x10c>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
801087f2:	90                   	nop
  }
  return d;

bad:
  freevm(d);
801087f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801087f6:	89 04 24             	mov    %eax,(%esp)
801087f9:	e8 15 fe ff ff       	call   80108613 <freevm>
  return 0;
801087fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108803:	83 c4 44             	add    $0x44,%esp
80108806:	5b                   	pop    %ebx
80108807:	5d                   	pop    %ebp
80108808:	c3                   	ret    

80108809 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108809:	55                   	push   %ebp
8010880a:	89 e5                	mov    %esp,%ebp
8010880c:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010880f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108816:	00 
80108817:	8b 45 0c             	mov    0xc(%ebp),%eax
8010881a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010881e:	8b 45 08             	mov    0x8(%ebp),%eax
80108821:	89 04 24             	mov    %eax,(%esp)
80108824:	e8 56 f7 ff ff       	call   80107f7f <walkpgdir>
80108829:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
8010882c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010882f:	8b 00                	mov    (%eax),%eax
80108831:	83 e0 01             	and    $0x1,%eax
80108834:	85 c0                	test   %eax,%eax
80108836:	75 07                	jne    8010883f <uva2ka+0x36>
    return 0;
80108838:	b8 00 00 00 00       	mov    $0x0,%eax
8010883d:	eb 25                	jmp    80108864 <uva2ka+0x5b>
  if((*pte & PTE_U) == 0)
8010883f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108842:	8b 00                	mov    (%eax),%eax
80108844:	83 e0 04             	and    $0x4,%eax
80108847:	85 c0                	test   %eax,%eax
80108849:	75 07                	jne    80108852 <uva2ka+0x49>
    return 0;
8010884b:	b8 00 00 00 00       	mov    $0x0,%eax
80108850:	eb 12                	jmp    80108864 <uva2ka+0x5b>
  return (char*)p2v(PTE_ADDR(*pte));
80108852:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108855:	8b 00                	mov    (%eax),%eax
80108857:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010885c:	89 04 24             	mov    %eax,(%esp)
8010885f:	e8 98 f2 ff ff       	call   80107afc <p2v>
}
80108864:	c9                   	leave  
80108865:	c3                   	ret    

80108866 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108866:	55                   	push   %ebp
80108867:	89 e5                	mov    %esp,%ebp
80108869:	83 ec 28             	sub    $0x28,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
8010886c:	8b 45 10             	mov    0x10(%ebp),%eax
8010886f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  while(len > 0){
80108872:	e9 8b 00 00 00       	jmp    80108902 <copyout+0x9c>
    va0 = (uint)PGROUNDDOWN(va);
80108877:	8b 45 0c             	mov    0xc(%ebp),%eax
8010887a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010887f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80108882:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108885:	89 44 24 04          	mov    %eax,0x4(%esp)
80108889:	8b 45 08             	mov    0x8(%ebp),%eax
8010888c:	89 04 24             	mov    %eax,(%esp)
8010888f:	e8 75 ff ff ff       	call   80108809 <uva2ka>
80108894:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(pa0 == 0)
80108897:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010889b:	75 07                	jne    801088a4 <copyout+0x3e>
      return -1;
8010889d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801088a2:	eb 6d                	jmp    80108911 <copyout+0xab>
    n = PGSIZE - (va - va0);
801088a4:	8b 45 0c             	mov    0xc(%ebp),%eax
801088a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801088aa:	89 d1                	mov    %edx,%ecx
801088ac:	29 c1                	sub    %eax,%ecx
801088ae:	89 c8                	mov    %ecx,%eax
801088b0:	05 00 10 00 00       	add    $0x1000,%eax
801088b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
801088b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801088bb:	3b 45 14             	cmp    0x14(%ebp),%eax
801088be:	76 06                	jbe    801088c6 <copyout+0x60>
      n = len;
801088c0:	8b 45 14             	mov    0x14(%ebp),%eax
801088c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
801088c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088c9:	8b 55 0c             	mov    0xc(%ebp),%edx
801088cc:	89 d1                	mov    %edx,%ecx
801088ce:	29 c1                	sub    %eax,%ecx
801088d0:	89 c8                	mov    %ecx,%eax
801088d2:	03 45 ec             	add    -0x14(%ebp),%eax
801088d5:	8b 55 f0             	mov    -0x10(%ebp),%edx
801088d8:	89 54 24 08          	mov    %edx,0x8(%esp)
801088dc:	8b 55 e8             	mov    -0x18(%ebp),%edx
801088df:	89 54 24 04          	mov    %edx,0x4(%esp)
801088e3:	89 04 24             	mov    %eax,(%esp)
801088e6:	e8 9e c9 ff ff       	call   80105289 <memmove>
    len -= n;
801088eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801088ee:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
801088f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801088f4:	01 45 e8             	add    %eax,-0x18(%ebp)
    va = va0 + PGSIZE;
801088f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088fa:	05 00 10 00 00       	add    $0x1000,%eax
801088ff:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108902:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108906:	0f 85 6b ff ff ff    	jne    80108877 <copyout+0x11>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
8010890c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108911:	c9                   	leave  
80108912:	c3                   	ret    
