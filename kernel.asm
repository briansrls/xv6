
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4 0f                	in     $0xf,%al

8010000c <entry>:
8010000c:	0f 20 e0             	mov    %cr4,%eax
8010000f:	83 c8 10             	or     $0x10,%eax
80100012:	0f 22 e0             	mov    %eax,%cr4
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
8010001a:	0f 22 d8             	mov    %eax,%cr3
8010001d:	0f 20 c0             	mov    %cr0,%eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
80100025:	0f 22 c0             	mov    %eax,%cr0
80100028:	bc 70 d6 10 80       	mov    $0x8010d670,%esp
8010002d:	b8 ab 37 10 80       	mov    $0x801037ab,%eax
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
8010003a:	c7 44 24 04 90 88 10 	movl   $0x80108890,0x4(%esp)
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
801000a5:	81 7d f4 84 15 11 80 	cmpl   $0x80111584,-0xc(%ebp)
801000ac:	72 bd                	jb     8010006b <binit+0x37>
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000ae:	c9                   	leave  
801000af:	c3                   	ret    

801000b0 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint blockno)
{
801000b0:	55                   	push   %ebp
801000b1:	89 e5                	mov    %esp,%ebp
801000b3:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000b6:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
801000bd:	e8 9d 4e 00 00       	call   80104f5f <acquire>

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c2:	a1 94 15 11 80       	mov    0x80111594,%eax
801000c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000ca:	eb 63                	jmp    8010012f <bget+0x7f>
    if(b->dev == dev && b->blockno == blockno){
801000cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000cf:	8b 40 04             	mov    0x4(%eax),%eax
801000d2:	3b 45 08             	cmp    0x8(%ebp),%eax
801000d5:	75 4f                	jne    80100126 <bget+0x76>
801000d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000da:	8b 40 08             	mov    0x8(%eax),%eax
801000dd:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000e0:	75 44                	jne    80100126 <bget+0x76>
      if(!(b->flags & B_BUSY)){
801000e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e5:	8b 00                	mov    (%eax),%eax
801000e7:	83 e0 01             	and    $0x1,%eax
801000ea:	85 c0                	test   %eax,%eax
801000ec:	75 23                	jne    80100111 <bget+0x61>
        b->flags |= B_BUSY;
801000ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f1:	8b 00                	mov    (%eax),%eax
801000f3:	89 c2                	mov    %eax,%edx
801000f5:	83 ca 01             	or     $0x1,%edx
801000f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000fb:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
801000fd:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
80100104:	e8 b8 4e 00 00       	call   80104fc1 <release>
        return b;
80100109:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010c:	e9 93 00 00 00       	jmp    801001a4 <bget+0xf4>
      }
      sleep(b, &bcache.lock);
80100111:	c7 44 24 04 80 d6 10 	movl   $0x8010d680,0x4(%esp)
80100118:	80 
80100119:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010011c:	89 04 24             	mov    %eax,(%esp)
8010011f:	e8 56 4b 00 00       	call   80104c7a <sleep>
      goto loop;
80100124:	eb 9c                	jmp    801000c2 <bget+0x12>

  acquire(&bcache.lock);

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100126:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100129:	8b 40 10             	mov    0x10(%eax),%eax
8010012c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010012f:	81 7d f4 84 15 11 80 	cmpl   $0x80111584,-0xc(%ebp)
80100136:	75 94                	jne    801000cc <bget+0x1c>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100138:	a1 90 15 11 80       	mov    0x80111590,%eax
8010013d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100140:	eb 4d                	jmp    8010018f <bget+0xdf>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
80100142:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100145:	8b 00                	mov    (%eax),%eax
80100147:	83 e0 01             	and    $0x1,%eax
8010014a:	85 c0                	test   %eax,%eax
8010014c:	75 38                	jne    80100186 <bget+0xd6>
8010014e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100151:	8b 00                	mov    (%eax),%eax
80100153:	83 e0 04             	and    $0x4,%eax
80100156:	85 c0                	test   %eax,%eax
80100158:	75 2c                	jne    80100186 <bget+0xd6>
      b->dev = dev;
8010015a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015d:	8b 55 08             	mov    0x8(%ebp),%edx
80100160:	89 50 04             	mov    %edx,0x4(%eax)
      b->blockno = blockno;
80100163:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100166:	8b 55 0c             	mov    0xc(%ebp),%edx
80100169:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
8010016c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010016f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
80100175:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
8010017c:	e8 40 4e 00 00       	call   80104fc1 <release>
      return b;
80100181:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100184:	eb 1e                	jmp    801001a4 <bget+0xf4>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100186:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100189:	8b 40 0c             	mov    0xc(%eax),%eax
8010018c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010018f:	81 7d f4 84 15 11 80 	cmpl   $0x80111584,-0xc(%ebp)
80100196:	75 aa                	jne    80100142 <bget+0x92>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100198:	c7 04 24 97 88 10 80 	movl   $0x80108897,(%esp)
8010019f:	e8 92 03 00 00       	call   80100536 <panic>
}
801001a4:	c9                   	leave  
801001a5:	c3                   	ret    

801001a6 <bread>:

// Return a B_BUSY buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801001a6:	55                   	push   %ebp
801001a7:	89 e5                	mov    %esp,%ebp
801001a9:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  b = bget(dev, blockno);
801001ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801001af:	89 44 24 04          	mov    %eax,0x4(%esp)
801001b3:	8b 45 08             	mov    0x8(%ebp),%eax
801001b6:	89 04 24             	mov    %eax,(%esp)
801001b9:	e8 f2 fe ff ff       	call   801000b0 <bget>
801001be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID)) {
801001c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001c4:	8b 00                	mov    (%eax),%eax
801001c6:	83 e0 02             	and    $0x2,%eax
801001c9:	85 c0                	test   %eax,%eax
801001cb:	75 0b                	jne    801001d8 <bread+0x32>
    iderw(b);
801001cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d0:	89 04 24             	mov    %eax,(%esp)
801001d3:	e8 58 26 00 00       	call   80102830 <iderw>
  }
  return b;
801001d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001db:	c9                   	leave  
801001dc:	c3                   	ret    

801001dd <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001dd:	55                   	push   %ebp
801001de:	89 e5                	mov    %esp,%ebp
801001e0:	83 ec 18             	sub    $0x18,%esp
  if((b->flags & B_BUSY) == 0)
801001e3:	8b 45 08             	mov    0x8(%ebp),%eax
801001e6:	8b 00                	mov    (%eax),%eax
801001e8:	83 e0 01             	and    $0x1,%eax
801001eb:	85 c0                	test   %eax,%eax
801001ed:	75 0c                	jne    801001fb <bwrite+0x1e>
    panic("bwrite");
801001ef:	c7 04 24 a8 88 10 80 	movl   $0x801088a8,(%esp)
801001f6:	e8 3b 03 00 00       	call   80100536 <panic>
  b->flags |= B_DIRTY;
801001fb:	8b 45 08             	mov    0x8(%ebp),%eax
801001fe:	8b 00                	mov    (%eax),%eax
80100200:	89 c2                	mov    %eax,%edx
80100202:	83 ca 04             	or     $0x4,%edx
80100205:	8b 45 08             	mov    0x8(%ebp),%eax
80100208:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010020a:	8b 45 08             	mov    0x8(%ebp),%eax
8010020d:	89 04 24             	mov    %eax,(%esp)
80100210:	e8 1b 26 00 00       	call   80102830 <iderw>
}
80100215:	c9                   	leave  
80100216:	c3                   	ret    

80100217 <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
80100217:	55                   	push   %ebp
80100218:	89 e5                	mov    %esp,%ebp
8010021a:	83 ec 18             	sub    $0x18,%esp
  if((b->flags & B_BUSY) == 0)
8010021d:	8b 45 08             	mov    0x8(%ebp),%eax
80100220:	8b 00                	mov    (%eax),%eax
80100222:	83 e0 01             	and    $0x1,%eax
80100225:	85 c0                	test   %eax,%eax
80100227:	75 0c                	jne    80100235 <brelse+0x1e>
    panic("brelse");
80100229:	c7 04 24 af 88 10 80 	movl   $0x801088af,(%esp)
80100230:	e8 01 03 00 00       	call   80100536 <panic>

  acquire(&bcache.lock);
80100235:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
8010023c:	e8 1e 4d 00 00       	call   80104f5f <acquire>

  b->next->prev = b->prev;
80100241:	8b 45 08             	mov    0x8(%ebp),%eax
80100244:	8b 40 10             	mov    0x10(%eax),%eax
80100247:	8b 55 08             	mov    0x8(%ebp),%edx
8010024a:	8b 52 0c             	mov    0xc(%edx),%edx
8010024d:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
80100250:	8b 45 08             	mov    0x8(%ebp),%eax
80100253:	8b 40 0c             	mov    0xc(%eax),%eax
80100256:	8b 55 08             	mov    0x8(%ebp),%edx
80100259:	8b 52 10             	mov    0x10(%edx),%edx
8010025c:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
8010025f:	8b 15 94 15 11 80    	mov    0x80111594,%edx
80100265:	8b 45 08             	mov    0x8(%ebp),%eax
80100268:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
8010026b:	8b 45 08             	mov    0x8(%ebp),%eax
8010026e:	c7 40 0c 84 15 11 80 	movl   $0x80111584,0xc(%eax)
  bcache.head.next->prev = b;
80100275:	a1 94 15 11 80       	mov    0x80111594,%eax
8010027a:	8b 55 08             	mov    0x8(%ebp),%edx
8010027d:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
80100280:	8b 45 08             	mov    0x8(%ebp),%eax
80100283:	a3 94 15 11 80       	mov    %eax,0x80111594

  b->flags &= ~B_BUSY;
80100288:	8b 45 08             	mov    0x8(%ebp),%eax
8010028b:	8b 00                	mov    (%eax),%eax
8010028d:	89 c2                	mov    %eax,%edx
8010028f:	83 e2 fe             	and    $0xfffffffe,%edx
80100292:	8b 45 08             	mov    0x8(%ebp),%eax
80100295:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80100297:	8b 45 08             	mov    0x8(%ebp),%eax
8010029a:	89 04 24             	mov    %eax,(%esp)
8010029d:	e8 b4 4a 00 00       	call   80104d56 <wakeup>

  release(&bcache.lock);
801002a2:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
801002a9:	e8 13 4d 00 00       	call   80104fc1 <release>
}
801002ae:	c9                   	leave  
801002af:	c3                   	ret    

801002b0 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801002b0:	55                   	push   %ebp
801002b1:	89 e5                	mov    %esp,%ebp
801002b3:	53                   	push   %ebx
801002b4:	83 ec 14             	sub    $0x14,%esp
801002b7:	8b 45 08             	mov    0x8(%ebp),%eax
801002ba:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002be:	8b 55 e8             	mov    -0x18(%ebp),%edx
801002c1:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
801002c5:	66 8b 55 ea          	mov    -0x16(%ebp),%dx
801002c9:	ec                   	in     (%dx),%al
801002ca:	88 c3                	mov    %al,%bl
801002cc:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
801002cf:	8a 45 fb             	mov    -0x5(%ebp),%al
}
801002d2:	83 c4 14             	add    $0x14,%esp
801002d5:	5b                   	pop    %ebx
801002d6:	5d                   	pop    %ebp
801002d7:	c3                   	ret    

801002d8 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002d8:	55                   	push   %ebp
801002d9:	89 e5                	mov    %esp,%ebp
801002db:	83 ec 08             	sub    $0x8,%esp
801002de:	8b 45 08             	mov    0x8(%ebp),%eax
801002e1:	8b 55 0c             	mov    0xc(%ebp),%edx
801002e4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
801002e8:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801002eb:	8a 45 f8             	mov    -0x8(%ebp),%al
801002ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
801002f1:	ee                   	out    %al,(%dx)
}
801002f2:	c9                   	leave  
801002f3:	c3                   	ret    

801002f4 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
801002f4:	55                   	push   %ebp
801002f5:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
801002f7:	fa                   	cli    
}
801002f8:	5d                   	pop    %ebp
801002f9:	c3                   	ret    

801002fa <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
801002fa:	55                   	push   %ebp
801002fb:	89 e5                	mov    %esp,%ebp
801002fd:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100300:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100304:	74 1c                	je     80100322 <printint+0x28>
80100306:	8b 45 08             	mov    0x8(%ebp),%eax
80100309:	c1 e8 1f             	shr    $0x1f,%eax
8010030c:	0f b6 c0             	movzbl %al,%eax
8010030f:	89 45 10             	mov    %eax,0x10(%ebp)
80100312:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100316:	74 0a                	je     80100322 <printint+0x28>
    x = -xx;
80100318:	8b 45 08             	mov    0x8(%ebp),%eax
8010031b:	f7 d8                	neg    %eax
8010031d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100320:	eb 06                	jmp    80100328 <printint+0x2e>
  else
    x = xx;
80100322:	8b 45 08             	mov    0x8(%ebp),%eax
80100325:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100328:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
8010032f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100332:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100335:	ba 00 00 00 00       	mov    $0x0,%edx
8010033a:	f7 f1                	div    %ecx
8010033c:	89 d0                	mov    %edx,%eax
8010033e:	8a 80 04 a0 10 80    	mov    -0x7fef5ffc(%eax),%al
80100344:	8d 4d e0             	lea    -0x20(%ebp),%ecx
80100347:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010034a:	01 ca                	add    %ecx,%edx
8010034c:	88 02                	mov    %al,(%edx)
8010034e:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
80100351:	8b 55 0c             	mov    0xc(%ebp),%edx
80100354:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80100357:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010035a:	ba 00 00 00 00       	mov    $0x0,%edx
8010035f:	f7 75 d4             	divl   -0x2c(%ebp)
80100362:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100365:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100369:	75 c4                	jne    8010032f <printint+0x35>

  if(sign)
8010036b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010036f:	74 25                	je     80100396 <printint+0x9c>
    buf[i++] = '-';
80100371:	8d 55 e0             	lea    -0x20(%ebp),%edx
80100374:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100377:	01 d0                	add    %edx,%eax
80100379:	c6 00 2d             	movb   $0x2d,(%eax)
8010037c:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
8010037f:	eb 15                	jmp    80100396 <printint+0x9c>
    consputc(buf[i]);
80100381:	8d 55 e0             	lea    -0x20(%ebp),%edx
80100384:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100387:	01 d0                	add    %edx,%eax
80100389:	8a 00                	mov    (%eax),%al
8010038b:	0f be c0             	movsbl %al,%eax
8010038e:	89 04 24             	mov    %eax,(%esp)
80100391:	e8 b8 03 00 00       	call   8010074e <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
80100396:	ff 4d f4             	decl   -0xc(%ebp)
80100399:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010039d:	79 e2                	jns    80100381 <printint+0x87>
    consputc(buf[i]);
}
8010039f:	c9                   	leave  
801003a0:	c3                   	ret    

801003a1 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003a1:	55                   	push   %ebp
801003a2:	89 e5                	mov    %esp,%ebp
801003a4:	83 ec 38             	sub    $0x38,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003a7:	a1 14 c6 10 80       	mov    0x8010c614,%eax
801003ac:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003af:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003b3:	74 0c                	je     801003c1 <cprintf+0x20>
    acquire(&cons.lock);
801003b5:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
801003bc:	e8 9e 4b 00 00       	call   80104f5f <acquire>

  if (fmt == 0)
801003c1:	8b 45 08             	mov    0x8(%ebp),%eax
801003c4:	85 c0                	test   %eax,%eax
801003c6:	75 0c                	jne    801003d4 <cprintf+0x33>
    panic("null fmt");
801003c8:	c7 04 24 b6 88 10 80 	movl   $0x801088b6,(%esp)
801003cf:	e8 62 01 00 00       	call   80100536 <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003d4:	8d 45 0c             	lea    0xc(%ebp),%eax
801003d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801003da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801003e1:	e9 1a 01 00 00       	jmp    80100500 <cprintf+0x15f>
    if(c != '%'){
801003e6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
801003ea:	74 10                	je     801003fc <cprintf+0x5b>
      consputc(c);
801003ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801003ef:	89 04 24             	mov    %eax,(%esp)
801003f2:	e8 57 03 00 00       	call   8010074e <consputc>
      continue;
801003f7:	e9 01 01 00 00       	jmp    801004fd <cprintf+0x15c>
    }
    c = fmt[++i] & 0xff;
801003fc:	8b 55 08             	mov    0x8(%ebp),%edx
801003ff:	ff 45 f4             	incl   -0xc(%ebp)
80100402:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100405:	01 d0                	add    %edx,%eax
80100407:	8a 00                	mov    (%eax),%al
80100409:	0f be c0             	movsbl %al,%eax
8010040c:	25 ff 00 00 00       	and    $0xff,%eax
80100411:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
80100414:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100418:	0f 84 03 01 00 00    	je     80100521 <cprintf+0x180>
      break;
    switch(c){
8010041e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100421:	83 f8 70             	cmp    $0x70,%eax
80100424:	74 4d                	je     80100473 <cprintf+0xd2>
80100426:	83 f8 70             	cmp    $0x70,%eax
80100429:	7f 13                	jg     8010043e <cprintf+0x9d>
8010042b:	83 f8 25             	cmp    $0x25,%eax
8010042e:	0f 84 a3 00 00 00    	je     801004d7 <cprintf+0x136>
80100434:	83 f8 64             	cmp    $0x64,%eax
80100437:	74 14                	je     8010044d <cprintf+0xac>
80100439:	e9 a7 00 00 00       	jmp    801004e5 <cprintf+0x144>
8010043e:	83 f8 73             	cmp    $0x73,%eax
80100441:	74 53                	je     80100496 <cprintf+0xf5>
80100443:	83 f8 78             	cmp    $0x78,%eax
80100446:	74 2b                	je     80100473 <cprintf+0xd2>
80100448:	e9 98 00 00 00       	jmp    801004e5 <cprintf+0x144>
    case 'd':
      printint(*argp++, 10, 1);
8010044d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100450:	8b 00                	mov    (%eax),%eax
80100452:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
80100456:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
8010045d:	00 
8010045e:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80100465:	00 
80100466:	89 04 24             	mov    %eax,(%esp)
80100469:	e8 8c fe ff ff       	call   801002fa <printint>
      break;
8010046e:	e9 8a 00 00 00       	jmp    801004fd <cprintf+0x15c>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
80100473:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100476:	8b 00                	mov    (%eax),%eax
80100478:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
8010047c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100483:	00 
80100484:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
8010048b:	00 
8010048c:	89 04 24             	mov    %eax,(%esp)
8010048f:	e8 66 fe ff ff       	call   801002fa <printint>
      break;
80100494:	eb 67                	jmp    801004fd <cprintf+0x15c>
    case 's':
      if((s = (char*)*argp++) == 0)
80100496:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100499:	8b 00                	mov    (%eax),%eax
8010049b:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010049e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004a2:	0f 94 c0             	sete   %al
801004a5:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
801004a9:	84 c0                	test   %al,%al
801004ab:	74 1e                	je     801004cb <cprintf+0x12a>
        s = "(null)";
801004ad:	c7 45 ec bf 88 10 80 	movl   $0x801088bf,-0x14(%ebp)
      for(; *s; s++)
801004b4:	eb 15                	jmp    801004cb <cprintf+0x12a>
        consputc(*s);
801004b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004b9:	8a 00                	mov    (%eax),%al
801004bb:	0f be c0             	movsbl %al,%eax
801004be:	89 04 24             	mov    %eax,(%esp)
801004c1:	e8 88 02 00 00       	call   8010074e <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801004c6:	ff 45 ec             	incl   -0x14(%ebp)
801004c9:	eb 01                	jmp    801004cc <cprintf+0x12b>
801004cb:	90                   	nop
801004cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004cf:	8a 00                	mov    (%eax),%al
801004d1:	84 c0                	test   %al,%al
801004d3:	75 e1                	jne    801004b6 <cprintf+0x115>
        consputc(*s);
      break;
801004d5:	eb 26                	jmp    801004fd <cprintf+0x15c>
    case '%':
      consputc('%');
801004d7:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004de:	e8 6b 02 00 00       	call   8010074e <consputc>
      break;
801004e3:	eb 18                	jmp    801004fd <cprintf+0x15c>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
801004e5:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004ec:	e8 5d 02 00 00       	call   8010074e <consputc>
      consputc(c);
801004f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801004f4:	89 04 24             	mov    %eax,(%esp)
801004f7:	e8 52 02 00 00       	call   8010074e <consputc>
      break;
801004fc:	90                   	nop

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801004fd:	ff 45 f4             	incl   -0xc(%ebp)
80100500:	8b 55 08             	mov    0x8(%ebp),%edx
80100503:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100506:	01 d0                	add    %edx,%eax
80100508:	8a 00                	mov    (%eax),%al
8010050a:	0f be c0             	movsbl %al,%eax
8010050d:	25 ff 00 00 00       	and    $0xff,%eax
80100512:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100515:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100519:	0f 85 c7 fe ff ff    	jne    801003e6 <cprintf+0x45>
8010051f:	eb 01                	jmp    80100522 <cprintf+0x181>
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
80100521:	90                   	nop
      consputc(c);
      break;
    }
  }

  if(locking)
80100522:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100526:	74 0c                	je     80100534 <cprintf+0x193>
    release(&cons.lock);
80100528:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
8010052f:	e8 8d 4a 00 00       	call   80104fc1 <release>
}
80100534:	c9                   	leave  
80100535:	c3                   	ret    

80100536 <panic>:

void
panic(char *s)
{
80100536:	55                   	push   %ebp
80100537:	89 e5                	mov    %esp,%ebp
80100539:	83 ec 48             	sub    $0x48,%esp
  int i;
  uint pcs[10];
  
  cli();
8010053c:	e8 b3 fd ff ff       	call   801002f4 <cli>
  cons.locking = 0;
80100541:	c7 05 14 c6 10 80 00 	movl   $0x0,0x8010c614
80100548:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
8010054b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100551:	8a 00                	mov    (%eax),%al
80100553:	0f b6 c0             	movzbl %al,%eax
80100556:	89 44 24 04          	mov    %eax,0x4(%esp)
8010055a:	c7 04 24 c6 88 10 80 	movl   $0x801088c6,(%esp)
80100561:	e8 3b fe ff ff       	call   801003a1 <cprintf>
  cprintf(s);
80100566:	8b 45 08             	mov    0x8(%ebp),%eax
80100569:	89 04 24             	mov    %eax,(%esp)
8010056c:	e8 30 fe ff ff       	call   801003a1 <cprintf>
  cprintf("\n");
80100571:	c7 04 24 d5 88 10 80 	movl   $0x801088d5,(%esp)
80100578:	e8 24 fe ff ff       	call   801003a1 <cprintf>
  getcallerpcs(&s, pcs);
8010057d:	8d 45 cc             	lea    -0x34(%ebp),%eax
80100580:	89 44 24 04          	mov    %eax,0x4(%esp)
80100584:	8d 45 08             	lea    0x8(%ebp),%eax
80100587:	89 04 24             	mov    %eax,(%esp)
8010058a:	e8 81 4a 00 00       	call   80105010 <getcallerpcs>
  for(i=0; i<10; i++)
8010058f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100596:	eb 1a                	jmp    801005b2 <panic+0x7c>
    cprintf(" %p", pcs[i]);
80100598:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010059b:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
8010059f:	89 44 24 04          	mov    %eax,0x4(%esp)
801005a3:	c7 04 24 d7 88 10 80 	movl   $0x801088d7,(%esp)
801005aa:	e8 f2 fd ff ff       	call   801003a1 <cprintf>
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801005af:	ff 45 f4             	incl   -0xc(%ebp)
801005b2:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005b6:	7e e0                	jle    80100598 <panic+0x62>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801005b8:	c7 05 c0 c5 10 80 01 	movl   $0x1,0x8010c5c0
801005bf:	00 00 00 
  for(;;)
    ;
801005c2:	eb fe                	jmp    801005c2 <panic+0x8c>

801005c4 <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
801005c4:	55                   	push   %ebp
801005c5:	89 e5                	mov    %esp,%ebp
801005c7:	83 ec 28             	sub    $0x28,%esp
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
801005ca:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801005d1:	00 
801005d2:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
801005d9:	e8 fa fc ff ff       	call   801002d8 <outb>
  pos = inb(CRTPORT+1) << 8;
801005de:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
801005e5:	e8 c6 fc ff ff       	call   801002b0 <inb>
801005ea:	0f b6 c0             	movzbl %al,%eax
801005ed:	c1 e0 08             	shl    $0x8,%eax
801005f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
801005f3:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
801005fa:	00 
801005fb:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100602:	e8 d1 fc ff ff       	call   801002d8 <outb>
  pos |= inb(CRTPORT+1);
80100607:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
8010060e:	e8 9d fc ff ff       	call   801002b0 <inb>
80100613:	0f b6 c0             	movzbl %al,%eax
80100616:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
80100619:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
8010061d:	75 1d                	jne    8010063c <cgaputc+0x78>
    pos += 80 - pos%80;
8010061f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100622:	b9 50 00 00 00       	mov    $0x50,%ecx
80100627:	99                   	cltd   
80100628:	f7 f9                	idiv   %ecx
8010062a:	89 d0                	mov    %edx,%eax
8010062c:	ba 50 00 00 00       	mov    $0x50,%edx
80100631:	89 d1                	mov    %edx,%ecx
80100633:	29 c1                	sub    %eax,%ecx
80100635:	89 c8                	mov    %ecx,%eax
80100637:	01 45 f4             	add    %eax,-0xc(%ebp)
8010063a:	eb 31                	jmp    8010066d <cgaputc+0xa9>
  else if(c == BACKSPACE){
8010063c:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
80100643:	75 0b                	jne    80100650 <cgaputc+0x8c>
    if(pos > 0) --pos;
80100645:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100649:	7e 22                	jle    8010066d <cgaputc+0xa9>
8010064b:	ff 4d f4             	decl   -0xc(%ebp)
8010064e:	eb 1d                	jmp    8010066d <cgaputc+0xa9>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100650:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80100655:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100658:	d1 e2                	shl    %edx
8010065a:	01 c2                	add    %eax,%edx
8010065c:	8b 45 08             	mov    0x8(%ebp),%eax
8010065f:	25 ff 00 00 00       	and    $0xff,%eax
80100664:	80 cc 07             	or     $0x7,%ah
80100667:	66 89 02             	mov    %ax,(%edx)
8010066a:	ff 45 f4             	incl   -0xc(%ebp)

  if(pos < 0 || pos > 25*80)
8010066d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100671:	78 09                	js     8010067c <cgaputc+0xb8>
80100673:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
8010067a:	7e 0c                	jle    80100688 <cgaputc+0xc4>
    panic("pos under/overflow");
8010067c:	c7 04 24 db 88 10 80 	movl   $0x801088db,(%esp)
80100683:	e8 ae fe ff ff       	call   80100536 <panic>
  
  if((pos/80) >= 24){  // Scroll up.
80100688:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
8010068f:	7e 53                	jle    801006e4 <cgaputc+0x120>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100691:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80100696:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
8010069c:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006a1:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801006a8:	00 
801006a9:	89 54 24 04          	mov    %edx,0x4(%esp)
801006ad:	89 04 24             	mov    %eax,(%esp)
801006b0:	e8 c9 4b 00 00       	call   8010527e <memmove>
    pos -= 80;
801006b5:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801006b9:	b8 80 07 00 00       	mov    $0x780,%eax
801006be:	2b 45 f4             	sub    -0xc(%ebp),%eax
801006c1:	d1 e0                	shl    %eax
801006c3:	8b 15 00 a0 10 80    	mov    0x8010a000,%edx
801006c9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801006cc:	d1 e1                	shl    %ecx
801006ce:	01 ca                	add    %ecx,%edx
801006d0:	89 44 24 08          	mov    %eax,0x8(%esp)
801006d4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801006db:	00 
801006dc:	89 14 24             	mov    %edx,(%esp)
801006df:	e8 ce 4a 00 00       	call   801051b2 <memset>
  }
  
  outb(CRTPORT, 14);
801006e4:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801006eb:	00 
801006ec:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
801006f3:	e8 e0 fb ff ff       	call   801002d8 <outb>
  outb(CRTPORT+1, pos>>8);
801006f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801006fb:	c1 f8 08             	sar    $0x8,%eax
801006fe:	0f b6 c0             	movzbl %al,%eax
80100701:	89 44 24 04          	mov    %eax,0x4(%esp)
80100705:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
8010070c:	e8 c7 fb ff ff       	call   801002d8 <outb>
  outb(CRTPORT, 15);
80100711:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80100718:	00 
80100719:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100720:	e8 b3 fb ff ff       	call   801002d8 <outb>
  outb(CRTPORT+1, pos);
80100725:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100728:	0f b6 c0             	movzbl %al,%eax
8010072b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010072f:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100736:	e8 9d fb ff ff       	call   801002d8 <outb>
  crt[pos] = ' ' | 0x0700;
8010073b:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80100740:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100743:	d1 e2                	shl    %edx
80100745:	01 d0                	add    %edx,%eax
80100747:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
8010074c:	c9                   	leave  
8010074d:	c3                   	ret    

8010074e <consputc>:

void
consputc(int c)
{
8010074e:	55                   	push   %ebp
8010074f:	89 e5                	mov    %esp,%ebp
80100751:	83 ec 18             	sub    $0x18,%esp
  if(panicked){
80100754:	a1 c0 c5 10 80       	mov    0x8010c5c0,%eax
80100759:	85 c0                	test   %eax,%eax
8010075b:	74 07                	je     80100764 <consputc+0x16>
    cli();
8010075d:	e8 92 fb ff ff       	call   801002f4 <cli>
    for(;;)
      ;
80100762:	eb fe                	jmp    80100762 <consputc+0x14>
  }

  if(c == BACKSPACE){
80100764:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010076b:	75 26                	jne    80100793 <consputc+0x45>
    uartputc('\b'); uartputc(' '); uartputc('\b');
8010076d:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100774:	e8 89 67 00 00       	call   80106f02 <uartputc>
80100779:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100780:	e8 7d 67 00 00       	call   80106f02 <uartputc>
80100785:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010078c:	e8 71 67 00 00       	call   80106f02 <uartputc>
80100791:	eb 0b                	jmp    8010079e <consputc+0x50>
  } else
    uartputc(c);
80100793:	8b 45 08             	mov    0x8(%ebp),%eax
80100796:	89 04 24             	mov    %eax,(%esp)
80100799:	e8 64 67 00 00       	call   80106f02 <uartputc>
  cgaputc(c);
8010079e:	8b 45 08             	mov    0x8(%ebp),%eax
801007a1:	89 04 24             	mov    %eax,(%esp)
801007a4:	e8 1b fe ff ff       	call   801005c4 <cgaputc>
}
801007a9:	c9                   	leave  
801007aa:	c3                   	ret    

801007ab <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007ab:	55                   	push   %ebp
801007ac:	89 e5                	mov    %esp,%ebp
801007ae:	83 ec 28             	sub    $0x28,%esp
  int c, doprocdump = 0;
801007b1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&cons.lock);
801007b8:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
801007bf:	e8 9b 47 00 00       	call   80104f5f <acquire>
  while((c = getc()) >= 0){
801007c4:	e9 3a 01 00 00       	jmp    80100903 <consoleintr+0x158>
    switch(c){
801007c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801007cc:	83 f8 10             	cmp    $0x10,%eax
801007cf:	74 1e                	je     801007ef <consoleintr+0x44>
801007d1:	83 f8 10             	cmp    $0x10,%eax
801007d4:	7f 0a                	jg     801007e0 <consoleintr+0x35>
801007d6:	83 f8 08             	cmp    $0x8,%eax
801007d9:	74 65                	je     80100840 <consoleintr+0x95>
801007db:	e9 8f 00 00 00       	jmp    8010086f <consoleintr+0xc4>
801007e0:	83 f8 15             	cmp    $0x15,%eax
801007e3:	74 2f                	je     80100814 <consoleintr+0x69>
801007e5:	83 f8 7f             	cmp    $0x7f,%eax
801007e8:	74 56                	je     80100840 <consoleintr+0x95>
801007ea:	e9 80 00 00 00       	jmp    8010086f <consoleintr+0xc4>
    case C('P'):  // Process listing.
      doprocdump = 1;   // procdump() locks cons.lock indirectly; invoke later
801007ef:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
      break;
801007f6:	e9 08 01 00 00       	jmp    80100903 <consoleintr+0x158>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801007fb:	a1 28 18 11 80       	mov    0x80111828,%eax
80100800:	48                   	dec    %eax
80100801:	a3 28 18 11 80       	mov    %eax,0x80111828
        consputc(BACKSPACE);
80100806:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
8010080d:	e8 3c ff ff ff       	call   8010074e <consputc>
80100812:	eb 01                	jmp    80100815 <consoleintr+0x6a>
    switch(c){
    case C('P'):  // Process listing.
      doprocdump = 1;   // procdump() locks cons.lock indirectly; invoke later
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100814:	90                   	nop
80100815:	8b 15 28 18 11 80    	mov    0x80111828,%edx
8010081b:	a1 24 18 11 80       	mov    0x80111824,%eax
80100820:	39 c2                	cmp    %eax,%edx
80100822:	0f 84 d4 00 00 00    	je     801008fc <consoleintr+0x151>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100828:	a1 28 18 11 80       	mov    0x80111828,%eax
8010082d:	48                   	dec    %eax
8010082e:	83 e0 7f             	and    $0x7f,%eax
80100831:	8a 80 a0 17 11 80    	mov    -0x7feee860(%eax),%al
    switch(c){
    case C('P'):  // Process listing.
      doprocdump = 1;   // procdump() locks cons.lock indirectly; invoke later
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100837:	3c 0a                	cmp    $0xa,%al
80100839:	75 c0                	jne    801007fb <consoleintr+0x50>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
8010083b:	e9 bc 00 00 00       	jmp    801008fc <consoleintr+0x151>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100840:	8b 15 28 18 11 80    	mov    0x80111828,%edx
80100846:	a1 24 18 11 80       	mov    0x80111824,%eax
8010084b:	39 c2                	cmp    %eax,%edx
8010084d:	0f 84 ac 00 00 00    	je     801008ff <consoleintr+0x154>
        input.e--;
80100853:	a1 28 18 11 80       	mov    0x80111828,%eax
80100858:	48                   	dec    %eax
80100859:	a3 28 18 11 80       	mov    %eax,0x80111828
        consputc(BACKSPACE);
8010085e:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
80100865:	e8 e4 fe ff ff       	call   8010074e <consputc>
      }
      break;
8010086a:	e9 90 00 00 00       	jmp    801008ff <consoleintr+0x154>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
8010086f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100873:	0f 84 89 00 00 00    	je     80100902 <consoleintr+0x157>
80100879:	8b 15 28 18 11 80    	mov    0x80111828,%edx
8010087f:	a1 20 18 11 80       	mov    0x80111820,%eax
80100884:	89 d1                	mov    %edx,%ecx
80100886:	29 c1                	sub    %eax,%ecx
80100888:	89 c8                	mov    %ecx,%eax
8010088a:	83 f8 7f             	cmp    $0x7f,%eax
8010088d:	77 73                	ja     80100902 <consoleintr+0x157>
        c = (c == '\r') ? '\n' : c;
8010088f:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
80100893:	74 05                	je     8010089a <consoleintr+0xef>
80100895:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100898:	eb 05                	jmp    8010089f <consoleintr+0xf4>
8010089a:	b8 0a 00 00 00       	mov    $0xa,%eax
8010089f:	89 45 f0             	mov    %eax,-0x10(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
801008a2:	a1 28 18 11 80       	mov    0x80111828,%eax
801008a7:	89 c1                	mov    %eax,%ecx
801008a9:	83 e1 7f             	and    $0x7f,%ecx
801008ac:	8b 55 f0             	mov    -0x10(%ebp),%edx
801008af:	88 91 a0 17 11 80    	mov    %dl,-0x7feee860(%ecx)
801008b5:	40                   	inc    %eax
801008b6:	a3 28 18 11 80       	mov    %eax,0x80111828
        consputc(c);
801008bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801008be:	89 04 24             	mov    %eax,(%esp)
801008c1:	e8 88 fe ff ff       	call   8010074e <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008c6:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
801008ca:	74 18                	je     801008e4 <consoleintr+0x139>
801008cc:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
801008d0:	74 12                	je     801008e4 <consoleintr+0x139>
801008d2:	a1 28 18 11 80       	mov    0x80111828,%eax
801008d7:	8b 15 20 18 11 80    	mov    0x80111820,%edx
801008dd:	83 ea 80             	sub    $0xffffff80,%edx
801008e0:	39 d0                	cmp    %edx,%eax
801008e2:	75 1e                	jne    80100902 <consoleintr+0x157>
          input.w = input.e;
801008e4:	a1 28 18 11 80       	mov    0x80111828,%eax
801008e9:	a3 24 18 11 80       	mov    %eax,0x80111824
          wakeup(&input.r);
801008ee:	c7 04 24 20 18 11 80 	movl   $0x80111820,(%esp)
801008f5:	e8 5c 44 00 00       	call   80104d56 <wakeup>
        }
      }
      break;
801008fa:	eb 06                	jmp    80100902 <consoleintr+0x157>
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
801008fc:	90                   	nop
801008fd:	eb 04                	jmp    80100903 <consoleintr+0x158>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
801008ff:	90                   	nop
80100900:	eb 01                	jmp    80100903 <consoleintr+0x158>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          input.w = input.e;
          wakeup(&input.r);
        }
      }
      break;
80100902:	90                   	nop
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100903:	8b 45 08             	mov    0x8(%ebp),%eax
80100906:	ff d0                	call   *%eax
80100908:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010090b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010090f:	0f 89 b4 fe ff ff    	jns    801007c9 <consoleintr+0x1e>
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100915:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
8010091c:	e8 a0 46 00 00       	call   80104fc1 <release>
  if(doprocdump) {
80100921:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100925:	74 05                	je     8010092c <consoleintr+0x181>
    procdump();  // now call procdump() wo. cons.lock held
80100927:	e8 d0 44 00 00       	call   80104dfc <procdump>
  }
}
8010092c:	c9                   	leave  
8010092d:	c3                   	ret    

8010092e <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
8010092e:	55                   	push   %ebp
8010092f:	89 e5                	mov    %esp,%ebp
80100931:	83 ec 28             	sub    $0x28,%esp
  uint target;
  int c;

  iunlock(ip);
80100934:	8b 45 08             	mov    0x8(%ebp),%eax
80100937:	89 04 24             	mov    %eax,(%esp)
8010093a:	e8 c9 10 00 00       	call   80101a08 <iunlock>
  target = n;
8010093f:	8b 45 10             	mov    0x10(%ebp),%eax
80100942:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
80100945:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
8010094c:	e8 0e 46 00 00       	call   80104f5f <acquire>
  while(n > 0){
80100951:	e9 a1 00 00 00       	jmp    801009f7 <consoleread+0xc9>
    while(input.r == input.w){
      if(proc->killed){
80100956:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010095c:	8b 40 24             	mov    0x24(%eax),%eax
8010095f:	85 c0                	test   %eax,%eax
80100961:	74 21                	je     80100984 <consoleread+0x56>
        release(&cons.lock);
80100963:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
8010096a:	e8 52 46 00 00       	call   80104fc1 <release>
        ilock(ip);
8010096f:	8b 45 08             	mov    0x8(%ebp),%eax
80100972:	89 04 24             	mov    %eax,(%esp)
80100975:	e8 3d 0f 00 00       	call   801018b7 <ilock>
        return -1;
8010097a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010097f:	e9 a2 00 00 00       	jmp    80100a26 <consoleread+0xf8>
      }
      sleep(&input.r, &cons.lock);
80100984:	c7 44 24 04 e0 c5 10 	movl   $0x8010c5e0,0x4(%esp)
8010098b:	80 
8010098c:	c7 04 24 20 18 11 80 	movl   $0x80111820,(%esp)
80100993:	e8 e2 42 00 00       	call   80104c7a <sleep>
80100998:	eb 01                	jmp    8010099b <consoleread+0x6d>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
8010099a:	90                   	nop
8010099b:	8b 15 20 18 11 80    	mov    0x80111820,%edx
801009a1:	a1 24 18 11 80       	mov    0x80111824,%eax
801009a6:	39 c2                	cmp    %eax,%edx
801009a8:	74 ac                	je     80100956 <consoleread+0x28>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
801009aa:	a1 20 18 11 80       	mov    0x80111820,%eax
801009af:	89 c2                	mov    %eax,%edx
801009b1:	83 e2 7f             	and    $0x7f,%edx
801009b4:	8a 92 a0 17 11 80    	mov    -0x7feee860(%edx),%dl
801009ba:	0f be d2             	movsbl %dl,%edx
801009bd:	89 55 f0             	mov    %edx,-0x10(%ebp)
801009c0:	40                   	inc    %eax
801009c1:	a3 20 18 11 80       	mov    %eax,0x80111820
    if(c == C('D')){  // EOF
801009c6:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
801009ca:	75 15                	jne    801009e1 <consoleread+0xb3>
      if(n < target){
801009cc:	8b 45 10             	mov    0x10(%ebp),%eax
801009cf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801009d2:	73 2b                	jae    801009ff <consoleread+0xd1>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
801009d4:	a1 20 18 11 80       	mov    0x80111820,%eax
801009d9:	48                   	dec    %eax
801009da:	a3 20 18 11 80       	mov    %eax,0x80111820
      }
      break;
801009df:	eb 1e                	jmp    801009ff <consoleread+0xd1>
    }
    *dst++ = c;
801009e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801009e4:	88 c2                	mov    %al,%dl
801009e6:	8b 45 0c             	mov    0xc(%ebp),%eax
801009e9:	88 10                	mov    %dl,(%eax)
801009eb:	ff 45 0c             	incl   0xc(%ebp)
    --n;
801009ee:	ff 4d 10             	decl   0x10(%ebp)
    if(c == '\n')
801009f1:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
801009f5:	74 0b                	je     80100a02 <consoleread+0xd4>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
801009f7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801009fb:	7f 9d                	jg     8010099a <consoleread+0x6c>
801009fd:	eb 04                	jmp    80100a03 <consoleread+0xd5>
      if(n < target){
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
801009ff:	90                   	nop
80100a00:	eb 01                	jmp    80100a03 <consoleread+0xd5>
    }
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
80100a02:	90                   	nop
  }
  release(&cons.lock);
80100a03:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100a0a:	e8 b2 45 00 00       	call   80104fc1 <release>
  ilock(ip);
80100a0f:	8b 45 08             	mov    0x8(%ebp),%eax
80100a12:	89 04 24             	mov    %eax,(%esp)
80100a15:	e8 9d 0e 00 00       	call   801018b7 <ilock>

  return target - n;
80100a1a:	8b 45 10             	mov    0x10(%ebp),%eax
80100a1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a20:	89 d1                	mov    %edx,%ecx
80100a22:	29 c1                	sub    %eax,%ecx
80100a24:	89 c8                	mov    %ecx,%eax
}
80100a26:	c9                   	leave  
80100a27:	c3                   	ret    

80100a28 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100a28:	55                   	push   %ebp
80100a29:	89 e5                	mov    %esp,%ebp
80100a2b:	83 ec 28             	sub    $0x28,%esp
  int i;

  iunlock(ip);
80100a2e:	8b 45 08             	mov    0x8(%ebp),%eax
80100a31:	89 04 24             	mov    %eax,(%esp)
80100a34:	e8 cf 0f 00 00       	call   80101a08 <iunlock>
  acquire(&cons.lock);
80100a39:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100a40:	e8 1a 45 00 00       	call   80104f5f <acquire>
  for(i = 0; i < n; i++)
80100a45:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100a4c:	eb 1d                	jmp    80100a6b <consolewrite+0x43>
    consputc(buf[i] & 0xff);
80100a4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a51:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a54:	01 d0                	add    %edx,%eax
80100a56:	8a 00                	mov    (%eax),%al
80100a58:	0f be c0             	movsbl %al,%eax
80100a5b:	25 ff 00 00 00       	and    $0xff,%eax
80100a60:	89 04 24             	mov    %eax,(%esp)
80100a63:	e8 e6 fc ff ff       	call   8010074e <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100a68:	ff 45 f4             	incl   -0xc(%ebp)
80100a6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100a6e:	3b 45 10             	cmp    0x10(%ebp),%eax
80100a71:	7c db                	jl     80100a4e <consolewrite+0x26>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100a73:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100a7a:	e8 42 45 00 00       	call   80104fc1 <release>
  ilock(ip);
80100a7f:	8b 45 08             	mov    0x8(%ebp),%eax
80100a82:	89 04 24             	mov    %eax,(%esp)
80100a85:	e8 2d 0e 00 00       	call   801018b7 <ilock>

  return n;
80100a8a:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100a8d:	c9                   	leave  
80100a8e:	c3                   	ret    

80100a8f <consoleinit>:

void
consoleinit(void)
{
80100a8f:	55                   	push   %ebp
80100a90:	89 e5                	mov    %esp,%ebp
80100a92:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100a95:	c7 44 24 04 ee 88 10 	movl   $0x801088ee,0x4(%esp)
80100a9c:	80 
80100a9d:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100aa4:	e8 95 44 00 00       	call   80104f3e <initlock>

  devsw[CONSOLE].write = consolewrite;
80100aa9:	c7 05 ec 21 11 80 28 	movl   $0x80100a28,0x801121ec
80100ab0:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100ab3:	c7 05 e8 21 11 80 2e 	movl   $0x8010092e,0x801121e8
80100aba:	09 10 80 
  cons.locking = 1;
80100abd:	c7 05 14 c6 10 80 01 	movl   $0x1,0x8010c614
80100ac4:	00 00 00 

  picenable(IRQ_KBD);
80100ac7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100ace:	e8 c1 33 00 00       	call   80103e94 <picenable>
  ioapicenable(IRQ_KBD, 0);
80100ad3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100ada:	00 
80100adb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100ae2:	e8 06 1f 00 00       	call   801029ed <ioapicenable>
}
80100ae7:	c9                   	leave  
80100ae8:	c3                   	ret    
80100ae9:	66 90                	xchg   %ax,%ax
80100aeb:	90                   	nop

80100aec <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100aec:	55                   	push   %ebp
80100aed:	89 e5                	mov    %esp,%ebp
80100aef:	81 ec 38 01 00 00    	sub    $0x138,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
80100af5:	e8 ad 29 00 00       	call   801034a7 <begin_op>
  if((ip = namei(path)) == 0){
80100afa:	8b 45 08             	mov    0x8(%ebp),%eax
80100afd:	89 04 24             	mov    %eax,(%esp)
80100b00:	e8 52 19 00 00       	call   80102457 <namei>
80100b05:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100b08:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100b0c:	75 0f                	jne    80100b1d <exec+0x31>
    end_op();
80100b0e:	e8 13 2a 00 00       	call   80103526 <end_op>
    return -1;
80100b13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b18:	e9 ed 03 00 00       	jmp    80100f0a <exec+0x41e>
  }
  ilock(ip);
80100b1d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100b20:	89 04 24             	mov    %eax,(%esp)
80100b23:	e8 8f 0d 00 00       	call   801018b7 <ilock>
  pgdir = 0;
80100b28:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100b2f:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
80100b36:	00 
80100b37:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100b3e:	00 
80100b3f:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100b45:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b49:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100b4c:	89 04 24             	mov    %eax,(%esp)
80100b4f:	e8 70 12 00 00       	call   80101dc4 <readi>
80100b54:	83 f8 33             	cmp    $0x33,%eax
80100b57:	0f 86 62 03 00 00    	jbe    80100ebf <exec+0x3d3>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100b5d:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b63:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100b68:	0f 85 54 03 00 00    	jne    80100ec2 <exec+0x3d6>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100b6e:	e8 b5 74 00 00       	call   80108028 <setupkvm>
80100b73:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100b76:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100b7a:	0f 84 45 03 00 00    	je     80100ec5 <exec+0x3d9>
    goto bad;

  // Load program into memory.
  sz = 0;
80100b80:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b87:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100b8e:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100b94:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100b97:	e9 c4 00 00 00       	jmp    80100c60 <exec+0x174>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b9c:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100b9f:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100ba6:	00 
80100ba7:	89 44 24 08          	mov    %eax,0x8(%esp)
80100bab:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100bb1:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bb5:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100bb8:	89 04 24             	mov    %eax,(%esp)
80100bbb:	e8 04 12 00 00       	call   80101dc4 <readi>
80100bc0:	83 f8 20             	cmp    $0x20,%eax
80100bc3:	0f 85 ff 02 00 00    	jne    80100ec8 <exec+0x3dc>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100bc9:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100bcf:	83 f8 01             	cmp    $0x1,%eax
80100bd2:	75 7f                	jne    80100c53 <exec+0x167>
      continue;
    if(ph.memsz < ph.filesz)
80100bd4:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100bda:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100be0:	39 c2                	cmp    %eax,%edx
80100be2:	0f 82 e3 02 00 00    	jb     80100ecb <exec+0x3df>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100be8:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100bee:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100bf4:	01 d0                	add    %edx,%eax
80100bf6:	89 44 24 08          	mov    %eax,0x8(%esp)
80100bfa:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100bfd:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c01:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100c04:	89 04 24             	mov    %eax,(%esp)
80100c07:	e8 e2 77 00 00       	call   801083ee <allocuvm>
80100c0c:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100c0f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100c13:	0f 84 b5 02 00 00    	je     80100ece <exec+0x3e2>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c19:	8b 8d fc fe ff ff    	mov    -0x104(%ebp),%ecx
80100c1f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100c25:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100c2b:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80100c2f:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100c33:	8b 55 d8             	mov    -0x28(%ebp),%edx
80100c36:	89 54 24 08          	mov    %edx,0x8(%esp)
80100c3a:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c3e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100c41:	89 04 24             	mov    %eax,(%esp)
80100c44:	e8 b6 76 00 00       	call   801082ff <loaduvm>
80100c49:	85 c0                	test   %eax,%eax
80100c4b:	0f 88 80 02 00 00    	js     80100ed1 <exec+0x3e5>
80100c51:	eb 01                	jmp    80100c54 <exec+0x168>
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
      continue;
80100c53:	90                   	nop
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c54:	ff 45 ec             	incl   -0x14(%ebp)
80100c57:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100c5a:	83 c0 20             	add    $0x20,%eax
80100c5d:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100c60:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
80100c66:	0f b7 c0             	movzwl %ax,%eax
80100c69:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100c6c:	0f 8f 2a ff ff ff    	jg     80100b9c <exec+0xb0>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100c72:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100c75:	89 04 24             	mov    %eax,(%esp)
80100c78:	e8 c1 0e 00 00       	call   80101b3e <iunlockput>
  end_op();
80100c7d:	e8 a4 28 00 00       	call   80103526 <end_op>
  ip = 0;
80100c82:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100c89:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100c8c:	05 ff 0f 00 00       	add    $0xfff,%eax
80100c91:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100c96:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c99:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100c9c:	05 00 20 00 00       	add    $0x2000,%eax
80100ca1:	89 44 24 08          	mov    %eax,0x8(%esp)
80100ca5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ca8:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100caf:	89 04 24             	mov    %eax,(%esp)
80100cb2:	e8 37 77 00 00       	call   801083ee <allocuvm>
80100cb7:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100cba:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100cbe:	0f 84 10 02 00 00    	je     80100ed4 <exec+0x3e8>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cc4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cc7:	2d 00 20 00 00       	sub    $0x2000,%eax
80100ccc:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cd0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100cd3:	89 04 24             	mov    %eax,(%esp)
80100cd6:	e8 42 79 00 00       	call   8010861d <clearpteu>
  sp = sz;
80100cdb:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cde:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100ce1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100ce8:	e9 94 00 00 00       	jmp    80100d81 <exec+0x295>
    if(argc >= MAXARG)
80100ced:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100cf1:	0f 87 e0 01 00 00    	ja     80100ed7 <exec+0x3eb>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cf7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100cfa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d01:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d04:	01 d0                	add    %edx,%eax
80100d06:	8b 00                	mov    (%eax),%eax
80100d08:	89 04 24             	mov    %eax,(%esp)
80100d0b:	e8 fd 46 00 00       	call   8010540d <strlen>
80100d10:	f7 d0                	not    %eax
80100d12:	89 c2                	mov    %eax,%edx
80100d14:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d17:	01 d0                	add    %edx,%eax
80100d19:	83 e0 fc             	and    $0xfffffffc,%eax
80100d1c:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d22:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d29:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d2c:	01 d0                	add    %edx,%eax
80100d2e:	8b 00                	mov    (%eax),%eax
80100d30:	89 04 24             	mov    %eax,(%esp)
80100d33:	e8 d5 46 00 00       	call   8010540d <strlen>
80100d38:	40                   	inc    %eax
80100d39:	89 c2                	mov    %eax,%edx
80100d3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d3e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
80100d45:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d48:	01 c8                	add    %ecx,%eax
80100d4a:	8b 00                	mov    (%eax),%eax
80100d4c:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100d50:	89 44 24 08          	mov    %eax,0x8(%esp)
80100d54:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d57:	89 44 24 04          	mov    %eax,0x4(%esp)
80100d5b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100d5e:	89 04 24             	mov    %eax,(%esp)
80100d61:	e8 7c 7a 00 00       	call   801087e2 <copyout>
80100d66:	85 c0                	test   %eax,%eax
80100d68:	0f 88 6c 01 00 00    	js     80100eda <exec+0x3ee>
      goto bad;
    ustack[3+argc] = sp;
80100d6e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d71:	8d 50 03             	lea    0x3(%eax),%edx
80100d74:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d77:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d7e:	ff 45 e4             	incl   -0x1c(%ebp)
80100d81:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d84:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d8b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d8e:	01 d0                	add    %edx,%eax
80100d90:	8b 00                	mov    (%eax),%eax
80100d92:	85 c0                	test   %eax,%eax
80100d94:	0f 85 53 ff ff ff    	jne    80100ced <exec+0x201>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100d9a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d9d:	83 c0 03             	add    $0x3,%eax
80100da0:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100da7:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100dab:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100db2:	ff ff ff 
  ustack[1] = argc;
80100db5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100db8:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100dbe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dc1:	40                   	inc    %eax
80100dc2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100dc9:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100dcc:	29 d0                	sub    %edx,%eax
80100dce:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100dd4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dd7:	83 c0 04             	add    $0x4,%eax
80100dda:	c1 e0 02             	shl    $0x2,%eax
80100ddd:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100de0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100de3:	83 c0 04             	add    $0x4,%eax
80100de6:	c1 e0 02             	shl    $0x2,%eax
80100de9:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100ded:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100df3:	89 44 24 08          	mov    %eax,0x8(%esp)
80100df7:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100dfa:	89 44 24 04          	mov    %eax,0x4(%esp)
80100dfe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100e01:	89 04 24             	mov    %eax,(%esp)
80100e04:	e8 d9 79 00 00       	call   801087e2 <copyout>
80100e09:	85 c0                	test   %eax,%eax
80100e0b:	0f 88 cc 00 00 00    	js     80100edd <exec+0x3f1>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e11:	8b 45 08             	mov    0x8(%ebp),%eax
80100e14:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100e17:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100e1d:	eb 13                	jmp    80100e32 <exec+0x346>
    if(*s == '/')
80100e1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e22:	8a 00                	mov    (%eax),%al
80100e24:	3c 2f                	cmp    $0x2f,%al
80100e26:	75 07                	jne    80100e2f <exec+0x343>
      last = s+1;
80100e28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e2b:	40                   	inc    %eax
80100e2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e2f:	ff 45 f4             	incl   -0xc(%ebp)
80100e32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e35:	8a 00                	mov    (%eax),%al
80100e37:	84 c0                	test   %al,%al
80100e39:	75 e4                	jne    80100e1f <exec+0x333>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100e3b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e41:	8d 50 6c             	lea    0x6c(%eax),%edx
80100e44:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100e4b:	00 
80100e4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100e4f:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e53:	89 14 24             	mov    %edx,(%esp)
80100e56:	e8 69 45 00 00       	call   801053c4 <safestrcpy>

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100e5b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e61:	8b 40 04             	mov    0x4(%eax),%eax
80100e64:	89 45 d0             	mov    %eax,-0x30(%ebp)
  proc->pgdir = pgdir;
80100e67:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e6d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100e70:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100e73:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e79:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100e7c:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100e7e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e84:	8b 40 18             	mov    0x18(%eax),%eax
80100e87:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100e8d:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100e90:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e96:	8b 40 18             	mov    0x18(%eax),%eax
80100e99:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100e9c:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100e9f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ea5:	89 04 24             	mov    %eax,(%esp)
80100ea8:	e8 6c 72 00 00       	call   80108119 <switchuvm>
  freevm(oldpgdir);
80100ead:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100eb0:	89 04 24             	mov    %eax,(%esp)
80100eb3:	e8 cc 76 00 00       	call   80108584 <freevm>
  return 0;
80100eb8:	b8 00 00 00 00       	mov    $0x0,%eax
80100ebd:	eb 4b                	jmp    80100f0a <exec+0x41e>
  ilock(ip);
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
    goto bad;
80100ebf:	90                   	nop
80100ec0:	eb 1c                	jmp    80100ede <exec+0x3f2>
  if(elf.magic != ELF_MAGIC)
    goto bad;
80100ec2:	90                   	nop
80100ec3:	eb 19                	jmp    80100ede <exec+0x3f2>

  if((pgdir = setupkvm()) == 0)
    goto bad;
80100ec5:	90                   	nop
80100ec6:	eb 16                	jmp    80100ede <exec+0x3f2>

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
80100ec8:	90                   	nop
80100ec9:	eb 13                	jmp    80100ede <exec+0x3f2>
    if(ph.type != ELF_PROG_LOAD)
      continue;
    if(ph.memsz < ph.filesz)
      goto bad;
80100ecb:	90                   	nop
80100ecc:	eb 10                	jmp    80100ede <exec+0x3f2>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
80100ece:	90                   	nop
80100ecf:	eb 0d                	jmp    80100ede <exec+0x3f2>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
80100ed1:	90                   	nop
80100ed2:	eb 0a                	jmp    80100ede <exec+0x3f2>

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
80100ed4:	90                   	nop
80100ed5:	eb 07                	jmp    80100ede <exec+0x3f2>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
80100ed7:	90                   	nop
80100ed8:	eb 04                	jmp    80100ede <exec+0x3f2>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
80100eda:	90                   	nop
80100edb:	eb 01                	jmp    80100ede <exec+0x3f2>
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;
80100edd:	90                   	nop
  switchuvm(proc);
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
80100ede:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100ee2:	74 0b                	je     80100eef <exec+0x403>
    freevm(pgdir);
80100ee4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100ee7:	89 04 24             	mov    %eax,(%esp)
80100eea:	e8 95 76 00 00       	call   80108584 <freevm>
  if(ip){
80100eef:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100ef3:	74 10                	je     80100f05 <exec+0x419>
    iunlockput(ip);
80100ef5:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100ef8:	89 04 24             	mov    %eax,(%esp)
80100efb:	e8 3e 0c 00 00       	call   80101b3e <iunlockput>
    end_op();
80100f00:	e8 21 26 00 00       	call   80103526 <end_op>
  }
  return -1;
80100f05:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f0a:	c9                   	leave  
80100f0b:	c3                   	ret    

80100f0c <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f0c:	55                   	push   %ebp
80100f0d:	89 e5                	mov    %esp,%ebp
80100f0f:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100f12:	c7 44 24 04 f6 88 10 	movl   $0x801088f6,0x4(%esp)
80100f19:	80 
80100f1a:	c7 04 24 40 18 11 80 	movl   $0x80111840,(%esp)
80100f21:	e8 18 40 00 00       	call   80104f3e <initlock>
}
80100f26:	c9                   	leave  
80100f27:	c3                   	ret    

80100f28 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f28:	55                   	push   %ebp
80100f29:	89 e5                	mov    %esp,%ebp
80100f2b:	83 ec 28             	sub    $0x28,%esp
  struct file *f;

  acquire(&ftable.lock);
80100f2e:	c7 04 24 40 18 11 80 	movl   $0x80111840,(%esp)
80100f35:	e8 25 40 00 00       	call   80104f5f <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f3a:	c7 45 f4 74 18 11 80 	movl   $0x80111874,-0xc(%ebp)
80100f41:	eb 29                	jmp    80100f6c <filealloc+0x44>
    if(f->ref == 0){
80100f43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f46:	8b 40 04             	mov    0x4(%eax),%eax
80100f49:	85 c0                	test   %eax,%eax
80100f4b:	75 1b                	jne    80100f68 <filealloc+0x40>
      f->ref = 1;
80100f4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f50:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80100f57:	c7 04 24 40 18 11 80 	movl   $0x80111840,(%esp)
80100f5e:	e8 5e 40 00 00       	call   80104fc1 <release>
      return f;
80100f63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f66:	eb 1e                	jmp    80100f86 <filealloc+0x5e>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f68:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100f6c:	81 7d f4 d4 21 11 80 	cmpl   $0x801121d4,-0xc(%ebp)
80100f73:	72 ce                	jb     80100f43 <filealloc+0x1b>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100f75:	c7 04 24 40 18 11 80 	movl   $0x80111840,(%esp)
80100f7c:	e8 40 40 00 00       	call   80104fc1 <release>
  return 0;
80100f81:	b8 00 00 00 00       	mov    $0x0,%eax
}
80100f86:	c9                   	leave  
80100f87:	c3                   	ret    

80100f88 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100f88:	55                   	push   %ebp
80100f89:	89 e5                	mov    %esp,%ebp
80100f8b:	83 ec 18             	sub    $0x18,%esp
  acquire(&ftable.lock);
80100f8e:	c7 04 24 40 18 11 80 	movl   $0x80111840,(%esp)
80100f95:	e8 c5 3f 00 00       	call   80104f5f <acquire>
  if(f->ref < 1)
80100f9a:	8b 45 08             	mov    0x8(%ebp),%eax
80100f9d:	8b 40 04             	mov    0x4(%eax),%eax
80100fa0:	85 c0                	test   %eax,%eax
80100fa2:	7f 0c                	jg     80100fb0 <filedup+0x28>
    panic("filedup");
80100fa4:	c7 04 24 fd 88 10 80 	movl   $0x801088fd,(%esp)
80100fab:	e8 86 f5 ff ff       	call   80100536 <panic>
  f->ref++;
80100fb0:	8b 45 08             	mov    0x8(%ebp),%eax
80100fb3:	8b 40 04             	mov    0x4(%eax),%eax
80100fb6:	8d 50 01             	lea    0x1(%eax),%edx
80100fb9:	8b 45 08             	mov    0x8(%ebp),%eax
80100fbc:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80100fbf:	c7 04 24 40 18 11 80 	movl   $0x80111840,(%esp)
80100fc6:	e8 f6 3f 00 00       	call   80104fc1 <release>
  return f;
80100fcb:	8b 45 08             	mov    0x8(%ebp),%eax
}
80100fce:	c9                   	leave  
80100fcf:	c3                   	ret    

80100fd0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100fd0:	55                   	push   %ebp
80100fd1:	89 e5                	mov    %esp,%ebp
80100fd3:	57                   	push   %edi
80100fd4:	56                   	push   %esi
80100fd5:	53                   	push   %ebx
80100fd6:	83 ec 3c             	sub    $0x3c,%esp
  struct file ff;

  acquire(&ftable.lock);
80100fd9:	c7 04 24 40 18 11 80 	movl   $0x80111840,(%esp)
80100fe0:	e8 7a 3f 00 00       	call   80104f5f <acquire>
  if(f->ref < 1)
80100fe5:	8b 45 08             	mov    0x8(%ebp),%eax
80100fe8:	8b 40 04             	mov    0x4(%eax),%eax
80100feb:	85 c0                	test   %eax,%eax
80100fed:	7f 0c                	jg     80100ffb <fileclose+0x2b>
    panic("fileclose");
80100fef:	c7 04 24 05 89 10 80 	movl   $0x80108905,(%esp)
80100ff6:	e8 3b f5 ff ff       	call   80100536 <panic>
  if(--f->ref > 0){
80100ffb:	8b 45 08             	mov    0x8(%ebp),%eax
80100ffe:	8b 40 04             	mov    0x4(%eax),%eax
80101001:	8d 50 ff             	lea    -0x1(%eax),%edx
80101004:	8b 45 08             	mov    0x8(%ebp),%eax
80101007:	89 50 04             	mov    %edx,0x4(%eax)
8010100a:	8b 45 08             	mov    0x8(%ebp),%eax
8010100d:	8b 40 04             	mov    0x4(%eax),%eax
80101010:	85 c0                	test   %eax,%eax
80101012:	7e 0e                	jle    80101022 <fileclose+0x52>
    release(&ftable.lock);
80101014:	c7 04 24 40 18 11 80 	movl   $0x80111840,(%esp)
8010101b:	e8 a1 3f 00 00       	call   80104fc1 <release>
80101020:	eb 70                	jmp    80101092 <fileclose+0xc2>
    return;
  }
  ff = *f;
80101022:	8b 45 08             	mov    0x8(%ebp),%eax
80101025:	8d 55 d0             	lea    -0x30(%ebp),%edx
80101028:	89 c3                	mov    %eax,%ebx
8010102a:	b8 06 00 00 00       	mov    $0x6,%eax
8010102f:	89 d7                	mov    %edx,%edi
80101031:	89 de                	mov    %ebx,%esi
80101033:	89 c1                	mov    %eax,%ecx
80101035:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  f->ref = 0;
80101037:	8b 45 08             	mov    0x8(%ebp),%eax
8010103a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
80101041:	8b 45 08             	mov    0x8(%ebp),%eax
80101044:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
8010104a:	c7 04 24 40 18 11 80 	movl   $0x80111840,(%esp)
80101051:	e8 6b 3f 00 00       	call   80104fc1 <release>
  
  if(ff.type == FD_PIPE)
80101056:	8b 45 d0             	mov    -0x30(%ebp),%eax
80101059:	83 f8 01             	cmp    $0x1,%eax
8010105c:	75 17                	jne    80101075 <fileclose+0xa5>
    pipeclose(ff.pipe, ff.writable);
8010105e:	8a 45 d9             	mov    -0x27(%ebp),%al
80101061:	0f be d0             	movsbl %al,%edx
80101064:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101067:	89 54 24 04          	mov    %edx,0x4(%esp)
8010106b:	89 04 24             	mov    %eax,(%esp)
8010106e:	e8 d8 30 00 00       	call   8010414b <pipeclose>
80101073:	eb 1d                	jmp    80101092 <fileclose+0xc2>
  else if(ff.type == FD_INODE){
80101075:	8b 45 d0             	mov    -0x30(%ebp),%eax
80101078:	83 f8 02             	cmp    $0x2,%eax
8010107b:	75 15                	jne    80101092 <fileclose+0xc2>
    begin_op();
8010107d:	e8 25 24 00 00       	call   801034a7 <begin_op>
    iput(ff.ip);
80101082:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101085:	89 04 24             	mov    %eax,(%esp)
80101088:	e8 e0 09 00 00       	call   80101a6d <iput>
    end_op();
8010108d:	e8 94 24 00 00       	call   80103526 <end_op>
  }
}
80101092:	83 c4 3c             	add    $0x3c,%esp
80101095:	5b                   	pop    %ebx
80101096:	5e                   	pop    %esi
80101097:	5f                   	pop    %edi
80101098:	5d                   	pop    %ebp
80101099:	c3                   	ret    

8010109a <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
8010109a:	55                   	push   %ebp
8010109b:	89 e5                	mov    %esp,%ebp
8010109d:	83 ec 18             	sub    $0x18,%esp
  if(f->type == FD_INODE){
801010a0:	8b 45 08             	mov    0x8(%ebp),%eax
801010a3:	8b 00                	mov    (%eax),%eax
801010a5:	83 f8 02             	cmp    $0x2,%eax
801010a8:	75 38                	jne    801010e2 <filestat+0x48>
    ilock(f->ip);
801010aa:	8b 45 08             	mov    0x8(%ebp),%eax
801010ad:	8b 40 10             	mov    0x10(%eax),%eax
801010b0:	89 04 24             	mov    %eax,(%esp)
801010b3:	e8 ff 07 00 00       	call   801018b7 <ilock>
    stati(f->ip, st);
801010b8:	8b 45 08             	mov    0x8(%ebp),%eax
801010bb:	8b 40 10             	mov    0x10(%eax),%eax
801010be:	8b 55 0c             	mov    0xc(%ebp),%edx
801010c1:	89 54 24 04          	mov    %edx,0x4(%esp)
801010c5:	89 04 24             	mov    %eax,(%esp)
801010c8:	e8 b3 0c 00 00       	call   80101d80 <stati>
    iunlock(f->ip);
801010cd:	8b 45 08             	mov    0x8(%ebp),%eax
801010d0:	8b 40 10             	mov    0x10(%eax),%eax
801010d3:	89 04 24             	mov    %eax,(%esp)
801010d6:	e8 2d 09 00 00       	call   80101a08 <iunlock>
    return 0;
801010db:	b8 00 00 00 00       	mov    $0x0,%eax
801010e0:	eb 05                	jmp    801010e7 <filestat+0x4d>
  }
  return -1;
801010e2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801010e7:	c9                   	leave  
801010e8:	c3                   	ret    

801010e9 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801010e9:	55                   	push   %ebp
801010ea:	89 e5                	mov    %esp,%ebp
801010ec:	83 ec 28             	sub    $0x28,%esp
  int r;

  if(f->readable == 0)
801010ef:	8b 45 08             	mov    0x8(%ebp),%eax
801010f2:	8a 40 08             	mov    0x8(%eax),%al
801010f5:	84 c0                	test   %al,%al
801010f7:	75 0a                	jne    80101103 <fileread+0x1a>
    return -1;
801010f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801010fe:	e9 9f 00 00 00       	jmp    801011a2 <fileread+0xb9>
  if(f->type == FD_PIPE)
80101103:	8b 45 08             	mov    0x8(%ebp),%eax
80101106:	8b 00                	mov    (%eax),%eax
80101108:	83 f8 01             	cmp    $0x1,%eax
8010110b:	75 1e                	jne    8010112b <fileread+0x42>
    return piperead(f->pipe, addr, n);
8010110d:	8b 45 08             	mov    0x8(%ebp),%eax
80101110:	8b 40 0c             	mov    0xc(%eax),%eax
80101113:	8b 55 10             	mov    0x10(%ebp),%edx
80101116:	89 54 24 08          	mov    %edx,0x8(%esp)
8010111a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010111d:	89 54 24 04          	mov    %edx,0x4(%esp)
80101121:	89 04 24             	mov    %eax,(%esp)
80101124:	e8 a4 31 00 00       	call   801042cd <piperead>
80101129:	eb 77                	jmp    801011a2 <fileread+0xb9>
  if(f->type == FD_INODE){
8010112b:	8b 45 08             	mov    0x8(%ebp),%eax
8010112e:	8b 00                	mov    (%eax),%eax
80101130:	83 f8 02             	cmp    $0x2,%eax
80101133:	75 61                	jne    80101196 <fileread+0xad>
    ilock(f->ip);
80101135:	8b 45 08             	mov    0x8(%ebp),%eax
80101138:	8b 40 10             	mov    0x10(%eax),%eax
8010113b:	89 04 24             	mov    %eax,(%esp)
8010113e:	e8 74 07 00 00       	call   801018b7 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101143:	8b 4d 10             	mov    0x10(%ebp),%ecx
80101146:	8b 45 08             	mov    0x8(%ebp),%eax
80101149:	8b 50 14             	mov    0x14(%eax),%edx
8010114c:	8b 45 08             	mov    0x8(%ebp),%eax
8010114f:	8b 40 10             	mov    0x10(%eax),%eax
80101152:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101156:	89 54 24 08          	mov    %edx,0x8(%esp)
8010115a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010115d:	89 54 24 04          	mov    %edx,0x4(%esp)
80101161:	89 04 24             	mov    %eax,(%esp)
80101164:	e8 5b 0c 00 00       	call   80101dc4 <readi>
80101169:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010116c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101170:	7e 11                	jle    80101183 <fileread+0x9a>
      f->off += r;
80101172:	8b 45 08             	mov    0x8(%ebp),%eax
80101175:	8b 50 14             	mov    0x14(%eax),%edx
80101178:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010117b:	01 c2                	add    %eax,%edx
8010117d:	8b 45 08             	mov    0x8(%ebp),%eax
80101180:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
80101183:	8b 45 08             	mov    0x8(%ebp),%eax
80101186:	8b 40 10             	mov    0x10(%eax),%eax
80101189:	89 04 24             	mov    %eax,(%esp)
8010118c:	e8 77 08 00 00       	call   80101a08 <iunlock>
    return r;
80101191:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101194:	eb 0c                	jmp    801011a2 <fileread+0xb9>
  }
  panic("fileread");
80101196:	c7 04 24 0f 89 10 80 	movl   $0x8010890f,(%esp)
8010119d:	e8 94 f3 ff ff       	call   80100536 <panic>
}
801011a2:	c9                   	leave  
801011a3:	c3                   	ret    

801011a4 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801011a4:	55                   	push   %ebp
801011a5:	89 e5                	mov    %esp,%ebp
801011a7:	53                   	push   %ebx
801011a8:	83 ec 24             	sub    $0x24,%esp
  int r;

  if(f->writable == 0)
801011ab:	8b 45 08             	mov    0x8(%ebp),%eax
801011ae:	8a 40 09             	mov    0x9(%eax),%al
801011b1:	84 c0                	test   %al,%al
801011b3:	75 0a                	jne    801011bf <filewrite+0x1b>
    return -1;
801011b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011ba:	e9 23 01 00 00       	jmp    801012e2 <filewrite+0x13e>
  if(f->type == FD_PIPE)
801011bf:	8b 45 08             	mov    0x8(%ebp),%eax
801011c2:	8b 00                	mov    (%eax),%eax
801011c4:	83 f8 01             	cmp    $0x1,%eax
801011c7:	75 21                	jne    801011ea <filewrite+0x46>
    return pipewrite(f->pipe, addr, n);
801011c9:	8b 45 08             	mov    0x8(%ebp),%eax
801011cc:	8b 40 0c             	mov    0xc(%eax),%eax
801011cf:	8b 55 10             	mov    0x10(%ebp),%edx
801011d2:	89 54 24 08          	mov    %edx,0x8(%esp)
801011d6:	8b 55 0c             	mov    0xc(%ebp),%edx
801011d9:	89 54 24 04          	mov    %edx,0x4(%esp)
801011dd:	89 04 24             	mov    %eax,(%esp)
801011e0:	e8 f8 2f 00 00       	call   801041dd <pipewrite>
801011e5:	e9 f8 00 00 00       	jmp    801012e2 <filewrite+0x13e>
  if(f->type == FD_INODE){
801011ea:	8b 45 08             	mov    0x8(%ebp),%eax
801011ed:	8b 00                	mov    (%eax),%eax
801011ef:	83 f8 02             	cmp    $0x2,%eax
801011f2:	0f 85 de 00 00 00    	jne    801012d6 <filewrite+0x132>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
801011f8:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
801011ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
80101206:	e9 a8 00 00 00       	jmp    801012b3 <filewrite+0x10f>
      int n1 = n - i;
8010120b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010120e:	8b 55 10             	mov    0x10(%ebp),%edx
80101211:	89 d1                	mov    %edx,%ecx
80101213:	29 c1                	sub    %eax,%ecx
80101215:	89 c8                	mov    %ecx,%eax
80101217:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
8010121a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010121d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80101220:	7e 06                	jle    80101228 <filewrite+0x84>
        n1 = max;
80101222:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101225:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
80101228:	e8 7a 22 00 00       	call   801034a7 <begin_op>
      ilock(f->ip);
8010122d:	8b 45 08             	mov    0x8(%ebp),%eax
80101230:	8b 40 10             	mov    0x10(%eax),%eax
80101233:	89 04 24             	mov    %eax,(%esp)
80101236:	e8 7c 06 00 00       	call   801018b7 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010123b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010123e:	8b 45 08             	mov    0x8(%ebp),%eax
80101241:	8b 50 14             	mov    0x14(%eax),%edx
80101244:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101247:	8b 45 0c             	mov    0xc(%ebp),%eax
8010124a:	01 c3                	add    %eax,%ebx
8010124c:	8b 45 08             	mov    0x8(%ebp),%eax
8010124f:	8b 40 10             	mov    0x10(%eax),%eax
80101252:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101256:	89 54 24 08          	mov    %edx,0x8(%esp)
8010125a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
8010125e:	89 04 24             	mov    %eax,(%esp)
80101261:	e8 c3 0c 00 00       	call   80101f29 <writei>
80101266:	89 45 e8             	mov    %eax,-0x18(%ebp)
80101269:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010126d:	7e 11                	jle    80101280 <filewrite+0xdc>
        f->off += r;
8010126f:	8b 45 08             	mov    0x8(%ebp),%eax
80101272:	8b 50 14             	mov    0x14(%eax),%edx
80101275:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101278:	01 c2                	add    %eax,%edx
8010127a:	8b 45 08             	mov    0x8(%ebp),%eax
8010127d:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
80101280:	8b 45 08             	mov    0x8(%ebp),%eax
80101283:	8b 40 10             	mov    0x10(%eax),%eax
80101286:	89 04 24             	mov    %eax,(%esp)
80101289:	e8 7a 07 00 00       	call   80101a08 <iunlock>
      end_op();
8010128e:	e8 93 22 00 00       	call   80103526 <end_op>

      if(r < 0)
80101293:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101297:	78 28                	js     801012c1 <filewrite+0x11d>
        break;
      if(r != n1)
80101299:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010129c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010129f:	74 0c                	je     801012ad <filewrite+0x109>
        panic("short filewrite");
801012a1:	c7 04 24 18 89 10 80 	movl   $0x80108918,(%esp)
801012a8:	e8 89 f2 ff ff       	call   80100536 <panic>
      i += r;
801012ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012b0:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801012b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012b6:	3b 45 10             	cmp    0x10(%ebp),%eax
801012b9:	0f 8c 4c ff ff ff    	jl     8010120b <filewrite+0x67>
801012bf:	eb 01                	jmp    801012c2 <filewrite+0x11e>
        f->off += r;
      iunlock(f->ip);
      end_op();

      if(r < 0)
        break;
801012c1:	90                   	nop
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801012c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012c5:	3b 45 10             	cmp    0x10(%ebp),%eax
801012c8:	75 05                	jne    801012cf <filewrite+0x12b>
801012ca:	8b 45 10             	mov    0x10(%ebp),%eax
801012cd:	eb 05                	jmp    801012d4 <filewrite+0x130>
801012cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801012d4:	eb 0c                	jmp    801012e2 <filewrite+0x13e>
  }
  panic("filewrite");
801012d6:	c7 04 24 28 89 10 80 	movl   $0x80108928,(%esp)
801012dd:	e8 54 f2 ff ff       	call   80100536 <panic>
}
801012e2:	83 c4 24             	add    $0x24,%esp
801012e5:	5b                   	pop    %ebx
801012e6:	5d                   	pop    %ebp
801012e7:	c3                   	ret    

801012e8 <readsb>:
struct superblock sb;   // there should be one per dev, but we run with one dev

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801012e8:	55                   	push   %ebp
801012e9:	89 e5                	mov    %esp,%ebp
801012eb:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
801012ee:	8b 45 08             	mov    0x8(%ebp),%eax
801012f1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801012f8:	00 
801012f9:	89 04 24             	mov    %eax,(%esp)
801012fc:	e8 a5 ee ff ff       	call   801001a6 <bread>
80101301:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
80101304:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101307:	83 c0 18             	add    $0x18,%eax
8010130a:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
80101311:	00 
80101312:	89 44 24 04          	mov    %eax,0x4(%esp)
80101316:	8b 45 0c             	mov    0xc(%ebp),%eax
80101319:	89 04 24             	mov    %eax,(%esp)
8010131c:	e8 5d 3f 00 00       	call   8010527e <memmove>
  brelse(bp);
80101321:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101324:	89 04 24             	mov    %eax,(%esp)
80101327:	e8 eb ee ff ff       	call   80100217 <brelse>
}
8010132c:	c9                   	leave  
8010132d:	c3                   	ret    

8010132e <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
8010132e:	55                   	push   %ebp
8010132f:	89 e5                	mov    %esp,%ebp
80101331:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
80101334:	8b 55 0c             	mov    0xc(%ebp),%edx
80101337:	8b 45 08             	mov    0x8(%ebp),%eax
8010133a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010133e:	89 04 24             	mov    %eax,(%esp)
80101341:	e8 60 ee ff ff       	call   801001a6 <bread>
80101346:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
80101349:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010134c:	83 c0 18             	add    $0x18,%eax
8010134f:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80101356:	00 
80101357:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010135e:	00 
8010135f:	89 04 24             	mov    %eax,(%esp)
80101362:	e8 4b 3e 00 00       	call   801051b2 <memset>
  log_write(bp);
80101367:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010136a:	89 04 24             	mov    %eax,(%esp)
8010136d:	e8 36 23 00 00       	call   801036a8 <log_write>
  brelse(bp);
80101372:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101375:	89 04 24             	mov    %eax,(%esp)
80101378:	e8 9a ee ff ff       	call   80100217 <brelse>
}
8010137d:	c9                   	leave  
8010137e:	c3                   	ret    

8010137f <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
8010137f:	55                   	push   %ebp
80101380:	89 e5                	mov    %esp,%ebp
80101382:	53                   	push   %ebx
80101383:	83 ec 24             	sub    $0x24,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
80101386:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
8010138d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101394:	e9 05 01 00 00       	jmp    8010149e <balloc+0x11f>
    bp = bread(dev, BBLOCK(b, sb));
80101399:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010139c:	85 c0                	test   %eax,%eax
8010139e:	79 05                	jns    801013a5 <balloc+0x26>
801013a0:	05 ff 0f 00 00       	add    $0xfff,%eax
801013a5:	c1 f8 0c             	sar    $0xc,%eax
801013a8:	89 c2                	mov    %eax,%edx
801013aa:	a1 58 22 11 80       	mov    0x80112258,%eax
801013af:	01 d0                	add    %edx,%eax
801013b1:	89 44 24 04          	mov    %eax,0x4(%esp)
801013b5:	8b 45 08             	mov    0x8(%ebp),%eax
801013b8:	89 04 24             	mov    %eax,(%esp)
801013bb:	e8 e6 ed ff ff       	call   801001a6 <bread>
801013c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801013c3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801013ca:	e9 9d 00 00 00       	jmp    8010146c <balloc+0xed>
      m = 1 << (bi % 8);
801013cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801013d2:	25 07 00 00 80       	and    $0x80000007,%eax
801013d7:	85 c0                	test   %eax,%eax
801013d9:	79 05                	jns    801013e0 <balloc+0x61>
801013db:	48                   	dec    %eax
801013dc:	83 c8 f8             	or     $0xfffffff8,%eax
801013df:	40                   	inc    %eax
801013e0:	ba 01 00 00 00       	mov    $0x1,%edx
801013e5:	89 d3                	mov    %edx,%ebx
801013e7:	88 c1                	mov    %al,%cl
801013e9:	d3 e3                	shl    %cl,%ebx
801013eb:	89 d8                	mov    %ebx,%eax
801013ed:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801013f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801013f3:	85 c0                	test   %eax,%eax
801013f5:	79 03                	jns    801013fa <balloc+0x7b>
801013f7:	83 c0 07             	add    $0x7,%eax
801013fa:	c1 f8 03             	sar    $0x3,%eax
801013fd:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101400:	8a 44 02 18          	mov    0x18(%edx,%eax,1),%al
80101404:	0f b6 c0             	movzbl %al,%eax
80101407:	23 45 e8             	and    -0x18(%ebp),%eax
8010140a:	85 c0                	test   %eax,%eax
8010140c:	75 5b                	jne    80101469 <balloc+0xea>
        bp->data[bi/8] |= m;  // Mark block in use.
8010140e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101411:	85 c0                	test   %eax,%eax
80101413:	79 03                	jns    80101418 <balloc+0x99>
80101415:	83 c0 07             	add    $0x7,%eax
80101418:	c1 f8 03             	sar    $0x3,%eax
8010141b:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010141e:	8a 54 02 18          	mov    0x18(%edx,%eax,1),%dl
80101422:	88 d1                	mov    %dl,%cl
80101424:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101427:	09 ca                	or     %ecx,%edx
80101429:	88 d1                	mov    %dl,%cl
8010142b:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010142e:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
80101432:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101435:	89 04 24             	mov    %eax,(%esp)
80101438:	e8 6b 22 00 00       	call   801036a8 <log_write>
        brelse(bp);
8010143d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101440:	89 04 24             	mov    %eax,(%esp)
80101443:	e8 cf ed ff ff       	call   80100217 <brelse>
        bzero(dev, b + bi);
80101448:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010144b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010144e:	01 c2                	add    %eax,%edx
80101450:	8b 45 08             	mov    0x8(%ebp),%eax
80101453:	89 54 24 04          	mov    %edx,0x4(%esp)
80101457:	89 04 24             	mov    %eax,(%esp)
8010145a:	e8 cf fe ff ff       	call   8010132e <bzero>
        return b + bi;
8010145f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101462:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101465:	01 d0                	add    %edx,%eax
80101467:	eb 51                	jmp    801014ba <balloc+0x13b>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101469:	ff 45 f0             	incl   -0x10(%ebp)
8010146c:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
80101473:	7f 17                	jg     8010148c <balloc+0x10d>
80101475:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101478:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010147b:	01 d0                	add    %edx,%eax
8010147d:	89 c2                	mov    %eax,%edx
8010147f:	a1 40 22 11 80       	mov    0x80112240,%eax
80101484:	39 c2                	cmp    %eax,%edx
80101486:	0f 82 43 ff ff ff    	jb     801013cf <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
8010148c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010148f:	89 04 24             	mov    %eax,(%esp)
80101492:	e8 80 ed ff ff       	call   80100217 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101497:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010149e:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014a1:	a1 40 22 11 80       	mov    0x80112240,%eax
801014a6:	39 c2                	cmp    %eax,%edx
801014a8:	0f 82 eb fe ff ff    	jb     80101399 <balloc+0x1a>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801014ae:	c7 04 24 34 89 10 80 	movl   $0x80108934,(%esp)
801014b5:	e8 7c f0 ff ff       	call   80100536 <panic>
}
801014ba:	83 c4 24             	add    $0x24,%esp
801014bd:	5b                   	pop    %ebx
801014be:	5d                   	pop    %ebp
801014bf:	c3                   	ret    

801014c0 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
801014c0:	55                   	push   %ebp
801014c1:	89 e5                	mov    %esp,%ebp
801014c3:	53                   	push   %ebx
801014c4:	83 ec 24             	sub    $0x24,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
801014c7:	c7 44 24 04 40 22 11 	movl   $0x80112240,0x4(%esp)
801014ce:	80 
801014cf:	8b 45 08             	mov    0x8(%ebp),%eax
801014d2:	89 04 24             	mov    %eax,(%esp)
801014d5:	e8 0e fe ff ff       	call   801012e8 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801014da:	8b 45 0c             	mov    0xc(%ebp),%eax
801014dd:	89 c2                	mov    %eax,%edx
801014df:	c1 ea 0c             	shr    $0xc,%edx
801014e2:	a1 58 22 11 80       	mov    0x80112258,%eax
801014e7:	01 c2                	add    %eax,%edx
801014e9:	8b 45 08             	mov    0x8(%ebp),%eax
801014ec:	89 54 24 04          	mov    %edx,0x4(%esp)
801014f0:	89 04 24             	mov    %eax,(%esp)
801014f3:	e8 ae ec ff ff       	call   801001a6 <bread>
801014f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
801014fb:	8b 45 0c             	mov    0xc(%ebp),%eax
801014fe:	25 ff 0f 00 00       	and    $0xfff,%eax
80101503:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
80101506:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101509:	25 07 00 00 80       	and    $0x80000007,%eax
8010150e:	85 c0                	test   %eax,%eax
80101510:	79 05                	jns    80101517 <bfree+0x57>
80101512:	48                   	dec    %eax
80101513:	83 c8 f8             	or     $0xfffffff8,%eax
80101516:	40                   	inc    %eax
80101517:	ba 01 00 00 00       	mov    $0x1,%edx
8010151c:	89 d3                	mov    %edx,%ebx
8010151e:	88 c1                	mov    %al,%cl
80101520:	d3 e3                	shl    %cl,%ebx
80101522:	89 d8                	mov    %ebx,%eax
80101524:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
80101527:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010152a:	85 c0                	test   %eax,%eax
8010152c:	79 03                	jns    80101531 <bfree+0x71>
8010152e:	83 c0 07             	add    $0x7,%eax
80101531:	c1 f8 03             	sar    $0x3,%eax
80101534:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101537:	8a 44 02 18          	mov    0x18(%edx,%eax,1),%al
8010153b:	0f b6 c0             	movzbl %al,%eax
8010153e:	23 45 ec             	and    -0x14(%ebp),%eax
80101541:	85 c0                	test   %eax,%eax
80101543:	75 0c                	jne    80101551 <bfree+0x91>
    panic("freeing free block");
80101545:	c7 04 24 4a 89 10 80 	movl   $0x8010894a,(%esp)
8010154c:	e8 e5 ef ff ff       	call   80100536 <panic>
  bp->data[bi/8] &= ~m;
80101551:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101554:	85 c0                	test   %eax,%eax
80101556:	79 03                	jns    8010155b <bfree+0x9b>
80101558:	83 c0 07             	add    $0x7,%eax
8010155b:	c1 f8 03             	sar    $0x3,%eax
8010155e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101561:	8a 54 02 18          	mov    0x18(%edx,%eax,1),%dl
80101565:	8b 4d ec             	mov    -0x14(%ebp),%ecx
80101568:	f7 d1                	not    %ecx
8010156a:	21 ca                	and    %ecx,%edx
8010156c:	88 d1                	mov    %dl,%cl
8010156e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101571:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
80101575:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101578:	89 04 24             	mov    %eax,(%esp)
8010157b:	e8 28 21 00 00       	call   801036a8 <log_write>
  brelse(bp);
80101580:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101583:	89 04 24             	mov    %eax,(%esp)
80101586:	e8 8c ec ff ff       	call   80100217 <brelse>
}
8010158b:	83 c4 24             	add    $0x24,%esp
8010158e:	5b                   	pop    %ebx
8010158f:	5d                   	pop    %ebp
80101590:	c3                   	ret    

80101591 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101591:	55                   	push   %ebp
80101592:	89 e5                	mov    %esp,%ebp
80101594:	57                   	push   %edi
80101595:	56                   	push   %esi
80101596:	53                   	push   %ebx
80101597:	83 ec 3c             	sub    $0x3c,%esp
  initlock(&icache.lock, "icache");
8010159a:	c7 44 24 04 5d 89 10 	movl   $0x8010895d,0x4(%esp)
801015a1:	80 
801015a2:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
801015a9:	e8 90 39 00 00       	call   80104f3e <initlock>
  readsb(dev, &sb);
801015ae:	c7 44 24 04 40 22 11 	movl   $0x80112240,0x4(%esp)
801015b5:	80 
801015b6:	8b 45 08             	mov    0x8(%ebp),%eax
801015b9:	89 04 24             	mov    %eax,(%esp)
801015bc:	e8 27 fd ff ff       	call   801012e8 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d inodestart %d bmap start %d\n", sb.size,
801015c1:	a1 58 22 11 80       	mov    0x80112258,%eax
801015c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801015c9:	8b 3d 54 22 11 80    	mov    0x80112254,%edi
801015cf:	8b 35 50 22 11 80    	mov    0x80112250,%esi
801015d5:	8b 1d 4c 22 11 80    	mov    0x8011224c,%ebx
801015db:	8b 0d 48 22 11 80    	mov    0x80112248,%ecx
801015e1:	8b 15 44 22 11 80    	mov    0x80112244,%edx
801015e7:	a1 40 22 11 80       	mov    0x80112240,%eax
801015ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
801015ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801015f2:	89 44 24 1c          	mov    %eax,0x1c(%esp)
801015f6:	89 7c 24 18          	mov    %edi,0x18(%esp)
801015fa:	89 74 24 14          	mov    %esi,0x14(%esp)
801015fe:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80101602:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101606:	89 54 24 08          	mov    %edx,0x8(%esp)
8010160a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010160d:	89 44 24 04          	mov    %eax,0x4(%esp)
80101611:	c7 04 24 64 89 10 80 	movl   $0x80108964,(%esp)
80101618:	e8 84 ed ff ff       	call   801003a1 <cprintf>
          sb.nblocks, sb.ninodes, sb.nlog, sb.logstart, sb.inodestart, sb.bmapstart);
}
8010161d:	83 c4 3c             	add    $0x3c,%esp
80101620:	5b                   	pop    %ebx
80101621:	5e                   	pop    %esi
80101622:	5f                   	pop    %edi
80101623:	5d                   	pop    %ebp
80101624:	c3                   	ret    

80101625 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
80101625:	55                   	push   %ebp
80101626:	89 e5                	mov    %esp,%ebp
80101628:	83 ec 38             	sub    $0x38,%esp
8010162b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010162e:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101632:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
80101639:	e9 9b 00 00 00       	jmp    801016d9 <ialloc+0xb4>
    bp = bread(dev, IBLOCK(inum, sb));
8010163e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101641:	89 c2                	mov    %eax,%edx
80101643:	c1 ea 03             	shr    $0x3,%edx
80101646:	a1 54 22 11 80       	mov    0x80112254,%eax
8010164b:	01 d0                	add    %edx,%eax
8010164d:	89 44 24 04          	mov    %eax,0x4(%esp)
80101651:	8b 45 08             	mov    0x8(%ebp),%eax
80101654:	89 04 24             	mov    %eax,(%esp)
80101657:	e8 4a eb ff ff       	call   801001a6 <bread>
8010165c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
8010165f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101662:	8d 50 18             	lea    0x18(%eax),%edx
80101665:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101668:	83 e0 07             	and    $0x7,%eax
8010166b:	c1 e0 06             	shl    $0x6,%eax
8010166e:	01 d0                	add    %edx,%eax
80101670:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
80101673:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101676:	8b 00                	mov    (%eax),%eax
80101678:	66 85 c0             	test   %ax,%ax
8010167b:	75 4e                	jne    801016cb <ialloc+0xa6>
      memset(dip, 0, sizeof(*dip));
8010167d:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
80101684:	00 
80101685:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010168c:	00 
8010168d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101690:	89 04 24             	mov    %eax,(%esp)
80101693:	e8 1a 3b 00 00       	call   801051b2 <memset>
      dip->type = type;
80101698:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010169b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010169e:	66 89 02             	mov    %ax,(%edx)
      log_write(bp);   // mark it allocated on the disk
801016a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016a4:	89 04 24             	mov    %eax,(%esp)
801016a7:	e8 fc 1f 00 00       	call   801036a8 <log_write>
      brelse(bp);
801016ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016af:	89 04 24             	mov    %eax,(%esp)
801016b2:	e8 60 eb ff ff       	call   80100217 <brelse>
      return iget(dev, inum);
801016b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016ba:	89 44 24 04          	mov    %eax,0x4(%esp)
801016be:	8b 45 08             	mov    0x8(%ebp),%eax
801016c1:	89 04 24             	mov    %eax,(%esp)
801016c4:	e8 ea 00 00 00       	call   801017b3 <iget>
801016c9:	eb 2a                	jmp    801016f5 <ialloc+0xd0>
    }
    brelse(bp);
801016cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016ce:	89 04 24             	mov    %eax,(%esp)
801016d1:	e8 41 eb ff ff       	call   80100217 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801016d6:	ff 45 f4             	incl   -0xc(%ebp)
801016d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801016dc:	a1 48 22 11 80       	mov    0x80112248,%eax
801016e1:	39 c2                	cmp    %eax,%edx
801016e3:	0f 82 55 ff ff ff    	jb     8010163e <ialloc+0x19>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801016e9:	c7 04 24 b7 89 10 80 	movl   $0x801089b7,(%esp)
801016f0:	e8 41 ee ff ff       	call   80100536 <panic>
}
801016f5:	c9                   	leave  
801016f6:	c3                   	ret    

801016f7 <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
801016f7:	55                   	push   %ebp
801016f8:	89 e5                	mov    %esp,%ebp
801016fa:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016fd:	8b 45 08             	mov    0x8(%ebp),%eax
80101700:	8b 40 04             	mov    0x4(%eax),%eax
80101703:	89 c2                	mov    %eax,%edx
80101705:	c1 ea 03             	shr    $0x3,%edx
80101708:	a1 54 22 11 80       	mov    0x80112254,%eax
8010170d:	01 c2                	add    %eax,%edx
8010170f:	8b 45 08             	mov    0x8(%ebp),%eax
80101712:	8b 00                	mov    (%eax),%eax
80101714:	89 54 24 04          	mov    %edx,0x4(%esp)
80101718:	89 04 24             	mov    %eax,(%esp)
8010171b:	e8 86 ea ff ff       	call   801001a6 <bread>
80101720:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101723:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101726:	8d 50 18             	lea    0x18(%eax),%edx
80101729:	8b 45 08             	mov    0x8(%ebp),%eax
8010172c:	8b 40 04             	mov    0x4(%eax),%eax
8010172f:	83 e0 07             	and    $0x7,%eax
80101732:	c1 e0 06             	shl    $0x6,%eax
80101735:	01 d0                	add    %edx,%eax
80101737:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
8010173a:	8b 45 08             	mov    0x8(%ebp),%eax
8010173d:	8b 40 10             	mov    0x10(%eax),%eax
80101740:	8b 55 f0             	mov    -0x10(%ebp),%edx
80101743:	66 89 02             	mov    %ax,(%edx)
  dip->major = ip->major;
80101746:	8b 45 08             	mov    0x8(%ebp),%eax
80101749:	66 8b 40 12          	mov    0x12(%eax),%ax
8010174d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80101750:	66 89 42 02          	mov    %ax,0x2(%edx)
  dip->minor = ip->minor;
80101754:	8b 45 08             	mov    0x8(%ebp),%eax
80101757:	8b 40 14             	mov    0x14(%eax),%eax
8010175a:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010175d:	66 89 42 04          	mov    %ax,0x4(%edx)
  dip->nlink = ip->nlink;
80101761:	8b 45 08             	mov    0x8(%ebp),%eax
80101764:	66 8b 40 16          	mov    0x16(%eax),%ax
80101768:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010176b:	66 89 42 06          	mov    %ax,0x6(%edx)
  dip->size = ip->size;
8010176f:	8b 45 08             	mov    0x8(%ebp),%eax
80101772:	8b 50 18             	mov    0x18(%eax),%edx
80101775:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101778:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010177b:	8b 45 08             	mov    0x8(%ebp),%eax
8010177e:	8d 50 1c             	lea    0x1c(%eax),%edx
80101781:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101784:	83 c0 0c             	add    $0xc,%eax
80101787:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
8010178e:	00 
8010178f:	89 54 24 04          	mov    %edx,0x4(%esp)
80101793:	89 04 24             	mov    %eax,(%esp)
80101796:	e8 e3 3a 00 00       	call   8010527e <memmove>
  log_write(bp);
8010179b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010179e:	89 04 24             	mov    %eax,(%esp)
801017a1:	e8 02 1f 00 00       	call   801036a8 <log_write>
  brelse(bp);
801017a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017a9:	89 04 24             	mov    %eax,(%esp)
801017ac:	e8 66 ea ff ff       	call   80100217 <brelse>
}
801017b1:	c9                   	leave  
801017b2:	c3                   	ret    

801017b3 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801017b3:	55                   	push   %ebp
801017b4:	89 e5                	mov    %esp,%ebp
801017b6:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
801017b9:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
801017c0:	e8 9a 37 00 00       	call   80104f5f <acquire>

  // Is the inode already cached?
  empty = 0;
801017c5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801017cc:	c7 45 f4 94 22 11 80 	movl   $0x80112294,-0xc(%ebp)
801017d3:	eb 59                	jmp    8010182e <iget+0x7b>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801017d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017d8:	8b 40 08             	mov    0x8(%eax),%eax
801017db:	85 c0                	test   %eax,%eax
801017dd:	7e 35                	jle    80101814 <iget+0x61>
801017df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017e2:	8b 00                	mov    (%eax),%eax
801017e4:	3b 45 08             	cmp    0x8(%ebp),%eax
801017e7:	75 2b                	jne    80101814 <iget+0x61>
801017e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017ec:	8b 40 04             	mov    0x4(%eax),%eax
801017ef:	3b 45 0c             	cmp    0xc(%ebp),%eax
801017f2:	75 20                	jne    80101814 <iget+0x61>
      ip->ref++;
801017f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017f7:	8b 40 08             	mov    0x8(%eax),%eax
801017fa:	8d 50 01             	lea    0x1(%eax),%edx
801017fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101800:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
80101803:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
8010180a:	e8 b2 37 00 00       	call   80104fc1 <release>
      return ip;
8010180f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101812:	eb 6f                	jmp    80101883 <iget+0xd0>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101814:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101818:	75 10                	jne    8010182a <iget+0x77>
8010181a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010181d:	8b 40 08             	mov    0x8(%eax),%eax
80101820:	85 c0                	test   %eax,%eax
80101822:	75 06                	jne    8010182a <iget+0x77>
      empty = ip;
80101824:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101827:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010182a:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
8010182e:	81 7d f4 34 32 11 80 	cmpl   $0x80113234,-0xc(%ebp)
80101835:	72 9e                	jb     801017d5 <iget+0x22>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101837:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010183b:	75 0c                	jne    80101849 <iget+0x96>
    panic("iget: no inodes");
8010183d:	c7 04 24 c9 89 10 80 	movl   $0x801089c9,(%esp)
80101844:	e8 ed ec ff ff       	call   80100536 <panic>

  ip = empty;
80101849:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010184c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
8010184f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101852:	8b 55 08             	mov    0x8(%ebp),%edx
80101855:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
80101857:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010185a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010185d:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
80101860:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101863:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
8010186a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010186d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
80101874:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
8010187b:	e8 41 37 00 00       	call   80104fc1 <release>

  return ip;
80101880:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80101883:	c9                   	leave  
80101884:	c3                   	ret    

80101885 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101885:	55                   	push   %ebp
80101886:	89 e5                	mov    %esp,%ebp
80101888:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
8010188b:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80101892:	e8 c8 36 00 00       	call   80104f5f <acquire>
  ip->ref++;
80101897:	8b 45 08             	mov    0x8(%ebp),%eax
8010189a:	8b 40 08             	mov    0x8(%eax),%eax
8010189d:	8d 50 01             	lea    0x1(%eax),%edx
801018a0:	8b 45 08             	mov    0x8(%ebp),%eax
801018a3:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
801018a6:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
801018ad:	e8 0f 37 00 00       	call   80104fc1 <release>
  return ip;
801018b2:	8b 45 08             	mov    0x8(%ebp),%eax
}
801018b5:	c9                   	leave  
801018b6:	c3                   	ret    

801018b7 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
801018b7:	55                   	push   %ebp
801018b8:	89 e5                	mov    %esp,%ebp
801018ba:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
801018bd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801018c1:	74 0a                	je     801018cd <ilock+0x16>
801018c3:	8b 45 08             	mov    0x8(%ebp),%eax
801018c6:	8b 40 08             	mov    0x8(%eax),%eax
801018c9:	85 c0                	test   %eax,%eax
801018cb:	7f 0c                	jg     801018d9 <ilock+0x22>
    panic("ilock");
801018cd:	c7 04 24 d9 89 10 80 	movl   $0x801089d9,(%esp)
801018d4:	e8 5d ec ff ff       	call   80100536 <panic>

  acquire(&icache.lock);
801018d9:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
801018e0:	e8 7a 36 00 00       	call   80104f5f <acquire>
  while(ip->flags & I_BUSY)
801018e5:	eb 13                	jmp    801018fa <ilock+0x43>
    sleep(ip, &icache.lock);
801018e7:	c7 44 24 04 60 22 11 	movl   $0x80112260,0x4(%esp)
801018ee:	80 
801018ef:	8b 45 08             	mov    0x8(%ebp),%eax
801018f2:	89 04 24             	mov    %eax,(%esp)
801018f5:	e8 80 33 00 00       	call   80104c7a <sleep>

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
801018fa:	8b 45 08             	mov    0x8(%ebp),%eax
801018fd:	8b 40 0c             	mov    0xc(%eax),%eax
80101900:	83 e0 01             	and    $0x1,%eax
80101903:	85 c0                	test   %eax,%eax
80101905:	75 e0                	jne    801018e7 <ilock+0x30>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
80101907:	8b 45 08             	mov    0x8(%ebp),%eax
8010190a:	8b 40 0c             	mov    0xc(%eax),%eax
8010190d:	89 c2                	mov    %eax,%edx
8010190f:	83 ca 01             	or     $0x1,%edx
80101912:	8b 45 08             	mov    0x8(%ebp),%eax
80101915:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
80101918:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
8010191f:	e8 9d 36 00 00       	call   80104fc1 <release>

  if(!(ip->flags & I_VALID)){
80101924:	8b 45 08             	mov    0x8(%ebp),%eax
80101927:	8b 40 0c             	mov    0xc(%eax),%eax
8010192a:	83 e0 02             	and    $0x2,%eax
8010192d:	85 c0                	test   %eax,%eax
8010192f:	0f 85 d1 00 00 00    	jne    80101a06 <ilock+0x14f>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101935:	8b 45 08             	mov    0x8(%ebp),%eax
80101938:	8b 40 04             	mov    0x4(%eax),%eax
8010193b:	89 c2                	mov    %eax,%edx
8010193d:	c1 ea 03             	shr    $0x3,%edx
80101940:	a1 54 22 11 80       	mov    0x80112254,%eax
80101945:	01 c2                	add    %eax,%edx
80101947:	8b 45 08             	mov    0x8(%ebp),%eax
8010194a:	8b 00                	mov    (%eax),%eax
8010194c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101950:	89 04 24             	mov    %eax,(%esp)
80101953:	e8 4e e8 ff ff       	call   801001a6 <bread>
80101958:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010195b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010195e:	8d 50 18             	lea    0x18(%eax),%edx
80101961:	8b 45 08             	mov    0x8(%ebp),%eax
80101964:	8b 40 04             	mov    0x4(%eax),%eax
80101967:	83 e0 07             	and    $0x7,%eax
8010196a:	c1 e0 06             	shl    $0x6,%eax
8010196d:	01 d0                	add    %edx,%eax
8010196f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101972:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101975:	8b 00                	mov    (%eax),%eax
80101977:	8b 55 08             	mov    0x8(%ebp),%edx
8010197a:	66 89 42 10          	mov    %ax,0x10(%edx)
    ip->major = dip->major;
8010197e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101981:	66 8b 40 02          	mov    0x2(%eax),%ax
80101985:	8b 55 08             	mov    0x8(%ebp),%edx
80101988:	66 89 42 12          	mov    %ax,0x12(%edx)
    ip->minor = dip->minor;
8010198c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010198f:	8b 40 04             	mov    0x4(%eax),%eax
80101992:	8b 55 08             	mov    0x8(%ebp),%edx
80101995:	66 89 42 14          	mov    %ax,0x14(%edx)
    ip->nlink = dip->nlink;
80101999:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010199c:	66 8b 40 06          	mov    0x6(%eax),%ax
801019a0:	8b 55 08             	mov    0x8(%ebp),%edx
801019a3:	66 89 42 16          	mov    %ax,0x16(%edx)
    ip->size = dip->size;
801019a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019aa:	8b 50 08             	mov    0x8(%eax),%edx
801019ad:	8b 45 08             	mov    0x8(%ebp),%eax
801019b0:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801019b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019b6:	8d 50 0c             	lea    0xc(%eax),%edx
801019b9:	8b 45 08             	mov    0x8(%ebp),%eax
801019bc:	83 c0 1c             	add    $0x1c,%eax
801019bf:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
801019c6:	00 
801019c7:	89 54 24 04          	mov    %edx,0x4(%esp)
801019cb:	89 04 24             	mov    %eax,(%esp)
801019ce:	e8 ab 38 00 00       	call   8010527e <memmove>
    brelse(bp);
801019d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019d6:	89 04 24             	mov    %eax,(%esp)
801019d9:	e8 39 e8 ff ff       	call   80100217 <brelse>
    ip->flags |= I_VALID;
801019de:	8b 45 08             	mov    0x8(%ebp),%eax
801019e1:	8b 40 0c             	mov    0xc(%eax),%eax
801019e4:	89 c2                	mov    %eax,%edx
801019e6:	83 ca 02             	or     $0x2,%edx
801019e9:	8b 45 08             	mov    0x8(%ebp),%eax
801019ec:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
801019ef:	8b 45 08             	mov    0x8(%ebp),%eax
801019f2:	8b 40 10             	mov    0x10(%eax),%eax
801019f5:	66 85 c0             	test   %ax,%ax
801019f8:	75 0c                	jne    80101a06 <ilock+0x14f>
      panic("ilock: no type");
801019fa:	c7 04 24 df 89 10 80 	movl   $0x801089df,(%esp)
80101a01:	e8 30 eb ff ff       	call   80100536 <panic>
  }
}
80101a06:	c9                   	leave  
80101a07:	c3                   	ret    

80101a08 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101a08:	55                   	push   %ebp
80101a09:	89 e5                	mov    %esp,%ebp
80101a0b:	83 ec 18             	sub    $0x18,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
80101a0e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101a12:	74 17                	je     80101a2b <iunlock+0x23>
80101a14:	8b 45 08             	mov    0x8(%ebp),%eax
80101a17:	8b 40 0c             	mov    0xc(%eax),%eax
80101a1a:	83 e0 01             	and    $0x1,%eax
80101a1d:	85 c0                	test   %eax,%eax
80101a1f:	74 0a                	je     80101a2b <iunlock+0x23>
80101a21:	8b 45 08             	mov    0x8(%ebp),%eax
80101a24:	8b 40 08             	mov    0x8(%eax),%eax
80101a27:	85 c0                	test   %eax,%eax
80101a29:	7f 0c                	jg     80101a37 <iunlock+0x2f>
    panic("iunlock");
80101a2b:	c7 04 24 ee 89 10 80 	movl   $0x801089ee,(%esp)
80101a32:	e8 ff ea ff ff       	call   80100536 <panic>

  acquire(&icache.lock);
80101a37:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80101a3e:	e8 1c 35 00 00       	call   80104f5f <acquire>
  ip->flags &= ~I_BUSY;
80101a43:	8b 45 08             	mov    0x8(%ebp),%eax
80101a46:	8b 40 0c             	mov    0xc(%eax),%eax
80101a49:	89 c2                	mov    %eax,%edx
80101a4b:	83 e2 fe             	and    $0xfffffffe,%edx
80101a4e:	8b 45 08             	mov    0x8(%ebp),%eax
80101a51:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101a54:	8b 45 08             	mov    0x8(%ebp),%eax
80101a57:	89 04 24             	mov    %eax,(%esp)
80101a5a:	e8 f7 32 00 00       	call   80104d56 <wakeup>
  release(&icache.lock);
80101a5f:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80101a66:	e8 56 35 00 00       	call   80104fc1 <release>
}
80101a6b:	c9                   	leave  
80101a6c:	c3                   	ret    

80101a6d <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101a6d:	55                   	push   %ebp
80101a6e:	89 e5                	mov    %esp,%ebp
80101a70:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80101a73:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80101a7a:	e8 e0 34 00 00       	call   80104f5f <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101a7f:	8b 45 08             	mov    0x8(%ebp),%eax
80101a82:	8b 40 08             	mov    0x8(%eax),%eax
80101a85:	83 f8 01             	cmp    $0x1,%eax
80101a88:	0f 85 93 00 00 00    	jne    80101b21 <iput+0xb4>
80101a8e:	8b 45 08             	mov    0x8(%ebp),%eax
80101a91:	8b 40 0c             	mov    0xc(%eax),%eax
80101a94:	83 e0 02             	and    $0x2,%eax
80101a97:	85 c0                	test   %eax,%eax
80101a99:	0f 84 82 00 00 00    	je     80101b21 <iput+0xb4>
80101a9f:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa2:	66 8b 40 16          	mov    0x16(%eax),%ax
80101aa6:	66 85 c0             	test   %ax,%ax
80101aa9:	75 76                	jne    80101b21 <iput+0xb4>
    // inode has no links and no other references: truncate and free.
    if(ip->flags & I_BUSY)
80101aab:	8b 45 08             	mov    0x8(%ebp),%eax
80101aae:	8b 40 0c             	mov    0xc(%eax),%eax
80101ab1:	83 e0 01             	and    $0x1,%eax
80101ab4:	85 c0                	test   %eax,%eax
80101ab6:	74 0c                	je     80101ac4 <iput+0x57>
      panic("iput busy");
80101ab8:	c7 04 24 f6 89 10 80 	movl   $0x801089f6,(%esp)
80101abf:	e8 72 ea ff ff       	call   80100536 <panic>
    ip->flags |= I_BUSY;
80101ac4:	8b 45 08             	mov    0x8(%ebp),%eax
80101ac7:	8b 40 0c             	mov    0xc(%eax),%eax
80101aca:	89 c2                	mov    %eax,%edx
80101acc:	83 ca 01             	or     $0x1,%edx
80101acf:	8b 45 08             	mov    0x8(%ebp),%eax
80101ad2:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101ad5:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80101adc:	e8 e0 34 00 00       	call   80104fc1 <release>
    itrunc(ip);
80101ae1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ae4:	89 04 24             	mov    %eax,(%esp)
80101ae7:	e8 7d 01 00 00       	call   80101c69 <itrunc>
    ip->type = 0;
80101aec:	8b 45 08             	mov    0x8(%ebp),%eax
80101aef:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101af5:	8b 45 08             	mov    0x8(%ebp),%eax
80101af8:	89 04 24             	mov    %eax,(%esp)
80101afb:	e8 f7 fb ff ff       	call   801016f7 <iupdate>
    acquire(&icache.lock);
80101b00:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80101b07:	e8 53 34 00 00       	call   80104f5f <acquire>
    ip->flags = 0;
80101b0c:	8b 45 08             	mov    0x8(%ebp),%eax
80101b0f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101b16:	8b 45 08             	mov    0x8(%ebp),%eax
80101b19:	89 04 24             	mov    %eax,(%esp)
80101b1c:	e8 35 32 00 00       	call   80104d56 <wakeup>
  }
  ip->ref--;
80101b21:	8b 45 08             	mov    0x8(%ebp),%eax
80101b24:	8b 40 08             	mov    0x8(%eax),%eax
80101b27:	8d 50 ff             	lea    -0x1(%eax),%edx
80101b2a:	8b 45 08             	mov    0x8(%ebp),%eax
80101b2d:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101b30:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80101b37:	e8 85 34 00 00       	call   80104fc1 <release>
}
80101b3c:	c9                   	leave  
80101b3d:	c3                   	ret    

80101b3e <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101b3e:	55                   	push   %ebp
80101b3f:	89 e5                	mov    %esp,%ebp
80101b41:	83 ec 18             	sub    $0x18,%esp
  iunlock(ip);
80101b44:	8b 45 08             	mov    0x8(%ebp),%eax
80101b47:	89 04 24             	mov    %eax,(%esp)
80101b4a:	e8 b9 fe ff ff       	call   80101a08 <iunlock>
  iput(ip);
80101b4f:	8b 45 08             	mov    0x8(%ebp),%eax
80101b52:	89 04 24             	mov    %eax,(%esp)
80101b55:	e8 13 ff ff ff       	call   80101a6d <iput>
}
80101b5a:	c9                   	leave  
80101b5b:	c3                   	ret    

80101b5c <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101b5c:	55                   	push   %ebp
80101b5d:	89 e5                	mov    %esp,%ebp
80101b5f:	53                   	push   %ebx
80101b60:	83 ec 24             	sub    $0x24,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101b63:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101b67:	77 3e                	ja     80101ba7 <bmap+0x4b>
    if((addr = ip->addrs[bn]) == 0)
80101b69:	8b 45 08             	mov    0x8(%ebp),%eax
80101b6c:	8b 55 0c             	mov    0xc(%ebp),%edx
80101b6f:	83 c2 04             	add    $0x4,%edx
80101b72:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101b76:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b79:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101b7d:	75 20                	jne    80101b9f <bmap+0x43>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101b7f:	8b 45 08             	mov    0x8(%ebp),%eax
80101b82:	8b 00                	mov    (%eax),%eax
80101b84:	89 04 24             	mov    %eax,(%esp)
80101b87:	e8 f3 f7 ff ff       	call   8010137f <balloc>
80101b8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b8f:	8b 45 08             	mov    0x8(%ebp),%eax
80101b92:	8b 55 0c             	mov    0xc(%ebp),%edx
80101b95:	8d 4a 04             	lea    0x4(%edx),%ecx
80101b98:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101b9b:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ba2:	e9 bc 00 00 00       	jmp    80101c63 <bmap+0x107>
  }
  bn -= NDIRECT;
80101ba7:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101bab:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101baf:	0f 87 a2 00 00 00    	ja     80101c57 <bmap+0xfb>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101bb5:	8b 45 08             	mov    0x8(%ebp),%eax
80101bb8:	8b 40 4c             	mov    0x4c(%eax),%eax
80101bbb:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101bbe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101bc2:	75 19                	jne    80101bdd <bmap+0x81>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101bc4:	8b 45 08             	mov    0x8(%ebp),%eax
80101bc7:	8b 00                	mov    (%eax),%eax
80101bc9:	89 04 24             	mov    %eax,(%esp)
80101bcc:	e8 ae f7 ff ff       	call   8010137f <balloc>
80101bd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101bd4:	8b 45 08             	mov    0x8(%ebp),%eax
80101bd7:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101bda:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101bdd:	8b 45 08             	mov    0x8(%ebp),%eax
80101be0:	8b 00                	mov    (%eax),%eax
80101be2:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101be5:	89 54 24 04          	mov    %edx,0x4(%esp)
80101be9:	89 04 24             	mov    %eax,(%esp)
80101bec:	e8 b5 e5 ff ff       	call   801001a6 <bread>
80101bf1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101bf4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bf7:	83 c0 18             	add    $0x18,%eax
80101bfa:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101bfd:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c00:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101c07:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101c0a:	01 d0                	add    %edx,%eax
80101c0c:	8b 00                	mov    (%eax),%eax
80101c0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c11:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c15:	75 30                	jne    80101c47 <bmap+0xeb>
      a[bn] = addr = balloc(ip->dev);
80101c17:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c1a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101c21:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101c24:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101c27:	8b 45 08             	mov    0x8(%ebp),%eax
80101c2a:	8b 00                	mov    (%eax),%eax
80101c2c:	89 04 24             	mov    %eax,(%esp)
80101c2f:	e8 4b f7 ff ff       	call   8010137f <balloc>
80101c34:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c3a:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101c3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c3f:	89 04 24             	mov    %eax,(%esp)
80101c42:	e8 61 1a 00 00       	call   801036a8 <log_write>
    }
    brelse(bp);
80101c47:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c4a:	89 04 24             	mov    %eax,(%esp)
80101c4d:	e8 c5 e5 ff ff       	call   80100217 <brelse>
    return addr;
80101c52:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c55:	eb 0c                	jmp    80101c63 <bmap+0x107>
  }

  panic("bmap: out of range");
80101c57:	c7 04 24 00 8a 10 80 	movl   $0x80108a00,(%esp)
80101c5e:	e8 d3 e8 ff ff       	call   80100536 <panic>
}
80101c63:	83 c4 24             	add    $0x24,%esp
80101c66:	5b                   	pop    %ebx
80101c67:	5d                   	pop    %ebp
80101c68:	c3                   	ret    

80101c69 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101c69:	55                   	push   %ebp
80101c6a:	89 e5                	mov    %esp,%ebp
80101c6c:	83 ec 28             	sub    $0x28,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101c6f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101c76:	eb 43                	jmp    80101cbb <itrunc+0x52>
    if(ip->addrs[i]){
80101c78:	8b 45 08             	mov    0x8(%ebp),%eax
80101c7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c7e:	83 c2 04             	add    $0x4,%edx
80101c81:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101c85:	85 c0                	test   %eax,%eax
80101c87:	74 2f                	je     80101cb8 <itrunc+0x4f>
      bfree(ip->dev, ip->addrs[i]);
80101c89:	8b 45 08             	mov    0x8(%ebp),%eax
80101c8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c8f:	83 c2 04             	add    $0x4,%edx
80101c92:	8b 54 90 0c          	mov    0xc(%eax,%edx,4),%edx
80101c96:	8b 45 08             	mov    0x8(%ebp),%eax
80101c99:	8b 00                	mov    (%eax),%eax
80101c9b:	89 54 24 04          	mov    %edx,0x4(%esp)
80101c9f:	89 04 24             	mov    %eax,(%esp)
80101ca2:	e8 19 f8 ff ff       	call   801014c0 <bfree>
      ip->addrs[i] = 0;
80101ca7:	8b 45 08             	mov    0x8(%ebp),%eax
80101caa:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101cad:	83 c2 04             	add    $0x4,%edx
80101cb0:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101cb7:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101cb8:	ff 45 f4             	incl   -0xc(%ebp)
80101cbb:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101cbf:	7e b7                	jle    80101c78 <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101cc1:	8b 45 08             	mov    0x8(%ebp),%eax
80101cc4:	8b 40 4c             	mov    0x4c(%eax),%eax
80101cc7:	85 c0                	test   %eax,%eax
80101cc9:	0f 84 9a 00 00 00    	je     80101d69 <itrunc+0x100>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101ccf:	8b 45 08             	mov    0x8(%ebp),%eax
80101cd2:	8b 50 4c             	mov    0x4c(%eax),%edx
80101cd5:	8b 45 08             	mov    0x8(%ebp),%eax
80101cd8:	8b 00                	mov    (%eax),%eax
80101cda:	89 54 24 04          	mov    %edx,0x4(%esp)
80101cde:	89 04 24             	mov    %eax,(%esp)
80101ce1:	e8 c0 e4 ff ff       	call   801001a6 <bread>
80101ce6:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101ce9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101cec:	83 c0 18             	add    $0x18,%eax
80101cef:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101cf2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101cf9:	eb 3a                	jmp    80101d35 <itrunc+0xcc>
      if(a[j])
80101cfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cfe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d05:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101d08:	01 d0                	add    %edx,%eax
80101d0a:	8b 00                	mov    (%eax),%eax
80101d0c:	85 c0                	test   %eax,%eax
80101d0e:	74 22                	je     80101d32 <itrunc+0xc9>
        bfree(ip->dev, a[j]);
80101d10:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d13:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101d1d:	01 d0                	add    %edx,%eax
80101d1f:	8b 10                	mov    (%eax),%edx
80101d21:	8b 45 08             	mov    0x8(%ebp),%eax
80101d24:	8b 00                	mov    (%eax),%eax
80101d26:	89 54 24 04          	mov    %edx,0x4(%esp)
80101d2a:	89 04 24             	mov    %eax,(%esp)
80101d2d:	e8 8e f7 ff ff       	call   801014c0 <bfree>
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101d32:	ff 45 f0             	incl   -0x10(%ebp)
80101d35:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d38:	83 f8 7f             	cmp    $0x7f,%eax
80101d3b:	76 be                	jbe    80101cfb <itrunc+0x92>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101d3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d40:	89 04 24             	mov    %eax,(%esp)
80101d43:	e8 cf e4 ff ff       	call   80100217 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101d48:	8b 45 08             	mov    0x8(%ebp),%eax
80101d4b:	8b 50 4c             	mov    0x4c(%eax),%edx
80101d4e:	8b 45 08             	mov    0x8(%ebp),%eax
80101d51:	8b 00                	mov    (%eax),%eax
80101d53:	89 54 24 04          	mov    %edx,0x4(%esp)
80101d57:	89 04 24             	mov    %eax,(%esp)
80101d5a:	e8 61 f7 ff ff       	call   801014c0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101d5f:	8b 45 08             	mov    0x8(%ebp),%eax
80101d62:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101d69:	8b 45 08             	mov    0x8(%ebp),%eax
80101d6c:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101d73:	8b 45 08             	mov    0x8(%ebp),%eax
80101d76:	89 04 24             	mov    %eax,(%esp)
80101d79:	e8 79 f9 ff ff       	call   801016f7 <iupdate>
}
80101d7e:	c9                   	leave  
80101d7f:	c3                   	ret    

80101d80 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101d80:	55                   	push   %ebp
80101d81:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101d83:	8b 45 08             	mov    0x8(%ebp),%eax
80101d86:	8b 00                	mov    (%eax),%eax
80101d88:	89 c2                	mov    %eax,%edx
80101d8a:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d8d:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101d90:	8b 45 08             	mov    0x8(%ebp),%eax
80101d93:	8b 50 04             	mov    0x4(%eax),%edx
80101d96:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d99:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101d9c:	8b 45 08             	mov    0x8(%ebp),%eax
80101d9f:	8b 40 10             	mov    0x10(%eax),%eax
80101da2:	8b 55 0c             	mov    0xc(%ebp),%edx
80101da5:	66 89 02             	mov    %ax,(%edx)
  st->nlink = ip->nlink;
80101da8:	8b 45 08             	mov    0x8(%ebp),%eax
80101dab:	66 8b 40 16          	mov    0x16(%eax),%ax
80101daf:	8b 55 0c             	mov    0xc(%ebp),%edx
80101db2:	66 89 42 0c          	mov    %ax,0xc(%edx)
  st->size = ip->size;
80101db6:	8b 45 08             	mov    0x8(%ebp),%eax
80101db9:	8b 50 18             	mov    0x18(%eax),%edx
80101dbc:	8b 45 0c             	mov    0xc(%ebp),%eax
80101dbf:	89 50 10             	mov    %edx,0x10(%eax)
}
80101dc2:	5d                   	pop    %ebp
80101dc3:	c3                   	ret    

80101dc4 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101dc4:	55                   	push   %ebp
80101dc5:	89 e5                	mov    %esp,%ebp
80101dc7:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101dca:	8b 45 08             	mov    0x8(%ebp),%eax
80101dcd:	8b 40 10             	mov    0x10(%eax),%eax
80101dd0:	66 83 f8 03          	cmp    $0x3,%ax
80101dd4:	75 60                	jne    80101e36 <readi+0x72>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101dd6:	8b 45 08             	mov    0x8(%ebp),%eax
80101dd9:	66 8b 40 12          	mov    0x12(%eax),%ax
80101ddd:	66 85 c0             	test   %ax,%ax
80101de0:	78 20                	js     80101e02 <readi+0x3e>
80101de2:	8b 45 08             	mov    0x8(%ebp),%eax
80101de5:	66 8b 40 12          	mov    0x12(%eax),%ax
80101de9:	66 83 f8 09          	cmp    $0x9,%ax
80101ded:	7f 13                	jg     80101e02 <readi+0x3e>
80101def:	8b 45 08             	mov    0x8(%ebp),%eax
80101df2:	66 8b 40 12          	mov    0x12(%eax),%ax
80101df6:	98                   	cwtl   
80101df7:	8b 04 c5 e0 21 11 80 	mov    -0x7feede20(,%eax,8),%eax
80101dfe:	85 c0                	test   %eax,%eax
80101e00:	75 0a                	jne    80101e0c <readi+0x48>
      return -1;
80101e02:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e07:	e9 1b 01 00 00       	jmp    80101f27 <readi+0x163>
    return devsw[ip->major].read(ip, dst, n);
80101e0c:	8b 45 08             	mov    0x8(%ebp),%eax
80101e0f:	66 8b 40 12          	mov    0x12(%eax),%ax
80101e13:	98                   	cwtl   
80101e14:	8b 04 c5 e0 21 11 80 	mov    -0x7feede20(,%eax,8),%eax
80101e1b:	8b 55 14             	mov    0x14(%ebp),%edx
80101e1e:	89 54 24 08          	mov    %edx,0x8(%esp)
80101e22:	8b 55 0c             	mov    0xc(%ebp),%edx
80101e25:	89 54 24 04          	mov    %edx,0x4(%esp)
80101e29:	8b 55 08             	mov    0x8(%ebp),%edx
80101e2c:	89 14 24             	mov    %edx,(%esp)
80101e2f:	ff d0                	call   *%eax
80101e31:	e9 f1 00 00 00       	jmp    80101f27 <readi+0x163>
  }

  if(off > ip->size || off + n < off)
80101e36:	8b 45 08             	mov    0x8(%ebp),%eax
80101e39:	8b 40 18             	mov    0x18(%eax),%eax
80101e3c:	3b 45 10             	cmp    0x10(%ebp),%eax
80101e3f:	72 0d                	jb     80101e4e <readi+0x8a>
80101e41:	8b 45 14             	mov    0x14(%ebp),%eax
80101e44:	8b 55 10             	mov    0x10(%ebp),%edx
80101e47:	01 d0                	add    %edx,%eax
80101e49:	3b 45 10             	cmp    0x10(%ebp),%eax
80101e4c:	73 0a                	jae    80101e58 <readi+0x94>
    return -1;
80101e4e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e53:	e9 cf 00 00 00       	jmp    80101f27 <readi+0x163>
  if(off + n > ip->size)
80101e58:	8b 45 14             	mov    0x14(%ebp),%eax
80101e5b:	8b 55 10             	mov    0x10(%ebp),%edx
80101e5e:	01 c2                	add    %eax,%edx
80101e60:	8b 45 08             	mov    0x8(%ebp),%eax
80101e63:	8b 40 18             	mov    0x18(%eax),%eax
80101e66:	39 c2                	cmp    %eax,%edx
80101e68:	76 0c                	jbe    80101e76 <readi+0xb2>
    n = ip->size - off;
80101e6a:	8b 45 08             	mov    0x8(%ebp),%eax
80101e6d:	8b 40 18             	mov    0x18(%eax),%eax
80101e70:	2b 45 10             	sub    0x10(%ebp),%eax
80101e73:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101e76:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101e7d:	e9 96 00 00 00       	jmp    80101f18 <readi+0x154>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e82:	8b 45 10             	mov    0x10(%ebp),%eax
80101e85:	c1 e8 09             	shr    $0x9,%eax
80101e88:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e8c:	8b 45 08             	mov    0x8(%ebp),%eax
80101e8f:	89 04 24             	mov    %eax,(%esp)
80101e92:	e8 c5 fc ff ff       	call   80101b5c <bmap>
80101e97:	8b 55 08             	mov    0x8(%ebp),%edx
80101e9a:	8b 12                	mov    (%edx),%edx
80101e9c:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ea0:	89 14 24             	mov    %edx,(%esp)
80101ea3:	e8 fe e2 ff ff       	call   801001a6 <bread>
80101ea8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101eab:	8b 45 10             	mov    0x10(%ebp),%eax
80101eae:	89 c2                	mov    %eax,%edx
80101eb0:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80101eb6:	b8 00 02 00 00       	mov    $0x200,%eax
80101ebb:	89 c1                	mov    %eax,%ecx
80101ebd:	29 d1                	sub    %edx,%ecx
80101ebf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ec2:	8b 55 14             	mov    0x14(%ebp),%edx
80101ec5:	29 c2                	sub    %eax,%edx
80101ec7:	89 c8                	mov    %ecx,%eax
80101ec9:	39 d0                	cmp    %edx,%eax
80101ecb:	76 02                	jbe    80101ecf <readi+0x10b>
80101ecd:	89 d0                	mov    %edx,%eax
80101ecf:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101ed2:	8b 45 10             	mov    0x10(%ebp),%eax
80101ed5:	25 ff 01 00 00       	and    $0x1ff,%eax
80101eda:	8d 50 10             	lea    0x10(%eax),%edx
80101edd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ee0:	01 d0                	add    %edx,%eax
80101ee2:	8d 50 08             	lea    0x8(%eax),%edx
80101ee5:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ee8:	89 44 24 08          	mov    %eax,0x8(%esp)
80101eec:	89 54 24 04          	mov    %edx,0x4(%esp)
80101ef0:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ef3:	89 04 24             	mov    %eax,(%esp)
80101ef6:	e8 83 33 00 00       	call   8010527e <memmove>
    brelse(bp);
80101efb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101efe:	89 04 24             	mov    %eax,(%esp)
80101f01:	e8 11 e3 ff ff       	call   80100217 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101f06:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f09:	01 45 f4             	add    %eax,-0xc(%ebp)
80101f0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f0f:	01 45 10             	add    %eax,0x10(%ebp)
80101f12:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f15:	01 45 0c             	add    %eax,0xc(%ebp)
80101f18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101f1b:	3b 45 14             	cmp    0x14(%ebp),%eax
80101f1e:	0f 82 5e ff ff ff    	jb     80101e82 <readi+0xbe>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101f24:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101f27:	c9                   	leave  
80101f28:	c3                   	ret    

80101f29 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101f29:	55                   	push   %ebp
80101f2a:	89 e5                	mov    %esp,%ebp
80101f2c:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101f2f:	8b 45 08             	mov    0x8(%ebp),%eax
80101f32:	8b 40 10             	mov    0x10(%eax),%eax
80101f35:	66 83 f8 03          	cmp    $0x3,%ax
80101f39:	75 60                	jne    80101f9b <writei+0x72>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101f3b:	8b 45 08             	mov    0x8(%ebp),%eax
80101f3e:	66 8b 40 12          	mov    0x12(%eax),%ax
80101f42:	66 85 c0             	test   %ax,%ax
80101f45:	78 20                	js     80101f67 <writei+0x3e>
80101f47:	8b 45 08             	mov    0x8(%ebp),%eax
80101f4a:	66 8b 40 12          	mov    0x12(%eax),%ax
80101f4e:	66 83 f8 09          	cmp    $0x9,%ax
80101f52:	7f 13                	jg     80101f67 <writei+0x3e>
80101f54:	8b 45 08             	mov    0x8(%ebp),%eax
80101f57:	66 8b 40 12          	mov    0x12(%eax),%ax
80101f5b:	98                   	cwtl   
80101f5c:	8b 04 c5 e4 21 11 80 	mov    -0x7feede1c(,%eax,8),%eax
80101f63:	85 c0                	test   %eax,%eax
80101f65:	75 0a                	jne    80101f71 <writei+0x48>
      return -1;
80101f67:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f6c:	e9 46 01 00 00       	jmp    801020b7 <writei+0x18e>
    return devsw[ip->major].write(ip, src, n);
80101f71:	8b 45 08             	mov    0x8(%ebp),%eax
80101f74:	66 8b 40 12          	mov    0x12(%eax),%ax
80101f78:	98                   	cwtl   
80101f79:	8b 04 c5 e4 21 11 80 	mov    -0x7feede1c(,%eax,8),%eax
80101f80:	8b 55 14             	mov    0x14(%ebp),%edx
80101f83:	89 54 24 08          	mov    %edx,0x8(%esp)
80101f87:	8b 55 0c             	mov    0xc(%ebp),%edx
80101f8a:	89 54 24 04          	mov    %edx,0x4(%esp)
80101f8e:	8b 55 08             	mov    0x8(%ebp),%edx
80101f91:	89 14 24             	mov    %edx,(%esp)
80101f94:	ff d0                	call   *%eax
80101f96:	e9 1c 01 00 00       	jmp    801020b7 <writei+0x18e>
  }

  if(off > ip->size || off + n < off)
80101f9b:	8b 45 08             	mov    0x8(%ebp),%eax
80101f9e:	8b 40 18             	mov    0x18(%eax),%eax
80101fa1:	3b 45 10             	cmp    0x10(%ebp),%eax
80101fa4:	72 0d                	jb     80101fb3 <writei+0x8a>
80101fa6:	8b 45 14             	mov    0x14(%ebp),%eax
80101fa9:	8b 55 10             	mov    0x10(%ebp),%edx
80101fac:	01 d0                	add    %edx,%eax
80101fae:	3b 45 10             	cmp    0x10(%ebp),%eax
80101fb1:	73 0a                	jae    80101fbd <writei+0x94>
    return -1;
80101fb3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fb8:	e9 fa 00 00 00       	jmp    801020b7 <writei+0x18e>
  if(off + n > MAXFILE*BSIZE)
80101fbd:	8b 45 14             	mov    0x14(%ebp),%eax
80101fc0:	8b 55 10             	mov    0x10(%ebp),%edx
80101fc3:	01 d0                	add    %edx,%eax
80101fc5:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101fca:	76 0a                	jbe    80101fd6 <writei+0xad>
    return -1;
80101fcc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fd1:	e9 e1 00 00 00       	jmp    801020b7 <writei+0x18e>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101fd6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101fdd:	e9 a1 00 00 00       	jmp    80102083 <writei+0x15a>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101fe2:	8b 45 10             	mov    0x10(%ebp),%eax
80101fe5:	c1 e8 09             	shr    $0x9,%eax
80101fe8:	89 44 24 04          	mov    %eax,0x4(%esp)
80101fec:	8b 45 08             	mov    0x8(%ebp),%eax
80101fef:	89 04 24             	mov    %eax,(%esp)
80101ff2:	e8 65 fb ff ff       	call   80101b5c <bmap>
80101ff7:	8b 55 08             	mov    0x8(%ebp),%edx
80101ffa:	8b 12                	mov    (%edx),%edx
80101ffc:	89 44 24 04          	mov    %eax,0x4(%esp)
80102000:	89 14 24             	mov    %edx,(%esp)
80102003:	e8 9e e1 ff ff       	call   801001a6 <bread>
80102008:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
8010200b:	8b 45 10             	mov    0x10(%ebp),%eax
8010200e:	89 c2                	mov    %eax,%edx
80102010:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80102016:	b8 00 02 00 00       	mov    $0x200,%eax
8010201b:	89 c1                	mov    %eax,%ecx
8010201d:	29 d1                	sub    %edx,%ecx
8010201f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102022:	8b 55 14             	mov    0x14(%ebp),%edx
80102025:	29 c2                	sub    %eax,%edx
80102027:	89 c8                	mov    %ecx,%eax
80102029:	39 d0                	cmp    %edx,%eax
8010202b:	76 02                	jbe    8010202f <writei+0x106>
8010202d:	89 d0                	mov    %edx,%eax
8010202f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
80102032:	8b 45 10             	mov    0x10(%ebp),%eax
80102035:	25 ff 01 00 00       	and    $0x1ff,%eax
8010203a:	8d 50 10             	lea    0x10(%eax),%edx
8010203d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102040:	01 d0                	add    %edx,%eax
80102042:	8d 50 08             	lea    0x8(%eax),%edx
80102045:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102048:	89 44 24 08          	mov    %eax,0x8(%esp)
8010204c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010204f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102053:	89 14 24             	mov    %edx,(%esp)
80102056:	e8 23 32 00 00       	call   8010527e <memmove>
    log_write(bp);
8010205b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010205e:	89 04 24             	mov    %eax,(%esp)
80102061:	e8 42 16 00 00       	call   801036a8 <log_write>
    brelse(bp);
80102066:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102069:	89 04 24             	mov    %eax,(%esp)
8010206c:	e8 a6 e1 ff ff       	call   80100217 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102071:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102074:	01 45 f4             	add    %eax,-0xc(%ebp)
80102077:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010207a:	01 45 10             	add    %eax,0x10(%ebp)
8010207d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102080:	01 45 0c             	add    %eax,0xc(%ebp)
80102083:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102086:	3b 45 14             	cmp    0x14(%ebp),%eax
80102089:	0f 82 53 ff ff ff    	jb     80101fe2 <writei+0xb9>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
8010208f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80102093:	74 1f                	je     801020b4 <writei+0x18b>
80102095:	8b 45 08             	mov    0x8(%ebp),%eax
80102098:	8b 40 18             	mov    0x18(%eax),%eax
8010209b:	3b 45 10             	cmp    0x10(%ebp),%eax
8010209e:	73 14                	jae    801020b4 <writei+0x18b>
    ip->size = off;
801020a0:	8b 45 08             	mov    0x8(%ebp),%eax
801020a3:	8b 55 10             	mov    0x10(%ebp),%edx
801020a6:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
801020a9:	8b 45 08             	mov    0x8(%ebp),%eax
801020ac:	89 04 24             	mov    %eax,(%esp)
801020af:	e8 43 f6 ff ff       	call   801016f7 <iupdate>
  }
  return n;
801020b4:	8b 45 14             	mov    0x14(%ebp),%eax
}
801020b7:	c9                   	leave  
801020b8:	c3                   	ret    

801020b9 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
801020b9:	55                   	push   %ebp
801020ba:	89 e5                	mov    %esp,%ebp
801020bc:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
801020bf:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801020c6:	00 
801020c7:	8b 45 0c             	mov    0xc(%ebp),%eax
801020ca:	89 44 24 04          	mov    %eax,0x4(%esp)
801020ce:	8b 45 08             	mov    0x8(%ebp),%eax
801020d1:	89 04 24             	mov    %eax,(%esp)
801020d4:	e8 41 32 00 00       	call   8010531a <strncmp>
}
801020d9:	c9                   	leave  
801020da:	c3                   	ret    

801020db <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
801020db:	55                   	push   %ebp
801020dc:	89 e5                	mov    %esp,%ebp
801020de:	83 ec 38             	sub    $0x38,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
801020e1:	8b 45 08             	mov    0x8(%ebp),%eax
801020e4:	8b 40 10             	mov    0x10(%eax),%eax
801020e7:	66 83 f8 01          	cmp    $0x1,%ax
801020eb:	74 0c                	je     801020f9 <dirlookup+0x1e>
    panic("dirlookup not DIR");
801020ed:	c7 04 24 13 8a 10 80 	movl   $0x80108a13,(%esp)
801020f4:	e8 3d e4 ff ff       	call   80100536 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
801020f9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102100:	e9 85 00 00 00       	jmp    8010218a <dirlookup+0xaf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102105:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
8010210c:	00 
8010210d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102110:	89 44 24 08          	mov    %eax,0x8(%esp)
80102114:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102117:	89 44 24 04          	mov    %eax,0x4(%esp)
8010211b:	8b 45 08             	mov    0x8(%ebp),%eax
8010211e:	89 04 24             	mov    %eax,(%esp)
80102121:	e8 9e fc ff ff       	call   80101dc4 <readi>
80102126:	83 f8 10             	cmp    $0x10,%eax
80102129:	74 0c                	je     80102137 <dirlookup+0x5c>
      panic("dirlink read");
8010212b:	c7 04 24 25 8a 10 80 	movl   $0x80108a25,(%esp)
80102132:	e8 ff e3 ff ff       	call   80100536 <panic>
    if(de.inum == 0)
80102137:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010213a:	66 85 c0             	test   %ax,%ax
8010213d:	74 46                	je     80102185 <dirlookup+0xaa>
      continue;
    if(namecmp(name, de.name) == 0){
8010213f:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102142:	83 c0 02             	add    $0x2,%eax
80102145:	89 44 24 04          	mov    %eax,0x4(%esp)
80102149:	8b 45 0c             	mov    0xc(%ebp),%eax
8010214c:	89 04 24             	mov    %eax,(%esp)
8010214f:	e8 65 ff ff ff       	call   801020b9 <namecmp>
80102154:	85 c0                	test   %eax,%eax
80102156:	75 2e                	jne    80102186 <dirlookup+0xab>
      // entry matches path element
      if(poff)
80102158:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010215c:	74 08                	je     80102166 <dirlookup+0x8b>
        *poff = off;
8010215e:	8b 45 10             	mov    0x10(%ebp),%eax
80102161:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102164:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
80102166:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102169:	0f b7 c0             	movzwl %ax,%eax
8010216c:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
8010216f:	8b 45 08             	mov    0x8(%ebp),%eax
80102172:	8b 00                	mov    (%eax),%eax
80102174:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102177:	89 54 24 04          	mov    %edx,0x4(%esp)
8010217b:	89 04 24             	mov    %eax,(%esp)
8010217e:	e8 30 f6 ff ff       	call   801017b3 <iget>
80102183:	eb 19                	jmp    8010219e <dirlookup+0xc3>

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
80102185:	90                   	nop
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80102186:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010218a:	8b 45 08             	mov    0x8(%ebp),%eax
8010218d:	8b 40 18             	mov    0x18(%eax),%eax
80102190:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80102193:	0f 87 6c ff ff ff    	ja     80102105 <dirlookup+0x2a>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80102199:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010219e:	c9                   	leave  
8010219f:	c3                   	ret    

801021a0 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
801021a0:	55                   	push   %ebp
801021a1:	89 e5                	mov    %esp,%ebp
801021a3:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
801021a6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801021ad:	00 
801021ae:	8b 45 0c             	mov    0xc(%ebp),%eax
801021b1:	89 44 24 04          	mov    %eax,0x4(%esp)
801021b5:	8b 45 08             	mov    0x8(%ebp),%eax
801021b8:	89 04 24             	mov    %eax,(%esp)
801021bb:	e8 1b ff ff ff       	call   801020db <dirlookup>
801021c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
801021c3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801021c7:	74 15                	je     801021de <dirlink+0x3e>
    iput(ip);
801021c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801021cc:	89 04 24             	mov    %eax,(%esp)
801021cf:	e8 99 f8 ff ff       	call   80101a6d <iput>
    return -1;
801021d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021d9:	e9 b7 00 00 00       	jmp    80102295 <dirlink+0xf5>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801021de:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801021e5:	eb 43                	jmp    8010222a <dirlink+0x8a>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801021ea:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801021f1:	00 
801021f2:	89 44 24 08          	mov    %eax,0x8(%esp)
801021f6:	8d 45 e0             	lea    -0x20(%ebp),%eax
801021f9:	89 44 24 04          	mov    %eax,0x4(%esp)
801021fd:	8b 45 08             	mov    0x8(%ebp),%eax
80102200:	89 04 24             	mov    %eax,(%esp)
80102203:	e8 bc fb ff ff       	call   80101dc4 <readi>
80102208:	83 f8 10             	cmp    $0x10,%eax
8010220b:	74 0c                	je     80102219 <dirlink+0x79>
      panic("dirlink read");
8010220d:	c7 04 24 25 8a 10 80 	movl   $0x80108a25,(%esp)
80102214:	e8 1d e3 ff ff       	call   80100536 <panic>
    if(de.inum == 0)
80102219:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010221c:	66 85 c0             	test   %ax,%ax
8010221f:	74 18                	je     80102239 <dirlink+0x99>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102221:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102224:	83 c0 10             	add    $0x10,%eax
80102227:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010222a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010222d:	8b 45 08             	mov    0x8(%ebp),%eax
80102230:	8b 40 18             	mov    0x18(%eax),%eax
80102233:	39 c2                	cmp    %eax,%edx
80102235:	72 b0                	jb     801021e7 <dirlink+0x47>
80102237:	eb 01                	jmp    8010223a <dirlink+0x9a>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      break;
80102239:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
8010223a:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80102241:	00 
80102242:	8b 45 0c             	mov    0xc(%ebp),%eax
80102245:	89 44 24 04          	mov    %eax,0x4(%esp)
80102249:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010224c:	83 c0 02             	add    $0x2,%eax
8010224f:	89 04 24             	mov    %eax,(%esp)
80102252:	e8 13 31 00 00       	call   8010536a <strncpy>
  de.inum = inum;
80102257:	8b 45 10             	mov    0x10(%ebp),%eax
8010225a:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010225e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102261:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80102268:	00 
80102269:	89 44 24 08          	mov    %eax,0x8(%esp)
8010226d:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102270:	89 44 24 04          	mov    %eax,0x4(%esp)
80102274:	8b 45 08             	mov    0x8(%ebp),%eax
80102277:	89 04 24             	mov    %eax,(%esp)
8010227a:	e8 aa fc ff ff       	call   80101f29 <writei>
8010227f:	83 f8 10             	cmp    $0x10,%eax
80102282:	74 0c                	je     80102290 <dirlink+0xf0>
    panic("dirlink");
80102284:	c7 04 24 32 8a 10 80 	movl   $0x80108a32,(%esp)
8010228b:	e8 a6 e2 ff ff       	call   80100536 <panic>
  
  return 0;
80102290:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102295:	c9                   	leave  
80102296:	c3                   	ret    

80102297 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80102297:	55                   	push   %ebp
80102298:	89 e5                	mov    %esp,%ebp
8010229a:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int len;

  while(*path == '/')
8010229d:	eb 03                	jmp    801022a2 <skipelem+0xb>
    path++;
8010229f:	ff 45 08             	incl   0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
801022a2:	8b 45 08             	mov    0x8(%ebp),%eax
801022a5:	8a 00                	mov    (%eax),%al
801022a7:	3c 2f                	cmp    $0x2f,%al
801022a9:	74 f4                	je     8010229f <skipelem+0x8>
    path++;
  if(*path == 0)
801022ab:	8b 45 08             	mov    0x8(%ebp),%eax
801022ae:	8a 00                	mov    (%eax),%al
801022b0:	84 c0                	test   %al,%al
801022b2:	75 0a                	jne    801022be <skipelem+0x27>
    return 0;
801022b4:	b8 00 00 00 00       	mov    $0x0,%eax
801022b9:	e9 83 00 00 00       	jmp    80102341 <skipelem+0xaa>
  s = path;
801022be:	8b 45 08             	mov    0x8(%ebp),%eax
801022c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
801022c4:	eb 03                	jmp    801022c9 <skipelem+0x32>
    path++;
801022c6:	ff 45 08             	incl   0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
801022c9:	8b 45 08             	mov    0x8(%ebp),%eax
801022cc:	8a 00                	mov    (%eax),%al
801022ce:	3c 2f                	cmp    $0x2f,%al
801022d0:	74 09                	je     801022db <skipelem+0x44>
801022d2:	8b 45 08             	mov    0x8(%ebp),%eax
801022d5:	8a 00                	mov    (%eax),%al
801022d7:	84 c0                	test   %al,%al
801022d9:	75 eb                	jne    801022c6 <skipelem+0x2f>
    path++;
  len = path - s;
801022db:	8b 55 08             	mov    0x8(%ebp),%edx
801022de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022e1:	89 d1                	mov    %edx,%ecx
801022e3:	29 c1                	sub    %eax,%ecx
801022e5:	89 c8                	mov    %ecx,%eax
801022e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
801022ea:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801022ee:	7e 1c                	jle    8010230c <skipelem+0x75>
    memmove(name, s, DIRSIZ);
801022f0:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801022f7:	00 
801022f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022fb:	89 44 24 04          	mov    %eax,0x4(%esp)
801022ff:	8b 45 0c             	mov    0xc(%ebp),%eax
80102302:	89 04 24             	mov    %eax,(%esp)
80102305:	e8 74 2f 00 00       	call   8010527e <memmove>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
8010230a:	eb 29                	jmp    80102335 <skipelem+0x9e>
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
8010230c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010230f:	89 44 24 08          	mov    %eax,0x8(%esp)
80102313:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102316:	89 44 24 04          	mov    %eax,0x4(%esp)
8010231a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010231d:	89 04 24             	mov    %eax,(%esp)
80102320:	e8 59 2f 00 00       	call   8010527e <memmove>
    name[len] = 0;
80102325:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102328:	8b 45 0c             	mov    0xc(%ebp),%eax
8010232b:	01 d0                	add    %edx,%eax
8010232d:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
80102330:	eb 03                	jmp    80102335 <skipelem+0x9e>
    path++;
80102332:	ff 45 08             	incl   0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80102335:	8b 45 08             	mov    0x8(%ebp),%eax
80102338:	8a 00                	mov    (%eax),%al
8010233a:	3c 2f                	cmp    $0x2f,%al
8010233c:	74 f4                	je     80102332 <skipelem+0x9b>
    path++;
  return path;
8010233e:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102341:	c9                   	leave  
80102342:	c3                   	ret    

80102343 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102343:	55                   	push   %ebp
80102344:	89 e5                	mov    %esp,%ebp
80102346:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *next;

  if(*path == '/')
80102349:	8b 45 08             	mov    0x8(%ebp),%eax
8010234c:	8a 00                	mov    (%eax),%al
8010234e:	3c 2f                	cmp    $0x2f,%al
80102350:	75 1c                	jne    8010236e <namex+0x2b>
    ip = iget(ROOTDEV, ROOTINO);
80102352:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102359:	00 
8010235a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102361:	e8 4d f4 ff ff       	call   801017b3 <iget>
80102366:	89 45 f4             	mov    %eax,-0xc(%ebp)
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
80102369:	e9 ad 00 00 00       	jmp    8010241b <namex+0xd8>
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
8010236e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80102374:	8b 40 68             	mov    0x68(%eax),%eax
80102377:	89 04 24             	mov    %eax,(%esp)
8010237a:	e8 06 f5 ff ff       	call   80101885 <idup>
8010237f:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
80102382:	e9 94 00 00 00       	jmp    8010241b <namex+0xd8>
    ilock(ip);
80102387:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010238a:	89 04 24             	mov    %eax,(%esp)
8010238d:	e8 25 f5 ff ff       	call   801018b7 <ilock>
    if(ip->type != T_DIR){
80102392:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102395:	8b 40 10             	mov    0x10(%eax),%eax
80102398:	66 83 f8 01          	cmp    $0x1,%ax
8010239c:	74 15                	je     801023b3 <namex+0x70>
      iunlockput(ip);
8010239e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023a1:	89 04 24             	mov    %eax,(%esp)
801023a4:	e8 95 f7 ff ff       	call   80101b3e <iunlockput>
      return 0;
801023a9:	b8 00 00 00 00       	mov    $0x0,%eax
801023ae:	e9 a2 00 00 00       	jmp    80102455 <namex+0x112>
    }
    if(nameiparent && *path == '\0'){
801023b3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801023b7:	74 1c                	je     801023d5 <namex+0x92>
801023b9:	8b 45 08             	mov    0x8(%ebp),%eax
801023bc:	8a 00                	mov    (%eax),%al
801023be:	84 c0                	test   %al,%al
801023c0:	75 13                	jne    801023d5 <namex+0x92>
      // Stop one level early.
      iunlock(ip);
801023c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023c5:	89 04 24             	mov    %eax,(%esp)
801023c8:	e8 3b f6 ff ff       	call   80101a08 <iunlock>
      return ip;
801023cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023d0:	e9 80 00 00 00       	jmp    80102455 <namex+0x112>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801023d5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801023dc:	00 
801023dd:	8b 45 10             	mov    0x10(%ebp),%eax
801023e0:	89 44 24 04          	mov    %eax,0x4(%esp)
801023e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023e7:	89 04 24             	mov    %eax,(%esp)
801023ea:	e8 ec fc ff ff       	call   801020db <dirlookup>
801023ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
801023f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801023f6:	75 12                	jne    8010240a <namex+0xc7>
      iunlockput(ip);
801023f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023fb:	89 04 24             	mov    %eax,(%esp)
801023fe:	e8 3b f7 ff ff       	call   80101b3e <iunlockput>
      return 0;
80102403:	b8 00 00 00 00       	mov    $0x0,%eax
80102408:	eb 4b                	jmp    80102455 <namex+0x112>
    }
    iunlockput(ip);
8010240a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010240d:	89 04 24             	mov    %eax,(%esp)
80102410:	e8 29 f7 ff ff       	call   80101b3e <iunlockput>
    ip = next;
80102415:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102418:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
8010241b:	8b 45 10             	mov    0x10(%ebp),%eax
8010241e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102422:	8b 45 08             	mov    0x8(%ebp),%eax
80102425:	89 04 24             	mov    %eax,(%esp)
80102428:	e8 6a fe ff ff       	call   80102297 <skipelem>
8010242d:	89 45 08             	mov    %eax,0x8(%ebp)
80102430:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102434:	0f 85 4d ff ff ff    	jne    80102387 <namex+0x44>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
8010243a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010243e:	74 12                	je     80102452 <namex+0x10f>
    iput(ip);
80102440:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102443:	89 04 24             	mov    %eax,(%esp)
80102446:	e8 22 f6 ff ff       	call   80101a6d <iput>
    return 0;
8010244b:	b8 00 00 00 00       	mov    $0x0,%eax
80102450:	eb 03                	jmp    80102455 <namex+0x112>
  }
  return ip;
80102452:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102455:	c9                   	leave  
80102456:	c3                   	ret    

80102457 <namei>:

struct inode*
namei(char *path)
{
80102457:	55                   	push   %ebp
80102458:	89 e5                	mov    %esp,%ebp
8010245a:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
8010245d:	8d 45 ea             	lea    -0x16(%ebp),%eax
80102460:	89 44 24 08          	mov    %eax,0x8(%esp)
80102464:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010246b:	00 
8010246c:	8b 45 08             	mov    0x8(%ebp),%eax
8010246f:	89 04 24             	mov    %eax,(%esp)
80102472:	e8 cc fe ff ff       	call   80102343 <namex>
}
80102477:	c9                   	leave  
80102478:	c3                   	ret    

80102479 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102479:	55                   	push   %ebp
8010247a:	89 e5                	mov    %esp,%ebp
8010247c:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 1, name);
8010247f:	8b 45 0c             	mov    0xc(%ebp),%eax
80102482:	89 44 24 08          	mov    %eax,0x8(%esp)
80102486:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010248d:	00 
8010248e:	8b 45 08             	mov    0x8(%ebp),%eax
80102491:	89 04 24             	mov    %eax,(%esp)
80102494:	e8 aa fe ff ff       	call   80102343 <namex>
}
80102499:	c9                   	leave  
8010249a:	c3                   	ret    
8010249b:	90                   	nop

8010249c <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
8010249c:	55                   	push   %ebp
8010249d:	89 e5                	mov    %esp,%ebp
8010249f:	53                   	push   %ebx
801024a0:	83 ec 14             	sub    $0x14,%esp
801024a3:	8b 45 08             	mov    0x8(%ebp),%eax
801024a6:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801024aa:	8b 55 e8             	mov    -0x18(%ebp),%edx
801024ad:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
801024b1:	66 8b 55 ea          	mov    -0x16(%ebp),%dx
801024b5:	ec                   	in     (%dx),%al
801024b6:	88 c3                	mov    %al,%bl
801024b8:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
801024bb:	8a 45 fb             	mov    -0x5(%ebp),%al
}
801024be:	83 c4 14             	add    $0x14,%esp
801024c1:	5b                   	pop    %ebx
801024c2:	5d                   	pop    %ebp
801024c3:	c3                   	ret    

801024c4 <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
801024c4:	55                   	push   %ebp
801024c5:	89 e5                	mov    %esp,%ebp
801024c7:	57                   	push   %edi
801024c8:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
801024c9:	8b 55 08             	mov    0x8(%ebp),%edx
801024cc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801024cf:	8b 45 10             	mov    0x10(%ebp),%eax
801024d2:	89 cb                	mov    %ecx,%ebx
801024d4:	89 df                	mov    %ebx,%edi
801024d6:	89 c1                	mov    %eax,%ecx
801024d8:	fc                   	cld    
801024d9:	f3 6d                	rep insl (%dx),%es:(%edi)
801024db:	89 c8                	mov    %ecx,%eax
801024dd:	89 fb                	mov    %edi,%ebx
801024df:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801024e2:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
801024e5:	5b                   	pop    %ebx
801024e6:	5f                   	pop    %edi
801024e7:	5d                   	pop    %ebp
801024e8:	c3                   	ret    

801024e9 <outb>:

static inline void
outb(ushort port, uchar data)
{
801024e9:	55                   	push   %ebp
801024ea:	89 e5                	mov    %esp,%ebp
801024ec:	83 ec 08             	sub    $0x8,%esp
801024ef:	8b 45 08             	mov    0x8(%ebp),%eax
801024f2:	8b 55 0c             	mov    0xc(%ebp),%edx
801024f5:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
801024f9:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801024fc:	8a 45 f8             	mov    -0x8(%ebp),%al
801024ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
80102502:	ee                   	out    %al,(%dx)
}
80102503:	c9                   	leave  
80102504:	c3                   	ret    

80102505 <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
80102505:	55                   	push   %ebp
80102506:	89 e5                	mov    %esp,%ebp
80102508:	56                   	push   %esi
80102509:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
8010250a:	8b 55 08             	mov    0x8(%ebp),%edx
8010250d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102510:	8b 45 10             	mov    0x10(%ebp),%eax
80102513:	89 cb                	mov    %ecx,%ebx
80102515:	89 de                	mov    %ebx,%esi
80102517:	89 c1                	mov    %eax,%ecx
80102519:	fc                   	cld    
8010251a:	f3 6f                	rep outsl %ds:(%esi),(%dx)
8010251c:	89 c8                	mov    %ecx,%eax
8010251e:	89 f3                	mov    %esi,%ebx
80102520:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102523:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
80102526:	5b                   	pop    %ebx
80102527:	5e                   	pop    %esi
80102528:	5d                   	pop    %ebp
80102529:	c3                   	ret    

8010252a <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
8010252a:	55                   	push   %ebp
8010252b:	89 e5                	mov    %esp,%ebp
8010252d:	83 ec 14             	sub    $0x14,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
80102530:	90                   	nop
80102531:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102538:	e8 5f ff ff ff       	call   8010249c <inb>
8010253d:	0f b6 c0             	movzbl %al,%eax
80102540:	89 45 fc             	mov    %eax,-0x4(%ebp)
80102543:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102546:	25 c0 00 00 00       	and    $0xc0,%eax
8010254b:	83 f8 40             	cmp    $0x40,%eax
8010254e:	75 e1                	jne    80102531 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102550:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102554:	74 11                	je     80102567 <idewait+0x3d>
80102556:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102559:	83 e0 21             	and    $0x21,%eax
8010255c:	85 c0                	test   %eax,%eax
8010255e:	74 07                	je     80102567 <idewait+0x3d>
    return -1;
80102560:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102565:	eb 05                	jmp    8010256c <idewait+0x42>
  return 0;
80102567:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010256c:	c9                   	leave  
8010256d:	c3                   	ret    

8010256e <ideinit>:

void
ideinit(void)
{
8010256e:	55                   	push   %ebp
8010256f:	89 e5                	mov    %esp,%ebp
80102571:	83 ec 28             	sub    $0x28,%esp
  int i;
  
  initlock(&idelock, "ide");
80102574:	c7 44 24 04 3a 8a 10 	movl   $0x80108a3a,0x4(%esp)
8010257b:	80 
8010257c:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
80102583:	e8 b6 29 00 00       	call   80104f3e <initlock>
  picenable(IRQ_IDE);
80102588:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
8010258f:	e8 00 19 00 00       	call   80103e94 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102594:	a1 60 39 11 80       	mov    0x80113960,%eax
80102599:	48                   	dec    %eax
8010259a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010259e:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
801025a5:	e8 43 04 00 00       	call   801029ed <ioapicenable>
  idewait(0);
801025aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801025b1:	e8 74 ff ff ff       	call   8010252a <idewait>
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
801025b6:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
801025bd:	00 
801025be:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
801025c5:	e8 1f ff ff ff       	call   801024e9 <outb>
  for(i=0; i<1000; i++){
801025ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801025d1:	eb 1f                	jmp    801025f2 <ideinit+0x84>
    if(inb(0x1f7) != 0){
801025d3:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801025da:	e8 bd fe ff ff       	call   8010249c <inb>
801025df:	84 c0                	test   %al,%al
801025e1:	74 0c                	je     801025ef <ideinit+0x81>
      havedisk1 = 1;
801025e3:	c7 05 58 c6 10 80 01 	movl   $0x1,0x8010c658
801025ea:	00 00 00 
      break;
801025ed:	eb 0c                	jmp    801025fb <ideinit+0x8d>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
801025ef:	ff 45 f4             	incl   -0xc(%ebp)
801025f2:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
801025f9:	7e d8                	jle    801025d3 <ideinit+0x65>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
801025fb:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
80102602:	00 
80102603:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
8010260a:	e8 da fe ff ff       	call   801024e9 <outb>
}
8010260f:	c9                   	leave  
80102610:	c3                   	ret    

80102611 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102611:	55                   	push   %ebp
80102612:	89 e5                	mov    %esp,%ebp
80102614:	83 ec 28             	sub    $0x28,%esp
  if(b == 0)
80102617:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010261b:	75 0c                	jne    80102629 <idestart+0x18>
    panic("idestart");
8010261d:	c7 04 24 3e 8a 10 80 	movl   $0x80108a3e,(%esp)
80102624:	e8 0d df ff ff       	call   80100536 <panic>
  if(b->blockno >= FSSIZE)
80102629:	8b 45 08             	mov    0x8(%ebp),%eax
8010262c:	8b 40 08             	mov    0x8(%eax),%eax
8010262f:	3d e7 03 00 00       	cmp    $0x3e7,%eax
80102634:	76 0c                	jbe    80102642 <idestart+0x31>
    panic("incorrect blockno");
80102636:	c7 04 24 47 8a 10 80 	movl   $0x80108a47,(%esp)
8010263d:	e8 f4 de ff ff       	call   80100536 <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
80102642:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
80102649:	8b 45 08             	mov    0x8(%ebp),%eax
8010264c:	8b 50 08             	mov    0x8(%eax),%edx
8010264f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102652:	0f af c2             	imul   %edx,%eax
80102655:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if (sector_per_block > 7) panic("idestart");
80102658:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
8010265c:	7e 0c                	jle    8010266a <idestart+0x59>
8010265e:	c7 04 24 3e 8a 10 80 	movl   $0x80108a3e,(%esp)
80102665:	e8 cc de ff ff       	call   80100536 <panic>
  
  idewait(0);
8010266a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80102671:	e8 b4 fe ff ff       	call   8010252a <idewait>
  outb(0x3f6, 0);  // generate interrupt
80102676:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010267d:	00 
8010267e:	c7 04 24 f6 03 00 00 	movl   $0x3f6,(%esp)
80102685:	e8 5f fe ff ff       	call   801024e9 <outb>
  outb(0x1f2, sector_per_block);  // number of sectors
8010268a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010268d:	0f b6 c0             	movzbl %al,%eax
80102690:	89 44 24 04          	mov    %eax,0x4(%esp)
80102694:	c7 04 24 f2 01 00 00 	movl   $0x1f2,(%esp)
8010269b:	e8 49 fe ff ff       	call   801024e9 <outb>
  outb(0x1f3, sector & 0xff);
801026a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801026a3:	0f b6 c0             	movzbl %al,%eax
801026a6:	89 44 24 04          	mov    %eax,0x4(%esp)
801026aa:	c7 04 24 f3 01 00 00 	movl   $0x1f3,(%esp)
801026b1:	e8 33 fe ff ff       	call   801024e9 <outb>
  outb(0x1f4, (sector >> 8) & 0xff);
801026b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801026b9:	c1 f8 08             	sar    $0x8,%eax
801026bc:	0f b6 c0             	movzbl %al,%eax
801026bf:	89 44 24 04          	mov    %eax,0x4(%esp)
801026c3:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
801026ca:	e8 1a fe ff ff       	call   801024e9 <outb>
  outb(0x1f5, (sector >> 16) & 0xff);
801026cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801026d2:	c1 f8 10             	sar    $0x10,%eax
801026d5:	0f b6 c0             	movzbl %al,%eax
801026d8:	89 44 24 04          	mov    %eax,0x4(%esp)
801026dc:	c7 04 24 f5 01 00 00 	movl   $0x1f5,(%esp)
801026e3:	e8 01 fe ff ff       	call   801024e9 <outb>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801026e8:	8b 45 08             	mov    0x8(%ebp),%eax
801026eb:	8b 40 04             	mov    0x4(%eax),%eax
801026ee:	83 e0 01             	and    $0x1,%eax
801026f1:	88 c2                	mov    %al,%dl
801026f3:	c1 e2 04             	shl    $0x4,%edx
801026f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801026f9:	c1 f8 18             	sar    $0x18,%eax
801026fc:	83 e0 0f             	and    $0xf,%eax
801026ff:	09 d0                	or     %edx,%eax
80102701:	83 c8 e0             	or     $0xffffffe0,%eax
80102704:	0f b6 c0             	movzbl %al,%eax
80102707:	89 44 24 04          	mov    %eax,0x4(%esp)
8010270b:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
80102712:	e8 d2 fd ff ff       	call   801024e9 <outb>
  if(b->flags & B_DIRTY){
80102717:	8b 45 08             	mov    0x8(%ebp),%eax
8010271a:	8b 00                	mov    (%eax),%eax
8010271c:	83 e0 04             	and    $0x4,%eax
8010271f:	85 c0                	test   %eax,%eax
80102721:	74 34                	je     80102757 <idestart+0x146>
    outb(0x1f7, IDE_CMD_WRITE);
80102723:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
8010272a:	00 
8010272b:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102732:	e8 b2 fd ff ff       	call   801024e9 <outb>
    outsl(0x1f0, b->data, BSIZE/4);
80102737:	8b 45 08             	mov    0x8(%ebp),%eax
8010273a:	83 c0 18             	add    $0x18,%eax
8010273d:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80102744:	00 
80102745:	89 44 24 04          	mov    %eax,0x4(%esp)
80102749:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
80102750:	e8 b0 fd ff ff       	call   80102505 <outsl>
80102755:	eb 14                	jmp    8010276b <idestart+0x15a>
  } else {
    outb(0x1f7, IDE_CMD_READ);
80102757:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
8010275e:	00 
8010275f:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102766:	e8 7e fd ff ff       	call   801024e9 <outb>
  }
}
8010276b:	c9                   	leave  
8010276c:	c3                   	ret    

8010276d <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
8010276d:	55                   	push   %ebp
8010276e:	89 e5                	mov    %esp,%ebp
80102770:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102773:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
8010277a:	e8 e0 27 00 00       	call   80104f5f <acquire>
  if((b = idequeue) == 0){
8010277f:	a1 54 c6 10 80       	mov    0x8010c654,%eax
80102784:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102787:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010278b:	75 11                	jne    8010279e <ideintr+0x31>
    release(&idelock);
8010278d:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
80102794:	e8 28 28 00 00       	call   80104fc1 <release>
    // cprintf("spurious IDE interrupt\n");
    return;
80102799:	e9 90 00 00 00       	jmp    8010282e <ideintr+0xc1>
  }
  idequeue = b->qnext;
8010279e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027a1:	8b 40 14             	mov    0x14(%eax),%eax
801027a4:	a3 54 c6 10 80       	mov    %eax,0x8010c654

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801027a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027ac:	8b 00                	mov    (%eax),%eax
801027ae:	83 e0 04             	and    $0x4,%eax
801027b1:	85 c0                	test   %eax,%eax
801027b3:	75 2e                	jne    801027e3 <ideintr+0x76>
801027b5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801027bc:	e8 69 fd ff ff       	call   8010252a <idewait>
801027c1:	85 c0                	test   %eax,%eax
801027c3:	78 1e                	js     801027e3 <ideintr+0x76>
    insl(0x1f0, b->data, BSIZE/4);
801027c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027c8:	83 c0 18             	add    $0x18,%eax
801027cb:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801027d2:	00 
801027d3:	89 44 24 04          	mov    %eax,0x4(%esp)
801027d7:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
801027de:	e8 e1 fc ff ff       	call   801024c4 <insl>
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
801027e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027e6:	8b 00                	mov    (%eax),%eax
801027e8:	89 c2                	mov    %eax,%edx
801027ea:	83 ca 02             	or     $0x2,%edx
801027ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027f0:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
801027f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027f5:	8b 00                	mov    (%eax),%eax
801027f7:	89 c2                	mov    %eax,%edx
801027f9:	83 e2 fb             	and    $0xfffffffb,%edx
801027fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027ff:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102801:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102804:	89 04 24             	mov    %eax,(%esp)
80102807:	e8 4a 25 00 00       	call   80104d56 <wakeup>
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
8010280c:	a1 54 c6 10 80       	mov    0x8010c654,%eax
80102811:	85 c0                	test   %eax,%eax
80102813:	74 0d                	je     80102822 <ideintr+0xb5>
    idestart(idequeue);
80102815:	a1 54 c6 10 80       	mov    0x8010c654,%eax
8010281a:	89 04 24             	mov    %eax,(%esp)
8010281d:	e8 ef fd ff ff       	call   80102611 <idestart>

  release(&idelock);
80102822:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
80102829:	e8 93 27 00 00       	call   80104fc1 <release>
}
8010282e:	c9                   	leave  
8010282f:	c3                   	ret    

80102830 <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102830:	55                   	push   %ebp
80102831:	89 e5                	mov    %esp,%ebp
80102833:	83 ec 28             	sub    $0x28,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
80102836:	8b 45 08             	mov    0x8(%ebp),%eax
80102839:	8b 00                	mov    (%eax),%eax
8010283b:	83 e0 01             	and    $0x1,%eax
8010283e:	85 c0                	test   %eax,%eax
80102840:	75 0c                	jne    8010284e <iderw+0x1e>
    panic("iderw: buf not busy");
80102842:	c7 04 24 59 8a 10 80 	movl   $0x80108a59,(%esp)
80102849:	e8 e8 dc ff ff       	call   80100536 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010284e:	8b 45 08             	mov    0x8(%ebp),%eax
80102851:	8b 00                	mov    (%eax),%eax
80102853:	83 e0 06             	and    $0x6,%eax
80102856:	83 f8 02             	cmp    $0x2,%eax
80102859:	75 0c                	jne    80102867 <iderw+0x37>
    panic("iderw: nothing to do");
8010285b:	c7 04 24 6d 8a 10 80 	movl   $0x80108a6d,(%esp)
80102862:	e8 cf dc ff ff       	call   80100536 <panic>
  if(b->dev != 0 && !havedisk1)
80102867:	8b 45 08             	mov    0x8(%ebp),%eax
8010286a:	8b 40 04             	mov    0x4(%eax),%eax
8010286d:	85 c0                	test   %eax,%eax
8010286f:	74 15                	je     80102886 <iderw+0x56>
80102871:	a1 58 c6 10 80       	mov    0x8010c658,%eax
80102876:	85 c0                	test   %eax,%eax
80102878:	75 0c                	jne    80102886 <iderw+0x56>
    panic("iderw: ide disk 1 not present");
8010287a:	c7 04 24 82 8a 10 80 	movl   $0x80108a82,(%esp)
80102881:	e8 b0 dc ff ff       	call   80100536 <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102886:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
8010288d:	e8 cd 26 00 00       	call   80104f5f <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80102892:	8b 45 08             	mov    0x8(%ebp),%eax
80102895:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010289c:	c7 45 f4 54 c6 10 80 	movl   $0x8010c654,-0xc(%ebp)
801028a3:	eb 0b                	jmp    801028b0 <iderw+0x80>
801028a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028a8:	8b 00                	mov    (%eax),%eax
801028aa:	83 c0 14             	add    $0x14,%eax
801028ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
801028b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028b3:	8b 00                	mov    (%eax),%eax
801028b5:	85 c0                	test   %eax,%eax
801028b7:	75 ec                	jne    801028a5 <iderw+0x75>
    ;
  *pp = b;
801028b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028bc:	8b 55 08             	mov    0x8(%ebp),%edx
801028bf:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
801028c1:	a1 54 c6 10 80       	mov    0x8010c654,%eax
801028c6:	3b 45 08             	cmp    0x8(%ebp),%eax
801028c9:	75 22                	jne    801028ed <iderw+0xbd>
    idestart(b);
801028cb:	8b 45 08             	mov    0x8(%ebp),%eax
801028ce:	89 04 24             	mov    %eax,(%esp)
801028d1:	e8 3b fd ff ff       	call   80102611 <idestart>
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801028d6:	eb 15                	jmp    801028ed <iderw+0xbd>
    sleep(b, &idelock);
801028d8:	c7 44 24 04 20 c6 10 	movl   $0x8010c620,0x4(%esp)
801028df:	80 
801028e0:	8b 45 08             	mov    0x8(%ebp),%eax
801028e3:	89 04 24             	mov    %eax,(%esp)
801028e6:	e8 8f 23 00 00       	call   80104c7a <sleep>
801028eb:	eb 01                	jmp    801028ee <iderw+0xbe>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801028ed:	90                   	nop
801028ee:	8b 45 08             	mov    0x8(%ebp),%eax
801028f1:	8b 00                	mov    (%eax),%eax
801028f3:	83 e0 06             	and    $0x6,%eax
801028f6:	83 f8 02             	cmp    $0x2,%eax
801028f9:	75 dd                	jne    801028d8 <iderw+0xa8>
    sleep(b, &idelock);
  }

  release(&idelock);
801028fb:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
80102902:	e8 ba 26 00 00       	call   80104fc1 <release>
}
80102907:	c9                   	leave  
80102908:	c3                   	ret    
80102909:	66 90                	xchg   %ax,%ax
8010290b:	90                   	nop

8010290c <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
8010290c:	55                   	push   %ebp
8010290d:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
8010290f:	a1 34 32 11 80       	mov    0x80113234,%eax
80102914:	8b 55 08             	mov    0x8(%ebp),%edx
80102917:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102919:	a1 34 32 11 80       	mov    0x80113234,%eax
8010291e:	8b 40 10             	mov    0x10(%eax),%eax
}
80102921:	5d                   	pop    %ebp
80102922:	c3                   	ret    

80102923 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102923:	55                   	push   %ebp
80102924:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102926:	a1 34 32 11 80       	mov    0x80113234,%eax
8010292b:	8b 55 08             	mov    0x8(%ebp),%edx
8010292e:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102930:	a1 34 32 11 80       	mov    0x80113234,%eax
80102935:	8b 55 0c             	mov    0xc(%ebp),%edx
80102938:	89 50 10             	mov    %edx,0x10(%eax)
}
8010293b:	5d                   	pop    %ebp
8010293c:	c3                   	ret    

8010293d <ioapicinit>:

void
ioapicinit(void)
{
8010293d:	55                   	push   %ebp
8010293e:	89 e5                	mov    %esp,%ebp
80102940:	83 ec 28             	sub    $0x28,%esp
  int i, id, maxintr;

  if(!ismp)
80102943:	a1 64 33 11 80       	mov    0x80113364,%eax
80102948:	85 c0                	test   %eax,%eax
8010294a:	0f 84 9a 00 00 00    	je     801029ea <ioapicinit+0xad>
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102950:	c7 05 34 32 11 80 00 	movl   $0xfec00000,0x80113234
80102957:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010295a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102961:	e8 a6 ff ff ff       	call   8010290c <ioapicread>
80102966:	c1 e8 10             	shr    $0x10,%eax
80102969:	25 ff 00 00 00       	and    $0xff,%eax
8010296e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102971:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80102978:	e8 8f ff ff ff       	call   8010290c <ioapicread>
8010297d:	c1 e8 18             	shr    $0x18,%eax
80102980:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102983:	a0 60 33 11 80       	mov    0x80113360,%al
80102988:	0f b6 c0             	movzbl %al,%eax
8010298b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010298e:	74 0c                	je     8010299c <ioapicinit+0x5f>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102990:	c7 04 24 a0 8a 10 80 	movl   $0x80108aa0,(%esp)
80102997:	e8 05 da ff ff       	call   801003a1 <cprintf>

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010299c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801029a3:	eb 3b                	jmp    801029e0 <ioapicinit+0xa3>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801029a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029a8:	83 c0 20             	add    $0x20,%eax
801029ab:	0d 00 00 01 00       	or     $0x10000,%eax
801029b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801029b3:	83 c2 08             	add    $0x8,%edx
801029b6:	d1 e2                	shl    %edx
801029b8:	89 44 24 04          	mov    %eax,0x4(%esp)
801029bc:	89 14 24             	mov    %edx,(%esp)
801029bf:	e8 5f ff ff ff       	call   80102923 <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
801029c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029c7:	83 c0 08             	add    $0x8,%eax
801029ca:	d1 e0                	shl    %eax
801029cc:	40                   	inc    %eax
801029cd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801029d4:	00 
801029d5:	89 04 24             	mov    %eax,(%esp)
801029d8:	e8 46 ff ff ff       	call   80102923 <ioapicwrite>
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801029dd:	ff 45 f4             	incl   -0xc(%ebp)
801029e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029e3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801029e6:	7e bd                	jle    801029a5 <ioapicinit+0x68>
801029e8:	eb 01                	jmp    801029eb <ioapicinit+0xae>
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
    return;
801029ea:	90                   	nop
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801029eb:	c9                   	leave  
801029ec:	c3                   	ret    

801029ed <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801029ed:	55                   	push   %ebp
801029ee:	89 e5                	mov    %esp,%ebp
801029f0:	83 ec 08             	sub    $0x8,%esp
  if(!ismp)
801029f3:	a1 64 33 11 80       	mov    0x80113364,%eax
801029f8:	85 c0                	test   %eax,%eax
801029fa:	74 37                	je     80102a33 <ioapicenable+0x46>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801029fc:	8b 45 08             	mov    0x8(%ebp),%eax
801029ff:	83 c0 20             	add    $0x20,%eax
80102a02:	8b 55 08             	mov    0x8(%ebp),%edx
80102a05:	83 c2 08             	add    $0x8,%edx
80102a08:	d1 e2                	shl    %edx
80102a0a:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a0e:	89 14 24             	mov    %edx,(%esp)
80102a11:	e8 0d ff ff ff       	call   80102923 <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102a16:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a19:	c1 e0 18             	shl    $0x18,%eax
80102a1c:	8b 55 08             	mov    0x8(%ebp),%edx
80102a1f:	83 c2 08             	add    $0x8,%edx
80102a22:	d1 e2                	shl    %edx
80102a24:	42                   	inc    %edx
80102a25:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a29:	89 14 24             	mov    %edx,(%esp)
80102a2c:	e8 f2 fe ff ff       	call   80102923 <ioapicwrite>
80102a31:	eb 01                	jmp    80102a34 <ioapicenable+0x47>

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
    return;
80102a33:	90                   	nop
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80102a34:	c9                   	leave  
80102a35:	c3                   	ret    
80102a36:	66 90                	xchg   %ax,%ax

80102a38 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80102a38:	55                   	push   %ebp
80102a39:	89 e5                	mov    %esp,%ebp
80102a3b:	8b 45 08             	mov    0x8(%ebp),%eax
80102a3e:	05 00 00 00 80       	add    $0x80000000,%eax
80102a43:	5d                   	pop    %ebp
80102a44:	c3                   	ret    

80102a45 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102a45:	55                   	push   %ebp
80102a46:	89 e5                	mov    %esp,%ebp
80102a48:	83 ec 18             	sub    $0x18,%esp
  initlock(&kmem.lock, "kmem");
80102a4b:	c7 44 24 04 d2 8a 10 	movl   $0x80108ad2,0x4(%esp)
80102a52:	80 
80102a53:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
80102a5a:	e8 df 24 00 00       	call   80104f3e <initlock>
  kmem.use_lock = 0;
80102a5f:	c7 05 74 32 11 80 00 	movl   $0x0,0x80113274
80102a66:	00 00 00 
  freerange(vstart, vend);
80102a69:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a6c:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a70:	8b 45 08             	mov    0x8(%ebp),%eax
80102a73:	89 04 24             	mov    %eax,(%esp)
80102a76:	e8 26 00 00 00       	call   80102aa1 <freerange>
}
80102a7b:	c9                   	leave  
80102a7c:	c3                   	ret    

80102a7d <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102a7d:	55                   	push   %ebp
80102a7e:	89 e5                	mov    %esp,%ebp
80102a80:	83 ec 18             	sub    $0x18,%esp
  freerange(vstart, vend);
80102a83:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a86:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a8a:	8b 45 08             	mov    0x8(%ebp),%eax
80102a8d:	89 04 24             	mov    %eax,(%esp)
80102a90:	e8 0c 00 00 00       	call   80102aa1 <freerange>
  kmem.use_lock = 1;
80102a95:	c7 05 74 32 11 80 01 	movl   $0x1,0x80113274
80102a9c:	00 00 00 
}
80102a9f:	c9                   	leave  
80102aa0:	c3                   	ret    

80102aa1 <freerange>:

void
freerange(void *vstart, void *vend)
{
80102aa1:	55                   	push   %ebp
80102aa2:	89 e5                	mov    %esp,%ebp
80102aa4:	83 ec 28             	sub    $0x28,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102aa7:	8b 45 08             	mov    0x8(%ebp),%eax
80102aaa:	05 ff 0f 00 00       	add    $0xfff,%eax
80102aaf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102ab4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ab7:	eb 12                	jmp    80102acb <freerange+0x2a>
    kfree(p);
80102ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102abc:	89 04 24             	mov    %eax,(%esp)
80102abf:	e8 16 00 00 00       	call   80102ada <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ac4:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ace:	05 00 10 00 00       	add    $0x1000,%eax
80102ad3:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102ad6:	76 e1                	jbe    80102ab9 <freerange+0x18>
    kfree(p);
}
80102ad8:	c9                   	leave  
80102ad9:	c3                   	ret    

80102ada <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102ada:	55                   	push   %ebp
80102adb:	89 e5                	mov    %esp,%ebp
80102add:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102ae0:	8b 45 08             	mov    0x8(%ebp),%eax
80102ae3:	25 ff 0f 00 00       	and    $0xfff,%eax
80102ae8:	85 c0                	test   %eax,%eax
80102aea:	75 1b                	jne    80102b07 <kfree+0x2d>
80102aec:	81 7d 08 5c 84 11 80 	cmpl   $0x8011845c,0x8(%ebp)
80102af3:	72 12                	jb     80102b07 <kfree+0x2d>
80102af5:	8b 45 08             	mov    0x8(%ebp),%eax
80102af8:	89 04 24             	mov    %eax,(%esp)
80102afb:	e8 38 ff ff ff       	call   80102a38 <v2p>
80102b00:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102b05:	76 0c                	jbe    80102b13 <kfree+0x39>
    panic("kfree");
80102b07:	c7 04 24 d7 8a 10 80 	movl   $0x80108ad7,(%esp)
80102b0e:	e8 23 da ff ff       	call   80100536 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102b13:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80102b1a:	00 
80102b1b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102b22:	00 
80102b23:	8b 45 08             	mov    0x8(%ebp),%eax
80102b26:	89 04 24             	mov    %eax,(%esp)
80102b29:	e8 84 26 00 00       	call   801051b2 <memset>

  if(kmem.use_lock)
80102b2e:	a1 74 32 11 80       	mov    0x80113274,%eax
80102b33:	85 c0                	test   %eax,%eax
80102b35:	74 0c                	je     80102b43 <kfree+0x69>
    acquire(&kmem.lock);
80102b37:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
80102b3e:	e8 1c 24 00 00       	call   80104f5f <acquire>
  r = (struct run*)v;
80102b43:	8b 45 08             	mov    0x8(%ebp),%eax
80102b46:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102b49:	8b 15 78 32 11 80    	mov    0x80113278,%edx
80102b4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b52:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102b54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b57:	a3 78 32 11 80       	mov    %eax,0x80113278
  if(kmem.use_lock)
80102b5c:	a1 74 32 11 80       	mov    0x80113274,%eax
80102b61:	85 c0                	test   %eax,%eax
80102b63:	74 0c                	je     80102b71 <kfree+0x97>
    release(&kmem.lock);
80102b65:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
80102b6c:	e8 50 24 00 00       	call   80104fc1 <release>
}
80102b71:	c9                   	leave  
80102b72:	c3                   	ret    

80102b73 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102b73:	55                   	push   %ebp
80102b74:	89 e5                	mov    %esp,%ebp
80102b76:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if(kmem.use_lock)
80102b79:	a1 74 32 11 80       	mov    0x80113274,%eax
80102b7e:	85 c0                	test   %eax,%eax
80102b80:	74 0c                	je     80102b8e <kalloc+0x1b>
    acquire(&kmem.lock);
80102b82:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
80102b89:	e8 d1 23 00 00       	call   80104f5f <acquire>
  r = kmem.freelist;
80102b8e:	a1 78 32 11 80       	mov    0x80113278,%eax
80102b93:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102b96:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102b9a:	74 0a                	je     80102ba6 <kalloc+0x33>
    kmem.freelist = r->next;
80102b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b9f:	8b 00                	mov    (%eax),%eax
80102ba1:	a3 78 32 11 80       	mov    %eax,0x80113278
  if(kmem.use_lock)
80102ba6:	a1 74 32 11 80       	mov    0x80113274,%eax
80102bab:	85 c0                	test   %eax,%eax
80102bad:	74 0c                	je     80102bbb <kalloc+0x48>
    release(&kmem.lock);
80102baf:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
80102bb6:	e8 06 24 00 00       	call   80104fc1 <release>
  return (char*)r;
80102bbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102bbe:	c9                   	leave  
80102bbf:	c3                   	ret    

80102bc0 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102bc0:	55                   	push   %ebp
80102bc1:	89 e5                	mov    %esp,%ebp
80102bc3:	53                   	push   %ebx
80102bc4:	83 ec 14             	sub    $0x14,%esp
80102bc7:	8b 45 08             	mov    0x8(%ebp),%eax
80102bca:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bce:	8b 55 e8             	mov    -0x18(%ebp),%edx
80102bd1:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
80102bd5:	66 8b 55 ea          	mov    -0x16(%ebp),%dx
80102bd9:	ec                   	in     (%dx),%al
80102bda:	88 c3                	mov    %al,%bl
80102bdc:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
80102bdf:	8a 45 fb             	mov    -0x5(%ebp),%al
}
80102be2:	83 c4 14             	add    $0x14,%esp
80102be5:	5b                   	pop    %ebx
80102be6:	5d                   	pop    %ebp
80102be7:	c3                   	ret    

80102be8 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102be8:	55                   	push   %ebp
80102be9:	89 e5                	mov    %esp,%ebp
80102beb:	83 ec 14             	sub    $0x14,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102bee:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102bf5:	e8 c6 ff ff ff       	call   80102bc0 <inb>
80102bfa:	0f b6 c0             	movzbl %al,%eax
80102bfd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102c00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c03:	83 e0 01             	and    $0x1,%eax
80102c06:	85 c0                	test   %eax,%eax
80102c08:	75 0a                	jne    80102c14 <kbdgetc+0x2c>
    return -1;
80102c0a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102c0f:	e9 21 01 00 00       	jmp    80102d35 <kbdgetc+0x14d>
  data = inb(KBDATAP);
80102c14:	c7 04 24 60 00 00 00 	movl   $0x60,(%esp)
80102c1b:	e8 a0 ff ff ff       	call   80102bc0 <inb>
80102c20:	0f b6 c0             	movzbl %al,%eax
80102c23:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102c26:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102c2d:	75 17                	jne    80102c46 <kbdgetc+0x5e>
    shift |= E0ESC;
80102c2f:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c34:	83 c8 40             	or     $0x40,%eax
80102c37:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
    return 0;
80102c3c:	b8 00 00 00 00       	mov    $0x0,%eax
80102c41:	e9 ef 00 00 00       	jmp    80102d35 <kbdgetc+0x14d>
  } else if(data & 0x80){
80102c46:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c49:	25 80 00 00 00       	and    $0x80,%eax
80102c4e:	85 c0                	test   %eax,%eax
80102c50:	74 44                	je     80102c96 <kbdgetc+0xae>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102c52:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c57:	83 e0 40             	and    $0x40,%eax
80102c5a:	85 c0                	test   %eax,%eax
80102c5c:	75 08                	jne    80102c66 <kbdgetc+0x7e>
80102c5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c61:	83 e0 7f             	and    $0x7f,%eax
80102c64:	eb 03                	jmp    80102c69 <kbdgetc+0x81>
80102c66:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c69:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102c6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c6f:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102c74:	8a 00                	mov    (%eax),%al
80102c76:	83 c8 40             	or     $0x40,%eax
80102c79:	0f b6 c0             	movzbl %al,%eax
80102c7c:	f7 d0                	not    %eax
80102c7e:	89 c2                	mov    %eax,%edx
80102c80:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c85:	21 d0                	and    %edx,%eax
80102c87:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
    return 0;
80102c8c:	b8 00 00 00 00       	mov    $0x0,%eax
80102c91:	e9 9f 00 00 00       	jmp    80102d35 <kbdgetc+0x14d>
  } else if(shift & E0ESC){
80102c96:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c9b:	83 e0 40             	and    $0x40,%eax
80102c9e:	85 c0                	test   %eax,%eax
80102ca0:	74 14                	je     80102cb6 <kbdgetc+0xce>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102ca2:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102ca9:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102cae:	83 e0 bf             	and    $0xffffffbf,%eax
80102cb1:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  }

  shift |= shiftcode[data];
80102cb6:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cb9:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102cbe:	8a 00                	mov    (%eax),%al
80102cc0:	0f b6 d0             	movzbl %al,%edx
80102cc3:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102cc8:	09 d0                	or     %edx,%eax
80102cca:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  shift ^= togglecode[data];
80102ccf:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cd2:	05 20 a1 10 80       	add    $0x8010a120,%eax
80102cd7:	8a 00                	mov    (%eax),%al
80102cd9:	0f b6 d0             	movzbl %al,%edx
80102cdc:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102ce1:	31 d0                	xor    %edx,%eax
80102ce3:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  c = charcode[shift & (CTL | SHIFT)][data];
80102ce8:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102ced:	83 e0 03             	and    $0x3,%eax
80102cf0:	8b 14 85 20 a5 10 80 	mov    -0x7fef5ae0(,%eax,4),%edx
80102cf7:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cfa:	01 d0                	add    %edx,%eax
80102cfc:	8a 00                	mov    (%eax),%al
80102cfe:	0f b6 c0             	movzbl %al,%eax
80102d01:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102d04:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102d09:	83 e0 08             	and    $0x8,%eax
80102d0c:	85 c0                	test   %eax,%eax
80102d0e:	74 22                	je     80102d32 <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
80102d10:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102d14:	76 0c                	jbe    80102d22 <kbdgetc+0x13a>
80102d16:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102d1a:	77 06                	ja     80102d22 <kbdgetc+0x13a>
      c += 'A' - 'a';
80102d1c:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102d20:	eb 10                	jmp    80102d32 <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
80102d22:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102d26:	76 0a                	jbe    80102d32 <kbdgetc+0x14a>
80102d28:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102d2c:	77 04                	ja     80102d32 <kbdgetc+0x14a>
      c += 'a' - 'A';
80102d2e:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102d32:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102d35:	c9                   	leave  
80102d36:	c3                   	ret    

80102d37 <kbdintr>:

void
kbdintr(void)
{
80102d37:	55                   	push   %ebp
80102d38:	89 e5                	mov    %esp,%ebp
80102d3a:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
80102d3d:	c7 04 24 e8 2b 10 80 	movl   $0x80102be8,(%esp)
80102d44:	e8 62 da ff ff       	call   801007ab <consoleintr>
}
80102d49:	c9                   	leave  
80102d4a:	c3                   	ret    
80102d4b:	90                   	nop

80102d4c <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102d4c:	55                   	push   %ebp
80102d4d:	89 e5                	mov    %esp,%ebp
80102d4f:	53                   	push   %ebx
80102d50:	83 ec 14             	sub    $0x14,%esp
80102d53:	8b 45 08             	mov    0x8(%ebp),%eax
80102d56:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d5a:	8b 55 e8             	mov    -0x18(%ebp),%edx
80102d5d:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
80102d61:	66 8b 55 ea          	mov    -0x16(%ebp),%dx
80102d65:	ec                   	in     (%dx),%al
80102d66:	88 c3                	mov    %al,%bl
80102d68:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
80102d6b:	8a 45 fb             	mov    -0x5(%ebp),%al
}
80102d6e:	83 c4 14             	add    $0x14,%esp
80102d71:	5b                   	pop    %ebx
80102d72:	5d                   	pop    %ebp
80102d73:	c3                   	ret    

80102d74 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102d74:	55                   	push   %ebp
80102d75:	89 e5                	mov    %esp,%ebp
80102d77:	83 ec 08             	sub    $0x8,%esp
80102d7a:	8b 45 08             	mov    0x8(%ebp),%eax
80102d7d:	8b 55 0c             	mov    0xc(%ebp),%edx
80102d80:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80102d84:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d87:	8a 45 f8             	mov    -0x8(%ebp),%al
80102d8a:	8b 55 fc             	mov    -0x4(%ebp),%edx
80102d8d:	ee                   	out    %al,(%dx)
}
80102d8e:	c9                   	leave  
80102d8f:	c3                   	ret    

80102d90 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80102d90:	55                   	push   %ebp
80102d91:	89 e5                	mov    %esp,%ebp
80102d93:	53                   	push   %ebx
80102d94:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102d97:	9c                   	pushf  
80102d98:	5b                   	pop    %ebx
80102d99:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return eflags;
80102d9c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102d9f:	83 c4 10             	add    $0x10,%esp
80102da2:	5b                   	pop    %ebx
80102da3:	5d                   	pop    %ebp
80102da4:	c3                   	ret    

80102da5 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102da5:	55                   	push   %ebp
80102da6:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102da8:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102dad:	8b 55 08             	mov    0x8(%ebp),%edx
80102db0:	c1 e2 02             	shl    $0x2,%edx
80102db3:	01 c2                	add    %eax,%edx
80102db5:	8b 45 0c             	mov    0xc(%ebp),%eax
80102db8:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102dba:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102dbf:	83 c0 20             	add    $0x20,%eax
80102dc2:	8b 00                	mov    (%eax),%eax
}
80102dc4:	5d                   	pop    %ebp
80102dc5:	c3                   	ret    

80102dc6 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
80102dc6:	55                   	push   %ebp
80102dc7:	89 e5                	mov    %esp,%ebp
80102dc9:	83 ec 08             	sub    $0x8,%esp
  if(!lapic) 
80102dcc:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102dd1:	85 c0                	test   %eax,%eax
80102dd3:	0f 84 47 01 00 00    	je     80102f20 <lapicinit+0x15a>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102dd9:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
80102de0:	00 
80102de1:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
80102de8:	e8 b8 ff ff ff       	call   80102da5 <lapicw>

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102ded:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
80102df4:	00 
80102df5:	c7 04 24 f8 00 00 00 	movl   $0xf8,(%esp)
80102dfc:	e8 a4 ff ff ff       	call   80102da5 <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102e01:	c7 44 24 04 20 00 02 	movl   $0x20020,0x4(%esp)
80102e08:	00 
80102e09:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102e10:	e8 90 ff ff ff       	call   80102da5 <lapicw>
  lapicw(TICR, 10000000); 
80102e15:	c7 44 24 04 80 96 98 	movl   $0x989680,0x4(%esp)
80102e1c:	00 
80102e1d:	c7 04 24 e0 00 00 00 	movl   $0xe0,(%esp)
80102e24:	e8 7c ff ff ff       	call   80102da5 <lapicw>

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102e29:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102e30:	00 
80102e31:	c7 04 24 d4 00 00 00 	movl   $0xd4,(%esp)
80102e38:	e8 68 ff ff ff       	call   80102da5 <lapicw>
  lapicw(LINT1, MASKED);
80102e3d:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102e44:	00 
80102e45:	c7 04 24 d8 00 00 00 	movl   $0xd8,(%esp)
80102e4c:	e8 54 ff ff ff       	call   80102da5 <lapicw>

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102e51:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102e56:	83 c0 30             	add    $0x30,%eax
80102e59:	8b 00                	mov    (%eax),%eax
80102e5b:	c1 e8 10             	shr    $0x10,%eax
80102e5e:	25 ff 00 00 00       	and    $0xff,%eax
80102e63:	83 f8 03             	cmp    $0x3,%eax
80102e66:	76 14                	jbe    80102e7c <lapicinit+0xb6>
    lapicw(PCINT, MASKED);
80102e68:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102e6f:	00 
80102e70:	c7 04 24 d0 00 00 00 	movl   $0xd0,(%esp)
80102e77:	e8 29 ff ff ff       	call   80102da5 <lapicw>

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102e7c:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
80102e83:	00 
80102e84:	c7 04 24 dc 00 00 00 	movl   $0xdc,(%esp)
80102e8b:	e8 15 ff ff ff       	call   80102da5 <lapicw>

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102e90:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e97:	00 
80102e98:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102e9f:	e8 01 ff ff ff       	call   80102da5 <lapicw>
  lapicw(ESR, 0);
80102ea4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102eab:	00 
80102eac:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102eb3:	e8 ed fe ff ff       	call   80102da5 <lapicw>

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102eb8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102ebf:	00 
80102ec0:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102ec7:	e8 d9 fe ff ff       	call   80102da5 <lapicw>

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102ecc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102ed3:	00 
80102ed4:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102edb:	e8 c5 fe ff ff       	call   80102da5 <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102ee0:	c7 44 24 04 00 85 08 	movl   $0x88500,0x4(%esp)
80102ee7:	00 
80102ee8:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102eef:	e8 b1 fe ff ff       	call   80102da5 <lapicw>
  while(lapic[ICRLO] & DELIVS)
80102ef4:	90                   	nop
80102ef5:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102efa:	05 00 03 00 00       	add    $0x300,%eax
80102eff:	8b 00                	mov    (%eax),%eax
80102f01:	25 00 10 00 00       	and    $0x1000,%eax
80102f06:	85 c0                	test   %eax,%eax
80102f08:	75 eb                	jne    80102ef5 <lapicinit+0x12f>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102f0a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102f11:	00 
80102f12:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80102f19:	e8 87 fe ff ff       	call   80102da5 <lapicw>
80102f1e:	eb 01                	jmp    80102f21 <lapicinit+0x15b>

void
lapicinit(void)
{
  if(!lapic) 
    return;
80102f20:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102f21:	c9                   	leave  
80102f22:	c3                   	ret    

80102f23 <cpunum>:

int
cpunum(void)
{
80102f23:	55                   	push   %ebp
80102f24:	89 e5                	mov    %esp,%ebp
80102f26:	83 ec 18             	sub    $0x18,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80102f29:	e8 62 fe ff ff       	call   80102d90 <readeflags>
80102f2e:	25 00 02 00 00       	and    $0x200,%eax
80102f33:	85 c0                	test   %eax,%eax
80102f35:	74 27                	je     80102f5e <cpunum+0x3b>
    static int n;
    if(n++ == 0)
80102f37:	a1 60 c6 10 80       	mov    0x8010c660,%eax
80102f3c:	85 c0                	test   %eax,%eax
80102f3e:	0f 94 c2             	sete   %dl
80102f41:	40                   	inc    %eax
80102f42:	a3 60 c6 10 80       	mov    %eax,0x8010c660
80102f47:	84 d2                	test   %dl,%dl
80102f49:	74 13                	je     80102f5e <cpunum+0x3b>
      cprintf("cpu called from %x with interrupts enabled\n",
80102f4b:	8b 45 04             	mov    0x4(%ebp),%eax
80102f4e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102f52:	c7 04 24 e0 8a 10 80 	movl   $0x80108ae0,(%esp)
80102f59:	e8 43 d4 ff ff       	call   801003a1 <cprintf>
        __builtin_return_address(0));
  }

  if(lapic)
80102f5e:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102f63:	85 c0                	test   %eax,%eax
80102f65:	74 0f                	je     80102f76 <cpunum+0x53>
    return lapic[ID]>>24;
80102f67:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102f6c:	83 c0 20             	add    $0x20,%eax
80102f6f:	8b 00                	mov    (%eax),%eax
80102f71:	c1 e8 18             	shr    $0x18,%eax
80102f74:	eb 05                	jmp    80102f7b <cpunum+0x58>
  return 0;
80102f76:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102f7b:	c9                   	leave  
80102f7c:	c3                   	ret    

80102f7d <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102f7d:	55                   	push   %ebp
80102f7e:	89 e5                	mov    %esp,%ebp
80102f80:	83 ec 08             	sub    $0x8,%esp
  if(lapic)
80102f83:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102f88:	85 c0                	test   %eax,%eax
80102f8a:	74 14                	je     80102fa0 <lapiceoi+0x23>
    lapicw(EOI, 0);
80102f8c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102f93:	00 
80102f94:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102f9b:	e8 05 fe ff ff       	call   80102da5 <lapicw>
}
80102fa0:	c9                   	leave  
80102fa1:	c3                   	ret    

80102fa2 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102fa2:	55                   	push   %ebp
80102fa3:	89 e5                	mov    %esp,%ebp
}
80102fa5:	5d                   	pop    %ebp
80102fa6:	c3                   	ret    

80102fa7 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102fa7:	55                   	push   %ebp
80102fa8:	89 e5                	mov    %esp,%ebp
80102faa:	83 ec 1c             	sub    $0x1c,%esp
80102fad:	8b 45 08             	mov    0x8(%ebp),%eax
80102fb0:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
80102fb3:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80102fba:	00 
80102fbb:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
80102fc2:	e8 ad fd ff ff       	call   80102d74 <outb>
  outb(CMOS_PORT+1, 0x0A);
80102fc7:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80102fce:	00 
80102fcf:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
80102fd6:	e8 99 fd ff ff       	call   80102d74 <outb>
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80102fdb:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80102fe2:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102fe5:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80102fea:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102fed:	8d 50 02             	lea    0x2(%eax),%edx
80102ff0:	8b 45 0c             	mov    0xc(%ebp),%eax
80102ff3:	c1 e8 04             	shr    $0x4,%eax
80102ff6:	66 89 02             	mov    %ax,(%edx)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102ff9:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102ffd:	c1 e0 18             	shl    $0x18,%eax
80103000:	89 44 24 04          	mov    %eax,0x4(%esp)
80103004:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
8010300b:	e8 95 fd ff ff       	call   80102da5 <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80103010:	c7 44 24 04 00 c5 00 	movl   $0xc500,0x4(%esp)
80103017:	00 
80103018:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
8010301f:	e8 81 fd ff ff       	call   80102da5 <lapicw>
  microdelay(200);
80103024:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
8010302b:	e8 72 ff ff ff       	call   80102fa2 <microdelay>
  lapicw(ICRLO, INIT | LEVEL);
80103030:	c7 44 24 04 00 85 00 	movl   $0x8500,0x4(%esp)
80103037:	00 
80103038:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
8010303f:	e8 61 fd ff ff       	call   80102da5 <lapicw>
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80103044:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
8010304b:	e8 52 ff ff ff       	call   80102fa2 <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103050:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103057:	eb 3f                	jmp    80103098 <lapicstartap+0xf1>
    lapicw(ICRHI, apicid<<24);
80103059:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
8010305d:	c1 e0 18             	shl    $0x18,%eax
80103060:	89 44 24 04          	mov    %eax,0x4(%esp)
80103064:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
8010306b:	e8 35 fd ff ff       	call   80102da5 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
80103070:	8b 45 0c             	mov    0xc(%ebp),%eax
80103073:	c1 e8 0c             	shr    $0xc,%eax
80103076:	80 cc 06             	or     $0x6,%ah
80103079:	89 44 24 04          	mov    %eax,0x4(%esp)
8010307d:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80103084:	e8 1c fd ff ff       	call   80102da5 <lapicw>
    microdelay(200);
80103089:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80103090:	e8 0d ff ff ff       	call   80102fa2 <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103095:	ff 45 fc             	incl   -0x4(%ebp)
80103098:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
8010309c:	7e bb                	jle    80103059 <lapicstartap+0xb2>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
8010309e:	c9                   	leave  
8010309f:	c3                   	ret    

801030a0 <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
801030a0:	55                   	push   %ebp
801030a1:	89 e5                	mov    %esp,%ebp
801030a3:	83 ec 08             	sub    $0x8,%esp
  outb(CMOS_PORT,  reg);
801030a6:	8b 45 08             	mov    0x8(%ebp),%eax
801030a9:	0f b6 c0             	movzbl %al,%eax
801030ac:	89 44 24 04          	mov    %eax,0x4(%esp)
801030b0:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
801030b7:	e8 b8 fc ff ff       	call   80102d74 <outb>
  microdelay(200);
801030bc:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
801030c3:	e8 da fe ff ff       	call   80102fa2 <microdelay>

  return inb(CMOS_RETURN);
801030c8:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
801030cf:	e8 78 fc ff ff       	call   80102d4c <inb>
801030d4:	0f b6 c0             	movzbl %al,%eax
}
801030d7:	c9                   	leave  
801030d8:	c3                   	ret    

801030d9 <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
801030d9:	55                   	push   %ebp
801030da:	89 e5                	mov    %esp,%ebp
801030dc:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
801030df:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801030e6:	e8 b5 ff ff ff       	call   801030a0 <cmos_read>
801030eb:	8b 55 08             	mov    0x8(%ebp),%edx
801030ee:	89 02                	mov    %eax,(%edx)
  r->minute = cmos_read(MINS);
801030f0:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801030f7:	e8 a4 ff ff ff       	call   801030a0 <cmos_read>
801030fc:	8b 55 08             	mov    0x8(%ebp),%edx
801030ff:	89 42 04             	mov    %eax,0x4(%edx)
  r->hour   = cmos_read(HOURS);
80103102:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80103109:	e8 92 ff ff ff       	call   801030a0 <cmos_read>
8010310e:	8b 55 08             	mov    0x8(%ebp),%edx
80103111:	89 42 08             	mov    %eax,0x8(%edx)
  r->day    = cmos_read(DAY);
80103114:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
8010311b:	e8 80 ff ff ff       	call   801030a0 <cmos_read>
80103120:	8b 55 08             	mov    0x8(%ebp),%edx
80103123:	89 42 0c             	mov    %eax,0xc(%edx)
  r->month  = cmos_read(MONTH);
80103126:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010312d:	e8 6e ff ff ff       	call   801030a0 <cmos_read>
80103132:	8b 55 08             	mov    0x8(%ebp),%edx
80103135:	89 42 10             	mov    %eax,0x10(%edx)
  r->year   = cmos_read(YEAR);
80103138:	c7 04 24 09 00 00 00 	movl   $0x9,(%esp)
8010313f:	e8 5c ff ff ff       	call   801030a0 <cmos_read>
80103144:	8b 55 08             	mov    0x8(%ebp),%edx
80103147:	89 42 14             	mov    %eax,0x14(%edx)
}
8010314a:	c9                   	leave  
8010314b:	c3                   	ret    

8010314c <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
8010314c:	55                   	push   %ebp
8010314d:	89 e5                	mov    %esp,%ebp
8010314f:	57                   	push   %edi
80103150:	56                   	push   %esi
80103151:	53                   	push   %ebx
80103152:	83 ec 5c             	sub    $0x5c,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
80103155:	c7 04 24 0b 00 00 00 	movl   $0xb,(%esp)
8010315c:	e8 3f ff ff ff       	call   801030a0 <cmos_read>
80103161:	89 45 e4             	mov    %eax,-0x1c(%ebp)

  bcd = (sb & (1 << 2)) == 0;
80103164:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103167:	83 e0 04             	and    $0x4,%eax
8010316a:	85 c0                	test   %eax,%eax
8010316c:	0f 94 c0             	sete   %al
8010316f:	0f b6 c0             	movzbl %al,%eax
80103172:	89 45 e0             	mov    %eax,-0x20(%ebp)
80103175:	eb 01                	jmp    80103178 <cmostime+0x2c>
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
80103177:	90                   	nop

  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
80103178:	8d 45 c8             	lea    -0x38(%ebp),%eax
8010317b:	89 04 24             	mov    %eax,(%esp)
8010317e:	e8 56 ff ff ff       	call   801030d9 <fill_rtcdate>
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
80103183:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
8010318a:	e8 11 ff ff ff       	call   801030a0 <cmos_read>
8010318f:	25 80 00 00 00       	and    $0x80,%eax
80103194:	85 c0                	test   %eax,%eax
80103196:	75 2b                	jne    801031c3 <cmostime+0x77>
        continue;
    fill_rtcdate(&t2);
80103198:	8d 45 b0             	lea    -0x50(%ebp),%eax
8010319b:	89 04 24             	mov    %eax,(%esp)
8010319e:	e8 36 ff ff ff       	call   801030d9 <fill_rtcdate>
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
801031a3:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
801031aa:	00 
801031ab:	8d 45 b0             	lea    -0x50(%ebp),%eax
801031ae:	89 44 24 04          	mov    %eax,0x4(%esp)
801031b2:	8d 45 c8             	lea    -0x38(%ebp),%eax
801031b5:	89 04 24             	mov    %eax,(%esp)
801031b8:	e8 6c 20 00 00       	call   80105229 <memcmp>
801031bd:	85 c0                	test   %eax,%eax
801031bf:	75 b6                	jne    80103177 <cmostime+0x2b>
      break;
801031c1:	eb 03                	jmp    801031c6 <cmostime+0x7a>

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
801031c3:	90                   	nop
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
801031c4:	eb b1                	jmp    80103177 <cmostime+0x2b>

  // convert
  if (bcd) {
801031c6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801031ca:	0f 84 a8 00 00 00    	je     80103278 <cmostime+0x12c>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801031d0:	8b 45 c8             	mov    -0x38(%ebp),%eax
801031d3:	89 c2                	mov    %eax,%edx
801031d5:	c1 ea 04             	shr    $0x4,%edx
801031d8:	89 d0                	mov    %edx,%eax
801031da:	c1 e0 02             	shl    $0x2,%eax
801031dd:	01 d0                	add    %edx,%eax
801031df:	d1 e0                	shl    %eax
801031e1:	8b 55 c8             	mov    -0x38(%ebp),%edx
801031e4:	83 e2 0f             	and    $0xf,%edx
801031e7:	01 d0                	add    %edx,%eax
801031e9:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(minute);
801031ec:	8b 45 cc             	mov    -0x34(%ebp),%eax
801031ef:	89 c2                	mov    %eax,%edx
801031f1:	c1 ea 04             	shr    $0x4,%edx
801031f4:	89 d0                	mov    %edx,%eax
801031f6:	c1 e0 02             	shl    $0x2,%eax
801031f9:	01 d0                	add    %edx,%eax
801031fb:	d1 e0                	shl    %eax
801031fd:	8b 55 cc             	mov    -0x34(%ebp),%edx
80103200:	83 e2 0f             	and    $0xf,%edx
80103203:	01 d0                	add    %edx,%eax
80103205:	89 45 cc             	mov    %eax,-0x34(%ebp)
    CONV(hour  );
80103208:	8b 45 d0             	mov    -0x30(%ebp),%eax
8010320b:	89 c2                	mov    %eax,%edx
8010320d:	c1 ea 04             	shr    $0x4,%edx
80103210:	89 d0                	mov    %edx,%eax
80103212:	c1 e0 02             	shl    $0x2,%eax
80103215:	01 d0                	add    %edx,%eax
80103217:	d1 e0                	shl    %eax
80103219:	8b 55 d0             	mov    -0x30(%ebp),%edx
8010321c:	83 e2 0f             	and    $0xf,%edx
8010321f:	01 d0                	add    %edx,%eax
80103221:	89 45 d0             	mov    %eax,-0x30(%ebp)
    CONV(day   );
80103224:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80103227:	89 c2                	mov    %eax,%edx
80103229:	c1 ea 04             	shr    $0x4,%edx
8010322c:	89 d0                	mov    %edx,%eax
8010322e:	c1 e0 02             	shl    $0x2,%eax
80103231:	01 d0                	add    %edx,%eax
80103233:	d1 e0                	shl    %eax
80103235:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80103238:	83 e2 0f             	and    $0xf,%edx
8010323b:	01 d0                	add    %edx,%eax
8010323d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    CONV(month );
80103240:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103243:	89 c2                	mov    %eax,%edx
80103245:	c1 ea 04             	shr    $0x4,%edx
80103248:	89 d0                	mov    %edx,%eax
8010324a:	c1 e0 02             	shl    $0x2,%eax
8010324d:	01 d0                	add    %edx,%eax
8010324f:	d1 e0                	shl    %eax
80103251:	8b 55 d8             	mov    -0x28(%ebp),%edx
80103254:	83 e2 0f             	and    $0xf,%edx
80103257:	01 d0                	add    %edx,%eax
80103259:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(year  );
8010325c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010325f:	89 c2                	mov    %eax,%edx
80103261:	c1 ea 04             	shr    $0x4,%edx
80103264:	89 d0                	mov    %edx,%eax
80103266:	c1 e0 02             	shl    $0x2,%eax
80103269:	01 d0                	add    %edx,%eax
8010326b:	d1 e0                	shl    %eax
8010326d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103270:	83 e2 0f             	and    $0xf,%edx
80103273:	01 d0                	add    %edx,%eax
80103275:	89 45 dc             	mov    %eax,-0x24(%ebp)
#undef     CONV
  }

  *r = t1;
80103278:	8b 45 08             	mov    0x8(%ebp),%eax
8010327b:	89 c2                	mov    %eax,%edx
8010327d:	8d 5d c8             	lea    -0x38(%ebp),%ebx
80103280:	b8 06 00 00 00       	mov    $0x6,%eax
80103285:	89 d7                	mov    %edx,%edi
80103287:	89 de                	mov    %ebx,%esi
80103289:	89 c1                	mov    %eax,%ecx
8010328b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  r->year += 2000;
8010328d:	8b 45 08             	mov    0x8(%ebp),%eax
80103290:	8b 40 14             	mov    0x14(%eax),%eax
80103293:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
80103299:	8b 45 08             	mov    0x8(%ebp),%eax
8010329c:	89 50 14             	mov    %edx,0x14(%eax)
}
8010329f:	83 c4 5c             	add    $0x5c,%esp
801032a2:	5b                   	pop    %ebx
801032a3:	5e                   	pop    %esi
801032a4:	5f                   	pop    %edi
801032a5:	5d                   	pop    %ebp
801032a6:	c3                   	ret    
801032a7:	90                   	nop

801032a8 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
801032a8:	55                   	push   %ebp
801032a9:	89 e5                	mov    %esp,%ebp
801032ab:	83 ec 38             	sub    $0x38,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
801032ae:	c7 44 24 04 0c 8b 10 	movl   $0x80108b0c,0x4(%esp)
801032b5:	80 
801032b6:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
801032bd:	e8 7c 1c 00 00       	call   80104f3e <initlock>
  readsb(dev, &sb);
801032c2:	8d 45 dc             	lea    -0x24(%ebp),%eax
801032c5:	89 44 24 04          	mov    %eax,0x4(%esp)
801032c9:	8b 45 08             	mov    0x8(%ebp),%eax
801032cc:	89 04 24             	mov    %eax,(%esp)
801032cf:	e8 14 e0 ff ff       	call   801012e8 <readsb>
  log.start = sb.logstart;
801032d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801032d7:	a3 b4 32 11 80       	mov    %eax,0x801132b4
  log.size = sb.nlog;
801032dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
801032df:	a3 b8 32 11 80       	mov    %eax,0x801132b8
  log.dev = dev;
801032e4:	8b 45 08             	mov    0x8(%ebp),%eax
801032e7:	a3 c4 32 11 80       	mov    %eax,0x801132c4
  recover_from_log();
801032ec:	e8 95 01 00 00       	call   80103486 <recover_from_log>
}
801032f1:	c9                   	leave  
801032f2:	c3                   	ret    

801032f3 <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
801032f3:	55                   	push   %ebp
801032f4:	89 e5                	mov    %esp,%ebp
801032f6:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801032f9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103300:	e9 89 00 00 00       	jmp    8010338e <install_trans+0x9b>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103305:	8b 15 b4 32 11 80    	mov    0x801132b4,%edx
8010330b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010330e:	01 d0                	add    %edx,%eax
80103310:	40                   	inc    %eax
80103311:	89 c2                	mov    %eax,%edx
80103313:	a1 c4 32 11 80       	mov    0x801132c4,%eax
80103318:	89 54 24 04          	mov    %edx,0x4(%esp)
8010331c:	89 04 24             	mov    %eax,(%esp)
8010331f:	e8 82 ce ff ff       	call   801001a6 <bread>
80103324:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103327:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010332a:	83 c0 10             	add    $0x10,%eax
8010332d:	8b 04 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%eax
80103334:	89 c2                	mov    %eax,%edx
80103336:	a1 c4 32 11 80       	mov    0x801132c4,%eax
8010333b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010333f:	89 04 24             	mov    %eax,(%esp)
80103342:	e8 5f ce ff ff       	call   801001a6 <bread>
80103347:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
8010334a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010334d:	8d 50 18             	lea    0x18(%eax),%edx
80103350:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103353:	83 c0 18             	add    $0x18,%eax
80103356:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
8010335d:	00 
8010335e:	89 54 24 04          	mov    %edx,0x4(%esp)
80103362:	89 04 24             	mov    %eax,(%esp)
80103365:	e8 14 1f 00 00       	call   8010527e <memmove>
    bwrite(dbuf);  // write dst to disk
8010336a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010336d:	89 04 24             	mov    %eax,(%esp)
80103370:	e8 68 ce ff ff       	call   801001dd <bwrite>
    brelse(lbuf); 
80103375:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103378:	89 04 24             	mov    %eax,(%esp)
8010337b:	e8 97 ce ff ff       	call   80100217 <brelse>
    brelse(dbuf);
80103380:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103383:	89 04 24             	mov    %eax,(%esp)
80103386:	e8 8c ce ff ff       	call   80100217 <brelse>
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010338b:	ff 45 f4             	incl   -0xc(%ebp)
8010338e:	a1 c8 32 11 80       	mov    0x801132c8,%eax
80103393:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103396:	0f 8f 69 ff ff ff    	jg     80103305 <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
8010339c:	c9                   	leave  
8010339d:	c3                   	ret    

8010339e <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
8010339e:	55                   	push   %ebp
8010339f:	89 e5                	mov    %esp,%ebp
801033a1:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
801033a4:	a1 b4 32 11 80       	mov    0x801132b4,%eax
801033a9:	89 c2                	mov    %eax,%edx
801033ab:	a1 c4 32 11 80       	mov    0x801132c4,%eax
801033b0:	89 54 24 04          	mov    %edx,0x4(%esp)
801033b4:	89 04 24             	mov    %eax,(%esp)
801033b7:	e8 ea cd ff ff       	call   801001a6 <bread>
801033bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
801033bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801033c2:	83 c0 18             	add    $0x18,%eax
801033c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
801033c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033cb:	8b 00                	mov    (%eax),%eax
801033cd:	a3 c8 32 11 80       	mov    %eax,0x801132c8
  for (i = 0; i < log.lh.n; i++) {
801033d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801033d9:	eb 1a                	jmp    801033f5 <read_head+0x57>
    log.lh.block[i] = lh->block[i];
801033db:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033de:	8b 55 f4             	mov    -0xc(%ebp),%edx
801033e1:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
801033e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801033e8:	83 c2 10             	add    $0x10,%edx
801033eb:	89 04 95 8c 32 11 80 	mov    %eax,-0x7feecd74(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
801033f2:	ff 45 f4             	incl   -0xc(%ebp)
801033f5:	a1 c8 32 11 80       	mov    0x801132c8,%eax
801033fa:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801033fd:	7f dc                	jg     801033db <read_head+0x3d>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
801033ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103402:	89 04 24             	mov    %eax,(%esp)
80103405:	e8 0d ce ff ff       	call   80100217 <brelse>
}
8010340a:	c9                   	leave  
8010340b:	c3                   	ret    

8010340c <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
8010340c:	55                   	push   %ebp
8010340d:	89 e5                	mov    %esp,%ebp
8010340f:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
80103412:	a1 b4 32 11 80       	mov    0x801132b4,%eax
80103417:	89 c2                	mov    %eax,%edx
80103419:	a1 c4 32 11 80       	mov    0x801132c4,%eax
8010341e:	89 54 24 04          	mov    %edx,0x4(%esp)
80103422:	89 04 24             	mov    %eax,(%esp)
80103425:	e8 7c cd ff ff       	call   801001a6 <bread>
8010342a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
8010342d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103430:	83 c0 18             	add    $0x18,%eax
80103433:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
80103436:	8b 15 c8 32 11 80    	mov    0x801132c8,%edx
8010343c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010343f:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
80103441:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103448:	eb 1a                	jmp    80103464 <write_head+0x58>
    hb->block[i] = log.lh.block[i];
8010344a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010344d:	83 c0 10             	add    $0x10,%eax
80103450:	8b 0c 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%ecx
80103457:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010345a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010345d:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103461:	ff 45 f4             	incl   -0xc(%ebp)
80103464:	a1 c8 32 11 80       	mov    0x801132c8,%eax
80103469:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010346c:	7f dc                	jg     8010344a <write_head+0x3e>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
8010346e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103471:	89 04 24             	mov    %eax,(%esp)
80103474:	e8 64 cd ff ff       	call   801001dd <bwrite>
  brelse(buf);
80103479:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010347c:	89 04 24             	mov    %eax,(%esp)
8010347f:	e8 93 cd ff ff       	call   80100217 <brelse>
}
80103484:	c9                   	leave  
80103485:	c3                   	ret    

80103486 <recover_from_log>:

static void
recover_from_log(void)
{
80103486:	55                   	push   %ebp
80103487:	89 e5                	mov    %esp,%ebp
80103489:	83 ec 08             	sub    $0x8,%esp
  read_head();      
8010348c:	e8 0d ff ff ff       	call   8010339e <read_head>
  install_trans(); // if committed, copy from log to disk
80103491:	e8 5d fe ff ff       	call   801032f3 <install_trans>
  log.lh.n = 0;
80103496:	c7 05 c8 32 11 80 00 	movl   $0x0,0x801132c8
8010349d:	00 00 00 
  write_head(); // clear the log
801034a0:	e8 67 ff ff ff       	call   8010340c <write_head>
}
801034a5:	c9                   	leave  
801034a6:	c3                   	ret    

801034a7 <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
801034a7:	55                   	push   %ebp
801034a8:	89 e5                	mov    %esp,%ebp
801034aa:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
801034ad:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
801034b4:	e8 a6 1a 00 00       	call   80104f5f <acquire>
  while(1){
    if(log.committing){
801034b9:	a1 c0 32 11 80       	mov    0x801132c0,%eax
801034be:	85 c0                	test   %eax,%eax
801034c0:	74 16                	je     801034d8 <begin_op+0x31>
      sleep(&log, &log.lock);
801034c2:	c7 44 24 04 80 32 11 	movl   $0x80113280,0x4(%esp)
801034c9:	80 
801034ca:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
801034d1:	e8 a4 17 00 00       	call   80104c7a <sleep>
    } else {
      log.outstanding += 1;
      release(&log.lock);
      break;
    }
  }
801034d6:	eb e1                	jmp    801034b9 <begin_op+0x12>
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801034d8:	8b 15 c8 32 11 80    	mov    0x801132c8,%edx
801034de:	a1 bc 32 11 80       	mov    0x801132bc,%eax
801034e3:	8d 48 01             	lea    0x1(%eax),%ecx
801034e6:	89 c8                	mov    %ecx,%eax
801034e8:	c1 e0 02             	shl    $0x2,%eax
801034eb:	01 c8                	add    %ecx,%eax
801034ed:	d1 e0                	shl    %eax
801034ef:	01 d0                	add    %edx,%eax
801034f1:	83 f8 1e             	cmp    $0x1e,%eax
801034f4:	7e 16                	jle    8010350c <begin_op+0x65>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
801034f6:	c7 44 24 04 80 32 11 	movl   $0x80113280,0x4(%esp)
801034fd:	80 
801034fe:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
80103505:	e8 70 17 00 00       	call   80104c7a <sleep>
    } else {
      log.outstanding += 1;
      release(&log.lock);
      break;
    }
  }
8010350a:	eb ad                	jmp    801034b9 <begin_op+0x12>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
8010350c:	a1 bc 32 11 80       	mov    0x801132bc,%eax
80103511:	40                   	inc    %eax
80103512:	a3 bc 32 11 80       	mov    %eax,0x801132bc
      release(&log.lock);
80103517:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
8010351e:	e8 9e 1a 00 00       	call   80104fc1 <release>
      break;
80103523:	90                   	nop
    }
  }
}
80103524:	c9                   	leave  
80103525:	c3                   	ret    

80103526 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103526:	55                   	push   %ebp
80103527:	89 e5                	mov    %esp,%ebp
80103529:	83 ec 28             	sub    $0x28,%esp
  int do_commit = 0;
8010352c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
80103533:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
8010353a:	e8 20 1a 00 00       	call   80104f5f <acquire>
  log.outstanding -= 1;
8010353f:	a1 bc 32 11 80       	mov    0x801132bc,%eax
80103544:	48                   	dec    %eax
80103545:	a3 bc 32 11 80       	mov    %eax,0x801132bc
  if(log.committing)
8010354a:	a1 c0 32 11 80       	mov    0x801132c0,%eax
8010354f:	85 c0                	test   %eax,%eax
80103551:	74 0c                	je     8010355f <end_op+0x39>
    panic("log.committing");
80103553:	c7 04 24 10 8b 10 80 	movl   $0x80108b10,(%esp)
8010355a:	e8 d7 cf ff ff       	call   80100536 <panic>
  if(log.outstanding == 0){
8010355f:	a1 bc 32 11 80       	mov    0x801132bc,%eax
80103564:	85 c0                	test   %eax,%eax
80103566:	75 13                	jne    8010357b <end_op+0x55>
    do_commit = 1;
80103568:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
8010356f:	c7 05 c0 32 11 80 01 	movl   $0x1,0x801132c0
80103576:	00 00 00 
80103579:	eb 0c                	jmp    80103587 <end_op+0x61>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
8010357b:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
80103582:	e8 cf 17 00 00       	call   80104d56 <wakeup>
  }
  release(&log.lock);
80103587:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
8010358e:	e8 2e 1a 00 00       	call   80104fc1 <release>

  if(do_commit){
80103593:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103597:	74 33                	je     801035cc <end_op+0xa6>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
80103599:	e8 db 00 00 00       	call   80103679 <commit>
    acquire(&log.lock);
8010359e:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
801035a5:	e8 b5 19 00 00       	call   80104f5f <acquire>
    log.committing = 0;
801035aa:	c7 05 c0 32 11 80 00 	movl   $0x0,0x801132c0
801035b1:	00 00 00 
    wakeup(&log);
801035b4:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
801035bb:	e8 96 17 00 00       	call   80104d56 <wakeup>
    release(&log.lock);
801035c0:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
801035c7:	e8 f5 19 00 00       	call   80104fc1 <release>
  }
}
801035cc:	c9                   	leave  
801035cd:	c3                   	ret    

801035ce <write_log>:

// Copy modified blocks from cache to log.
static void 
write_log(void)
{
801035ce:	55                   	push   %ebp
801035cf:	89 e5                	mov    %esp,%ebp
801035d1:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801035d4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801035db:	e9 89 00 00 00       	jmp    80103669 <write_log+0x9b>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801035e0:	8b 15 b4 32 11 80    	mov    0x801132b4,%edx
801035e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801035e9:	01 d0                	add    %edx,%eax
801035eb:	40                   	inc    %eax
801035ec:	89 c2                	mov    %eax,%edx
801035ee:	a1 c4 32 11 80       	mov    0x801132c4,%eax
801035f3:	89 54 24 04          	mov    %edx,0x4(%esp)
801035f7:	89 04 24             	mov    %eax,(%esp)
801035fa:	e8 a7 cb ff ff       	call   801001a6 <bread>
801035ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103602:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103605:	83 c0 10             	add    $0x10,%eax
80103608:	8b 04 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%eax
8010360f:	89 c2                	mov    %eax,%edx
80103611:	a1 c4 32 11 80       	mov    0x801132c4,%eax
80103616:	89 54 24 04          	mov    %edx,0x4(%esp)
8010361a:	89 04 24             	mov    %eax,(%esp)
8010361d:	e8 84 cb ff ff       	call   801001a6 <bread>
80103622:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
80103625:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103628:	8d 50 18             	lea    0x18(%eax),%edx
8010362b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010362e:	83 c0 18             	add    $0x18,%eax
80103631:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80103638:	00 
80103639:	89 54 24 04          	mov    %edx,0x4(%esp)
8010363d:	89 04 24             	mov    %eax,(%esp)
80103640:	e8 39 1c 00 00       	call   8010527e <memmove>
    bwrite(to);  // write the log
80103645:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103648:	89 04 24             	mov    %eax,(%esp)
8010364b:	e8 8d cb ff ff       	call   801001dd <bwrite>
    brelse(from); 
80103650:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103653:	89 04 24             	mov    %eax,(%esp)
80103656:	e8 bc cb ff ff       	call   80100217 <brelse>
    brelse(to);
8010365b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010365e:	89 04 24             	mov    %eax,(%esp)
80103661:	e8 b1 cb ff ff       	call   80100217 <brelse>
static void 
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103666:	ff 45 f4             	incl   -0xc(%ebp)
80103669:	a1 c8 32 11 80       	mov    0x801132c8,%eax
8010366e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103671:	0f 8f 69 ff ff ff    	jg     801035e0 <write_log+0x12>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from); 
    brelse(to);
  }
}
80103677:	c9                   	leave  
80103678:	c3                   	ret    

80103679 <commit>:

static void
commit()
{
80103679:	55                   	push   %ebp
8010367a:	89 e5                	mov    %esp,%ebp
8010367c:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
8010367f:	a1 c8 32 11 80       	mov    0x801132c8,%eax
80103684:	85 c0                	test   %eax,%eax
80103686:	7e 1e                	jle    801036a6 <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
80103688:	e8 41 ff ff ff       	call   801035ce <write_log>
    write_head();    // Write header to disk -- the real commit
8010368d:	e8 7a fd ff ff       	call   8010340c <write_head>
    install_trans(); // Now install writes to home locations
80103692:	e8 5c fc ff ff       	call   801032f3 <install_trans>
    log.lh.n = 0; 
80103697:	c7 05 c8 32 11 80 00 	movl   $0x0,0x801132c8
8010369e:	00 00 00 
    write_head();    // Erase the transaction from the log
801036a1:	e8 66 fd ff ff       	call   8010340c <write_head>
  }
}
801036a6:	c9                   	leave  
801036a7:	c3                   	ret    

801036a8 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801036a8:	55                   	push   %ebp
801036a9:	89 e5                	mov    %esp,%ebp
801036ab:	83 ec 28             	sub    $0x28,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801036ae:	a1 c8 32 11 80       	mov    0x801132c8,%eax
801036b3:	83 f8 1d             	cmp    $0x1d,%eax
801036b6:	7f 10                	jg     801036c8 <log_write+0x20>
801036b8:	a1 c8 32 11 80       	mov    0x801132c8,%eax
801036bd:	8b 15 b8 32 11 80    	mov    0x801132b8,%edx
801036c3:	4a                   	dec    %edx
801036c4:	39 d0                	cmp    %edx,%eax
801036c6:	7c 0c                	jl     801036d4 <log_write+0x2c>
    panic("too big a transaction");
801036c8:	c7 04 24 1f 8b 10 80 	movl   $0x80108b1f,(%esp)
801036cf:	e8 62 ce ff ff       	call   80100536 <panic>
  if (log.outstanding < 1)
801036d4:	a1 bc 32 11 80       	mov    0x801132bc,%eax
801036d9:	85 c0                	test   %eax,%eax
801036db:	7f 0c                	jg     801036e9 <log_write+0x41>
    panic("log_write outside of trans");
801036dd:	c7 04 24 35 8b 10 80 	movl   $0x80108b35,(%esp)
801036e4:	e8 4d ce ff ff       	call   80100536 <panic>

  acquire(&log.lock);
801036e9:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
801036f0:	e8 6a 18 00 00       	call   80104f5f <acquire>
  for (i = 0; i < log.lh.n; i++) {
801036f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801036fc:	eb 1c                	jmp    8010371a <log_write+0x72>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801036fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103701:	83 c0 10             	add    $0x10,%eax
80103704:	8b 04 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%eax
8010370b:	89 c2                	mov    %eax,%edx
8010370d:	8b 45 08             	mov    0x8(%ebp),%eax
80103710:	8b 40 08             	mov    0x8(%eax),%eax
80103713:	39 c2                	cmp    %eax,%edx
80103715:	74 0f                	je     80103726 <log_write+0x7e>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80103717:	ff 45 f4             	incl   -0xc(%ebp)
8010371a:	a1 c8 32 11 80       	mov    0x801132c8,%eax
8010371f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103722:	7f da                	jg     801036fe <log_write+0x56>
80103724:	eb 01                	jmp    80103727 <log_write+0x7f>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
80103726:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
80103727:	8b 45 08             	mov    0x8(%ebp),%eax
8010372a:	8b 40 08             	mov    0x8(%eax),%eax
8010372d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103730:	83 c2 10             	add    $0x10,%edx
80103733:	89 04 95 8c 32 11 80 	mov    %eax,-0x7feecd74(,%edx,4)
  if (i == log.lh.n)
8010373a:	a1 c8 32 11 80       	mov    0x801132c8,%eax
8010373f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103742:	75 0b                	jne    8010374f <log_write+0xa7>
    log.lh.n++;
80103744:	a1 c8 32 11 80       	mov    0x801132c8,%eax
80103749:	40                   	inc    %eax
8010374a:	a3 c8 32 11 80       	mov    %eax,0x801132c8
  b->flags |= B_DIRTY; // prevent eviction
8010374f:	8b 45 08             	mov    0x8(%ebp),%eax
80103752:	8b 00                	mov    (%eax),%eax
80103754:	89 c2                	mov    %eax,%edx
80103756:	83 ca 04             	or     $0x4,%edx
80103759:	8b 45 08             	mov    0x8(%ebp),%eax
8010375c:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
8010375e:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
80103765:	e8 57 18 00 00       	call   80104fc1 <release>
}
8010376a:	c9                   	leave  
8010376b:	c3                   	ret    

8010376c <v2p>:
8010376c:	55                   	push   %ebp
8010376d:	89 e5                	mov    %esp,%ebp
8010376f:	8b 45 08             	mov    0x8(%ebp),%eax
80103772:	05 00 00 00 80       	add    $0x80000000,%eax
80103777:	5d                   	pop    %ebp
80103778:	c3                   	ret    

80103779 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80103779:	55                   	push   %ebp
8010377a:	89 e5                	mov    %esp,%ebp
8010377c:	8b 45 08             	mov    0x8(%ebp),%eax
8010377f:	05 00 00 00 80       	add    $0x80000000,%eax
80103784:	5d                   	pop    %ebp
80103785:	c3                   	ret    

80103786 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
80103786:	55                   	push   %ebp
80103787:	89 e5                	mov    %esp,%ebp
80103789:	53                   	push   %ebx
8010378a:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
               "+m" (*addr), "=a" (result) :
8010378d:	8b 55 08             	mov    0x8(%ebp),%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103790:	8b 45 0c             	mov    0xc(%ebp),%eax
               "+m" (*addr), "=a" (result) :
80103793:	8b 4d 08             	mov    0x8(%ebp),%ecx
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103796:	89 c3                	mov    %eax,%ebx
80103798:	89 d8                	mov    %ebx,%eax
8010379a:	f0 87 02             	lock xchg %eax,(%edx)
8010379d:	89 c3                	mov    %eax,%ebx
8010379f:	89 5d f8             	mov    %ebx,-0x8(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
801037a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
801037a5:	83 c4 10             	add    $0x10,%esp
801037a8:	5b                   	pop    %ebx
801037a9:	5d                   	pop    %ebp
801037aa:	c3                   	ret    

801037ab <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
801037ab:	55                   	push   %ebp
801037ac:	89 e5                	mov    %esp,%ebp
801037ae:	83 e4 f0             	and    $0xfffffff0,%esp
801037b1:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801037b4:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
801037bb:	80 
801037bc:	c7 04 24 5c 84 11 80 	movl   $0x8011845c,(%esp)
801037c3:	e8 7d f2 ff ff       	call   80102a45 <kinit1>
  kvmalloc();      // kernel page table
801037c8:	e8 18 49 00 00       	call   801080e5 <kvmalloc>
  mpinit();        // collect info about this machine
801037cd:	e8 8f 04 00 00       	call   80103c61 <mpinit>
  lapicinit();
801037d2:	e8 ef f5 ff ff       	call   80102dc6 <lapicinit>
  seginit();       // set up segments
801037d7:	e8 c5 42 00 00       	call   80107aa1 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
801037dc:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801037e2:	8a 00                	mov    (%eax),%al
801037e4:	0f b6 c0             	movzbl %al,%eax
801037e7:	89 44 24 04          	mov    %eax,0x4(%esp)
801037eb:	c7 04 24 50 8b 10 80 	movl   $0x80108b50,(%esp)
801037f2:	e8 aa cb ff ff       	call   801003a1 <cprintf>
  picinit();       // interrupt controller
801037f7:	e8 cc 06 00 00       	call   80103ec8 <picinit>
  ioapicinit();    // another interrupt controller
801037fc:	e8 3c f1 ff ff       	call   8010293d <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
80103801:	e8 89 d2 ff ff       	call   80100a8f <consoleinit>
  uartinit();      // serial port
80103806:	e8 e9 35 00 00       	call   80106df4 <uartinit>
  pinit();         // process table
8010380b:	e8 cb 0b 00 00       	call   801043db <pinit>
  tvinit();        // trap vectors
80103810:	e8 00 2f 00 00       	call   80106715 <tvinit>
  binit();         // buffer cache
80103815:	e8 1a c8 ff ff       	call   80100034 <binit>
  fileinit();      // file table
8010381a:	e8 ed d6 ff ff       	call   80100f0c <fileinit>
  ideinit();       // disk
8010381f:	e8 4a ed ff ff       	call   8010256e <ideinit>
  if(!ismp)
80103824:	a1 64 33 11 80       	mov    0x80113364,%eax
80103829:	85 c0                	test   %eax,%eax
8010382b:	75 05                	jne    80103832 <main+0x87>
    timerinit();   // uniprocessor timer
8010382d:	e8 2a 2e 00 00       	call   8010665c <timerinit>
  startothers();   // start other processors
80103832:	e8 7e 00 00 00       	call   801038b5 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103837:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
8010383e:	8e 
8010383f:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80103846:	e8 32 f2 ff ff       	call   80102a7d <kinit2>
  userinit();      // first user process
8010384b:	e8 f8 0c 00 00       	call   80104548 <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
80103850:	e8 1a 00 00 00       	call   8010386f <mpmain>

80103855 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103855:	55                   	push   %ebp
80103856:	89 e5                	mov    %esp,%ebp
80103858:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
8010385b:	e8 9c 48 00 00       	call   801080fc <switchkvm>
  seginit();
80103860:	e8 3c 42 00 00       	call   80107aa1 <seginit>
  lapicinit();
80103865:	e8 5c f5 ff ff       	call   80102dc6 <lapicinit>
  mpmain();
8010386a:	e8 00 00 00 00       	call   8010386f <mpmain>

8010386f <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
8010386f:	55                   	push   %ebp
80103870:	89 e5                	mov    %esp,%ebp
80103872:	83 ec 18             	sub    $0x18,%esp
  cprintf("cpu%d: starting\n", cpu->id);
80103875:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010387b:	8a 00                	mov    (%eax),%al
8010387d:	0f b6 c0             	movzbl %al,%eax
80103880:	89 44 24 04          	mov    %eax,0x4(%esp)
80103884:	c7 04 24 67 8b 10 80 	movl   $0x80108b67,(%esp)
8010388b:	e8 11 cb ff ff       	call   801003a1 <cprintf>
  idtinit();       // load idt register
80103890:	e8 dd 2f 00 00       	call   80106872 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80103895:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010389b:	05 a8 00 00 00       	add    $0xa8,%eax
801038a0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801038a7:	00 
801038a8:	89 04 24             	mov    %eax,(%esp)
801038ab:	e8 d6 fe ff ff       	call   80103786 <xchg>
  scheduler();     // start running processes
801038b0:	e8 06 12 00 00       	call   80104abb <scheduler>

801038b5 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
801038b5:	55                   	push   %ebp
801038b6:	89 e5                	mov    %esp,%ebp
801038b8:	53                   	push   %ebx
801038b9:	83 ec 24             	sub    $0x24,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
801038bc:	c7 04 24 00 70 00 00 	movl   $0x7000,(%esp)
801038c3:	e8 b1 fe ff ff       	call   80103779 <p2v>
801038c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801038cb:	b8 8a 00 00 00       	mov    $0x8a,%eax
801038d0:	89 44 24 08          	mov    %eax,0x8(%esp)
801038d4:	c7 44 24 04 2c c5 10 	movl   $0x8010c52c,0x4(%esp)
801038db:	80 
801038dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038df:	89 04 24             	mov    %eax,(%esp)
801038e2:	e8 97 19 00 00       	call   8010527e <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801038e7:	c7 45 f4 80 33 11 80 	movl   $0x80113380,-0xc(%ebp)
801038ee:	e9 8f 00 00 00       	jmp    80103982 <startothers+0xcd>
    if(c == cpus+cpunum())  // We've started already.
801038f3:	e8 2b f6 ff ff       	call   80102f23 <cpunum>
801038f8:	89 c2                	mov    %eax,%edx
801038fa:	89 d0                	mov    %edx,%eax
801038fc:	d1 e0                	shl    %eax
801038fe:	01 d0                	add    %edx,%eax
80103900:	c1 e0 04             	shl    $0x4,%eax
80103903:	29 d0                	sub    %edx,%eax
80103905:	c1 e0 02             	shl    $0x2,%eax
80103908:	05 80 33 11 80       	add    $0x80113380,%eax
8010390d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103910:	74 68                	je     8010397a <startothers+0xc5>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103912:	e8 5c f2 ff ff       	call   80102b73 <kalloc>
80103917:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
8010391a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010391d:	83 e8 04             	sub    $0x4,%eax
80103920:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103923:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103929:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
8010392b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010392e:	83 e8 08             	sub    $0x8,%eax
80103931:	c7 00 55 38 10 80    	movl   $0x80103855,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
80103937:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010393a:	8d 58 f4             	lea    -0xc(%eax),%ebx
8010393d:	c7 04 24 00 b0 10 80 	movl   $0x8010b000,(%esp)
80103944:	e8 23 fe ff ff       	call   8010376c <v2p>
80103949:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
8010394b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010394e:	89 04 24             	mov    %eax,(%esp)
80103951:	e8 16 fe ff ff       	call   8010376c <v2p>
80103956:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103959:	8a 12                	mov    (%edx),%dl
8010395b:	0f b6 d2             	movzbl %dl,%edx
8010395e:	89 44 24 04          	mov    %eax,0x4(%esp)
80103962:	89 14 24             	mov    %edx,(%esp)
80103965:	e8 3d f6 ff ff       	call   80102fa7 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
8010396a:	90                   	nop
8010396b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010396e:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80103974:	85 c0                	test   %eax,%eax
80103976:	74 f3                	je     8010396b <startothers+0xb6>
80103978:	eb 01                	jmp    8010397b <startothers+0xc6>
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
    if(c == cpus+cpunum())  // We've started already.
      continue;
8010397a:	90                   	nop
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
8010397b:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
80103982:	a1 60 39 11 80       	mov    0x80113960,%eax
80103987:	89 c2                	mov    %eax,%edx
80103989:	89 d0                	mov    %edx,%eax
8010398b:	d1 e0                	shl    %eax
8010398d:	01 d0                	add    %edx,%eax
8010398f:	c1 e0 04             	shl    $0x4,%eax
80103992:	29 d0                	sub    %edx,%eax
80103994:	c1 e0 02             	shl    $0x2,%eax
80103997:	05 80 33 11 80       	add    $0x80113380,%eax
8010399c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010399f:	0f 87 4e ff ff ff    	ja     801038f3 <startothers+0x3e>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
801039a5:	83 c4 24             	add    $0x24,%esp
801039a8:	5b                   	pop    %ebx
801039a9:	5d                   	pop    %ebp
801039aa:	c3                   	ret    
801039ab:	90                   	nop

801039ac <p2v>:
801039ac:	55                   	push   %ebp
801039ad:	89 e5                	mov    %esp,%ebp
801039af:	8b 45 08             	mov    0x8(%ebp),%eax
801039b2:	05 00 00 00 80       	add    $0x80000000,%eax
801039b7:	5d                   	pop    %ebp
801039b8:	c3                   	ret    

801039b9 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801039b9:	55                   	push   %ebp
801039ba:	89 e5                	mov    %esp,%ebp
801039bc:	53                   	push   %ebx
801039bd:	83 ec 14             	sub    $0x14,%esp
801039c0:	8b 45 08             	mov    0x8(%ebp),%eax
801039c3:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801039c7:	8b 55 e8             	mov    -0x18(%ebp),%edx
801039ca:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
801039ce:	66 8b 55 ea          	mov    -0x16(%ebp),%dx
801039d2:	ec                   	in     (%dx),%al
801039d3:	88 c3                	mov    %al,%bl
801039d5:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
801039d8:	8a 45 fb             	mov    -0x5(%ebp),%al
}
801039db:	83 c4 14             	add    $0x14,%esp
801039de:	5b                   	pop    %ebx
801039df:	5d                   	pop    %ebp
801039e0:	c3                   	ret    

801039e1 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801039e1:	55                   	push   %ebp
801039e2:	89 e5                	mov    %esp,%ebp
801039e4:	83 ec 08             	sub    $0x8,%esp
801039e7:	8b 45 08             	mov    0x8(%ebp),%eax
801039ea:	8b 55 0c             	mov    0xc(%ebp),%edx
801039ed:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
801039f1:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801039f4:	8a 45 f8             	mov    -0x8(%ebp),%al
801039f7:	8b 55 fc             	mov    -0x4(%ebp),%edx
801039fa:	ee                   	out    %al,(%dx)
}
801039fb:	c9                   	leave  
801039fc:	c3                   	ret    

801039fd <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
801039fd:	55                   	push   %ebp
801039fe:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103a00:	a1 64 c6 10 80       	mov    0x8010c664,%eax
80103a05:	89 c2                	mov    %eax,%edx
80103a07:	b8 80 33 11 80       	mov    $0x80113380,%eax
80103a0c:	89 d1                	mov    %edx,%ecx
80103a0e:	29 c1                	sub    %eax,%ecx
80103a10:	89 c8                	mov    %ecx,%eax
80103a12:	89 c2                	mov    %eax,%edx
80103a14:	c1 fa 02             	sar    $0x2,%edx
80103a17:	89 d0                	mov    %edx,%eax
80103a19:	c1 e0 03             	shl    $0x3,%eax
80103a1c:	01 d0                	add    %edx,%eax
80103a1e:	c1 e0 03             	shl    $0x3,%eax
80103a21:	01 d0                	add    %edx,%eax
80103a23:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
80103a2a:	01 c8                	add    %ecx,%eax
80103a2c:	c1 e0 03             	shl    $0x3,%eax
80103a2f:	01 d0                	add    %edx,%eax
80103a31:	c1 e0 03             	shl    $0x3,%eax
80103a34:	29 d0                	sub    %edx,%eax
80103a36:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
80103a3d:	01 c8                	add    %ecx,%eax
80103a3f:	c1 e0 02             	shl    $0x2,%eax
80103a42:	01 d0                	add    %edx,%eax
80103a44:	c1 e0 03             	shl    $0x3,%eax
80103a47:	29 d0                	sub    %edx,%eax
80103a49:	89 c1                	mov    %eax,%ecx
80103a4b:	c1 e1 07             	shl    $0x7,%ecx
80103a4e:	01 c8                	add    %ecx,%eax
80103a50:	d1 e0                	shl    %eax
80103a52:	01 d0                	add    %edx,%eax
}
80103a54:	5d                   	pop    %ebp
80103a55:	c3                   	ret    

80103a56 <sum>:

static uchar
sum(uchar *addr, int len)
{
80103a56:	55                   	push   %ebp
80103a57:	89 e5                	mov    %esp,%ebp
80103a59:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103a5c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103a63:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103a6a:	eb 13                	jmp    80103a7f <sum+0x29>
    sum += addr[i];
80103a6c:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103a6f:	8b 45 08             	mov    0x8(%ebp),%eax
80103a72:	01 d0                	add    %edx,%eax
80103a74:	8a 00                	mov    (%eax),%al
80103a76:	0f b6 c0             	movzbl %al,%eax
80103a79:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
80103a7c:	ff 45 fc             	incl   -0x4(%ebp)
80103a7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103a82:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103a85:	7c e5                	jl     80103a6c <sum+0x16>
    sum += addr[i];
  return sum;
80103a87:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103a8a:	c9                   	leave  
80103a8b:	c3                   	ret    

80103a8c <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103a8c:	55                   	push   %ebp
80103a8d:	89 e5                	mov    %esp,%ebp
80103a8f:	83 ec 28             	sub    $0x28,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
80103a92:	8b 45 08             	mov    0x8(%ebp),%eax
80103a95:	89 04 24             	mov    %eax,(%esp)
80103a98:	e8 0f ff ff ff       	call   801039ac <p2v>
80103a9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103aa0:	8b 55 0c             	mov    0xc(%ebp),%edx
80103aa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103aa6:	01 d0                	add    %edx,%eax
80103aa8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103aab:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103aae:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103ab1:	eb 3f                	jmp    80103af2 <mpsearch1+0x66>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103ab3:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103aba:	00 
80103abb:	c7 44 24 04 78 8b 10 	movl   $0x80108b78,0x4(%esp)
80103ac2:	80 
80103ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ac6:	89 04 24             	mov    %eax,(%esp)
80103ac9:	e8 5b 17 00 00       	call   80105229 <memcmp>
80103ace:	85 c0                	test   %eax,%eax
80103ad0:	75 1c                	jne    80103aee <mpsearch1+0x62>
80103ad2:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
80103ad9:	00 
80103ada:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103add:	89 04 24             	mov    %eax,(%esp)
80103ae0:	e8 71 ff ff ff       	call   80103a56 <sum>
80103ae5:	84 c0                	test   %al,%al
80103ae7:	75 05                	jne    80103aee <mpsearch1+0x62>
      return (struct mp*)p;
80103ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103aec:	eb 11                	jmp    80103aff <mpsearch1+0x73>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103aee:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103af2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103af5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103af8:	72 b9                	jb     80103ab3 <mpsearch1+0x27>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103afa:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103aff:	c9                   	leave  
80103b00:	c3                   	ret    

80103b01 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103b01:	55                   	push   %ebp
80103b02:	89 e5                	mov    %esp,%ebp
80103b04:	83 ec 28             	sub    $0x28,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103b07:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b11:	83 c0 0f             	add    $0xf,%eax
80103b14:	8a 00                	mov    (%eax),%al
80103b16:	0f b6 c0             	movzbl %al,%eax
80103b19:	89 c2                	mov    %eax,%edx
80103b1b:	c1 e2 08             	shl    $0x8,%edx
80103b1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b21:	83 c0 0e             	add    $0xe,%eax
80103b24:	8a 00                	mov    (%eax),%al
80103b26:	0f b6 c0             	movzbl %al,%eax
80103b29:	09 d0                	or     %edx,%eax
80103b2b:	c1 e0 04             	shl    $0x4,%eax
80103b2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103b31:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103b35:	74 21                	je     80103b58 <mpsearch+0x57>
    if((mp = mpsearch1(p, 1024)))
80103b37:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103b3e:	00 
80103b3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b42:	89 04 24             	mov    %eax,(%esp)
80103b45:	e8 42 ff ff ff       	call   80103a8c <mpsearch1>
80103b4a:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103b4d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103b51:	74 4e                	je     80103ba1 <mpsearch+0xa0>
      return mp;
80103b53:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b56:	eb 5d                	jmp    80103bb5 <mpsearch+0xb4>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103b58:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b5b:	83 c0 14             	add    $0x14,%eax
80103b5e:	8a 00                	mov    (%eax),%al
80103b60:	0f b6 c0             	movzbl %al,%eax
80103b63:	89 c2                	mov    %eax,%edx
80103b65:	c1 e2 08             	shl    $0x8,%edx
80103b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b6b:	83 c0 13             	add    $0x13,%eax
80103b6e:	8a 00                	mov    (%eax),%al
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
80103b8e:	e8 f9 fe ff ff       	call   80103a8c <mpsearch1>
80103b93:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103b96:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103b9a:	74 05                	je     80103ba1 <mpsearch+0xa0>
      return mp;
80103b9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b9f:	eb 14                	jmp    80103bb5 <mpsearch+0xb4>
  }
  return mpsearch1(0xF0000, 0x10000);
80103ba1:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80103ba8:	00 
80103ba9:	c7 04 24 00 00 0f 00 	movl   $0xf0000,(%esp)
80103bb0:	e8 d7 fe ff ff       	call   80103a8c <mpsearch1>
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
80103bbd:	e8 3f ff ff ff       	call   80103b01 <mpsearch>
80103bc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103bc5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103bc9:	74 0a                	je     80103bd5 <mpconfig+0x1e>
80103bcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bce:	8b 40 04             	mov    0x4(%eax),%eax
80103bd1:	85 c0                	test   %eax,%eax
80103bd3:	75 0a                	jne    80103bdf <mpconfig+0x28>
    return 0;
80103bd5:	b8 00 00 00 00       	mov    $0x0,%eax
80103bda:	e9 80 00 00 00       	jmp    80103c5f <mpconfig+0xa8>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
80103bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103be2:	8b 40 04             	mov    0x4(%eax),%eax
80103be5:	89 04 24             	mov    %eax,(%esp)
80103be8:	e8 bf fd ff ff       	call   801039ac <p2v>
80103bed:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103bf0:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103bf7:	00 
80103bf8:	c7 44 24 04 7d 8b 10 	movl   $0x80108b7d,0x4(%esp)
80103bff:	80 
80103c00:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c03:	89 04 24             	mov    %eax,(%esp)
80103c06:	e8 1e 16 00 00       	call   80105229 <memcmp>
80103c0b:	85 c0                	test   %eax,%eax
80103c0d:	74 07                	je     80103c16 <mpconfig+0x5f>
    return 0;
80103c0f:	b8 00 00 00 00       	mov    $0x0,%eax
80103c14:	eb 49                	jmp    80103c5f <mpconfig+0xa8>
  if(conf->version != 1 && conf->version != 4)
80103c16:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c19:	8a 40 06             	mov    0x6(%eax),%al
80103c1c:	3c 01                	cmp    $0x1,%al
80103c1e:	74 11                	je     80103c31 <mpconfig+0x7a>
80103c20:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c23:	8a 40 06             	mov    0x6(%eax),%al
80103c26:	3c 04                	cmp    $0x4,%al
80103c28:	74 07                	je     80103c31 <mpconfig+0x7a>
    return 0;
80103c2a:	b8 00 00 00 00       	mov    $0x0,%eax
80103c2f:	eb 2e                	jmp    80103c5f <mpconfig+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103c31:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c34:	8b 40 04             	mov    0x4(%eax),%eax
80103c37:	0f b7 c0             	movzwl %ax,%eax
80103c3a:	89 44 24 04          	mov    %eax,0x4(%esp)
80103c3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c41:	89 04 24             	mov    %eax,(%esp)
80103c44:	e8 0d fe ff ff       	call   80103a56 <sum>
80103c49:	84 c0                	test   %al,%al
80103c4b:	74 07                	je     80103c54 <mpconfig+0x9d>
    return 0;
80103c4d:	b8 00 00 00 00       	mov    $0x0,%eax
80103c52:	eb 0b                	jmp    80103c5f <mpconfig+0xa8>
  *pmp = mp;
80103c54:	8b 45 08             	mov    0x8(%ebp),%eax
80103c57:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103c5a:	89 10                	mov    %edx,(%eax)
  return conf;
80103c5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103c5f:	c9                   	leave  
80103c60:	c3                   	ret    

80103c61 <mpinit>:

void
mpinit(void)
{
80103c61:	55                   	push   %ebp
80103c62:	89 e5                	mov    %esp,%ebp
80103c64:	83 ec 38             	sub    $0x38,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103c67:	c7 05 64 c6 10 80 80 	movl   $0x80113380,0x8010c664
80103c6e:	33 11 80 
  if((conf = mpconfig(&mp)) == 0)
80103c71:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103c74:	89 04 24             	mov    %eax,(%esp)
80103c77:	e8 3b ff ff ff       	call   80103bb7 <mpconfig>
80103c7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103c7f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103c83:	0f 84 a4 01 00 00    	je     80103e2d <mpinit+0x1cc>
    return;
  ismp = 1;
80103c89:	c7 05 64 33 11 80 01 	movl   $0x1,0x80113364
80103c90:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103c93:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c96:	8b 40 24             	mov    0x24(%eax),%eax
80103c99:	a3 7c 32 11 80       	mov    %eax,0x8011327c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103c9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ca1:	83 c0 2c             	add    $0x2c,%eax
80103ca4:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103ca7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103caa:	8b 40 04             	mov    0x4(%eax),%eax
80103cad:	0f b7 d0             	movzwl %ax,%edx
80103cb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cb3:	01 d0                	add    %edx,%eax
80103cb5:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103cb8:	e9 fe 00 00 00       	jmp    80103dbb <mpinit+0x15a>
    switch(*p){
80103cbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cc0:	8a 00                	mov    (%eax),%al
80103cc2:	0f b6 c0             	movzbl %al,%eax
80103cc5:	83 f8 04             	cmp    $0x4,%eax
80103cc8:	0f 87 cb 00 00 00    	ja     80103d99 <mpinit+0x138>
80103cce:	8b 04 85 c0 8b 10 80 	mov    -0x7fef7440(,%eax,4),%eax
80103cd5:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103cd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cda:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
80103cdd:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103ce0:	8a 40 01             	mov    0x1(%eax),%al
80103ce3:	0f b6 d0             	movzbl %al,%edx
80103ce6:	a1 60 39 11 80       	mov    0x80113960,%eax
80103ceb:	39 c2                	cmp    %eax,%edx
80103ced:	74 2c                	je     80103d1b <mpinit+0xba>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80103cef:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103cf2:	8a 40 01             	mov    0x1(%eax),%al
80103cf5:	0f b6 d0             	movzbl %al,%edx
80103cf8:	a1 60 39 11 80       	mov    0x80113960,%eax
80103cfd:	89 54 24 08          	mov    %edx,0x8(%esp)
80103d01:	89 44 24 04          	mov    %eax,0x4(%esp)
80103d05:	c7 04 24 82 8b 10 80 	movl   $0x80108b82,(%esp)
80103d0c:	e8 90 c6 ff ff       	call   801003a1 <cprintf>
        ismp = 0;
80103d11:	c7 05 64 33 11 80 00 	movl   $0x0,0x80113364
80103d18:	00 00 00 
      }
      if(proc->flags & MPBOOT)
80103d1b:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103d1e:	8a 40 03             	mov    0x3(%eax),%al
80103d21:	0f b6 c0             	movzbl %al,%eax
80103d24:	83 e0 02             	and    $0x2,%eax
80103d27:	85 c0                	test   %eax,%eax
80103d29:	74 1e                	je     80103d49 <mpinit+0xe8>
        bcpu = &cpus[ncpu];
80103d2b:	8b 15 60 39 11 80    	mov    0x80113960,%edx
80103d31:	89 d0                	mov    %edx,%eax
80103d33:	d1 e0                	shl    %eax
80103d35:	01 d0                	add    %edx,%eax
80103d37:	c1 e0 04             	shl    $0x4,%eax
80103d3a:	29 d0                	sub    %edx,%eax
80103d3c:	c1 e0 02             	shl    $0x2,%eax
80103d3f:	05 80 33 11 80       	add    $0x80113380,%eax
80103d44:	a3 64 c6 10 80       	mov    %eax,0x8010c664
      cpus[ncpu].id = ncpu;
80103d49:	8b 15 60 39 11 80    	mov    0x80113960,%edx
80103d4f:	a1 60 39 11 80       	mov    0x80113960,%eax
80103d54:	88 c1                	mov    %al,%cl
80103d56:	89 d0                	mov    %edx,%eax
80103d58:	d1 e0                	shl    %eax
80103d5a:	01 d0                	add    %edx,%eax
80103d5c:	c1 e0 04             	shl    $0x4,%eax
80103d5f:	29 d0                	sub    %edx,%eax
80103d61:	c1 e0 02             	shl    $0x2,%eax
80103d64:	05 80 33 11 80       	add    $0x80113380,%eax
80103d69:	88 08                	mov    %cl,(%eax)
      ncpu++;
80103d6b:	a1 60 39 11 80       	mov    0x80113960,%eax
80103d70:	40                   	inc    %eax
80103d71:	a3 60 39 11 80       	mov    %eax,0x80113960
      p += sizeof(struct mpproc);
80103d76:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103d7a:	eb 3f                	jmp    80103dbb <mpinit+0x15a>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103d7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d7f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103d82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103d85:	8a 40 01             	mov    0x1(%eax),%al
80103d88:	a2 60 33 11 80       	mov    %al,0x80113360
      p += sizeof(struct mpioapic);
80103d8d:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103d91:	eb 28                	jmp    80103dbb <mpinit+0x15a>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103d93:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103d97:	eb 22                	jmp    80103dbb <mpinit+0x15a>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80103d99:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d9c:	8a 00                	mov    (%eax),%al
80103d9e:	0f b6 c0             	movzbl %al,%eax
80103da1:	89 44 24 04          	mov    %eax,0x4(%esp)
80103da5:	c7 04 24 a0 8b 10 80 	movl   $0x80108ba0,(%esp)
80103dac:	e8 f0 c5 ff ff       	call   801003a1 <cprintf>
      ismp = 0;
80103db1:	c7 05 64 33 11 80 00 	movl   $0x0,0x80113364
80103db8:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103dbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103dbe:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103dc1:	0f 82 f6 fe ff ff    	jb     80103cbd <mpinit+0x5c>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
80103dc7:	a1 64 33 11 80       	mov    0x80113364,%eax
80103dcc:	85 c0                	test   %eax,%eax
80103dce:	75 1d                	jne    80103ded <mpinit+0x18c>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103dd0:	c7 05 60 39 11 80 01 	movl   $0x1,0x80113960
80103dd7:	00 00 00 
    lapic = 0;
80103dda:	c7 05 7c 32 11 80 00 	movl   $0x0,0x8011327c
80103de1:	00 00 00 
    ioapicid = 0;
80103de4:	c6 05 60 33 11 80 00 	movb   $0x0,0x80113360
80103deb:	eb 40                	jmp    80103e2d <mpinit+0x1cc>
    return;
  }

  if(mp->imcrp){
80103ded:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103df0:	8a 40 0c             	mov    0xc(%eax),%al
80103df3:	84 c0                	test   %al,%al
80103df5:	74 36                	je     80103e2d <mpinit+0x1cc>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103df7:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
80103dfe:	00 
80103dff:	c7 04 24 22 00 00 00 	movl   $0x22,(%esp)
80103e06:	e8 d6 fb ff ff       	call   801039e1 <outb>
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103e0b:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103e12:	e8 a2 fb ff ff       	call   801039b9 <inb>
80103e17:	83 c8 01             	or     $0x1,%eax
80103e1a:	0f b6 c0             	movzbl %al,%eax
80103e1d:	89 44 24 04          	mov    %eax,0x4(%esp)
80103e21:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103e28:	e8 b4 fb ff ff       	call   801039e1 <outb>
  }
}
80103e2d:	c9                   	leave  
80103e2e:	c3                   	ret    
80103e2f:	90                   	nop

80103e30 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103e30:	55                   	push   %ebp
80103e31:	89 e5                	mov    %esp,%ebp
80103e33:	83 ec 08             	sub    $0x8,%esp
80103e36:	8b 45 08             	mov    0x8(%ebp),%eax
80103e39:	8b 55 0c             	mov    0xc(%ebp),%edx
80103e3c:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103e40:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103e43:	8a 45 f8             	mov    -0x8(%ebp),%al
80103e46:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103e49:	ee                   	out    %al,(%dx)
}
80103e4a:	c9                   	leave  
80103e4b:	c3                   	ret    

80103e4c <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103e4c:	55                   	push   %ebp
80103e4d:	89 e5                	mov    %esp,%ebp
80103e4f:	83 ec 0c             	sub    $0xc,%esp
80103e52:	8b 45 08             	mov    0x8(%ebp),%eax
80103e55:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103e59:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103e5c:	66 a3 00 c0 10 80    	mov    %ax,0x8010c000
  outb(IO_PIC1+1, mask);
80103e62:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103e65:	0f b6 c0             	movzbl %al,%eax
80103e68:	89 44 24 04          	mov    %eax,0x4(%esp)
80103e6c:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103e73:	e8 b8 ff ff ff       	call   80103e30 <outb>
  outb(IO_PIC2+1, mask >> 8);
80103e78:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103e7b:	66 c1 e8 08          	shr    $0x8,%ax
80103e7f:	0f b6 c0             	movzbl %al,%eax
80103e82:	89 44 24 04          	mov    %eax,0x4(%esp)
80103e86:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103e8d:	e8 9e ff ff ff       	call   80103e30 <outb>
}
80103e92:	c9                   	leave  
80103e93:	c3                   	ret    

80103e94 <picenable>:

void
picenable(int irq)
{
80103e94:	55                   	push   %ebp
80103e95:	89 e5                	mov    %esp,%ebp
80103e97:	53                   	push   %ebx
80103e98:	83 ec 04             	sub    $0x4,%esp
  picsetmask(irqmask & ~(1<<irq));
80103e9b:	8b 45 08             	mov    0x8(%ebp),%eax
80103e9e:	ba 01 00 00 00       	mov    $0x1,%edx
80103ea3:	89 d3                	mov    %edx,%ebx
80103ea5:	88 c1                	mov    %al,%cl
80103ea7:	d3 e3                	shl    %cl,%ebx
80103ea9:	89 d8                	mov    %ebx,%eax
80103eab:	89 c2                	mov    %eax,%edx
80103ead:	f7 d2                	not    %edx
80103eaf:	66 a1 00 c0 10 80    	mov    0x8010c000,%ax
80103eb5:	21 d0                	and    %edx,%eax
80103eb7:	0f b7 c0             	movzwl %ax,%eax
80103eba:	89 04 24             	mov    %eax,(%esp)
80103ebd:	e8 8a ff ff ff       	call   80103e4c <picsetmask>
}
80103ec2:	83 c4 04             	add    $0x4,%esp
80103ec5:	5b                   	pop    %ebx
80103ec6:	5d                   	pop    %ebp
80103ec7:	c3                   	ret    

80103ec8 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103ec8:	55                   	push   %ebp
80103ec9:	89 e5                	mov    %esp,%ebp
80103ecb:	83 ec 08             	sub    $0x8,%esp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103ece:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103ed5:	00 
80103ed6:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103edd:	e8 4e ff ff ff       	call   80103e30 <outb>
  outb(IO_PIC2+1, 0xFF);
80103ee2:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103ee9:	00 
80103eea:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103ef1:	e8 3a ff ff ff       	call   80103e30 <outb>

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80103ef6:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103efd:	00 
80103efe:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103f05:	e8 26 ff ff ff       	call   80103e30 <outb>

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80103f0a:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
80103f11:	00 
80103f12:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103f19:	e8 12 ff ff ff       	call   80103e30 <outb>

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80103f1e:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
80103f25:	00 
80103f26:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103f2d:	e8 fe fe ff ff       	call   80103e30 <outb>
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80103f32:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103f39:	00 
80103f3a:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103f41:	e8 ea fe ff ff       	call   80103e30 <outb>

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80103f46:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103f4d:	00 
80103f4e:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103f55:	e8 d6 fe ff ff       	call   80103e30 <outb>
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80103f5a:	c7 44 24 04 28 00 00 	movl   $0x28,0x4(%esp)
80103f61:	00 
80103f62:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103f69:	e8 c2 fe ff ff       	call   80103e30 <outb>
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80103f6e:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80103f75:	00 
80103f76:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103f7d:	e8 ae fe ff ff       	call   80103e30 <outb>
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80103f82:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103f89:	00 
80103f8a:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103f91:	e8 9a fe ff ff       	call   80103e30 <outb>

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80103f96:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103f9d:	00 
80103f9e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103fa5:	e8 86 fe ff ff       	call   80103e30 <outb>
  outb(IO_PIC1, 0x0a);             // read IRR by default
80103faa:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103fb1:	00 
80103fb2:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103fb9:	e8 72 fe ff ff       	call   80103e30 <outb>

  outb(IO_PIC2, 0x68);             // OCW3
80103fbe:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103fc5:	00 
80103fc6:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103fcd:	e8 5e fe ff ff       	call   80103e30 <outb>
  outb(IO_PIC2, 0x0a);             // OCW3
80103fd2:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103fd9:	00 
80103fda:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103fe1:	e8 4a fe ff ff       	call   80103e30 <outb>

  if(irqmask != 0xFFFF)
80103fe6:	66 a1 00 c0 10 80    	mov    0x8010c000,%ax
80103fec:	66 83 f8 ff          	cmp    $0xffff,%ax
80103ff0:	74 11                	je     80104003 <picinit+0x13b>
    picsetmask(irqmask);
80103ff2:	66 a1 00 c0 10 80    	mov    0x8010c000,%ax
80103ff8:	0f b7 c0             	movzwl %ax,%eax
80103ffb:	89 04 24             	mov    %eax,(%esp)
80103ffe:	e8 49 fe ff ff       	call   80103e4c <picsetmask>
}
80104003:	c9                   	leave  
80104004:	c3                   	ret    
80104005:	66 90                	xchg   %ax,%ax
80104007:	90                   	nop

80104008 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80104008:	55                   	push   %ebp
80104009:	89 e5                	mov    %esp,%ebp
8010400b:	83 ec 28             	sub    $0x28,%esp
  struct pipe *p;

  p = 0;
8010400e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80104015:	8b 45 0c             	mov    0xc(%ebp),%eax
80104018:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
8010401e:	8b 45 0c             	mov    0xc(%ebp),%eax
80104021:	8b 10                	mov    (%eax),%edx
80104023:	8b 45 08             	mov    0x8(%ebp),%eax
80104026:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80104028:	e8 fb ce ff ff       	call   80100f28 <filealloc>
8010402d:	8b 55 08             	mov    0x8(%ebp),%edx
80104030:	89 02                	mov    %eax,(%edx)
80104032:	8b 45 08             	mov    0x8(%ebp),%eax
80104035:	8b 00                	mov    (%eax),%eax
80104037:	85 c0                	test   %eax,%eax
80104039:	0f 84 c8 00 00 00    	je     80104107 <pipealloc+0xff>
8010403f:	e8 e4 ce ff ff       	call   80100f28 <filealloc>
80104044:	8b 55 0c             	mov    0xc(%ebp),%edx
80104047:	89 02                	mov    %eax,(%edx)
80104049:	8b 45 0c             	mov    0xc(%ebp),%eax
8010404c:	8b 00                	mov    (%eax),%eax
8010404e:	85 c0                	test   %eax,%eax
80104050:	0f 84 b1 00 00 00    	je     80104107 <pipealloc+0xff>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80104056:	e8 18 eb ff ff       	call   80102b73 <kalloc>
8010405b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010405e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104062:	0f 84 9e 00 00 00    	je     80104106 <pipealloc+0xfe>
    goto bad;
  p->readopen = 1;
80104068:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010406b:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80104072:	00 00 00 
  p->writeopen = 1;
80104075:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104078:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010407f:	00 00 00 
  p->nwrite = 0;
80104082:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104085:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010408c:	00 00 00 
  p->nread = 0;
8010408f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104092:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80104099:	00 00 00 
  initlock(&p->lock, "pipe");
8010409c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010409f:	c7 44 24 04 d4 8b 10 	movl   $0x80108bd4,0x4(%esp)
801040a6:	80 
801040a7:	89 04 24             	mov    %eax,(%esp)
801040aa:	e8 8f 0e 00 00       	call   80104f3e <initlock>
  (*f0)->type = FD_PIPE;
801040af:	8b 45 08             	mov    0x8(%ebp),%eax
801040b2:	8b 00                	mov    (%eax),%eax
801040b4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801040ba:	8b 45 08             	mov    0x8(%ebp),%eax
801040bd:	8b 00                	mov    (%eax),%eax
801040bf:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801040c3:	8b 45 08             	mov    0x8(%ebp),%eax
801040c6:	8b 00                	mov    (%eax),%eax
801040c8:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801040cc:	8b 45 08             	mov    0x8(%ebp),%eax
801040cf:	8b 00                	mov    (%eax),%eax
801040d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801040d4:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
801040d7:	8b 45 0c             	mov    0xc(%ebp),%eax
801040da:	8b 00                	mov    (%eax),%eax
801040dc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801040e2:	8b 45 0c             	mov    0xc(%ebp),%eax
801040e5:	8b 00                	mov    (%eax),%eax
801040e7:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801040eb:	8b 45 0c             	mov    0xc(%ebp),%eax
801040ee:	8b 00                	mov    (%eax),%eax
801040f0:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801040f4:	8b 45 0c             	mov    0xc(%ebp),%eax
801040f7:	8b 00                	mov    (%eax),%eax
801040f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801040fc:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
801040ff:	b8 00 00 00 00       	mov    $0x0,%eax
80104104:	eb 43                	jmp    80104149 <pipealloc+0x141>
  p = 0;
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
80104106:	90                   	nop
  (*f1)->pipe = p;
  return 0;

//PAGEBREAK: 20
 bad:
  if(p)
80104107:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010410b:	74 0b                	je     80104118 <pipealloc+0x110>
    kfree((char*)p);
8010410d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104110:	89 04 24             	mov    %eax,(%esp)
80104113:	e8 c2 e9 ff ff       	call   80102ada <kfree>
  if(*f0)
80104118:	8b 45 08             	mov    0x8(%ebp),%eax
8010411b:	8b 00                	mov    (%eax),%eax
8010411d:	85 c0                	test   %eax,%eax
8010411f:	74 0d                	je     8010412e <pipealloc+0x126>
    fileclose(*f0);
80104121:	8b 45 08             	mov    0x8(%ebp),%eax
80104124:	8b 00                	mov    (%eax),%eax
80104126:	89 04 24             	mov    %eax,(%esp)
80104129:	e8 a2 ce ff ff       	call   80100fd0 <fileclose>
  if(*f1)
8010412e:	8b 45 0c             	mov    0xc(%ebp),%eax
80104131:	8b 00                	mov    (%eax),%eax
80104133:	85 c0                	test   %eax,%eax
80104135:	74 0d                	je     80104144 <pipealloc+0x13c>
    fileclose(*f1);
80104137:	8b 45 0c             	mov    0xc(%ebp),%eax
8010413a:	8b 00                	mov    (%eax),%eax
8010413c:	89 04 24             	mov    %eax,(%esp)
8010413f:	e8 8c ce ff ff       	call   80100fd0 <fileclose>
  return -1;
80104144:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104149:	c9                   	leave  
8010414a:	c3                   	ret    

8010414b <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
8010414b:	55                   	push   %ebp
8010414c:	89 e5                	mov    %esp,%ebp
8010414e:	83 ec 18             	sub    $0x18,%esp
  acquire(&p->lock);
80104151:	8b 45 08             	mov    0x8(%ebp),%eax
80104154:	89 04 24             	mov    %eax,(%esp)
80104157:	e8 03 0e 00 00       	call   80104f5f <acquire>
  if(writable){
8010415c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104160:	74 1f                	je     80104181 <pipeclose+0x36>
    p->writeopen = 0;
80104162:	8b 45 08             	mov    0x8(%ebp),%eax
80104165:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
8010416c:	00 00 00 
    wakeup(&p->nread);
8010416f:	8b 45 08             	mov    0x8(%ebp),%eax
80104172:	05 34 02 00 00       	add    $0x234,%eax
80104177:	89 04 24             	mov    %eax,(%esp)
8010417a:	e8 d7 0b 00 00       	call   80104d56 <wakeup>
8010417f:	eb 1d                	jmp    8010419e <pipeclose+0x53>
  } else {
    p->readopen = 0;
80104181:	8b 45 08             	mov    0x8(%ebp),%eax
80104184:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
8010418b:	00 00 00 
    wakeup(&p->nwrite);
8010418e:	8b 45 08             	mov    0x8(%ebp),%eax
80104191:	05 38 02 00 00       	add    $0x238,%eax
80104196:	89 04 24             	mov    %eax,(%esp)
80104199:	e8 b8 0b 00 00       	call   80104d56 <wakeup>
  }
  if(p->readopen == 0 && p->writeopen == 0){
8010419e:	8b 45 08             	mov    0x8(%ebp),%eax
801041a1:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
801041a7:	85 c0                	test   %eax,%eax
801041a9:	75 25                	jne    801041d0 <pipeclose+0x85>
801041ab:	8b 45 08             	mov    0x8(%ebp),%eax
801041ae:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
801041b4:	85 c0                	test   %eax,%eax
801041b6:	75 18                	jne    801041d0 <pipeclose+0x85>
    release(&p->lock);
801041b8:	8b 45 08             	mov    0x8(%ebp),%eax
801041bb:	89 04 24             	mov    %eax,(%esp)
801041be:	e8 fe 0d 00 00       	call   80104fc1 <release>
    kfree((char*)p);
801041c3:	8b 45 08             	mov    0x8(%ebp),%eax
801041c6:	89 04 24             	mov    %eax,(%esp)
801041c9:	e8 0c e9 ff ff       	call   80102ada <kfree>
801041ce:	eb 0b                	jmp    801041db <pipeclose+0x90>
  } else
    release(&p->lock);
801041d0:	8b 45 08             	mov    0x8(%ebp),%eax
801041d3:	89 04 24             	mov    %eax,(%esp)
801041d6:	e8 e6 0d 00 00       	call   80104fc1 <release>
}
801041db:	c9                   	leave  
801041dc:	c3                   	ret    

801041dd <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801041dd:	55                   	push   %ebp
801041de:	89 e5                	mov    %esp,%ebp
801041e0:	53                   	push   %ebx
801041e1:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
801041e4:	8b 45 08             	mov    0x8(%ebp),%eax
801041e7:	89 04 24             	mov    %eax,(%esp)
801041ea:	e8 70 0d 00 00       	call   80104f5f <acquire>
  for(i = 0; i < n; i++){
801041ef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801041f6:	e9 a6 00 00 00       	jmp    801042a1 <pipewrite+0xc4>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
801041fb:	8b 45 08             	mov    0x8(%ebp),%eax
801041fe:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104204:	85 c0                	test   %eax,%eax
80104206:	74 0d                	je     80104215 <pipewrite+0x38>
80104208:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010420e:	8b 40 24             	mov    0x24(%eax),%eax
80104211:	85 c0                	test   %eax,%eax
80104213:	74 15                	je     8010422a <pipewrite+0x4d>
        release(&p->lock);
80104215:	8b 45 08             	mov    0x8(%ebp),%eax
80104218:	89 04 24             	mov    %eax,(%esp)
8010421b:	e8 a1 0d 00 00       	call   80104fc1 <release>
        return -1;
80104220:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104225:	e9 9d 00 00 00       	jmp    801042c7 <pipewrite+0xea>
      }
      wakeup(&p->nread);
8010422a:	8b 45 08             	mov    0x8(%ebp),%eax
8010422d:	05 34 02 00 00       	add    $0x234,%eax
80104232:	89 04 24             	mov    %eax,(%esp)
80104235:	e8 1c 0b 00 00       	call   80104d56 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010423a:	8b 45 08             	mov    0x8(%ebp),%eax
8010423d:	8b 55 08             	mov    0x8(%ebp),%edx
80104240:	81 c2 38 02 00 00    	add    $0x238,%edx
80104246:	89 44 24 04          	mov    %eax,0x4(%esp)
8010424a:	89 14 24             	mov    %edx,(%esp)
8010424d:	e8 28 0a 00 00       	call   80104c7a <sleep>
80104252:	eb 01                	jmp    80104255 <pipewrite+0x78>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104254:	90                   	nop
80104255:	8b 45 08             	mov    0x8(%ebp),%eax
80104258:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
8010425e:	8b 45 08             	mov    0x8(%ebp),%eax
80104261:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104267:	05 00 02 00 00       	add    $0x200,%eax
8010426c:	39 c2                	cmp    %eax,%edx
8010426e:	74 8b                	je     801041fb <pipewrite+0x1e>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80104270:	8b 45 08             	mov    0x8(%ebp),%eax
80104273:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104279:	89 c3                	mov    %eax,%ebx
8010427b:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80104281:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80104284:	8b 55 0c             	mov    0xc(%ebp),%edx
80104287:	01 ca                	add    %ecx,%edx
80104289:	8a 0a                	mov    (%edx),%cl
8010428b:	8b 55 08             	mov    0x8(%ebp),%edx
8010428e:	88 4c 1a 34          	mov    %cl,0x34(%edx,%ebx,1)
80104292:	8d 50 01             	lea    0x1(%eax),%edx
80104295:	8b 45 08             	mov    0x8(%ebp),%eax
80104298:	89 90 38 02 00 00    	mov    %edx,0x238(%eax)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
8010429e:	ff 45 f4             	incl   -0xc(%ebp)
801042a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042a4:	3b 45 10             	cmp    0x10(%ebp),%eax
801042a7:	7c ab                	jl     80104254 <pipewrite+0x77>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801042a9:	8b 45 08             	mov    0x8(%ebp),%eax
801042ac:	05 34 02 00 00       	add    $0x234,%eax
801042b1:	89 04 24             	mov    %eax,(%esp)
801042b4:	e8 9d 0a 00 00       	call   80104d56 <wakeup>
  release(&p->lock);
801042b9:	8b 45 08             	mov    0x8(%ebp),%eax
801042bc:	89 04 24             	mov    %eax,(%esp)
801042bf:	e8 fd 0c 00 00       	call   80104fc1 <release>
  return n;
801042c4:	8b 45 10             	mov    0x10(%ebp),%eax
}
801042c7:	83 c4 24             	add    $0x24,%esp
801042ca:	5b                   	pop    %ebx
801042cb:	5d                   	pop    %ebp
801042cc:	c3                   	ret    

801042cd <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801042cd:	55                   	push   %ebp
801042ce:	89 e5                	mov    %esp,%ebp
801042d0:	53                   	push   %ebx
801042d1:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
801042d4:	8b 45 08             	mov    0x8(%ebp),%eax
801042d7:	89 04 24             	mov    %eax,(%esp)
801042da:	e8 80 0c 00 00       	call   80104f5f <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801042df:	eb 3a                	jmp    8010431b <piperead+0x4e>
    if(proc->killed){
801042e1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042e7:	8b 40 24             	mov    0x24(%eax),%eax
801042ea:	85 c0                	test   %eax,%eax
801042ec:	74 15                	je     80104303 <piperead+0x36>
      release(&p->lock);
801042ee:	8b 45 08             	mov    0x8(%ebp),%eax
801042f1:	89 04 24             	mov    %eax,(%esp)
801042f4:	e8 c8 0c 00 00       	call   80104fc1 <release>
      return -1;
801042f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801042fe:	e9 b5 00 00 00       	jmp    801043b8 <piperead+0xeb>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80104303:	8b 45 08             	mov    0x8(%ebp),%eax
80104306:	8b 55 08             	mov    0x8(%ebp),%edx
80104309:	81 c2 34 02 00 00    	add    $0x234,%edx
8010430f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104313:	89 14 24             	mov    %edx,(%esp)
80104316:	e8 5f 09 00 00       	call   80104c7a <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010431b:	8b 45 08             	mov    0x8(%ebp),%eax
8010431e:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104324:	8b 45 08             	mov    0x8(%ebp),%eax
80104327:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010432d:	39 c2                	cmp    %eax,%edx
8010432f:	75 0d                	jne    8010433e <piperead+0x71>
80104331:	8b 45 08             	mov    0x8(%ebp),%eax
80104334:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
8010433a:	85 c0                	test   %eax,%eax
8010433c:	75 a3                	jne    801042e1 <piperead+0x14>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010433e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104345:	eb 48                	jmp    8010438f <piperead+0xc2>
    if(p->nread == p->nwrite)
80104347:	8b 45 08             	mov    0x8(%ebp),%eax
8010434a:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104350:	8b 45 08             	mov    0x8(%ebp),%eax
80104353:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104359:	39 c2                	cmp    %eax,%edx
8010435b:	74 3c                	je     80104399 <piperead+0xcc>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010435d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104360:	8b 45 0c             	mov    0xc(%ebp),%eax
80104363:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80104366:	8b 45 08             	mov    0x8(%ebp),%eax
80104369:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
8010436f:	89 c3                	mov    %eax,%ebx
80104371:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80104377:	8b 55 08             	mov    0x8(%ebp),%edx
8010437a:	8a 54 1a 34          	mov    0x34(%edx,%ebx,1),%dl
8010437e:	88 11                	mov    %dl,(%ecx)
80104380:	8d 50 01             	lea    0x1(%eax),%edx
80104383:	8b 45 08             	mov    0x8(%ebp),%eax
80104386:	89 90 34 02 00 00    	mov    %edx,0x234(%eax)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010438c:	ff 45 f4             	incl   -0xc(%ebp)
8010438f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104392:	3b 45 10             	cmp    0x10(%ebp),%eax
80104395:	7c b0                	jl     80104347 <piperead+0x7a>
80104397:	eb 01                	jmp    8010439a <piperead+0xcd>
    if(p->nread == p->nwrite)
      break;
80104399:	90                   	nop
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010439a:	8b 45 08             	mov    0x8(%ebp),%eax
8010439d:	05 38 02 00 00       	add    $0x238,%eax
801043a2:	89 04 24             	mov    %eax,(%esp)
801043a5:	e8 ac 09 00 00       	call   80104d56 <wakeup>
  release(&p->lock);
801043aa:	8b 45 08             	mov    0x8(%ebp),%eax
801043ad:	89 04 24             	mov    %eax,(%esp)
801043b0:	e8 0c 0c 00 00       	call   80104fc1 <release>
  return i;
801043b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801043b8:	83 c4 24             	add    $0x24,%esp
801043bb:	5b                   	pop    %ebx
801043bc:	5d                   	pop    %ebp
801043bd:	c3                   	ret    
801043be:	66 90                	xchg   %ax,%ax

801043c0 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
801043c0:	55                   	push   %ebp
801043c1:	89 e5                	mov    %esp,%ebp
801043c3:	53                   	push   %ebx
801043c4:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801043c7:	9c                   	pushf  
801043c8:	5b                   	pop    %ebx
801043c9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return eflags;
801043cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
801043cf:	83 c4 10             	add    $0x10,%esp
801043d2:	5b                   	pop    %ebx
801043d3:	5d                   	pop    %ebp
801043d4:	c3                   	ret    

801043d5 <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
801043d5:	55                   	push   %ebp
801043d6:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801043d8:	fb                   	sti    
}
801043d9:	5d                   	pop    %ebp
801043da:	c3                   	ret    

801043db <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
801043db:	55                   	push   %ebp
801043dc:	89 e5                	mov    %esp,%ebp
801043de:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
801043e1:	c7 44 24 04 d9 8b 10 	movl   $0x80108bd9,0x4(%esp)
801043e8:	80 
801043e9:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
801043f0:	e8 49 0b 00 00       	call   80104f3e <initlock>
}
801043f5:	c9                   	leave  
801043f6:	c3                   	ret    

801043f7 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801043f7:	55                   	push   %ebp
801043f8:	89 e5                	mov    %esp,%ebp
801043fa:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
801043fd:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104404:	e8 56 0b 00 00       	call   80104f5f <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104409:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104410:	eb 11                	jmp    80104423 <allocproc+0x2c>
    if(p->state == UNUSED)
80104412:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104415:	8b 40 0c             	mov    0xc(%eax),%eax
80104418:	85 c0                	test   %eax,%eax
8010441a:	74 26                	je     80104442 <allocproc+0x4b>
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010441c:	81 45 f4 08 01 00 00 	addl   $0x108,-0xc(%ebp)
80104423:	81 7d f4 b4 7b 11 80 	cmpl   $0x80117bb4,-0xc(%ebp)
8010442a:	72 e6                	jb     80104412 <allocproc+0x1b>
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
8010442c:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104433:	e8 89 0b 00 00       	call   80104fc1 <release>
  return 0;
80104438:	b8 00 00 00 00       	mov    $0x0,%eax
8010443d:	e9 04 01 00 00       	jmp    80104546 <allocproc+0x14f>
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
80104443:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104446:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
8010444d:	a1 04 c0 10 80       	mov    0x8010c004,%eax
80104452:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104455:	89 42 10             	mov    %eax,0x10(%edx)
80104458:	40                   	inc    %eax
80104459:	a3 04 c0 10 80       	mov    %eax,0x8010c004

  // Signal Handling
  int i = 0;
8010445e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(i = 0; i < 32; i++) // For the array of signal handlers
80104465:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010446c:	eb 14                	jmp    80104482 <allocproc+0x8b>
	p->handlers[i] = -1; // Initialize them all to -1
8010446e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104471:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104474:	83 c2 1c             	add    $0x1c,%edx
80104477:	c7 44 90 0c ff ff ff 	movl   $0xffffffff,0xc(%eax,%edx,4)
8010447e:	ff 
  p->state = EMBRYO;
  p->pid = nextpid++;

  // Signal Handling
  int i = 0;
  for(i = 0; i < 32; i++) // For the array of signal handlers
8010447f:	ff 45 f0             	incl   -0x10(%ebp)
80104482:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
80104486:	7e e6                	jle    8010446e <allocproc+0x77>
	p->handlers[i] = -1; // Initialize them all to -1
  release(&ptable.lock);
80104488:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
8010448f:	e8 2d 0b 00 00       	call   80104fc1 <release>


  // Alarm Signal Call 
  p->numberOfTicks = 0; // Initialize the number of ticks to 0
80104494:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104497:	c7 80 00 01 00 00 00 	movl   $0x0,0x100(%eax)
8010449e:	00 00 00 
  p->alarmState = -1; // Initial the alarm state
801044a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044a4:	c7 80 fc 00 00 00 ff 	movl   $0xffffffff,0xfc(%eax)
801044ab:	ff ff ff 
  p->trampoline = -1; 
801044ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044b1:	c7 80 04 01 00 00 ff 	movl   $0xffffffff,0x104(%eax)
801044b8:	ff ff ff 

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801044bb:	e8 b3 e6 ff ff       	call   80102b73 <kalloc>
801044c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801044c3:	89 42 08             	mov    %eax,0x8(%edx)
801044c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044c9:	8b 40 08             	mov    0x8(%eax),%eax
801044cc:	85 c0                	test   %eax,%eax
801044ce:	75 11                	jne    801044e1 <allocproc+0xea>
    p->state = UNUSED;
801044d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044d3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
801044da:	b8 00 00 00 00       	mov    $0x0,%eax
801044df:	eb 65                	jmp    80104546 <allocproc+0x14f>
  }
  sp = p->kstack + KSTACKSIZE;
801044e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044e4:	8b 40 08             	mov    0x8(%eax),%eax
801044e7:	05 00 10 00 00       	add    $0x1000,%eax
801044ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801044ef:	83 6d ec 4c          	subl   $0x4c,-0x14(%ebp)
  p->tf = (struct trapframe*)sp;
801044f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044f6:	8b 55 ec             	mov    -0x14(%ebp),%edx
801044f9:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
801044fc:	83 6d ec 04          	subl   $0x4,-0x14(%ebp)
  *(uint*)sp = (uint)trapret;
80104500:	ba cc 66 10 80       	mov    $0x801066cc,%edx
80104505:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104508:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
8010450a:	83 6d ec 14          	subl   $0x14,-0x14(%ebp)
  p->context = (struct context*)sp;
8010450e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104511:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104514:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
80104517:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010451a:	8b 40 1c             	mov    0x1c(%eax),%eax
8010451d:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104524:	00 
80104525:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010452c:	00 
8010452d:	89 04 24             	mov    %eax,(%esp)
80104530:	e8 7d 0c 00 00       	call   801051b2 <memset>
  p->context->eip = (uint)forkret;
80104535:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104538:	8b 40 1c             	mov    0x1c(%eax),%eax
8010453b:	ba 3b 4c 10 80       	mov    $0x80104c3b,%edx
80104540:	89 50 10             	mov    %edx,0x10(%eax)



  return p;
80104543:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104546:	c9                   	leave  
80104547:	c3                   	ret    

80104548 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80104548:	55                   	push   %ebp
80104549:	89 e5                	mov    %esp,%ebp
8010454b:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
8010454e:	e8 a4 fe ff ff       	call   801043f7 <allocproc>
80104553:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
80104556:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104559:	a3 68 c6 10 80       	mov    %eax,0x8010c668
  if((p->pgdir = setupkvm()) == 0)
8010455e:	e8 c5 3a 00 00       	call   80108028 <setupkvm>
80104563:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104566:	89 42 04             	mov    %eax,0x4(%edx)
80104569:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010456c:	8b 40 04             	mov    0x4(%eax),%eax
8010456f:	85 c0                	test   %eax,%eax
80104571:	75 0c                	jne    8010457f <userinit+0x37>
    panic("userinit: out of memory?");
80104573:	c7 04 24 e0 8b 10 80 	movl   $0x80108be0,(%esp)
8010457a:	e8 b7 bf ff ff       	call   80100536 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
8010457f:	ba 2c 00 00 00       	mov    $0x2c,%edx
80104584:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104587:	8b 40 04             	mov    0x4(%eax),%eax
8010458a:	89 54 24 08          	mov    %edx,0x8(%esp)
8010458e:	c7 44 24 04 00 c5 10 	movl   $0x8010c500,0x4(%esp)
80104595:	80 
80104596:	89 04 24             	mov    %eax,(%esp)
80104599:	e8 d6 3c 00 00       	call   80108274 <inituvm>
  p->sz = PGSIZE;
8010459e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045a1:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
801045a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045aa:	8b 40 18             	mov    0x18(%eax),%eax
801045ad:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
801045b4:	00 
801045b5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801045bc:	00 
801045bd:	89 04 24             	mov    %eax,(%esp)
801045c0:	e8 ed 0b 00 00       	call   801051b2 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801045c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045c8:	8b 40 18             	mov    0x18(%eax),%eax
801045cb:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801045d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045d4:	8b 40 18             	mov    0x18(%eax),%eax
801045d7:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
801045dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045e0:	8b 50 18             	mov    0x18(%eax),%edx
801045e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045e6:	8b 40 18             	mov    0x18(%eax),%eax
801045e9:	8b 40 2c             	mov    0x2c(%eax),%eax
801045ec:	66 89 42 28          	mov    %ax,0x28(%edx)
  p->tf->ss = p->tf->ds;
801045f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045f3:	8b 50 18             	mov    0x18(%eax),%edx
801045f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045f9:	8b 40 18             	mov    0x18(%eax),%eax
801045fc:	8b 40 2c             	mov    0x2c(%eax),%eax
801045ff:	66 89 42 48          	mov    %ax,0x48(%edx)
  p->tf->eflags = FL_IF;
80104603:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104606:	8b 40 18             	mov    0x18(%eax),%eax
80104609:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104610:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104613:	8b 40 18             	mov    0x18(%eax),%eax
80104616:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
8010461d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104620:	8b 40 18             	mov    0x18(%eax),%eax
80104623:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
8010462a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010462d:	83 c0 6c             	add    $0x6c,%eax
80104630:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104637:	00 
80104638:	c7 44 24 04 f9 8b 10 	movl   $0x80108bf9,0x4(%esp)
8010463f:	80 
80104640:	89 04 24             	mov    %eax,(%esp)
80104643:	e8 7c 0d 00 00       	call   801053c4 <safestrcpy>
  p->cwd = namei("/");
80104648:	c7 04 24 02 8c 10 80 	movl   $0x80108c02,(%esp)
8010464f:	e8 03 de ff ff       	call   80102457 <namei>
80104654:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104657:	89 42 68             	mov    %eax,0x68(%edx)

  p->state = RUNNABLE;
8010465a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010465d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
}
80104664:	c9                   	leave  
80104665:	c3                   	ret    

80104666 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80104666:	55                   	push   %ebp
80104667:	89 e5                	mov    %esp,%ebp
80104669:	83 ec 28             	sub    $0x28,%esp
  uint sz;
  
  sz = proc->sz;
8010466c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104672:	8b 00                	mov    (%eax),%eax
80104674:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
80104677:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010467b:	7e 34                	jle    801046b1 <growproc+0x4b>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
8010467d:	8b 55 08             	mov    0x8(%ebp),%edx
80104680:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104683:	01 c2                	add    %eax,%edx
80104685:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010468b:	8b 40 04             	mov    0x4(%eax),%eax
8010468e:	89 54 24 08          	mov    %edx,0x8(%esp)
80104692:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104695:	89 54 24 04          	mov    %edx,0x4(%esp)
80104699:	89 04 24             	mov    %eax,(%esp)
8010469c:	e8 4d 3d 00 00       	call   801083ee <allocuvm>
801046a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
801046a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801046a8:	75 41                	jne    801046eb <growproc+0x85>
      return -1;
801046aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046af:	eb 58                	jmp    80104709 <growproc+0xa3>
  } else if(n < 0){
801046b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801046b5:	79 34                	jns    801046eb <growproc+0x85>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
801046b7:	8b 55 08             	mov    0x8(%ebp),%edx
801046ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046bd:	01 c2                	add    %eax,%edx
801046bf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046c5:	8b 40 04             	mov    0x4(%eax),%eax
801046c8:	89 54 24 08          	mov    %edx,0x8(%esp)
801046cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801046cf:	89 54 24 04          	mov    %edx,0x4(%esp)
801046d3:	89 04 24             	mov    %eax,(%esp)
801046d6:	e8 ed 3d 00 00       	call   801084c8 <deallocuvm>
801046db:	89 45 f4             	mov    %eax,-0xc(%ebp)
801046de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801046e2:	75 07                	jne    801046eb <growproc+0x85>
      return -1;
801046e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046e9:	eb 1e                	jmp    80104709 <growproc+0xa3>
  }
  proc->sz = sz;
801046eb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801046f4:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
801046f6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046fc:	89 04 24             	mov    %eax,(%esp)
801046ff:	e8 15 3a 00 00       	call   80108119 <switchuvm>
  return 0;
80104704:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104709:	c9                   	leave  
8010470a:	c3                   	ret    

8010470b <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
8010470b:	55                   	push   %ebp
8010470c:	89 e5                	mov    %esp,%ebp
8010470e:	57                   	push   %edi
8010470f:	56                   	push   %esi
80104710:	53                   	push   %ebx
80104711:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
80104714:	e8 de fc ff ff       	call   801043f7 <allocproc>
80104719:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010471c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80104720:	75 0a                	jne    8010472c <fork+0x21>
    return -1;
80104722:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104727:	e9 51 01 00 00       	jmp    8010487d <fork+0x172>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
8010472c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104732:	8b 10                	mov    (%eax),%edx
80104734:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010473a:	8b 40 04             	mov    0x4(%eax),%eax
8010473d:	89 54 24 04          	mov    %edx,0x4(%esp)
80104741:	89 04 24             	mov    %eax,(%esp)
80104744:	e8 1a 3f 00 00       	call   80108663 <copyuvm>
80104749:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010474c:	89 42 04             	mov    %eax,0x4(%edx)
8010474f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104752:	8b 40 04             	mov    0x4(%eax),%eax
80104755:	85 c0                	test   %eax,%eax
80104757:	75 2c                	jne    80104785 <fork+0x7a>
    kfree(np->kstack);
80104759:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010475c:	8b 40 08             	mov    0x8(%eax),%eax
8010475f:	89 04 24             	mov    %eax,(%esp)
80104762:	e8 73 e3 ff ff       	call   80102ada <kfree>
    np->kstack = 0;
80104767:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010476a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
80104771:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104774:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
8010477b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104780:	e9 f8 00 00 00       	jmp    8010487d <fork+0x172>
  }
  np->sz = proc->sz;
80104785:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010478b:	8b 10                	mov    (%eax),%edx
8010478d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104790:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
80104792:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104799:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010479c:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
8010479f:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047a2:	8b 50 18             	mov    0x18(%eax),%edx
801047a5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047ab:	8b 40 18             	mov    0x18(%eax),%eax
801047ae:	89 c3                	mov    %eax,%ebx
801047b0:	b8 13 00 00 00       	mov    $0x13,%eax
801047b5:	89 d7                	mov    %edx,%edi
801047b7:	89 de                	mov    %ebx,%esi
801047b9:	89 c1                	mov    %eax,%ecx
801047bb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
801047bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047c0:	8b 40 18             	mov    0x18(%eax),%eax
801047c3:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
801047ca:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801047d1:	eb 3c                	jmp    8010480f <fork+0x104>
    if(proc->ofile[i])
801047d3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047d9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801047dc:	83 c2 08             	add    $0x8,%edx
801047df:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801047e3:	85 c0                	test   %eax,%eax
801047e5:	74 25                	je     8010480c <fork+0x101>
      np->ofile[i] = filedup(proc->ofile[i]);
801047e7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047ed:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801047f0:	83 c2 08             	add    $0x8,%edx
801047f3:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801047f7:	89 04 24             	mov    %eax,(%esp)
801047fa:	e8 89 c7 ff ff       	call   80100f88 <filedup>
801047ff:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104802:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104805:	83 c1 08             	add    $0x8,%ecx
80104808:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
8010480c:	ff 45 e4             	incl   -0x1c(%ebp)
8010480f:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104813:	7e be                	jle    801047d3 <fork+0xc8>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
80104815:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010481b:	8b 40 68             	mov    0x68(%eax),%eax
8010481e:	89 04 24             	mov    %eax,(%esp)
80104821:	e8 5f d0 ff ff       	call   80101885 <idup>
80104826:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104829:	89 42 68             	mov    %eax,0x68(%edx)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
8010482c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104832:	8d 50 6c             	lea    0x6c(%eax),%edx
80104835:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104838:	83 c0 6c             	add    $0x6c,%eax
8010483b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104842:	00 
80104843:	89 54 24 04          	mov    %edx,0x4(%esp)
80104847:	89 04 24             	mov    %eax,(%esp)
8010484a:	e8 75 0b 00 00       	call   801053c4 <safestrcpy>
 
  pid = np->pid;
8010484f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104852:	8b 40 10             	mov    0x10(%eax),%eax
80104855:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
80104858:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
8010485f:	e8 fb 06 00 00       	call   80104f5f <acquire>
  np->state = RUNNABLE;
80104864:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104867:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  release(&ptable.lock);
8010486e:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104875:	e8 47 07 00 00       	call   80104fc1 <release>
  
  return pid;
8010487a:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
8010487d:	83 c4 2c             	add    $0x2c,%esp
80104880:	5b                   	pop    %ebx
80104881:	5e                   	pop    %esi
80104882:	5f                   	pop    %edi
80104883:	5d                   	pop    %ebp
80104884:	c3                   	ret    

80104885 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80104885:	55                   	push   %ebp
80104886:	89 e5                	mov    %esp,%ebp
80104888:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
8010488b:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104892:	a1 68 c6 10 80       	mov    0x8010c668,%eax
80104897:	39 c2                	cmp    %eax,%edx
80104899:	75 0c                	jne    801048a7 <exit+0x22>
    panic("init exiting");
8010489b:	c7 04 24 04 8c 10 80 	movl   $0x80108c04,(%esp)
801048a2:	e8 8f bc ff ff       	call   80100536 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
801048a7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801048ae:	eb 43                	jmp    801048f3 <exit+0x6e>
    if(proc->ofile[fd]){
801048b0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048b6:	8b 55 f0             	mov    -0x10(%ebp),%edx
801048b9:	83 c2 08             	add    $0x8,%edx
801048bc:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801048c0:	85 c0                	test   %eax,%eax
801048c2:	74 2c                	je     801048f0 <exit+0x6b>
      fileclose(proc->ofile[fd]);
801048c4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
801048cd:	83 c2 08             	add    $0x8,%edx
801048d0:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801048d4:	89 04 24             	mov    %eax,(%esp)
801048d7:	e8 f4 c6 ff ff       	call   80100fd0 <fileclose>
      proc->ofile[fd] = 0;
801048dc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048e2:	8b 55 f0             	mov    -0x10(%ebp),%edx
801048e5:	83 c2 08             	add    $0x8,%edx
801048e8:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801048ef:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
801048f0:	ff 45 f0             	incl   -0x10(%ebp)
801048f3:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
801048f7:	7e b7                	jle    801048b0 <exit+0x2b>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
801048f9:	e8 a9 eb ff ff       	call   801034a7 <begin_op>
  iput(proc->cwd);
801048fe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104904:	8b 40 68             	mov    0x68(%eax),%eax
80104907:	89 04 24             	mov    %eax,(%esp)
8010490a:	e8 5e d1 ff ff       	call   80101a6d <iput>
  end_op();
8010490f:	e8 12 ec ff ff       	call   80103526 <end_op>
  proc->cwd = 0;
80104914:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010491a:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104921:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104928:	e8 32 06 00 00       	call   80104f5f <acquire>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
8010492d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104933:	8b 40 14             	mov    0x14(%eax),%eax
80104936:	89 04 24             	mov    %eax,(%esp)
80104939:	e8 d7 03 00 00       	call   80104d15 <wakeup1>

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010493e:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104945:	eb 3b                	jmp    80104982 <exit+0xfd>
    if(p->parent == proc){
80104947:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010494a:	8b 50 14             	mov    0x14(%eax),%edx
8010494d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104953:	39 c2                	cmp    %eax,%edx
80104955:	75 24                	jne    8010497b <exit+0xf6>
      p->parent = initproc;
80104957:	8b 15 68 c6 10 80    	mov    0x8010c668,%edx
8010495d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104960:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80104963:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104966:	8b 40 0c             	mov    0xc(%eax),%eax
80104969:	83 f8 05             	cmp    $0x5,%eax
8010496c:	75 0d                	jne    8010497b <exit+0xf6>
        wakeup1(initproc);
8010496e:	a1 68 c6 10 80       	mov    0x8010c668,%eax
80104973:	89 04 24             	mov    %eax,(%esp)
80104976:	e8 9a 03 00 00       	call   80104d15 <wakeup1>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010497b:	81 45 f4 08 01 00 00 	addl   $0x108,-0xc(%ebp)
80104982:	81 7d f4 b4 7b 11 80 	cmpl   $0x80117bb4,-0xc(%ebp)
80104989:	72 bc                	jb     80104947 <exit+0xc2>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
8010498b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104991:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104998:	e8 ba 01 00 00       	call   80104b57 <sched>
  panic("zombie exit");
8010499d:	c7 04 24 11 8c 10 80 	movl   $0x80108c11,(%esp)
801049a4:	e8 8d bb ff ff       	call   80100536 <panic>

801049a9 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
801049a9:	55                   	push   %ebp
801049aa:	89 e5                	mov    %esp,%ebp
801049ac:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
801049af:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
801049b6:	e8 a4 05 00 00       	call   80104f5f <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
801049bb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049c2:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
801049c9:	e9 9d 00 00 00       	jmp    80104a6b <wait+0xc2>
      if(p->parent != proc)
801049ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049d1:	8b 50 14             	mov    0x14(%eax),%edx
801049d4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049da:	39 c2                	cmp    %eax,%edx
801049dc:	0f 85 81 00 00 00    	jne    80104a63 <wait+0xba>
        continue;
      havekids = 1;
801049e2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
801049e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049ec:	8b 40 0c             	mov    0xc(%eax),%eax
801049ef:	83 f8 05             	cmp    $0x5,%eax
801049f2:	75 70                	jne    80104a64 <wait+0xbb>
        // Found one.
        pid = p->pid;
801049f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049f7:	8b 40 10             	mov    0x10(%eax),%eax
801049fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
801049fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a00:	8b 40 08             	mov    0x8(%eax),%eax
80104a03:	89 04 24             	mov    %eax,(%esp)
80104a06:	e8 cf e0 ff ff       	call   80102ada <kfree>
        p->kstack = 0;
80104a0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a0e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a18:	8b 40 04             	mov    0x4(%eax),%eax
80104a1b:	89 04 24             	mov    %eax,(%esp)
80104a1e:	e8 61 3b 00 00       	call   80108584 <freevm>
        p->state = UNUSED;
80104a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a26:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
80104a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a30:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a3a:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104a41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a44:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a4b:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
80104a52:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104a59:	e8 63 05 00 00       	call   80104fc1 <release>
        return pid;
80104a5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a61:	eb 56                	jmp    80104ab9 <wait+0x110>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
80104a63:	90                   	nop

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a64:	81 45 f4 08 01 00 00 	addl   $0x108,-0xc(%ebp)
80104a6b:	81 7d f4 b4 7b 11 80 	cmpl   $0x80117bb4,-0xc(%ebp)
80104a72:	0f 82 56 ff ff ff    	jb     801049ce <wait+0x25>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104a78:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104a7c:	74 0d                	je     80104a8b <wait+0xe2>
80104a7e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a84:	8b 40 24             	mov    0x24(%eax),%eax
80104a87:	85 c0                	test   %eax,%eax
80104a89:	74 13                	je     80104a9e <wait+0xf5>
      release(&ptable.lock);
80104a8b:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104a92:	e8 2a 05 00 00       	call   80104fc1 <release>
      return -1;
80104a97:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a9c:	eb 1b                	jmp    80104ab9 <wait+0x110>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104a9e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104aa4:	c7 44 24 04 80 39 11 	movl   $0x80113980,0x4(%esp)
80104aab:	80 
80104aac:	89 04 24             	mov    %eax,(%esp)
80104aaf:	e8 c6 01 00 00       	call   80104c7a <sleep>
  }
80104ab4:	e9 02 ff ff ff       	jmp    801049bb <wait+0x12>
}
80104ab9:	c9                   	leave  
80104aba:	c3                   	ret    

80104abb <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80104abb:	55                   	push   %ebp
80104abc:	89 e5                	mov    %esp,%ebp
80104abe:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  for(;;){
    // Enable interrupts on this processor.
    sti();
80104ac1:	e8 0f f9 ff ff       	call   801043d5 <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104ac6:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104acd:	e8 8d 04 00 00       	call   80104f5f <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ad2:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104ad9:	eb 62                	jmp    80104b3d <scheduler+0x82>
      if(p->state != RUNNABLE)
80104adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ade:	8b 40 0c             	mov    0xc(%eax),%eax
80104ae1:	83 f8 03             	cmp    $0x3,%eax
80104ae4:	75 4f                	jne    80104b35 <scheduler+0x7a>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
80104ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ae9:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
80104aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104af2:	89 04 24             	mov    %eax,(%esp)
80104af5:	e8 1f 36 00 00       	call   80108119 <switchuvm>
      p->state = RUNNING;
80104afa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104afd:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
      swtch(&cpu->scheduler, proc->context);
80104b04:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b0a:	8b 40 1c             	mov    0x1c(%eax),%eax
80104b0d:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104b14:	83 c2 04             	add    $0x4,%edx
80104b17:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b1b:	89 14 24             	mov    %edx,(%esp)
80104b1e:	e8 11 09 00 00       	call   80105434 <swtch>
      switchkvm();
80104b23:	e8 d4 35 00 00       	call   801080fc <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80104b28:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104b2f:	00 00 00 00 
80104b33:	eb 01                	jmp    80104b36 <scheduler+0x7b>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;
80104b35:	90                   	nop
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b36:	81 45 f4 08 01 00 00 	addl   $0x108,-0xc(%ebp)
80104b3d:	81 7d f4 b4 7b 11 80 	cmpl   $0x80117bb4,-0xc(%ebp)
80104b44:	72 95                	jb     80104adb <scheduler+0x20>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
80104b46:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104b4d:	e8 6f 04 00 00       	call   80104fc1 <release>

  }
80104b52:	e9 6a ff ff ff       	jmp    80104ac1 <scheduler+0x6>

80104b57 <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
80104b57:	55                   	push   %ebp
80104b58:	89 e5                	mov    %esp,%ebp
80104b5a:	83 ec 28             	sub    $0x28,%esp
  int intena;

  if(!holding(&ptable.lock))
80104b5d:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104b64:	e8 1e 05 00 00       	call   80105087 <holding>
80104b69:	85 c0                	test   %eax,%eax
80104b6b:	75 0c                	jne    80104b79 <sched+0x22>
    panic("sched ptable.lock");
80104b6d:	c7 04 24 1d 8c 10 80 	movl   $0x80108c1d,(%esp)
80104b74:	e8 bd b9 ff ff       	call   80100536 <panic>
  if(cpu->ncli != 1)
80104b79:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104b7f:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104b85:	83 f8 01             	cmp    $0x1,%eax
80104b88:	74 0c                	je     80104b96 <sched+0x3f>
    panic("sched locks");
80104b8a:	c7 04 24 2f 8c 10 80 	movl   $0x80108c2f,(%esp)
80104b91:	e8 a0 b9 ff ff       	call   80100536 <panic>
  if(proc->state == RUNNING)
80104b96:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b9c:	8b 40 0c             	mov    0xc(%eax),%eax
80104b9f:	83 f8 04             	cmp    $0x4,%eax
80104ba2:	75 0c                	jne    80104bb0 <sched+0x59>
    panic("sched running");
80104ba4:	c7 04 24 3b 8c 10 80 	movl   $0x80108c3b,(%esp)
80104bab:	e8 86 b9 ff ff       	call   80100536 <panic>
  if(readeflags()&FL_IF)
80104bb0:	e8 0b f8 ff ff       	call   801043c0 <readeflags>
80104bb5:	25 00 02 00 00       	and    $0x200,%eax
80104bba:	85 c0                	test   %eax,%eax
80104bbc:	74 0c                	je     80104bca <sched+0x73>
    panic("sched interruptible");
80104bbe:	c7 04 24 49 8c 10 80 	movl   $0x80108c49,(%esp)
80104bc5:	e8 6c b9 ff ff       	call   80100536 <panic>
  intena = cpu->intena;
80104bca:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104bd0:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104bd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
80104bd9:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104bdf:	8b 40 04             	mov    0x4(%eax),%eax
80104be2:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104be9:	83 c2 1c             	add    $0x1c,%edx
80104bec:	89 44 24 04          	mov    %eax,0x4(%esp)
80104bf0:	89 14 24             	mov    %edx,(%esp)
80104bf3:	e8 3c 08 00 00       	call   80105434 <swtch>
  cpu->intena = intena;
80104bf8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104bfe:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104c01:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104c07:	c9                   	leave  
80104c08:	c3                   	ret    

80104c09 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104c09:	55                   	push   %ebp
80104c0a:	89 e5                	mov    %esp,%ebp
80104c0c:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104c0f:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104c16:	e8 44 03 00 00       	call   80104f5f <acquire>
  proc->state = RUNNABLE;
80104c1b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c21:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104c28:	e8 2a ff ff ff       	call   80104b57 <sched>
  release(&ptable.lock);
80104c2d:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104c34:	e8 88 03 00 00       	call   80104fc1 <release>
}
80104c39:	c9                   	leave  
80104c3a:	c3                   	ret    

80104c3b <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104c3b:	55                   	push   %ebp
80104c3c:	89 e5                	mov    %esp,%ebp
80104c3e:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104c41:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104c48:	e8 74 03 00 00       	call   80104fc1 <release>

  if (first) {
80104c4d:	a1 20 c0 10 80       	mov    0x8010c020,%eax
80104c52:	85 c0                	test   %eax,%eax
80104c54:	74 22                	je     80104c78 <forkret+0x3d>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
80104c56:	c7 05 20 c0 10 80 00 	movl   $0x0,0x8010c020
80104c5d:	00 00 00 
    iinit(ROOTDEV);
80104c60:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104c67:	e8 25 c9 ff ff       	call   80101591 <iinit>
    initlog(ROOTDEV);
80104c6c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104c73:	e8 30 e6 ff ff       	call   801032a8 <initlog>
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
80104c78:	c9                   	leave  
80104c79:	c3                   	ret    

80104c7a <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104c7a:	55                   	push   %ebp
80104c7b:	89 e5                	mov    %esp,%ebp
80104c7d:	83 ec 18             	sub    $0x18,%esp
  if(proc == 0)
80104c80:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c86:	85 c0                	test   %eax,%eax
80104c88:	75 0c                	jne    80104c96 <sleep+0x1c>
    panic("sleep");
80104c8a:	c7 04 24 5d 8c 10 80 	movl   $0x80108c5d,(%esp)
80104c91:	e8 a0 b8 ff ff       	call   80100536 <panic>

  if(lk == 0)
80104c96:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104c9a:	75 0c                	jne    80104ca8 <sleep+0x2e>
    panic("sleep without lk");
80104c9c:	c7 04 24 63 8c 10 80 	movl   $0x80108c63,(%esp)
80104ca3:	e8 8e b8 ff ff       	call   80100536 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104ca8:	81 7d 0c 80 39 11 80 	cmpl   $0x80113980,0xc(%ebp)
80104caf:	74 17                	je     80104cc8 <sleep+0x4e>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104cb1:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104cb8:	e8 a2 02 00 00       	call   80104f5f <acquire>
    release(lk);
80104cbd:	8b 45 0c             	mov    0xc(%ebp),%eax
80104cc0:	89 04 24             	mov    %eax,(%esp)
80104cc3:	e8 f9 02 00 00       	call   80104fc1 <release>
  }

  // Go to sleep.
  proc->chan = chan;
80104cc8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cce:	8b 55 08             	mov    0x8(%ebp),%edx
80104cd1:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
80104cd4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cda:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80104ce1:	e8 71 fe ff ff       	call   80104b57 <sched>

  // Tidy up.
  proc->chan = 0;
80104ce6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cec:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104cf3:	81 7d 0c 80 39 11 80 	cmpl   $0x80113980,0xc(%ebp)
80104cfa:	74 17                	je     80104d13 <sleep+0x99>
    release(&ptable.lock);
80104cfc:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104d03:	e8 b9 02 00 00       	call   80104fc1 <release>
    acquire(lk);
80104d08:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d0b:	89 04 24             	mov    %eax,(%esp)
80104d0e:	e8 4c 02 00 00       	call   80104f5f <acquire>
  }
}
80104d13:	c9                   	leave  
80104d14:	c3                   	ret    

80104d15 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104d15:	55                   	push   %ebp
80104d16:	89 e5                	mov    %esp,%ebp
80104d18:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d1b:	c7 45 fc b4 39 11 80 	movl   $0x801139b4,-0x4(%ebp)
80104d22:	eb 27                	jmp    80104d4b <wakeup1+0x36>
    if(p->state == SLEEPING && p->chan == chan)
80104d24:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d27:	8b 40 0c             	mov    0xc(%eax),%eax
80104d2a:	83 f8 02             	cmp    $0x2,%eax
80104d2d:	75 15                	jne    80104d44 <wakeup1+0x2f>
80104d2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d32:	8b 40 20             	mov    0x20(%eax),%eax
80104d35:	3b 45 08             	cmp    0x8(%ebp),%eax
80104d38:	75 0a                	jne    80104d44 <wakeup1+0x2f>
      p->state = RUNNABLE;
80104d3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d3d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d44:	81 45 fc 08 01 00 00 	addl   $0x108,-0x4(%ebp)
80104d4b:	81 7d fc b4 7b 11 80 	cmpl   $0x80117bb4,-0x4(%ebp)
80104d52:	72 d0                	jb     80104d24 <wakeup1+0xf>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
80104d54:	c9                   	leave  
80104d55:	c3                   	ret    

80104d56 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104d56:	55                   	push   %ebp
80104d57:	89 e5                	mov    %esp,%ebp
80104d59:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80104d5c:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104d63:	e8 f7 01 00 00       	call   80104f5f <acquire>
  wakeup1(chan);
80104d68:	8b 45 08             	mov    0x8(%ebp),%eax
80104d6b:	89 04 24             	mov    %eax,(%esp)
80104d6e:	e8 a2 ff ff ff       	call   80104d15 <wakeup1>
  release(&ptable.lock);
80104d73:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104d7a:	e8 42 02 00 00       	call   80104fc1 <release>
}
80104d7f:	c9                   	leave  
80104d80:	c3                   	ret    

80104d81 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104d81:	55                   	push   %ebp
80104d82:	89 e5                	mov    %esp,%ebp
80104d84:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104d87:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104d8e:	e8 cc 01 00 00       	call   80104f5f <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d93:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104d9a:	eb 44                	jmp    80104de0 <kill+0x5f>
    if(p->pid == pid){
80104d9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d9f:	8b 40 10             	mov    0x10(%eax),%eax
80104da2:	3b 45 08             	cmp    0x8(%ebp),%eax
80104da5:	75 32                	jne    80104dd9 <kill+0x58>
      p->killed = 1;
80104da7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104daa:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104db1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104db4:	8b 40 0c             	mov    0xc(%eax),%eax
80104db7:	83 f8 02             	cmp    $0x2,%eax
80104dba:	75 0a                	jne    80104dc6 <kill+0x45>
        p->state = RUNNABLE;
80104dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dbf:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104dc6:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104dcd:	e8 ef 01 00 00       	call   80104fc1 <release>
      return 0;
80104dd2:	b8 00 00 00 00       	mov    $0x0,%eax
80104dd7:	eb 21                	jmp    80104dfa <kill+0x79>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104dd9:	81 45 f4 08 01 00 00 	addl   $0x108,-0xc(%ebp)
80104de0:	81 7d f4 b4 7b 11 80 	cmpl   $0x80117bb4,-0xc(%ebp)
80104de7:	72 b3                	jb     80104d9c <kill+0x1b>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104de9:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104df0:	e8 cc 01 00 00       	call   80104fc1 <release>
  return -1;
80104df5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104dfa:	c9                   	leave  
80104dfb:	c3                   	ret    

80104dfc <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104dfc:	55                   	push   %ebp
80104dfd:	89 e5                	mov    %esp,%ebp
80104dff:	83 ec 58             	sub    $0x58,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e02:	c7 45 f0 b4 39 11 80 	movl   $0x801139b4,-0x10(%ebp)
80104e09:	e9 da 00 00 00       	jmp    80104ee8 <procdump+0xec>
    if(p->state == UNUSED)
80104e0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e11:	8b 40 0c             	mov    0xc(%eax),%eax
80104e14:	85 c0                	test   %eax,%eax
80104e16:	0f 84 c4 00 00 00    	je     80104ee0 <procdump+0xe4>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104e1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e1f:	8b 40 0c             	mov    0xc(%eax),%eax
80104e22:	83 f8 05             	cmp    $0x5,%eax
80104e25:	77 23                	ja     80104e4a <procdump+0x4e>
80104e27:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e2a:	8b 40 0c             	mov    0xc(%eax),%eax
80104e2d:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
80104e34:	85 c0                	test   %eax,%eax
80104e36:	74 12                	je     80104e4a <procdump+0x4e>
      state = states[p->state];
80104e38:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e3b:	8b 40 0c             	mov    0xc(%eax),%eax
80104e3e:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
80104e45:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104e48:	eb 07                	jmp    80104e51 <procdump+0x55>
    else
      state = "???";
80104e4a:	c7 45 ec 74 8c 10 80 	movl   $0x80108c74,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80104e51:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e54:	8d 50 6c             	lea    0x6c(%eax),%edx
80104e57:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e5a:	8b 40 10             	mov    0x10(%eax),%eax
80104e5d:	89 54 24 0c          	mov    %edx,0xc(%esp)
80104e61:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104e64:	89 54 24 08          	mov    %edx,0x8(%esp)
80104e68:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e6c:	c7 04 24 78 8c 10 80 	movl   $0x80108c78,(%esp)
80104e73:	e8 29 b5 ff ff       	call   801003a1 <cprintf>
    if(p->state == SLEEPING){
80104e78:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e7b:	8b 40 0c             	mov    0xc(%eax),%eax
80104e7e:	83 f8 02             	cmp    $0x2,%eax
80104e81:	75 4f                	jne    80104ed2 <procdump+0xd6>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104e83:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e86:	8b 40 1c             	mov    0x1c(%eax),%eax
80104e89:	8b 40 0c             	mov    0xc(%eax),%eax
80104e8c:	83 c0 08             	add    $0x8,%eax
80104e8f:	8d 55 c4             	lea    -0x3c(%ebp),%edx
80104e92:	89 54 24 04          	mov    %edx,0x4(%esp)
80104e96:	89 04 24             	mov    %eax,(%esp)
80104e99:	e8 72 01 00 00       	call   80105010 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104e9e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104ea5:	eb 1a                	jmp    80104ec1 <procdump+0xc5>
        cprintf(" %p", pc[i]);
80104ea7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104eaa:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104eae:	89 44 24 04          	mov    %eax,0x4(%esp)
80104eb2:	c7 04 24 81 8c 10 80 	movl   $0x80108c81,(%esp)
80104eb9:	e8 e3 b4 ff ff       	call   801003a1 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104ebe:	ff 45 f4             	incl   -0xc(%ebp)
80104ec1:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104ec5:	7f 0b                	jg     80104ed2 <procdump+0xd6>
80104ec7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104eca:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104ece:	85 c0                	test   %eax,%eax
80104ed0:	75 d5                	jne    80104ea7 <procdump+0xab>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104ed2:	c7 04 24 85 8c 10 80 	movl   $0x80108c85,(%esp)
80104ed9:	e8 c3 b4 ff ff       	call   801003a1 <cprintf>
80104ede:	eb 01                	jmp    80104ee1 <procdump+0xe5>
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
80104ee0:	90                   	nop
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ee1:	81 45 f0 08 01 00 00 	addl   $0x108,-0x10(%ebp)
80104ee8:	81 7d f0 b4 7b 11 80 	cmpl   $0x80117bb4,-0x10(%ebp)
80104eef:	0f 82 19 ff ff ff    	jb     80104e0e <procdump+0x12>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104ef5:	c9                   	leave  
80104ef6:	c3                   	ret    
80104ef7:	90                   	nop

80104ef8 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80104ef8:	55                   	push   %ebp
80104ef9:	89 e5                	mov    %esp,%ebp
80104efb:	53                   	push   %ebx
80104efc:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104eff:	9c                   	pushf  
80104f00:	5b                   	pop    %ebx
80104f01:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return eflags;
80104f04:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80104f07:	83 c4 10             	add    $0x10,%esp
80104f0a:	5b                   	pop    %ebx
80104f0b:	5d                   	pop    %ebp
80104f0c:	c3                   	ret    

80104f0d <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80104f0d:	55                   	push   %ebp
80104f0e:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80104f10:	fa                   	cli    
}
80104f11:	5d                   	pop    %ebp
80104f12:	c3                   	ret    

80104f13 <sti>:

static inline void
sti(void)
{
80104f13:	55                   	push   %ebp
80104f14:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104f16:	fb                   	sti    
}
80104f17:	5d                   	pop    %ebp
80104f18:	c3                   	ret    

80104f19 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80104f19:	55                   	push   %ebp
80104f1a:	89 e5                	mov    %esp,%ebp
80104f1c:	53                   	push   %ebx
80104f1d:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
               "+m" (*addr), "=a" (result) :
80104f20:	8b 55 08             	mov    0x8(%ebp),%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104f23:	8b 45 0c             	mov    0xc(%ebp),%eax
               "+m" (*addr), "=a" (result) :
80104f26:	8b 4d 08             	mov    0x8(%ebp),%ecx
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104f29:	89 c3                	mov    %eax,%ebx
80104f2b:	89 d8                	mov    %ebx,%eax
80104f2d:	f0 87 02             	lock xchg %eax,(%edx)
80104f30:	89 c3                	mov    %eax,%ebx
80104f32:	89 5d f8             	mov    %ebx,-0x8(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80104f35:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80104f38:	83 c4 10             	add    $0x10,%esp
80104f3b:	5b                   	pop    %ebx
80104f3c:	5d                   	pop    %ebp
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
80104f79:	c7 04 24 b1 8c 10 80 	movl   $0x80108cb1,(%esp)
80104f80:	e8 b1 b5 ff ff       	call   80100536 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80104f85:	90                   	nop
80104f86:	8b 45 08             	mov    0x8(%ebp),%eax
80104f89:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80104f90:	00 
80104f91:	89 04 24             	mov    %eax,(%esp)
80104f94:	e8 80 ff ff ff       	call   80104f19 <xchg>
80104f99:	85 c0                	test   %eax,%eax
80104f9b:	75 e9                	jne    80104f86 <acquire+0x27>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80104f9d:	8b 45 08             	mov    0x8(%ebp),%eax
80104fa0:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104fa7:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80104faa:	8b 45 08             	mov    0x8(%ebp),%eax
80104fad:	83 c0 0c             	add    $0xc,%eax
80104fb0:	89 44 24 04          	mov    %eax,0x4(%esp)
80104fb4:	8d 45 08             	lea    0x8(%ebp),%eax
80104fb7:	89 04 24             	mov    %eax,(%esp)
80104fba:	e8 51 00 00 00       	call   80105010 <getcallerpcs>
}
80104fbf:	c9                   	leave  
80104fc0:	c3                   	ret    

80104fc1 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80104fc1:	55                   	push   %ebp
80104fc2:	89 e5                	mov    %esp,%ebp
80104fc4:	83 ec 18             	sub    $0x18,%esp
  if(!holding(lk))
80104fc7:	8b 45 08             	mov    0x8(%ebp),%eax
80104fca:	89 04 24             	mov    %eax,(%esp)
80104fcd:	e8 b5 00 00 00       	call   80105087 <holding>
80104fd2:	85 c0                	test   %eax,%eax
80104fd4:	75 0c                	jne    80104fe2 <release+0x21>
    panic("release");
80104fd6:	c7 04 24 b9 8c 10 80 	movl   $0x80108cb9,(%esp)
80104fdd:	e8 54 b5 ff ff       	call   80100536 <panic>

  lk->pcs[0] = 0;
80104fe2:	8b 45 08             	mov    0x8(%ebp),%eax
80104fe5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80104fec:	8b 45 08             	mov    0x8(%ebp),%eax
80104fef:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
80104ff6:	8b 45 08             	mov    0x8(%ebp),%eax
80104ff9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105000:	00 
80105001:	89 04 24             	mov    %eax,(%esp)
80105004:	e8 10 ff ff ff       	call   80104f19 <xchg>

  popcli();
80105009:	e8 e9 00 00 00       	call   801050f7 <popcli>
}
8010500e:	c9                   	leave  
8010500f:	c3                   	ret    

80105010 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105010:	55                   	push   %ebp
80105011:	89 e5                	mov    %esp,%ebp
80105013:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
80105016:	8b 45 08             	mov    0x8(%ebp),%eax
80105019:	83 e8 08             	sub    $0x8,%eax
8010501c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
8010501f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80105026:	eb 37                	jmp    8010505f <getcallerpcs+0x4f>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105028:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
8010502c:	74 51                	je     8010507f <getcallerpcs+0x6f>
8010502e:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80105035:	76 48                	jbe    8010507f <getcallerpcs+0x6f>
80105037:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
8010503b:	74 42                	je     8010507f <getcallerpcs+0x6f>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010503d:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105040:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105047:	8b 45 0c             	mov    0xc(%ebp),%eax
8010504a:	01 c2                	add    %eax,%edx
8010504c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010504f:	8b 40 04             	mov    0x4(%eax),%eax
80105052:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80105054:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105057:	8b 00                	mov    (%eax),%eax
80105059:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
8010505c:	ff 45 f8             	incl   -0x8(%ebp)
8010505f:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105063:	7e c3                	jle    80105028 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80105065:	eb 18                	jmp    8010507f <getcallerpcs+0x6f>
    pcs[i] = 0;
80105067:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010506a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105071:	8b 45 0c             	mov    0xc(%ebp),%eax
80105074:	01 d0                	add    %edx,%eax
80105076:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010507c:	ff 45 f8             	incl   -0x8(%ebp)
8010507f:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105083:	7e e2                	jle    80105067 <getcallerpcs+0x57>
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
801050b7:	e8 3c fe ff ff       	call   80104ef8 <readeflags>
801050bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
801050bf:	e8 49 fe ff ff       	call   80104f0d <cli>
  if(cpu->ncli++ == 0)
801050c4:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801050ca:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
801050d0:	85 d2                	test   %edx,%edx
801050d2:	0f 94 c1             	sete   %cl
801050d5:	42                   	inc    %edx
801050d6:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
801050dc:	84 c9                	test   %cl,%cl
801050de:	74 15                	je     801050f5 <pushcli+0x44>
    cpu->intena = eflags & FL_IF;
801050e0:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801050e6:	8b 55 fc             	mov    -0x4(%ebp),%edx
801050e9:	81 e2 00 02 00 00    	and    $0x200,%edx
801050ef:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
801050f5:	c9                   	leave  
801050f6:	c3                   	ret    

801050f7 <popcli>:

void
popcli(void)
{
801050f7:	55                   	push   %ebp
801050f8:	89 e5                	mov    %esp,%ebp
801050fa:	83 ec 18             	sub    $0x18,%esp
  if(readeflags()&FL_IF)
801050fd:	e8 f6 fd ff ff       	call   80104ef8 <readeflags>
80105102:	25 00 02 00 00       	and    $0x200,%eax
80105107:	85 c0                	test   %eax,%eax
80105109:	74 0c                	je     80105117 <popcli+0x20>
    panic("popcli - interruptible");
8010510b:	c7 04 24 c1 8c 10 80 	movl   $0x80108cc1,(%esp)
80105112:	e8 1f b4 ff ff       	call   80100536 <panic>
  if(--cpu->ncli < 0)
80105117:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010511d:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80105123:	4a                   	dec    %edx
80105124:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
8010512a:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105130:	85 c0                	test   %eax,%eax
80105132:	79 0c                	jns    80105140 <popcli+0x49>
    panic("popcli");
80105134:	c7 04 24 d8 8c 10 80 	movl   $0x80108cd8,(%esp)
8010513b:	e8 f6 b3 ff ff       	call   80100536 <panic>
  if(cpu->ncli == 0 && cpu->intena)
80105140:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105146:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010514c:	85 c0                	test   %eax,%eax
8010514e:	75 15                	jne    80105165 <popcli+0x6e>
80105150:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105156:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
8010515c:	85 c0                	test   %eax,%eax
8010515e:	74 05                	je     80105165 <popcli+0x6e>
    sti();
80105160:	e8 ae fd ff ff       	call   80104f13 <sti>
}
80105165:	c9                   	leave  
80105166:	c3                   	ret    
80105167:	90                   	nop

80105168 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80105168:	55                   	push   %ebp
80105169:	89 e5                	mov    %esp,%ebp
8010516b:	57                   	push   %edi
8010516c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
8010516d:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105170:	8b 55 10             	mov    0x10(%ebp),%edx
80105173:	8b 45 0c             	mov    0xc(%ebp),%eax
80105176:	89 cb                	mov    %ecx,%ebx
80105178:	89 df                	mov    %ebx,%edi
8010517a:	89 d1                	mov    %edx,%ecx
8010517c:	fc                   	cld    
8010517d:	f3 aa                	rep stos %al,%es:(%edi)
8010517f:	89 ca                	mov    %ecx,%edx
80105181:	89 fb                	mov    %edi,%ebx
80105183:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105186:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80105189:	5b                   	pop    %ebx
8010518a:	5f                   	pop    %edi
8010518b:	5d                   	pop    %ebp
8010518c:	c3                   	ret    

8010518d <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
8010518d:	55                   	push   %ebp
8010518e:	89 e5                	mov    %esp,%ebp
80105190:	57                   	push   %edi
80105191:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80105192:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105195:	8b 55 10             	mov    0x10(%ebp),%edx
80105198:	8b 45 0c             	mov    0xc(%ebp),%eax
8010519b:	89 cb                	mov    %ecx,%ebx
8010519d:	89 df                	mov    %ebx,%edi
8010519f:	89 d1                	mov    %edx,%ecx
801051a1:	fc                   	cld    
801051a2:	f3 ab                	rep stos %eax,%es:(%edi)
801051a4:	89 ca                	mov    %ecx,%edx
801051a6:	89 fb                	mov    %edi,%ebx
801051a8:	89 5d 08             	mov    %ebx,0x8(%ebp)
801051ab:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
801051ae:	5b                   	pop    %ebx
801051af:	5f                   	pop    %edi
801051b0:	5d                   	pop    %ebp
801051b1:	c3                   	ret    

801051b2 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801051b2:	55                   	push   %ebp
801051b3:	89 e5                	mov    %esp,%ebp
801051b5:	83 ec 0c             	sub    $0xc,%esp
  if ((int)dst%4 == 0 && n%4 == 0){
801051b8:	8b 45 08             	mov    0x8(%ebp),%eax
801051bb:	83 e0 03             	and    $0x3,%eax
801051be:	85 c0                	test   %eax,%eax
801051c0:	75 49                	jne    8010520b <memset+0x59>
801051c2:	8b 45 10             	mov    0x10(%ebp),%eax
801051c5:	83 e0 03             	and    $0x3,%eax
801051c8:	85 c0                	test   %eax,%eax
801051ca:	75 3f                	jne    8010520b <memset+0x59>
    c &= 0xFF;
801051cc:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801051d3:	8b 45 10             	mov    0x10(%ebp),%eax
801051d6:	c1 e8 02             	shr    $0x2,%eax
801051d9:	89 c2                	mov    %eax,%edx
801051db:	8b 45 0c             	mov    0xc(%ebp),%eax
801051de:	89 c1                	mov    %eax,%ecx
801051e0:	c1 e1 18             	shl    $0x18,%ecx
801051e3:	8b 45 0c             	mov    0xc(%ebp),%eax
801051e6:	c1 e0 10             	shl    $0x10,%eax
801051e9:	09 c1                	or     %eax,%ecx
801051eb:	8b 45 0c             	mov    0xc(%ebp),%eax
801051ee:	c1 e0 08             	shl    $0x8,%eax
801051f1:	09 c8                	or     %ecx,%eax
801051f3:	0b 45 0c             	or     0xc(%ebp),%eax
801051f6:	89 54 24 08          	mov    %edx,0x8(%esp)
801051fa:	89 44 24 04          	mov    %eax,0x4(%esp)
801051fe:	8b 45 08             	mov    0x8(%ebp),%eax
80105201:	89 04 24             	mov    %eax,(%esp)
80105204:	e8 84 ff ff ff       	call   8010518d <stosl>
80105209:	eb 19                	jmp    80105224 <memset+0x72>
  } else
    stosb(dst, c, n);
8010520b:	8b 45 10             	mov    0x10(%ebp),%eax
8010520e:	89 44 24 08          	mov    %eax,0x8(%esp)
80105212:	8b 45 0c             	mov    0xc(%ebp),%eax
80105215:	89 44 24 04          	mov    %eax,0x4(%esp)
80105219:	8b 45 08             	mov    0x8(%ebp),%eax
8010521c:	89 04 24             	mov    %eax,(%esp)
8010521f:	e8 44 ff ff ff       	call   80105168 <stosb>
  return dst;
80105224:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105227:	c9                   	leave  
80105228:	c3                   	ret    

80105229 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105229:	55                   	push   %ebp
8010522a:	89 e5                	mov    %esp,%ebp
8010522c:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
8010522f:	8b 45 08             	mov    0x8(%ebp),%eax
80105232:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80105235:	8b 45 0c             	mov    0xc(%ebp),%eax
80105238:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
8010523b:	eb 2c                	jmp    80105269 <memcmp+0x40>
    if(*s1 != *s2)
8010523d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105240:	8a 10                	mov    (%eax),%dl
80105242:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105245:	8a 00                	mov    (%eax),%al
80105247:	38 c2                	cmp    %al,%dl
80105249:	74 18                	je     80105263 <memcmp+0x3a>
      return *s1 - *s2;
8010524b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010524e:	8a 00                	mov    (%eax),%al
80105250:	0f b6 d0             	movzbl %al,%edx
80105253:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105256:	8a 00                	mov    (%eax),%al
80105258:	0f b6 c0             	movzbl %al,%eax
8010525b:	89 d1                	mov    %edx,%ecx
8010525d:	29 c1                	sub    %eax,%ecx
8010525f:	89 c8                	mov    %ecx,%eax
80105261:	eb 19                	jmp    8010527c <memcmp+0x53>
    s1++, s2++;
80105263:	ff 45 fc             	incl   -0x4(%ebp)
80105266:	ff 45 f8             	incl   -0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80105269:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010526d:	0f 95 c0             	setne  %al
80105270:	ff 4d 10             	decl   0x10(%ebp)
80105273:	84 c0                	test   %al,%al
80105275:	75 c6                	jne    8010523d <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80105277:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010527c:	c9                   	leave  
8010527d:	c3                   	ret    

8010527e <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
8010527e:	55                   	push   %ebp
8010527f:	89 e5                	mov    %esp,%ebp
80105281:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80105284:	8b 45 0c             	mov    0xc(%ebp),%eax
80105287:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
8010528a:	8b 45 08             	mov    0x8(%ebp),%eax
8010528d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80105290:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105293:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105296:	73 4d                	jae    801052e5 <memmove+0x67>
80105298:	8b 45 10             	mov    0x10(%ebp),%eax
8010529b:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010529e:	01 d0                	add    %edx,%eax
801052a0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801052a3:	76 40                	jbe    801052e5 <memmove+0x67>
    s += n;
801052a5:	8b 45 10             	mov    0x10(%ebp),%eax
801052a8:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
801052ab:	8b 45 10             	mov    0x10(%ebp),%eax
801052ae:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
801052b1:	eb 10                	jmp    801052c3 <memmove+0x45>
      *--d = *--s;
801052b3:	ff 4d f8             	decl   -0x8(%ebp)
801052b6:	ff 4d fc             	decl   -0x4(%ebp)
801052b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
801052bc:	8a 10                	mov    (%eax),%dl
801052be:	8b 45 f8             	mov    -0x8(%ebp),%eax
801052c1:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
801052c3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801052c7:	0f 95 c0             	setne  %al
801052ca:	ff 4d 10             	decl   0x10(%ebp)
801052cd:	84 c0                	test   %al,%al
801052cf:	75 e2                	jne    801052b3 <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801052d1:	eb 21                	jmp    801052f4 <memmove+0x76>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
801052d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
801052d6:	8a 10                	mov    (%eax),%dl
801052d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
801052db:	88 10                	mov    %dl,(%eax)
801052dd:	ff 45 f8             	incl   -0x8(%ebp)
801052e0:	ff 45 fc             	incl   -0x4(%ebp)
801052e3:	eb 01                	jmp    801052e6 <memmove+0x68>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801052e5:	90                   	nop
801052e6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801052ea:	0f 95 c0             	setne  %al
801052ed:	ff 4d 10             	decl   0x10(%ebp)
801052f0:	84 c0                	test   %al,%al
801052f2:	75 df                	jne    801052d3 <memmove+0x55>
      *d++ = *s++;

  return dst;
801052f4:	8b 45 08             	mov    0x8(%ebp),%eax
}
801052f7:	c9                   	leave  
801052f8:	c3                   	ret    

801052f9 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801052f9:	55                   	push   %ebp
801052fa:	89 e5                	mov    %esp,%ebp
801052fc:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
801052ff:	8b 45 10             	mov    0x10(%ebp),%eax
80105302:	89 44 24 08          	mov    %eax,0x8(%esp)
80105306:	8b 45 0c             	mov    0xc(%ebp),%eax
80105309:	89 44 24 04          	mov    %eax,0x4(%esp)
8010530d:	8b 45 08             	mov    0x8(%ebp),%eax
80105310:	89 04 24             	mov    %eax,(%esp)
80105313:	e8 66 ff ff ff       	call   8010527e <memmove>
}
80105318:	c9                   	leave  
80105319:	c3                   	ret    

8010531a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
8010531a:	55                   	push   %ebp
8010531b:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
8010531d:	eb 09                	jmp    80105328 <strncmp+0xe>
    n--, p++, q++;
8010531f:	ff 4d 10             	decl   0x10(%ebp)
80105322:	ff 45 08             	incl   0x8(%ebp)
80105325:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80105328:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010532c:	74 17                	je     80105345 <strncmp+0x2b>
8010532e:	8b 45 08             	mov    0x8(%ebp),%eax
80105331:	8a 00                	mov    (%eax),%al
80105333:	84 c0                	test   %al,%al
80105335:	74 0e                	je     80105345 <strncmp+0x2b>
80105337:	8b 45 08             	mov    0x8(%ebp),%eax
8010533a:	8a 10                	mov    (%eax),%dl
8010533c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010533f:	8a 00                	mov    (%eax),%al
80105341:	38 c2                	cmp    %al,%dl
80105343:	74 da                	je     8010531f <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
80105345:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105349:	75 07                	jne    80105352 <strncmp+0x38>
    return 0;
8010534b:	b8 00 00 00 00       	mov    $0x0,%eax
80105350:	eb 16                	jmp    80105368 <strncmp+0x4e>
  return (uchar)*p - (uchar)*q;
80105352:	8b 45 08             	mov    0x8(%ebp),%eax
80105355:	8a 00                	mov    (%eax),%al
80105357:	0f b6 d0             	movzbl %al,%edx
8010535a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010535d:	8a 00                	mov    (%eax),%al
8010535f:	0f b6 c0             	movzbl %al,%eax
80105362:	89 d1                	mov    %edx,%ecx
80105364:	29 c1                	sub    %eax,%ecx
80105366:	89 c8                	mov    %ecx,%eax
}
80105368:	5d                   	pop    %ebp
80105369:	c3                   	ret    

8010536a <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
8010536a:	55                   	push   %ebp
8010536b:	89 e5                	mov    %esp,%ebp
8010536d:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105370:	8b 45 08             	mov    0x8(%ebp),%eax
80105373:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80105376:	90                   	nop
80105377:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010537b:	0f 9f c0             	setg   %al
8010537e:	ff 4d 10             	decl   0x10(%ebp)
80105381:	84 c0                	test   %al,%al
80105383:	74 2b                	je     801053b0 <strncpy+0x46>
80105385:	8b 45 0c             	mov    0xc(%ebp),%eax
80105388:	8a 10                	mov    (%eax),%dl
8010538a:	8b 45 08             	mov    0x8(%ebp),%eax
8010538d:	88 10                	mov    %dl,(%eax)
8010538f:	8b 45 08             	mov    0x8(%ebp),%eax
80105392:	8a 00                	mov    (%eax),%al
80105394:	84 c0                	test   %al,%al
80105396:	0f 95 c0             	setne  %al
80105399:	ff 45 08             	incl   0x8(%ebp)
8010539c:	ff 45 0c             	incl   0xc(%ebp)
8010539f:	84 c0                	test   %al,%al
801053a1:	75 d4                	jne    80105377 <strncpy+0xd>
    ;
  while(n-- > 0)
801053a3:	eb 0b                	jmp    801053b0 <strncpy+0x46>
    *s++ = 0;
801053a5:	8b 45 08             	mov    0x8(%ebp),%eax
801053a8:	c6 00 00             	movb   $0x0,(%eax)
801053ab:	ff 45 08             	incl   0x8(%ebp)
801053ae:	eb 01                	jmp    801053b1 <strncpy+0x47>
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
801053b0:	90                   	nop
801053b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801053b5:	0f 9f c0             	setg   %al
801053b8:	ff 4d 10             	decl   0x10(%ebp)
801053bb:	84 c0                	test   %al,%al
801053bd:	75 e6                	jne    801053a5 <strncpy+0x3b>
    *s++ = 0;
  return os;
801053bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801053c2:	c9                   	leave  
801053c3:	c3                   	ret    

801053c4 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801053c4:	55                   	push   %ebp
801053c5:	89 e5                	mov    %esp,%ebp
801053c7:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
801053ca:	8b 45 08             	mov    0x8(%ebp),%eax
801053cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
801053d0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801053d4:	7f 05                	jg     801053db <safestrcpy+0x17>
    return os;
801053d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
801053d9:	eb 30                	jmp    8010540b <safestrcpy+0x47>
  while(--n > 0 && (*s++ = *t++) != 0)
801053db:	ff 4d 10             	decl   0x10(%ebp)
801053de:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801053e2:	7e 1e                	jle    80105402 <safestrcpy+0x3e>
801053e4:	8b 45 0c             	mov    0xc(%ebp),%eax
801053e7:	8a 10                	mov    (%eax),%dl
801053e9:	8b 45 08             	mov    0x8(%ebp),%eax
801053ec:	88 10                	mov    %dl,(%eax)
801053ee:	8b 45 08             	mov    0x8(%ebp),%eax
801053f1:	8a 00                	mov    (%eax),%al
801053f3:	84 c0                	test   %al,%al
801053f5:	0f 95 c0             	setne  %al
801053f8:	ff 45 08             	incl   0x8(%ebp)
801053fb:	ff 45 0c             	incl   0xc(%ebp)
801053fe:	84 c0                	test   %al,%al
80105400:	75 d9                	jne    801053db <safestrcpy+0x17>
    ;
  *s = 0;
80105402:	8b 45 08             	mov    0x8(%ebp),%eax
80105405:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80105408:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010540b:	c9                   	leave  
8010540c:	c3                   	ret    

8010540d <strlen>:

int
strlen(const char *s)
{
8010540d:	55                   	push   %ebp
8010540e:	89 e5                	mov    %esp,%ebp
80105410:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80105413:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010541a:	eb 03                	jmp    8010541f <strlen+0x12>
8010541c:	ff 45 fc             	incl   -0x4(%ebp)
8010541f:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105422:	8b 45 08             	mov    0x8(%ebp),%eax
80105425:	01 d0                	add    %edx,%eax
80105427:	8a 00                	mov    (%eax),%al
80105429:	84 c0                	test   %al,%al
8010542b:	75 ef                	jne    8010541c <strlen+0xf>
    ;
  return n;
8010542d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105430:	c9                   	leave  
80105431:	c3                   	ret    
80105432:	66 90                	xchg   %ax,%ax

80105434 <swtch>:
80105434:	8b 44 24 04          	mov    0x4(%esp),%eax
80105438:	8b 54 24 08          	mov    0x8(%esp),%edx
8010543c:	55                   	push   %ebp
8010543d:	53                   	push   %ebx
8010543e:	56                   	push   %esi
8010543f:	57                   	push   %edi
80105440:	89 20                	mov    %esp,(%eax)
80105442:	89 d4                	mov    %edx,%esp
80105444:	5f                   	pop    %edi
80105445:	5e                   	pop    %esi
80105446:	5b                   	pop    %ebx
80105447:	5d                   	pop    %ebp
80105448:	c3                   	ret    
80105449:	66 90                	xchg   %ax,%ax
8010544b:	90                   	nop

8010544c <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
8010544c:	55                   	push   %ebp
8010544d:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
8010544f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105455:	8b 00                	mov    (%eax),%eax
80105457:	3b 45 08             	cmp    0x8(%ebp),%eax
8010545a:	76 12                	jbe    8010546e <fetchint+0x22>
8010545c:	8b 45 08             	mov    0x8(%ebp),%eax
8010545f:	8d 50 04             	lea    0x4(%eax),%edx
80105462:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105468:	8b 00                	mov    (%eax),%eax
8010546a:	39 c2                	cmp    %eax,%edx
8010546c:	76 07                	jbe    80105475 <fetchint+0x29>
    return -1;
8010546e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105473:	eb 0f                	jmp    80105484 <fetchint+0x38>
  *ip = *(int*)(addr);
80105475:	8b 45 08             	mov    0x8(%ebp),%eax
80105478:	8b 10                	mov    (%eax),%edx
8010547a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010547d:	89 10                	mov    %edx,(%eax)
  return 0;
8010547f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105484:	5d                   	pop    %ebp
80105485:	c3                   	ret    

80105486 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105486:	55                   	push   %ebp
80105487:	89 e5                	mov    %esp,%ebp
80105489:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
8010548c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105492:	8b 00                	mov    (%eax),%eax
80105494:	3b 45 08             	cmp    0x8(%ebp),%eax
80105497:	77 07                	ja     801054a0 <fetchstr+0x1a>
    return -1;
80105499:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010549e:	eb 46                	jmp    801054e6 <fetchstr+0x60>
  *pp = (char*)addr;
801054a0:	8b 55 08             	mov    0x8(%ebp),%edx
801054a3:	8b 45 0c             	mov    0xc(%ebp),%eax
801054a6:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
801054a8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054ae:	8b 00                	mov    (%eax),%eax
801054b0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
801054b3:	8b 45 0c             	mov    0xc(%ebp),%eax
801054b6:	8b 00                	mov    (%eax),%eax
801054b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
801054bb:	eb 1c                	jmp    801054d9 <fetchstr+0x53>
    if(*s == 0)
801054bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
801054c0:	8a 00                	mov    (%eax),%al
801054c2:	84 c0                	test   %al,%al
801054c4:	75 10                	jne    801054d6 <fetchstr+0x50>
      return s - *pp;
801054c6:	8b 55 fc             	mov    -0x4(%ebp),%edx
801054c9:	8b 45 0c             	mov    0xc(%ebp),%eax
801054cc:	8b 00                	mov    (%eax),%eax
801054ce:	89 d1                	mov    %edx,%ecx
801054d0:	29 c1                	sub    %eax,%ecx
801054d2:	89 c8                	mov    %ecx,%eax
801054d4:	eb 10                	jmp    801054e6 <fetchstr+0x60>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
801054d6:	ff 45 fc             	incl   -0x4(%ebp)
801054d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
801054dc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801054df:	72 dc                	jb     801054bd <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
801054e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054e6:	c9                   	leave  
801054e7:	c3                   	ret    

801054e8 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801054e8:	55                   	push   %ebp
801054e9:	89 e5                	mov    %esp,%ebp
801054eb:	83 ec 08             	sub    $0x8,%esp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801054ee:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054f4:	8b 40 18             	mov    0x18(%eax),%eax
801054f7:	8b 50 44             	mov    0x44(%eax),%edx
801054fa:	8b 45 08             	mov    0x8(%ebp),%eax
801054fd:	c1 e0 02             	shl    $0x2,%eax
80105500:	01 d0                	add    %edx,%eax
80105502:	8d 50 04             	lea    0x4(%eax),%edx
80105505:	8b 45 0c             	mov    0xc(%ebp),%eax
80105508:	89 44 24 04          	mov    %eax,0x4(%esp)
8010550c:	89 14 24             	mov    %edx,(%esp)
8010550f:	e8 38 ff ff ff       	call   8010544c <fetchint>
}
80105514:	c9                   	leave  
80105515:	c3                   	ret    

80105516 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105516:	55                   	push   %ebp
80105517:	89 e5                	mov    %esp,%ebp
80105519:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  if(argint(n, &i) < 0)
8010551c:	8d 45 fc             	lea    -0x4(%ebp),%eax
8010551f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105523:	8b 45 08             	mov    0x8(%ebp),%eax
80105526:	89 04 24             	mov    %eax,(%esp)
80105529:	e8 ba ff ff ff       	call   801054e8 <argint>
8010552e:	85 c0                	test   %eax,%eax
80105530:	79 07                	jns    80105539 <argptr+0x23>
    return -1;
80105532:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105537:	eb 3d                	jmp    80105576 <argptr+0x60>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
80105539:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010553c:	89 c2                	mov    %eax,%edx
8010553e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105544:	8b 00                	mov    (%eax),%eax
80105546:	39 c2                	cmp    %eax,%edx
80105548:	73 16                	jae    80105560 <argptr+0x4a>
8010554a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010554d:	89 c2                	mov    %eax,%edx
8010554f:	8b 45 10             	mov    0x10(%ebp),%eax
80105552:	01 c2                	add    %eax,%edx
80105554:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010555a:	8b 00                	mov    (%eax),%eax
8010555c:	39 c2                	cmp    %eax,%edx
8010555e:	76 07                	jbe    80105567 <argptr+0x51>
    return -1;
80105560:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105565:	eb 0f                	jmp    80105576 <argptr+0x60>
  *pp = (char*)i;
80105567:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010556a:	89 c2                	mov    %eax,%edx
8010556c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010556f:	89 10                	mov    %edx,(%eax)
  return 0;
80105571:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105576:	c9                   	leave  
80105577:	c3                   	ret    

80105578 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105578:	55                   	push   %ebp
80105579:	89 e5                	mov    %esp,%ebp
8010557b:	83 ec 18             	sub    $0x18,%esp
  int addr;
  if(argint(n, &addr) < 0)
8010557e:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105581:	89 44 24 04          	mov    %eax,0x4(%esp)
80105585:	8b 45 08             	mov    0x8(%ebp),%eax
80105588:	89 04 24             	mov    %eax,(%esp)
8010558b:	e8 58 ff ff ff       	call   801054e8 <argint>
80105590:	85 c0                	test   %eax,%eax
80105592:	79 07                	jns    8010559b <argstr+0x23>
    return -1;
80105594:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105599:	eb 12                	jmp    801055ad <argstr+0x35>
  return fetchstr(addr, pp);
8010559b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010559e:	8b 55 0c             	mov    0xc(%ebp),%edx
801055a1:	89 54 24 04          	mov    %edx,0x4(%esp)
801055a5:	89 04 24             	mov    %eax,(%esp)
801055a8:	e8 d9 fe ff ff       	call   80105486 <fetchstr>
}
801055ad:	c9                   	leave  
801055ae:	c3                   	ret    

801055af <syscall>:
[SYS_alarm]   sys_alarm,
};

void
syscall(void)
{
801055af:	55                   	push   %ebp
801055b0:	89 e5                	mov    %esp,%ebp
801055b2:	53                   	push   %ebx
801055b3:	83 ec 24             	sub    $0x24,%esp
  int num;

  num = proc->tf->eax;
801055b6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055bc:	8b 40 18             	mov    0x18(%eax),%eax
801055bf:	8b 40 1c             	mov    0x1c(%eax),%eax
801055c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801055c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801055c9:	7e 30                	jle    801055fb <syscall+0x4c>
801055cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055ce:	83 f8 18             	cmp    $0x18,%eax
801055d1:	77 28                	ja     801055fb <syscall+0x4c>
801055d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055d6:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
801055dd:	85 c0                	test   %eax,%eax
801055df:	74 1a                	je     801055fb <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
801055e1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055e7:	8b 58 18             	mov    0x18(%eax),%ebx
801055ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055ed:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
801055f4:	ff d0                	call   *%eax
801055f6:	89 43 1c             	mov    %eax,0x1c(%ebx)
801055f9:	eb 3d                	jmp    80105638 <syscall+0x89>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
801055fb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105601:	8d 48 6c             	lea    0x6c(%eax),%ecx
80105604:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
8010560a:	8b 40 10             	mov    0x10(%eax),%eax
8010560d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105610:	89 54 24 0c          	mov    %edx,0xc(%esp)
80105614:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105618:	89 44 24 04          	mov    %eax,0x4(%esp)
8010561c:	c7 04 24 df 8c 10 80 	movl   $0x80108cdf,(%esp)
80105623:	e8 79 ad ff ff       	call   801003a1 <cprintf>
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
80105628:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010562e:	8b 40 18             	mov    0x18(%eax),%eax
80105631:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105638:	83 c4 24             	add    $0x24,%esp
8010563b:	5b                   	pop    %ebx
8010563c:	5d                   	pop    %ebp
8010563d:	c3                   	ret    
8010563e:	66 90                	xchg   %ax,%ax

80105640 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105640:	55                   	push   %ebp
80105641:	89 e5                	mov    %esp,%ebp
80105643:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105646:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105649:	89 44 24 04          	mov    %eax,0x4(%esp)
8010564d:	8b 45 08             	mov    0x8(%ebp),%eax
80105650:	89 04 24             	mov    %eax,(%esp)
80105653:	e8 90 fe ff ff       	call   801054e8 <argint>
80105658:	85 c0                	test   %eax,%eax
8010565a:	79 07                	jns    80105663 <argfd+0x23>
    return -1;
8010565c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105661:	eb 50                	jmp    801056b3 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80105663:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105666:	85 c0                	test   %eax,%eax
80105668:	78 21                	js     8010568b <argfd+0x4b>
8010566a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010566d:	83 f8 0f             	cmp    $0xf,%eax
80105670:	7f 19                	jg     8010568b <argfd+0x4b>
80105672:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105678:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010567b:	83 c2 08             	add    $0x8,%edx
8010567e:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105682:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105685:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105689:	75 07                	jne    80105692 <argfd+0x52>
    return -1;
8010568b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105690:	eb 21                	jmp    801056b3 <argfd+0x73>
  if(pfd)
80105692:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105696:	74 08                	je     801056a0 <argfd+0x60>
    *pfd = fd;
80105698:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010569b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010569e:	89 10                	mov    %edx,(%eax)
  if(pf)
801056a0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801056a4:	74 08                	je     801056ae <argfd+0x6e>
    *pf = f;
801056a6:	8b 45 10             	mov    0x10(%ebp),%eax
801056a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801056ac:	89 10                	mov    %edx,(%eax)
  return 0;
801056ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
801056b3:	c9                   	leave  
801056b4:	c3                   	ret    

801056b5 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
801056b5:	55                   	push   %ebp
801056b6:	89 e5                	mov    %esp,%ebp
801056b8:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801056bb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801056c2:	eb 2f                	jmp    801056f3 <fdalloc+0x3e>
    if(proc->ofile[fd] == 0){
801056c4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
801056cd:	83 c2 08             	add    $0x8,%edx
801056d0:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801056d4:	85 c0                	test   %eax,%eax
801056d6:	75 18                	jne    801056f0 <fdalloc+0x3b>
      proc->ofile[fd] = f;
801056d8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056de:	8b 55 fc             	mov    -0x4(%ebp),%edx
801056e1:	8d 4a 08             	lea    0x8(%edx),%ecx
801056e4:	8b 55 08             	mov    0x8(%ebp),%edx
801056e7:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
801056eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
801056ee:	eb 0e                	jmp    801056fe <fdalloc+0x49>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801056f0:	ff 45 fc             	incl   -0x4(%ebp)
801056f3:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
801056f7:	7e cb                	jle    801056c4 <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
801056f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056fe:	c9                   	leave  
801056ff:	c3                   	ret    

80105700 <sys_dup>:

int
sys_dup(void)
{
80105700:	55                   	push   %ebp
80105701:	89 e5                	mov    %esp,%ebp
80105703:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80105706:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105709:	89 44 24 08          	mov    %eax,0x8(%esp)
8010570d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105714:	00 
80105715:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010571c:	e8 1f ff ff ff       	call   80105640 <argfd>
80105721:	85 c0                	test   %eax,%eax
80105723:	79 07                	jns    8010572c <sys_dup+0x2c>
    return -1;
80105725:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010572a:	eb 29                	jmp    80105755 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
8010572c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010572f:	89 04 24             	mov    %eax,(%esp)
80105732:	e8 7e ff ff ff       	call   801056b5 <fdalloc>
80105737:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010573a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010573e:	79 07                	jns    80105747 <sys_dup+0x47>
    return -1;
80105740:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105745:	eb 0e                	jmp    80105755 <sys_dup+0x55>
  filedup(f);
80105747:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010574a:	89 04 24             	mov    %eax,(%esp)
8010574d:	e8 36 b8 ff ff       	call   80100f88 <filedup>
  return fd;
80105752:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105755:	c9                   	leave  
80105756:	c3                   	ret    

80105757 <sys_read>:

int
sys_read(void)
{
80105757:	55                   	push   %ebp
80105758:	89 e5                	mov    %esp,%ebp
8010575a:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010575d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105760:	89 44 24 08          	mov    %eax,0x8(%esp)
80105764:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010576b:	00 
8010576c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105773:	e8 c8 fe ff ff       	call   80105640 <argfd>
80105778:	85 c0                	test   %eax,%eax
8010577a:	78 35                	js     801057b1 <sys_read+0x5a>
8010577c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010577f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105783:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
8010578a:	e8 59 fd ff ff       	call   801054e8 <argint>
8010578f:	85 c0                	test   %eax,%eax
80105791:	78 1e                	js     801057b1 <sys_read+0x5a>
80105793:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105796:	89 44 24 08          	mov    %eax,0x8(%esp)
8010579a:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010579d:	89 44 24 04          	mov    %eax,0x4(%esp)
801057a1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801057a8:	e8 69 fd ff ff       	call   80105516 <argptr>
801057ad:	85 c0                	test   %eax,%eax
801057af:	79 07                	jns    801057b8 <sys_read+0x61>
    return -1;
801057b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057b6:	eb 19                	jmp    801057d1 <sys_read+0x7a>
  return fileread(f, p, n);
801057b8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801057bb:	8b 55 ec             	mov    -0x14(%ebp),%edx
801057be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057c1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801057c5:	89 54 24 04          	mov    %edx,0x4(%esp)
801057c9:	89 04 24             	mov    %eax,(%esp)
801057cc:	e8 18 b9 ff ff       	call   801010e9 <fileread>
}
801057d1:	c9                   	leave  
801057d2:	c3                   	ret    

801057d3 <sys_write>:

int
sys_write(void)
{
801057d3:	55                   	push   %ebp
801057d4:	89 e5                	mov    %esp,%ebp
801057d6:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801057d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057dc:	89 44 24 08          	mov    %eax,0x8(%esp)
801057e0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801057e7:	00 
801057e8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801057ef:	e8 4c fe ff ff       	call   80105640 <argfd>
801057f4:	85 c0                	test   %eax,%eax
801057f6:	78 35                	js     8010582d <sys_write+0x5a>
801057f8:	8d 45 f0             	lea    -0x10(%ebp),%eax
801057fb:	89 44 24 04          	mov    %eax,0x4(%esp)
801057ff:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105806:	e8 dd fc ff ff       	call   801054e8 <argint>
8010580b:	85 c0                	test   %eax,%eax
8010580d:	78 1e                	js     8010582d <sys_write+0x5a>
8010580f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105812:	89 44 24 08          	mov    %eax,0x8(%esp)
80105816:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105819:	89 44 24 04          	mov    %eax,0x4(%esp)
8010581d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105824:	e8 ed fc ff ff       	call   80105516 <argptr>
80105829:	85 c0                	test   %eax,%eax
8010582b:	79 07                	jns    80105834 <sys_write+0x61>
    return -1;
8010582d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105832:	eb 19                	jmp    8010584d <sys_write+0x7a>
  return filewrite(f, p, n);
80105834:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105837:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010583a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010583d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105841:	89 54 24 04          	mov    %edx,0x4(%esp)
80105845:	89 04 24             	mov    %eax,(%esp)
80105848:	e8 57 b9 ff ff       	call   801011a4 <filewrite>
}
8010584d:	c9                   	leave  
8010584e:	c3                   	ret    

8010584f <sys_close>:

int
sys_close(void)
{
8010584f:	55                   	push   %ebp
80105850:	89 e5                	mov    %esp,%ebp
80105852:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
80105855:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105858:	89 44 24 08          	mov    %eax,0x8(%esp)
8010585c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010585f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105863:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010586a:	e8 d1 fd ff ff       	call   80105640 <argfd>
8010586f:	85 c0                	test   %eax,%eax
80105871:	79 07                	jns    8010587a <sys_close+0x2b>
    return -1;
80105873:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105878:	eb 24                	jmp    8010589e <sys_close+0x4f>
  proc->ofile[fd] = 0;
8010587a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105880:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105883:	83 c2 08             	add    $0x8,%edx
80105886:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010588d:	00 
  fileclose(f);
8010588e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105891:	89 04 24             	mov    %eax,(%esp)
80105894:	e8 37 b7 ff ff       	call   80100fd0 <fileclose>
  return 0;
80105899:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010589e:	c9                   	leave  
8010589f:	c3                   	ret    

801058a0 <sys_fstat>:

int
sys_fstat(void)
{
801058a0:	55                   	push   %ebp
801058a1:	89 e5                	mov    %esp,%ebp
801058a3:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801058a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058a9:	89 44 24 08          	mov    %eax,0x8(%esp)
801058ad:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801058b4:	00 
801058b5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801058bc:	e8 7f fd ff ff       	call   80105640 <argfd>
801058c1:	85 c0                	test   %eax,%eax
801058c3:	78 1f                	js     801058e4 <sys_fstat+0x44>
801058c5:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
801058cc:	00 
801058cd:	8d 45 f0             	lea    -0x10(%ebp),%eax
801058d0:	89 44 24 04          	mov    %eax,0x4(%esp)
801058d4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801058db:	e8 36 fc ff ff       	call   80105516 <argptr>
801058e0:	85 c0                	test   %eax,%eax
801058e2:	79 07                	jns    801058eb <sys_fstat+0x4b>
    return -1;
801058e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058e9:	eb 12                	jmp    801058fd <sys_fstat+0x5d>
  return filestat(f, st);
801058eb:	8b 55 f0             	mov    -0x10(%ebp),%edx
801058ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058f1:	89 54 24 04          	mov    %edx,0x4(%esp)
801058f5:	89 04 24             	mov    %eax,(%esp)
801058f8:	e8 9d b7 ff ff       	call   8010109a <filestat>
}
801058fd:	c9                   	leave  
801058fe:	c3                   	ret    

801058ff <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801058ff:	55                   	push   %ebp
80105900:	89 e5                	mov    %esp,%ebp
80105902:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105905:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105908:	89 44 24 04          	mov    %eax,0x4(%esp)
8010590c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105913:	e8 60 fc ff ff       	call   80105578 <argstr>
80105918:	85 c0                	test   %eax,%eax
8010591a:	78 17                	js     80105933 <sys_link+0x34>
8010591c:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010591f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105923:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010592a:	e8 49 fc ff ff       	call   80105578 <argstr>
8010592f:	85 c0                	test   %eax,%eax
80105931:	79 0a                	jns    8010593d <sys_link+0x3e>
    return -1;
80105933:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105938:	e9 3c 01 00 00       	jmp    80105a79 <sys_link+0x17a>

  begin_op();
8010593d:	e8 65 db ff ff       	call   801034a7 <begin_op>
  if((ip = namei(old)) == 0){
80105942:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105945:	89 04 24             	mov    %eax,(%esp)
80105948:	e8 0a cb ff ff       	call   80102457 <namei>
8010594d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105950:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105954:	75 0f                	jne    80105965 <sys_link+0x66>
    end_op();
80105956:	e8 cb db ff ff       	call   80103526 <end_op>
    return -1;
8010595b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105960:	e9 14 01 00 00       	jmp    80105a79 <sys_link+0x17a>
  }

  ilock(ip);
80105965:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105968:	89 04 24             	mov    %eax,(%esp)
8010596b:	e8 47 bf ff ff       	call   801018b7 <ilock>
  if(ip->type == T_DIR){
80105970:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105973:	8b 40 10             	mov    0x10(%eax),%eax
80105976:	66 83 f8 01          	cmp    $0x1,%ax
8010597a:	75 1a                	jne    80105996 <sys_link+0x97>
    iunlockput(ip);
8010597c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010597f:	89 04 24             	mov    %eax,(%esp)
80105982:	e8 b7 c1 ff ff       	call   80101b3e <iunlockput>
    end_op();
80105987:	e8 9a db ff ff       	call   80103526 <end_op>
    return -1;
8010598c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105991:	e9 e3 00 00 00       	jmp    80105a79 <sys_link+0x17a>
  }

  ip->nlink++;
80105996:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105999:	66 8b 40 16          	mov    0x16(%eax),%ax
8010599d:	40                   	inc    %eax
8010599e:	8b 55 f4             	mov    -0xc(%ebp),%edx
801059a1:	66 89 42 16          	mov    %ax,0x16(%edx)
  iupdate(ip);
801059a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059a8:	89 04 24             	mov    %eax,(%esp)
801059ab:	e8 47 bd ff ff       	call   801016f7 <iupdate>
  iunlock(ip);
801059b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059b3:	89 04 24             	mov    %eax,(%esp)
801059b6:	e8 4d c0 ff ff       	call   80101a08 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
801059bb:	8b 45 dc             	mov    -0x24(%ebp),%eax
801059be:	8d 55 e2             	lea    -0x1e(%ebp),%edx
801059c1:	89 54 24 04          	mov    %edx,0x4(%esp)
801059c5:	89 04 24             	mov    %eax,(%esp)
801059c8:	e8 ac ca ff ff       	call   80102479 <nameiparent>
801059cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
801059d0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801059d4:	74 68                	je     80105a3e <sys_link+0x13f>
    goto bad;
  ilock(dp);
801059d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059d9:	89 04 24             	mov    %eax,(%esp)
801059dc:	e8 d6 be ff ff       	call   801018b7 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801059e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059e4:	8b 10                	mov    (%eax),%edx
801059e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059e9:	8b 00                	mov    (%eax),%eax
801059eb:	39 c2                	cmp    %eax,%edx
801059ed:	75 20                	jne    80105a0f <sys_link+0x110>
801059ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059f2:	8b 40 04             	mov    0x4(%eax),%eax
801059f5:	89 44 24 08          	mov    %eax,0x8(%esp)
801059f9:	8d 45 e2             	lea    -0x1e(%ebp),%eax
801059fc:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a00:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a03:	89 04 24             	mov    %eax,(%esp)
80105a06:	e8 95 c7 ff ff       	call   801021a0 <dirlink>
80105a0b:	85 c0                	test   %eax,%eax
80105a0d:	79 0d                	jns    80105a1c <sys_link+0x11d>
    iunlockput(dp);
80105a0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a12:	89 04 24             	mov    %eax,(%esp)
80105a15:	e8 24 c1 ff ff       	call   80101b3e <iunlockput>
    goto bad;
80105a1a:	eb 23                	jmp    80105a3f <sys_link+0x140>
  }
  iunlockput(dp);
80105a1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a1f:	89 04 24             	mov    %eax,(%esp)
80105a22:	e8 17 c1 ff ff       	call   80101b3e <iunlockput>
  iput(ip);
80105a27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a2a:	89 04 24             	mov    %eax,(%esp)
80105a2d:	e8 3b c0 ff ff       	call   80101a6d <iput>

  end_op();
80105a32:	e8 ef da ff ff       	call   80103526 <end_op>

  return 0;
80105a37:	b8 00 00 00 00       	mov    $0x0,%eax
80105a3c:	eb 3b                	jmp    80105a79 <sys_link+0x17a>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
80105a3e:	90                   	nop
  end_op();

  return 0;

bad:
  ilock(ip);
80105a3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a42:	89 04 24             	mov    %eax,(%esp)
80105a45:	e8 6d be ff ff       	call   801018b7 <ilock>
  ip->nlink--;
80105a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a4d:	66 8b 40 16          	mov    0x16(%eax),%ax
80105a51:	48                   	dec    %eax
80105a52:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105a55:	66 89 42 16          	mov    %ax,0x16(%edx)
  iupdate(ip);
80105a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a5c:	89 04 24             	mov    %eax,(%esp)
80105a5f:	e8 93 bc ff ff       	call   801016f7 <iupdate>
  iunlockput(ip);
80105a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a67:	89 04 24             	mov    %eax,(%esp)
80105a6a:	e8 cf c0 ff ff       	call   80101b3e <iunlockput>
  end_op();
80105a6f:	e8 b2 da ff ff       	call   80103526 <end_op>
  return -1;
80105a74:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a79:	c9                   	leave  
80105a7a:	c3                   	ret    

80105a7b <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105a7b:	55                   	push   %ebp
80105a7c:	89 e5                	mov    %esp,%ebp
80105a7e:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105a81:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105a88:	eb 4a                	jmp    80105ad4 <isdirempty+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105a8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a8d:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105a94:	00 
80105a95:	89 44 24 08          	mov    %eax,0x8(%esp)
80105a99:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105a9c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105aa0:	8b 45 08             	mov    0x8(%ebp),%eax
80105aa3:	89 04 24             	mov    %eax,(%esp)
80105aa6:	e8 19 c3 ff ff       	call   80101dc4 <readi>
80105aab:	83 f8 10             	cmp    $0x10,%eax
80105aae:	74 0c                	je     80105abc <isdirempty+0x41>
      panic("isdirempty: readi");
80105ab0:	c7 04 24 fb 8c 10 80 	movl   $0x80108cfb,(%esp)
80105ab7:	e8 7a aa ff ff       	call   80100536 <panic>
    if(de.inum != 0)
80105abc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105abf:	66 85 c0             	test   %ax,%ax
80105ac2:	74 07                	je     80105acb <isdirempty+0x50>
      return 0;
80105ac4:	b8 00 00 00 00       	mov    $0x0,%eax
80105ac9:	eb 1b                	jmp    80105ae6 <isdirempty+0x6b>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ace:	83 c0 10             	add    $0x10,%eax
80105ad1:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105ad4:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105ad7:	8b 45 08             	mov    0x8(%ebp),%eax
80105ada:	8b 40 18             	mov    0x18(%eax),%eax
80105add:	39 c2                	cmp    %eax,%edx
80105adf:	72 a9                	jb     80105a8a <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80105ae1:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105ae6:	c9                   	leave  
80105ae7:	c3                   	ret    

80105ae8 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105ae8:	55                   	push   %ebp
80105ae9:	89 e5                	mov    %esp,%ebp
80105aeb:	83 ec 48             	sub    $0x48,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105aee:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105af1:	89 44 24 04          	mov    %eax,0x4(%esp)
80105af5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105afc:	e8 77 fa ff ff       	call   80105578 <argstr>
80105b01:	85 c0                	test   %eax,%eax
80105b03:	79 0a                	jns    80105b0f <sys_unlink+0x27>
    return -1;
80105b05:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b0a:	e9 a9 01 00 00       	jmp    80105cb8 <sys_unlink+0x1d0>

  begin_op();
80105b0f:	e8 93 d9 ff ff       	call   801034a7 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105b14:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105b17:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105b1a:	89 54 24 04          	mov    %edx,0x4(%esp)
80105b1e:	89 04 24             	mov    %eax,(%esp)
80105b21:	e8 53 c9 ff ff       	call   80102479 <nameiparent>
80105b26:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105b29:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105b2d:	75 0f                	jne    80105b3e <sys_unlink+0x56>
    end_op();
80105b2f:	e8 f2 d9 ff ff       	call   80103526 <end_op>
    return -1;
80105b34:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b39:	e9 7a 01 00 00       	jmp    80105cb8 <sys_unlink+0x1d0>
  }

  ilock(dp);
80105b3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b41:	89 04 24             	mov    %eax,(%esp)
80105b44:	e8 6e bd ff ff       	call   801018b7 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105b49:	c7 44 24 04 0d 8d 10 	movl   $0x80108d0d,0x4(%esp)
80105b50:	80 
80105b51:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105b54:	89 04 24             	mov    %eax,(%esp)
80105b57:	e8 5d c5 ff ff       	call   801020b9 <namecmp>
80105b5c:	85 c0                	test   %eax,%eax
80105b5e:	0f 84 3f 01 00 00    	je     80105ca3 <sys_unlink+0x1bb>
80105b64:	c7 44 24 04 0f 8d 10 	movl   $0x80108d0f,0x4(%esp)
80105b6b:	80 
80105b6c:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105b6f:	89 04 24             	mov    %eax,(%esp)
80105b72:	e8 42 c5 ff ff       	call   801020b9 <namecmp>
80105b77:	85 c0                	test   %eax,%eax
80105b79:	0f 84 24 01 00 00    	je     80105ca3 <sys_unlink+0x1bb>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105b7f:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105b82:	89 44 24 08          	mov    %eax,0x8(%esp)
80105b86:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105b89:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b90:	89 04 24             	mov    %eax,(%esp)
80105b93:	e8 43 c5 ff ff       	call   801020db <dirlookup>
80105b98:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105b9b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105b9f:	0f 84 fd 00 00 00    	je     80105ca2 <sys_unlink+0x1ba>
    goto bad;
  ilock(ip);
80105ba5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ba8:	89 04 24             	mov    %eax,(%esp)
80105bab:	e8 07 bd ff ff       	call   801018b7 <ilock>

  if(ip->nlink < 1)
80105bb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bb3:	66 8b 40 16          	mov    0x16(%eax),%ax
80105bb7:	66 85 c0             	test   %ax,%ax
80105bba:	7f 0c                	jg     80105bc8 <sys_unlink+0xe0>
    panic("unlink: nlink < 1");
80105bbc:	c7 04 24 12 8d 10 80 	movl   $0x80108d12,(%esp)
80105bc3:	e8 6e a9 ff ff       	call   80100536 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105bc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bcb:	8b 40 10             	mov    0x10(%eax),%eax
80105bce:	66 83 f8 01          	cmp    $0x1,%ax
80105bd2:	75 1f                	jne    80105bf3 <sys_unlink+0x10b>
80105bd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bd7:	89 04 24             	mov    %eax,(%esp)
80105bda:	e8 9c fe ff ff       	call   80105a7b <isdirempty>
80105bdf:	85 c0                	test   %eax,%eax
80105be1:	75 10                	jne    80105bf3 <sys_unlink+0x10b>
    iunlockput(ip);
80105be3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105be6:	89 04 24             	mov    %eax,(%esp)
80105be9:	e8 50 bf ff ff       	call   80101b3e <iunlockput>
    goto bad;
80105bee:	e9 b0 00 00 00       	jmp    80105ca3 <sys_unlink+0x1bb>
  }

  memset(&de, 0, sizeof(de));
80105bf3:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80105bfa:	00 
80105bfb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105c02:	00 
80105c03:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105c06:	89 04 24             	mov    %eax,(%esp)
80105c09:	e8 a4 f5 ff ff       	call   801051b2 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105c0e:	8b 45 c8             	mov    -0x38(%ebp),%eax
80105c11:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105c18:	00 
80105c19:	89 44 24 08          	mov    %eax,0x8(%esp)
80105c1d:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105c20:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c27:	89 04 24             	mov    %eax,(%esp)
80105c2a:	e8 fa c2 ff ff       	call   80101f29 <writei>
80105c2f:	83 f8 10             	cmp    $0x10,%eax
80105c32:	74 0c                	je     80105c40 <sys_unlink+0x158>
    panic("unlink: writei");
80105c34:	c7 04 24 24 8d 10 80 	movl   $0x80108d24,(%esp)
80105c3b:	e8 f6 a8 ff ff       	call   80100536 <panic>
  if(ip->type == T_DIR){
80105c40:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c43:	8b 40 10             	mov    0x10(%eax),%eax
80105c46:	66 83 f8 01          	cmp    $0x1,%ax
80105c4a:	75 1a                	jne    80105c66 <sys_unlink+0x17e>
    dp->nlink--;
80105c4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c4f:	66 8b 40 16          	mov    0x16(%eax),%ax
80105c53:	48                   	dec    %eax
80105c54:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105c57:	66 89 42 16          	mov    %ax,0x16(%edx)
    iupdate(dp);
80105c5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c5e:	89 04 24             	mov    %eax,(%esp)
80105c61:	e8 91 ba ff ff       	call   801016f7 <iupdate>
  }
  iunlockput(dp);
80105c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c69:	89 04 24             	mov    %eax,(%esp)
80105c6c:	e8 cd be ff ff       	call   80101b3e <iunlockput>

  ip->nlink--;
80105c71:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c74:	66 8b 40 16          	mov    0x16(%eax),%ax
80105c78:	48                   	dec    %eax
80105c79:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105c7c:	66 89 42 16          	mov    %ax,0x16(%edx)
  iupdate(ip);
80105c80:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c83:	89 04 24             	mov    %eax,(%esp)
80105c86:	e8 6c ba ff ff       	call   801016f7 <iupdate>
  iunlockput(ip);
80105c8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c8e:	89 04 24             	mov    %eax,(%esp)
80105c91:	e8 a8 be ff ff       	call   80101b3e <iunlockput>

  end_op();
80105c96:	e8 8b d8 ff ff       	call   80103526 <end_op>

  return 0;
80105c9b:	b8 00 00 00 00       	mov    $0x0,%eax
80105ca0:	eb 16                	jmp    80105cb8 <sys_unlink+0x1d0>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
80105ca2:	90                   	nop
  end_op();

  return 0;

bad:
  iunlockput(dp);
80105ca3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ca6:	89 04 24             	mov    %eax,(%esp)
80105ca9:	e8 90 be ff ff       	call   80101b3e <iunlockput>
  end_op();
80105cae:	e8 73 d8 ff ff       	call   80103526 <end_op>
  return -1;
80105cb3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cb8:	c9                   	leave  
80105cb9:	c3                   	ret    

80105cba <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80105cba:	55                   	push   %ebp
80105cbb:	89 e5                	mov    %esp,%ebp
80105cbd:	83 ec 48             	sub    $0x48,%esp
80105cc0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105cc3:	8b 55 10             	mov    0x10(%ebp),%edx
80105cc6:	8b 45 14             	mov    0x14(%ebp),%eax
80105cc9:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80105ccd:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80105cd1:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105cd5:	8d 45 de             	lea    -0x22(%ebp),%eax
80105cd8:	89 44 24 04          	mov    %eax,0x4(%esp)
80105cdc:	8b 45 08             	mov    0x8(%ebp),%eax
80105cdf:	89 04 24             	mov    %eax,(%esp)
80105ce2:	e8 92 c7 ff ff       	call   80102479 <nameiparent>
80105ce7:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105cea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105cee:	75 0a                	jne    80105cfa <create+0x40>
    return 0;
80105cf0:	b8 00 00 00 00       	mov    $0x0,%eax
80105cf5:	e9 79 01 00 00       	jmp    80105e73 <create+0x1b9>
  ilock(dp);
80105cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cfd:	89 04 24             	mov    %eax,(%esp)
80105d00:	e8 b2 bb ff ff       	call   801018b7 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80105d05:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105d08:	89 44 24 08          	mov    %eax,0x8(%esp)
80105d0c:	8d 45 de             	lea    -0x22(%ebp),%eax
80105d0f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d16:	89 04 24             	mov    %eax,(%esp)
80105d19:	e8 bd c3 ff ff       	call   801020db <dirlookup>
80105d1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105d21:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105d25:	74 46                	je     80105d6d <create+0xb3>
    iunlockput(dp);
80105d27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d2a:	89 04 24             	mov    %eax,(%esp)
80105d2d:	e8 0c be ff ff       	call   80101b3e <iunlockput>
    ilock(ip);
80105d32:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d35:	89 04 24             	mov    %eax,(%esp)
80105d38:	e8 7a bb ff ff       	call   801018b7 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105d3d:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105d42:	75 14                	jne    80105d58 <create+0x9e>
80105d44:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d47:	8b 40 10             	mov    0x10(%eax),%eax
80105d4a:	66 83 f8 02          	cmp    $0x2,%ax
80105d4e:	75 08                	jne    80105d58 <create+0x9e>
      return ip;
80105d50:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d53:	e9 1b 01 00 00       	jmp    80105e73 <create+0x1b9>
    iunlockput(ip);
80105d58:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d5b:	89 04 24             	mov    %eax,(%esp)
80105d5e:	e8 db bd ff ff       	call   80101b3e <iunlockput>
    return 0;
80105d63:	b8 00 00 00 00       	mov    $0x0,%eax
80105d68:	e9 06 01 00 00       	jmp    80105e73 <create+0x1b9>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105d6d:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80105d71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d74:	8b 00                	mov    (%eax),%eax
80105d76:	89 54 24 04          	mov    %edx,0x4(%esp)
80105d7a:	89 04 24             	mov    %eax,(%esp)
80105d7d:	e8 a3 b8 ff ff       	call   80101625 <ialloc>
80105d82:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105d85:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105d89:	75 0c                	jne    80105d97 <create+0xdd>
    panic("create: ialloc");
80105d8b:	c7 04 24 33 8d 10 80 	movl   $0x80108d33,(%esp)
80105d92:	e8 9f a7 ff ff       	call   80100536 <panic>

  ilock(ip);
80105d97:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d9a:	89 04 24             	mov    %eax,(%esp)
80105d9d:	e8 15 bb ff ff       	call   801018b7 <ilock>
  ip->major = major;
80105da2:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105da5:	8b 45 d0             	mov    -0x30(%ebp),%eax
80105da8:	66 89 42 12          	mov    %ax,0x12(%edx)
  ip->minor = minor;
80105dac:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105daf:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105db2:	66 89 42 14          	mov    %ax,0x14(%edx)
  ip->nlink = 1;
80105db6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105db9:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80105dbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dc2:	89 04 24             	mov    %eax,(%esp)
80105dc5:	e8 2d b9 ff ff       	call   801016f7 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80105dca:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105dcf:	75 68                	jne    80105e39 <create+0x17f>
    dp->nlink++;  // for ".."
80105dd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dd4:	66 8b 40 16          	mov    0x16(%eax),%ax
80105dd8:	40                   	inc    %eax
80105dd9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105ddc:	66 89 42 16          	mov    %ax,0x16(%edx)
    iupdate(dp);
80105de0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105de3:	89 04 24             	mov    %eax,(%esp)
80105de6:	e8 0c b9 ff ff       	call   801016f7 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105deb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dee:	8b 40 04             	mov    0x4(%eax),%eax
80105df1:	89 44 24 08          	mov    %eax,0x8(%esp)
80105df5:	c7 44 24 04 0d 8d 10 	movl   $0x80108d0d,0x4(%esp)
80105dfc:	80 
80105dfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e00:	89 04 24             	mov    %eax,(%esp)
80105e03:	e8 98 c3 ff ff       	call   801021a0 <dirlink>
80105e08:	85 c0                	test   %eax,%eax
80105e0a:	78 21                	js     80105e2d <create+0x173>
80105e0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e0f:	8b 40 04             	mov    0x4(%eax),%eax
80105e12:	89 44 24 08          	mov    %eax,0x8(%esp)
80105e16:	c7 44 24 04 0f 8d 10 	movl   $0x80108d0f,0x4(%esp)
80105e1d:	80 
80105e1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e21:	89 04 24             	mov    %eax,(%esp)
80105e24:	e8 77 c3 ff ff       	call   801021a0 <dirlink>
80105e29:	85 c0                	test   %eax,%eax
80105e2b:	79 0c                	jns    80105e39 <create+0x17f>
      panic("create dots");
80105e2d:	c7 04 24 42 8d 10 80 	movl   $0x80108d42,(%esp)
80105e34:	e8 fd a6 ff ff       	call   80100536 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105e39:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e3c:	8b 40 04             	mov    0x4(%eax),%eax
80105e3f:	89 44 24 08          	mov    %eax,0x8(%esp)
80105e43:	8d 45 de             	lea    -0x22(%ebp),%eax
80105e46:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e4d:	89 04 24             	mov    %eax,(%esp)
80105e50:	e8 4b c3 ff ff       	call   801021a0 <dirlink>
80105e55:	85 c0                	test   %eax,%eax
80105e57:	79 0c                	jns    80105e65 <create+0x1ab>
    panic("create: dirlink");
80105e59:	c7 04 24 4e 8d 10 80 	movl   $0x80108d4e,(%esp)
80105e60:	e8 d1 a6 ff ff       	call   80100536 <panic>

  iunlockput(dp);
80105e65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e68:	89 04 24             	mov    %eax,(%esp)
80105e6b:	e8 ce bc ff ff       	call   80101b3e <iunlockput>

  return ip;
80105e70:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80105e73:	c9                   	leave  
80105e74:	c3                   	ret    

80105e75 <sys_open>:

int
sys_open(void)
{
80105e75:	55                   	push   %ebp
80105e76:	89 e5                	mov    %esp,%ebp
80105e78:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105e7b:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105e7e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e82:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105e89:	e8 ea f6 ff ff       	call   80105578 <argstr>
80105e8e:	85 c0                	test   %eax,%eax
80105e90:	78 17                	js     80105ea9 <sys_open+0x34>
80105e92:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105e95:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e99:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105ea0:	e8 43 f6 ff ff       	call   801054e8 <argint>
80105ea5:	85 c0                	test   %eax,%eax
80105ea7:	79 0a                	jns    80105eb3 <sys_open+0x3e>
    return -1;
80105ea9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105eae:	e9 5b 01 00 00       	jmp    8010600e <sys_open+0x199>

  begin_op();
80105eb3:	e8 ef d5 ff ff       	call   801034a7 <begin_op>

  if(omode & O_CREATE){
80105eb8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105ebb:	25 00 02 00 00       	and    $0x200,%eax
80105ec0:	85 c0                	test   %eax,%eax
80105ec2:	74 3b                	je     80105eff <sys_open+0x8a>
    ip = create(path, T_FILE, 0, 0);
80105ec4:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105ec7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80105ece:	00 
80105ecf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80105ed6:	00 
80105ed7:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80105ede:	00 
80105edf:	89 04 24             	mov    %eax,(%esp)
80105ee2:	e8 d3 fd ff ff       	call   80105cba <create>
80105ee7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
80105eea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105eee:	75 6a                	jne    80105f5a <sys_open+0xe5>
      end_op();
80105ef0:	e8 31 d6 ff ff       	call   80103526 <end_op>
      return -1;
80105ef5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105efa:	e9 0f 01 00 00       	jmp    8010600e <sys_open+0x199>
    }
  } else {
    if((ip = namei(path)) == 0){
80105eff:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105f02:	89 04 24             	mov    %eax,(%esp)
80105f05:	e8 4d c5 ff ff       	call   80102457 <namei>
80105f0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105f0d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105f11:	75 0f                	jne    80105f22 <sys_open+0xad>
      end_op();
80105f13:	e8 0e d6 ff ff       	call   80103526 <end_op>
      return -1;
80105f18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f1d:	e9 ec 00 00 00       	jmp    8010600e <sys_open+0x199>
    }
    ilock(ip);
80105f22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f25:	89 04 24             	mov    %eax,(%esp)
80105f28:	e8 8a b9 ff ff       	call   801018b7 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105f2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f30:	8b 40 10             	mov    0x10(%eax),%eax
80105f33:	66 83 f8 01          	cmp    $0x1,%ax
80105f37:	75 21                	jne    80105f5a <sys_open+0xe5>
80105f39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105f3c:	85 c0                	test   %eax,%eax
80105f3e:	74 1a                	je     80105f5a <sys_open+0xe5>
      iunlockput(ip);
80105f40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f43:	89 04 24             	mov    %eax,(%esp)
80105f46:	e8 f3 bb ff ff       	call   80101b3e <iunlockput>
      end_op();
80105f4b:	e8 d6 d5 ff ff       	call   80103526 <end_op>
      return -1;
80105f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f55:	e9 b4 00 00 00       	jmp    8010600e <sys_open+0x199>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105f5a:	e8 c9 af ff ff       	call   80100f28 <filealloc>
80105f5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105f62:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105f66:	74 14                	je     80105f7c <sys_open+0x107>
80105f68:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f6b:	89 04 24             	mov    %eax,(%esp)
80105f6e:	e8 42 f7 ff ff       	call   801056b5 <fdalloc>
80105f73:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105f76:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80105f7a:	79 28                	jns    80105fa4 <sys_open+0x12f>
    if(f)
80105f7c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105f80:	74 0b                	je     80105f8d <sys_open+0x118>
      fileclose(f);
80105f82:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f85:	89 04 24             	mov    %eax,(%esp)
80105f88:	e8 43 b0 ff ff       	call   80100fd0 <fileclose>
    iunlockput(ip);
80105f8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f90:	89 04 24             	mov    %eax,(%esp)
80105f93:	e8 a6 bb ff ff       	call   80101b3e <iunlockput>
    end_op();
80105f98:	e8 89 d5 ff ff       	call   80103526 <end_op>
    return -1;
80105f9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fa2:	eb 6a                	jmp    8010600e <sys_open+0x199>
  }
  iunlock(ip);
80105fa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fa7:	89 04 24             	mov    %eax,(%esp)
80105faa:	e8 59 ba ff ff       	call   80101a08 <iunlock>
  end_op();
80105faf:	e8 72 d5 ff ff       	call   80103526 <end_op>

  f->type = FD_INODE;
80105fb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fb7:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80105fbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fc0:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105fc3:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80105fc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fc9:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80105fd0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105fd3:	83 e0 01             	and    $0x1,%eax
80105fd6:	85 c0                	test   %eax,%eax
80105fd8:	0f 94 c0             	sete   %al
80105fdb:	88 c2                	mov    %al,%dl
80105fdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fe0:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105fe3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105fe6:	83 e0 01             	and    $0x1,%eax
80105fe9:	85 c0                	test   %eax,%eax
80105feb:	75 0a                	jne    80105ff7 <sys_open+0x182>
80105fed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105ff0:	83 e0 02             	and    $0x2,%eax
80105ff3:	85 c0                	test   %eax,%eax
80105ff5:	74 07                	je     80105ffe <sys_open+0x189>
80105ff7:	b8 01 00 00 00       	mov    $0x1,%eax
80105ffc:	eb 05                	jmp    80106003 <sys_open+0x18e>
80105ffe:	b8 00 00 00 00       	mov    $0x0,%eax
80106003:	88 c2                	mov    %al,%dl
80106005:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106008:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
8010600b:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
8010600e:	c9                   	leave  
8010600f:	c3                   	ret    

80106010 <sys_mkdir>:

int
sys_mkdir(void)
{
80106010:	55                   	push   %ebp
80106011:	89 e5                	mov    %esp,%ebp
80106013:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106016:	e8 8c d4 ff ff       	call   801034a7 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010601b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010601e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106022:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106029:	e8 4a f5 ff ff       	call   80105578 <argstr>
8010602e:	85 c0                	test   %eax,%eax
80106030:	78 2c                	js     8010605e <sys_mkdir+0x4e>
80106032:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106035:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
8010603c:	00 
8010603d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106044:	00 
80106045:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010604c:	00 
8010604d:	89 04 24             	mov    %eax,(%esp)
80106050:	e8 65 fc ff ff       	call   80105cba <create>
80106055:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106058:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010605c:	75 0c                	jne    8010606a <sys_mkdir+0x5a>
    end_op();
8010605e:	e8 c3 d4 ff ff       	call   80103526 <end_op>
    return -1;
80106063:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106068:	eb 15                	jmp    8010607f <sys_mkdir+0x6f>
  }
  iunlockput(ip);
8010606a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010606d:	89 04 24             	mov    %eax,(%esp)
80106070:	e8 c9 ba ff ff       	call   80101b3e <iunlockput>
  end_op();
80106075:	e8 ac d4 ff ff       	call   80103526 <end_op>
  return 0;
8010607a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010607f:	c9                   	leave  
80106080:	c3                   	ret    

80106081 <sys_mknod>:

int
sys_mknod(void)
{
80106081:	55                   	push   %ebp
80106082:	89 e5                	mov    %esp,%ebp
80106084:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
80106087:	e8 1b d4 ff ff       	call   801034a7 <begin_op>
  if((len=argstr(0, &path)) < 0 ||
8010608c:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010608f:	89 44 24 04          	mov    %eax,0x4(%esp)
80106093:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010609a:	e8 d9 f4 ff ff       	call   80105578 <argstr>
8010609f:	89 45 f4             	mov    %eax,-0xc(%ebp)
801060a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801060a6:	78 5e                	js     80106106 <sys_mknod+0x85>
     argint(1, &major) < 0 ||
801060a8:	8d 45 e8             	lea    -0x18(%ebp),%eax
801060ab:	89 44 24 04          	mov    %eax,0x4(%esp)
801060af:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801060b6:	e8 2d f4 ff ff       	call   801054e8 <argint>
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
801060bb:	85 c0                	test   %eax,%eax
801060bd:	78 47                	js     80106106 <sys_mknod+0x85>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801060bf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801060c2:	89 44 24 04          	mov    %eax,0x4(%esp)
801060c6:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801060cd:	e8 16 f4 ff ff       	call   801054e8 <argint>
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
801060d2:	85 c0                	test   %eax,%eax
801060d4:	78 30                	js     80106106 <sys_mknod+0x85>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
801060d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801060d9:	0f bf c8             	movswl %ax,%ecx
801060dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
801060df:	0f bf d0             	movswl %ax,%edx
801060e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801060e5:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
801060e9:	89 54 24 08          	mov    %edx,0x8(%esp)
801060ed:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
801060f4:	00 
801060f5:	89 04 24             	mov    %eax,(%esp)
801060f8:	e8 bd fb ff ff       	call   80105cba <create>
801060fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106100:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106104:	75 0c                	jne    80106112 <sys_mknod+0x91>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80106106:	e8 1b d4 ff ff       	call   80103526 <end_op>
    return -1;
8010610b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106110:	eb 15                	jmp    80106127 <sys_mknod+0xa6>
  }
  iunlockput(ip);
80106112:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106115:	89 04 24             	mov    %eax,(%esp)
80106118:	e8 21 ba ff ff       	call   80101b3e <iunlockput>
  end_op();
8010611d:	e8 04 d4 ff ff       	call   80103526 <end_op>
  return 0;
80106122:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106127:	c9                   	leave  
80106128:	c3                   	ret    

80106129 <sys_chdir>:

int
sys_chdir(void)
{
80106129:	55                   	push   %ebp
8010612a:	89 e5                	mov    %esp,%ebp
8010612c:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
8010612f:	e8 73 d3 ff ff       	call   801034a7 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106134:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106137:	89 44 24 04          	mov    %eax,0x4(%esp)
8010613b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106142:	e8 31 f4 ff ff       	call   80105578 <argstr>
80106147:	85 c0                	test   %eax,%eax
80106149:	78 14                	js     8010615f <sys_chdir+0x36>
8010614b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010614e:	89 04 24             	mov    %eax,(%esp)
80106151:	e8 01 c3 ff ff       	call   80102457 <namei>
80106156:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106159:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010615d:	75 0c                	jne    8010616b <sys_chdir+0x42>
    end_op();
8010615f:	e8 c2 d3 ff ff       	call   80103526 <end_op>
    return -1;
80106164:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106169:	eb 60                	jmp    801061cb <sys_chdir+0xa2>
  }
  ilock(ip);
8010616b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010616e:	89 04 24             	mov    %eax,(%esp)
80106171:	e8 41 b7 ff ff       	call   801018b7 <ilock>
  if(ip->type != T_DIR){
80106176:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106179:	8b 40 10             	mov    0x10(%eax),%eax
8010617c:	66 83 f8 01          	cmp    $0x1,%ax
80106180:	74 17                	je     80106199 <sys_chdir+0x70>
    iunlockput(ip);
80106182:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106185:	89 04 24             	mov    %eax,(%esp)
80106188:	e8 b1 b9 ff ff       	call   80101b3e <iunlockput>
    end_op();
8010618d:	e8 94 d3 ff ff       	call   80103526 <end_op>
    return -1;
80106192:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106197:	eb 32                	jmp    801061cb <sys_chdir+0xa2>
  }
  iunlock(ip);
80106199:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010619c:	89 04 24             	mov    %eax,(%esp)
8010619f:	e8 64 b8 ff ff       	call   80101a08 <iunlock>
  iput(proc->cwd);
801061a4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801061aa:	8b 40 68             	mov    0x68(%eax),%eax
801061ad:	89 04 24             	mov    %eax,(%esp)
801061b0:	e8 b8 b8 ff ff       	call   80101a6d <iput>
  end_op();
801061b5:	e8 6c d3 ff ff       	call   80103526 <end_op>
  proc->cwd = ip;
801061ba:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801061c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801061c3:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
801061c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
801061cb:	c9                   	leave  
801061cc:	c3                   	ret    

801061cd <sys_exec>:

int
sys_exec(void)
{
801061cd:	55                   	push   %ebp
801061ce:	89 e5                	mov    %esp,%ebp
801061d0:	81 ec a8 00 00 00    	sub    $0xa8,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801061d6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801061d9:	89 44 24 04          	mov    %eax,0x4(%esp)
801061dd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801061e4:	e8 8f f3 ff ff       	call   80105578 <argstr>
801061e9:	85 c0                	test   %eax,%eax
801061eb:	78 1a                	js     80106207 <sys_exec+0x3a>
801061ed:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
801061f3:	89 44 24 04          	mov    %eax,0x4(%esp)
801061f7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801061fe:	e8 e5 f2 ff ff       	call   801054e8 <argint>
80106203:	85 c0                	test   %eax,%eax
80106205:	79 0a                	jns    80106211 <sys_exec+0x44>
    return -1;
80106207:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010620c:	e9 c7 00 00 00       	jmp    801062d8 <sys_exec+0x10b>
  }
  memset(argv, 0, sizeof(argv));
80106211:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80106218:	00 
80106219:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106220:	00 
80106221:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106227:	89 04 24             	mov    %eax,(%esp)
8010622a:	e8 83 ef ff ff       	call   801051b2 <memset>
  for(i=0;; i++){
8010622f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80106236:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106239:	83 f8 1f             	cmp    $0x1f,%eax
8010623c:	76 0a                	jbe    80106248 <sys_exec+0x7b>
      return -1;
8010623e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106243:	e9 90 00 00 00       	jmp    801062d8 <sys_exec+0x10b>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106248:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010624b:	c1 e0 02             	shl    $0x2,%eax
8010624e:	89 c2                	mov    %eax,%edx
80106250:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80106256:	01 c2                	add    %eax,%edx
80106258:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
8010625e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106262:	89 14 24             	mov    %edx,(%esp)
80106265:	e8 e2 f1 ff ff       	call   8010544c <fetchint>
8010626a:	85 c0                	test   %eax,%eax
8010626c:	79 07                	jns    80106275 <sys_exec+0xa8>
      return -1;
8010626e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106273:	eb 63                	jmp    801062d8 <sys_exec+0x10b>
    if(uarg == 0){
80106275:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
8010627b:	85 c0                	test   %eax,%eax
8010627d:	75 26                	jne    801062a5 <sys_exec+0xd8>
      argv[i] = 0;
8010627f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106282:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80106289:	00 00 00 00 
      break;
8010628d:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
8010628e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106291:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80106297:	89 54 24 04          	mov    %edx,0x4(%esp)
8010629b:	89 04 24             	mov    %eax,(%esp)
8010629e:	e8 49 a8 ff ff       	call   80100aec <exec>
801062a3:	eb 33                	jmp    801062d8 <sys_exec+0x10b>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801062a5:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801062ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
801062ae:	c1 e2 02             	shl    $0x2,%edx
801062b1:	01 c2                	add    %eax,%edx
801062b3:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801062b9:	89 54 24 04          	mov    %edx,0x4(%esp)
801062bd:	89 04 24             	mov    %eax,(%esp)
801062c0:	e8 c1 f1 ff ff       	call   80105486 <fetchstr>
801062c5:	85 c0                	test   %eax,%eax
801062c7:	79 07                	jns    801062d0 <sys_exec+0x103>
      return -1;
801062c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062ce:	eb 08                	jmp    801062d8 <sys_exec+0x10b>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
801062d0:	ff 45 f4             	incl   -0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
801062d3:	e9 5e ff ff ff       	jmp    80106236 <sys_exec+0x69>
  return exec(path, argv);
}
801062d8:	c9                   	leave  
801062d9:	c3                   	ret    

801062da <sys_pipe>:

int
sys_pipe(void)
{
801062da:	55                   	push   %ebp
801062db:	89 e5                	mov    %esp,%ebp
801062dd:	83 ec 38             	sub    $0x38,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801062e0:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
801062e7:	00 
801062e8:	8d 45 ec             	lea    -0x14(%ebp),%eax
801062eb:	89 44 24 04          	mov    %eax,0x4(%esp)
801062ef:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801062f6:	e8 1b f2 ff ff       	call   80105516 <argptr>
801062fb:	85 c0                	test   %eax,%eax
801062fd:	79 0a                	jns    80106309 <sys_pipe+0x2f>
    return -1;
801062ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106304:	e9 9b 00 00 00       	jmp    801063a4 <sys_pipe+0xca>
  if(pipealloc(&rf, &wf) < 0)
80106309:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010630c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106310:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106313:	89 04 24             	mov    %eax,(%esp)
80106316:	e8 ed dc ff ff       	call   80104008 <pipealloc>
8010631b:	85 c0                	test   %eax,%eax
8010631d:	79 07                	jns    80106326 <sys_pipe+0x4c>
    return -1;
8010631f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106324:	eb 7e                	jmp    801063a4 <sys_pipe+0xca>
  fd0 = -1;
80106326:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010632d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106330:	89 04 24             	mov    %eax,(%esp)
80106333:	e8 7d f3 ff ff       	call   801056b5 <fdalloc>
80106338:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010633b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010633f:	78 14                	js     80106355 <sys_pipe+0x7b>
80106341:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106344:	89 04 24             	mov    %eax,(%esp)
80106347:	e8 69 f3 ff ff       	call   801056b5 <fdalloc>
8010634c:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010634f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106353:	79 37                	jns    8010638c <sys_pipe+0xb2>
    if(fd0 >= 0)
80106355:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106359:	78 14                	js     8010636f <sys_pipe+0x95>
      proc->ofile[fd0] = 0;
8010635b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106361:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106364:	83 c2 08             	add    $0x8,%edx
80106367:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010636e:	00 
    fileclose(rf);
8010636f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106372:	89 04 24             	mov    %eax,(%esp)
80106375:	e8 56 ac ff ff       	call   80100fd0 <fileclose>
    fileclose(wf);
8010637a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010637d:	89 04 24             	mov    %eax,(%esp)
80106380:	e8 4b ac ff ff       	call   80100fd0 <fileclose>
    return -1;
80106385:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010638a:	eb 18                	jmp    801063a4 <sys_pipe+0xca>
  }
  fd[0] = fd0;
8010638c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010638f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106392:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80106394:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106397:	8d 50 04             	lea    0x4(%eax),%edx
8010639a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010639d:	89 02                	mov    %eax,(%edx)
  return 0;
8010639f:	b8 00 00 00 00       	mov    $0x0,%eax
}
801063a4:	c9                   	leave  
801063a5:	c3                   	ret    
801063a6:	66 90                	xchg   %ax,%ax

801063a8 <outw>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outw(ushort port, ushort data)
{
801063a8:	55                   	push   %ebp
801063a9:	89 e5                	mov    %esp,%ebp
801063ab:	83 ec 08             	sub    $0x8,%esp
801063ae:	8b 55 08             	mov    0x8(%ebp),%edx
801063b1:	8b 45 0c             	mov    0xc(%ebp),%eax
801063b4:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801063b8:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801063bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
801063bf:	8b 55 fc             	mov    -0x4(%ebp),%edx
801063c2:	66 ef                	out    %ax,(%dx)
}
801063c4:	c9                   	leave  
801063c5:	c3                   	ret    

801063c6 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801063c6:	55                   	push   %ebp
801063c7:	89 e5                	mov    %esp,%ebp
801063c9:	83 ec 08             	sub    $0x8,%esp
  return fork();
801063cc:	e8 3a e3 ff ff       	call   8010470b <fork>
}
801063d1:	c9                   	leave  
801063d2:	c3                   	ret    

801063d3 <sys_exit>:

int
sys_exit(void)
{
801063d3:	55                   	push   %ebp
801063d4:	89 e5                	mov    %esp,%ebp
801063d6:	83 ec 08             	sub    $0x8,%esp
  exit();
801063d9:	e8 a7 e4 ff ff       	call   80104885 <exit>
  return 0;  // not reached
801063de:	b8 00 00 00 00       	mov    $0x0,%eax
}
801063e3:	c9                   	leave  
801063e4:	c3                   	ret    

801063e5 <sys_wait>:

int
sys_wait(void)
{
801063e5:	55                   	push   %ebp
801063e6:	89 e5                	mov    %esp,%ebp
801063e8:	83 ec 08             	sub    $0x8,%esp
  return wait();
801063eb:	e8 b9 e5 ff ff       	call   801049a9 <wait>
}
801063f0:	c9                   	leave  
801063f1:	c3                   	ret    

801063f2 <sys_kill>:

int
sys_kill(void)
{
801063f2:	55                   	push   %ebp
801063f3:	89 e5                	mov    %esp,%ebp
801063f5:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
801063f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801063fb:	89 44 24 04          	mov    %eax,0x4(%esp)
801063ff:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106406:	e8 dd f0 ff ff       	call   801054e8 <argint>
8010640b:	85 c0                	test   %eax,%eax
8010640d:	79 07                	jns    80106416 <sys_kill+0x24>
    return -1;
8010640f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106414:	eb 0b                	jmp    80106421 <sys_kill+0x2f>
  return kill(pid);
80106416:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106419:	89 04 24             	mov    %eax,(%esp)
8010641c:	e8 60 e9 ff ff       	call   80104d81 <kill>
}
80106421:	c9                   	leave  
80106422:	c3                   	ret    

80106423 <sys_getpid>:

int
sys_getpid(void)
{
80106423:	55                   	push   %ebp
80106424:	89 e5                	mov    %esp,%ebp
  return proc->pid;
80106426:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010642c:	8b 40 10             	mov    0x10(%eax),%eax
}
8010642f:	5d                   	pop    %ebp
80106430:	c3                   	ret    

80106431 <sys_sbrk>:

int
sys_sbrk(void)
{
80106431:	55                   	push   %ebp
80106432:	89 e5                	mov    %esp,%ebp
80106434:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106437:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010643a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010643e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106445:	e8 9e f0 ff ff       	call   801054e8 <argint>
8010644a:	85 c0                	test   %eax,%eax
8010644c:	79 07                	jns    80106455 <sys_sbrk+0x24>
    return -1;
8010644e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106453:	eb 24                	jmp    80106479 <sys_sbrk+0x48>
  addr = proc->sz;
80106455:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010645b:	8b 00                	mov    (%eax),%eax
8010645d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80106460:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106463:	89 04 24             	mov    %eax,(%esp)
80106466:	e8 fb e1 ff ff       	call   80104666 <growproc>
8010646b:	85 c0                	test   %eax,%eax
8010646d:	79 07                	jns    80106476 <sys_sbrk+0x45>
    return -1;
8010646f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106474:	eb 03                	jmp    80106479 <sys_sbrk+0x48>
  return addr;
80106476:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106479:	c9                   	leave  
8010647a:	c3                   	ret    

8010647b <sys_sleep>:

int
sys_sleep(void)
{
8010647b:	55                   	push   %ebp
8010647c:	89 e5                	mov    %esp,%ebp
8010647e:	83 ec 28             	sub    $0x28,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
80106481:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106484:	89 44 24 04          	mov    %eax,0x4(%esp)
80106488:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010648f:	e8 54 f0 ff ff       	call   801054e8 <argint>
80106494:	85 c0                	test   %eax,%eax
80106496:	79 07                	jns    8010649f <sys_sleep+0x24>
    return -1;
80106498:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010649d:	eb 6c                	jmp    8010650b <sys_sleep+0x90>
  acquire(&tickslock);
8010649f:	c7 04 24 c0 7b 11 80 	movl   $0x80117bc0,(%esp)
801064a6:	e8 b4 ea ff ff       	call   80104f5f <acquire>
  ticks0 = ticks;
801064ab:	a1 00 84 11 80       	mov    0x80118400,%eax
801064b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
801064b3:	eb 34                	jmp    801064e9 <sys_sleep+0x6e>
    if(proc->killed){
801064b5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801064bb:	8b 40 24             	mov    0x24(%eax),%eax
801064be:	85 c0                	test   %eax,%eax
801064c0:	74 13                	je     801064d5 <sys_sleep+0x5a>
      release(&tickslock);
801064c2:	c7 04 24 c0 7b 11 80 	movl   $0x80117bc0,(%esp)
801064c9:	e8 f3 ea ff ff       	call   80104fc1 <release>
      return -1;
801064ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064d3:	eb 36                	jmp    8010650b <sys_sleep+0x90>
    }
    sleep(&ticks, &tickslock);
801064d5:	c7 44 24 04 c0 7b 11 	movl   $0x80117bc0,0x4(%esp)
801064dc:	80 
801064dd:	c7 04 24 00 84 11 80 	movl   $0x80118400,(%esp)
801064e4:	e8 91 e7 ff ff       	call   80104c7a <sleep>
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801064e9:	a1 00 84 11 80       	mov    0x80118400,%eax
801064ee:	89 c2                	mov    %eax,%edx
801064f0:	2b 55 f4             	sub    -0xc(%ebp),%edx
801064f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064f6:	39 c2                	cmp    %eax,%edx
801064f8:	72 bb                	jb     801064b5 <sys_sleep+0x3a>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
801064fa:	c7 04 24 c0 7b 11 80 	movl   $0x80117bc0,(%esp)
80106501:	e8 bb ea ff ff       	call   80104fc1 <release>
  return 0;
80106506:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010650b:	c9                   	leave  
8010650c:	c3                   	ret    

8010650d <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
8010650d:	55                   	push   %ebp
8010650e:	89 e5                	mov    %esp,%ebp
80106510:	83 ec 28             	sub    $0x28,%esp
  uint xticks;
  
  acquire(&tickslock);
80106513:	c7 04 24 c0 7b 11 80 	movl   $0x80117bc0,(%esp)
8010651a:	e8 40 ea ff ff       	call   80104f5f <acquire>
  xticks = ticks;
8010651f:	a1 00 84 11 80       	mov    0x80118400,%eax
80106524:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80106527:	c7 04 24 c0 7b 11 80 	movl   $0x80117bc0,(%esp)
8010652e:	e8 8e ea ff ff       	call   80104fc1 <release>
  return xticks;
80106533:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106536:	c9                   	leave  
80106537:	c3                   	ret    

80106538 <sys_halt>:
// signal to QEMU.
// Based on: http://pdos.csail.mit.edu/6.828/2012/homework/xv6-syscall.html
// and: https://github.com/t3rm1n4l/pintos/blob/master/devices/shutdown.c
int
sys_halt(void)
{
80106538:	55                   	push   %ebp
80106539:	89 e5                	mov    %esp,%ebp
8010653b:	83 ec 18             	sub    $0x18,%esp
  char *p = "Shutdown";
8010653e:	c7 45 fc 5e 8d 10 80 	movl   $0x80108d5e,-0x4(%ebp)
  for( ; *p; p++)
80106545:	eb 17                	jmp    8010655e <sys_halt+0x26>
    outw(0xB004, 0x2000);
80106547:	c7 44 24 04 00 20 00 	movl   $0x2000,0x4(%esp)
8010654e:	00 
8010654f:	c7 04 24 04 b0 00 00 	movl   $0xb004,(%esp)
80106556:	e8 4d fe ff ff       	call   801063a8 <outw>
// and: https://github.com/t3rm1n4l/pintos/blob/master/devices/shutdown.c
int
sys_halt(void)
{
  char *p = "Shutdown";
  for( ; *p; p++)
8010655b:	ff 45 fc             	incl   -0x4(%ebp)
8010655e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106561:	8a 00                	mov    (%eax),%al
80106563:	84 c0                	test   %al,%al
80106565:	75 e0                	jne    80106547 <sys_halt+0xf>
    outw(0xB004, 0x2000);
  return 0;
80106567:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010656c:	c9                   	leave  
8010656d:	c3                   	ret    

8010656e <sys_register_signal_handler>:


int sys_register_signal_handler(void)
{
8010656e:	55                   	push   %ebp
8010656f:	89 e5                	mov    %esp,%ebp
80106571:	83 ec 28             	sub    $0x28,%esp

  int signum; // The number that represents the signal
  int sighandler; // The number that represents the handler
  int trampoline;// This represents the trampoline function

  if(argint(0, &signum) < 0) return -1; // Get the first argument
80106574:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106577:	89 44 24 04          	mov    %eax,0x4(%esp)
8010657b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106582:	e8 61 ef ff ff       	call   801054e8 <argint>
80106587:	85 c0                	test   %eax,%eax
80106589:	79 07                	jns    80106592 <sys_register_signal_handler+0x24>
8010658b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106590:	eb 61                	jmp    801065f3 <sys_register_signal_handler+0x85>
  if(argint(1, &sighandler) < 0) return -1; // Get the second argument
80106592:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106595:	89 44 24 04          	mov    %eax,0x4(%esp)
80106599:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801065a0:	e8 43 ef ff ff       	call   801054e8 <argint>
801065a5:	85 c0                	test   %eax,%eax
801065a7:	79 07                	jns    801065b0 <sys_register_signal_handler+0x42>
801065a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065ae:	eb 43                	jmp    801065f3 <sys_register_signal_handler+0x85>
  if(argint(2, &trampoline) < 0) return -1; // Get the third argument
801065b0:	8d 45 ec             	lea    -0x14(%ebp),%eax
801065b3:	89 44 24 04          	mov    %eax,0x4(%esp)
801065b7:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801065be:	e8 25 ef ff ff       	call   801054e8 <argint>
801065c3:	85 c0                	test   %eax,%eax
801065c5:	79 07                	jns    801065ce <sys_register_signal_handler+0x60>
801065c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065cc:	eb 25                	jmp    801065f3 <sys_register_signal_handler+0x85>

  proc->handlers[signum] = sighandler; // Set the handler for the specific signal
801065ce:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801065d4:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801065d7:	8b 55 f0             	mov    -0x10(%ebp),%edx
801065da:	83 c1 1c             	add    $0x1c,%ecx
801065dd:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
  proc->trampoline = trampoline;
801065e1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801065e7:	8b 55 ec             	mov    -0x14(%ebp),%edx
801065ea:	89 90 04 01 00 00    	mov    %edx,0x104(%eax)

  return sighandler; // Return the signal handler
801065f0:	8b 45 f0             	mov    -0x10(%ebp),%eax

  //return 0;
}
801065f3:	c9                   	leave  
801065f4:	c3                   	ret    

801065f5 <sys_alarm>:

int sys_alarm(void)
{
801065f5:	55                   	push   %ebp
801065f6:	89 e5                	mov    %esp,%ebp
801065f8:	83 ec 28             	sub    $0x28,%esp

  int seconds; // THe number of seconds for the timer
  if(argint(0, &seconds) < 0) return -1; // Get the first argument
801065fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801065fe:	89 44 24 04          	mov    %eax,0x4(%esp)
80106602:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106609:	e8 da ee ff ff       	call   801054e8 <argint>
8010660e:	85 c0                	test   %eax,%eax
80106610:	79 07                	jns    80106619 <sys_alarm+0x24>
80106612:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106617:	eb 24                	jmp    8010663d <sys_alarm+0x48>

  proc->numberOfTicks = seconds; // Get the number of seconds and put it in the proc
80106619:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010661f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106622:	89 90 00 01 00 00    	mov    %edx,0x100(%eax)
  proc->alarmState = 0; // Set the alarm state to needed, but off
80106628:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010662e:	c7 80 fc 00 00 00 00 	movl   $0x0,0xfc(%eax)
80106635:	00 00 00 
  
  return 0;
80106638:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010663d:	c9                   	leave  
8010663e:	c3                   	ret    
8010663f:	90                   	nop

80106640 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106640:	55                   	push   %ebp
80106641:	89 e5                	mov    %esp,%ebp
80106643:	83 ec 08             	sub    $0x8,%esp
80106646:	8b 45 08             	mov    0x8(%ebp),%eax
80106649:	8b 55 0c             	mov    0xc(%ebp),%edx
8010664c:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80106650:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106653:	8a 45 f8             	mov    -0x8(%ebp),%al
80106656:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106659:	ee                   	out    %al,(%dx)
}
8010665a:	c9                   	leave  
8010665b:	c3                   	ret    

8010665c <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
8010665c:	55                   	push   %ebp
8010665d:	89 e5                	mov    %esp,%ebp
8010665f:	83 ec 18             	sub    $0x18,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80106662:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
80106669:	00 
8010666a:	c7 04 24 43 00 00 00 	movl   $0x43,(%esp)
80106671:	e8 ca ff ff ff       	call   80106640 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80106676:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
8010667d:	00 
8010667e:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
80106685:	e8 b6 ff ff ff       	call   80106640 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
8010668a:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
80106691:	00 
80106692:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
80106699:	e8 a2 ff ff ff       	call   80106640 <outb>
  picenable(IRQ_TIMER);
8010669e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801066a5:	e8 ea d7 ff ff       	call   80103e94 <picenable>
}
801066aa:	c9                   	leave  
801066ab:	c3                   	ret    

801066ac <alltraps>:
801066ac:	1e                   	push   %ds
801066ad:	06                   	push   %es
801066ae:	0f a0                	push   %fs
801066b0:	0f a8                	push   %gs
801066b2:	60                   	pusha  
801066b3:	66 b8 10 00          	mov    $0x10,%ax
801066b7:	8e d8                	mov    %eax,%ds
801066b9:	8e c0                	mov    %eax,%es
801066bb:	66 b8 18 00          	mov    $0x18,%ax
801066bf:	8e e0                	mov    %eax,%fs
801066c1:	8e e8                	mov    %eax,%gs
801066c3:	54                   	push   %esp
801066c4:	e8 c5 01 00 00       	call   8010688e <trap>
801066c9:	83 c4 04             	add    $0x4,%esp

801066cc <trapret>:
801066cc:	61                   	popa   
801066cd:	0f a9                	pop    %gs
801066cf:	0f a1                	pop    %fs
801066d1:	07                   	pop    %es
801066d2:	1f                   	pop    %ds
801066d3:	83 c4 08             	add    $0x8,%esp
801066d6:	cf                   	iret   
801066d7:	90                   	nop

801066d8 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
801066d8:	55                   	push   %ebp
801066d9:	89 e5                	mov    %esp,%ebp
801066db:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
801066de:	8b 45 0c             	mov    0xc(%ebp),%eax
801066e1:	48                   	dec    %eax
801066e2:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801066e6:	8b 45 08             	mov    0x8(%ebp),%eax
801066e9:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801066ed:	8b 45 08             	mov    0x8(%ebp),%eax
801066f0:	c1 e8 10             	shr    $0x10,%eax
801066f3:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
801066f7:	8d 45 fa             	lea    -0x6(%ebp),%eax
801066fa:	0f 01 18             	lidtl  (%eax)
}
801066fd:	c9                   	leave  
801066fe:	c3                   	ret    

801066ff <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
801066ff:	55                   	push   %ebp
80106700:	89 e5                	mov    %esp,%ebp
80106702:	53                   	push   %ebx
80106703:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106706:	0f 20 d3             	mov    %cr2,%ebx
80106709:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return val;
8010670c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
8010670f:	83 c4 10             	add    $0x10,%esp
80106712:	5b                   	pop    %ebx
80106713:	5d                   	pop    %ebp
80106714:	c3                   	ret    

80106715 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106715:	55                   	push   %ebp
80106716:	89 e5                	mov    %esp,%ebp
80106718:	83 ec 28             	sub    $0x28,%esp
  int i;

  for(i = 0; i < 256; i++)
8010671b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106722:	e9 b8 00 00 00       	jmp    801067df <tvinit+0xca>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106727:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010672a:	8b 04 85 a4 c0 10 80 	mov    -0x7fef3f5c(,%eax,4),%eax
80106731:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106734:	66 89 04 d5 00 7c 11 	mov    %ax,-0x7fee8400(,%edx,8)
8010673b:	80 
8010673c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010673f:	66 c7 04 c5 02 7c 11 	movw   $0x8,-0x7fee83fe(,%eax,8)
80106746:	80 08 00 
80106749:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010674c:	8a 14 c5 04 7c 11 80 	mov    -0x7fee83fc(,%eax,8),%dl
80106753:	83 e2 e0             	and    $0xffffffe0,%edx
80106756:	88 14 c5 04 7c 11 80 	mov    %dl,-0x7fee83fc(,%eax,8)
8010675d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106760:	8a 14 c5 04 7c 11 80 	mov    -0x7fee83fc(,%eax,8),%dl
80106767:	83 e2 1f             	and    $0x1f,%edx
8010676a:	88 14 c5 04 7c 11 80 	mov    %dl,-0x7fee83fc(,%eax,8)
80106771:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106774:	8a 14 c5 05 7c 11 80 	mov    -0x7fee83fb(,%eax,8),%dl
8010677b:	83 e2 f0             	and    $0xfffffff0,%edx
8010677e:	83 ca 0e             	or     $0xe,%edx
80106781:	88 14 c5 05 7c 11 80 	mov    %dl,-0x7fee83fb(,%eax,8)
80106788:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010678b:	8a 14 c5 05 7c 11 80 	mov    -0x7fee83fb(,%eax,8),%dl
80106792:	83 e2 ef             	and    $0xffffffef,%edx
80106795:	88 14 c5 05 7c 11 80 	mov    %dl,-0x7fee83fb(,%eax,8)
8010679c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010679f:	8a 14 c5 05 7c 11 80 	mov    -0x7fee83fb(,%eax,8),%dl
801067a6:	83 e2 9f             	and    $0xffffff9f,%edx
801067a9:	88 14 c5 05 7c 11 80 	mov    %dl,-0x7fee83fb(,%eax,8)
801067b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067b3:	8a 14 c5 05 7c 11 80 	mov    -0x7fee83fb(,%eax,8),%dl
801067ba:	83 ca 80             	or     $0xffffff80,%edx
801067bd:	88 14 c5 05 7c 11 80 	mov    %dl,-0x7fee83fb(,%eax,8)
801067c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067c7:	8b 04 85 a4 c0 10 80 	mov    -0x7fef3f5c(,%eax,4),%eax
801067ce:	c1 e8 10             	shr    $0x10,%eax
801067d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801067d4:	66 89 04 d5 06 7c 11 	mov    %ax,-0x7fee83fa(,%edx,8)
801067db:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801067dc:	ff 45 f4             	incl   -0xc(%ebp)
801067df:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
801067e6:	0f 8e 3b ff ff ff    	jle    80106727 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801067ec:	a1 a4 c1 10 80       	mov    0x8010c1a4,%eax
801067f1:	66 a3 00 7e 11 80    	mov    %ax,0x80117e00
801067f7:	66 c7 05 02 7e 11 80 	movw   $0x8,0x80117e02
801067fe:	08 00 
80106800:	a0 04 7e 11 80       	mov    0x80117e04,%al
80106805:	83 e0 e0             	and    $0xffffffe0,%eax
80106808:	a2 04 7e 11 80       	mov    %al,0x80117e04
8010680d:	a0 04 7e 11 80       	mov    0x80117e04,%al
80106812:	83 e0 1f             	and    $0x1f,%eax
80106815:	a2 04 7e 11 80       	mov    %al,0x80117e04
8010681a:	a0 05 7e 11 80       	mov    0x80117e05,%al
8010681f:	83 c8 0f             	or     $0xf,%eax
80106822:	a2 05 7e 11 80       	mov    %al,0x80117e05
80106827:	a0 05 7e 11 80       	mov    0x80117e05,%al
8010682c:	83 e0 ef             	and    $0xffffffef,%eax
8010682f:	a2 05 7e 11 80       	mov    %al,0x80117e05
80106834:	a0 05 7e 11 80       	mov    0x80117e05,%al
80106839:	83 c8 60             	or     $0x60,%eax
8010683c:	a2 05 7e 11 80       	mov    %al,0x80117e05
80106841:	a0 05 7e 11 80       	mov    0x80117e05,%al
80106846:	83 c8 80             	or     $0xffffff80,%eax
80106849:	a2 05 7e 11 80       	mov    %al,0x80117e05
8010684e:	a1 a4 c1 10 80       	mov    0x8010c1a4,%eax
80106853:	c1 e8 10             	shr    $0x10,%eax
80106856:	66 a3 06 7e 11 80    	mov    %ax,0x80117e06
  
  initlock(&tickslock, "time");
8010685c:	c7 44 24 04 68 8d 10 	movl   $0x80108d68,0x4(%esp)
80106863:	80 
80106864:	c7 04 24 c0 7b 11 80 	movl   $0x80117bc0,(%esp)
8010686b:	e8 ce e6 ff ff       	call   80104f3e <initlock>
}
80106870:	c9                   	leave  
80106871:	c3                   	ret    

80106872 <idtinit>:

void
idtinit(void)
{
80106872:	55                   	push   %ebp
80106873:	89 e5                	mov    %esp,%ebp
80106875:	83 ec 08             	sub    $0x8,%esp
  lidt(idt, sizeof(idt));
80106878:	c7 44 24 04 00 08 00 	movl   $0x800,0x4(%esp)
8010687f:	00 
80106880:	c7 04 24 00 7c 11 80 	movl   $0x80117c00,(%esp)
80106887:	e8 4c fe ff ff       	call   801066d8 <lidt>
}
8010688c:	c9                   	leave  
8010688d:	c3                   	ret    

8010688e <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
8010688e:	55                   	push   %ebp
8010688f:	89 e5                	mov    %esp,%ebp
80106891:	57                   	push   %edi
80106892:	56                   	push   %esi
80106893:	53                   	push   %ebx
80106894:	83 ec 4c             	sub    $0x4c,%esp
  if(tf->trapno == T_SYSCALL){
80106897:	8b 45 08             	mov    0x8(%ebp),%eax
8010689a:	8b 40 30             	mov    0x30(%eax),%eax
8010689d:	83 f8 40             	cmp    $0x40,%eax
801068a0:	75 3e                	jne    801068e0 <trap+0x52>
    if(proc->killed)
801068a2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068a8:	8b 40 24             	mov    0x24(%eax),%eax
801068ab:	85 c0                	test   %eax,%eax
801068ad:	74 05                	je     801068b4 <trap+0x26>
      exit();
801068af:	e8 d1 df ff ff       	call   80104885 <exit>
    proc->tf = tf;
801068b4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068ba:	8b 55 08             	mov    0x8(%ebp),%edx
801068bd:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
801068c0:	e8 ea ec ff ff       	call   801055af <syscall>
    if(proc->killed)
801068c5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068cb:	8b 40 24             	mov    0x24(%eax),%eax
801068ce:	85 c0                	test   %eax,%eax
801068d0:	0f 84 ce 04 00 00    	je     80106da4 <trap+0x516>
      exit();
801068d6:	e8 aa df ff ff       	call   80104885 <exit>
    return;
801068db:	e9 c4 04 00 00       	jmp    80106da4 <trap+0x516>
  }

  switch(tf->trapno){
801068e0:	8b 45 08             	mov    0x8(%ebp),%eax
801068e3:	8b 40 30             	mov    0x30(%eax),%eax
801068e6:	83 f8 3f             	cmp    $0x3f,%eax
801068e9:	0f 87 5e 03 00 00    	ja     80106c4d <trap+0x3bf>
801068ef:	8b 04 85 10 8e 10 80 	mov    -0x7fef71f0(,%eax,4),%eax
801068f6:	ff e0                	jmp    *%eax
  // Alarm related things here?
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
801068f8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801068fe:	8a 00                	mov    (%eax),%al
80106900:	84 c0                	test   %al,%al
80106902:	75 2f                	jne    80106933 <trap+0xa5>
      acquire(&tickslock);
80106904:	c7 04 24 c0 7b 11 80 	movl   $0x80117bc0,(%esp)
8010690b:	e8 4f e6 ff ff       	call   80104f5f <acquire>
      ticks++;
80106910:	a1 00 84 11 80       	mov    0x80118400,%eax
80106915:	40                   	inc    %eax
80106916:	a3 00 84 11 80       	mov    %eax,0x80118400
      wakeup(&ticks);
8010691b:	c7 04 24 00 84 11 80 	movl   $0x80118400,(%esp)
80106922:	e8 2f e4 ff ff       	call   80104d56 <wakeup>
      release(&tickslock);
80106927:	c7 04 24 c0 7b 11 80 	movl   $0x80117bc0,(%esp)
8010692e:	e8 8e e6 ff ff       	call   80104fc1 <release>
    }

  if(proc && proc->alarmState == 0 && (tf->cs&3) == DPL_USER) // If the alarm is off 
80106933:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106939:	85 c0                	test   %eax,%eax
8010693b:	0f 84 7f 01 00 00    	je     80106ac0 <trap+0x232>
80106941:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106947:	8b 80 fc 00 00 00    	mov    0xfc(%eax),%eax
8010694d:	85 c0                	test   %eax,%eax
8010694f:	0f 85 6b 01 00 00    	jne    80106ac0 <trap+0x232>
80106955:	8b 45 08             	mov    0x8(%ebp),%eax
80106958:	8b 40 3c             	mov    0x3c(%eax),%eax
8010695b:	0f b7 c0             	movzwl %ax,%eax
8010695e:	83 e0 03             	and    $0x3,%eax
80106961:	83 f8 03             	cmp    $0x3,%eax
80106964:	0f 85 56 01 00 00    	jne    80106ac0 <trap+0x232>
  {
         proc->numberOfTicks = proc->numberOfTicks - 1; // Decrease the number of ticks
8010696a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106970:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80106977:	8b 92 00 01 00 00    	mov    0x100(%edx),%edx
8010697d:	4a                   	dec    %edx
8010697e:	89 90 00 01 00 00    	mov    %edx,0x100(%eax)
         	if(proc->numberOfTicks == 0) { // Once it reachs 0 
80106984:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010698a:	8b 80 00 01 00 00    	mov    0x100(%eax),%eax
80106990:	85 c0                	test   %eax,%eax
80106992:	0f 85 28 01 00 00    	jne    80106ac0 <trap+0x232>
			proc->alarmState = 1; // Turn the alarm on
80106998:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010699e:	c7 80 fc 00 00 00 01 	movl   $0x1,0xfc(%eax)
801069a5:	00 00 00 
    			if(proc->handlers[SIGALRM] != -1)  { // If SIGALRM is registered
801069a8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801069ae:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
801069b4:	83 f8 ff             	cmp    $0xffffffff,%eax
801069b7:	0f 84 03 01 00 00    	je     80106ac0 <trap+0x232>
				
				//cprintf("Alarm Address: %d\n", proc->handlers[SIGALRM]);
				int info = SIGALRM;
801069bd:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)


//				int decrement = sizeof(siginfo_t);
				int decrement = 4;
801069c4:	c7 45 e0 04 00 00 00 	movl   $0x4,-0x20(%ebp)
				*( (int*) (tf->esp - decrement) )  = tf->eip; // 
801069cb:	8b 45 08             	mov    0x8(%ebp),%eax
801069ce:	8b 50 44             	mov    0x44(%eax),%edx
801069d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
801069d4:	89 d1                	mov    %edx,%ecx
801069d6:	29 c1                	sub    %eax,%ecx
801069d8:	89 c8                	mov    %ecx,%eax
801069da:	8b 55 08             	mov    0x8(%ebp),%edx
801069dd:	8b 52 38             	mov    0x38(%edx),%edx
801069e0:	89 10                	mov    %edx,(%eax)
				decrement = decrement + 4;
801069e2:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
				
			
				*( (int*) (tf->esp - decrement) ) = tf->ebp;
801069e6:	8b 45 08             	mov    0x8(%ebp),%eax
801069e9:	8b 50 44             	mov    0x44(%eax),%edx
801069ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
801069ef:	89 d1                	mov    %edx,%ecx
801069f1:	29 c1                	sub    %eax,%ecx
801069f3:	89 c8                	mov    %ecx,%eax
801069f5:	8b 55 08             	mov    0x8(%ebp),%edx
801069f8:	8b 52 08             	mov    0x8(%edx),%edx
801069fb:	89 10                	mov    %edx,(%eax)
				
				tf->ebp = tf->esp - 8;
801069fd:	8b 45 08             	mov    0x8(%ebp),%eax
80106a00:	8b 40 44             	mov    0x44(%eax),%eax
80106a03:	8d 50 f8             	lea    -0x8(%eax),%edx
80106a06:	8b 45 08             	mov    0x8(%ebp),%eax
80106a09:	89 50 08             	mov    %edx,0x8(%eax)
				decrement = decrement + 4;
80106a0c:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
				
				*( (int*) (tf->esp - decrement) )  = tf->eax; // 
80106a10:	8b 45 08             	mov    0x8(%ebp),%eax
80106a13:	8b 50 44             	mov    0x44(%eax),%edx
80106a16:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106a19:	89 d1                	mov    %edx,%ecx
80106a1b:	29 c1                	sub    %eax,%ecx
80106a1d:	89 c8                	mov    %ecx,%eax
80106a1f:	8b 55 08             	mov    0x8(%ebp),%edx
80106a22:	8b 52 1c             	mov    0x1c(%edx),%edx
80106a25:	89 10                	mov    %edx,(%eax)
				decrement = decrement + 4;
80106a27:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
				
				*( (int*) (tf->esp  - decrement) )  = tf->edx; // 
80106a2b:	8b 45 08             	mov    0x8(%ebp),%eax
80106a2e:	8b 50 44             	mov    0x44(%eax),%edx
80106a31:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106a34:	89 d1                	mov    %edx,%ecx
80106a36:	29 c1                	sub    %eax,%ecx
80106a38:	89 c8                	mov    %ecx,%eax
80106a3a:	8b 55 08             	mov    0x8(%ebp),%edx
80106a3d:	8b 52 14             	mov    0x14(%edx),%edx
80106a40:	89 10                	mov    %edx,(%eax)
				decrement = decrement + 4;
80106a42:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
				*( (int*) (tf->esp - decrement) )  = tf->ecx; // 
80106a46:	8b 45 08             	mov    0x8(%ebp),%eax
80106a49:	8b 50 44             	mov    0x44(%eax),%edx
80106a4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106a4f:	89 d1                	mov    %edx,%ecx
80106a51:	29 c1                	sub    %eax,%ecx
80106a53:	89 c8                	mov    %ecx,%eax
80106a55:	8b 55 08             	mov    0x8(%ebp),%edx
80106a58:	8b 52 18             	mov    0x18(%edx),%edx
80106a5b:	89 10                	mov    %edx,(%eax)
				decrement = decrement + 4;
80106a5d:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
				
				*( (int*) (tf->esp - decrement) )  = info; // 
80106a61:	8b 45 08             	mov    0x8(%ebp),%eax
80106a64:	8b 50 44             	mov    0x44(%eax),%edx
80106a67:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106a6a:	89 d1                	mov    %edx,%ecx
80106a6c:	29 c1                	sub    %eax,%ecx
80106a6e:	89 c8                	mov    %ecx,%eax
80106a70:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106a73:	89 10                	mov    %edx,(%eax)
				decrement = decrement + 4;
80106a75:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
				*( (int*) (tf->esp - decrement) )  = proc->trampoline; // 
80106a79:	8b 45 08             	mov    0x8(%ebp),%eax
80106a7c:	8b 50 44             	mov    0x44(%eax),%edx
80106a7f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106a82:	89 d1                	mov    %edx,%ecx
80106a84:	29 c1                	sub    %eax,%ecx
80106a86:	89 c8                	mov    %ecx,%eax
80106a88:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80106a8f:	8b 92 04 01 00 00    	mov    0x104(%edx),%edx
80106a95:	89 10                	mov    %edx,(%eax)

						
				tf->esp = tf->esp - decrement; // Decrease the stack pointer
80106a97:	8b 45 08             	mov    0x8(%ebp),%eax
80106a9a:	8b 50 44             	mov    0x44(%eax),%edx
80106a9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106aa0:	29 c2                	sub    %eax,%edx
80106aa2:	8b 45 08             	mov    0x8(%ebp),%eax
80106aa5:	89 50 44             	mov    %edx,0x44(%eax)
				tf->eip = proc->handlers[info]; // Modify the address to that of the handler
80106aa8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106aae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106ab1:	83 c2 1c             	add    $0x1c,%edx
80106ab4:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80106ab8:	89 c2                	mov    %eax,%edx
80106aba:	8b 45 08             	mov    0x8(%ebp),%eax
80106abd:	89 50 38             	mov    %edx,0x38(%eax)
				// SIG INFO T
				// TRAMPOLINE	
		}
	}
  } 
    lapiceoi();
80106ac0:	e8 b8 c4 ff ff       	call   80102f7d <lapiceoi>
    break;
80106ac5:	e9 56 02 00 00       	jmp    80106d20 <trap+0x492>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106aca:	e8 9e bc ff ff       	call   8010276d <ideintr>
    lapiceoi();
80106acf:	e8 a9 c4 ff ff       	call   80102f7d <lapiceoi>
    break;
80106ad4:	e9 47 02 00 00       	jmp    80106d20 <trap+0x492>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106ad9:	e8 59 c2 ff ff       	call   80102d37 <kbdintr>
    lapiceoi();
80106ade:	e8 9a c4 ff ff       	call   80102f7d <lapiceoi>
    break;
80106ae3:	e9 38 02 00 00       	jmp    80106d20 <trap+0x492>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106ae8:	e8 b7 04 00 00       	call   80106fa4 <uartintr>
    lapiceoi();
80106aed:	e8 8b c4 ff ff       	call   80102f7d <lapiceoi>
    break;
80106af2:	e9 29 02 00 00       	jmp    80106d20 <trap+0x492>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
            cpu->id, tf->cs, tf->eip);
80106af7:	8b 45 08             	mov    0x8(%ebp),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106afa:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80106afd:	8b 45 08             	mov    0x8(%ebp),%eax
80106b00:	8b 40 3c             	mov    0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106b03:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80106b06:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106b0c:	8a 00                	mov    (%eax),%al
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106b0e:	0f b6 c0             	movzbl %al,%eax
80106b11:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106b15:	89 54 24 08          	mov    %edx,0x8(%esp)
80106b19:	89 44 24 04          	mov    %eax,0x4(%esp)
80106b1d:	c7 04 24 70 8d 10 80 	movl   $0x80108d70,(%esp)
80106b24:	e8 78 98 ff ff       	call   801003a1 <cprintf>
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
80106b29:	e8 4f c4 ff ff       	call   80102f7d <lapiceoi>
    break;
80106b2e:	e9 ed 01 00 00       	jmp    80106d20 <trap+0x492>
  case T_DIVIDE:
    if(proc->handlers[SIGFPE] != -1) // If SIGFPE is registered
80106b33:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b39:	8b 40 7c             	mov    0x7c(%eax),%eax
80106b3c:	83 f8 ff             	cmp    $0xffffffff,%eax
80106b3f:	0f 84 08 01 00 00    	je     80106c4d <trap+0x3bf>
    {

				int info = SIGFPE;
80106b45:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)


				int decrement = 4;
80106b4c:	c7 45 d8 04 00 00 00 	movl   $0x4,-0x28(%ebp)
				*( (int*) (tf->esp - decrement) )  = tf->eip; // 
80106b53:	8b 45 08             	mov    0x8(%ebp),%eax
80106b56:	8b 50 44             	mov    0x44(%eax),%edx
80106b59:	8b 45 d8             	mov    -0x28(%ebp),%eax
80106b5c:	89 d1                	mov    %edx,%ecx
80106b5e:	29 c1                	sub    %eax,%ecx
80106b60:	89 c8                	mov    %ecx,%eax
80106b62:	8b 55 08             	mov    0x8(%ebp),%edx
80106b65:	8b 52 38             	mov    0x38(%edx),%edx
80106b68:	89 10                	mov    %edx,(%eax)
				decrement = decrement + 4;
80106b6a:	83 45 d8 04          	addl   $0x4,-0x28(%ebp)
				
				
				*( (int*) (tf->esp - decrement) ) = tf->ebp;
80106b6e:	8b 45 08             	mov    0x8(%ebp),%eax
80106b71:	8b 50 44             	mov    0x44(%eax),%edx
80106b74:	8b 45 d8             	mov    -0x28(%ebp),%eax
80106b77:	89 d1                	mov    %edx,%ecx
80106b79:	29 c1                	sub    %eax,%ecx
80106b7b:	89 c8                	mov    %ecx,%eax
80106b7d:	8b 55 08             	mov    0x8(%ebp),%edx
80106b80:	8b 52 08             	mov    0x8(%edx),%edx
80106b83:	89 10                	mov    %edx,(%eax)
				
				tf->ebp = tf->esp - 8;
80106b85:	8b 45 08             	mov    0x8(%ebp),%eax
80106b88:	8b 40 44             	mov    0x44(%eax),%eax
80106b8b:	8d 50 f8             	lea    -0x8(%eax),%edx
80106b8e:	8b 45 08             	mov    0x8(%ebp),%eax
80106b91:	89 50 08             	mov    %edx,0x8(%eax)
				decrement = decrement + 4;
80106b94:	83 45 d8 04          	addl   $0x4,-0x28(%ebp)
				
				*( (int*) (tf->esp - decrement) )  = tf->eax; // 
80106b98:	8b 45 08             	mov    0x8(%ebp),%eax
80106b9b:	8b 50 44             	mov    0x44(%eax),%edx
80106b9e:	8b 45 d8             	mov    -0x28(%ebp),%eax
80106ba1:	89 d1                	mov    %edx,%ecx
80106ba3:	29 c1                	sub    %eax,%ecx
80106ba5:	89 c8                	mov    %ecx,%eax
80106ba7:	8b 55 08             	mov    0x8(%ebp),%edx
80106baa:	8b 52 1c             	mov    0x1c(%edx),%edx
80106bad:	89 10                	mov    %edx,(%eax)
				decrement = decrement + 4;
80106baf:	83 45 d8 04          	addl   $0x4,-0x28(%ebp)
				
				*( (int*) (tf->esp  - decrement) )  = tf->edx; // 
80106bb3:	8b 45 08             	mov    0x8(%ebp),%eax
80106bb6:	8b 50 44             	mov    0x44(%eax),%edx
80106bb9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80106bbc:	89 d1                	mov    %edx,%ecx
80106bbe:	29 c1                	sub    %eax,%ecx
80106bc0:	89 c8                	mov    %ecx,%eax
80106bc2:	8b 55 08             	mov    0x8(%ebp),%edx
80106bc5:	8b 52 14             	mov    0x14(%edx),%edx
80106bc8:	89 10                	mov    %edx,(%eax)
				decrement = decrement + 4;
80106bca:	83 45 d8 04          	addl   $0x4,-0x28(%ebp)
				*( (int*) (tf->esp - decrement) )  = tf->ecx; // 
80106bce:	8b 45 08             	mov    0x8(%ebp),%eax
80106bd1:	8b 50 44             	mov    0x44(%eax),%edx
80106bd4:	8b 45 d8             	mov    -0x28(%ebp),%eax
80106bd7:	89 d1                	mov    %edx,%ecx
80106bd9:	29 c1                	sub    %eax,%ecx
80106bdb:	89 c8                	mov    %ecx,%eax
80106bdd:	8b 55 08             	mov    0x8(%ebp),%edx
80106be0:	8b 52 18             	mov    0x18(%edx),%edx
80106be3:	89 10                	mov    %edx,(%eax)
				decrement = decrement + 4;
80106be5:	83 45 d8 04          	addl   $0x4,-0x28(%ebp)
				
				*( (int*) (tf->esp - decrement) )  = info; // 
80106be9:	8b 45 08             	mov    0x8(%ebp),%eax
80106bec:	8b 50 44             	mov    0x44(%eax),%edx
80106bef:	8b 45 d8             	mov    -0x28(%ebp),%eax
80106bf2:	89 d1                	mov    %edx,%ecx
80106bf4:	29 c1                	sub    %eax,%ecx
80106bf6:	89 c8                	mov    %ecx,%eax
80106bf8:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106bfb:	89 10                	mov    %edx,(%eax)
				decrement = decrement + 4;
80106bfd:	83 45 d8 04          	addl   $0x4,-0x28(%ebp)
				
				*( (int*) (tf->esp - decrement) )  = proc->trampoline; // 
80106c01:	8b 45 08             	mov    0x8(%ebp),%eax
80106c04:	8b 50 44             	mov    0x44(%eax),%edx
80106c07:	8b 45 d8             	mov    -0x28(%ebp),%eax
80106c0a:	89 d1                	mov    %edx,%ecx
80106c0c:	29 c1                	sub    %eax,%ecx
80106c0e:	89 c8                	mov    %ecx,%eax
80106c10:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80106c17:	8b 92 04 01 00 00    	mov    0x104(%edx),%edx
80106c1d:	89 10                	mov    %edx,(%eax)

						
				tf->esp = tf->esp - decrement; // Decrease the stack pointer
80106c1f:	8b 45 08             	mov    0x8(%ebp),%eax
80106c22:	8b 50 44             	mov    0x44(%eax),%edx
80106c25:	8b 45 d8             	mov    -0x28(%ebp),%eax
80106c28:	29 c2                	sub    %eax,%edx
80106c2a:	8b 45 08             	mov    0x8(%ebp),%eax
80106c2d:	89 50 44             	mov    %edx,0x44(%eax)
				tf->eip = proc->handlers[info]; // Modify the address to that of the handler
80106c30:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c36:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106c39:	83 c2 1c             	add    $0x1c,%edx
80106c3c:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80106c40:	89 c2                	mov    %eax,%edx
80106c42:	8b 45 08             	mov    0x8(%ebp),%eax
80106c45:	89 50 38             	mov    %edx,0x38(%eax)
				// TRAMPOLINE


		
				//cprintf("END OF FPE\n");
				break;
80106c48:	e9 d3 00 00 00       	jmp    80106d20 <trap+0x492>

    }
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80106c4d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c53:	85 c0                	test   %eax,%eax
80106c55:	74 10                	je     80106c67 <trap+0x3d9>
80106c57:	8b 45 08             	mov    0x8(%ebp),%eax
80106c5a:	8b 40 3c             	mov    0x3c(%eax),%eax
80106c5d:	0f b7 c0             	movzwl %ax,%eax
80106c60:	83 e0 03             	and    $0x3,%eax
80106c63:	85 c0                	test   %eax,%eax
80106c65:	75 45                	jne    80106cac <trap+0x41e>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106c67:	e8 93 fa ff ff       	call   801066ff <rcr2>
              tf->trapno, cpu->id, tf->eip, rcr2());
80106c6c:	8b 55 08             	mov    0x8(%ebp),%edx
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106c6f:	8b 5a 38             	mov    0x38(%edx),%ebx
              tf->trapno, cpu->id, tf->eip, rcr2());
80106c72:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80106c79:	8a 12                	mov    (%edx),%dl
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106c7b:	0f b6 ca             	movzbl %dl,%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
80106c7e:	8b 55 08             	mov    0x8(%ebp),%edx
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106c81:	8b 52 30             	mov    0x30(%edx),%edx
80106c84:	89 44 24 10          	mov    %eax,0x10(%esp)
80106c88:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
80106c8c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106c90:	89 54 24 04          	mov    %edx,0x4(%esp)
80106c94:	c7 04 24 94 8d 10 80 	movl   $0x80108d94,(%esp)
80106c9b:	e8 01 97 ff ff       	call   801003a1 <cprintf>
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
80106ca0:	c7 04 24 c6 8d 10 80 	movl   $0x80108dc6,(%esp)
80106ca7:	e8 8a 98 ff ff       	call   80100536 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106cac:	e8 4e fa ff ff       	call   801066ff <rcr2>
80106cb1:	89 c2                	mov    %eax,%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106cb3:	8b 45 08             	mov    0x8(%ebp),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106cb6:	8b 78 38             	mov    0x38(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106cb9:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106cbf:	8a 00                	mov    (%eax),%al
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106cc1:	0f b6 f0             	movzbl %al,%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106cc4:	8b 45 08             	mov    0x8(%ebp),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106cc7:	8b 58 34             	mov    0x34(%eax),%ebx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106cca:	8b 45 08             	mov    0x8(%ebp),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106ccd:	8b 48 30             	mov    0x30(%eax),%ecx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106cd0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106cd6:	83 c0 6c             	add    $0x6c,%eax
80106cd9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80106cdc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106ce2:	8b 40 10             	mov    0x10(%eax),%eax
80106ce5:	89 54 24 1c          	mov    %edx,0x1c(%esp)
80106ce9:	89 7c 24 18          	mov    %edi,0x18(%esp)
80106ced:	89 74 24 14          	mov    %esi,0x14(%esp)
80106cf1:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80106cf5:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106cf9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80106cfc:	89 54 24 08          	mov    %edx,0x8(%esp)
80106d00:	89 44 24 04          	mov    %eax,0x4(%esp)
80106d04:	c7 04 24 cc 8d 10 80 	movl   $0x80108dcc,(%esp)
80106d0b:	e8 91 96 ff ff       	call   801003a1 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
80106d10:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d16:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106d1d:	eb 01                	jmp    80106d20 <trap+0x492>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
80106d1f:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106d20:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d26:	85 c0                	test   %eax,%eax
80106d28:	74 23                	je     80106d4d <trap+0x4bf>
80106d2a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d30:	8b 40 24             	mov    0x24(%eax),%eax
80106d33:	85 c0                	test   %eax,%eax
80106d35:	74 16                	je     80106d4d <trap+0x4bf>
80106d37:	8b 45 08             	mov    0x8(%ebp),%eax
80106d3a:	8b 40 3c             	mov    0x3c(%eax),%eax
80106d3d:	0f b7 c0             	movzwl %ax,%eax
80106d40:	83 e0 03             	and    $0x3,%eax
80106d43:	83 f8 03             	cmp    $0x3,%eax
80106d46:	75 05                	jne    80106d4d <trap+0x4bf>
    exit();
80106d48:	e8 38 db ff ff       	call   80104885 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80106d4d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d53:	85 c0                	test   %eax,%eax
80106d55:	74 1e                	je     80106d75 <trap+0x4e7>
80106d57:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d5d:	8b 40 0c             	mov    0xc(%eax),%eax
80106d60:	83 f8 04             	cmp    $0x4,%eax
80106d63:	75 10                	jne    80106d75 <trap+0x4e7>
80106d65:	8b 45 08             	mov    0x8(%ebp),%eax
80106d68:	8b 40 30             	mov    0x30(%eax),%eax
80106d6b:	83 f8 20             	cmp    $0x20,%eax
80106d6e:	75 05                	jne    80106d75 <trap+0x4e7>
    yield();
80106d70:	e8 94 de ff ff       	call   80104c09 <yield>


  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106d75:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d7b:	85 c0                	test   %eax,%eax
80106d7d:	74 26                	je     80106da5 <trap+0x517>
80106d7f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d85:	8b 40 24             	mov    0x24(%eax),%eax
80106d88:	85 c0                	test   %eax,%eax
80106d8a:	74 19                	je     80106da5 <trap+0x517>
80106d8c:	8b 45 08             	mov    0x8(%ebp),%eax
80106d8f:	8b 40 3c             	mov    0x3c(%eax),%eax
80106d92:	0f b7 c0             	movzwl %ax,%eax
80106d95:	83 e0 03             	and    $0x3,%eax
80106d98:	83 f8 03             	cmp    $0x3,%eax
80106d9b:	75 08                	jne    80106da5 <trap+0x517>
    exit();
80106d9d:	e8 e3 da ff ff       	call   80104885 <exit>
80106da2:	eb 01                	jmp    80106da5 <trap+0x517>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
80106da4:	90                   	nop


  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80106da5:	83 c4 4c             	add    $0x4c,%esp
80106da8:	5b                   	pop    %ebx
80106da9:	5e                   	pop    %esi
80106daa:	5f                   	pop    %edi
80106dab:	5d                   	pop    %ebp
80106dac:	c3                   	ret    
80106dad:	66 90                	xchg   %ax,%ax
80106daf:	90                   	nop

80106db0 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80106db0:	55                   	push   %ebp
80106db1:	89 e5                	mov    %esp,%ebp
80106db3:	53                   	push   %ebx
80106db4:	83 ec 14             	sub    $0x14,%esp
80106db7:	8b 45 08             	mov    0x8(%ebp),%eax
80106dba:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106dbe:	8b 55 e8             	mov    -0x18(%ebp),%edx
80106dc1:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
80106dc5:	66 8b 55 ea          	mov    -0x16(%ebp),%dx
80106dc9:	ec                   	in     (%dx),%al
80106dca:	88 c3                	mov    %al,%bl
80106dcc:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
80106dcf:	8a 45 fb             	mov    -0x5(%ebp),%al
}
80106dd2:	83 c4 14             	add    $0x14,%esp
80106dd5:	5b                   	pop    %ebx
80106dd6:	5d                   	pop    %ebp
80106dd7:	c3                   	ret    

80106dd8 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106dd8:	55                   	push   %ebp
80106dd9:	89 e5                	mov    %esp,%ebp
80106ddb:	83 ec 08             	sub    $0x8,%esp
80106dde:	8b 45 08             	mov    0x8(%ebp),%eax
80106de1:	8b 55 0c             	mov    0xc(%ebp),%edx
80106de4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80106de8:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106deb:	8a 45 f8             	mov    -0x8(%ebp),%al
80106dee:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106df1:	ee                   	out    %al,(%dx)
}
80106df2:	c9                   	leave  
80106df3:	c3                   	ret    

80106df4 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106df4:	55                   	push   %ebp
80106df5:	89 e5                	mov    %esp,%ebp
80106df7:	83 ec 28             	sub    $0x28,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80106dfa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106e01:	00 
80106e02:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80106e09:	e8 ca ff ff ff       	call   80106dd8 <outb>
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80106e0e:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
80106e15:	00 
80106e16:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80106e1d:	e8 b6 ff ff ff       	call   80106dd8 <outb>
  outb(COM1+0, 115200/9600);
80106e22:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
80106e29:	00 
80106e2a:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106e31:	e8 a2 ff ff ff       	call   80106dd8 <outb>
  outb(COM1+1, 0);
80106e36:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106e3d:	00 
80106e3e:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80106e45:	e8 8e ff ff ff       	call   80106dd8 <outb>
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106e4a:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80106e51:	00 
80106e52:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80106e59:	e8 7a ff ff ff       	call   80106dd8 <outb>
  outb(COM1+4, 0);
80106e5e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106e65:	00 
80106e66:	c7 04 24 fc 03 00 00 	movl   $0x3fc,(%esp)
80106e6d:	e8 66 ff ff ff       	call   80106dd8 <outb>
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80106e72:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80106e79:	00 
80106e7a:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80106e81:	e8 52 ff ff ff       	call   80106dd8 <outb>

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106e86:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106e8d:	e8 1e ff ff ff       	call   80106db0 <inb>
80106e92:	3c ff                	cmp    $0xff,%al
80106e94:	74 69                	je     80106eff <uartinit+0x10b>
    return;
  uart = 1;
80106e96:	c7 05 6c c6 10 80 01 	movl   $0x1,0x8010c66c
80106e9d:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80106ea0:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80106ea7:	e8 04 ff ff ff       	call   80106db0 <inb>
  inb(COM1+0);
80106eac:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106eb3:	e8 f8 fe ff ff       	call   80106db0 <inb>
  picenable(IRQ_COM1);
80106eb8:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80106ebf:	e8 d0 cf ff ff       	call   80103e94 <picenable>
  ioapicenable(IRQ_COM1, 0);
80106ec4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106ecb:	00 
80106ecc:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80106ed3:	e8 15 bb ff ff       	call   801029ed <ioapicenable>
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106ed8:	c7 45 f4 10 8f 10 80 	movl   $0x80108f10,-0xc(%ebp)
80106edf:	eb 13                	jmp    80106ef4 <uartinit+0x100>
    uartputc(*p);
80106ee1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ee4:	8a 00                	mov    (%eax),%al
80106ee6:	0f be c0             	movsbl %al,%eax
80106ee9:	89 04 24             	mov    %eax,(%esp)
80106eec:	e8 11 00 00 00       	call   80106f02 <uartputc>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106ef1:	ff 45 f4             	incl   -0xc(%ebp)
80106ef4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ef7:	8a 00                	mov    (%eax),%al
80106ef9:	84 c0                	test   %al,%al
80106efb:	75 e4                	jne    80106ee1 <uartinit+0xed>
80106efd:	eb 01                	jmp    80106f00 <uartinit+0x10c>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
80106eff:	90                   	nop
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
80106f00:	c9                   	leave  
80106f01:	c3                   	ret    

80106f02 <uartputc>:

void
uartputc(int c)
{
80106f02:	55                   	push   %ebp
80106f03:	89 e5                	mov    %esp,%ebp
80106f05:	83 ec 28             	sub    $0x28,%esp
  int i;

  if(!uart)
80106f08:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
80106f0d:	85 c0                	test   %eax,%eax
80106f0f:	74 4c                	je     80106f5d <uartputc+0x5b>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106f11:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106f18:	eb 0f                	jmp    80106f29 <uartputc+0x27>
    microdelay(10);
80106f1a:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80106f21:	e8 7c c0 ff ff       	call   80102fa2 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106f26:	ff 45 f4             	incl   -0xc(%ebp)
80106f29:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80106f2d:	7f 16                	jg     80106f45 <uartputc+0x43>
80106f2f:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106f36:	e8 75 fe ff ff       	call   80106db0 <inb>
80106f3b:	0f b6 c0             	movzbl %al,%eax
80106f3e:	83 e0 20             	and    $0x20,%eax
80106f41:	85 c0                	test   %eax,%eax
80106f43:	74 d5                	je     80106f1a <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
80106f45:	8b 45 08             	mov    0x8(%ebp),%eax
80106f48:	0f b6 c0             	movzbl %al,%eax
80106f4b:	89 44 24 04          	mov    %eax,0x4(%esp)
80106f4f:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106f56:	e8 7d fe ff ff       	call   80106dd8 <outb>
80106f5b:	eb 01                	jmp    80106f5e <uartputc+0x5c>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
80106f5d:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80106f5e:	c9                   	leave  
80106f5f:	c3                   	ret    

80106f60 <uartgetc>:

static int
uartgetc(void)
{
80106f60:	55                   	push   %ebp
80106f61:	89 e5                	mov    %esp,%ebp
80106f63:	83 ec 04             	sub    $0x4,%esp
  if(!uart)
80106f66:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
80106f6b:	85 c0                	test   %eax,%eax
80106f6d:	75 07                	jne    80106f76 <uartgetc+0x16>
    return -1;
80106f6f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106f74:	eb 2c                	jmp    80106fa2 <uartgetc+0x42>
  if(!(inb(COM1+5) & 0x01))
80106f76:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106f7d:	e8 2e fe ff ff       	call   80106db0 <inb>
80106f82:	0f b6 c0             	movzbl %al,%eax
80106f85:	83 e0 01             	and    $0x1,%eax
80106f88:	85 c0                	test   %eax,%eax
80106f8a:	75 07                	jne    80106f93 <uartgetc+0x33>
    return -1;
80106f8c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106f91:	eb 0f                	jmp    80106fa2 <uartgetc+0x42>
  return inb(COM1+0);
80106f93:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106f9a:	e8 11 fe ff ff       	call   80106db0 <inb>
80106f9f:	0f b6 c0             	movzbl %al,%eax
}
80106fa2:	c9                   	leave  
80106fa3:	c3                   	ret    

80106fa4 <uartintr>:

void
uartintr(void)
{
80106fa4:	55                   	push   %ebp
80106fa5:	89 e5                	mov    %esp,%ebp
80106fa7:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80106faa:	c7 04 24 60 6f 10 80 	movl   $0x80106f60,(%esp)
80106fb1:	e8 f5 97 ff ff       	call   801007ab <consoleintr>
}
80106fb6:	c9                   	leave  
80106fb7:	c3                   	ret    

80106fb8 <vector0>:
80106fb8:	6a 00                	push   $0x0
80106fba:	6a 00                	push   $0x0
80106fbc:	e9 eb f6 ff ff       	jmp    801066ac <alltraps>

80106fc1 <vector1>:
80106fc1:	6a 00                	push   $0x0
80106fc3:	6a 01                	push   $0x1
80106fc5:	e9 e2 f6 ff ff       	jmp    801066ac <alltraps>

80106fca <vector2>:
80106fca:	6a 00                	push   $0x0
80106fcc:	6a 02                	push   $0x2
80106fce:	e9 d9 f6 ff ff       	jmp    801066ac <alltraps>

80106fd3 <vector3>:
80106fd3:	6a 00                	push   $0x0
80106fd5:	6a 03                	push   $0x3
80106fd7:	e9 d0 f6 ff ff       	jmp    801066ac <alltraps>

80106fdc <vector4>:
80106fdc:	6a 00                	push   $0x0
80106fde:	6a 04                	push   $0x4
80106fe0:	e9 c7 f6 ff ff       	jmp    801066ac <alltraps>

80106fe5 <vector5>:
80106fe5:	6a 00                	push   $0x0
80106fe7:	6a 05                	push   $0x5
80106fe9:	e9 be f6 ff ff       	jmp    801066ac <alltraps>

80106fee <vector6>:
80106fee:	6a 00                	push   $0x0
80106ff0:	6a 06                	push   $0x6
80106ff2:	e9 b5 f6 ff ff       	jmp    801066ac <alltraps>

80106ff7 <vector7>:
80106ff7:	6a 00                	push   $0x0
80106ff9:	6a 07                	push   $0x7
80106ffb:	e9 ac f6 ff ff       	jmp    801066ac <alltraps>

80107000 <vector8>:
80107000:	6a 08                	push   $0x8
80107002:	e9 a5 f6 ff ff       	jmp    801066ac <alltraps>

80107007 <vector9>:
80107007:	6a 00                	push   $0x0
80107009:	6a 09                	push   $0x9
8010700b:	e9 9c f6 ff ff       	jmp    801066ac <alltraps>

80107010 <vector10>:
80107010:	6a 0a                	push   $0xa
80107012:	e9 95 f6 ff ff       	jmp    801066ac <alltraps>

80107017 <vector11>:
80107017:	6a 0b                	push   $0xb
80107019:	e9 8e f6 ff ff       	jmp    801066ac <alltraps>

8010701e <vector12>:
8010701e:	6a 0c                	push   $0xc
80107020:	e9 87 f6 ff ff       	jmp    801066ac <alltraps>

80107025 <vector13>:
80107025:	6a 0d                	push   $0xd
80107027:	e9 80 f6 ff ff       	jmp    801066ac <alltraps>

8010702c <vector14>:
8010702c:	6a 0e                	push   $0xe
8010702e:	e9 79 f6 ff ff       	jmp    801066ac <alltraps>

80107033 <vector15>:
80107033:	6a 00                	push   $0x0
80107035:	6a 0f                	push   $0xf
80107037:	e9 70 f6 ff ff       	jmp    801066ac <alltraps>

8010703c <vector16>:
8010703c:	6a 00                	push   $0x0
8010703e:	6a 10                	push   $0x10
80107040:	e9 67 f6 ff ff       	jmp    801066ac <alltraps>

80107045 <vector17>:
80107045:	6a 11                	push   $0x11
80107047:	e9 60 f6 ff ff       	jmp    801066ac <alltraps>

8010704c <vector18>:
8010704c:	6a 00                	push   $0x0
8010704e:	6a 12                	push   $0x12
80107050:	e9 57 f6 ff ff       	jmp    801066ac <alltraps>

80107055 <vector19>:
80107055:	6a 00                	push   $0x0
80107057:	6a 13                	push   $0x13
80107059:	e9 4e f6 ff ff       	jmp    801066ac <alltraps>

8010705e <vector20>:
8010705e:	6a 00                	push   $0x0
80107060:	6a 14                	push   $0x14
80107062:	e9 45 f6 ff ff       	jmp    801066ac <alltraps>

80107067 <vector21>:
80107067:	6a 00                	push   $0x0
80107069:	6a 15                	push   $0x15
8010706b:	e9 3c f6 ff ff       	jmp    801066ac <alltraps>

80107070 <vector22>:
80107070:	6a 00                	push   $0x0
80107072:	6a 16                	push   $0x16
80107074:	e9 33 f6 ff ff       	jmp    801066ac <alltraps>

80107079 <vector23>:
80107079:	6a 00                	push   $0x0
8010707b:	6a 17                	push   $0x17
8010707d:	e9 2a f6 ff ff       	jmp    801066ac <alltraps>

80107082 <vector24>:
80107082:	6a 00                	push   $0x0
80107084:	6a 18                	push   $0x18
80107086:	e9 21 f6 ff ff       	jmp    801066ac <alltraps>

8010708b <vector25>:
8010708b:	6a 00                	push   $0x0
8010708d:	6a 19                	push   $0x19
8010708f:	e9 18 f6 ff ff       	jmp    801066ac <alltraps>

80107094 <vector26>:
80107094:	6a 00                	push   $0x0
80107096:	6a 1a                	push   $0x1a
80107098:	e9 0f f6 ff ff       	jmp    801066ac <alltraps>

8010709d <vector27>:
8010709d:	6a 00                	push   $0x0
8010709f:	6a 1b                	push   $0x1b
801070a1:	e9 06 f6 ff ff       	jmp    801066ac <alltraps>

801070a6 <vector28>:
801070a6:	6a 00                	push   $0x0
801070a8:	6a 1c                	push   $0x1c
801070aa:	e9 fd f5 ff ff       	jmp    801066ac <alltraps>

801070af <vector29>:
801070af:	6a 00                	push   $0x0
801070b1:	6a 1d                	push   $0x1d
801070b3:	e9 f4 f5 ff ff       	jmp    801066ac <alltraps>

801070b8 <vector30>:
801070b8:	6a 00                	push   $0x0
801070ba:	6a 1e                	push   $0x1e
801070bc:	e9 eb f5 ff ff       	jmp    801066ac <alltraps>

801070c1 <vector31>:
801070c1:	6a 00                	push   $0x0
801070c3:	6a 1f                	push   $0x1f
801070c5:	e9 e2 f5 ff ff       	jmp    801066ac <alltraps>

801070ca <vector32>:
801070ca:	6a 00                	push   $0x0
801070cc:	6a 20                	push   $0x20
801070ce:	e9 d9 f5 ff ff       	jmp    801066ac <alltraps>

801070d3 <vector33>:
801070d3:	6a 00                	push   $0x0
801070d5:	6a 21                	push   $0x21
801070d7:	e9 d0 f5 ff ff       	jmp    801066ac <alltraps>

801070dc <vector34>:
801070dc:	6a 00                	push   $0x0
801070de:	6a 22                	push   $0x22
801070e0:	e9 c7 f5 ff ff       	jmp    801066ac <alltraps>

801070e5 <vector35>:
801070e5:	6a 00                	push   $0x0
801070e7:	6a 23                	push   $0x23
801070e9:	e9 be f5 ff ff       	jmp    801066ac <alltraps>

801070ee <vector36>:
801070ee:	6a 00                	push   $0x0
801070f0:	6a 24                	push   $0x24
801070f2:	e9 b5 f5 ff ff       	jmp    801066ac <alltraps>

801070f7 <vector37>:
801070f7:	6a 00                	push   $0x0
801070f9:	6a 25                	push   $0x25
801070fb:	e9 ac f5 ff ff       	jmp    801066ac <alltraps>

80107100 <vector38>:
80107100:	6a 00                	push   $0x0
80107102:	6a 26                	push   $0x26
80107104:	e9 a3 f5 ff ff       	jmp    801066ac <alltraps>

80107109 <vector39>:
80107109:	6a 00                	push   $0x0
8010710b:	6a 27                	push   $0x27
8010710d:	e9 9a f5 ff ff       	jmp    801066ac <alltraps>

80107112 <vector40>:
80107112:	6a 00                	push   $0x0
80107114:	6a 28                	push   $0x28
80107116:	e9 91 f5 ff ff       	jmp    801066ac <alltraps>

8010711b <vector41>:
8010711b:	6a 00                	push   $0x0
8010711d:	6a 29                	push   $0x29
8010711f:	e9 88 f5 ff ff       	jmp    801066ac <alltraps>

80107124 <vector42>:
80107124:	6a 00                	push   $0x0
80107126:	6a 2a                	push   $0x2a
80107128:	e9 7f f5 ff ff       	jmp    801066ac <alltraps>

8010712d <vector43>:
8010712d:	6a 00                	push   $0x0
8010712f:	6a 2b                	push   $0x2b
80107131:	e9 76 f5 ff ff       	jmp    801066ac <alltraps>

80107136 <vector44>:
80107136:	6a 00                	push   $0x0
80107138:	6a 2c                	push   $0x2c
8010713a:	e9 6d f5 ff ff       	jmp    801066ac <alltraps>

8010713f <vector45>:
8010713f:	6a 00                	push   $0x0
80107141:	6a 2d                	push   $0x2d
80107143:	e9 64 f5 ff ff       	jmp    801066ac <alltraps>

80107148 <vector46>:
80107148:	6a 00                	push   $0x0
8010714a:	6a 2e                	push   $0x2e
8010714c:	e9 5b f5 ff ff       	jmp    801066ac <alltraps>

80107151 <vector47>:
80107151:	6a 00                	push   $0x0
80107153:	6a 2f                	push   $0x2f
80107155:	e9 52 f5 ff ff       	jmp    801066ac <alltraps>

8010715a <vector48>:
8010715a:	6a 00                	push   $0x0
8010715c:	6a 30                	push   $0x30
8010715e:	e9 49 f5 ff ff       	jmp    801066ac <alltraps>

80107163 <vector49>:
80107163:	6a 00                	push   $0x0
80107165:	6a 31                	push   $0x31
80107167:	e9 40 f5 ff ff       	jmp    801066ac <alltraps>

8010716c <vector50>:
8010716c:	6a 00                	push   $0x0
8010716e:	6a 32                	push   $0x32
80107170:	e9 37 f5 ff ff       	jmp    801066ac <alltraps>

80107175 <vector51>:
80107175:	6a 00                	push   $0x0
80107177:	6a 33                	push   $0x33
80107179:	e9 2e f5 ff ff       	jmp    801066ac <alltraps>

8010717e <vector52>:
8010717e:	6a 00                	push   $0x0
80107180:	6a 34                	push   $0x34
80107182:	e9 25 f5 ff ff       	jmp    801066ac <alltraps>

80107187 <vector53>:
80107187:	6a 00                	push   $0x0
80107189:	6a 35                	push   $0x35
8010718b:	e9 1c f5 ff ff       	jmp    801066ac <alltraps>

80107190 <vector54>:
80107190:	6a 00                	push   $0x0
80107192:	6a 36                	push   $0x36
80107194:	e9 13 f5 ff ff       	jmp    801066ac <alltraps>

80107199 <vector55>:
80107199:	6a 00                	push   $0x0
8010719b:	6a 37                	push   $0x37
8010719d:	e9 0a f5 ff ff       	jmp    801066ac <alltraps>

801071a2 <vector56>:
801071a2:	6a 00                	push   $0x0
801071a4:	6a 38                	push   $0x38
801071a6:	e9 01 f5 ff ff       	jmp    801066ac <alltraps>

801071ab <vector57>:
801071ab:	6a 00                	push   $0x0
801071ad:	6a 39                	push   $0x39
801071af:	e9 f8 f4 ff ff       	jmp    801066ac <alltraps>

801071b4 <vector58>:
801071b4:	6a 00                	push   $0x0
801071b6:	6a 3a                	push   $0x3a
801071b8:	e9 ef f4 ff ff       	jmp    801066ac <alltraps>

801071bd <vector59>:
801071bd:	6a 00                	push   $0x0
801071bf:	6a 3b                	push   $0x3b
801071c1:	e9 e6 f4 ff ff       	jmp    801066ac <alltraps>

801071c6 <vector60>:
801071c6:	6a 00                	push   $0x0
801071c8:	6a 3c                	push   $0x3c
801071ca:	e9 dd f4 ff ff       	jmp    801066ac <alltraps>

801071cf <vector61>:
801071cf:	6a 00                	push   $0x0
801071d1:	6a 3d                	push   $0x3d
801071d3:	e9 d4 f4 ff ff       	jmp    801066ac <alltraps>

801071d8 <vector62>:
801071d8:	6a 00                	push   $0x0
801071da:	6a 3e                	push   $0x3e
801071dc:	e9 cb f4 ff ff       	jmp    801066ac <alltraps>

801071e1 <vector63>:
801071e1:	6a 00                	push   $0x0
801071e3:	6a 3f                	push   $0x3f
801071e5:	e9 c2 f4 ff ff       	jmp    801066ac <alltraps>

801071ea <vector64>:
801071ea:	6a 00                	push   $0x0
801071ec:	6a 40                	push   $0x40
801071ee:	e9 b9 f4 ff ff       	jmp    801066ac <alltraps>

801071f3 <vector65>:
801071f3:	6a 00                	push   $0x0
801071f5:	6a 41                	push   $0x41
801071f7:	e9 b0 f4 ff ff       	jmp    801066ac <alltraps>

801071fc <vector66>:
801071fc:	6a 00                	push   $0x0
801071fe:	6a 42                	push   $0x42
80107200:	e9 a7 f4 ff ff       	jmp    801066ac <alltraps>

80107205 <vector67>:
80107205:	6a 00                	push   $0x0
80107207:	6a 43                	push   $0x43
80107209:	e9 9e f4 ff ff       	jmp    801066ac <alltraps>

8010720e <vector68>:
8010720e:	6a 00                	push   $0x0
80107210:	6a 44                	push   $0x44
80107212:	e9 95 f4 ff ff       	jmp    801066ac <alltraps>

80107217 <vector69>:
80107217:	6a 00                	push   $0x0
80107219:	6a 45                	push   $0x45
8010721b:	e9 8c f4 ff ff       	jmp    801066ac <alltraps>

80107220 <vector70>:
80107220:	6a 00                	push   $0x0
80107222:	6a 46                	push   $0x46
80107224:	e9 83 f4 ff ff       	jmp    801066ac <alltraps>

80107229 <vector71>:
80107229:	6a 00                	push   $0x0
8010722b:	6a 47                	push   $0x47
8010722d:	e9 7a f4 ff ff       	jmp    801066ac <alltraps>

80107232 <vector72>:
80107232:	6a 00                	push   $0x0
80107234:	6a 48                	push   $0x48
80107236:	e9 71 f4 ff ff       	jmp    801066ac <alltraps>

8010723b <vector73>:
8010723b:	6a 00                	push   $0x0
8010723d:	6a 49                	push   $0x49
8010723f:	e9 68 f4 ff ff       	jmp    801066ac <alltraps>

80107244 <vector74>:
80107244:	6a 00                	push   $0x0
80107246:	6a 4a                	push   $0x4a
80107248:	e9 5f f4 ff ff       	jmp    801066ac <alltraps>

8010724d <vector75>:
8010724d:	6a 00                	push   $0x0
8010724f:	6a 4b                	push   $0x4b
80107251:	e9 56 f4 ff ff       	jmp    801066ac <alltraps>

80107256 <vector76>:
80107256:	6a 00                	push   $0x0
80107258:	6a 4c                	push   $0x4c
8010725a:	e9 4d f4 ff ff       	jmp    801066ac <alltraps>

8010725f <vector77>:
8010725f:	6a 00                	push   $0x0
80107261:	6a 4d                	push   $0x4d
80107263:	e9 44 f4 ff ff       	jmp    801066ac <alltraps>

80107268 <vector78>:
80107268:	6a 00                	push   $0x0
8010726a:	6a 4e                	push   $0x4e
8010726c:	e9 3b f4 ff ff       	jmp    801066ac <alltraps>

80107271 <vector79>:
80107271:	6a 00                	push   $0x0
80107273:	6a 4f                	push   $0x4f
80107275:	e9 32 f4 ff ff       	jmp    801066ac <alltraps>

8010727a <vector80>:
8010727a:	6a 00                	push   $0x0
8010727c:	6a 50                	push   $0x50
8010727e:	e9 29 f4 ff ff       	jmp    801066ac <alltraps>

80107283 <vector81>:
80107283:	6a 00                	push   $0x0
80107285:	6a 51                	push   $0x51
80107287:	e9 20 f4 ff ff       	jmp    801066ac <alltraps>

8010728c <vector82>:
8010728c:	6a 00                	push   $0x0
8010728e:	6a 52                	push   $0x52
80107290:	e9 17 f4 ff ff       	jmp    801066ac <alltraps>

80107295 <vector83>:
80107295:	6a 00                	push   $0x0
80107297:	6a 53                	push   $0x53
80107299:	e9 0e f4 ff ff       	jmp    801066ac <alltraps>

8010729e <vector84>:
8010729e:	6a 00                	push   $0x0
801072a0:	6a 54                	push   $0x54
801072a2:	e9 05 f4 ff ff       	jmp    801066ac <alltraps>

801072a7 <vector85>:
801072a7:	6a 00                	push   $0x0
801072a9:	6a 55                	push   $0x55
801072ab:	e9 fc f3 ff ff       	jmp    801066ac <alltraps>

801072b0 <vector86>:
801072b0:	6a 00                	push   $0x0
801072b2:	6a 56                	push   $0x56
801072b4:	e9 f3 f3 ff ff       	jmp    801066ac <alltraps>

801072b9 <vector87>:
801072b9:	6a 00                	push   $0x0
801072bb:	6a 57                	push   $0x57
801072bd:	e9 ea f3 ff ff       	jmp    801066ac <alltraps>

801072c2 <vector88>:
801072c2:	6a 00                	push   $0x0
801072c4:	6a 58                	push   $0x58
801072c6:	e9 e1 f3 ff ff       	jmp    801066ac <alltraps>

801072cb <vector89>:
801072cb:	6a 00                	push   $0x0
801072cd:	6a 59                	push   $0x59
801072cf:	e9 d8 f3 ff ff       	jmp    801066ac <alltraps>

801072d4 <vector90>:
801072d4:	6a 00                	push   $0x0
801072d6:	6a 5a                	push   $0x5a
801072d8:	e9 cf f3 ff ff       	jmp    801066ac <alltraps>

801072dd <vector91>:
801072dd:	6a 00                	push   $0x0
801072df:	6a 5b                	push   $0x5b
801072e1:	e9 c6 f3 ff ff       	jmp    801066ac <alltraps>

801072e6 <vector92>:
801072e6:	6a 00                	push   $0x0
801072e8:	6a 5c                	push   $0x5c
801072ea:	e9 bd f3 ff ff       	jmp    801066ac <alltraps>

801072ef <vector93>:
801072ef:	6a 00                	push   $0x0
801072f1:	6a 5d                	push   $0x5d
801072f3:	e9 b4 f3 ff ff       	jmp    801066ac <alltraps>

801072f8 <vector94>:
801072f8:	6a 00                	push   $0x0
801072fa:	6a 5e                	push   $0x5e
801072fc:	e9 ab f3 ff ff       	jmp    801066ac <alltraps>

80107301 <vector95>:
80107301:	6a 00                	push   $0x0
80107303:	6a 5f                	push   $0x5f
80107305:	e9 a2 f3 ff ff       	jmp    801066ac <alltraps>

8010730a <vector96>:
8010730a:	6a 00                	push   $0x0
8010730c:	6a 60                	push   $0x60
8010730e:	e9 99 f3 ff ff       	jmp    801066ac <alltraps>

80107313 <vector97>:
80107313:	6a 00                	push   $0x0
80107315:	6a 61                	push   $0x61
80107317:	e9 90 f3 ff ff       	jmp    801066ac <alltraps>

8010731c <vector98>:
8010731c:	6a 00                	push   $0x0
8010731e:	6a 62                	push   $0x62
80107320:	e9 87 f3 ff ff       	jmp    801066ac <alltraps>

80107325 <vector99>:
80107325:	6a 00                	push   $0x0
80107327:	6a 63                	push   $0x63
80107329:	e9 7e f3 ff ff       	jmp    801066ac <alltraps>

8010732e <vector100>:
8010732e:	6a 00                	push   $0x0
80107330:	6a 64                	push   $0x64
80107332:	e9 75 f3 ff ff       	jmp    801066ac <alltraps>

80107337 <vector101>:
80107337:	6a 00                	push   $0x0
80107339:	6a 65                	push   $0x65
8010733b:	e9 6c f3 ff ff       	jmp    801066ac <alltraps>

80107340 <vector102>:
80107340:	6a 00                	push   $0x0
80107342:	6a 66                	push   $0x66
80107344:	e9 63 f3 ff ff       	jmp    801066ac <alltraps>

80107349 <vector103>:
80107349:	6a 00                	push   $0x0
8010734b:	6a 67                	push   $0x67
8010734d:	e9 5a f3 ff ff       	jmp    801066ac <alltraps>

80107352 <vector104>:
80107352:	6a 00                	push   $0x0
80107354:	6a 68                	push   $0x68
80107356:	e9 51 f3 ff ff       	jmp    801066ac <alltraps>

8010735b <vector105>:
8010735b:	6a 00                	push   $0x0
8010735d:	6a 69                	push   $0x69
8010735f:	e9 48 f3 ff ff       	jmp    801066ac <alltraps>

80107364 <vector106>:
80107364:	6a 00                	push   $0x0
80107366:	6a 6a                	push   $0x6a
80107368:	e9 3f f3 ff ff       	jmp    801066ac <alltraps>

8010736d <vector107>:
8010736d:	6a 00                	push   $0x0
8010736f:	6a 6b                	push   $0x6b
80107371:	e9 36 f3 ff ff       	jmp    801066ac <alltraps>

80107376 <vector108>:
80107376:	6a 00                	push   $0x0
80107378:	6a 6c                	push   $0x6c
8010737a:	e9 2d f3 ff ff       	jmp    801066ac <alltraps>

8010737f <vector109>:
8010737f:	6a 00                	push   $0x0
80107381:	6a 6d                	push   $0x6d
80107383:	e9 24 f3 ff ff       	jmp    801066ac <alltraps>

80107388 <vector110>:
80107388:	6a 00                	push   $0x0
8010738a:	6a 6e                	push   $0x6e
8010738c:	e9 1b f3 ff ff       	jmp    801066ac <alltraps>

80107391 <vector111>:
80107391:	6a 00                	push   $0x0
80107393:	6a 6f                	push   $0x6f
80107395:	e9 12 f3 ff ff       	jmp    801066ac <alltraps>

8010739a <vector112>:
8010739a:	6a 00                	push   $0x0
8010739c:	6a 70                	push   $0x70
8010739e:	e9 09 f3 ff ff       	jmp    801066ac <alltraps>

801073a3 <vector113>:
801073a3:	6a 00                	push   $0x0
801073a5:	6a 71                	push   $0x71
801073a7:	e9 00 f3 ff ff       	jmp    801066ac <alltraps>

801073ac <vector114>:
801073ac:	6a 00                	push   $0x0
801073ae:	6a 72                	push   $0x72
801073b0:	e9 f7 f2 ff ff       	jmp    801066ac <alltraps>

801073b5 <vector115>:
801073b5:	6a 00                	push   $0x0
801073b7:	6a 73                	push   $0x73
801073b9:	e9 ee f2 ff ff       	jmp    801066ac <alltraps>

801073be <vector116>:
801073be:	6a 00                	push   $0x0
801073c0:	6a 74                	push   $0x74
801073c2:	e9 e5 f2 ff ff       	jmp    801066ac <alltraps>

801073c7 <vector117>:
801073c7:	6a 00                	push   $0x0
801073c9:	6a 75                	push   $0x75
801073cb:	e9 dc f2 ff ff       	jmp    801066ac <alltraps>

801073d0 <vector118>:
801073d0:	6a 00                	push   $0x0
801073d2:	6a 76                	push   $0x76
801073d4:	e9 d3 f2 ff ff       	jmp    801066ac <alltraps>

801073d9 <vector119>:
801073d9:	6a 00                	push   $0x0
801073db:	6a 77                	push   $0x77
801073dd:	e9 ca f2 ff ff       	jmp    801066ac <alltraps>

801073e2 <vector120>:
801073e2:	6a 00                	push   $0x0
801073e4:	6a 78                	push   $0x78
801073e6:	e9 c1 f2 ff ff       	jmp    801066ac <alltraps>

801073eb <vector121>:
801073eb:	6a 00                	push   $0x0
801073ed:	6a 79                	push   $0x79
801073ef:	e9 b8 f2 ff ff       	jmp    801066ac <alltraps>

801073f4 <vector122>:
801073f4:	6a 00                	push   $0x0
801073f6:	6a 7a                	push   $0x7a
801073f8:	e9 af f2 ff ff       	jmp    801066ac <alltraps>

801073fd <vector123>:
801073fd:	6a 00                	push   $0x0
801073ff:	6a 7b                	push   $0x7b
80107401:	e9 a6 f2 ff ff       	jmp    801066ac <alltraps>

80107406 <vector124>:
80107406:	6a 00                	push   $0x0
80107408:	6a 7c                	push   $0x7c
8010740a:	e9 9d f2 ff ff       	jmp    801066ac <alltraps>

8010740f <vector125>:
8010740f:	6a 00                	push   $0x0
80107411:	6a 7d                	push   $0x7d
80107413:	e9 94 f2 ff ff       	jmp    801066ac <alltraps>

80107418 <vector126>:
80107418:	6a 00                	push   $0x0
8010741a:	6a 7e                	push   $0x7e
8010741c:	e9 8b f2 ff ff       	jmp    801066ac <alltraps>

80107421 <vector127>:
80107421:	6a 00                	push   $0x0
80107423:	6a 7f                	push   $0x7f
80107425:	e9 82 f2 ff ff       	jmp    801066ac <alltraps>

8010742a <vector128>:
8010742a:	6a 00                	push   $0x0
8010742c:	68 80 00 00 00       	push   $0x80
80107431:	e9 76 f2 ff ff       	jmp    801066ac <alltraps>

80107436 <vector129>:
80107436:	6a 00                	push   $0x0
80107438:	68 81 00 00 00       	push   $0x81
8010743d:	e9 6a f2 ff ff       	jmp    801066ac <alltraps>

80107442 <vector130>:
80107442:	6a 00                	push   $0x0
80107444:	68 82 00 00 00       	push   $0x82
80107449:	e9 5e f2 ff ff       	jmp    801066ac <alltraps>

8010744e <vector131>:
8010744e:	6a 00                	push   $0x0
80107450:	68 83 00 00 00       	push   $0x83
80107455:	e9 52 f2 ff ff       	jmp    801066ac <alltraps>

8010745a <vector132>:
8010745a:	6a 00                	push   $0x0
8010745c:	68 84 00 00 00       	push   $0x84
80107461:	e9 46 f2 ff ff       	jmp    801066ac <alltraps>

80107466 <vector133>:
80107466:	6a 00                	push   $0x0
80107468:	68 85 00 00 00       	push   $0x85
8010746d:	e9 3a f2 ff ff       	jmp    801066ac <alltraps>

80107472 <vector134>:
80107472:	6a 00                	push   $0x0
80107474:	68 86 00 00 00       	push   $0x86
80107479:	e9 2e f2 ff ff       	jmp    801066ac <alltraps>

8010747e <vector135>:
8010747e:	6a 00                	push   $0x0
80107480:	68 87 00 00 00       	push   $0x87
80107485:	e9 22 f2 ff ff       	jmp    801066ac <alltraps>

8010748a <vector136>:
8010748a:	6a 00                	push   $0x0
8010748c:	68 88 00 00 00       	push   $0x88
80107491:	e9 16 f2 ff ff       	jmp    801066ac <alltraps>

80107496 <vector137>:
80107496:	6a 00                	push   $0x0
80107498:	68 89 00 00 00       	push   $0x89
8010749d:	e9 0a f2 ff ff       	jmp    801066ac <alltraps>

801074a2 <vector138>:
801074a2:	6a 00                	push   $0x0
801074a4:	68 8a 00 00 00       	push   $0x8a
801074a9:	e9 fe f1 ff ff       	jmp    801066ac <alltraps>

801074ae <vector139>:
801074ae:	6a 00                	push   $0x0
801074b0:	68 8b 00 00 00       	push   $0x8b
801074b5:	e9 f2 f1 ff ff       	jmp    801066ac <alltraps>

801074ba <vector140>:
801074ba:	6a 00                	push   $0x0
801074bc:	68 8c 00 00 00       	push   $0x8c
801074c1:	e9 e6 f1 ff ff       	jmp    801066ac <alltraps>

801074c6 <vector141>:
801074c6:	6a 00                	push   $0x0
801074c8:	68 8d 00 00 00       	push   $0x8d
801074cd:	e9 da f1 ff ff       	jmp    801066ac <alltraps>

801074d2 <vector142>:
801074d2:	6a 00                	push   $0x0
801074d4:	68 8e 00 00 00       	push   $0x8e
801074d9:	e9 ce f1 ff ff       	jmp    801066ac <alltraps>

801074de <vector143>:
801074de:	6a 00                	push   $0x0
801074e0:	68 8f 00 00 00       	push   $0x8f
801074e5:	e9 c2 f1 ff ff       	jmp    801066ac <alltraps>

801074ea <vector144>:
801074ea:	6a 00                	push   $0x0
801074ec:	68 90 00 00 00       	push   $0x90
801074f1:	e9 b6 f1 ff ff       	jmp    801066ac <alltraps>

801074f6 <vector145>:
801074f6:	6a 00                	push   $0x0
801074f8:	68 91 00 00 00       	push   $0x91
801074fd:	e9 aa f1 ff ff       	jmp    801066ac <alltraps>

80107502 <vector146>:
80107502:	6a 00                	push   $0x0
80107504:	68 92 00 00 00       	push   $0x92
80107509:	e9 9e f1 ff ff       	jmp    801066ac <alltraps>

8010750e <vector147>:
8010750e:	6a 00                	push   $0x0
80107510:	68 93 00 00 00       	push   $0x93
80107515:	e9 92 f1 ff ff       	jmp    801066ac <alltraps>

8010751a <vector148>:
8010751a:	6a 00                	push   $0x0
8010751c:	68 94 00 00 00       	push   $0x94
80107521:	e9 86 f1 ff ff       	jmp    801066ac <alltraps>

80107526 <vector149>:
80107526:	6a 00                	push   $0x0
80107528:	68 95 00 00 00       	push   $0x95
8010752d:	e9 7a f1 ff ff       	jmp    801066ac <alltraps>

80107532 <vector150>:
80107532:	6a 00                	push   $0x0
80107534:	68 96 00 00 00       	push   $0x96
80107539:	e9 6e f1 ff ff       	jmp    801066ac <alltraps>

8010753e <vector151>:
8010753e:	6a 00                	push   $0x0
80107540:	68 97 00 00 00       	push   $0x97
80107545:	e9 62 f1 ff ff       	jmp    801066ac <alltraps>

8010754a <vector152>:
8010754a:	6a 00                	push   $0x0
8010754c:	68 98 00 00 00       	push   $0x98
80107551:	e9 56 f1 ff ff       	jmp    801066ac <alltraps>

80107556 <vector153>:
80107556:	6a 00                	push   $0x0
80107558:	68 99 00 00 00       	push   $0x99
8010755d:	e9 4a f1 ff ff       	jmp    801066ac <alltraps>

80107562 <vector154>:
80107562:	6a 00                	push   $0x0
80107564:	68 9a 00 00 00       	push   $0x9a
80107569:	e9 3e f1 ff ff       	jmp    801066ac <alltraps>

8010756e <vector155>:
8010756e:	6a 00                	push   $0x0
80107570:	68 9b 00 00 00       	push   $0x9b
80107575:	e9 32 f1 ff ff       	jmp    801066ac <alltraps>

8010757a <vector156>:
8010757a:	6a 00                	push   $0x0
8010757c:	68 9c 00 00 00       	push   $0x9c
80107581:	e9 26 f1 ff ff       	jmp    801066ac <alltraps>

80107586 <vector157>:
80107586:	6a 00                	push   $0x0
80107588:	68 9d 00 00 00       	push   $0x9d
8010758d:	e9 1a f1 ff ff       	jmp    801066ac <alltraps>

80107592 <vector158>:
80107592:	6a 00                	push   $0x0
80107594:	68 9e 00 00 00       	push   $0x9e
80107599:	e9 0e f1 ff ff       	jmp    801066ac <alltraps>

8010759e <vector159>:
8010759e:	6a 00                	push   $0x0
801075a0:	68 9f 00 00 00       	push   $0x9f
801075a5:	e9 02 f1 ff ff       	jmp    801066ac <alltraps>

801075aa <vector160>:
801075aa:	6a 00                	push   $0x0
801075ac:	68 a0 00 00 00       	push   $0xa0
801075b1:	e9 f6 f0 ff ff       	jmp    801066ac <alltraps>

801075b6 <vector161>:
801075b6:	6a 00                	push   $0x0
801075b8:	68 a1 00 00 00       	push   $0xa1
801075bd:	e9 ea f0 ff ff       	jmp    801066ac <alltraps>

801075c2 <vector162>:
801075c2:	6a 00                	push   $0x0
801075c4:	68 a2 00 00 00       	push   $0xa2
801075c9:	e9 de f0 ff ff       	jmp    801066ac <alltraps>

801075ce <vector163>:
801075ce:	6a 00                	push   $0x0
801075d0:	68 a3 00 00 00       	push   $0xa3
801075d5:	e9 d2 f0 ff ff       	jmp    801066ac <alltraps>

801075da <vector164>:
801075da:	6a 00                	push   $0x0
801075dc:	68 a4 00 00 00       	push   $0xa4
801075e1:	e9 c6 f0 ff ff       	jmp    801066ac <alltraps>

801075e6 <vector165>:
801075e6:	6a 00                	push   $0x0
801075e8:	68 a5 00 00 00       	push   $0xa5
801075ed:	e9 ba f0 ff ff       	jmp    801066ac <alltraps>

801075f2 <vector166>:
801075f2:	6a 00                	push   $0x0
801075f4:	68 a6 00 00 00       	push   $0xa6
801075f9:	e9 ae f0 ff ff       	jmp    801066ac <alltraps>

801075fe <vector167>:
801075fe:	6a 00                	push   $0x0
80107600:	68 a7 00 00 00       	push   $0xa7
80107605:	e9 a2 f0 ff ff       	jmp    801066ac <alltraps>

8010760a <vector168>:
8010760a:	6a 00                	push   $0x0
8010760c:	68 a8 00 00 00       	push   $0xa8
80107611:	e9 96 f0 ff ff       	jmp    801066ac <alltraps>

80107616 <vector169>:
80107616:	6a 00                	push   $0x0
80107618:	68 a9 00 00 00       	push   $0xa9
8010761d:	e9 8a f0 ff ff       	jmp    801066ac <alltraps>

80107622 <vector170>:
80107622:	6a 00                	push   $0x0
80107624:	68 aa 00 00 00       	push   $0xaa
80107629:	e9 7e f0 ff ff       	jmp    801066ac <alltraps>

8010762e <vector171>:
8010762e:	6a 00                	push   $0x0
80107630:	68 ab 00 00 00       	push   $0xab
80107635:	e9 72 f0 ff ff       	jmp    801066ac <alltraps>

8010763a <vector172>:
8010763a:	6a 00                	push   $0x0
8010763c:	68 ac 00 00 00       	push   $0xac
80107641:	e9 66 f0 ff ff       	jmp    801066ac <alltraps>

80107646 <vector173>:
80107646:	6a 00                	push   $0x0
80107648:	68 ad 00 00 00       	push   $0xad
8010764d:	e9 5a f0 ff ff       	jmp    801066ac <alltraps>

80107652 <vector174>:
80107652:	6a 00                	push   $0x0
80107654:	68 ae 00 00 00       	push   $0xae
80107659:	e9 4e f0 ff ff       	jmp    801066ac <alltraps>

8010765e <vector175>:
8010765e:	6a 00                	push   $0x0
80107660:	68 af 00 00 00       	push   $0xaf
80107665:	e9 42 f0 ff ff       	jmp    801066ac <alltraps>

8010766a <vector176>:
8010766a:	6a 00                	push   $0x0
8010766c:	68 b0 00 00 00       	push   $0xb0
80107671:	e9 36 f0 ff ff       	jmp    801066ac <alltraps>

80107676 <vector177>:
80107676:	6a 00                	push   $0x0
80107678:	68 b1 00 00 00       	push   $0xb1
8010767d:	e9 2a f0 ff ff       	jmp    801066ac <alltraps>

80107682 <vector178>:
80107682:	6a 00                	push   $0x0
80107684:	68 b2 00 00 00       	push   $0xb2
80107689:	e9 1e f0 ff ff       	jmp    801066ac <alltraps>

8010768e <vector179>:
8010768e:	6a 00                	push   $0x0
80107690:	68 b3 00 00 00       	push   $0xb3
80107695:	e9 12 f0 ff ff       	jmp    801066ac <alltraps>

8010769a <vector180>:
8010769a:	6a 00                	push   $0x0
8010769c:	68 b4 00 00 00       	push   $0xb4
801076a1:	e9 06 f0 ff ff       	jmp    801066ac <alltraps>

801076a6 <vector181>:
801076a6:	6a 00                	push   $0x0
801076a8:	68 b5 00 00 00       	push   $0xb5
801076ad:	e9 fa ef ff ff       	jmp    801066ac <alltraps>

801076b2 <vector182>:
801076b2:	6a 00                	push   $0x0
801076b4:	68 b6 00 00 00       	push   $0xb6
801076b9:	e9 ee ef ff ff       	jmp    801066ac <alltraps>

801076be <vector183>:
801076be:	6a 00                	push   $0x0
801076c0:	68 b7 00 00 00       	push   $0xb7
801076c5:	e9 e2 ef ff ff       	jmp    801066ac <alltraps>

801076ca <vector184>:
801076ca:	6a 00                	push   $0x0
801076cc:	68 b8 00 00 00       	push   $0xb8
801076d1:	e9 d6 ef ff ff       	jmp    801066ac <alltraps>

801076d6 <vector185>:
801076d6:	6a 00                	push   $0x0
801076d8:	68 b9 00 00 00       	push   $0xb9
801076dd:	e9 ca ef ff ff       	jmp    801066ac <alltraps>

801076e2 <vector186>:
801076e2:	6a 00                	push   $0x0
801076e4:	68 ba 00 00 00       	push   $0xba
801076e9:	e9 be ef ff ff       	jmp    801066ac <alltraps>

801076ee <vector187>:
801076ee:	6a 00                	push   $0x0
801076f0:	68 bb 00 00 00       	push   $0xbb
801076f5:	e9 b2 ef ff ff       	jmp    801066ac <alltraps>

801076fa <vector188>:
801076fa:	6a 00                	push   $0x0
801076fc:	68 bc 00 00 00       	push   $0xbc
80107701:	e9 a6 ef ff ff       	jmp    801066ac <alltraps>

80107706 <vector189>:
80107706:	6a 00                	push   $0x0
80107708:	68 bd 00 00 00       	push   $0xbd
8010770d:	e9 9a ef ff ff       	jmp    801066ac <alltraps>

80107712 <vector190>:
80107712:	6a 00                	push   $0x0
80107714:	68 be 00 00 00       	push   $0xbe
80107719:	e9 8e ef ff ff       	jmp    801066ac <alltraps>

8010771e <vector191>:
8010771e:	6a 00                	push   $0x0
80107720:	68 bf 00 00 00       	push   $0xbf
80107725:	e9 82 ef ff ff       	jmp    801066ac <alltraps>

8010772a <vector192>:
8010772a:	6a 00                	push   $0x0
8010772c:	68 c0 00 00 00       	push   $0xc0
80107731:	e9 76 ef ff ff       	jmp    801066ac <alltraps>

80107736 <vector193>:
80107736:	6a 00                	push   $0x0
80107738:	68 c1 00 00 00       	push   $0xc1
8010773d:	e9 6a ef ff ff       	jmp    801066ac <alltraps>

80107742 <vector194>:
80107742:	6a 00                	push   $0x0
80107744:	68 c2 00 00 00       	push   $0xc2
80107749:	e9 5e ef ff ff       	jmp    801066ac <alltraps>

8010774e <vector195>:
8010774e:	6a 00                	push   $0x0
80107750:	68 c3 00 00 00       	push   $0xc3
80107755:	e9 52 ef ff ff       	jmp    801066ac <alltraps>

8010775a <vector196>:
8010775a:	6a 00                	push   $0x0
8010775c:	68 c4 00 00 00       	push   $0xc4
80107761:	e9 46 ef ff ff       	jmp    801066ac <alltraps>

80107766 <vector197>:
80107766:	6a 00                	push   $0x0
80107768:	68 c5 00 00 00       	push   $0xc5
8010776d:	e9 3a ef ff ff       	jmp    801066ac <alltraps>

80107772 <vector198>:
80107772:	6a 00                	push   $0x0
80107774:	68 c6 00 00 00       	push   $0xc6
80107779:	e9 2e ef ff ff       	jmp    801066ac <alltraps>

8010777e <vector199>:
8010777e:	6a 00                	push   $0x0
80107780:	68 c7 00 00 00       	push   $0xc7
80107785:	e9 22 ef ff ff       	jmp    801066ac <alltraps>

8010778a <vector200>:
8010778a:	6a 00                	push   $0x0
8010778c:	68 c8 00 00 00       	push   $0xc8
80107791:	e9 16 ef ff ff       	jmp    801066ac <alltraps>

80107796 <vector201>:
80107796:	6a 00                	push   $0x0
80107798:	68 c9 00 00 00       	push   $0xc9
8010779d:	e9 0a ef ff ff       	jmp    801066ac <alltraps>

801077a2 <vector202>:
801077a2:	6a 00                	push   $0x0
801077a4:	68 ca 00 00 00       	push   $0xca
801077a9:	e9 fe ee ff ff       	jmp    801066ac <alltraps>

801077ae <vector203>:
801077ae:	6a 00                	push   $0x0
801077b0:	68 cb 00 00 00       	push   $0xcb
801077b5:	e9 f2 ee ff ff       	jmp    801066ac <alltraps>

801077ba <vector204>:
801077ba:	6a 00                	push   $0x0
801077bc:	68 cc 00 00 00       	push   $0xcc
801077c1:	e9 e6 ee ff ff       	jmp    801066ac <alltraps>

801077c6 <vector205>:
801077c6:	6a 00                	push   $0x0
801077c8:	68 cd 00 00 00       	push   $0xcd
801077cd:	e9 da ee ff ff       	jmp    801066ac <alltraps>

801077d2 <vector206>:
801077d2:	6a 00                	push   $0x0
801077d4:	68 ce 00 00 00       	push   $0xce
801077d9:	e9 ce ee ff ff       	jmp    801066ac <alltraps>

801077de <vector207>:
801077de:	6a 00                	push   $0x0
801077e0:	68 cf 00 00 00       	push   $0xcf
801077e5:	e9 c2 ee ff ff       	jmp    801066ac <alltraps>

801077ea <vector208>:
801077ea:	6a 00                	push   $0x0
801077ec:	68 d0 00 00 00       	push   $0xd0
801077f1:	e9 b6 ee ff ff       	jmp    801066ac <alltraps>

801077f6 <vector209>:
801077f6:	6a 00                	push   $0x0
801077f8:	68 d1 00 00 00       	push   $0xd1
801077fd:	e9 aa ee ff ff       	jmp    801066ac <alltraps>

80107802 <vector210>:
80107802:	6a 00                	push   $0x0
80107804:	68 d2 00 00 00       	push   $0xd2
80107809:	e9 9e ee ff ff       	jmp    801066ac <alltraps>

8010780e <vector211>:
8010780e:	6a 00                	push   $0x0
80107810:	68 d3 00 00 00       	push   $0xd3
80107815:	e9 92 ee ff ff       	jmp    801066ac <alltraps>

8010781a <vector212>:
8010781a:	6a 00                	push   $0x0
8010781c:	68 d4 00 00 00       	push   $0xd4
80107821:	e9 86 ee ff ff       	jmp    801066ac <alltraps>

80107826 <vector213>:
80107826:	6a 00                	push   $0x0
80107828:	68 d5 00 00 00       	push   $0xd5
8010782d:	e9 7a ee ff ff       	jmp    801066ac <alltraps>

80107832 <vector214>:
80107832:	6a 00                	push   $0x0
80107834:	68 d6 00 00 00       	push   $0xd6
80107839:	e9 6e ee ff ff       	jmp    801066ac <alltraps>

8010783e <vector215>:
8010783e:	6a 00                	push   $0x0
80107840:	68 d7 00 00 00       	push   $0xd7
80107845:	e9 62 ee ff ff       	jmp    801066ac <alltraps>

8010784a <vector216>:
8010784a:	6a 00                	push   $0x0
8010784c:	68 d8 00 00 00       	push   $0xd8
80107851:	e9 56 ee ff ff       	jmp    801066ac <alltraps>

80107856 <vector217>:
80107856:	6a 00                	push   $0x0
80107858:	68 d9 00 00 00       	push   $0xd9
8010785d:	e9 4a ee ff ff       	jmp    801066ac <alltraps>

80107862 <vector218>:
80107862:	6a 00                	push   $0x0
80107864:	68 da 00 00 00       	push   $0xda
80107869:	e9 3e ee ff ff       	jmp    801066ac <alltraps>

8010786e <vector219>:
8010786e:	6a 00                	push   $0x0
80107870:	68 db 00 00 00       	push   $0xdb
80107875:	e9 32 ee ff ff       	jmp    801066ac <alltraps>

8010787a <vector220>:
8010787a:	6a 00                	push   $0x0
8010787c:	68 dc 00 00 00       	push   $0xdc
80107881:	e9 26 ee ff ff       	jmp    801066ac <alltraps>

80107886 <vector221>:
80107886:	6a 00                	push   $0x0
80107888:	68 dd 00 00 00       	push   $0xdd
8010788d:	e9 1a ee ff ff       	jmp    801066ac <alltraps>

80107892 <vector222>:
80107892:	6a 00                	push   $0x0
80107894:	68 de 00 00 00       	push   $0xde
80107899:	e9 0e ee ff ff       	jmp    801066ac <alltraps>

8010789e <vector223>:
8010789e:	6a 00                	push   $0x0
801078a0:	68 df 00 00 00       	push   $0xdf
801078a5:	e9 02 ee ff ff       	jmp    801066ac <alltraps>

801078aa <vector224>:
801078aa:	6a 00                	push   $0x0
801078ac:	68 e0 00 00 00       	push   $0xe0
801078b1:	e9 f6 ed ff ff       	jmp    801066ac <alltraps>

801078b6 <vector225>:
801078b6:	6a 00                	push   $0x0
801078b8:	68 e1 00 00 00       	push   $0xe1
801078bd:	e9 ea ed ff ff       	jmp    801066ac <alltraps>

801078c2 <vector226>:
801078c2:	6a 00                	push   $0x0
801078c4:	68 e2 00 00 00       	push   $0xe2
801078c9:	e9 de ed ff ff       	jmp    801066ac <alltraps>

801078ce <vector227>:
801078ce:	6a 00                	push   $0x0
801078d0:	68 e3 00 00 00       	push   $0xe3
801078d5:	e9 d2 ed ff ff       	jmp    801066ac <alltraps>

801078da <vector228>:
801078da:	6a 00                	push   $0x0
801078dc:	68 e4 00 00 00       	push   $0xe4
801078e1:	e9 c6 ed ff ff       	jmp    801066ac <alltraps>

801078e6 <vector229>:
801078e6:	6a 00                	push   $0x0
801078e8:	68 e5 00 00 00       	push   $0xe5
801078ed:	e9 ba ed ff ff       	jmp    801066ac <alltraps>

801078f2 <vector230>:
801078f2:	6a 00                	push   $0x0
801078f4:	68 e6 00 00 00       	push   $0xe6
801078f9:	e9 ae ed ff ff       	jmp    801066ac <alltraps>

801078fe <vector231>:
801078fe:	6a 00                	push   $0x0
80107900:	68 e7 00 00 00       	push   $0xe7
80107905:	e9 a2 ed ff ff       	jmp    801066ac <alltraps>

8010790a <vector232>:
8010790a:	6a 00                	push   $0x0
8010790c:	68 e8 00 00 00       	push   $0xe8
80107911:	e9 96 ed ff ff       	jmp    801066ac <alltraps>

80107916 <vector233>:
80107916:	6a 00                	push   $0x0
80107918:	68 e9 00 00 00       	push   $0xe9
8010791d:	e9 8a ed ff ff       	jmp    801066ac <alltraps>

80107922 <vector234>:
80107922:	6a 00                	push   $0x0
80107924:	68 ea 00 00 00       	push   $0xea
80107929:	e9 7e ed ff ff       	jmp    801066ac <alltraps>

8010792e <vector235>:
8010792e:	6a 00                	push   $0x0
80107930:	68 eb 00 00 00       	push   $0xeb
80107935:	e9 72 ed ff ff       	jmp    801066ac <alltraps>

8010793a <vector236>:
8010793a:	6a 00                	push   $0x0
8010793c:	68 ec 00 00 00       	push   $0xec
80107941:	e9 66 ed ff ff       	jmp    801066ac <alltraps>

80107946 <vector237>:
80107946:	6a 00                	push   $0x0
80107948:	68 ed 00 00 00       	push   $0xed
8010794d:	e9 5a ed ff ff       	jmp    801066ac <alltraps>

80107952 <vector238>:
80107952:	6a 00                	push   $0x0
80107954:	68 ee 00 00 00       	push   $0xee
80107959:	e9 4e ed ff ff       	jmp    801066ac <alltraps>

8010795e <vector239>:
8010795e:	6a 00                	push   $0x0
80107960:	68 ef 00 00 00       	push   $0xef
80107965:	e9 42 ed ff ff       	jmp    801066ac <alltraps>

8010796a <vector240>:
8010796a:	6a 00                	push   $0x0
8010796c:	68 f0 00 00 00       	push   $0xf0
80107971:	e9 36 ed ff ff       	jmp    801066ac <alltraps>

80107976 <vector241>:
80107976:	6a 00                	push   $0x0
80107978:	68 f1 00 00 00       	push   $0xf1
8010797d:	e9 2a ed ff ff       	jmp    801066ac <alltraps>

80107982 <vector242>:
80107982:	6a 00                	push   $0x0
80107984:	68 f2 00 00 00       	push   $0xf2
80107989:	e9 1e ed ff ff       	jmp    801066ac <alltraps>

8010798e <vector243>:
8010798e:	6a 00                	push   $0x0
80107990:	68 f3 00 00 00       	push   $0xf3
80107995:	e9 12 ed ff ff       	jmp    801066ac <alltraps>

8010799a <vector244>:
8010799a:	6a 00                	push   $0x0
8010799c:	68 f4 00 00 00       	push   $0xf4
801079a1:	e9 06 ed ff ff       	jmp    801066ac <alltraps>

801079a6 <vector245>:
801079a6:	6a 00                	push   $0x0
801079a8:	68 f5 00 00 00       	push   $0xf5
801079ad:	e9 fa ec ff ff       	jmp    801066ac <alltraps>

801079b2 <vector246>:
801079b2:	6a 00                	push   $0x0
801079b4:	68 f6 00 00 00       	push   $0xf6
801079b9:	e9 ee ec ff ff       	jmp    801066ac <alltraps>

801079be <vector247>:
801079be:	6a 00                	push   $0x0
801079c0:	68 f7 00 00 00       	push   $0xf7
801079c5:	e9 e2 ec ff ff       	jmp    801066ac <alltraps>

801079ca <vector248>:
801079ca:	6a 00                	push   $0x0
801079cc:	68 f8 00 00 00       	push   $0xf8
801079d1:	e9 d6 ec ff ff       	jmp    801066ac <alltraps>

801079d6 <vector249>:
801079d6:	6a 00                	push   $0x0
801079d8:	68 f9 00 00 00       	push   $0xf9
801079dd:	e9 ca ec ff ff       	jmp    801066ac <alltraps>

801079e2 <vector250>:
801079e2:	6a 00                	push   $0x0
801079e4:	68 fa 00 00 00       	push   $0xfa
801079e9:	e9 be ec ff ff       	jmp    801066ac <alltraps>

801079ee <vector251>:
801079ee:	6a 00                	push   $0x0
801079f0:	68 fb 00 00 00       	push   $0xfb
801079f5:	e9 b2 ec ff ff       	jmp    801066ac <alltraps>

801079fa <vector252>:
801079fa:	6a 00                	push   $0x0
801079fc:	68 fc 00 00 00       	push   $0xfc
80107a01:	e9 a6 ec ff ff       	jmp    801066ac <alltraps>

80107a06 <vector253>:
80107a06:	6a 00                	push   $0x0
80107a08:	68 fd 00 00 00       	push   $0xfd
80107a0d:	e9 9a ec ff ff       	jmp    801066ac <alltraps>

80107a12 <vector254>:
80107a12:	6a 00                	push   $0x0
80107a14:	68 fe 00 00 00       	push   $0xfe
80107a19:	e9 8e ec ff ff       	jmp    801066ac <alltraps>

80107a1e <vector255>:
80107a1e:	6a 00                	push   $0x0
80107a20:	68 ff 00 00 00       	push   $0xff
80107a25:	e9 82 ec ff ff       	jmp    801066ac <alltraps>
80107a2a:	66 90                	xchg   %ax,%ax

80107a2c <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80107a2c:	55                   	push   %ebp
80107a2d:	89 e5                	mov    %esp,%ebp
80107a2f:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80107a32:	8b 45 0c             	mov    0xc(%ebp),%eax
80107a35:	48                   	dec    %eax
80107a36:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107a3a:	8b 45 08             	mov    0x8(%ebp),%eax
80107a3d:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107a41:	8b 45 08             	mov    0x8(%ebp),%eax
80107a44:	c1 e8 10             	shr    $0x10,%eax
80107a47:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80107a4b:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107a4e:	0f 01 10             	lgdtl  (%eax)
}
80107a51:	c9                   	leave  
80107a52:	c3                   	ret    

80107a53 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80107a53:	55                   	push   %ebp
80107a54:	89 e5                	mov    %esp,%ebp
80107a56:	83 ec 04             	sub    $0x4,%esp
80107a59:	8b 45 08             	mov    0x8(%ebp),%eax
80107a5c:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107a60:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107a63:	0f 00 d8             	ltr    %ax
}
80107a66:	c9                   	leave  
80107a67:	c3                   	ret    

80107a68 <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80107a68:	55                   	push   %ebp
80107a69:	89 e5                	mov    %esp,%ebp
80107a6b:	83 ec 04             	sub    $0x4,%esp
80107a6e:	8b 45 08             	mov    0x8(%ebp),%eax
80107a71:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80107a75:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107a78:	8e e8                	mov    %eax,%gs
}
80107a7a:	c9                   	leave  
80107a7b:	c3                   	ret    

80107a7c <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
80107a7c:	55                   	push   %ebp
80107a7d:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107a7f:	8b 45 08             	mov    0x8(%ebp),%eax
80107a82:	0f 22 d8             	mov    %eax,%cr3
}
80107a85:	5d                   	pop    %ebp
80107a86:	c3                   	ret    

80107a87 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80107a87:	55                   	push   %ebp
80107a88:	89 e5                	mov    %esp,%ebp
80107a8a:	8b 45 08             	mov    0x8(%ebp),%eax
80107a8d:	05 00 00 00 80       	add    $0x80000000,%eax
80107a92:	5d                   	pop    %ebp
80107a93:	c3                   	ret    

80107a94 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80107a94:	55                   	push   %ebp
80107a95:	89 e5                	mov    %esp,%ebp
80107a97:	8b 45 08             	mov    0x8(%ebp),%eax
80107a9a:	05 00 00 00 80       	add    $0x80000000,%eax
80107a9f:	5d                   	pop    %ebp
80107aa0:	c3                   	ret    

80107aa1 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107aa1:	55                   	push   %ebp
80107aa2:	89 e5                	mov    %esp,%ebp
80107aa4:	53                   	push   %ebx
80107aa5:	83 ec 24             	sub    $0x24,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80107aa8:	e8 76 b4 ff ff       	call   80102f23 <cpunum>
80107aad:	89 c2                	mov    %eax,%edx
80107aaf:	89 d0                	mov    %edx,%eax
80107ab1:	d1 e0                	shl    %eax
80107ab3:	01 d0                	add    %edx,%eax
80107ab5:	c1 e0 04             	shl    $0x4,%eax
80107ab8:	29 d0                	sub    %edx,%eax
80107aba:	c1 e0 02             	shl    $0x2,%eax
80107abd:	05 80 33 11 80       	add    $0x80113380,%eax
80107ac2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ac8:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ad1:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ada:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107ade:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ae1:	8a 50 7d             	mov    0x7d(%eax),%dl
80107ae4:	83 e2 f0             	and    $0xfffffff0,%edx
80107ae7:	83 ca 0a             	or     $0xa,%edx
80107aea:	88 50 7d             	mov    %dl,0x7d(%eax)
80107aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107af0:	8a 50 7d             	mov    0x7d(%eax),%dl
80107af3:	83 ca 10             	or     $0x10,%edx
80107af6:	88 50 7d             	mov    %dl,0x7d(%eax)
80107af9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107afc:	8a 50 7d             	mov    0x7d(%eax),%dl
80107aff:	83 e2 9f             	and    $0xffffff9f,%edx
80107b02:	88 50 7d             	mov    %dl,0x7d(%eax)
80107b05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b08:	8a 50 7d             	mov    0x7d(%eax),%dl
80107b0b:	83 ca 80             	or     $0xffffff80,%edx
80107b0e:	88 50 7d             	mov    %dl,0x7d(%eax)
80107b11:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b14:	8a 50 7e             	mov    0x7e(%eax),%dl
80107b17:	83 ca 0f             	or     $0xf,%edx
80107b1a:	88 50 7e             	mov    %dl,0x7e(%eax)
80107b1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b20:	8a 50 7e             	mov    0x7e(%eax),%dl
80107b23:	83 e2 ef             	and    $0xffffffef,%edx
80107b26:	88 50 7e             	mov    %dl,0x7e(%eax)
80107b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b2c:	8a 50 7e             	mov    0x7e(%eax),%dl
80107b2f:	83 e2 df             	and    $0xffffffdf,%edx
80107b32:	88 50 7e             	mov    %dl,0x7e(%eax)
80107b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b38:	8a 50 7e             	mov    0x7e(%eax),%dl
80107b3b:	83 ca 40             	or     $0x40,%edx
80107b3e:	88 50 7e             	mov    %dl,0x7e(%eax)
80107b41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b44:	8a 50 7e             	mov    0x7e(%eax),%dl
80107b47:	83 ca 80             	or     $0xffffff80,%edx
80107b4a:	88 50 7e             	mov    %dl,0x7e(%eax)
80107b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b50:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107b54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b57:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107b5e:	ff ff 
80107b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b63:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107b6a:	00 00 
80107b6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b6f:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b79:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
80107b7f:	83 e2 f0             	and    $0xfffffff0,%edx
80107b82:	83 ca 02             	or     $0x2,%edx
80107b85:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b8e:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
80107b94:	83 ca 10             	or     $0x10,%edx
80107b97:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ba0:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
80107ba6:	83 e2 9f             	and    $0xffffff9f,%edx
80107ba9:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bb2:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
80107bb8:	83 ca 80             	or     $0xffffff80,%edx
80107bbb:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107bc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bc4:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
80107bca:	83 ca 0f             	or     $0xf,%edx
80107bcd:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107bd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bd6:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
80107bdc:	83 e2 ef             	and    $0xffffffef,%edx
80107bdf:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107be5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107be8:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
80107bee:	83 e2 df             	and    $0xffffffdf,%edx
80107bf1:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107bf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bfa:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
80107c00:	83 ca 40             	or     $0x40,%edx
80107c03:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107c09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c0c:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
80107c12:	83 ca 80             	or     $0xffffff80,%edx
80107c15:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107c1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c1e:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107c25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c28:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80107c2f:	ff ff 
80107c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c34:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107c3b:	00 00 
80107c3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c40:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107c47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c4a:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
80107c50:	83 e2 f0             	and    $0xfffffff0,%edx
80107c53:	83 ca 0a             	or     $0xa,%edx
80107c56:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c5f:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
80107c65:	83 ca 10             	or     $0x10,%edx
80107c68:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107c6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c71:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
80107c77:	83 ca 60             	or     $0x60,%edx
80107c7a:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107c80:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c83:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
80107c89:	83 ca 80             	or     $0xffffff80,%edx
80107c8c:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107c92:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c95:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
80107c9b:	83 ca 0f             	or     $0xf,%edx
80107c9e:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107ca4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ca7:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
80107cad:	83 e2 ef             	and    $0xffffffef,%edx
80107cb0:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107cb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cb9:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
80107cbf:	83 e2 df             	and    $0xffffffdf,%edx
80107cc2:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107cc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ccb:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
80107cd1:	83 ca 40             	or     $0x40,%edx
80107cd4:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107cda:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cdd:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
80107ce3:	83 ca 80             	or     $0xffffff80,%edx
80107ce6:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107cec:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cef:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107cf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cf9:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80107d00:	ff ff 
80107d02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d05:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80107d0c:	00 00 
80107d0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d11:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80107d18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d1b:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
80107d21:	83 e2 f0             	and    $0xfffffff0,%edx
80107d24:	83 ca 02             	or     $0x2,%edx
80107d27:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107d2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d30:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
80107d36:	83 ca 10             	or     $0x10,%edx
80107d39:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107d3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d42:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
80107d48:	83 ca 60             	or     $0x60,%edx
80107d4b:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d54:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
80107d5a:	83 ca 80             	or     $0xffffff80,%edx
80107d5d:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107d63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d66:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
80107d6c:	83 ca 0f             	or     $0xf,%edx
80107d6f:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d78:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
80107d7e:	83 e2 ef             	and    $0xffffffef,%edx
80107d81:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107d87:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d8a:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
80107d90:	83 e2 df             	and    $0xffffffdf,%edx
80107d93:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107d99:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d9c:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
80107da2:	83 ca 40             	or     $0x40,%edx
80107da5:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dae:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
80107db4:	83 ca 80             	or     $0xffffff80,%edx
80107db7:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107dbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dc0:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80107dc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dca:	05 b4 00 00 00       	add    $0xb4,%eax
80107dcf:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107dd2:	81 c2 b4 00 00 00    	add    $0xb4,%edx
80107dd8:	c1 ea 10             	shr    $0x10,%edx
80107ddb:	88 d1                	mov    %dl,%cl
80107ddd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107de0:	81 c2 b4 00 00 00    	add    $0xb4,%edx
80107de6:	c1 ea 18             	shr    $0x18,%edx
80107de9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80107dec:	66 c7 83 88 00 00 00 	movw   $0x0,0x88(%ebx)
80107df3:	00 00 
80107df5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80107df8:	66 89 83 8a 00 00 00 	mov    %ax,0x8a(%ebx)
80107dff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e02:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
80107e08:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e0b:	8a 88 8d 00 00 00    	mov    0x8d(%eax),%cl
80107e11:	83 e1 f0             	and    $0xfffffff0,%ecx
80107e14:	83 c9 02             	or     $0x2,%ecx
80107e17:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107e1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e20:	8a 88 8d 00 00 00    	mov    0x8d(%eax),%cl
80107e26:	83 c9 10             	or     $0x10,%ecx
80107e29:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107e2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e32:	8a 88 8d 00 00 00    	mov    0x8d(%eax),%cl
80107e38:	83 e1 9f             	and    $0xffffff9f,%ecx
80107e3b:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e44:	8a 88 8d 00 00 00    	mov    0x8d(%eax),%cl
80107e4a:	83 c9 80             	or     $0xffffff80,%ecx
80107e4d:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107e53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e56:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
80107e5c:	83 e1 f0             	and    $0xfffffff0,%ecx
80107e5f:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107e65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e68:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
80107e6e:	83 e1 ef             	and    $0xffffffef,%ecx
80107e71:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107e77:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e7a:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
80107e80:	83 e1 df             	and    $0xffffffdf,%ecx
80107e83:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107e89:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e8c:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
80107e92:	83 c9 40             	or     $0x40,%ecx
80107e95:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107e9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e9e:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
80107ea4:	83 c9 80             	or     $0xffffff80,%ecx
80107ea7:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107ead:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eb0:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80107eb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eb9:	83 c0 70             	add    $0x70,%eax
80107ebc:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
80107ec3:	00 
80107ec4:	89 04 24             	mov    %eax,(%esp)
80107ec7:	e8 60 fb ff ff       	call   80107a2c <lgdt>
  loadgs(SEG_KCPU << 3);
80107ecc:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
80107ed3:	e8 90 fb ff ff       	call   80107a68 <loadgs>
  
  // Initialize cpu-local storage.
  cpu = c;
80107ed8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107edb:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
80107ee1:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80107ee8:	00 00 00 00 
}
80107eec:	83 c4 24             	add    $0x24,%esp
80107eef:	5b                   	pop    %ebx
80107ef0:	5d                   	pop    %ebp
80107ef1:	c3                   	ret    

80107ef2 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107ef2:	55                   	push   %ebp
80107ef3:	89 e5                	mov    %esp,%ebp
80107ef5:	83 ec 28             	sub    $0x28,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107ef8:	8b 45 0c             	mov    0xc(%ebp),%eax
80107efb:	c1 e8 16             	shr    $0x16,%eax
80107efe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107f05:	8b 45 08             	mov    0x8(%ebp),%eax
80107f08:	01 d0                	add    %edx,%eax
80107f0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80107f0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107f10:	8b 00                	mov    (%eax),%eax
80107f12:	83 e0 01             	and    $0x1,%eax
80107f15:	85 c0                	test   %eax,%eax
80107f17:	74 17                	je     80107f30 <walkpgdir+0x3e>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
80107f19:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107f1c:	8b 00                	mov    (%eax),%eax
80107f1e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107f23:	89 04 24             	mov    %eax,(%esp)
80107f26:	e8 69 fb ff ff       	call   80107a94 <p2v>
80107f2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107f2e:	eb 4b                	jmp    80107f7b <walkpgdir+0x89>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107f30:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80107f34:	74 0e                	je     80107f44 <walkpgdir+0x52>
80107f36:	e8 38 ac ff ff       	call   80102b73 <kalloc>
80107f3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107f3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107f42:	75 07                	jne    80107f4b <walkpgdir+0x59>
      return 0;
80107f44:	b8 00 00 00 00       	mov    $0x0,%eax
80107f49:	eb 47                	jmp    80107f92 <walkpgdir+0xa0>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80107f4b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107f52:	00 
80107f53:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107f5a:	00 
80107f5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f5e:	89 04 24             	mov    %eax,(%esp)
80107f61:	e8 4c d2 ff ff       	call   801051b2 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80107f66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f69:	89 04 24             	mov    %eax,(%esp)
80107f6c:	e8 16 fb ff ff       	call   80107a87 <v2p>
80107f71:	89 c2                	mov    %eax,%edx
80107f73:	83 ca 07             	or     $0x7,%edx
80107f76:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107f79:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80107f7b:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f7e:	c1 e8 0c             	shr    $0xc,%eax
80107f81:	25 ff 03 00 00       	and    $0x3ff,%eax
80107f86:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107f8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f90:	01 d0                	add    %edx,%eax
}
80107f92:	c9                   	leave  
80107f93:	c3                   	ret    

80107f94 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107f94:	55                   	push   %ebp
80107f95:	89 e5                	mov    %esp,%ebp
80107f97:	83 ec 28             	sub    $0x28,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
80107f9a:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f9d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107fa2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107fa5:	8b 55 0c             	mov    0xc(%ebp),%edx
80107fa8:	8b 45 10             	mov    0x10(%ebp),%eax
80107fab:	01 d0                	add    %edx,%eax
80107fad:	48                   	dec    %eax
80107fae:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107fb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107fb6:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80107fbd:	00 
80107fbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fc1:	89 44 24 04          	mov    %eax,0x4(%esp)
80107fc5:	8b 45 08             	mov    0x8(%ebp),%eax
80107fc8:	89 04 24             	mov    %eax,(%esp)
80107fcb:	e8 22 ff ff ff       	call   80107ef2 <walkpgdir>
80107fd0:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107fd3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107fd7:	75 07                	jne    80107fe0 <mappages+0x4c>
      return -1;
80107fd9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107fde:	eb 46                	jmp    80108026 <mappages+0x92>
    if(*pte & PTE_P)
80107fe0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107fe3:	8b 00                	mov    (%eax),%eax
80107fe5:	83 e0 01             	and    $0x1,%eax
80107fe8:	85 c0                	test   %eax,%eax
80107fea:	74 0c                	je     80107ff8 <mappages+0x64>
      panic("remap");
80107fec:	c7 04 24 18 8f 10 80 	movl   $0x80108f18,(%esp)
80107ff3:	e8 3e 85 ff ff       	call   80100536 <panic>
    *pte = pa | perm | PTE_P;
80107ff8:	8b 45 18             	mov    0x18(%ebp),%eax
80107ffb:	0b 45 14             	or     0x14(%ebp),%eax
80107ffe:	89 c2                	mov    %eax,%edx
80108000:	83 ca 01             	or     $0x1,%edx
80108003:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108006:	89 10                	mov    %edx,(%eax)
    if(a == last)
80108008:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010800b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010800e:	74 10                	je     80108020 <mappages+0x8c>
      break;
    a += PGSIZE;
80108010:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80108017:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
8010801e:	eb 96                	jmp    80107fb6 <mappages+0x22>
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
80108020:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80108021:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108026:	c9                   	leave  
80108027:	c3                   	ret    

80108028 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80108028:	55                   	push   %ebp
80108029:	89 e5                	mov    %esp,%ebp
8010802b:	53                   	push   %ebx
8010802c:	83 ec 34             	sub    $0x34,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
8010802f:	e8 3f ab ff ff       	call   80102b73 <kalloc>
80108034:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108037:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010803b:	75 0a                	jne    80108047 <setupkvm+0x1f>
    return 0;
8010803d:	b8 00 00 00 00       	mov    $0x0,%eax
80108042:	e9 98 00 00 00       	jmp    801080df <setupkvm+0xb7>
  memset(pgdir, 0, PGSIZE);
80108047:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010804e:	00 
8010804f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108056:	00 
80108057:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010805a:	89 04 24             	mov    %eax,(%esp)
8010805d:	e8 50 d1 ff ff       	call   801051b2 <memset>
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80108062:	c7 04 24 00 00 00 0e 	movl   $0xe000000,(%esp)
80108069:	e8 26 fa ff ff       	call   80107a94 <p2v>
8010806e:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
80108073:	76 0c                	jbe    80108081 <setupkvm+0x59>
    panic("PHYSTOP too high");
80108075:	c7 04 24 1e 8f 10 80 	movl   $0x80108f1e,(%esp)
8010807c:	e8 b5 84 ff ff       	call   80100536 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108081:	c7 45 f4 c0 c4 10 80 	movl   $0x8010c4c0,-0xc(%ebp)
80108088:	eb 49                	jmp    801080d3 <setupkvm+0xab>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
8010808a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
8010808d:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
80108090:	8b 45 f4             	mov    -0xc(%ebp),%eax
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80108093:	8b 50 04             	mov    0x4(%eax),%edx
80108096:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108099:	8b 58 08             	mov    0x8(%eax),%ebx
8010809c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010809f:	8b 40 04             	mov    0x4(%eax),%eax
801080a2:	29 c3                	sub    %eax,%ebx
801080a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080a7:	8b 00                	mov    (%eax),%eax
801080a9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
801080ad:	89 54 24 0c          	mov    %edx,0xc(%esp)
801080b1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
801080b5:	89 44 24 04          	mov    %eax,0x4(%esp)
801080b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801080bc:	89 04 24             	mov    %eax,(%esp)
801080bf:	e8 d0 fe ff ff       	call   80107f94 <mappages>
801080c4:	85 c0                	test   %eax,%eax
801080c6:	79 07                	jns    801080cf <setupkvm+0xa7>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
801080c8:	b8 00 00 00 00       	mov    $0x0,%eax
801080cd:	eb 10                	jmp    801080df <setupkvm+0xb7>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801080cf:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801080d3:	81 7d f4 00 c5 10 80 	cmpl   $0x8010c500,-0xc(%ebp)
801080da:	72 ae                	jb     8010808a <setupkvm+0x62>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
801080dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801080df:	83 c4 34             	add    $0x34,%esp
801080e2:	5b                   	pop    %ebx
801080e3:	5d                   	pop    %ebp
801080e4:	c3                   	ret    

801080e5 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
801080e5:	55                   	push   %ebp
801080e6:	89 e5                	mov    %esp,%ebp
801080e8:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801080eb:	e8 38 ff ff ff       	call   80108028 <setupkvm>
801080f0:	a3 58 84 11 80       	mov    %eax,0x80118458
  switchkvm();
801080f5:	e8 02 00 00 00       	call   801080fc <switchkvm>
}
801080fa:	c9                   	leave  
801080fb:	c3                   	ret    

801080fc <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
801080fc:	55                   	push   %ebp
801080fd:	89 e5                	mov    %esp,%ebp
801080ff:	83 ec 04             	sub    $0x4,%esp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80108102:	a1 58 84 11 80       	mov    0x80118458,%eax
80108107:	89 04 24             	mov    %eax,(%esp)
8010810a:	e8 78 f9 ff ff       	call   80107a87 <v2p>
8010810f:	89 04 24             	mov    %eax,(%esp)
80108112:	e8 65 f9 ff ff       	call   80107a7c <lcr3>
}
80108117:	c9                   	leave  
80108118:	c3                   	ret    

80108119 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80108119:	55                   	push   %ebp
8010811a:	89 e5                	mov    %esp,%ebp
8010811c:	53                   	push   %ebx
8010811d:	83 ec 14             	sub    $0x14,%esp
  pushcli();
80108120:	e8 8c cf ff ff       	call   801050b1 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80108125:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010812b:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80108132:	83 c2 08             	add    $0x8,%edx
80108135:	65 8b 0d 00 00 00 00 	mov    %gs:0x0,%ecx
8010813c:	83 c1 08             	add    $0x8,%ecx
8010813f:	c1 e9 10             	shr    $0x10,%ecx
80108142:	88 cb                	mov    %cl,%bl
80108144:	65 8b 0d 00 00 00 00 	mov    %gs:0x0,%ecx
8010814b:	83 c1 08             	add    $0x8,%ecx
8010814e:	c1 e9 18             	shr    $0x18,%ecx
80108151:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80108158:	67 00 
8010815a:	66 89 90 a2 00 00 00 	mov    %dx,0xa2(%eax)
80108161:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
80108167:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
8010816d:	83 e2 f0             	and    $0xfffffff0,%edx
80108170:	83 ca 09             	or     $0x9,%edx
80108173:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108179:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
8010817f:	83 ca 10             	or     $0x10,%edx
80108182:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108188:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
8010818e:	83 e2 9f             	and    $0xffffff9f,%edx
80108191:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108197:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
8010819d:	83 ca 80             	or     $0xffffff80,%edx
801081a0:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801081a6:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
801081ac:	83 e2 f0             	and    $0xfffffff0,%edx
801081af:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801081b5:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
801081bb:	83 e2 ef             	and    $0xffffffef,%edx
801081be:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801081c4:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
801081ca:	83 e2 df             	and    $0xffffffdf,%edx
801081cd:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801081d3:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
801081d9:	83 ca 40             	or     $0x40,%edx
801081dc:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801081e2:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
801081e8:	83 e2 7f             	and    $0x7f,%edx
801081eb:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801081f1:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
801081f7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801081fd:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
80108203:	83 e2 ef             	and    $0xffffffef,%edx
80108206:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
8010820c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108212:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80108218:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010821e:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80108225:	8b 52 08             	mov    0x8(%edx),%edx
80108228:	81 c2 00 10 00 00    	add    $0x1000,%edx
8010822e:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
80108231:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
80108238:	e8 16 f8 ff ff       	call   80107a53 <ltr>
  if(p->pgdir == 0)
8010823d:	8b 45 08             	mov    0x8(%ebp),%eax
80108240:	8b 40 04             	mov    0x4(%eax),%eax
80108243:	85 c0                	test   %eax,%eax
80108245:	75 0c                	jne    80108253 <switchuvm+0x13a>
    panic("switchuvm: no pgdir");
80108247:	c7 04 24 2f 8f 10 80 	movl   $0x80108f2f,(%esp)
8010824e:	e8 e3 82 ff ff       	call   80100536 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80108253:	8b 45 08             	mov    0x8(%ebp),%eax
80108256:	8b 40 04             	mov    0x4(%eax),%eax
80108259:	89 04 24             	mov    %eax,(%esp)
8010825c:	e8 26 f8 ff ff       	call   80107a87 <v2p>
80108261:	89 04 24             	mov    %eax,(%esp)
80108264:	e8 13 f8 ff ff       	call   80107a7c <lcr3>
  popcli();
80108269:	e8 89 ce ff ff       	call   801050f7 <popcli>
}
8010826e:	83 c4 14             	add    $0x14,%esp
80108271:	5b                   	pop    %ebx
80108272:	5d                   	pop    %ebp
80108273:	c3                   	ret    

80108274 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80108274:	55                   	push   %ebp
80108275:	89 e5                	mov    %esp,%ebp
80108277:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  
  if(sz >= PGSIZE)
8010827a:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80108281:	76 0c                	jbe    8010828f <inituvm+0x1b>
    panic("inituvm: more than a page");
80108283:	c7 04 24 43 8f 10 80 	movl   $0x80108f43,(%esp)
8010828a:	e8 a7 82 ff ff       	call   80100536 <panic>
  mem = kalloc();
8010828f:	e8 df a8 ff ff       	call   80102b73 <kalloc>
80108294:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80108297:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010829e:	00 
8010829f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801082a6:	00 
801082a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082aa:	89 04 24             	mov    %eax,(%esp)
801082ad:	e8 00 cf ff ff       	call   801051b2 <memset>
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
801082b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082b5:	89 04 24             	mov    %eax,(%esp)
801082b8:	e8 ca f7 ff ff       	call   80107a87 <v2p>
801082bd:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
801082c4:	00 
801082c5:	89 44 24 0c          	mov    %eax,0xc(%esp)
801082c9:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801082d0:	00 
801082d1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801082d8:	00 
801082d9:	8b 45 08             	mov    0x8(%ebp),%eax
801082dc:	89 04 24             	mov    %eax,(%esp)
801082df:	e8 b0 fc ff ff       	call   80107f94 <mappages>
  memmove(mem, init, sz);
801082e4:	8b 45 10             	mov    0x10(%ebp),%eax
801082e7:	89 44 24 08          	mov    %eax,0x8(%esp)
801082eb:	8b 45 0c             	mov    0xc(%ebp),%eax
801082ee:	89 44 24 04          	mov    %eax,0x4(%esp)
801082f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082f5:	89 04 24             	mov    %eax,(%esp)
801082f8:	e8 81 cf ff ff       	call   8010527e <memmove>
}
801082fd:	c9                   	leave  
801082fe:	c3                   	ret    

801082ff <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801082ff:	55                   	push   %ebp
80108300:	89 e5                	mov    %esp,%ebp
80108302:	53                   	push   %ebx
80108303:	83 ec 24             	sub    $0x24,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80108306:	8b 45 0c             	mov    0xc(%ebp),%eax
80108309:	25 ff 0f 00 00       	and    $0xfff,%eax
8010830e:	85 c0                	test   %eax,%eax
80108310:	74 0c                	je     8010831e <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
80108312:	c7 04 24 60 8f 10 80 	movl   $0x80108f60,(%esp)
80108319:	e8 18 82 ff ff       	call   80100536 <panic>
  for(i = 0; i < sz; i += PGSIZE){
8010831e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108325:	e9 ad 00 00 00       	jmp    801083d7 <loaduvm+0xd8>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
8010832a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010832d:	8b 55 0c             	mov    0xc(%ebp),%edx
80108330:	01 d0                	add    %edx,%eax
80108332:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108339:	00 
8010833a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010833e:	8b 45 08             	mov    0x8(%ebp),%eax
80108341:	89 04 24             	mov    %eax,(%esp)
80108344:	e8 a9 fb ff ff       	call   80107ef2 <walkpgdir>
80108349:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010834c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108350:	75 0c                	jne    8010835e <loaduvm+0x5f>
      panic("loaduvm: address should exist");
80108352:	c7 04 24 83 8f 10 80 	movl   $0x80108f83,(%esp)
80108359:	e8 d8 81 ff ff       	call   80100536 <panic>
    pa = PTE_ADDR(*pte);
8010835e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108361:	8b 00                	mov    (%eax),%eax
80108363:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108368:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
8010836b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010836e:	8b 55 18             	mov    0x18(%ebp),%edx
80108371:	89 d1                	mov    %edx,%ecx
80108373:	29 c1                	sub    %eax,%ecx
80108375:	89 c8                	mov    %ecx,%eax
80108377:	3d ff 0f 00 00       	cmp    $0xfff,%eax
8010837c:	77 11                	ja     8010838f <loaduvm+0x90>
      n = sz - i;
8010837e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108381:	8b 55 18             	mov    0x18(%ebp),%edx
80108384:	89 d1                	mov    %edx,%ecx
80108386:	29 c1                	sub    %eax,%ecx
80108388:	89 c8                	mov    %ecx,%eax
8010838a:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010838d:	eb 07                	jmp    80108396 <loaduvm+0x97>
    else
      n = PGSIZE;
8010838f:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80108396:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108399:	8b 55 14             	mov    0x14(%ebp),%edx
8010839c:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
8010839f:	8b 45 e8             	mov    -0x18(%ebp),%eax
801083a2:	89 04 24             	mov    %eax,(%esp)
801083a5:	e8 ea f6 ff ff       	call   80107a94 <p2v>
801083aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
801083ad:	89 54 24 0c          	mov    %edx,0xc(%esp)
801083b1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
801083b5:	89 44 24 04          	mov    %eax,0x4(%esp)
801083b9:	8b 45 10             	mov    0x10(%ebp),%eax
801083bc:	89 04 24             	mov    %eax,(%esp)
801083bf:	e8 00 9a ff ff       	call   80101dc4 <readi>
801083c4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801083c7:	74 07                	je     801083d0 <loaduvm+0xd1>
      return -1;
801083c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801083ce:	eb 18                	jmp    801083e8 <loaduvm+0xe9>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
801083d0:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801083d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083da:	3b 45 18             	cmp    0x18(%ebp),%eax
801083dd:	0f 82 47 ff ff ff    	jb     8010832a <loaduvm+0x2b>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
801083e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801083e8:	83 c4 24             	add    $0x24,%esp
801083eb:	5b                   	pop    %ebx
801083ec:	5d                   	pop    %ebp
801083ed:	c3                   	ret    

801083ee <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801083ee:	55                   	push   %ebp
801083ef:	89 e5                	mov    %esp,%ebp
801083f1:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
801083f4:	8b 45 10             	mov    0x10(%ebp),%eax
801083f7:	85 c0                	test   %eax,%eax
801083f9:	79 0a                	jns    80108405 <allocuvm+0x17>
    return 0;
801083fb:	b8 00 00 00 00       	mov    $0x0,%eax
80108400:	e9 c1 00 00 00       	jmp    801084c6 <allocuvm+0xd8>
  if(newsz < oldsz)
80108405:	8b 45 10             	mov    0x10(%ebp),%eax
80108408:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010840b:	73 08                	jae    80108415 <allocuvm+0x27>
    return oldsz;
8010840d:	8b 45 0c             	mov    0xc(%ebp),%eax
80108410:	e9 b1 00 00 00       	jmp    801084c6 <allocuvm+0xd8>

  a = PGROUNDUP(oldsz);
80108415:	8b 45 0c             	mov    0xc(%ebp),%eax
80108418:	05 ff 0f 00 00       	add    $0xfff,%eax
8010841d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108422:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80108425:	e9 8d 00 00 00       	jmp    801084b7 <allocuvm+0xc9>
    mem = kalloc();
8010842a:	e8 44 a7 ff ff       	call   80102b73 <kalloc>
8010842f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80108432:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108436:	75 2c                	jne    80108464 <allocuvm+0x76>
      cprintf("allocuvm out of memory\n");
80108438:	c7 04 24 a1 8f 10 80 	movl   $0x80108fa1,(%esp)
8010843f:	e8 5d 7f ff ff       	call   801003a1 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80108444:	8b 45 0c             	mov    0xc(%ebp),%eax
80108447:	89 44 24 08          	mov    %eax,0x8(%esp)
8010844b:	8b 45 10             	mov    0x10(%ebp),%eax
8010844e:	89 44 24 04          	mov    %eax,0x4(%esp)
80108452:	8b 45 08             	mov    0x8(%ebp),%eax
80108455:	89 04 24             	mov    %eax,(%esp)
80108458:	e8 6b 00 00 00       	call   801084c8 <deallocuvm>
      return 0;
8010845d:	b8 00 00 00 00       	mov    $0x0,%eax
80108462:	eb 62                	jmp    801084c6 <allocuvm+0xd8>
    }
    memset(mem, 0, PGSIZE);
80108464:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010846b:	00 
8010846c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108473:	00 
80108474:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108477:	89 04 24             	mov    %eax,(%esp)
8010847a:	e8 33 cd ff ff       	call   801051b2 <memset>
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
8010847f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108482:	89 04 24             	mov    %eax,(%esp)
80108485:	e8 fd f5 ff ff       	call   80107a87 <v2p>
8010848a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010848d:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80108494:	00 
80108495:	89 44 24 0c          	mov    %eax,0xc(%esp)
80108499:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801084a0:	00 
801084a1:	89 54 24 04          	mov    %edx,0x4(%esp)
801084a5:	8b 45 08             	mov    0x8(%ebp),%eax
801084a8:	89 04 24             	mov    %eax,(%esp)
801084ab:	e8 e4 fa ff ff       	call   80107f94 <mappages>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
801084b0:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801084b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084ba:	3b 45 10             	cmp    0x10(%ebp),%eax
801084bd:	0f 82 67 ff ff ff    	jb     8010842a <allocuvm+0x3c>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
801084c3:	8b 45 10             	mov    0x10(%ebp),%eax
}
801084c6:	c9                   	leave  
801084c7:	c3                   	ret    

801084c8 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801084c8:	55                   	push   %ebp
801084c9:	89 e5                	mov    %esp,%ebp
801084cb:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801084ce:	8b 45 10             	mov    0x10(%ebp),%eax
801084d1:	3b 45 0c             	cmp    0xc(%ebp),%eax
801084d4:	72 08                	jb     801084de <deallocuvm+0x16>
    return oldsz;
801084d6:	8b 45 0c             	mov    0xc(%ebp),%eax
801084d9:	e9 a4 00 00 00       	jmp    80108582 <deallocuvm+0xba>

  a = PGROUNDUP(newsz);
801084de:	8b 45 10             	mov    0x10(%ebp),%eax
801084e1:	05 ff 0f 00 00       	add    $0xfff,%eax
801084e6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801084eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801084ee:	e9 80 00 00 00       	jmp    80108573 <deallocuvm+0xab>
    pte = walkpgdir(pgdir, (char*)a, 0);
801084f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084f6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801084fd:	00 
801084fe:	89 44 24 04          	mov    %eax,0x4(%esp)
80108502:	8b 45 08             	mov    0x8(%ebp),%eax
80108505:	89 04 24             	mov    %eax,(%esp)
80108508:	e8 e5 f9 ff ff       	call   80107ef2 <walkpgdir>
8010850d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80108510:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108514:	75 09                	jne    8010851f <deallocuvm+0x57>
      a += (NPTENTRIES - 1) * PGSIZE;
80108516:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
8010851d:	eb 4d                	jmp    8010856c <deallocuvm+0xa4>
    else if((*pte & PTE_P) != 0){
8010851f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108522:	8b 00                	mov    (%eax),%eax
80108524:	83 e0 01             	and    $0x1,%eax
80108527:	85 c0                	test   %eax,%eax
80108529:	74 41                	je     8010856c <deallocuvm+0xa4>
      pa = PTE_ADDR(*pte);
8010852b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010852e:	8b 00                	mov    (%eax),%eax
80108530:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108535:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80108538:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010853c:	75 0c                	jne    8010854a <deallocuvm+0x82>
        panic("kfree");
8010853e:	c7 04 24 b9 8f 10 80 	movl   $0x80108fb9,(%esp)
80108545:	e8 ec 7f ff ff       	call   80100536 <panic>
      char *v = p2v(pa);
8010854a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010854d:	89 04 24             	mov    %eax,(%esp)
80108550:	e8 3f f5 ff ff       	call   80107a94 <p2v>
80108555:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80108558:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010855b:	89 04 24             	mov    %eax,(%esp)
8010855e:	e8 77 a5 ff ff       	call   80102ada <kfree>
      *pte = 0;
80108563:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108566:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010856c:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108573:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108576:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108579:	0f 82 74 ff ff ff    	jb     801084f3 <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
8010857f:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108582:	c9                   	leave  
80108583:	c3                   	ret    

80108584 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108584:	55                   	push   %ebp
80108585:	89 e5                	mov    %esp,%ebp
80108587:	83 ec 28             	sub    $0x28,%esp
  uint i;

  if(pgdir == 0)
8010858a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010858e:	75 0c                	jne    8010859c <freevm+0x18>
    panic("freevm: no pgdir");
80108590:	c7 04 24 bf 8f 10 80 	movl   $0x80108fbf,(%esp)
80108597:	e8 9a 7f ff ff       	call   80100536 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
8010859c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801085a3:	00 
801085a4:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
801085ab:	80 
801085ac:	8b 45 08             	mov    0x8(%ebp),%eax
801085af:	89 04 24             	mov    %eax,(%esp)
801085b2:	e8 11 ff ff ff       	call   801084c8 <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
801085b7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801085be:	eb 47                	jmp    80108607 <freevm+0x83>
    if(pgdir[i] & PTE_P){
801085c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801085ca:	8b 45 08             	mov    0x8(%ebp),%eax
801085cd:	01 d0                	add    %edx,%eax
801085cf:	8b 00                	mov    (%eax),%eax
801085d1:	83 e0 01             	and    $0x1,%eax
801085d4:	85 c0                	test   %eax,%eax
801085d6:	74 2c                	je     80108604 <freevm+0x80>
      char * v = p2v(PTE_ADDR(pgdir[i]));
801085d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085db:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801085e2:	8b 45 08             	mov    0x8(%ebp),%eax
801085e5:	01 d0                	add    %edx,%eax
801085e7:	8b 00                	mov    (%eax),%eax
801085e9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801085ee:	89 04 24             	mov    %eax,(%esp)
801085f1:	e8 9e f4 ff ff       	call   80107a94 <p2v>
801085f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
801085f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801085fc:	89 04 24             	mov    %eax,(%esp)
801085ff:	e8 d6 a4 ff ff       	call   80102ada <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80108604:	ff 45 f4             	incl   -0xc(%ebp)
80108607:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
8010860e:	76 b0                	jbe    801085c0 <freevm+0x3c>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80108610:	8b 45 08             	mov    0x8(%ebp),%eax
80108613:	89 04 24             	mov    %eax,(%esp)
80108616:	e8 bf a4 ff ff       	call   80102ada <kfree>
}
8010861b:	c9                   	leave  
8010861c:	c3                   	ret    

8010861d <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
8010861d:	55                   	push   %ebp
8010861e:	89 e5                	mov    %esp,%ebp
80108620:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108623:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010862a:	00 
8010862b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010862e:	89 44 24 04          	mov    %eax,0x4(%esp)
80108632:	8b 45 08             	mov    0x8(%ebp),%eax
80108635:	89 04 24             	mov    %eax,(%esp)
80108638:	e8 b5 f8 ff ff       	call   80107ef2 <walkpgdir>
8010863d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80108640:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108644:	75 0c                	jne    80108652 <clearpteu+0x35>
    panic("clearpteu");
80108646:	c7 04 24 d0 8f 10 80 	movl   $0x80108fd0,(%esp)
8010864d:	e8 e4 7e ff ff       	call   80100536 <panic>
  *pte &= ~PTE_U;
80108652:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108655:	8b 00                	mov    (%eax),%eax
80108657:	89 c2                	mov    %eax,%edx
80108659:	83 e2 fb             	and    $0xfffffffb,%edx
8010865c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010865f:	89 10                	mov    %edx,(%eax)
}
80108661:	c9                   	leave  
80108662:	c3                   	ret    

80108663 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108663:	55                   	push   %ebp
80108664:	89 e5                	mov    %esp,%ebp
80108666:	53                   	push   %ebx
80108667:	83 ec 44             	sub    $0x44,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
8010866a:	e8 b9 f9 ff ff       	call   80108028 <setupkvm>
8010866f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108672:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108676:	75 0a                	jne    80108682 <copyuvm+0x1f>
    return 0;
80108678:	b8 00 00 00 00       	mov    $0x0,%eax
8010867d:	e9 fd 00 00 00       	jmp    8010877f <copyuvm+0x11c>
  for(i = 0; i < sz; i += PGSIZE){
80108682:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108689:	e9 cc 00 00 00       	jmp    8010875a <copyuvm+0xf7>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
8010868e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108691:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108698:	00 
80108699:	89 44 24 04          	mov    %eax,0x4(%esp)
8010869d:	8b 45 08             	mov    0x8(%ebp),%eax
801086a0:	89 04 24             	mov    %eax,(%esp)
801086a3:	e8 4a f8 ff ff       	call   80107ef2 <walkpgdir>
801086a8:	89 45 ec             	mov    %eax,-0x14(%ebp)
801086ab:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801086af:	75 0c                	jne    801086bd <copyuvm+0x5a>
      panic("copyuvm: pte should exist");
801086b1:	c7 04 24 da 8f 10 80 	movl   $0x80108fda,(%esp)
801086b8:	e8 79 7e ff ff       	call   80100536 <panic>
    if(!(*pte & PTE_P))
801086bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
801086c0:	8b 00                	mov    (%eax),%eax
801086c2:	83 e0 01             	and    $0x1,%eax
801086c5:	85 c0                	test   %eax,%eax
801086c7:	75 0c                	jne    801086d5 <copyuvm+0x72>
      panic("copyuvm: page not present");
801086c9:	c7 04 24 f4 8f 10 80 	movl   $0x80108ff4,(%esp)
801086d0:	e8 61 7e ff ff       	call   80100536 <panic>
    pa = PTE_ADDR(*pte);
801086d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801086d8:	8b 00                	mov    (%eax),%eax
801086da:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801086df:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
801086e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801086e5:	8b 00                	mov    (%eax),%eax
801086e7:	25 ff 0f 00 00       	and    $0xfff,%eax
801086ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
801086ef:	e8 7f a4 ff ff       	call   80102b73 <kalloc>
801086f4:	89 45 e0             	mov    %eax,-0x20(%ebp)
801086f7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801086fb:	74 6e                	je     8010876b <copyuvm+0x108>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
801086fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108700:	89 04 24             	mov    %eax,(%esp)
80108703:	e8 8c f3 ff ff       	call   80107a94 <p2v>
80108708:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010870f:	00 
80108710:	89 44 24 04          	mov    %eax,0x4(%esp)
80108714:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108717:	89 04 24             	mov    %eax,(%esp)
8010871a:	e8 5f cb ff ff       	call   8010527e <memmove>
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
8010871f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80108722:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108725:	89 04 24             	mov    %eax,(%esp)
80108728:	e8 5a f3 ff ff       	call   80107a87 <v2p>
8010872d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108730:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80108734:	89 44 24 0c          	mov    %eax,0xc(%esp)
80108738:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010873f:	00 
80108740:	89 54 24 04          	mov    %edx,0x4(%esp)
80108744:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108747:	89 04 24             	mov    %eax,(%esp)
8010874a:	e8 45 f8 ff ff       	call   80107f94 <mappages>
8010874f:	85 c0                	test   %eax,%eax
80108751:	78 1b                	js     8010876e <copyuvm+0x10b>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80108753:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010875a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010875d:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108760:	0f 82 28 ff ff ff    	jb     8010868e <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
80108766:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108769:	eb 14                	jmp    8010877f <copyuvm+0x11c>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
8010876b:	90                   	nop
8010876c:	eb 01                	jmp    8010876f <copyuvm+0x10c>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
8010876e:	90                   	nop
  }
  return d;

bad:
  freevm(d);
8010876f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108772:	89 04 24             	mov    %eax,(%esp)
80108775:	e8 0a fe ff ff       	call   80108584 <freevm>
  return 0;
8010877a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010877f:	83 c4 44             	add    $0x44,%esp
80108782:	5b                   	pop    %ebx
80108783:	5d                   	pop    %ebp
80108784:	c3                   	ret    

80108785 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108785:	55                   	push   %ebp
80108786:	89 e5                	mov    %esp,%ebp
80108788:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010878b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108792:	00 
80108793:	8b 45 0c             	mov    0xc(%ebp),%eax
80108796:	89 44 24 04          	mov    %eax,0x4(%esp)
8010879a:	8b 45 08             	mov    0x8(%ebp),%eax
8010879d:	89 04 24             	mov    %eax,(%esp)
801087a0:	e8 4d f7 ff ff       	call   80107ef2 <walkpgdir>
801087a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
801087a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087ab:	8b 00                	mov    (%eax),%eax
801087ad:	83 e0 01             	and    $0x1,%eax
801087b0:	85 c0                	test   %eax,%eax
801087b2:	75 07                	jne    801087bb <uva2ka+0x36>
    return 0;
801087b4:	b8 00 00 00 00       	mov    $0x0,%eax
801087b9:	eb 25                	jmp    801087e0 <uva2ka+0x5b>
  if((*pte & PTE_U) == 0)
801087bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087be:	8b 00                	mov    (%eax),%eax
801087c0:	83 e0 04             	and    $0x4,%eax
801087c3:	85 c0                	test   %eax,%eax
801087c5:	75 07                	jne    801087ce <uva2ka+0x49>
    return 0;
801087c7:	b8 00 00 00 00       	mov    $0x0,%eax
801087cc:	eb 12                	jmp    801087e0 <uva2ka+0x5b>
  return (char*)p2v(PTE_ADDR(*pte));
801087ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087d1:	8b 00                	mov    (%eax),%eax
801087d3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801087d8:	89 04 24             	mov    %eax,(%esp)
801087db:	e8 b4 f2 ff ff       	call   80107a94 <p2v>
}
801087e0:	c9                   	leave  
801087e1:	c3                   	ret    

801087e2 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801087e2:	55                   	push   %ebp
801087e3:	89 e5                	mov    %esp,%ebp
801087e5:	83 ec 28             	sub    $0x28,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
801087e8:	8b 45 10             	mov    0x10(%ebp),%eax
801087eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
801087ee:	e9 89 00 00 00       	jmp    8010887c <copyout+0x9a>
    va0 = (uint)PGROUNDDOWN(va);
801087f3:	8b 45 0c             	mov    0xc(%ebp),%eax
801087f6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801087fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
801087fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108801:	89 44 24 04          	mov    %eax,0x4(%esp)
80108805:	8b 45 08             	mov    0x8(%ebp),%eax
80108808:	89 04 24             	mov    %eax,(%esp)
8010880b:	e8 75 ff ff ff       	call   80108785 <uva2ka>
80108810:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108813:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108817:	75 07                	jne    80108820 <copyout+0x3e>
      return -1;
80108819:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010881e:	eb 6b                	jmp    8010888b <copyout+0xa9>
    n = PGSIZE - (va - va0);
80108820:	8b 45 0c             	mov    0xc(%ebp),%eax
80108823:	8b 55 ec             	mov    -0x14(%ebp),%edx
80108826:	89 d1                	mov    %edx,%ecx
80108828:	29 c1                	sub    %eax,%ecx
8010882a:	89 c8                	mov    %ecx,%eax
8010882c:	05 00 10 00 00       	add    $0x1000,%eax
80108831:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108834:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108837:	3b 45 14             	cmp    0x14(%ebp),%eax
8010883a:	76 06                	jbe    80108842 <copyout+0x60>
      n = len;
8010883c:	8b 45 14             	mov    0x14(%ebp),%eax
8010883f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80108842:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108845:	8b 55 0c             	mov    0xc(%ebp),%edx
80108848:	29 c2                	sub    %eax,%edx
8010884a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010884d:	01 c2                	add    %eax,%edx
8010884f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108852:	89 44 24 08          	mov    %eax,0x8(%esp)
80108856:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108859:	89 44 24 04          	mov    %eax,0x4(%esp)
8010885d:	89 14 24             	mov    %edx,(%esp)
80108860:	e8 19 ca ff ff       	call   8010527e <memmove>
    len -= n;
80108865:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108868:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
8010886b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010886e:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108871:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108874:	05 00 10 00 00       	add    $0x1000,%eax
80108879:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
8010887c:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108880:	0f 85 6d ff ff ff    	jne    801087f3 <copyout+0x11>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80108886:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010888b:	c9                   	leave  
8010888c:	c3                   	ret    
