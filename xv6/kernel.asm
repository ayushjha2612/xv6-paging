
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

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
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
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
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 50 30 10 80       	mov    $0x80103050,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	f3 0f 1e fb          	endbr32 
80100044:	55                   	push   %ebp
80100045:	89 e5                	mov    %esp,%ebp
80100047:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100048:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
{
8010004d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
80100050:	68 20 74 10 80       	push   $0x80107420
80100055:	68 c0 b5 10 80       	push   $0x8010b5c0
8010005a:	e8 e1 43 00 00       	call   80104440 <initlock>
  bcache.head.next = &bcache.head;
8010005f:	83 c4 10             	add    $0x10,%esp
80100062:	b8 bc fc 10 80       	mov    $0x8010fcbc,%eax
  bcache.head.prev = &bcache.head;
80100067:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
8010006e:	fc 10 80 
  bcache.head.next = &bcache.head;
80100071:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
80100078:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010007b:	eb 05                	jmp    80100082 <binit+0x42>
8010007d:	8d 76 00             	lea    0x0(%esi),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 27 74 10 80       	push   $0x80107427
80100097:	50                   	push   %eax
80100098:	e8 63 42 00 00       	call   80104300 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb 60 fa 10 80    	cmp    $0x8010fa60,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	f3 0f 1e fb          	endbr32 
801000d4:	55                   	push   %ebp
801000d5:	89 e5                	mov    %esp,%ebp
801000d7:	57                   	push   %edi
801000d8:	56                   	push   %esi
801000d9:	53                   	push   %ebx
801000da:	83 ec 18             	sub    $0x18,%esp
801000dd:	8b 7d 08             	mov    0x8(%ebp),%edi
801000e0:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&bcache.lock);
801000e3:	68 c0 b5 10 80       	push   $0x8010b5c0
801000e8:	e8 d3 44 00 00       	call   801045c0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ed:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000f3:	83 c4 10             	add    $0x10,%esp
801000f6:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000fc:	75 0d                	jne    8010010b <bread+0x3b>
801000fe:	eb 20                	jmp    80100120 <bread+0x50>
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 7b 04             	cmp    0x4(%ebx),%edi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 73 08             	cmp    0x8(%ebx),%esi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 65                	je     801001a0 <bread+0xd0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 7b 04             	mov    %edi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 73 08             	mov    %esi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 b5 10 80       	push   $0x8010b5c0
80100162:	e8 19 45 00 00       	call   80104680 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ce 41 00 00       	call   80104340 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 ff 20 00 00       	call   80102290 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
8010019e:	66 90                	xchg   %ax,%ax
  panic("bget: no buffers");
801001a0:	83 ec 0c             	sub    $0xc,%esp
801001a3:	68 2e 74 10 80       	push   $0x8010742e
801001a8:	e8 e3 01 00 00       	call   80100390 <panic>
801001ad:	8d 76 00             	lea    0x0(%esi),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	f3 0f 1e fb          	endbr32 
801001b4:	55                   	push   %ebp
801001b5:	89 e5                	mov    %esp,%ebp
801001b7:	53                   	push   %ebx
801001b8:	83 ec 10             	sub    $0x10,%esp
801001bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001be:	8d 43 0c             	lea    0xc(%ebx),%eax
801001c1:	50                   	push   %eax
801001c2:	e8 19 42 00 00       	call   801043e0 <holdingsleep>
801001c7:	83 c4 10             	add    $0x10,%esp
801001ca:	85 c0                	test   %eax,%eax
801001cc:	74 0f                	je     801001dd <bwrite+0x2d>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ce:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001d1:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d7:	c9                   	leave  
  iderw(b);
801001d8:	e9 b3 20 00 00       	jmp    80102290 <iderw>
    panic("bwrite");
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	68 3f 74 10 80       	push   $0x8010743f
801001e5:	e8 a6 01 00 00       	call   80100390 <panic>
801001ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	f3 0f 1e fb          	endbr32 
801001f4:	55                   	push   %ebp
801001f5:	89 e5                	mov    %esp,%ebp
801001f7:	56                   	push   %esi
801001f8:	53                   	push   %ebx
801001f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001fc:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ff:	83 ec 0c             	sub    $0xc,%esp
80100202:	56                   	push   %esi
80100203:	e8 d8 41 00 00       	call   801043e0 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 88 41 00 00       	call   801043a0 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010021f:	e8 9c 43 00 00       	call   801045c0 <acquire>
  b->refcnt--;
80100224:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100227:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
8010022a:	83 e8 01             	sub    $0x1,%eax
8010022d:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
80100230:	85 c0                	test   %eax,%eax
80100232:	75 2f                	jne    80100263 <brelse+0x73>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100234:	8b 43 54             	mov    0x54(%ebx),%eax
80100237:	8b 53 50             	mov    0x50(%ebx),%edx
8010023a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010023d:	8b 43 50             	mov    0x50(%ebx),%eax
80100240:	8b 53 54             	mov    0x54(%ebx),%edx
80100243:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100246:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
8010024b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    b->next = bcache.head.next;
80100252:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100255:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
8010025a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010025d:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
80100263:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
8010026a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010026d:	5b                   	pop    %ebx
8010026e:	5e                   	pop    %esi
8010026f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100270:	e9 0b 44 00 00       	jmp    80104680 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 46 74 10 80       	push   $0x80107446
8010027d:	e8 0e 01 00 00       	call   80100390 <panic>
80100282:	66 90                	xchg   %ax,%ax
80100284:	66 90                	xchg   %ax,%ax
80100286:	66 90                	xchg   %ax,%ax
80100288:	66 90                	xchg   %ax,%ax
8010028a:	66 90                	xchg   %ax,%ax
8010028c:	66 90                	xchg   %ax,%ax
8010028e:	66 90                	xchg   %ax,%ax

80100290 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100290:	f3 0f 1e fb          	endbr32 
80100294:	55                   	push   %ebp
80100295:	89 e5                	mov    %esp,%ebp
80100297:	57                   	push   %edi
80100298:	56                   	push   %esi
80100299:	53                   	push   %ebx
8010029a:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
8010029d:	ff 75 08             	pushl  0x8(%ebp)
{
801002a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  target = n;
801002a3:	89 de                	mov    %ebx,%esi
  iunlock(ip);
801002a5:	e8 a6 15 00 00       	call   80101850 <iunlock>
  acquire(&cons.lock);
801002aa:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801002b1:	e8 0a 43 00 00       	call   801045c0 <acquire>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002b6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  while(n > 0){
801002b9:	83 c4 10             	add    $0x10,%esp
    *dst++ = c;
801002bc:	01 df                	add    %ebx,%edi
  while(n > 0){
801002be:	85 db                	test   %ebx,%ebx
801002c0:	0f 8e 97 00 00 00    	jle    8010035d <consoleread+0xcd>
    while(input.r == input.w){
801002c6:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002cb:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002d1:	74 27                	je     801002fa <consoleread+0x6a>
801002d3:	eb 5b                	jmp    80100330 <consoleread+0xa0>
801002d5:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 20 a5 10 80       	push   $0x8010a520
801002e0:	68 a0 ff 10 80       	push   $0x8010ffa0
801002e5:	e8 96 3c 00 00       	call   80103f80 <sleep>
    while(input.r == input.w){
801002ea:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 81 36 00 00       	call   80103980 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 a5 10 80       	push   $0x8010a520
8010030e:	e8 6d 43 00 00       	call   80104680 <release>
        ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	pushl  0x8(%ebp)
80100317:	e8 54 14 00 00       	call   80101770 <ilock>
        return -1;
8010031c:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
8010031f:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100322:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100327:	5b                   	pop    %ebx
80100328:	5e                   	pop    %esi
80100329:	5f                   	pop    %edi
8010032a:	5d                   	pop    %ebp
8010032b:	c3                   	ret    
8010032c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100330:	8d 50 01             	lea    0x1(%eax),%edx
80100333:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a 20 ff 10 80 	movsbl -0x7fef00e0(%edx),%ecx
    if(c == C('D')){  // EOF
80100345:	80 f9 04             	cmp    $0x4,%cl
80100348:	74 38                	je     80100382 <consoleread+0xf2>
    *dst++ = c;
8010034a:	89 d8                	mov    %ebx,%eax
    --n;
8010034c:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
8010034f:	f7 d8                	neg    %eax
80100351:	88 0c 07             	mov    %cl,(%edi,%eax,1)
    if(c == '\n')
80100354:	83 f9 0a             	cmp    $0xa,%ecx
80100357:	0f 85 61 ff ff ff    	jne    801002be <consoleread+0x2e>
  release(&cons.lock);
8010035d:	83 ec 0c             	sub    $0xc,%esp
80100360:	68 20 a5 10 80       	push   $0x8010a520
80100365:	e8 16 43 00 00       	call   80104680 <release>
  ilock(ip);
8010036a:	58                   	pop    %eax
8010036b:	ff 75 08             	pushl  0x8(%ebp)
8010036e:	e8 fd 13 00 00       	call   80101770 <ilock>
  return target - n;
80100373:	89 f0                	mov    %esi,%eax
80100375:	83 c4 10             	add    $0x10,%esp
}
80100378:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
8010037b:	29 d8                	sub    %ebx,%eax
}
8010037d:	5b                   	pop    %ebx
8010037e:	5e                   	pop    %esi
8010037f:	5f                   	pop    %edi
80100380:	5d                   	pop    %ebp
80100381:	c3                   	ret    
      if(n < target){
80100382:	39 f3                	cmp    %esi,%ebx
80100384:	73 d7                	jae    8010035d <consoleread+0xcd>
        input.r--;
80100386:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
8010038b:	eb d0                	jmp    8010035d <consoleread+0xcd>
8010038d:	8d 76 00             	lea    0x0(%esi),%esi

80100390 <panic>:
{
80100390:	f3 0f 1e fb          	endbr32 
80100394:	55                   	push   %ebp
80100395:	89 e5                	mov    %esp,%ebp
80100397:	56                   	push   %esi
80100398:	53                   	push   %ebx
80100399:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
8010039c:	fa                   	cli    
  cons.locking = 0;
8010039d:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
801003a4:	00 00 00 
  getcallerpcs(&s, pcs);
801003a7:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003aa:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003ad:	e8 fe 24 00 00       	call   801028b0 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 4d 74 10 80       	push   $0x8010744d
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 55 7c 10 80 	movl   $0x80107c55,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 7f 40 00 00       	call   80104460 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 61 74 10 80       	push   $0x80107461
801003f1:	e8 ba 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003f6:	83 c4 10             	add    $0x10,%esp
801003f9:	39 f3                	cmp    %esi,%ebx
801003fb:	75 e7                	jne    801003e4 <panic+0x54>
  panicked = 1; // freeze other CPU
801003fd:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
80100404:	00 00 00 
  for(;;)
80100407:	eb fe                	jmp    80100407 <panic+0x77>
80100409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100410 <consputc.part.0>:
consputc(int c)
80100410:	55                   	push   %ebp
80100411:	89 e5                	mov    %esp,%ebp
80100413:	57                   	push   %edi
80100414:	56                   	push   %esi
80100415:	53                   	push   %ebx
80100416:	89 c3                	mov    %eax,%ebx
80100418:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010041b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100420:	0f 84 ea 00 00 00    	je     80100510 <consputc.part.0+0x100>
    uartputc(c);
80100426:	83 ec 0c             	sub    $0xc,%esp
80100429:	50                   	push   %eax
8010042a:	e8 b1 5b 00 00       	call   80105fe0 <uartputc>
8010042f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100432:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100437:	b8 0e 00 00 00       	mov    $0xe,%eax
8010043c:	89 fa                	mov    %edi,%edx
8010043e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010043f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100444:	89 ca                	mov    %ecx,%edx
80100446:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100447:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010044a:	89 fa                	mov    %edi,%edx
8010044c:	c1 e0 08             	shl    $0x8,%eax
8010044f:	89 c6                	mov    %eax,%esi
80100451:	b8 0f 00 00 00       	mov    $0xf,%eax
80100456:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100457:	89 ca                	mov    %ecx,%edx
80100459:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010045a:	0f b6 c0             	movzbl %al,%eax
8010045d:	09 f0                	or     %esi,%eax
  if(c == '\n')
8010045f:	83 fb 0a             	cmp    $0xa,%ebx
80100462:	0f 84 90 00 00 00    	je     801004f8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100468:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010046e:	74 70                	je     801004e0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100470:	0f b6 db             	movzbl %bl,%ebx
80100473:	8d 70 01             	lea    0x1(%eax),%esi
80100476:	80 cf 07             	or     $0x7,%bh
80100479:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
80100480:	80 
  if(pos < 0 || pos > 25*80)
80100481:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100487:	0f 8f f9 00 00 00    	jg     80100586 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010048d:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100493:	0f 8f a7 00 00 00    	jg     80100540 <consputc.part.0+0x130>
80100499:	89 f0                	mov    %esi,%eax
8010049b:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
801004a2:	88 45 e7             	mov    %al,-0x19(%ebp)
801004a5:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004a8:	bb d4 03 00 00       	mov    $0x3d4,%ebx
801004ad:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004ba:	89 f8                	mov    %edi,%eax
801004bc:	89 ca                	mov    %ecx,%edx
801004be:	ee                   	out    %al,(%dx)
801004bf:	b8 0f 00 00 00       	mov    $0xf,%eax
801004c4:	89 da                	mov    %ebx,%edx
801004c6:	ee                   	out    %al,(%dx)
801004c7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004cb:	89 ca                	mov    %ecx,%edx
801004cd:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004ce:	b8 20 07 00 00       	mov    $0x720,%eax
801004d3:	66 89 06             	mov    %ax,(%esi)
}
801004d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004d9:	5b                   	pop    %ebx
801004da:	5e                   	pop    %esi
801004db:	5f                   	pop    %edi
801004dc:	5d                   	pop    %ebp
801004dd:	c3                   	ret    
801004de:	66 90                	xchg   %ax,%ax
    if(pos > 0) --pos;
801004e0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004e3:	85 c0                	test   %eax,%eax
801004e5:	75 9a                	jne    80100481 <consputc.part.0+0x71>
801004e7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004eb:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004f0:	31 ff                	xor    %edi,%edi
801004f2:	eb b4                	jmp    801004a8 <consputc.part.0+0x98>
801004f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004f8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004fd:	f7 e2                	mul    %edx
801004ff:	c1 ea 06             	shr    $0x6,%edx
80100502:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100505:	c1 e0 04             	shl    $0x4,%eax
80100508:	8d 70 50             	lea    0x50(%eax),%esi
8010050b:	e9 71 ff ff ff       	jmp    80100481 <consputc.part.0+0x71>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100510:	83 ec 0c             	sub    $0xc,%esp
80100513:	6a 08                	push   $0x8
80100515:	e8 c6 5a 00 00       	call   80105fe0 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 ba 5a 00 00       	call   80105fe0 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 ae 5a 00 00       	call   80105fe0 <uartputc>
80100532:	83 c4 10             	add    $0x10,%esp
80100535:	e9 f8 fe ff ff       	jmp    80100432 <consputc.part.0+0x22>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
8010054d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100552:	68 60 0e 00 00       	push   $0xe60
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 0a 42 00 00       	call   80104770 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 55 41 00 00       	call   801046d0 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 65 74 10 80       	push   $0x80107465
8010058e:	e8 fd fd ff ff       	call   80100390 <panic>
80100593:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010059a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801005a0 <printint>:
{
801005a0:	55                   	push   %ebp
801005a1:	89 e5                	mov    %esp,%ebp
801005a3:	57                   	push   %edi
801005a4:	56                   	push   %esi
801005a5:	53                   	push   %ebx
801005a6:	83 ec 2c             	sub    $0x2c,%esp
801005a9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
801005ac:	85 c9                	test   %ecx,%ecx
801005ae:	74 04                	je     801005b4 <printint+0x14>
801005b0:	85 c0                	test   %eax,%eax
801005b2:	78 6d                	js     80100621 <printint+0x81>
    x = xx;
801005b4:	89 c1                	mov    %eax,%ecx
801005b6:	31 f6                	xor    %esi,%esi
  i = 0;
801005b8:	89 75 cc             	mov    %esi,-0x34(%ebp)
801005bb:	31 db                	xor    %ebx,%ebx
801005bd:	8d 7d d7             	lea    -0x29(%ebp),%edi
    buf[i++] = digits[x % base];
801005c0:	89 c8                	mov    %ecx,%eax
801005c2:	31 d2                	xor    %edx,%edx
801005c4:	89 ce                	mov    %ecx,%esi
801005c6:	f7 75 d4             	divl   -0x2c(%ebp)
801005c9:	0f b6 92 90 74 10 80 	movzbl -0x7fef8b70(%edx),%edx
801005d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
801005d3:	89 d8                	mov    %ebx,%eax
801005d5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
801005d8:	8b 4d d0             	mov    -0x30(%ebp),%ecx
801005db:	89 75 d0             	mov    %esi,-0x30(%ebp)
    buf[i++] = digits[x % base];
801005de:	88 14 1f             	mov    %dl,(%edi,%ebx,1)
  }while((x /= base) != 0);
801005e1:	8b 75 d4             	mov    -0x2c(%ebp),%esi
801005e4:	39 75 d0             	cmp    %esi,-0x30(%ebp)
801005e7:	73 d7                	jae    801005c0 <printint+0x20>
801005e9:	8b 75 cc             	mov    -0x34(%ebp),%esi
  if(sign)
801005ec:	85 f6                	test   %esi,%esi
801005ee:	74 0c                	je     801005fc <printint+0x5c>
    buf[i++] = '-';
801005f0:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
801005f5:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
801005f7:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
801005fc:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
80100600:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100603:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
80100609:	85 d2                	test   %edx,%edx
8010060b:	74 03                	je     80100610 <printint+0x70>
  asm volatile("cli");
8010060d:	fa                   	cli    
    for(;;)
8010060e:	eb fe                	jmp    8010060e <printint+0x6e>
80100610:	e8 fb fd ff ff       	call   80100410 <consputc.part.0>
  while(--i >= 0)
80100615:	39 fb                	cmp    %edi,%ebx
80100617:	74 10                	je     80100629 <printint+0x89>
80100619:	0f be 03             	movsbl (%ebx),%eax
8010061c:	83 eb 01             	sub    $0x1,%ebx
8010061f:	eb e2                	jmp    80100603 <printint+0x63>
    x = -xx;
80100621:	f7 d8                	neg    %eax
80100623:	89 ce                	mov    %ecx,%esi
80100625:	89 c1                	mov    %eax,%ecx
80100627:	eb 8f                	jmp    801005b8 <printint+0x18>
}
80100629:	83 c4 2c             	add    $0x2c,%esp
8010062c:	5b                   	pop    %ebx
8010062d:	5e                   	pop    %esi
8010062e:	5f                   	pop    %edi
8010062f:	5d                   	pop    %ebp
80100630:	c3                   	ret    
80100631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100638:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010063f:	90                   	nop

80100640 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100640:	f3 0f 1e fb          	endbr32 
80100644:	55                   	push   %ebp
80100645:	89 e5                	mov    %esp,%ebp
80100647:	57                   	push   %edi
80100648:	56                   	push   %esi
80100649:	53                   	push   %ebx
8010064a:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
8010064d:	ff 75 08             	pushl  0x8(%ebp)
{
80100650:	8b 5d 10             	mov    0x10(%ebp),%ebx
  iunlock(ip);
80100653:	e8 f8 11 00 00       	call   80101850 <iunlock>
  acquire(&cons.lock);
80100658:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010065f:	e8 5c 3f 00 00       	call   801045c0 <acquire>
  for(i = 0; i < n; i++)
80100664:	83 c4 10             	add    $0x10,%esp
80100667:	85 db                	test   %ebx,%ebx
80100669:	7e 24                	jle    8010068f <consolewrite+0x4f>
8010066b:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010066e:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
  if(panicked){
80100671:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
80100677:	85 d2                	test   %edx,%edx
80100679:	74 05                	je     80100680 <consolewrite+0x40>
8010067b:	fa                   	cli    
    for(;;)
8010067c:	eb fe                	jmp    8010067c <consolewrite+0x3c>
8010067e:	66 90                	xchg   %ax,%ax
    consputc(buf[i] & 0xff);
80100680:	0f b6 07             	movzbl (%edi),%eax
80100683:	83 c7 01             	add    $0x1,%edi
80100686:	e8 85 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; i < n; i++)
8010068b:	39 fe                	cmp    %edi,%esi
8010068d:	75 e2                	jne    80100671 <consolewrite+0x31>
  release(&cons.lock);
8010068f:	83 ec 0c             	sub    $0xc,%esp
80100692:	68 20 a5 10 80       	push   $0x8010a520
80100697:	e8 e4 3f 00 00       	call   80104680 <release>
  ilock(ip);
8010069c:	58                   	pop    %eax
8010069d:	ff 75 08             	pushl  0x8(%ebp)
801006a0:	e8 cb 10 00 00       	call   80101770 <ilock>

  return n;
}
801006a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801006a8:	89 d8                	mov    %ebx,%eax
801006aa:	5b                   	pop    %ebx
801006ab:	5e                   	pop    %esi
801006ac:	5f                   	pop    %edi
801006ad:	5d                   	pop    %ebp
801006ae:	c3                   	ret    
801006af:	90                   	nop

801006b0 <cprintf>:
{
801006b0:	f3 0f 1e fb          	endbr32 
801006b4:	55                   	push   %ebp
801006b5:	89 e5                	mov    %esp,%ebp
801006b7:	57                   	push   %edi
801006b8:	56                   	push   %esi
801006b9:	53                   	push   %ebx
801006ba:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006bd:	a1 54 a5 10 80       	mov    0x8010a554,%eax
801006c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
801006c5:	85 c0                	test   %eax,%eax
801006c7:	0f 85 e8 00 00 00    	jne    801007b5 <cprintf+0x105>
  if (fmt == 0)
801006cd:	8b 45 08             	mov    0x8(%ebp),%eax
801006d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d3:	85 c0                	test   %eax,%eax
801006d5:	0f 84 5a 01 00 00    	je     80100835 <cprintf+0x185>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006db:	0f b6 00             	movzbl (%eax),%eax
801006de:	85 c0                	test   %eax,%eax
801006e0:	74 36                	je     80100718 <cprintf+0x68>
  argp = (uint*)(void*)(&fmt + 1);
801006e2:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e5:	31 f6                	xor    %esi,%esi
    if(c != '%'){
801006e7:	83 f8 25             	cmp    $0x25,%eax
801006ea:	74 44                	je     80100730 <cprintf+0x80>
  if(panicked){
801006ec:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
801006f2:	85 c9                	test   %ecx,%ecx
801006f4:	74 0f                	je     80100705 <cprintf+0x55>
801006f6:	fa                   	cli    
    for(;;)
801006f7:	eb fe                	jmp    801006f7 <cprintf+0x47>
801006f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100700:	b8 25 00 00 00       	mov    $0x25,%eax
80100705:	e8 06 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010070a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010070d:	83 c6 01             	add    $0x1,%esi
80100710:	0f b6 04 30          	movzbl (%eax,%esi,1),%eax
80100714:	85 c0                	test   %eax,%eax
80100716:	75 cf                	jne    801006e7 <cprintf+0x37>
  if(locking)
80100718:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010071b:	85 c0                	test   %eax,%eax
8010071d:	0f 85 fd 00 00 00    	jne    80100820 <cprintf+0x170>
}
80100723:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100726:	5b                   	pop    %ebx
80100727:	5e                   	pop    %esi
80100728:	5f                   	pop    %edi
80100729:	5d                   	pop    %ebp
8010072a:	c3                   	ret    
8010072b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010072f:	90                   	nop
    c = fmt[++i] & 0xff;
80100730:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100733:	83 c6 01             	add    $0x1,%esi
80100736:	0f b6 3c 30          	movzbl (%eax,%esi,1),%edi
    if(c == 0)
8010073a:	85 ff                	test   %edi,%edi
8010073c:	74 da                	je     80100718 <cprintf+0x68>
    switch(c){
8010073e:	83 ff 70             	cmp    $0x70,%edi
80100741:	74 5a                	je     8010079d <cprintf+0xed>
80100743:	7f 2a                	jg     8010076f <cprintf+0xbf>
80100745:	83 ff 25             	cmp    $0x25,%edi
80100748:	0f 84 92 00 00 00    	je     801007e0 <cprintf+0x130>
8010074e:	83 ff 64             	cmp    $0x64,%edi
80100751:	0f 85 a1 00 00 00    	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 10, 1);
80100757:	8b 03                	mov    (%ebx),%eax
80100759:	8d 7b 04             	lea    0x4(%ebx),%edi
8010075c:	b9 01 00 00 00       	mov    $0x1,%ecx
80100761:	ba 0a 00 00 00       	mov    $0xa,%edx
80100766:	89 fb                	mov    %edi,%ebx
80100768:	e8 33 fe ff ff       	call   801005a0 <printint>
      break;
8010076d:	eb 9b                	jmp    8010070a <cprintf+0x5a>
    switch(c){
8010076f:	83 ff 73             	cmp    $0x73,%edi
80100772:	75 24                	jne    80100798 <cprintf+0xe8>
      if((s = (char*)*argp++) == 0)
80100774:	8d 7b 04             	lea    0x4(%ebx),%edi
80100777:	8b 1b                	mov    (%ebx),%ebx
80100779:	85 db                	test   %ebx,%ebx
8010077b:	75 55                	jne    801007d2 <cprintf+0x122>
        s = "(null)";
8010077d:	bb 78 74 10 80       	mov    $0x80107478,%ebx
      for(; *s; s++)
80100782:	b8 28 00 00 00       	mov    $0x28,%eax
  if(panicked){
80100787:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
8010078d:	85 d2                	test   %edx,%edx
8010078f:	74 39                	je     801007ca <cprintf+0x11a>
80100791:	fa                   	cli    
    for(;;)
80100792:	eb fe                	jmp    80100792 <cprintf+0xe2>
80100794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100798:	83 ff 78             	cmp    $0x78,%edi
8010079b:	75 5b                	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 16, 0);
8010079d:	8b 03                	mov    (%ebx),%eax
8010079f:	8d 7b 04             	lea    0x4(%ebx),%edi
801007a2:	31 c9                	xor    %ecx,%ecx
801007a4:	ba 10 00 00 00       	mov    $0x10,%edx
801007a9:	89 fb                	mov    %edi,%ebx
801007ab:	e8 f0 fd ff ff       	call   801005a0 <printint>
      break;
801007b0:	e9 55 ff ff ff       	jmp    8010070a <cprintf+0x5a>
    acquire(&cons.lock);
801007b5:	83 ec 0c             	sub    $0xc,%esp
801007b8:	68 20 a5 10 80       	push   $0x8010a520
801007bd:	e8 fe 3d 00 00       	call   801045c0 <acquire>
801007c2:	83 c4 10             	add    $0x10,%esp
801007c5:	e9 03 ff ff ff       	jmp    801006cd <cprintf+0x1d>
801007ca:	e8 41 fc ff ff       	call   80100410 <consputc.part.0>
      for(; *s; s++)
801007cf:	83 c3 01             	add    $0x1,%ebx
801007d2:	0f be 03             	movsbl (%ebx),%eax
801007d5:	84 c0                	test   %al,%al
801007d7:	75 ae                	jne    80100787 <cprintf+0xd7>
      if((s = (char*)*argp++) == 0)
801007d9:	89 fb                	mov    %edi,%ebx
801007db:	e9 2a ff ff ff       	jmp    8010070a <cprintf+0x5a>
  if(panicked){
801007e0:	8b 3d 58 a5 10 80    	mov    0x8010a558,%edi
801007e6:	85 ff                	test   %edi,%edi
801007e8:	0f 84 12 ff ff ff    	je     80100700 <cprintf+0x50>
801007ee:	fa                   	cli    
    for(;;)
801007ef:	eb fe                	jmp    801007ef <cprintf+0x13f>
801007f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
801007f8:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
801007fe:	85 c9                	test   %ecx,%ecx
80100800:	74 06                	je     80100808 <cprintf+0x158>
80100802:	fa                   	cli    
    for(;;)
80100803:	eb fe                	jmp    80100803 <cprintf+0x153>
80100805:	8d 76 00             	lea    0x0(%esi),%esi
80100808:	b8 25 00 00 00       	mov    $0x25,%eax
8010080d:	e8 fe fb ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
80100812:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
80100818:	85 d2                	test   %edx,%edx
8010081a:	74 2c                	je     80100848 <cprintf+0x198>
8010081c:	fa                   	cli    
    for(;;)
8010081d:	eb fe                	jmp    8010081d <cprintf+0x16d>
8010081f:	90                   	nop
    release(&cons.lock);
80100820:	83 ec 0c             	sub    $0xc,%esp
80100823:	68 20 a5 10 80       	push   $0x8010a520
80100828:	e8 53 3e 00 00       	call   80104680 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 7f 74 10 80       	push   $0x8010747f
8010083d:	e8 4e fb ff ff       	call   80100390 <panic>
80100842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100848:	89 f8                	mov    %edi,%eax
8010084a:	e8 c1 fb ff ff       	call   80100410 <consputc.part.0>
8010084f:	e9 b6 fe ff ff       	jmp    8010070a <cprintf+0x5a>
80100854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010085b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010085f:	90                   	nop

80100860 <consoleintr>:
{
80100860:	f3 0f 1e fb          	endbr32 
80100864:	55                   	push   %ebp
80100865:	89 e5                	mov    %esp,%ebp
80100867:	57                   	push   %edi
80100868:	56                   	push   %esi
  int c, doprocdump = 0;
80100869:	31 f6                	xor    %esi,%esi
{
8010086b:	53                   	push   %ebx
8010086c:	83 ec 18             	sub    $0x18,%esp
8010086f:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
80100872:	68 20 a5 10 80       	push   $0x8010a520
80100877:	e8 44 3d 00 00       	call   801045c0 <acquire>
  while((c = getc()) >= 0){
8010087c:	83 c4 10             	add    $0x10,%esp
8010087f:	eb 17                	jmp    80100898 <consoleintr+0x38>
    switch(c){
80100881:	83 fb 08             	cmp    $0x8,%ebx
80100884:	0f 84 f6 00 00 00    	je     80100980 <consoleintr+0x120>
8010088a:	83 fb 10             	cmp    $0x10,%ebx
8010088d:	0f 85 15 01 00 00    	jne    801009a8 <consoleintr+0x148>
80100893:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
80100898:	ff d7                	call   *%edi
8010089a:	89 c3                	mov    %eax,%ebx
8010089c:	85 c0                	test   %eax,%eax
8010089e:	0f 88 23 01 00 00    	js     801009c7 <consoleintr+0x167>
    switch(c){
801008a4:	83 fb 15             	cmp    $0x15,%ebx
801008a7:	74 77                	je     80100920 <consoleintr+0xc0>
801008a9:	7e d6                	jle    80100881 <consoleintr+0x21>
801008ab:	83 fb 7f             	cmp    $0x7f,%ebx
801008ae:	0f 84 cc 00 00 00    	je     80100980 <consoleintr+0x120>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008b4:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008b9:	89 c2                	mov    %eax,%edx
801008bb:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
801008c1:	83 fa 7f             	cmp    $0x7f,%edx
801008c4:	77 d2                	ja     80100898 <consoleintr+0x38>
        c = (c == '\r') ? '\n' : c;
801008c6:	8d 48 01             	lea    0x1(%eax),%ecx
801008c9:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801008cf:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
801008d2:	89 0d a8 ff 10 80    	mov    %ecx,0x8010ffa8
        c = (c == '\r') ? '\n' : c;
801008d8:	83 fb 0d             	cmp    $0xd,%ebx
801008db:	0f 84 02 01 00 00    	je     801009e3 <consoleintr+0x183>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e1:	88 98 20 ff 10 80    	mov    %bl,-0x7fef00e0(%eax)
  if(panicked){
801008e7:	85 d2                	test   %edx,%edx
801008e9:	0f 85 ff 00 00 00    	jne    801009ee <consoleintr+0x18e>
801008ef:	89 d8                	mov    %ebx,%eax
801008f1:	e8 1a fb ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008f6:	83 fb 0a             	cmp    $0xa,%ebx
801008f9:	0f 84 0f 01 00 00    	je     80100a0e <consoleintr+0x1ae>
801008ff:	83 fb 04             	cmp    $0x4,%ebx
80100902:	0f 84 06 01 00 00    	je     80100a0e <consoleintr+0x1ae>
80100908:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
8010090d:	83 e8 80             	sub    $0xffffff80,%eax
80100910:	39 05 a8 ff 10 80    	cmp    %eax,0x8010ffa8
80100916:	75 80                	jne    80100898 <consoleintr+0x38>
80100918:	e9 f6 00 00 00       	jmp    80100a13 <consoleintr+0x1b3>
8010091d:	8d 76 00             	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100920:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100925:	39 05 a4 ff 10 80    	cmp    %eax,0x8010ffa4
8010092b:	0f 84 67 ff ff ff    	je     80100898 <consoleintr+0x38>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100931:	83 e8 01             	sub    $0x1,%eax
80100934:	89 c2                	mov    %eax,%edx
80100936:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100939:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
80100940:	0f 84 52 ff ff ff    	je     80100898 <consoleintr+0x38>
  if(panicked){
80100946:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
        input.e--;
8010094c:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
  if(panicked){
80100951:	85 d2                	test   %edx,%edx
80100953:	74 0b                	je     80100960 <consoleintr+0x100>
80100955:	fa                   	cli    
    for(;;)
80100956:	eb fe                	jmp    80100956 <consoleintr+0xf6>
80100958:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010095f:	90                   	nop
80100960:	b8 00 01 00 00       	mov    $0x100,%eax
80100965:	e8 a6 fa ff ff       	call   80100410 <consputc.part.0>
      while(input.e != input.w &&
8010096a:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010096f:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
80100975:	75 ba                	jne    80100931 <consoleintr+0xd1>
80100977:	e9 1c ff ff ff       	jmp    80100898 <consoleintr+0x38>
8010097c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(input.e != input.w){
80100980:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100985:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010098b:	0f 84 07 ff ff ff    	je     80100898 <consoleintr+0x38>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
  if(panicked){
80100999:	a1 58 a5 10 80       	mov    0x8010a558,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 16                	je     801009b8 <consoleintr+0x158>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x143>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009a8:	85 db                	test   %ebx,%ebx
801009aa:	0f 84 e8 fe ff ff    	je     80100898 <consoleintr+0x38>
801009b0:	e9 ff fe ff ff       	jmp    801008b4 <consoleintr+0x54>
801009b5:	8d 76 00             	lea    0x0(%esi),%esi
801009b8:	b8 00 01 00 00       	mov    $0x100,%eax
801009bd:	e8 4e fa ff ff       	call   80100410 <consputc.part.0>
801009c2:	e9 d1 fe ff ff       	jmp    80100898 <consoleintr+0x38>
  release(&cons.lock);
801009c7:	83 ec 0c             	sub    $0xc,%esp
801009ca:	68 20 a5 10 80       	push   $0x8010a520
801009cf:	e8 ac 3c 00 00       	call   80104680 <release>
  if(doprocdump) {
801009d4:	83 c4 10             	add    $0x10,%esp
801009d7:	85 f6                	test   %esi,%esi
801009d9:	75 1d                	jne    801009f8 <consoleintr+0x198>
}
801009db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009de:	5b                   	pop    %ebx
801009df:	5e                   	pop    %esi
801009e0:	5f                   	pop    %edi
801009e1:	5d                   	pop    %ebp
801009e2:	c3                   	ret    
        input.buf[input.e++ % INPUT_BUF] = c;
801009e3:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
  if(panicked){
801009ea:	85 d2                	test   %edx,%edx
801009ec:	74 16                	je     80100a04 <consoleintr+0x1a4>
801009ee:	fa                   	cli    
    for(;;)
801009ef:	eb fe                	jmp    801009ef <consoleintr+0x18f>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
801009f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009fb:	5b                   	pop    %ebx
801009fc:	5e                   	pop    %esi
801009fd:	5f                   	pop    %edi
801009fe:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
801009ff:	e9 2c 38 00 00       	jmp    80104230 <procdump>
80100a04:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a09:	e8 02 fa ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100a0e:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
          wakeup(&input.r);
80100a13:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a16:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
80100a1b:	68 a0 ff 10 80       	push   $0x8010ffa0
80100a20:	e8 1b 37 00 00       	call   80104140 <wakeup>
80100a25:	83 c4 10             	add    $0x10,%esp
80100a28:	e9 6b fe ff ff       	jmp    80100898 <consoleintr+0x38>
80100a2d:	8d 76 00             	lea    0x0(%esi),%esi

80100a30 <consoleinit>:

void
consoleinit(void)
{
80100a30:	f3 0f 1e fb          	endbr32 
80100a34:	55                   	push   %ebp
80100a35:	89 e5                	mov    %esp,%ebp
80100a37:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a3a:	68 88 74 10 80       	push   $0x80107488
80100a3f:	68 20 a5 10 80       	push   $0x8010a520
80100a44:	e8 f7 39 00 00       	call   80104440 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a49:	58                   	pop    %eax
80100a4a:	5a                   	pop    %edx
80100a4b:	6a 00                	push   $0x0
80100a4d:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a4f:	c7 05 6c 09 11 80 40 	movl   $0x80100640,0x8011096c
80100a56:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100a59:	c7 05 68 09 11 80 90 	movl   $0x80100290,0x80110968
80100a60:	02 10 80 
  cons.locking = 1;
80100a63:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
80100a6a:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a6d:	e8 ce 19 00 00       	call   80102440 <ioapicenable>
}
80100a72:	83 c4 10             	add    $0x10,%esp
80100a75:	c9                   	leave  
80100a76:	c3                   	ret    
80100a77:	66 90                	xchg   %ax,%ax
80100a79:	66 90                	xchg   %ax,%ax
80100a7b:	66 90                	xchg   %ax,%ax
80100a7d:	66 90                	xchg   %ax,%ax
80100a7f:	90                   	nop

80100a80 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a80:	f3 0f 1e fb          	endbr32 
80100a84:	55                   	push   %ebp
80100a85:	89 e5                	mov    %esp,%ebp
80100a87:	57                   	push   %edi
80100a88:	56                   	push   %esi
80100a89:	53                   	push   %ebx
80100a8a:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a90:	e8 eb 2e 00 00       	call   80103980 <myproc>
80100a95:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100a9b:	e8 a0 22 00 00       	call   80102d40 <begin_op>

  if((ip = namei(path)) == 0){
80100aa0:	83 ec 0c             	sub    $0xc,%esp
80100aa3:	ff 75 08             	pushl  0x8(%ebp)
80100aa6:	e8 95 15 00 00       	call   80102040 <namei>
80100aab:	83 c4 10             	add    $0x10,%esp
80100aae:	85 c0                	test   %eax,%eax
80100ab0:	0f 84 0e 03 00 00    	je     80100dc4 <exec+0x344>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ab6:	83 ec 0c             	sub    $0xc,%esp
80100ab9:	89 c3                	mov    %eax,%ebx
80100abb:	50                   	push   %eax
80100abc:	e8 af 0c 00 00       	call   80101770 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100ac1:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100ac7:	6a 34                	push   $0x34
80100ac9:	6a 00                	push   $0x0
80100acb:	50                   	push   %eax
80100acc:	53                   	push   %ebx
80100acd:	e8 9e 0f 00 00       	call   80101a70 <readi>
80100ad2:	83 c4 20             	add    $0x20,%esp
80100ad5:	83 f8 34             	cmp    $0x34,%eax
80100ad8:	74 26                	je     80100b00 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100ada:	83 ec 0c             	sub    $0xc,%esp
80100add:	53                   	push   %ebx
80100ade:	e8 2d 0f 00 00       	call   80101a10 <iunlockput>
    end_op();
80100ae3:	e8 c8 22 00 00       	call   80102db0 <end_op>
80100ae8:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100aeb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100af0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100af3:	5b                   	pop    %ebx
80100af4:	5e                   	pop    %esi
80100af5:	5f                   	pop    %edi
80100af6:	5d                   	pop    %ebp
80100af7:	c3                   	ret    
80100af8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100aff:	90                   	nop
  if(elf.magic != ELF_MAGIC)
80100b00:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b07:	45 4c 46 
80100b0a:	75 ce                	jne    80100ada <exec+0x5a>
  if((pgdir = setupkvm()) == 0)
80100b0c:	e8 5f 66 00 00       	call   80107170 <setupkvm>
80100b11:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b17:	85 c0                	test   %eax,%eax
80100b19:	74 bf                	je     80100ada <exec+0x5a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b1b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b22:	00 
80100b23:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b29:	0f 84 b4 02 00 00    	je     80100de3 <exec+0x363>
  sz = 0;
80100b2f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b36:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b39:	31 ff                	xor    %edi,%edi
80100b3b:	e9 99 00 00 00       	jmp    80100bd9 <exec+0x159>
    if(ph.type != ELF_PROG_LOAD)
80100b40:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b47:	75 7f                	jne    80100bc8 <exec+0x148>
    if(ph.memsz < ph.filesz)
80100b49:	8b 95 18 ff ff ff    	mov    -0xe8(%ebp),%edx
80100b4f:	8b 85 14 ff ff ff    	mov    -0xec(%ebp),%eax
80100b55:	39 c2                	cmp    %eax,%edx
80100b57:	0f 82 98 00 00 00    	jb     80100bf5 <exec+0x175>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b5d:	8b 8d 0c ff ff ff    	mov    -0xf4(%ebp),%ecx
80100b63:	01 ca                	add    %ecx,%edx
80100b65:	0f 82 8a 00 00 00    	jb     80100bf5 <exec+0x175>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.filesz)) == 0)
80100b6b:	83 ec 04             	sub    $0x4,%esp
80100b6e:	01 c8                	add    %ecx,%eax
80100b70:	50                   	push   %eax
80100b71:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b77:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b7d:	e8 fe 63 00 00       	call   80106f80 <allocuvm>
80100b82:	83 c4 10             	add    $0x10,%esp
80100b85:	85 c0                	test   %eax,%eax
80100b87:	74 6c                	je     80100bf5 <exec+0x175>
    sz+=ph.memsz-ph.filesz;
80100b89:	8b 95 14 ff ff ff    	mov    -0xec(%ebp),%edx
80100b8f:	03 85 18 ff ff ff    	add    -0xe8(%ebp),%eax
80100b95:	29 d0                	sub    %edx,%eax
80100b97:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
    if(ph.vaddr % PGSIZE != 0)
80100b9d:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100ba3:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100ba8:	75 4b                	jne    80100bf5 <exec+0x175>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100baa:	83 ec 0c             	sub    $0xc,%esp
80100bad:	52                   	push   %edx
80100bae:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100bb4:	53                   	push   %ebx
80100bb5:	50                   	push   %eax
80100bb6:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100bbc:	e8 ef 62 00 00       	call   80106eb0 <loaduvm>
80100bc1:	83 c4 20             	add    $0x20,%esp
80100bc4:	85 c0                	test   %eax,%eax
80100bc6:	78 2d                	js     80100bf5 <exec+0x175>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bc8:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bcf:	83 c7 01             	add    $0x1,%edi
80100bd2:	83 c6 20             	add    $0x20,%esi
80100bd5:	39 f8                	cmp    %edi,%eax
80100bd7:	7e 37                	jle    80100c10 <exec+0x190>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bd9:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bdf:	6a 20                	push   $0x20
80100be1:	56                   	push   %esi
80100be2:	50                   	push   %eax
80100be3:	53                   	push   %ebx
80100be4:	e8 87 0e 00 00       	call   80101a70 <readi>
80100be9:	83 c4 10             	add    $0x10,%esp
80100bec:	83 f8 20             	cmp    $0x20,%eax
80100bef:	0f 84 4b ff ff ff    	je     80100b40 <exec+0xc0>
    freevm(pgdir);
80100bf5:	83 ec 0c             	sub    $0xc,%esp
80100bf8:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100bfe:	e8 ed 64 00 00       	call   801070f0 <freevm>
  if(ip){
80100c03:	83 c4 10             	add    $0x10,%esp
80100c06:	e9 cf fe ff ff       	jmp    80100ada <exec+0x5a>
80100c0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100c0f:	90                   	nop
80100c10:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c16:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c1c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100c22:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c28:	83 ec 0c             	sub    $0xc,%esp
80100c2b:	53                   	push   %ebx
80100c2c:	e8 df 0d 00 00       	call   80101a10 <iunlockput>
  end_op();
80100c31:	e8 7a 21 00 00       	call   80102db0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c36:	83 c4 0c             	add    $0xc,%esp
80100c39:	56                   	push   %esi
80100c3a:	57                   	push   %edi
80100c3b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c41:	57                   	push   %edi
80100c42:	e8 39 63 00 00       	call   80106f80 <allocuvm>
80100c47:	83 c4 10             	add    $0x10,%esp
80100c4a:	89 c6                	mov    %eax,%esi
80100c4c:	85 c0                	test   %eax,%eax
80100c4e:	0f 84 94 00 00 00    	je     80100ce8 <exec+0x268>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c54:	83 ec 08             	sub    $0x8,%esp
80100c57:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c5d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c5f:	50                   	push   %eax
80100c60:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c61:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c63:	e8 a8 65 00 00       	call   80107210 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c68:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c6b:	83 c4 10             	add    $0x10,%esp
80100c6e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c74:	8b 00                	mov    (%eax),%eax
80100c76:	85 c0                	test   %eax,%eax
80100c78:	0f 84 8b 00 00 00    	je     80100d09 <exec+0x289>
80100c7e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100c84:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c8a:	eb 23                	jmp    80100caf <exec+0x22f>
80100c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100c90:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c93:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c9a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c9d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100ca3:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100ca6:	85 c0                	test   %eax,%eax
80100ca8:	74 59                	je     80100d03 <exec+0x283>
    if(argc >= MAXARG)
80100caa:	83 ff 20             	cmp    $0x20,%edi
80100cad:	74 39                	je     80100ce8 <exec+0x268>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100caf:	83 ec 0c             	sub    $0xc,%esp
80100cb2:	50                   	push   %eax
80100cb3:	e8 18 3c 00 00       	call   801048d0 <strlen>
80100cb8:	f7 d0                	not    %eax
80100cba:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cbc:	58                   	pop    %eax
80100cbd:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cc0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cc3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cc6:	e8 05 3c 00 00       	call   801048d0 <strlen>
80100ccb:	83 c0 01             	add    $0x1,%eax
80100cce:	50                   	push   %eax
80100ccf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cd2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cd5:	53                   	push   %ebx
80100cd6:	56                   	push   %esi
80100cd7:	e8 a4 66 00 00       	call   80107380 <copyout>
80100cdc:	83 c4 20             	add    $0x20,%esp
80100cdf:	85 c0                	test   %eax,%eax
80100ce1:	79 ad                	jns    80100c90 <exec+0x210>
80100ce3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100ce7:	90                   	nop
    freevm(pgdir);
80100ce8:	83 ec 0c             	sub    $0xc,%esp
80100ceb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100cf1:	e8 fa 63 00 00       	call   801070f0 <freevm>
80100cf6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100cf9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100cfe:	e9 ed fd ff ff       	jmp    80100af0 <exec+0x70>
80100d03:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d09:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d10:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d12:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d19:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d1d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d1f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d22:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d28:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d2a:	50                   	push   %eax
80100d2b:	52                   	push   %edx
80100d2c:	53                   	push   %ebx
80100d2d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d33:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d3a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d3d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d43:	e8 38 66 00 00       	call   80107380 <copyout>
80100d48:	83 c4 10             	add    $0x10,%esp
80100d4b:	85 c0                	test   %eax,%eax
80100d4d:	78 99                	js     80100ce8 <exec+0x268>
  for(last=s=path; *s; s++)
80100d4f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d52:	8b 55 08             	mov    0x8(%ebp),%edx
80100d55:	0f b6 00             	movzbl (%eax),%eax
80100d58:	84 c0                	test   %al,%al
80100d5a:	74 13                	je     80100d6f <exec+0x2ef>
80100d5c:	89 d1                	mov    %edx,%ecx
80100d5e:	66 90                	xchg   %ax,%ax
    if(*s == '/')
80100d60:	83 c1 01             	add    $0x1,%ecx
80100d63:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d65:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
80100d68:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d6b:	84 c0                	test   %al,%al
80100d6d:	75 f1                	jne    80100d60 <exec+0x2e0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d6f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d75:	83 ec 04             	sub    $0x4,%esp
80100d78:	6a 10                	push   $0x10
80100d7a:	89 f8                	mov    %edi,%eax
80100d7c:	52                   	push   %edx
80100d7d:	83 c0 6c             	add    $0x6c,%eax
80100d80:	50                   	push   %eax
80100d81:	e8 0a 3b 00 00       	call   80104890 <safestrcpy>
  curproc->pgdir = pgdir;
80100d86:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100d8c:	89 f8                	mov    %edi,%eax
80100d8e:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100d91:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100d93:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100d96:	89 c1                	mov    %eax,%ecx
80100d98:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d9e:	8b 40 18             	mov    0x18(%eax),%eax
80100da1:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100da4:	8b 41 18             	mov    0x18(%ecx),%eax
80100da7:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100daa:	89 0c 24             	mov    %ecx,(%esp)
80100dad:	e8 6e 5f 00 00       	call   80106d20 <switchuvm>
  freevm(oldpgdir);
80100db2:	89 3c 24             	mov    %edi,(%esp)
80100db5:	e8 36 63 00 00       	call   801070f0 <freevm>
  return 0;
80100dba:	83 c4 10             	add    $0x10,%esp
80100dbd:	31 c0                	xor    %eax,%eax
80100dbf:	e9 2c fd ff ff       	jmp    80100af0 <exec+0x70>
    end_op();
80100dc4:	e8 e7 1f 00 00       	call   80102db0 <end_op>
    cprintf("exec: fail\n");
80100dc9:	83 ec 0c             	sub    $0xc,%esp
80100dcc:	68 a1 74 10 80       	push   $0x801074a1
80100dd1:	e8 da f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100dd6:	83 c4 10             	add    $0x10,%esp
80100dd9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dde:	e9 0d fd ff ff       	jmp    80100af0 <exec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100de3:	31 ff                	xor    %edi,%edi
80100de5:	be 00 20 00 00       	mov    $0x2000,%esi
80100dea:	e9 39 fe ff ff       	jmp    80100c28 <exec+0x1a8>
80100def:	90                   	nop

80100df0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100df0:	f3 0f 1e fb          	endbr32 
80100df4:	55                   	push   %ebp
80100df5:	89 e5                	mov    %esp,%ebp
80100df7:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100dfa:	68 ad 74 10 80       	push   $0x801074ad
80100dff:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e04:	e8 37 36 00 00       	call   80104440 <initlock>
}
80100e09:	83 c4 10             	add    $0x10,%esp
80100e0c:	c9                   	leave  
80100e0d:	c3                   	ret    
80100e0e:	66 90                	xchg   %ax,%ax

80100e10 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e10:	f3 0f 1e fb          	endbr32 
80100e14:	55                   	push   %ebp
80100e15:	89 e5                	mov    %esp,%ebp
80100e17:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e18:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
{
80100e1d:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e20:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e25:	e8 96 37 00 00       	call   801045c0 <acquire>
80100e2a:	83 c4 10             	add    $0x10,%esp
80100e2d:	eb 0c                	jmp    80100e3b <filealloc+0x2b>
80100e2f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e30:	83 c3 18             	add    $0x18,%ebx
80100e33:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100e39:	74 25                	je     80100e60 <filealloc+0x50>
    if(f->ref == 0){
80100e3b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e3e:	85 c0                	test   %eax,%eax
80100e40:	75 ee                	jne    80100e30 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e42:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e45:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e4c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e51:	e8 2a 38 00 00       	call   80104680 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e56:	89 d8                	mov    %ebx,%eax
      return f;
80100e58:	83 c4 10             	add    $0x10,%esp
}
80100e5b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e5e:	c9                   	leave  
80100e5f:	c3                   	ret    
  release(&ftable.lock);
80100e60:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e63:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e65:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e6a:	e8 11 38 00 00       	call   80104680 <release>
}
80100e6f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e71:	83 c4 10             	add    $0x10,%esp
}
80100e74:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e77:	c9                   	leave  
80100e78:	c3                   	ret    
80100e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e80 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e80:	f3 0f 1e fb          	endbr32 
80100e84:	55                   	push   %ebp
80100e85:	89 e5                	mov    %esp,%ebp
80100e87:	53                   	push   %ebx
80100e88:	83 ec 10             	sub    $0x10,%esp
80100e8b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e8e:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e93:	e8 28 37 00 00       	call   801045c0 <acquire>
  if(f->ref < 1)
80100e98:	8b 43 04             	mov    0x4(%ebx),%eax
80100e9b:	83 c4 10             	add    $0x10,%esp
80100e9e:	85 c0                	test   %eax,%eax
80100ea0:	7e 1a                	jle    80100ebc <filedup+0x3c>
    panic("filedup");
  f->ref++;
80100ea2:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ea5:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ea8:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100eab:	68 c0 ff 10 80       	push   $0x8010ffc0
80100eb0:	e8 cb 37 00 00       	call   80104680 <release>
  return f;
}
80100eb5:	89 d8                	mov    %ebx,%eax
80100eb7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eba:	c9                   	leave  
80100ebb:	c3                   	ret    
    panic("filedup");
80100ebc:	83 ec 0c             	sub    $0xc,%esp
80100ebf:	68 b4 74 10 80       	push   $0x801074b4
80100ec4:	e8 c7 f4 ff ff       	call   80100390 <panic>
80100ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ed0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ed0:	f3 0f 1e fb          	endbr32 
80100ed4:	55                   	push   %ebp
80100ed5:	89 e5                	mov    %esp,%ebp
80100ed7:	57                   	push   %edi
80100ed8:	56                   	push   %esi
80100ed9:	53                   	push   %ebx
80100eda:	83 ec 28             	sub    $0x28,%esp
80100edd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100ee0:	68 c0 ff 10 80       	push   $0x8010ffc0
80100ee5:	e8 d6 36 00 00       	call   801045c0 <acquire>
  if(f->ref < 1)
80100eea:	8b 53 04             	mov    0x4(%ebx),%edx
80100eed:	83 c4 10             	add    $0x10,%esp
80100ef0:	85 d2                	test   %edx,%edx
80100ef2:	0f 8e a1 00 00 00    	jle    80100f99 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100ef8:	83 ea 01             	sub    $0x1,%edx
80100efb:	89 53 04             	mov    %edx,0x4(%ebx)
80100efe:	75 40                	jne    80100f40 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f00:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f04:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f07:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f09:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f0f:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f12:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f15:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f18:	68 c0 ff 10 80       	push   $0x8010ffc0
  ff = *f;
80100f1d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f20:	e8 5b 37 00 00       	call   80104680 <release>

  if(ff.type == FD_PIPE)
80100f25:	83 c4 10             	add    $0x10,%esp
80100f28:	83 ff 01             	cmp    $0x1,%edi
80100f2b:	74 53                	je     80100f80 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f2d:	83 ff 02             	cmp    $0x2,%edi
80100f30:	74 26                	je     80100f58 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f32:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f35:	5b                   	pop    %ebx
80100f36:	5e                   	pop    %esi
80100f37:	5f                   	pop    %edi
80100f38:	5d                   	pop    %ebp
80100f39:	c3                   	ret    
80100f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f40:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
}
80100f47:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f4a:	5b                   	pop    %ebx
80100f4b:	5e                   	pop    %esi
80100f4c:	5f                   	pop    %edi
80100f4d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f4e:	e9 2d 37 00 00       	jmp    80104680 <release>
80100f53:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f57:	90                   	nop
    begin_op();
80100f58:	e8 e3 1d 00 00       	call   80102d40 <begin_op>
    iput(ff.ip);
80100f5d:	83 ec 0c             	sub    $0xc,%esp
80100f60:	ff 75 e0             	pushl  -0x20(%ebp)
80100f63:	e8 38 09 00 00       	call   801018a0 <iput>
    end_op();
80100f68:	83 c4 10             	add    $0x10,%esp
}
80100f6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f6e:	5b                   	pop    %ebx
80100f6f:	5e                   	pop    %esi
80100f70:	5f                   	pop    %edi
80100f71:	5d                   	pop    %ebp
    end_op();
80100f72:	e9 39 1e 00 00       	jmp    80102db0 <end_op>
80100f77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f7e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100f80:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f84:	83 ec 08             	sub    $0x8,%esp
80100f87:	53                   	push   %ebx
80100f88:	56                   	push   %esi
80100f89:	e8 82 25 00 00       	call   80103510 <pipeclose>
80100f8e:	83 c4 10             	add    $0x10,%esp
}
80100f91:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f94:	5b                   	pop    %ebx
80100f95:	5e                   	pop    %esi
80100f96:	5f                   	pop    %edi
80100f97:	5d                   	pop    %ebp
80100f98:	c3                   	ret    
    panic("fileclose");
80100f99:	83 ec 0c             	sub    $0xc,%esp
80100f9c:	68 bc 74 10 80       	push   $0x801074bc
80100fa1:	e8 ea f3 ff ff       	call   80100390 <panic>
80100fa6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fad:	8d 76 00             	lea    0x0(%esi),%esi

80100fb0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fb0:	f3 0f 1e fb          	endbr32 
80100fb4:	55                   	push   %ebp
80100fb5:	89 e5                	mov    %esp,%ebp
80100fb7:	53                   	push   %ebx
80100fb8:	83 ec 04             	sub    $0x4,%esp
80100fbb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fbe:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fc1:	75 2d                	jne    80100ff0 <filestat+0x40>
    ilock(f->ip);
80100fc3:	83 ec 0c             	sub    $0xc,%esp
80100fc6:	ff 73 10             	pushl  0x10(%ebx)
80100fc9:	e8 a2 07 00 00       	call   80101770 <ilock>
    stati(f->ip, st);
80100fce:	58                   	pop    %eax
80100fcf:	5a                   	pop    %edx
80100fd0:	ff 75 0c             	pushl  0xc(%ebp)
80100fd3:	ff 73 10             	pushl  0x10(%ebx)
80100fd6:	e8 65 0a 00 00       	call   80101a40 <stati>
    iunlock(f->ip);
80100fdb:	59                   	pop    %ecx
80100fdc:	ff 73 10             	pushl  0x10(%ebx)
80100fdf:	e8 6c 08 00 00       	call   80101850 <iunlock>
    return 0;
  }
  return -1;
}
80100fe4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80100fe7:	83 c4 10             	add    $0x10,%esp
80100fea:	31 c0                	xor    %eax,%eax
}
80100fec:	c9                   	leave  
80100fed:	c3                   	ret    
80100fee:	66 90                	xchg   %ax,%ax
80100ff0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80100ff3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100ff8:	c9                   	leave  
80100ff9:	c3                   	ret    
80100ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101000 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101000:	f3 0f 1e fb          	endbr32 
80101004:	55                   	push   %ebp
80101005:	89 e5                	mov    %esp,%ebp
80101007:	57                   	push   %edi
80101008:	56                   	push   %esi
80101009:	53                   	push   %ebx
8010100a:	83 ec 0c             	sub    $0xc,%esp
8010100d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101010:	8b 75 0c             	mov    0xc(%ebp),%esi
80101013:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101016:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
8010101a:	74 64                	je     80101080 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
8010101c:	8b 03                	mov    (%ebx),%eax
8010101e:	83 f8 01             	cmp    $0x1,%eax
80101021:	74 45                	je     80101068 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101023:	83 f8 02             	cmp    $0x2,%eax
80101026:	75 5f                	jne    80101087 <fileread+0x87>
    ilock(f->ip);
80101028:	83 ec 0c             	sub    $0xc,%esp
8010102b:	ff 73 10             	pushl  0x10(%ebx)
8010102e:	e8 3d 07 00 00       	call   80101770 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101033:	57                   	push   %edi
80101034:	ff 73 14             	pushl  0x14(%ebx)
80101037:	56                   	push   %esi
80101038:	ff 73 10             	pushl  0x10(%ebx)
8010103b:	e8 30 0a 00 00       	call   80101a70 <readi>
80101040:	83 c4 20             	add    $0x20,%esp
80101043:	89 c6                	mov    %eax,%esi
80101045:	85 c0                	test   %eax,%eax
80101047:	7e 03                	jle    8010104c <fileread+0x4c>
      f->off += r;
80101049:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
8010104c:	83 ec 0c             	sub    $0xc,%esp
8010104f:	ff 73 10             	pushl  0x10(%ebx)
80101052:	e8 f9 07 00 00       	call   80101850 <iunlock>
    return r;
80101057:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
8010105a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010105d:	89 f0                	mov    %esi,%eax
8010105f:	5b                   	pop    %ebx
80101060:	5e                   	pop    %esi
80101061:	5f                   	pop    %edi
80101062:	5d                   	pop    %ebp
80101063:	c3                   	ret    
80101064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
80101068:	8b 43 0c             	mov    0xc(%ebx),%eax
8010106b:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010106e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101071:	5b                   	pop    %ebx
80101072:	5e                   	pop    %esi
80101073:	5f                   	pop    %edi
80101074:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80101075:	e9 36 26 00 00       	jmp    801036b0 <piperead>
8010107a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101080:	be ff ff ff ff       	mov    $0xffffffff,%esi
80101085:	eb d3                	jmp    8010105a <fileread+0x5a>
  panic("fileread");
80101087:	83 ec 0c             	sub    $0xc,%esp
8010108a:	68 c6 74 10 80       	push   $0x801074c6
8010108f:	e8 fc f2 ff ff       	call   80100390 <panic>
80101094:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010109b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010109f:	90                   	nop

801010a0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010a0:	f3 0f 1e fb          	endbr32 
801010a4:	55                   	push   %ebp
801010a5:	89 e5                	mov    %esp,%ebp
801010a7:	57                   	push   %edi
801010a8:	56                   	push   %esi
801010a9:	53                   	push   %ebx
801010aa:	83 ec 1c             	sub    $0x1c,%esp
801010ad:	8b 45 0c             	mov    0xc(%ebp),%eax
801010b0:	8b 75 08             	mov    0x8(%ebp),%esi
801010b3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010b6:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010b9:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801010bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010c0:	0f 84 c1 00 00 00    	je     80101187 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
801010c6:	8b 06                	mov    (%esi),%eax
801010c8:	83 f8 01             	cmp    $0x1,%eax
801010cb:	0f 84 c3 00 00 00    	je     80101194 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010d1:	83 f8 02             	cmp    $0x2,%eax
801010d4:	0f 85 cc 00 00 00    	jne    801011a6 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010dd:	31 ff                	xor    %edi,%edi
    while(i < n){
801010df:	85 c0                	test   %eax,%eax
801010e1:	7f 34                	jg     80101117 <filewrite+0x77>
801010e3:	e9 98 00 00 00       	jmp    80101180 <filewrite+0xe0>
801010e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010ef:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010f0:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801010f3:	83 ec 0c             	sub    $0xc,%esp
801010f6:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
801010f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801010fc:	e8 4f 07 00 00       	call   80101850 <iunlock>
      end_op();
80101101:	e8 aa 1c 00 00       	call   80102db0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
80101106:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101109:	83 c4 10             	add    $0x10,%esp
8010110c:	39 c3                	cmp    %eax,%ebx
8010110e:	75 60                	jne    80101170 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
80101110:	01 df                	add    %ebx,%edi
    while(i < n){
80101112:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101115:	7e 69                	jle    80101180 <filewrite+0xe0>
      int n1 = n - i;
80101117:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010111a:	b8 00 06 00 00       	mov    $0x600,%eax
8010111f:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
80101121:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101127:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
8010112a:	e8 11 1c 00 00       	call   80102d40 <begin_op>
      ilock(f->ip);
8010112f:	83 ec 0c             	sub    $0xc,%esp
80101132:	ff 76 10             	pushl  0x10(%esi)
80101135:	e8 36 06 00 00       	call   80101770 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010113a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010113d:	53                   	push   %ebx
8010113e:	ff 76 14             	pushl  0x14(%esi)
80101141:	01 f8                	add    %edi,%eax
80101143:	50                   	push   %eax
80101144:	ff 76 10             	pushl  0x10(%esi)
80101147:	e8 24 0a 00 00       	call   80101b70 <writei>
8010114c:	83 c4 20             	add    $0x20,%esp
8010114f:	85 c0                	test   %eax,%eax
80101151:	7f 9d                	jg     801010f0 <filewrite+0x50>
      iunlock(f->ip);
80101153:	83 ec 0c             	sub    $0xc,%esp
80101156:	ff 76 10             	pushl  0x10(%esi)
80101159:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010115c:	e8 ef 06 00 00       	call   80101850 <iunlock>
      end_op();
80101161:	e8 4a 1c 00 00       	call   80102db0 <end_op>
      if(r < 0)
80101166:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101169:	83 c4 10             	add    $0x10,%esp
8010116c:	85 c0                	test   %eax,%eax
8010116e:	75 17                	jne    80101187 <filewrite+0xe7>
        panic("short filewrite");
80101170:	83 ec 0c             	sub    $0xc,%esp
80101173:	68 cf 74 10 80       	push   $0x801074cf
80101178:	e8 13 f2 ff ff       	call   80100390 <panic>
8010117d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
80101180:	89 f8                	mov    %edi,%eax
80101182:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80101185:	74 05                	je     8010118c <filewrite+0xec>
80101187:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
8010118c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010118f:	5b                   	pop    %ebx
80101190:	5e                   	pop    %esi
80101191:	5f                   	pop    %edi
80101192:	5d                   	pop    %ebp
80101193:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
80101194:	8b 46 0c             	mov    0xc(%esi),%eax
80101197:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010119a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010119d:	5b                   	pop    %ebx
8010119e:	5e                   	pop    %esi
8010119f:	5f                   	pop    %edi
801011a0:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011a1:	e9 0a 24 00 00       	jmp    801035b0 <pipewrite>
  panic("filewrite");
801011a6:	83 ec 0c             	sub    $0xc,%esp
801011a9:	68 d5 74 10 80       	push   $0x801074d5
801011ae:	e8 dd f1 ff ff       	call   80100390 <panic>
801011b3:	66 90                	xchg   %ax,%ax
801011b5:	66 90                	xchg   %ax,%ax
801011b7:	66 90                	xchg   %ax,%ax
801011b9:	66 90                	xchg   %ax,%ax
801011bb:	66 90                	xchg   %ax,%ax
801011bd:	66 90                	xchg   %ax,%ax
801011bf:	90                   	nop

801011c0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011c0:	55                   	push   %ebp
801011c1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011c3:	89 d0                	mov    %edx,%eax
801011c5:	c1 e8 0c             	shr    $0xc,%eax
801011c8:	03 05 d8 09 11 80    	add    0x801109d8,%eax
{
801011ce:	89 e5                	mov    %esp,%ebp
801011d0:	56                   	push   %esi
801011d1:	53                   	push   %ebx
801011d2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801011d4:	83 ec 08             	sub    $0x8,%esp
801011d7:	50                   	push   %eax
801011d8:	51                   	push   %ecx
801011d9:	e8 f2 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011de:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801011e0:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801011e3:	ba 01 00 00 00       	mov    $0x1,%edx
801011e8:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801011eb:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801011f1:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
801011f4:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
801011f6:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
801011fb:	85 d1                	test   %edx,%ecx
801011fd:	74 25                	je     80101224 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801011ff:	f7 d2                	not    %edx
  log_write(bp);
80101201:	83 ec 0c             	sub    $0xc,%esp
80101204:	89 c6                	mov    %eax,%esi
  bp->data[bi/8] &= ~m;
80101206:	21 ca                	and    %ecx,%edx
80101208:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
  log_write(bp);
8010120c:	50                   	push   %eax
8010120d:	e8 0e 1d 00 00       	call   80102f20 <log_write>
  brelse(bp);
80101212:	89 34 24             	mov    %esi,(%esp)
80101215:	e8 d6 ef ff ff       	call   801001f0 <brelse>
}
8010121a:	83 c4 10             	add    $0x10,%esp
8010121d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101220:	5b                   	pop    %ebx
80101221:	5e                   	pop    %esi
80101222:	5d                   	pop    %ebp
80101223:	c3                   	ret    
    panic("freeing free block");
80101224:	83 ec 0c             	sub    $0xc,%esp
80101227:	68 df 74 10 80       	push   $0x801074df
8010122c:	e8 5f f1 ff ff       	call   80100390 <panic>
80101231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010123f:	90                   	nop

80101240 <balloc>:
{
80101240:	55                   	push   %ebp
80101241:	89 e5                	mov    %esp,%ebp
80101243:	57                   	push   %edi
80101244:	56                   	push   %esi
80101245:	53                   	push   %ebx
80101246:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101249:	8b 0d c0 09 11 80    	mov    0x801109c0,%ecx
{
8010124f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101252:	85 c9                	test   %ecx,%ecx
80101254:	0f 84 87 00 00 00    	je     801012e1 <balloc+0xa1>
8010125a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101261:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101264:	83 ec 08             	sub    $0x8,%esp
80101267:	89 f0                	mov    %esi,%eax
80101269:	c1 f8 0c             	sar    $0xc,%eax
8010126c:	03 05 d8 09 11 80    	add    0x801109d8,%eax
80101272:	50                   	push   %eax
80101273:	ff 75 d8             	pushl  -0x28(%ebp)
80101276:	e8 55 ee ff ff       	call   801000d0 <bread>
8010127b:	83 c4 10             	add    $0x10,%esp
8010127e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101281:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101286:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101289:	31 c0                	xor    %eax,%eax
8010128b:	eb 2f                	jmp    801012bc <balloc+0x7c>
8010128d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101290:	89 c1                	mov    %eax,%ecx
80101292:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101297:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010129a:	83 e1 07             	and    $0x7,%ecx
8010129d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010129f:	89 c1                	mov    %eax,%ecx
801012a1:	c1 f9 03             	sar    $0x3,%ecx
801012a4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801012a9:	89 fa                	mov    %edi,%edx
801012ab:	85 df                	test   %ebx,%edi
801012ad:	74 41                	je     801012f0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012af:	83 c0 01             	add    $0x1,%eax
801012b2:	83 c6 01             	add    $0x1,%esi
801012b5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012ba:	74 05                	je     801012c1 <balloc+0x81>
801012bc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012bf:	77 cf                	ja     80101290 <balloc+0x50>
    brelse(bp);
801012c1:	83 ec 0c             	sub    $0xc,%esp
801012c4:	ff 75 e4             	pushl  -0x1c(%ebp)
801012c7:	e8 24 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012cc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012d3:	83 c4 10             	add    $0x10,%esp
801012d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012d9:	39 05 c0 09 11 80    	cmp    %eax,0x801109c0
801012df:	77 80                	ja     80101261 <balloc+0x21>
  panic("balloc: out of blocks");
801012e1:	83 ec 0c             	sub    $0xc,%esp
801012e4:	68 f2 74 10 80       	push   $0x801074f2
801012e9:	e8 a2 f0 ff ff       	call   80100390 <panic>
801012ee:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801012f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012f3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012f6:	09 da                	or     %ebx,%edx
801012f8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012fc:	57                   	push   %edi
801012fd:	e8 1e 1c 00 00       	call   80102f20 <log_write>
        brelse(bp);
80101302:	89 3c 24             	mov    %edi,(%esp)
80101305:	e8 e6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010130a:	58                   	pop    %eax
8010130b:	5a                   	pop    %edx
8010130c:	56                   	push   %esi
8010130d:	ff 75 d8             	pushl  -0x28(%ebp)
80101310:	e8 bb ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101315:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101318:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010131a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010131d:	68 00 02 00 00       	push   $0x200
80101322:	6a 00                	push   $0x0
80101324:	50                   	push   %eax
80101325:	e8 a6 33 00 00       	call   801046d0 <memset>
  log_write(bp);
8010132a:	89 1c 24             	mov    %ebx,(%esp)
8010132d:	e8 ee 1b 00 00       	call   80102f20 <log_write>
  brelse(bp);
80101332:	89 1c 24             	mov    %ebx,(%esp)
80101335:	e8 b6 ee ff ff       	call   801001f0 <brelse>
}
8010133a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010133d:	89 f0                	mov    %esi,%eax
8010133f:	5b                   	pop    %ebx
80101340:	5e                   	pop    %esi
80101341:	5f                   	pop    %edi
80101342:	5d                   	pop    %ebp
80101343:	c3                   	ret    
80101344:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010134b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010134f:	90                   	nop

80101350 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101350:	55                   	push   %ebp
80101351:	89 e5                	mov    %esp,%ebp
80101353:	57                   	push   %edi
80101354:	89 c7                	mov    %eax,%edi
80101356:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101357:	31 f6                	xor    %esi,%esi
{
80101359:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010135a:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
{
8010135f:	83 ec 28             	sub    $0x28,%esp
80101362:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101365:	68 e0 09 11 80       	push   $0x801109e0
8010136a:	e8 51 32 00 00       	call   801045c0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010136f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101372:	83 c4 10             	add    $0x10,%esp
80101375:	eb 1b                	jmp    80101392 <iget+0x42>
80101377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010137e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101380:	39 3b                	cmp    %edi,(%ebx)
80101382:	74 6c                	je     801013f0 <iget+0xa0>
80101384:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010138a:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101390:	73 26                	jae    801013b8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101392:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101395:	85 c9                	test   %ecx,%ecx
80101397:	7f e7                	jg     80101380 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101399:	85 f6                	test   %esi,%esi
8010139b:	75 e7                	jne    80101384 <iget+0x34>
8010139d:	89 d8                	mov    %ebx,%eax
8010139f:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013a5:	85 c9                	test   %ecx,%ecx
801013a7:	75 6e                	jne    80101417 <iget+0xc7>
801013a9:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013ab:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801013b1:	72 df                	jb     80101392 <iget+0x42>
801013b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013b7:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013b8:	85 f6                	test   %esi,%esi
801013ba:	74 73                	je     8010142f <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013bc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013bf:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013c1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013c4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013cb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013d2:	68 e0 09 11 80       	push   $0x801109e0
801013d7:	e8 a4 32 00 00       	call   80104680 <release>

  return ip;
801013dc:	83 c4 10             	add    $0x10,%esp
}
801013df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e2:	89 f0                	mov    %esi,%eax
801013e4:	5b                   	pop    %ebx
801013e5:	5e                   	pop    %esi
801013e6:	5f                   	pop    %edi
801013e7:	5d                   	pop    %ebp
801013e8:	c3                   	ret    
801013e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013f0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013f3:	75 8f                	jne    80101384 <iget+0x34>
      release(&icache.lock);
801013f5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801013f8:	83 c1 01             	add    $0x1,%ecx
      return ip;
801013fb:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801013fd:	68 e0 09 11 80       	push   $0x801109e0
      ip->ref++;
80101402:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101405:	e8 76 32 00 00       	call   80104680 <release>
      return ip;
8010140a:	83 c4 10             	add    $0x10,%esp
}
8010140d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101410:	89 f0                	mov    %esi,%eax
80101412:	5b                   	pop    %ebx
80101413:	5e                   	pop    %esi
80101414:	5f                   	pop    %edi
80101415:	5d                   	pop    %ebp
80101416:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101417:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
8010141d:	73 10                	jae    8010142f <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010141f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101422:	85 c9                	test   %ecx,%ecx
80101424:	0f 8f 56 ff ff ff    	jg     80101380 <iget+0x30>
8010142a:	e9 6e ff ff ff       	jmp    8010139d <iget+0x4d>
    panic("iget: no inodes");
8010142f:	83 ec 0c             	sub    $0xc,%esp
80101432:	68 08 75 10 80       	push   $0x80107508
80101437:	e8 54 ef ff ff       	call   80100390 <panic>
8010143c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101440 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101440:	55                   	push   %ebp
80101441:	89 e5                	mov    %esp,%ebp
80101443:	57                   	push   %edi
80101444:	56                   	push   %esi
80101445:	89 c6                	mov    %eax,%esi
80101447:	53                   	push   %ebx
80101448:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010144b:	83 fa 0b             	cmp    $0xb,%edx
8010144e:	0f 86 84 00 00 00    	jbe    801014d8 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101454:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101457:	83 fb 7f             	cmp    $0x7f,%ebx
8010145a:	0f 87 98 00 00 00    	ja     801014f8 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101460:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101466:	8b 16                	mov    (%esi),%edx
80101468:	85 c0                	test   %eax,%eax
8010146a:	74 54                	je     801014c0 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010146c:	83 ec 08             	sub    $0x8,%esp
8010146f:	50                   	push   %eax
80101470:	52                   	push   %edx
80101471:	e8 5a ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101476:	83 c4 10             	add    $0x10,%esp
80101479:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
8010147d:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
8010147f:	8b 1a                	mov    (%edx),%ebx
80101481:	85 db                	test   %ebx,%ebx
80101483:	74 1b                	je     801014a0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101485:	83 ec 0c             	sub    $0xc,%esp
80101488:	57                   	push   %edi
80101489:	e8 62 ed ff ff       	call   801001f0 <brelse>
    return addr;
8010148e:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
80101491:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101494:	89 d8                	mov    %ebx,%eax
80101496:	5b                   	pop    %ebx
80101497:	5e                   	pop    %esi
80101498:	5f                   	pop    %edi
80101499:	5d                   	pop    %ebp
8010149a:	c3                   	ret    
8010149b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010149f:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
801014a0:	8b 06                	mov    (%esi),%eax
801014a2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801014a5:	e8 96 fd ff ff       	call   80101240 <balloc>
801014aa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801014ad:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014b0:	89 c3                	mov    %eax,%ebx
801014b2:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801014b4:	57                   	push   %edi
801014b5:	e8 66 1a 00 00       	call   80102f20 <log_write>
801014ba:	83 c4 10             	add    $0x10,%esp
801014bd:	eb c6                	jmp    80101485 <bmap+0x45>
801014bf:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014c0:	89 d0                	mov    %edx,%eax
801014c2:	e8 79 fd ff ff       	call   80101240 <balloc>
801014c7:	8b 16                	mov    (%esi),%edx
801014c9:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014cf:	eb 9b                	jmp    8010146c <bmap+0x2c>
801014d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
801014d8:	8d 3c 90             	lea    (%eax,%edx,4),%edi
801014db:	8b 5f 5c             	mov    0x5c(%edi),%ebx
801014de:	85 db                	test   %ebx,%ebx
801014e0:	75 af                	jne    80101491 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
801014e2:	8b 00                	mov    (%eax),%eax
801014e4:	e8 57 fd ff ff       	call   80101240 <balloc>
801014e9:	89 47 5c             	mov    %eax,0x5c(%edi)
801014ec:	89 c3                	mov    %eax,%ebx
}
801014ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014f1:	89 d8                	mov    %ebx,%eax
801014f3:	5b                   	pop    %ebx
801014f4:	5e                   	pop    %esi
801014f5:	5f                   	pop    %edi
801014f6:	5d                   	pop    %ebp
801014f7:	c3                   	ret    
  panic("bmap: out of range");
801014f8:	83 ec 0c             	sub    $0xc,%esp
801014fb:	68 18 75 10 80       	push   $0x80107518
80101500:	e8 8b ee ff ff       	call   80100390 <panic>
80101505:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010150c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101510 <readsb>:
{
80101510:	f3 0f 1e fb          	endbr32 
80101514:	55                   	push   %ebp
80101515:	89 e5                	mov    %esp,%ebp
80101517:	56                   	push   %esi
80101518:	53                   	push   %ebx
80101519:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
8010151c:	83 ec 08             	sub    $0x8,%esp
8010151f:	6a 01                	push   $0x1
80101521:	ff 75 08             	pushl  0x8(%ebp)
80101524:	e8 a7 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101529:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010152c:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010152e:	8d 40 5c             	lea    0x5c(%eax),%eax
80101531:	6a 1c                	push   $0x1c
80101533:	50                   	push   %eax
80101534:	56                   	push   %esi
80101535:	e8 36 32 00 00       	call   80104770 <memmove>
  brelse(bp);
8010153a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010153d:	83 c4 10             	add    $0x10,%esp
}
80101540:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101543:	5b                   	pop    %ebx
80101544:	5e                   	pop    %esi
80101545:	5d                   	pop    %ebp
  brelse(bp);
80101546:	e9 a5 ec ff ff       	jmp    801001f0 <brelse>
8010154b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010154f:	90                   	nop

80101550 <iinit>:
{
80101550:	f3 0f 1e fb          	endbr32 
80101554:	55                   	push   %ebp
80101555:	89 e5                	mov    %esp,%ebp
80101557:	53                   	push   %ebx
80101558:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
8010155d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101560:	68 2b 75 10 80       	push   $0x8010752b
80101565:	68 e0 09 11 80       	push   $0x801109e0
8010156a:	e8 d1 2e 00 00       	call   80104440 <initlock>
  for(i = 0; i < NINODE; i++) {
8010156f:	83 c4 10             	add    $0x10,%esp
80101572:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101578:	83 ec 08             	sub    $0x8,%esp
8010157b:	68 32 75 10 80       	push   $0x80107532
80101580:	53                   	push   %ebx
80101581:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101587:	e8 74 2d 00 00       	call   80104300 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
8010158c:	83 c4 10             	add    $0x10,%esp
8010158f:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
80101595:	75 e1                	jne    80101578 <iinit+0x28>
  readsb(dev, &sb);
80101597:	83 ec 08             	sub    $0x8,%esp
8010159a:	68 c0 09 11 80       	push   $0x801109c0
8010159f:	ff 75 08             	pushl  0x8(%ebp)
801015a2:	e8 69 ff ff ff       	call   80101510 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015a7:	ff 35 d8 09 11 80    	pushl  0x801109d8
801015ad:	ff 35 d4 09 11 80    	pushl  0x801109d4
801015b3:	ff 35 d0 09 11 80    	pushl  0x801109d0
801015b9:	ff 35 cc 09 11 80    	pushl  0x801109cc
801015bf:	ff 35 c8 09 11 80    	pushl  0x801109c8
801015c5:	ff 35 c4 09 11 80    	pushl  0x801109c4
801015cb:	ff 35 c0 09 11 80    	pushl  0x801109c0
801015d1:	68 98 75 10 80       	push   $0x80107598
801015d6:	e8 d5 f0 ff ff       	call   801006b0 <cprintf>
}
801015db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801015de:	83 c4 30             	add    $0x30,%esp
801015e1:	c9                   	leave  
801015e2:	c3                   	ret    
801015e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801015f0 <ialloc>:
{
801015f0:	f3 0f 1e fb          	endbr32 
801015f4:	55                   	push   %ebp
801015f5:	89 e5                	mov    %esp,%ebp
801015f7:	57                   	push   %edi
801015f8:	56                   	push   %esi
801015f9:	53                   	push   %ebx
801015fa:	83 ec 1c             	sub    $0x1c,%esp
801015fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
80101600:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
{
80101607:	8b 75 08             	mov    0x8(%ebp),%esi
8010160a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
8010160d:	0f 86 8d 00 00 00    	jbe    801016a0 <ialloc+0xb0>
80101613:	bf 01 00 00 00       	mov    $0x1,%edi
80101618:	eb 1d                	jmp    80101637 <ialloc+0x47>
8010161a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
80101620:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101623:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101626:	53                   	push   %ebx
80101627:	e8 c4 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010162c:	83 c4 10             	add    $0x10,%esp
8010162f:	3b 3d c8 09 11 80    	cmp    0x801109c8,%edi
80101635:	73 69                	jae    801016a0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101637:	89 f8                	mov    %edi,%eax
80101639:	83 ec 08             	sub    $0x8,%esp
8010163c:	c1 e8 03             	shr    $0x3,%eax
8010163f:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101645:	50                   	push   %eax
80101646:	56                   	push   %esi
80101647:	e8 84 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010164c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010164f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101651:	89 f8                	mov    %edi,%eax
80101653:	83 e0 07             	and    $0x7,%eax
80101656:	c1 e0 06             	shl    $0x6,%eax
80101659:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010165d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101661:	75 bd                	jne    80101620 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101663:	83 ec 04             	sub    $0x4,%esp
80101666:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101669:	6a 40                	push   $0x40
8010166b:	6a 00                	push   $0x0
8010166d:	51                   	push   %ecx
8010166e:	e8 5d 30 00 00       	call   801046d0 <memset>
      dip->type = type;
80101673:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101677:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010167a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010167d:	89 1c 24             	mov    %ebx,(%esp)
80101680:	e8 9b 18 00 00       	call   80102f20 <log_write>
      brelse(bp);
80101685:	89 1c 24             	mov    %ebx,(%esp)
80101688:	e8 63 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010168d:	83 c4 10             	add    $0x10,%esp
}
80101690:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101693:	89 fa                	mov    %edi,%edx
}
80101695:	5b                   	pop    %ebx
      return iget(dev, inum);
80101696:	89 f0                	mov    %esi,%eax
}
80101698:	5e                   	pop    %esi
80101699:	5f                   	pop    %edi
8010169a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010169b:	e9 b0 fc ff ff       	jmp    80101350 <iget>
  panic("ialloc: no inodes");
801016a0:	83 ec 0c             	sub    $0xc,%esp
801016a3:	68 38 75 10 80       	push   $0x80107538
801016a8:	e8 e3 ec ff ff       	call   80100390 <panic>
801016ad:	8d 76 00             	lea    0x0(%esi),%esi

801016b0 <iupdate>:
{
801016b0:	f3 0f 1e fb          	endbr32 
801016b4:	55                   	push   %ebp
801016b5:	89 e5                	mov    %esp,%ebp
801016b7:	56                   	push   %esi
801016b8:	53                   	push   %ebx
801016b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016bc:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016bf:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016c2:	83 ec 08             	sub    $0x8,%esp
801016c5:	c1 e8 03             	shr    $0x3,%eax
801016c8:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801016ce:	50                   	push   %eax
801016cf:	ff 73 a4             	pushl  -0x5c(%ebx)
801016d2:	e8 f9 e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801016d7:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016db:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016de:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016e0:	8b 43 a8             	mov    -0x58(%ebx),%eax
801016e3:	83 e0 07             	and    $0x7,%eax
801016e6:	c1 e0 06             	shl    $0x6,%eax
801016e9:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801016ed:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801016f0:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016f4:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801016f7:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801016fb:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801016ff:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101703:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101707:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
8010170b:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010170e:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101711:	6a 34                	push   $0x34
80101713:	53                   	push   %ebx
80101714:	50                   	push   %eax
80101715:	e8 56 30 00 00       	call   80104770 <memmove>
  log_write(bp);
8010171a:	89 34 24             	mov    %esi,(%esp)
8010171d:	e8 fe 17 00 00       	call   80102f20 <log_write>
  brelse(bp);
80101722:	89 75 08             	mov    %esi,0x8(%ebp)
80101725:	83 c4 10             	add    $0x10,%esp
}
80101728:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010172b:	5b                   	pop    %ebx
8010172c:	5e                   	pop    %esi
8010172d:	5d                   	pop    %ebp
  brelse(bp);
8010172e:	e9 bd ea ff ff       	jmp    801001f0 <brelse>
80101733:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010173a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101740 <idup>:
{
80101740:	f3 0f 1e fb          	endbr32 
80101744:	55                   	push   %ebp
80101745:	89 e5                	mov    %esp,%ebp
80101747:	53                   	push   %ebx
80101748:	83 ec 10             	sub    $0x10,%esp
8010174b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010174e:	68 e0 09 11 80       	push   $0x801109e0
80101753:	e8 68 2e 00 00       	call   801045c0 <acquire>
  ip->ref++;
80101758:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010175c:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101763:	e8 18 2f 00 00       	call   80104680 <release>
}
80101768:	89 d8                	mov    %ebx,%eax
8010176a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010176d:	c9                   	leave  
8010176e:	c3                   	ret    
8010176f:	90                   	nop

80101770 <ilock>:
{
80101770:	f3 0f 1e fb          	endbr32 
80101774:	55                   	push   %ebp
80101775:	89 e5                	mov    %esp,%ebp
80101777:	56                   	push   %esi
80101778:	53                   	push   %ebx
80101779:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
8010177c:	85 db                	test   %ebx,%ebx
8010177e:	0f 84 b3 00 00 00    	je     80101837 <ilock+0xc7>
80101784:	8b 53 08             	mov    0x8(%ebx),%edx
80101787:	85 d2                	test   %edx,%edx
80101789:	0f 8e a8 00 00 00    	jle    80101837 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010178f:	83 ec 0c             	sub    $0xc,%esp
80101792:	8d 43 0c             	lea    0xc(%ebx),%eax
80101795:	50                   	push   %eax
80101796:	e8 a5 2b 00 00       	call   80104340 <acquiresleep>
  if(ip->valid == 0){
8010179b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010179e:	83 c4 10             	add    $0x10,%esp
801017a1:	85 c0                	test   %eax,%eax
801017a3:	74 0b                	je     801017b0 <ilock+0x40>
}
801017a5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017a8:	5b                   	pop    %ebx
801017a9:	5e                   	pop    %esi
801017aa:	5d                   	pop    %ebp
801017ab:	c3                   	ret    
801017ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017b0:	8b 43 04             	mov    0x4(%ebx),%eax
801017b3:	83 ec 08             	sub    $0x8,%esp
801017b6:	c1 e8 03             	shr    $0x3,%eax
801017b9:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801017bf:	50                   	push   %eax
801017c0:	ff 33                	pushl  (%ebx)
801017c2:	e8 09 e9 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017c7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017ca:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017cc:	8b 43 04             	mov    0x4(%ebx),%eax
801017cf:	83 e0 07             	and    $0x7,%eax
801017d2:	c1 e0 06             	shl    $0x6,%eax
801017d5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017d9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017dc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017df:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017e3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017e7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017eb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017ef:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801017f3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801017f7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801017fb:	8b 50 fc             	mov    -0x4(%eax),%edx
801017fe:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101801:	6a 34                	push   $0x34
80101803:	50                   	push   %eax
80101804:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101807:	50                   	push   %eax
80101808:	e8 63 2f 00 00       	call   80104770 <memmove>
    brelse(bp);
8010180d:	89 34 24             	mov    %esi,(%esp)
80101810:	e8 db e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101815:	83 c4 10             	add    $0x10,%esp
80101818:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010181d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101824:	0f 85 7b ff ff ff    	jne    801017a5 <ilock+0x35>
      panic("ilock: no type");
8010182a:	83 ec 0c             	sub    $0xc,%esp
8010182d:	68 50 75 10 80       	push   $0x80107550
80101832:	e8 59 eb ff ff       	call   80100390 <panic>
    panic("ilock");
80101837:	83 ec 0c             	sub    $0xc,%esp
8010183a:	68 4a 75 10 80       	push   $0x8010754a
8010183f:	e8 4c eb ff ff       	call   80100390 <panic>
80101844:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010184b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010184f:	90                   	nop

80101850 <iunlock>:
{
80101850:	f3 0f 1e fb          	endbr32 
80101854:	55                   	push   %ebp
80101855:	89 e5                	mov    %esp,%ebp
80101857:	56                   	push   %esi
80101858:	53                   	push   %ebx
80101859:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010185c:	85 db                	test   %ebx,%ebx
8010185e:	74 28                	je     80101888 <iunlock+0x38>
80101860:	83 ec 0c             	sub    $0xc,%esp
80101863:	8d 73 0c             	lea    0xc(%ebx),%esi
80101866:	56                   	push   %esi
80101867:	e8 74 2b 00 00       	call   801043e0 <holdingsleep>
8010186c:	83 c4 10             	add    $0x10,%esp
8010186f:	85 c0                	test   %eax,%eax
80101871:	74 15                	je     80101888 <iunlock+0x38>
80101873:	8b 43 08             	mov    0x8(%ebx),%eax
80101876:	85 c0                	test   %eax,%eax
80101878:	7e 0e                	jle    80101888 <iunlock+0x38>
  releasesleep(&ip->lock);
8010187a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010187d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101880:	5b                   	pop    %ebx
80101881:	5e                   	pop    %esi
80101882:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101883:	e9 18 2b 00 00       	jmp    801043a0 <releasesleep>
    panic("iunlock");
80101888:	83 ec 0c             	sub    $0xc,%esp
8010188b:	68 5f 75 10 80       	push   $0x8010755f
80101890:	e8 fb ea ff ff       	call   80100390 <panic>
80101895:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010189c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801018a0 <iput>:
{
801018a0:	f3 0f 1e fb          	endbr32 
801018a4:	55                   	push   %ebp
801018a5:	89 e5                	mov    %esp,%ebp
801018a7:	57                   	push   %edi
801018a8:	56                   	push   %esi
801018a9:	53                   	push   %ebx
801018aa:	83 ec 28             	sub    $0x28,%esp
801018ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018b0:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018b3:	57                   	push   %edi
801018b4:	e8 87 2a 00 00       	call   80104340 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018b9:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018bc:	83 c4 10             	add    $0x10,%esp
801018bf:	85 d2                	test   %edx,%edx
801018c1:	74 07                	je     801018ca <iput+0x2a>
801018c3:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018c8:	74 36                	je     80101900 <iput+0x60>
  releasesleep(&ip->lock);
801018ca:	83 ec 0c             	sub    $0xc,%esp
801018cd:	57                   	push   %edi
801018ce:	e8 cd 2a 00 00       	call   801043a0 <releasesleep>
  acquire(&icache.lock);
801018d3:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801018da:	e8 e1 2c 00 00       	call   801045c0 <acquire>
  ip->ref--;
801018df:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018e3:	83 c4 10             	add    $0x10,%esp
801018e6:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
801018ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018f0:	5b                   	pop    %ebx
801018f1:	5e                   	pop    %esi
801018f2:	5f                   	pop    %edi
801018f3:	5d                   	pop    %ebp
  release(&icache.lock);
801018f4:	e9 87 2d 00 00       	jmp    80104680 <release>
801018f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
80101900:	83 ec 0c             	sub    $0xc,%esp
80101903:	68 e0 09 11 80       	push   $0x801109e0
80101908:	e8 b3 2c 00 00       	call   801045c0 <acquire>
    int r = ip->ref;
8010190d:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101910:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101917:	e8 64 2d 00 00       	call   80104680 <release>
    if(r == 1){
8010191c:	83 c4 10             	add    $0x10,%esp
8010191f:	83 fe 01             	cmp    $0x1,%esi
80101922:	75 a6                	jne    801018ca <iput+0x2a>
80101924:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
8010192a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010192d:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101930:	89 cf                	mov    %ecx,%edi
80101932:	eb 0b                	jmp    8010193f <iput+0x9f>
80101934:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101938:	83 c6 04             	add    $0x4,%esi
8010193b:	39 fe                	cmp    %edi,%esi
8010193d:	74 19                	je     80101958 <iput+0xb8>
    if(ip->addrs[i]){
8010193f:	8b 16                	mov    (%esi),%edx
80101941:	85 d2                	test   %edx,%edx
80101943:	74 f3                	je     80101938 <iput+0x98>
      bfree(ip->dev, ip->addrs[i]);
80101945:	8b 03                	mov    (%ebx),%eax
80101947:	e8 74 f8 ff ff       	call   801011c0 <bfree>
      ip->addrs[i] = 0;
8010194c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101952:	eb e4                	jmp    80101938 <iput+0x98>
80101954:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101958:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
8010195e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101961:	85 c0                	test   %eax,%eax
80101963:	75 33                	jne    80101998 <iput+0xf8>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101965:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101968:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
8010196f:	53                   	push   %ebx
80101970:	e8 3b fd ff ff       	call   801016b0 <iupdate>
      ip->type = 0;
80101975:	31 c0                	xor    %eax,%eax
80101977:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
8010197b:	89 1c 24             	mov    %ebx,(%esp)
8010197e:	e8 2d fd ff ff       	call   801016b0 <iupdate>
      ip->valid = 0;
80101983:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
8010198a:	83 c4 10             	add    $0x10,%esp
8010198d:	e9 38 ff ff ff       	jmp    801018ca <iput+0x2a>
80101992:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101998:	83 ec 08             	sub    $0x8,%esp
8010199b:	50                   	push   %eax
8010199c:	ff 33                	pushl  (%ebx)
8010199e:	e8 2d e7 ff ff       	call   801000d0 <bread>
801019a3:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019a6:	83 c4 10             	add    $0x10,%esp
801019a9:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019b2:	8d 70 5c             	lea    0x5c(%eax),%esi
801019b5:	89 cf                	mov    %ecx,%edi
801019b7:	eb 0e                	jmp    801019c7 <iput+0x127>
801019b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019c0:	83 c6 04             	add    $0x4,%esi
801019c3:	39 f7                	cmp    %esi,%edi
801019c5:	74 19                	je     801019e0 <iput+0x140>
      if(a[j])
801019c7:	8b 16                	mov    (%esi),%edx
801019c9:	85 d2                	test   %edx,%edx
801019cb:	74 f3                	je     801019c0 <iput+0x120>
        bfree(ip->dev, a[j]);
801019cd:	8b 03                	mov    (%ebx),%eax
801019cf:	e8 ec f7 ff ff       	call   801011c0 <bfree>
801019d4:	eb ea                	jmp    801019c0 <iput+0x120>
801019d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019dd:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
801019e0:	83 ec 0c             	sub    $0xc,%esp
801019e3:	ff 75 e4             	pushl  -0x1c(%ebp)
801019e6:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019e9:	e8 02 e8 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019ee:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019f4:	8b 03                	mov    (%ebx),%eax
801019f6:	e8 c5 f7 ff ff       	call   801011c0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019fb:	83 c4 10             	add    $0x10,%esp
801019fe:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a05:	00 00 00 
80101a08:	e9 58 ff ff ff       	jmp    80101965 <iput+0xc5>
80101a0d:	8d 76 00             	lea    0x0(%esi),%esi

80101a10 <iunlockput>:
{
80101a10:	f3 0f 1e fb          	endbr32 
80101a14:	55                   	push   %ebp
80101a15:	89 e5                	mov    %esp,%ebp
80101a17:	53                   	push   %ebx
80101a18:	83 ec 10             	sub    $0x10,%esp
80101a1b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101a1e:	53                   	push   %ebx
80101a1f:	e8 2c fe ff ff       	call   80101850 <iunlock>
  iput(ip);
80101a24:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a27:	83 c4 10             	add    $0x10,%esp
}
80101a2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101a2d:	c9                   	leave  
  iput(ip);
80101a2e:	e9 6d fe ff ff       	jmp    801018a0 <iput>
80101a33:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a40 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a40:	f3 0f 1e fb          	endbr32 
80101a44:	55                   	push   %ebp
80101a45:	89 e5                	mov    %esp,%ebp
80101a47:	8b 55 08             	mov    0x8(%ebp),%edx
80101a4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a4d:	8b 0a                	mov    (%edx),%ecx
80101a4f:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a52:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a55:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a58:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a5c:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a5f:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a63:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a67:	8b 52 58             	mov    0x58(%edx),%edx
80101a6a:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a6d:	5d                   	pop    %ebp
80101a6e:	c3                   	ret    
80101a6f:	90                   	nop

80101a70 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a70:	f3 0f 1e fb          	endbr32 
80101a74:	55                   	push   %ebp
80101a75:	89 e5                	mov    %esp,%ebp
80101a77:	57                   	push   %edi
80101a78:	56                   	push   %esi
80101a79:	53                   	push   %ebx
80101a7a:	83 ec 1c             	sub    $0x1c,%esp
80101a7d:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a80:	8b 45 08             	mov    0x8(%ebp),%eax
80101a83:	8b 75 10             	mov    0x10(%ebp),%esi
80101a86:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a89:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a8c:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a91:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a94:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101a97:	0f 84 a3 00 00 00    	je     80101b40 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101a9d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101aa0:	8b 40 58             	mov    0x58(%eax),%eax
80101aa3:	39 c6                	cmp    %eax,%esi
80101aa5:	0f 87 b6 00 00 00    	ja     80101b61 <readi+0xf1>
80101aab:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101aae:	31 c9                	xor    %ecx,%ecx
80101ab0:	89 da                	mov    %ebx,%edx
80101ab2:	01 f2                	add    %esi,%edx
80101ab4:	0f 92 c1             	setb   %cl
80101ab7:	89 cf                	mov    %ecx,%edi
80101ab9:	0f 82 a2 00 00 00    	jb     80101b61 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101abf:	89 c1                	mov    %eax,%ecx
80101ac1:	29 f1                	sub    %esi,%ecx
80101ac3:	39 d0                	cmp    %edx,%eax
80101ac5:	0f 43 cb             	cmovae %ebx,%ecx
80101ac8:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101acb:	85 c9                	test   %ecx,%ecx
80101acd:	74 63                	je     80101b32 <readi+0xc2>
80101acf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ad0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101ad3:	89 f2                	mov    %esi,%edx
80101ad5:	c1 ea 09             	shr    $0x9,%edx
80101ad8:	89 d8                	mov    %ebx,%eax
80101ada:	e8 61 f9 ff ff       	call   80101440 <bmap>
80101adf:	83 ec 08             	sub    $0x8,%esp
80101ae2:	50                   	push   %eax
80101ae3:	ff 33                	pushl  (%ebx)
80101ae5:	e8 e6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101aea:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101aed:	b9 00 02 00 00       	mov    $0x200,%ecx
80101af2:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af5:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101af7:	89 f0                	mov    %esi,%eax
80101af9:	25 ff 01 00 00       	and    $0x1ff,%eax
80101afe:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b00:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b03:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b05:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b09:	39 d9                	cmp    %ebx,%ecx
80101b0b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b0e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b0f:	01 df                	add    %ebx,%edi
80101b11:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b13:	50                   	push   %eax
80101b14:	ff 75 e0             	pushl  -0x20(%ebp)
80101b17:	e8 54 2c 00 00       	call   80104770 <memmove>
    brelse(bp);
80101b1c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b1f:	89 14 24             	mov    %edx,(%esp)
80101b22:	e8 c9 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b27:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b2a:	83 c4 10             	add    $0x10,%esp
80101b2d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b30:	77 9e                	ja     80101ad0 <readi+0x60>
  }
  return n;
80101b32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b35:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b38:	5b                   	pop    %ebx
80101b39:	5e                   	pop    %esi
80101b3a:	5f                   	pop    %edi
80101b3b:	5d                   	pop    %ebp
80101b3c:	c3                   	ret    
80101b3d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b44:	66 83 f8 09          	cmp    $0x9,%ax
80101b48:	77 17                	ja     80101b61 <readi+0xf1>
80101b4a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101b51:	85 c0                	test   %eax,%eax
80101b53:	74 0c                	je     80101b61 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b55:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b5b:	5b                   	pop    %ebx
80101b5c:	5e                   	pop    %esi
80101b5d:	5f                   	pop    %edi
80101b5e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b5f:	ff e0                	jmp    *%eax
      return -1;
80101b61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b66:	eb cd                	jmp    80101b35 <readi+0xc5>
80101b68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b6f:	90                   	nop

80101b70 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b70:	f3 0f 1e fb          	endbr32 
80101b74:	55                   	push   %ebp
80101b75:	89 e5                	mov    %esp,%ebp
80101b77:	57                   	push   %edi
80101b78:	56                   	push   %esi
80101b79:	53                   	push   %ebx
80101b7a:	83 ec 1c             	sub    $0x1c,%esp
80101b7d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b80:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b83:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b86:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b8b:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101b8e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b91:	8b 75 10             	mov    0x10(%ebp),%esi
80101b94:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101b97:	0f 84 b3 00 00 00    	je     80101c50 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101b9d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101ba0:	39 70 58             	cmp    %esi,0x58(%eax)
80101ba3:	0f 82 e3 00 00 00    	jb     80101c8c <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ba9:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bac:	89 f8                	mov    %edi,%eax
80101bae:	01 f0                	add    %esi,%eax
80101bb0:	0f 82 d6 00 00 00    	jb     80101c8c <writei+0x11c>
80101bb6:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101bbb:	0f 87 cb 00 00 00    	ja     80101c8c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bc1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101bc8:	85 ff                	test   %edi,%edi
80101bca:	74 75                	je     80101c41 <writei+0xd1>
80101bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bd0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101bd3:	89 f2                	mov    %esi,%edx
80101bd5:	c1 ea 09             	shr    $0x9,%edx
80101bd8:	89 f8                	mov    %edi,%eax
80101bda:	e8 61 f8 ff ff       	call   80101440 <bmap>
80101bdf:	83 ec 08             	sub    $0x8,%esp
80101be2:	50                   	push   %eax
80101be3:	ff 37                	pushl  (%edi)
80101be5:	e8 e6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101bea:	b9 00 02 00 00       	mov    $0x200,%ecx
80101bef:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101bf2:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bf5:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101bf7:	89 f0                	mov    %esi,%eax
80101bf9:	83 c4 0c             	add    $0xc,%esp
80101bfc:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c01:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c03:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c07:	39 d9                	cmp    %ebx,%ecx
80101c09:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c0c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c0d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c0f:	ff 75 dc             	pushl  -0x24(%ebp)
80101c12:	50                   	push   %eax
80101c13:	e8 58 2b 00 00       	call   80104770 <memmove>
    log_write(bp);
80101c18:	89 3c 24             	mov    %edi,(%esp)
80101c1b:	e8 00 13 00 00       	call   80102f20 <log_write>
    brelse(bp);
80101c20:	89 3c 24             	mov    %edi,(%esp)
80101c23:	e8 c8 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c28:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c2b:	83 c4 10             	add    $0x10,%esp
80101c2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c31:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c34:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c37:	77 97                	ja     80101bd0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c39:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c3c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c3f:	77 37                	ja     80101c78 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c41:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c44:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c47:	5b                   	pop    %ebx
80101c48:	5e                   	pop    %esi
80101c49:	5f                   	pop    %edi
80101c4a:	5d                   	pop    %ebp
80101c4b:	c3                   	ret    
80101c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c50:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c54:	66 83 f8 09          	cmp    $0x9,%ax
80101c58:	77 32                	ja     80101c8c <writei+0x11c>
80101c5a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101c61:	85 c0                	test   %eax,%eax
80101c63:	74 27                	je     80101c8c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c65:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101c68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c6b:	5b                   	pop    %ebx
80101c6c:	5e                   	pop    %esi
80101c6d:	5f                   	pop    %edi
80101c6e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c6f:	ff e0                	jmp    *%eax
80101c71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c78:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c7b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c7e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101c81:	50                   	push   %eax
80101c82:	e8 29 fa ff ff       	call   801016b0 <iupdate>
80101c87:	83 c4 10             	add    $0x10,%esp
80101c8a:	eb b5                	jmp    80101c41 <writei+0xd1>
      return -1;
80101c8c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c91:	eb b1                	jmp    80101c44 <writei+0xd4>
80101c93:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101ca0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101ca0:	f3 0f 1e fb          	endbr32 
80101ca4:	55                   	push   %ebp
80101ca5:	89 e5                	mov    %esp,%ebp
80101ca7:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101caa:	6a 0e                	push   $0xe
80101cac:	ff 75 0c             	pushl  0xc(%ebp)
80101caf:	ff 75 08             	pushl  0x8(%ebp)
80101cb2:	e8 29 2b 00 00       	call   801047e0 <strncmp>
}
80101cb7:	c9                   	leave  
80101cb8:	c3                   	ret    
80101cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101cc0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101cc0:	f3 0f 1e fb          	endbr32 
80101cc4:	55                   	push   %ebp
80101cc5:	89 e5                	mov    %esp,%ebp
80101cc7:	57                   	push   %edi
80101cc8:	56                   	push   %esi
80101cc9:	53                   	push   %ebx
80101cca:	83 ec 1c             	sub    $0x1c,%esp
80101ccd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cd0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101cd5:	0f 85 89 00 00 00    	jne    80101d64 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101cdb:	8b 53 58             	mov    0x58(%ebx),%edx
80101cde:	31 ff                	xor    %edi,%edi
80101ce0:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101ce3:	85 d2                	test   %edx,%edx
80101ce5:	74 42                	je     80101d29 <dirlookup+0x69>
80101ce7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cee:	66 90                	xchg   %ax,%ax
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101cf0:	6a 10                	push   $0x10
80101cf2:	57                   	push   %edi
80101cf3:	56                   	push   %esi
80101cf4:	53                   	push   %ebx
80101cf5:	e8 76 fd ff ff       	call   80101a70 <readi>
80101cfa:	83 c4 10             	add    $0x10,%esp
80101cfd:	83 f8 10             	cmp    $0x10,%eax
80101d00:	75 55                	jne    80101d57 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
80101d02:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d07:	74 18                	je     80101d21 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
80101d09:	83 ec 04             	sub    $0x4,%esp
80101d0c:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d0f:	6a 0e                	push   $0xe
80101d11:	50                   	push   %eax
80101d12:	ff 75 0c             	pushl  0xc(%ebp)
80101d15:	e8 c6 2a 00 00       	call   801047e0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d1a:	83 c4 10             	add    $0x10,%esp
80101d1d:	85 c0                	test   %eax,%eax
80101d1f:	74 17                	je     80101d38 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d21:	83 c7 10             	add    $0x10,%edi
80101d24:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d27:	72 c7                	jb     80101cf0 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d29:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d2c:	31 c0                	xor    %eax,%eax
}
80101d2e:	5b                   	pop    %ebx
80101d2f:	5e                   	pop    %esi
80101d30:	5f                   	pop    %edi
80101d31:	5d                   	pop    %ebp
80101d32:	c3                   	ret    
80101d33:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d37:	90                   	nop
      if(poff)
80101d38:	8b 45 10             	mov    0x10(%ebp),%eax
80101d3b:	85 c0                	test   %eax,%eax
80101d3d:	74 05                	je     80101d44 <dirlookup+0x84>
        *poff = off;
80101d3f:	8b 45 10             	mov    0x10(%ebp),%eax
80101d42:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d44:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d48:	8b 03                	mov    (%ebx),%eax
80101d4a:	e8 01 f6 ff ff       	call   80101350 <iget>
}
80101d4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d52:	5b                   	pop    %ebx
80101d53:	5e                   	pop    %esi
80101d54:	5f                   	pop    %edi
80101d55:	5d                   	pop    %ebp
80101d56:	c3                   	ret    
      panic("dirlookup read");
80101d57:	83 ec 0c             	sub    $0xc,%esp
80101d5a:	68 79 75 10 80       	push   $0x80107579
80101d5f:	e8 2c e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101d64:	83 ec 0c             	sub    $0xc,%esp
80101d67:	68 67 75 10 80       	push   $0x80107567
80101d6c:	e8 1f e6 ff ff       	call   80100390 <panic>
80101d71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d7f:	90                   	nop

80101d80 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d80:	55                   	push   %ebp
80101d81:	89 e5                	mov    %esp,%ebp
80101d83:	57                   	push   %edi
80101d84:	56                   	push   %esi
80101d85:	53                   	push   %ebx
80101d86:	89 c3                	mov    %eax,%ebx
80101d88:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d8b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d8e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101d91:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101d94:	0f 84 86 01 00 00    	je     80101f20 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101d9a:	e8 e1 1b 00 00       	call   80103980 <myproc>
  acquire(&icache.lock);
80101d9f:	83 ec 0c             	sub    $0xc,%esp
80101da2:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101da4:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101da7:	68 e0 09 11 80       	push   $0x801109e0
80101dac:	e8 0f 28 00 00       	call   801045c0 <acquire>
  ip->ref++;
80101db1:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101db5:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101dbc:	e8 bf 28 00 00       	call   80104680 <release>
80101dc1:	83 c4 10             	add    $0x10,%esp
80101dc4:	eb 0d                	jmp    80101dd3 <namex+0x53>
80101dc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dcd:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80101dd0:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101dd3:	0f b6 07             	movzbl (%edi),%eax
80101dd6:	3c 2f                	cmp    $0x2f,%al
80101dd8:	74 f6                	je     80101dd0 <namex+0x50>
  if(*path == 0)
80101dda:	84 c0                	test   %al,%al
80101ddc:	0f 84 ee 00 00 00    	je     80101ed0 <namex+0x150>
  while(*path != '/' && *path != 0)
80101de2:	0f b6 07             	movzbl (%edi),%eax
80101de5:	84 c0                	test   %al,%al
80101de7:	0f 84 fb 00 00 00    	je     80101ee8 <namex+0x168>
80101ded:	89 fb                	mov    %edi,%ebx
80101def:	3c 2f                	cmp    $0x2f,%al
80101df1:	0f 84 f1 00 00 00    	je     80101ee8 <namex+0x168>
80101df7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dfe:	66 90                	xchg   %ax,%ax
80101e00:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
80101e04:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80101e07:	3c 2f                	cmp    $0x2f,%al
80101e09:	74 04                	je     80101e0f <namex+0x8f>
80101e0b:	84 c0                	test   %al,%al
80101e0d:	75 f1                	jne    80101e00 <namex+0x80>
  len = path - s;
80101e0f:	89 d8                	mov    %ebx,%eax
80101e11:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80101e13:	83 f8 0d             	cmp    $0xd,%eax
80101e16:	0f 8e 84 00 00 00    	jle    80101ea0 <namex+0x120>
    memmove(name, s, DIRSIZ);
80101e1c:	83 ec 04             	sub    $0x4,%esp
80101e1f:	6a 0e                	push   $0xe
80101e21:	57                   	push   %edi
    path++;
80101e22:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80101e24:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e27:	e8 44 29 00 00       	call   80104770 <memmove>
80101e2c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e2f:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e32:	75 0c                	jne    80101e40 <namex+0xc0>
80101e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e38:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101e3b:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e3e:	74 f8                	je     80101e38 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e40:	83 ec 0c             	sub    $0xc,%esp
80101e43:	56                   	push   %esi
80101e44:	e8 27 f9 ff ff       	call   80101770 <ilock>
    if(ip->type != T_DIR){
80101e49:	83 c4 10             	add    $0x10,%esp
80101e4c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e51:	0f 85 a1 00 00 00    	jne    80101ef8 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e57:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101e5a:	85 d2                	test   %edx,%edx
80101e5c:	74 09                	je     80101e67 <namex+0xe7>
80101e5e:	80 3f 00             	cmpb   $0x0,(%edi)
80101e61:	0f 84 d9 00 00 00    	je     80101f40 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e67:	83 ec 04             	sub    $0x4,%esp
80101e6a:	6a 00                	push   $0x0
80101e6c:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e6f:	56                   	push   %esi
80101e70:	e8 4b fe ff ff       	call   80101cc0 <dirlookup>
80101e75:	83 c4 10             	add    $0x10,%esp
80101e78:	89 c3                	mov    %eax,%ebx
80101e7a:	85 c0                	test   %eax,%eax
80101e7c:	74 7a                	je     80101ef8 <namex+0x178>
  iunlock(ip);
80101e7e:	83 ec 0c             	sub    $0xc,%esp
80101e81:	56                   	push   %esi
80101e82:	e8 c9 f9 ff ff       	call   80101850 <iunlock>
  iput(ip);
80101e87:	89 34 24             	mov    %esi,(%esp)
80101e8a:	89 de                	mov    %ebx,%esi
80101e8c:	e8 0f fa ff ff       	call   801018a0 <iput>
80101e91:	83 c4 10             	add    $0x10,%esp
80101e94:	e9 3a ff ff ff       	jmp    80101dd3 <namex+0x53>
80101e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ea0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101ea3:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80101ea6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80101ea9:	83 ec 04             	sub    $0x4,%esp
80101eac:	50                   	push   %eax
80101ead:	57                   	push   %edi
    name[len] = 0;
80101eae:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80101eb0:	ff 75 e4             	pushl  -0x1c(%ebp)
80101eb3:	e8 b8 28 00 00       	call   80104770 <memmove>
    name[len] = 0;
80101eb8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101ebb:	83 c4 10             	add    $0x10,%esp
80101ebe:	c6 00 00             	movb   $0x0,(%eax)
80101ec1:	e9 69 ff ff ff       	jmp    80101e2f <namex+0xaf>
80101ec6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ecd:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101ed0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101ed3:	85 c0                	test   %eax,%eax
80101ed5:	0f 85 85 00 00 00    	jne    80101f60 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
80101edb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ede:	89 f0                	mov    %esi,%eax
80101ee0:	5b                   	pop    %ebx
80101ee1:	5e                   	pop    %esi
80101ee2:	5f                   	pop    %edi
80101ee3:	5d                   	pop    %ebp
80101ee4:	c3                   	ret    
80101ee5:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80101ee8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101eeb:	89 fb                	mov    %edi,%ebx
80101eed:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101ef0:	31 c0                	xor    %eax,%eax
80101ef2:	eb b5                	jmp    80101ea9 <namex+0x129>
80101ef4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101ef8:	83 ec 0c             	sub    $0xc,%esp
80101efb:	56                   	push   %esi
80101efc:	e8 4f f9 ff ff       	call   80101850 <iunlock>
  iput(ip);
80101f01:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f04:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f06:	e8 95 f9 ff ff       	call   801018a0 <iput>
      return 0;
80101f0b:	83 c4 10             	add    $0x10,%esp
}
80101f0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f11:	89 f0                	mov    %esi,%eax
80101f13:	5b                   	pop    %ebx
80101f14:	5e                   	pop    %esi
80101f15:	5f                   	pop    %edi
80101f16:	5d                   	pop    %ebp
80101f17:	c3                   	ret    
80101f18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f1f:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
80101f20:	ba 01 00 00 00       	mov    $0x1,%edx
80101f25:	b8 01 00 00 00       	mov    $0x1,%eax
80101f2a:	89 df                	mov    %ebx,%edi
80101f2c:	e8 1f f4 ff ff       	call   80101350 <iget>
80101f31:	89 c6                	mov    %eax,%esi
80101f33:	e9 9b fe ff ff       	jmp    80101dd3 <namex+0x53>
80101f38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f3f:	90                   	nop
      iunlock(ip);
80101f40:	83 ec 0c             	sub    $0xc,%esp
80101f43:	56                   	push   %esi
80101f44:	e8 07 f9 ff ff       	call   80101850 <iunlock>
      return ip;
80101f49:	83 c4 10             	add    $0x10,%esp
}
80101f4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f4f:	89 f0                	mov    %esi,%eax
80101f51:	5b                   	pop    %ebx
80101f52:	5e                   	pop    %esi
80101f53:	5f                   	pop    %edi
80101f54:	5d                   	pop    %ebp
80101f55:	c3                   	ret    
80101f56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f5d:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
80101f60:	83 ec 0c             	sub    $0xc,%esp
80101f63:	56                   	push   %esi
    return 0;
80101f64:	31 f6                	xor    %esi,%esi
    iput(ip);
80101f66:	e8 35 f9 ff ff       	call   801018a0 <iput>
    return 0;
80101f6b:	83 c4 10             	add    $0x10,%esp
80101f6e:	e9 68 ff ff ff       	jmp    80101edb <namex+0x15b>
80101f73:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101f80 <dirlink>:
{
80101f80:	f3 0f 1e fb          	endbr32 
80101f84:	55                   	push   %ebp
80101f85:	89 e5                	mov    %esp,%ebp
80101f87:	57                   	push   %edi
80101f88:	56                   	push   %esi
80101f89:	53                   	push   %ebx
80101f8a:	83 ec 20             	sub    $0x20,%esp
80101f8d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101f90:	6a 00                	push   $0x0
80101f92:	ff 75 0c             	pushl  0xc(%ebp)
80101f95:	53                   	push   %ebx
80101f96:	e8 25 fd ff ff       	call   80101cc0 <dirlookup>
80101f9b:	83 c4 10             	add    $0x10,%esp
80101f9e:	85 c0                	test   %eax,%eax
80101fa0:	75 6b                	jne    8010200d <dirlink+0x8d>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101fa2:	8b 7b 58             	mov    0x58(%ebx),%edi
80101fa5:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fa8:	85 ff                	test   %edi,%edi
80101faa:	74 2d                	je     80101fd9 <dirlink+0x59>
80101fac:	31 ff                	xor    %edi,%edi
80101fae:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fb1:	eb 0d                	jmp    80101fc0 <dirlink+0x40>
80101fb3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fb7:	90                   	nop
80101fb8:	83 c7 10             	add    $0x10,%edi
80101fbb:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101fbe:	73 19                	jae    80101fd9 <dirlink+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fc0:	6a 10                	push   $0x10
80101fc2:	57                   	push   %edi
80101fc3:	56                   	push   %esi
80101fc4:	53                   	push   %ebx
80101fc5:	e8 a6 fa ff ff       	call   80101a70 <readi>
80101fca:	83 c4 10             	add    $0x10,%esp
80101fcd:	83 f8 10             	cmp    $0x10,%eax
80101fd0:	75 4e                	jne    80102020 <dirlink+0xa0>
    if(de.inum == 0)
80101fd2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101fd7:	75 df                	jne    80101fb8 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
80101fd9:	83 ec 04             	sub    $0x4,%esp
80101fdc:	8d 45 da             	lea    -0x26(%ebp),%eax
80101fdf:	6a 0e                	push   $0xe
80101fe1:	ff 75 0c             	pushl  0xc(%ebp)
80101fe4:	50                   	push   %eax
80101fe5:	e8 46 28 00 00       	call   80104830 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fea:	6a 10                	push   $0x10
  de.inum = inum;
80101fec:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fef:	57                   	push   %edi
80101ff0:	56                   	push   %esi
80101ff1:	53                   	push   %ebx
  de.inum = inum;
80101ff2:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ff6:	e8 75 fb ff ff       	call   80101b70 <writei>
80101ffb:	83 c4 20             	add    $0x20,%esp
80101ffe:	83 f8 10             	cmp    $0x10,%eax
80102001:	75 2a                	jne    8010202d <dirlink+0xad>
  return 0;
80102003:	31 c0                	xor    %eax,%eax
}
80102005:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102008:	5b                   	pop    %ebx
80102009:	5e                   	pop    %esi
8010200a:	5f                   	pop    %edi
8010200b:	5d                   	pop    %ebp
8010200c:	c3                   	ret    
    iput(ip);
8010200d:	83 ec 0c             	sub    $0xc,%esp
80102010:	50                   	push   %eax
80102011:	e8 8a f8 ff ff       	call   801018a0 <iput>
    return -1;
80102016:	83 c4 10             	add    $0x10,%esp
80102019:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010201e:	eb e5                	jmp    80102005 <dirlink+0x85>
      panic("dirlink read");
80102020:	83 ec 0c             	sub    $0xc,%esp
80102023:	68 88 75 10 80       	push   $0x80107588
80102028:	e8 63 e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
8010202d:	83 ec 0c             	sub    $0xc,%esp
80102030:	68 6e 7b 10 80       	push   $0x80107b6e
80102035:	e8 56 e3 ff ff       	call   80100390 <panic>
8010203a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102040 <namei>:

struct inode*
namei(char *path)
{
80102040:	f3 0f 1e fb          	endbr32 
80102044:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102045:	31 d2                	xor    %edx,%edx
{
80102047:	89 e5                	mov    %esp,%ebp
80102049:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
8010204c:	8b 45 08             	mov    0x8(%ebp),%eax
8010204f:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80102052:	e8 29 fd ff ff       	call   80101d80 <namex>
}
80102057:	c9                   	leave  
80102058:	c3                   	ret    
80102059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102060 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102060:	f3 0f 1e fb          	endbr32 
80102064:	55                   	push   %ebp
  return namex(path, 1, name);
80102065:	ba 01 00 00 00       	mov    $0x1,%edx
{
8010206a:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
8010206c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010206f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102072:	5d                   	pop    %ebp
  return namex(path, 1, name);
80102073:	e9 08 fd ff ff       	jmp    80101d80 <namex>
80102078:	66 90                	xchg   %ax,%ax
8010207a:	66 90                	xchg   %ax,%ax
8010207c:	66 90                	xchg   %ax,%ax
8010207e:	66 90                	xchg   %ax,%ax

80102080 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102080:	55                   	push   %ebp
80102081:	89 e5                	mov    %esp,%ebp
80102083:	57                   	push   %edi
80102084:	56                   	push   %esi
80102085:	53                   	push   %ebx
80102086:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102089:	85 c0                	test   %eax,%eax
8010208b:	0f 84 b4 00 00 00    	je     80102145 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102091:	8b 70 08             	mov    0x8(%eax),%esi
80102094:	89 c3                	mov    %eax,%ebx
80102096:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010209c:	0f 87 96 00 00 00    	ja     80102138 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020a2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801020a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020ae:	66 90                	xchg   %ax,%ax
801020b0:	89 ca                	mov    %ecx,%edx
801020b2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020b3:	83 e0 c0             	and    $0xffffffc0,%eax
801020b6:	3c 40                	cmp    $0x40,%al
801020b8:	75 f6                	jne    801020b0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020ba:	31 ff                	xor    %edi,%edi
801020bc:	ba f6 03 00 00       	mov    $0x3f6,%edx
801020c1:	89 f8                	mov    %edi,%eax
801020c3:	ee                   	out    %al,(%dx)
801020c4:	b8 01 00 00 00       	mov    $0x1,%eax
801020c9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801020ce:	ee                   	out    %al,(%dx)
801020cf:	ba f3 01 00 00       	mov    $0x1f3,%edx
801020d4:	89 f0                	mov    %esi,%eax
801020d6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801020d7:	89 f0                	mov    %esi,%eax
801020d9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801020de:	c1 f8 08             	sar    $0x8,%eax
801020e1:	ee                   	out    %al,(%dx)
801020e2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801020e7:	89 f8                	mov    %edi,%eax
801020e9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801020ea:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
801020ee:	ba f6 01 00 00       	mov    $0x1f6,%edx
801020f3:	c1 e0 04             	shl    $0x4,%eax
801020f6:	83 e0 10             	and    $0x10,%eax
801020f9:	83 c8 e0             	or     $0xffffffe0,%eax
801020fc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801020fd:	f6 03 04             	testb  $0x4,(%ebx)
80102100:	75 16                	jne    80102118 <idestart+0x98>
80102102:	b8 20 00 00 00       	mov    $0x20,%eax
80102107:	89 ca                	mov    %ecx,%edx
80102109:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010210a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010210d:	5b                   	pop    %ebx
8010210e:	5e                   	pop    %esi
8010210f:	5f                   	pop    %edi
80102110:	5d                   	pop    %ebp
80102111:	c3                   	ret    
80102112:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102118:	b8 30 00 00 00       	mov    $0x30,%eax
8010211d:	89 ca                	mov    %ecx,%edx
8010211f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102120:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102125:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102128:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010212d:	fc                   	cld    
8010212e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102130:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102133:	5b                   	pop    %ebx
80102134:	5e                   	pop    %esi
80102135:	5f                   	pop    %edi
80102136:	5d                   	pop    %ebp
80102137:	c3                   	ret    
    panic("incorrect blockno");
80102138:	83 ec 0c             	sub    $0xc,%esp
8010213b:	68 f4 75 10 80       	push   $0x801075f4
80102140:	e8 4b e2 ff ff       	call   80100390 <panic>
    panic("idestart");
80102145:	83 ec 0c             	sub    $0xc,%esp
80102148:	68 eb 75 10 80       	push   $0x801075eb
8010214d:	e8 3e e2 ff ff       	call   80100390 <panic>
80102152:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102160 <ideinit>:
{
80102160:	f3 0f 1e fb          	endbr32 
80102164:	55                   	push   %ebp
80102165:	89 e5                	mov    %esp,%ebp
80102167:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
8010216a:	68 06 76 10 80       	push   $0x80107606
8010216f:	68 80 a5 10 80       	push   $0x8010a580
80102174:	e8 c7 22 00 00       	call   80104440 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102179:	58                   	pop    %eax
8010217a:	a1 00 2d 11 80       	mov    0x80112d00,%eax
8010217f:	5a                   	pop    %edx
80102180:	83 e8 01             	sub    $0x1,%eax
80102183:	50                   	push   %eax
80102184:	6a 0e                	push   $0xe
80102186:	e8 b5 02 00 00       	call   80102440 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
8010218b:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010218e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102193:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102197:	90                   	nop
80102198:	ec                   	in     (%dx),%al
80102199:	83 e0 c0             	and    $0xffffffc0,%eax
8010219c:	3c 40                	cmp    $0x40,%al
8010219e:	75 f8                	jne    80102198 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021a0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801021a5:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021aa:	ee                   	out    %al,(%dx)
801021ab:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021b0:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021b5:	eb 0e                	jmp    801021c5 <ideinit+0x65>
801021b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021be:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
801021c0:	83 e9 01             	sub    $0x1,%ecx
801021c3:	74 0f                	je     801021d4 <ideinit+0x74>
801021c5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801021c6:	84 c0                	test   %al,%al
801021c8:	74 f6                	je     801021c0 <ideinit+0x60>
      havedisk1 = 1;
801021ca:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
801021d1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021d4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801021d9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021de:	ee                   	out    %al,(%dx)
}
801021df:	c9                   	leave  
801021e0:	c3                   	ret    
801021e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021ef:	90                   	nop

801021f0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801021f0:	f3 0f 1e fb          	endbr32 
801021f4:	55                   	push   %ebp
801021f5:	89 e5                	mov    %esp,%ebp
801021f7:	57                   	push   %edi
801021f8:	56                   	push   %esi
801021f9:	53                   	push   %ebx
801021fa:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801021fd:	68 80 a5 10 80       	push   $0x8010a580
80102202:	e8 b9 23 00 00       	call   801045c0 <acquire>

  if((b = idequeue) == 0){
80102207:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
8010220d:	83 c4 10             	add    $0x10,%esp
80102210:	85 db                	test   %ebx,%ebx
80102212:	74 5f                	je     80102273 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102214:	8b 43 58             	mov    0x58(%ebx),%eax
80102217:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010221c:	8b 33                	mov    (%ebx),%esi
8010221e:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102224:	75 2b                	jne    80102251 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102226:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010222b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010222f:	90                   	nop
80102230:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102231:	89 c1                	mov    %eax,%ecx
80102233:	83 e1 c0             	and    $0xffffffc0,%ecx
80102236:	80 f9 40             	cmp    $0x40,%cl
80102239:	75 f5                	jne    80102230 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010223b:	a8 21                	test   $0x21,%al
8010223d:	75 12                	jne    80102251 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010223f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102242:	b9 80 00 00 00       	mov    $0x80,%ecx
80102247:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010224c:	fc                   	cld    
8010224d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010224f:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102251:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102254:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102257:	83 ce 02             	or     $0x2,%esi
8010225a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010225c:	53                   	push   %ebx
8010225d:	e8 de 1e 00 00       	call   80104140 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102262:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80102267:	83 c4 10             	add    $0x10,%esp
8010226a:	85 c0                	test   %eax,%eax
8010226c:	74 05                	je     80102273 <ideintr+0x83>
    idestart(idequeue);
8010226e:	e8 0d fe ff ff       	call   80102080 <idestart>
    release(&idelock);
80102273:	83 ec 0c             	sub    $0xc,%esp
80102276:	68 80 a5 10 80       	push   $0x8010a580
8010227b:	e8 00 24 00 00       	call   80104680 <release>

  release(&idelock);
}
80102280:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102283:	5b                   	pop    %ebx
80102284:	5e                   	pop    %esi
80102285:	5f                   	pop    %edi
80102286:	5d                   	pop    %ebp
80102287:	c3                   	ret    
80102288:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010228f:	90                   	nop

80102290 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102290:	f3 0f 1e fb          	endbr32 
80102294:	55                   	push   %ebp
80102295:	89 e5                	mov    %esp,%ebp
80102297:	53                   	push   %ebx
80102298:	83 ec 10             	sub    $0x10,%esp
8010229b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010229e:	8d 43 0c             	lea    0xc(%ebx),%eax
801022a1:	50                   	push   %eax
801022a2:	e8 39 21 00 00       	call   801043e0 <holdingsleep>
801022a7:	83 c4 10             	add    $0x10,%esp
801022aa:	85 c0                	test   %eax,%eax
801022ac:	0f 84 cf 00 00 00    	je     80102381 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022b2:	8b 03                	mov    (%ebx),%eax
801022b4:	83 e0 06             	and    $0x6,%eax
801022b7:	83 f8 02             	cmp    $0x2,%eax
801022ba:	0f 84 b4 00 00 00    	je     80102374 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801022c0:	8b 53 04             	mov    0x4(%ebx),%edx
801022c3:	85 d2                	test   %edx,%edx
801022c5:	74 0d                	je     801022d4 <iderw+0x44>
801022c7:	a1 60 a5 10 80       	mov    0x8010a560,%eax
801022cc:	85 c0                	test   %eax,%eax
801022ce:	0f 84 93 00 00 00    	je     80102367 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801022d4:	83 ec 0c             	sub    $0xc,%esp
801022d7:	68 80 a5 10 80       	push   $0x8010a580
801022dc:	e8 df 22 00 00       	call   801045c0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022e1:	a1 64 a5 10 80       	mov    0x8010a564,%eax
  b->qnext = 0;
801022e6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022ed:	83 c4 10             	add    $0x10,%esp
801022f0:	85 c0                	test   %eax,%eax
801022f2:	74 6c                	je     80102360 <iderw+0xd0>
801022f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801022f8:	89 c2                	mov    %eax,%edx
801022fa:	8b 40 58             	mov    0x58(%eax),%eax
801022fd:	85 c0                	test   %eax,%eax
801022ff:	75 f7                	jne    801022f8 <iderw+0x68>
80102301:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102304:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102306:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
8010230c:	74 42                	je     80102350 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010230e:	8b 03                	mov    (%ebx),%eax
80102310:	83 e0 06             	and    $0x6,%eax
80102313:	83 f8 02             	cmp    $0x2,%eax
80102316:	74 23                	je     8010233b <iderw+0xab>
80102318:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010231f:	90                   	nop
    sleep(b, &idelock);
80102320:	83 ec 08             	sub    $0x8,%esp
80102323:	68 80 a5 10 80       	push   $0x8010a580
80102328:	53                   	push   %ebx
80102329:	e8 52 1c 00 00       	call   80103f80 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010232e:	8b 03                	mov    (%ebx),%eax
80102330:	83 c4 10             	add    $0x10,%esp
80102333:	83 e0 06             	and    $0x6,%eax
80102336:	83 f8 02             	cmp    $0x2,%eax
80102339:	75 e5                	jne    80102320 <iderw+0x90>
  }


  release(&idelock);
8010233b:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
80102342:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102345:	c9                   	leave  
  release(&idelock);
80102346:	e9 35 23 00 00       	jmp    80104680 <release>
8010234b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010234f:	90                   	nop
    idestart(b);
80102350:	89 d8                	mov    %ebx,%eax
80102352:	e8 29 fd ff ff       	call   80102080 <idestart>
80102357:	eb b5                	jmp    8010230e <iderw+0x7e>
80102359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102360:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80102365:	eb 9d                	jmp    80102304 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
80102367:	83 ec 0c             	sub    $0xc,%esp
8010236a:	68 35 76 10 80       	push   $0x80107635
8010236f:	e8 1c e0 ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102374:	83 ec 0c             	sub    $0xc,%esp
80102377:	68 20 76 10 80       	push   $0x80107620
8010237c:	e8 0f e0 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102381:	83 ec 0c             	sub    $0xc,%esp
80102384:	68 0a 76 10 80       	push   $0x8010760a
80102389:	e8 02 e0 ff ff       	call   80100390 <panic>
8010238e:	66 90                	xchg   %ax,%ax

80102390 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102390:	f3 0f 1e fb          	endbr32 
80102394:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102395:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
8010239c:	00 c0 fe 
{
8010239f:	89 e5                	mov    %esp,%ebp
801023a1:	56                   	push   %esi
801023a2:	53                   	push   %ebx
  ioapic->reg = reg;
801023a3:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023aa:	00 00 00 
  return ioapic->data;
801023ad:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801023b3:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023b6:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023bc:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023c2:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801023c9:	c1 ee 10             	shr    $0x10,%esi
801023cc:	89 f0                	mov    %esi,%eax
801023ce:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801023d1:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
801023d4:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801023d7:	39 c2                	cmp    %eax,%edx
801023d9:	74 16                	je     801023f1 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801023db:	83 ec 0c             	sub    $0xc,%esp
801023de:	68 54 76 10 80       	push   $0x80107654
801023e3:	e8 c8 e2 ff ff       	call   801006b0 <cprintf>
801023e8:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
801023ee:	83 c4 10             	add    $0x10,%esp
801023f1:	83 c6 21             	add    $0x21,%esi
{
801023f4:	ba 10 00 00 00       	mov    $0x10,%edx
801023f9:	b8 20 00 00 00       	mov    $0x20,%eax
801023fe:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
80102400:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102402:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102404:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010240a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010240d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102413:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102416:	8d 5a 01             	lea    0x1(%edx),%ebx
80102419:	83 c2 02             	add    $0x2,%edx
8010241c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010241e:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102424:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010242b:	39 f0                	cmp    %esi,%eax
8010242d:	75 d1                	jne    80102400 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010242f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102432:	5b                   	pop    %ebx
80102433:	5e                   	pop    %esi
80102434:	5d                   	pop    %ebp
80102435:	c3                   	ret    
80102436:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010243d:	8d 76 00             	lea    0x0(%esi),%esi

80102440 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102440:	f3 0f 1e fb          	endbr32 
80102444:	55                   	push   %ebp
  ioapic->reg = reg;
80102445:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
8010244b:	89 e5                	mov    %esp,%ebp
8010244d:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102450:	8d 50 20             	lea    0x20(%eax),%edx
80102453:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102457:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102459:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010245f:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102462:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102465:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102468:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
8010246a:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010246f:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102472:	89 50 10             	mov    %edx,0x10(%eax)
}
80102475:	5d                   	pop    %ebp
80102476:	c3                   	ret    
80102477:	66 90                	xchg   %ax,%ax
80102479:	66 90                	xchg   %ax,%ax
8010247b:	66 90                	xchg   %ax,%ax
8010247d:	66 90                	xchg   %ax,%ax
8010247f:	90                   	nop

80102480 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102480:	f3 0f 1e fb          	endbr32 
80102484:	55                   	push   %ebp
80102485:	89 e5                	mov    %esp,%ebp
80102487:	53                   	push   %ebx
80102488:	83 ec 04             	sub    $0x4,%esp
8010248b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010248e:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102494:	75 7a                	jne    80102510 <kfree+0x90>
80102496:	81 fb a8 55 11 80    	cmp    $0x801155a8,%ebx
8010249c:	72 72                	jb     80102510 <kfree+0x90>
8010249e:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801024a4:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801024a9:	77 65                	ja     80102510 <kfree+0x90>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801024ab:	83 ec 04             	sub    $0x4,%esp
801024ae:	68 00 10 00 00       	push   $0x1000
801024b3:	6a 01                	push   $0x1
801024b5:	53                   	push   %ebx
801024b6:	e8 15 22 00 00       	call   801046d0 <memset>

  if(kmem.use_lock)
801024bb:	8b 15 74 26 11 80    	mov    0x80112674,%edx
801024c1:	83 c4 10             	add    $0x10,%esp
801024c4:	85 d2                	test   %edx,%edx
801024c6:	75 20                	jne    801024e8 <kfree+0x68>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801024c8:	a1 78 26 11 80       	mov    0x80112678,%eax
801024cd:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801024cf:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
801024d4:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
801024da:	85 c0                	test   %eax,%eax
801024dc:	75 22                	jne    80102500 <kfree+0x80>
    release(&kmem.lock);
}
801024de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024e1:	c9                   	leave  
801024e2:	c3                   	ret    
801024e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024e7:	90                   	nop
    acquire(&kmem.lock);
801024e8:	83 ec 0c             	sub    $0xc,%esp
801024eb:	68 40 26 11 80       	push   $0x80112640
801024f0:	e8 cb 20 00 00       	call   801045c0 <acquire>
801024f5:	83 c4 10             	add    $0x10,%esp
801024f8:	eb ce                	jmp    801024c8 <kfree+0x48>
801024fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102500:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
80102507:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010250a:	c9                   	leave  
    release(&kmem.lock);
8010250b:	e9 70 21 00 00       	jmp    80104680 <release>
    panic("kfree");
80102510:	83 ec 0c             	sub    $0xc,%esp
80102513:	68 86 76 10 80       	push   $0x80107686
80102518:	e8 73 de ff ff       	call   80100390 <panic>
8010251d:	8d 76 00             	lea    0x0(%esi),%esi

80102520 <freerange>:
{
80102520:	f3 0f 1e fb          	endbr32 
80102524:	55                   	push   %ebp
80102525:	89 e5                	mov    %esp,%ebp
80102527:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102528:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010252b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010252e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010252f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102535:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010253b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102541:	39 de                	cmp    %ebx,%esi
80102543:	72 1f                	jb     80102564 <freerange+0x44>
80102545:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102548:	83 ec 0c             	sub    $0xc,%esp
8010254b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102551:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102557:	50                   	push   %eax
80102558:	e8 23 ff ff ff       	call   80102480 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010255d:	83 c4 10             	add    $0x10,%esp
80102560:	39 f3                	cmp    %esi,%ebx
80102562:	76 e4                	jbe    80102548 <freerange+0x28>
}
80102564:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102567:	5b                   	pop    %ebx
80102568:	5e                   	pop    %esi
80102569:	5d                   	pop    %ebp
8010256a:	c3                   	ret    
8010256b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010256f:	90                   	nop

80102570 <kinit1>:
{
80102570:	f3 0f 1e fb          	endbr32 
80102574:	55                   	push   %ebp
80102575:	89 e5                	mov    %esp,%ebp
80102577:	56                   	push   %esi
80102578:	53                   	push   %ebx
80102579:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
8010257c:	83 ec 08             	sub    $0x8,%esp
8010257f:	68 8c 76 10 80       	push   $0x8010768c
80102584:	68 40 26 11 80       	push   $0x80112640
80102589:	e8 b2 1e 00 00       	call   80104440 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010258e:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102591:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102594:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
8010259b:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010259e:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025a4:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025aa:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025b0:	39 de                	cmp    %ebx,%esi
801025b2:	72 20                	jb     801025d4 <kinit1+0x64>
801025b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025b8:	83 ec 0c             	sub    $0xc,%esp
801025bb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025c1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025c7:	50                   	push   %eax
801025c8:	e8 b3 fe ff ff       	call   80102480 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025cd:	83 c4 10             	add    $0x10,%esp
801025d0:	39 de                	cmp    %ebx,%esi
801025d2:	73 e4                	jae    801025b8 <kinit1+0x48>
}
801025d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025d7:	5b                   	pop    %ebx
801025d8:	5e                   	pop    %esi
801025d9:	5d                   	pop    %ebp
801025da:	c3                   	ret    
801025db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025df:	90                   	nop

801025e0 <kinit2>:
{
801025e0:	f3 0f 1e fb          	endbr32 
801025e4:	55                   	push   %ebp
801025e5:	89 e5                	mov    %esp,%ebp
801025e7:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801025e8:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025eb:	8b 75 0c             	mov    0xc(%ebp),%esi
801025ee:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025ef:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025f5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025fb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102601:	39 de                	cmp    %ebx,%esi
80102603:	72 1f                	jb     80102624 <kinit2+0x44>
80102605:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102608:	83 ec 0c             	sub    $0xc,%esp
8010260b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102611:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102617:	50                   	push   %eax
80102618:	e8 63 fe ff ff       	call   80102480 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010261d:	83 c4 10             	add    $0x10,%esp
80102620:	39 de                	cmp    %ebx,%esi
80102622:	73 e4                	jae    80102608 <kinit2+0x28>
  kmem.use_lock = 1;
80102624:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
8010262b:	00 00 00 
}
8010262e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102631:	5b                   	pop    %ebx
80102632:	5e                   	pop    %esi
80102633:	5d                   	pop    %ebp
80102634:	c3                   	ret    
80102635:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010263c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102640 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102640:	f3 0f 1e fb          	endbr32 
  struct run *r;

  if(kmem.use_lock)
80102644:	a1 74 26 11 80       	mov    0x80112674,%eax
80102649:	85 c0                	test   %eax,%eax
8010264b:	75 1b                	jne    80102668 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
8010264d:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
80102652:	85 c0                	test   %eax,%eax
80102654:	74 0a                	je     80102660 <kalloc+0x20>
    kmem.freelist = r->next;
80102656:	8b 10                	mov    (%eax),%edx
80102658:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
8010265e:	c3                   	ret    
8010265f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102660:	c3                   	ret    
80102661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102668:	55                   	push   %ebp
80102669:	89 e5                	mov    %esp,%ebp
8010266b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010266e:	68 40 26 11 80       	push   $0x80112640
80102673:	e8 48 1f 00 00       	call   801045c0 <acquire>
  r = kmem.freelist;
80102678:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
8010267d:	8b 15 74 26 11 80    	mov    0x80112674,%edx
80102683:	83 c4 10             	add    $0x10,%esp
80102686:	85 c0                	test   %eax,%eax
80102688:	74 08                	je     80102692 <kalloc+0x52>
    kmem.freelist = r->next;
8010268a:	8b 08                	mov    (%eax),%ecx
8010268c:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
  if(kmem.use_lock)
80102692:	85 d2                	test   %edx,%edx
80102694:	74 16                	je     801026ac <kalloc+0x6c>
    release(&kmem.lock);
80102696:	83 ec 0c             	sub    $0xc,%esp
80102699:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010269c:	68 40 26 11 80       	push   $0x80112640
801026a1:	e8 da 1f 00 00       	call   80104680 <release>
  return (char*)r;
801026a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801026a9:	83 c4 10             	add    $0x10,%esp
}
801026ac:	c9                   	leave  
801026ad:	c3                   	ret    
801026ae:	66 90                	xchg   %ax,%ax

801026b0 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
801026b0:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026b4:	ba 64 00 00 00       	mov    $0x64,%edx
801026b9:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801026ba:	a8 01                	test   $0x1,%al
801026bc:	0f 84 be 00 00 00    	je     80102780 <kbdgetc+0xd0>
{
801026c2:	55                   	push   %ebp
801026c3:	ba 60 00 00 00       	mov    $0x60,%edx
801026c8:	89 e5                	mov    %esp,%ebp
801026ca:	53                   	push   %ebx
801026cb:	ec                   	in     (%dx),%al
  return data;
801026cc:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
    return -1;
  data = inb(KBDATAP);
801026d2:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
801026d5:	3c e0                	cmp    $0xe0,%al
801026d7:	74 57                	je     80102730 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801026d9:	89 d9                	mov    %ebx,%ecx
801026db:	83 e1 40             	and    $0x40,%ecx
801026de:	84 c0                	test   %al,%al
801026e0:	78 5e                	js     80102740 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801026e2:	85 c9                	test   %ecx,%ecx
801026e4:	74 09                	je     801026ef <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801026e6:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801026e9:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
801026ec:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
801026ef:	0f b6 8a c0 77 10 80 	movzbl -0x7fef8840(%edx),%ecx
  shift ^= togglecode[data];
801026f6:	0f b6 82 c0 76 10 80 	movzbl -0x7fef8940(%edx),%eax
  shift |= shiftcode[data];
801026fd:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
801026ff:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102701:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102703:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102709:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010270c:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
8010270f:	8b 04 85 a0 76 10 80 	mov    -0x7fef8960(,%eax,4),%eax
80102716:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010271a:	74 0b                	je     80102727 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
8010271c:	8d 50 9f             	lea    -0x61(%eax),%edx
8010271f:	83 fa 19             	cmp    $0x19,%edx
80102722:	77 44                	ja     80102768 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102724:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102727:	5b                   	pop    %ebx
80102728:	5d                   	pop    %ebp
80102729:	c3                   	ret    
8010272a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102730:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102733:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102735:	89 1d b4 a5 10 80    	mov    %ebx,0x8010a5b4
}
8010273b:	5b                   	pop    %ebx
8010273c:	5d                   	pop    %ebp
8010273d:	c3                   	ret    
8010273e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102740:	83 e0 7f             	and    $0x7f,%eax
80102743:	85 c9                	test   %ecx,%ecx
80102745:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102748:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010274a:	0f b6 8a c0 77 10 80 	movzbl -0x7fef8840(%edx),%ecx
80102751:	83 c9 40             	or     $0x40,%ecx
80102754:	0f b6 c9             	movzbl %cl,%ecx
80102757:	f7 d1                	not    %ecx
80102759:	21 d9                	and    %ebx,%ecx
}
8010275b:	5b                   	pop    %ebx
8010275c:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
8010275d:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
}
80102763:	c3                   	ret    
80102764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102768:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010276b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010276e:	5b                   	pop    %ebx
8010276f:	5d                   	pop    %ebp
      c += 'a' - 'A';
80102770:	83 f9 1a             	cmp    $0x1a,%ecx
80102773:	0f 42 c2             	cmovb  %edx,%eax
}
80102776:	c3                   	ret    
80102777:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010277e:	66 90                	xchg   %ax,%ax
    return -1;
80102780:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102785:	c3                   	ret    
80102786:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010278d:	8d 76 00             	lea    0x0(%esi),%esi

80102790 <kbdintr>:

void
kbdintr(void)
{
80102790:	f3 0f 1e fb          	endbr32 
80102794:	55                   	push   %ebp
80102795:	89 e5                	mov    %esp,%ebp
80102797:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
8010279a:	68 b0 26 10 80       	push   $0x801026b0
8010279f:	e8 bc e0 ff ff       	call   80100860 <consoleintr>
}
801027a4:	83 c4 10             	add    $0x10,%esp
801027a7:	c9                   	leave  
801027a8:	c3                   	ret    
801027a9:	66 90                	xchg   %ax,%ax
801027ab:	66 90                	xchg   %ax,%ax
801027ad:	66 90                	xchg   %ax,%ax
801027af:	90                   	nop

801027b0 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
801027b0:	f3 0f 1e fb          	endbr32 
  if(!lapic)
801027b4:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801027b9:	85 c0                	test   %eax,%eax
801027bb:	0f 84 c7 00 00 00    	je     80102888 <lapicinit+0xd8>
  lapic[index] = value;
801027c1:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801027c8:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027cb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027ce:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801027d5:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027d8:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027db:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801027e2:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801027e5:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027e8:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801027ef:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801027f2:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027f5:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801027fc:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801027ff:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102802:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102809:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010280c:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010280f:	8b 50 30             	mov    0x30(%eax),%edx
80102812:	c1 ea 10             	shr    $0x10,%edx
80102815:	81 e2 fc 00 00 00    	and    $0xfc,%edx
8010281b:	75 73                	jne    80102890 <lapicinit+0xe0>
  lapic[index] = value;
8010281d:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102824:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102827:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010282a:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102831:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102834:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102837:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010283e:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102841:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102844:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
8010284b:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010284e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102851:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102858:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010285b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010285e:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102865:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102868:	8b 50 20             	mov    0x20(%eax),%edx
8010286b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010286f:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102870:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102876:	80 e6 10             	and    $0x10,%dh
80102879:	75 f5                	jne    80102870 <lapicinit+0xc0>
  lapic[index] = value;
8010287b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102882:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102885:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102888:	c3                   	ret    
80102889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102890:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102897:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010289a:	8b 50 20             	mov    0x20(%eax),%edx
}
8010289d:	e9 7b ff ff ff       	jmp    8010281d <lapicinit+0x6d>
801028a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801028b0 <lapicid>:

int
lapicid(void)
{
801028b0:	f3 0f 1e fb          	endbr32 
  if (!lapic)
801028b4:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801028b9:	85 c0                	test   %eax,%eax
801028bb:	74 0b                	je     801028c8 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
801028bd:	8b 40 20             	mov    0x20(%eax),%eax
801028c0:	c1 e8 18             	shr    $0x18,%eax
801028c3:	c3                   	ret    
801028c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
801028c8:	31 c0                	xor    %eax,%eax
}
801028ca:	c3                   	ret    
801028cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028cf:	90                   	nop

801028d0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
801028d0:	f3 0f 1e fb          	endbr32 
  if(lapic)
801028d4:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801028d9:	85 c0                	test   %eax,%eax
801028db:	74 0d                	je     801028ea <lapiceoi+0x1a>
  lapic[index] = value;
801028dd:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801028e4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028e7:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801028ea:	c3                   	ret    
801028eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028ef:	90                   	nop

801028f0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801028f0:	f3 0f 1e fb          	endbr32 
}
801028f4:	c3                   	ret    
801028f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102900 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102900:	f3 0f 1e fb          	endbr32 
80102904:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102905:	b8 0f 00 00 00       	mov    $0xf,%eax
8010290a:	ba 70 00 00 00       	mov    $0x70,%edx
8010290f:	89 e5                	mov    %esp,%ebp
80102911:	53                   	push   %ebx
80102912:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102915:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102918:	ee                   	out    %al,(%dx)
80102919:	b8 0a 00 00 00       	mov    $0xa,%eax
8010291e:	ba 71 00 00 00       	mov    $0x71,%edx
80102923:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102924:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102926:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102929:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010292f:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102931:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102934:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102936:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102939:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
8010293c:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102942:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102947:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010294d:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102950:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102957:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010295a:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010295d:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102964:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102967:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010296a:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102970:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102973:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102979:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010297c:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102982:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102985:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
8010298b:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
8010298c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010298f:	5d                   	pop    %ebp
80102990:	c3                   	ret    
80102991:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102998:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010299f:	90                   	nop

801029a0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801029a0:	f3 0f 1e fb          	endbr32 
801029a4:	55                   	push   %ebp
801029a5:	b8 0b 00 00 00       	mov    $0xb,%eax
801029aa:	ba 70 00 00 00       	mov    $0x70,%edx
801029af:	89 e5                	mov    %esp,%ebp
801029b1:	57                   	push   %edi
801029b2:	56                   	push   %esi
801029b3:	53                   	push   %ebx
801029b4:	83 ec 4c             	sub    $0x4c,%esp
801029b7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029b8:	ba 71 00 00 00       	mov    $0x71,%edx
801029bd:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801029be:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029c1:	bb 70 00 00 00       	mov    $0x70,%ebx
801029c6:	88 45 b3             	mov    %al,-0x4d(%ebp)
801029c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029d0:	31 c0                	xor    %eax,%eax
801029d2:	89 da                	mov    %ebx,%edx
801029d4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029d5:	b9 71 00 00 00       	mov    $0x71,%ecx
801029da:	89 ca                	mov    %ecx,%edx
801029dc:	ec                   	in     (%dx),%al
801029dd:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029e0:	89 da                	mov    %ebx,%edx
801029e2:	b8 02 00 00 00       	mov    $0x2,%eax
801029e7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029e8:	89 ca                	mov    %ecx,%edx
801029ea:	ec                   	in     (%dx),%al
801029eb:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029ee:	89 da                	mov    %ebx,%edx
801029f0:	b8 04 00 00 00       	mov    $0x4,%eax
801029f5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029f6:	89 ca                	mov    %ecx,%edx
801029f8:	ec                   	in     (%dx),%al
801029f9:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029fc:	89 da                	mov    %ebx,%edx
801029fe:	b8 07 00 00 00       	mov    $0x7,%eax
80102a03:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a04:	89 ca                	mov    %ecx,%edx
80102a06:	ec                   	in     (%dx),%al
80102a07:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a0a:	89 da                	mov    %ebx,%edx
80102a0c:	b8 08 00 00 00       	mov    $0x8,%eax
80102a11:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a12:	89 ca                	mov    %ecx,%edx
80102a14:	ec                   	in     (%dx),%al
80102a15:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a17:	89 da                	mov    %ebx,%edx
80102a19:	b8 09 00 00 00       	mov    $0x9,%eax
80102a1e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a1f:	89 ca                	mov    %ecx,%edx
80102a21:	ec                   	in     (%dx),%al
80102a22:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a24:	89 da                	mov    %ebx,%edx
80102a26:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a2b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a2c:	89 ca                	mov    %ecx,%edx
80102a2e:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a2f:	84 c0                	test   %al,%al
80102a31:	78 9d                	js     801029d0 <cmostime+0x30>
  return inb(CMOS_RETURN);
80102a33:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a37:	89 fa                	mov    %edi,%edx
80102a39:	0f b6 fa             	movzbl %dl,%edi
80102a3c:	89 f2                	mov    %esi,%edx
80102a3e:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a41:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a45:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a48:	89 da                	mov    %ebx,%edx
80102a4a:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102a4d:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a50:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a54:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102a57:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a5a:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a5e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a61:	31 c0                	xor    %eax,%eax
80102a63:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a64:	89 ca                	mov    %ecx,%edx
80102a66:	ec                   	in     (%dx),%al
80102a67:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a6a:	89 da                	mov    %ebx,%edx
80102a6c:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102a6f:	b8 02 00 00 00       	mov    $0x2,%eax
80102a74:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a75:	89 ca                	mov    %ecx,%edx
80102a77:	ec                   	in     (%dx),%al
80102a78:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a7b:	89 da                	mov    %ebx,%edx
80102a7d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102a80:	b8 04 00 00 00       	mov    $0x4,%eax
80102a85:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a86:	89 ca                	mov    %ecx,%edx
80102a88:	ec                   	in     (%dx),%al
80102a89:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a8c:	89 da                	mov    %ebx,%edx
80102a8e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102a91:	b8 07 00 00 00       	mov    $0x7,%eax
80102a96:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a97:	89 ca                	mov    %ecx,%edx
80102a99:	ec                   	in     (%dx),%al
80102a9a:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a9d:	89 da                	mov    %ebx,%edx
80102a9f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102aa2:	b8 08 00 00 00       	mov    $0x8,%eax
80102aa7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aa8:	89 ca                	mov    %ecx,%edx
80102aaa:	ec                   	in     (%dx),%al
80102aab:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aae:	89 da                	mov    %ebx,%edx
80102ab0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102ab3:	b8 09 00 00 00       	mov    $0x9,%eax
80102ab8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ab9:	89 ca                	mov    %ecx,%edx
80102abb:	ec                   	in     (%dx),%al
80102abc:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102abf:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102ac2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ac5:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102ac8:	6a 18                	push   $0x18
80102aca:	50                   	push   %eax
80102acb:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102ace:	50                   	push   %eax
80102acf:	e8 4c 1c 00 00       	call   80104720 <memcmp>
80102ad4:	83 c4 10             	add    $0x10,%esp
80102ad7:	85 c0                	test   %eax,%eax
80102ad9:	0f 85 f1 fe ff ff    	jne    801029d0 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102adf:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102ae3:	75 78                	jne    80102b5d <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102ae5:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102ae8:	89 c2                	mov    %eax,%edx
80102aea:	83 e0 0f             	and    $0xf,%eax
80102aed:	c1 ea 04             	shr    $0x4,%edx
80102af0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102af3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102af6:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102af9:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102afc:	89 c2                	mov    %eax,%edx
80102afe:	83 e0 0f             	and    $0xf,%eax
80102b01:	c1 ea 04             	shr    $0x4,%edx
80102b04:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b07:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b0a:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b0d:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b10:	89 c2                	mov    %eax,%edx
80102b12:	83 e0 0f             	and    $0xf,%eax
80102b15:	c1 ea 04             	shr    $0x4,%edx
80102b18:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b1b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b1e:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b21:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b24:	89 c2                	mov    %eax,%edx
80102b26:	83 e0 0f             	and    $0xf,%eax
80102b29:	c1 ea 04             	shr    $0x4,%edx
80102b2c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b2f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b32:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b35:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b38:	89 c2                	mov    %eax,%edx
80102b3a:	83 e0 0f             	and    $0xf,%eax
80102b3d:	c1 ea 04             	shr    $0x4,%edx
80102b40:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b43:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b46:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b49:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b4c:	89 c2                	mov    %eax,%edx
80102b4e:	83 e0 0f             	and    $0xf,%eax
80102b51:	c1 ea 04             	shr    $0x4,%edx
80102b54:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b57:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b5a:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b5d:	8b 75 08             	mov    0x8(%ebp),%esi
80102b60:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b63:	89 06                	mov    %eax,(%esi)
80102b65:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b68:	89 46 04             	mov    %eax,0x4(%esi)
80102b6b:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b6e:	89 46 08             	mov    %eax,0x8(%esi)
80102b71:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b74:	89 46 0c             	mov    %eax,0xc(%esi)
80102b77:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b7a:	89 46 10             	mov    %eax,0x10(%esi)
80102b7d:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b80:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102b83:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102b8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b8d:	5b                   	pop    %ebx
80102b8e:	5e                   	pop    %esi
80102b8f:	5f                   	pop    %edi
80102b90:	5d                   	pop    %ebp
80102b91:	c3                   	ret    
80102b92:	66 90                	xchg   %ax,%ax
80102b94:	66 90                	xchg   %ax,%ax
80102b96:	66 90                	xchg   %ax,%ax
80102b98:	66 90                	xchg   %ax,%ax
80102b9a:	66 90                	xchg   %ax,%ax
80102b9c:	66 90                	xchg   %ax,%ax
80102b9e:	66 90                	xchg   %ax,%ax

80102ba0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102ba0:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102ba6:	85 c9                	test   %ecx,%ecx
80102ba8:	0f 8e 8a 00 00 00    	jle    80102c38 <install_trans+0x98>
{
80102bae:	55                   	push   %ebp
80102baf:	89 e5                	mov    %esp,%ebp
80102bb1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102bb2:	31 ff                	xor    %edi,%edi
{
80102bb4:	56                   	push   %esi
80102bb5:	53                   	push   %ebx
80102bb6:	83 ec 0c             	sub    $0xc,%esp
80102bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102bc0:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102bc5:	83 ec 08             	sub    $0x8,%esp
80102bc8:	01 f8                	add    %edi,%eax
80102bca:	83 c0 01             	add    $0x1,%eax
80102bcd:	50                   	push   %eax
80102bce:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102bd4:	e8 f7 d4 ff ff       	call   801000d0 <bread>
80102bd9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bdb:	58                   	pop    %eax
80102bdc:	5a                   	pop    %edx
80102bdd:	ff 34 bd cc 26 11 80 	pushl  -0x7feed934(,%edi,4)
80102be4:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102bea:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bed:	e8 de d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102bf2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bf5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102bf7:	8d 46 5c             	lea    0x5c(%esi),%eax
80102bfa:	68 00 02 00 00       	push   $0x200
80102bff:	50                   	push   %eax
80102c00:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c03:	50                   	push   %eax
80102c04:	e8 67 1b 00 00       	call   80104770 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c09:	89 1c 24             	mov    %ebx,(%esp)
80102c0c:	e8 9f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c11:	89 34 24             	mov    %esi,(%esp)
80102c14:	e8 d7 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c19:	89 1c 24             	mov    %ebx,(%esp)
80102c1c:	e8 cf d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c21:	83 c4 10             	add    $0x10,%esp
80102c24:	39 3d c8 26 11 80    	cmp    %edi,0x801126c8
80102c2a:	7f 94                	jg     80102bc0 <install_trans+0x20>
  }
}
80102c2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c2f:	5b                   	pop    %ebx
80102c30:	5e                   	pop    %esi
80102c31:	5f                   	pop    %edi
80102c32:	5d                   	pop    %ebp
80102c33:	c3                   	ret    
80102c34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c38:	c3                   	ret    
80102c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c40 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c40:	55                   	push   %ebp
80102c41:	89 e5                	mov    %esp,%ebp
80102c43:	53                   	push   %ebx
80102c44:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c47:	ff 35 b4 26 11 80    	pushl  0x801126b4
80102c4d:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102c53:	e8 78 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c58:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c5b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102c5d:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102c62:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102c65:	85 c0                	test   %eax,%eax
80102c67:	7e 19                	jle    80102c82 <write_head+0x42>
80102c69:	31 d2                	xor    %edx,%edx
80102c6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c6f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102c70:	8b 0c 95 cc 26 11 80 	mov    -0x7feed934(,%edx,4),%ecx
80102c77:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102c7b:	83 c2 01             	add    $0x1,%edx
80102c7e:	39 d0                	cmp    %edx,%eax
80102c80:	75 ee                	jne    80102c70 <write_head+0x30>
  }
  bwrite(buf);
80102c82:	83 ec 0c             	sub    $0xc,%esp
80102c85:	53                   	push   %ebx
80102c86:	e8 25 d5 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102c8b:	89 1c 24             	mov    %ebx,(%esp)
80102c8e:	e8 5d d5 ff ff       	call   801001f0 <brelse>
}
80102c93:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c96:	83 c4 10             	add    $0x10,%esp
80102c99:	c9                   	leave  
80102c9a:	c3                   	ret    
80102c9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c9f:	90                   	nop

80102ca0 <initlog>:
{
80102ca0:	f3 0f 1e fb          	endbr32 
80102ca4:	55                   	push   %ebp
80102ca5:	89 e5                	mov    %esp,%ebp
80102ca7:	53                   	push   %ebx
80102ca8:	83 ec 2c             	sub    $0x2c,%esp
80102cab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102cae:	68 c0 78 10 80       	push   $0x801078c0
80102cb3:	68 80 26 11 80       	push   $0x80112680
80102cb8:	e8 83 17 00 00       	call   80104440 <initlock>
  readsb(dev, &sb);
80102cbd:	58                   	pop    %eax
80102cbe:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102cc1:	5a                   	pop    %edx
80102cc2:	50                   	push   %eax
80102cc3:	53                   	push   %ebx
80102cc4:	e8 47 e8 ff ff       	call   80101510 <readsb>
  log.start = sb.logstart;
80102cc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102ccc:	59                   	pop    %ecx
  log.dev = dev;
80102ccd:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  log.size = sb.nlog;
80102cd3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102cd6:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  log.size = sb.nlog;
80102cdb:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
  struct buf *buf = bread(log.dev, log.start);
80102ce1:	5a                   	pop    %edx
80102ce2:	50                   	push   %eax
80102ce3:	53                   	push   %ebx
80102ce4:	e8 e7 d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102ce9:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102cec:	8b 48 5c             	mov    0x5c(%eax),%ecx
80102cef:	89 0d c8 26 11 80    	mov    %ecx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102cf5:	85 c9                	test   %ecx,%ecx
80102cf7:	7e 19                	jle    80102d12 <initlog+0x72>
80102cf9:	31 d2                	xor    %edx,%edx
80102cfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cff:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102d00:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80102d04:	89 1c 95 cc 26 11 80 	mov    %ebx,-0x7feed934(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d0b:	83 c2 01             	add    $0x1,%edx
80102d0e:	39 d1                	cmp    %edx,%ecx
80102d10:	75 ee                	jne    80102d00 <initlog+0x60>
  brelse(buf);
80102d12:	83 ec 0c             	sub    $0xc,%esp
80102d15:	50                   	push   %eax
80102d16:	e8 d5 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d1b:	e8 80 fe ff ff       	call   80102ba0 <install_trans>
  log.lh.n = 0;
80102d20:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102d27:	00 00 00 
  write_head(); // clear the log
80102d2a:	e8 11 ff ff ff       	call   80102c40 <write_head>
}
80102d2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d32:	83 c4 10             	add    $0x10,%esp
80102d35:	c9                   	leave  
80102d36:	c3                   	ret    
80102d37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d3e:	66 90                	xchg   %ax,%ax

80102d40 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d40:	f3 0f 1e fb          	endbr32 
80102d44:	55                   	push   %ebp
80102d45:	89 e5                	mov    %esp,%ebp
80102d47:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d4a:	68 80 26 11 80       	push   $0x80112680
80102d4f:	e8 6c 18 00 00       	call   801045c0 <acquire>
80102d54:	83 c4 10             	add    $0x10,%esp
80102d57:	eb 1c                	jmp    80102d75 <begin_op+0x35>
80102d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d60:	83 ec 08             	sub    $0x8,%esp
80102d63:	68 80 26 11 80       	push   $0x80112680
80102d68:	68 80 26 11 80       	push   $0x80112680
80102d6d:	e8 0e 12 00 00       	call   80103f80 <sleep>
80102d72:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d75:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102d7a:	85 c0                	test   %eax,%eax
80102d7c:	75 e2                	jne    80102d60 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102d7e:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102d83:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102d89:	83 c0 01             	add    $0x1,%eax
80102d8c:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102d8f:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102d92:	83 fa 1e             	cmp    $0x1e,%edx
80102d95:	7f c9                	jg     80102d60 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102d97:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102d9a:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102d9f:	68 80 26 11 80       	push   $0x80112680
80102da4:	e8 d7 18 00 00       	call   80104680 <release>
      break;
    }
  }
}
80102da9:	83 c4 10             	add    $0x10,%esp
80102dac:	c9                   	leave  
80102dad:	c3                   	ret    
80102dae:	66 90                	xchg   %ax,%ax

80102db0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102db0:	f3 0f 1e fb          	endbr32 
80102db4:	55                   	push   %ebp
80102db5:	89 e5                	mov    %esp,%ebp
80102db7:	57                   	push   %edi
80102db8:	56                   	push   %esi
80102db9:	53                   	push   %ebx
80102dba:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102dbd:	68 80 26 11 80       	push   $0x80112680
80102dc2:	e8 f9 17 00 00       	call   801045c0 <acquire>
  log.outstanding -= 1;
80102dc7:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102dcc:	8b 35 c0 26 11 80    	mov    0x801126c0,%esi
80102dd2:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102dd5:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102dd8:	89 1d bc 26 11 80    	mov    %ebx,0x801126bc
  if(log.committing)
80102dde:	85 f6                	test   %esi,%esi
80102de0:	0f 85 1e 01 00 00    	jne    80102f04 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102de6:	85 db                	test   %ebx,%ebx
80102de8:	0f 85 f2 00 00 00    	jne    80102ee0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102dee:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102df5:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102df8:	83 ec 0c             	sub    $0xc,%esp
80102dfb:	68 80 26 11 80       	push   $0x80112680
80102e00:	e8 7b 18 00 00       	call   80104680 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e05:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102e0b:	83 c4 10             	add    $0x10,%esp
80102e0e:	85 c9                	test   %ecx,%ecx
80102e10:	7f 3e                	jg     80102e50 <end_op+0xa0>
    acquire(&log.lock);
80102e12:	83 ec 0c             	sub    $0xc,%esp
80102e15:	68 80 26 11 80       	push   $0x80112680
80102e1a:	e8 a1 17 00 00       	call   801045c0 <acquire>
    wakeup(&log);
80102e1f:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
    log.committing = 0;
80102e26:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102e2d:	00 00 00 
    wakeup(&log);
80102e30:	e8 0b 13 00 00       	call   80104140 <wakeup>
    release(&log.lock);
80102e35:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102e3c:	e8 3f 18 00 00       	call   80104680 <release>
80102e41:	83 c4 10             	add    $0x10,%esp
}
80102e44:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e47:	5b                   	pop    %ebx
80102e48:	5e                   	pop    %esi
80102e49:	5f                   	pop    %edi
80102e4a:	5d                   	pop    %ebp
80102e4b:	c3                   	ret    
80102e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e50:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102e55:	83 ec 08             	sub    $0x8,%esp
80102e58:	01 d8                	add    %ebx,%eax
80102e5a:	83 c0 01             	add    $0x1,%eax
80102e5d:	50                   	push   %eax
80102e5e:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102e64:	e8 67 d2 ff ff       	call   801000d0 <bread>
80102e69:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e6b:	58                   	pop    %eax
80102e6c:	5a                   	pop    %edx
80102e6d:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102e74:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102e7a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e7d:	e8 4e d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102e82:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e85:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102e87:	8d 40 5c             	lea    0x5c(%eax),%eax
80102e8a:	68 00 02 00 00       	push   $0x200
80102e8f:	50                   	push   %eax
80102e90:	8d 46 5c             	lea    0x5c(%esi),%eax
80102e93:	50                   	push   %eax
80102e94:	e8 d7 18 00 00       	call   80104770 <memmove>
    bwrite(to);  // write the log
80102e99:	89 34 24             	mov    %esi,(%esp)
80102e9c:	e8 0f d3 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102ea1:	89 3c 24             	mov    %edi,(%esp)
80102ea4:	e8 47 d3 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102ea9:	89 34 24             	mov    %esi,(%esp)
80102eac:	e8 3f d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102eb1:	83 c4 10             	add    $0x10,%esp
80102eb4:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102eba:	7c 94                	jl     80102e50 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102ebc:	e8 7f fd ff ff       	call   80102c40 <write_head>
    install_trans(); // Now install writes to home locations
80102ec1:	e8 da fc ff ff       	call   80102ba0 <install_trans>
    log.lh.n = 0;
80102ec6:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102ecd:	00 00 00 
    write_head();    // Erase the transaction from the log
80102ed0:	e8 6b fd ff ff       	call   80102c40 <write_head>
80102ed5:	e9 38 ff ff ff       	jmp    80102e12 <end_op+0x62>
80102eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102ee0:	83 ec 0c             	sub    $0xc,%esp
80102ee3:	68 80 26 11 80       	push   $0x80112680
80102ee8:	e8 53 12 00 00       	call   80104140 <wakeup>
  release(&log.lock);
80102eed:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102ef4:	e8 87 17 00 00       	call   80104680 <release>
80102ef9:	83 c4 10             	add    $0x10,%esp
}
80102efc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102eff:	5b                   	pop    %ebx
80102f00:	5e                   	pop    %esi
80102f01:	5f                   	pop    %edi
80102f02:	5d                   	pop    %ebp
80102f03:	c3                   	ret    
    panic("log.committing");
80102f04:	83 ec 0c             	sub    $0xc,%esp
80102f07:	68 c4 78 10 80       	push   $0x801078c4
80102f0c:	e8 7f d4 ff ff       	call   80100390 <panic>
80102f11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f1f:	90                   	nop

80102f20 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f20:	f3 0f 1e fb          	endbr32 
80102f24:	55                   	push   %ebp
80102f25:	89 e5                	mov    %esp,%ebp
80102f27:	53                   	push   %ebx
80102f28:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f2b:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
{
80102f31:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f34:	83 fa 1d             	cmp    $0x1d,%edx
80102f37:	0f 8f 91 00 00 00    	jg     80102fce <log_write+0xae>
80102f3d:	a1 b8 26 11 80       	mov    0x801126b8,%eax
80102f42:	83 e8 01             	sub    $0x1,%eax
80102f45:	39 c2                	cmp    %eax,%edx
80102f47:	0f 8d 81 00 00 00    	jge    80102fce <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f4d:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102f52:	85 c0                	test   %eax,%eax
80102f54:	0f 8e 81 00 00 00    	jle    80102fdb <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f5a:	83 ec 0c             	sub    $0xc,%esp
80102f5d:	68 80 26 11 80       	push   $0x80112680
80102f62:	e8 59 16 00 00       	call   801045c0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f67:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102f6d:	83 c4 10             	add    $0x10,%esp
80102f70:	85 d2                	test   %edx,%edx
80102f72:	7e 4e                	jle    80102fc2 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f74:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102f77:	31 c0                	xor    %eax,%eax
80102f79:	eb 0c                	jmp    80102f87 <log_write+0x67>
80102f7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f7f:	90                   	nop
80102f80:	83 c0 01             	add    $0x1,%eax
80102f83:	39 c2                	cmp    %eax,%edx
80102f85:	74 29                	je     80102fb0 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f87:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102f8e:	75 f0                	jne    80102f80 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102f90:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102f97:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102f9a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102f9d:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102fa4:	c9                   	leave  
  release(&log.lock);
80102fa5:	e9 d6 16 00 00       	jmp    80104680 <release>
80102faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102fb0:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
    log.lh.n++;
80102fb7:	83 c2 01             	add    $0x1,%edx
80102fba:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
80102fc0:	eb d5                	jmp    80102f97 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80102fc2:	8b 43 08             	mov    0x8(%ebx),%eax
80102fc5:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102fca:	75 cb                	jne    80102f97 <log_write+0x77>
80102fcc:	eb e9                	jmp    80102fb7 <log_write+0x97>
    panic("too big a transaction");
80102fce:	83 ec 0c             	sub    $0xc,%esp
80102fd1:	68 d3 78 10 80       	push   $0x801078d3
80102fd6:	e8 b5 d3 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102fdb:	83 ec 0c             	sub    $0xc,%esp
80102fde:	68 e9 78 10 80       	push   $0x801078e9
80102fe3:	e8 a8 d3 ff ff       	call   80100390 <panic>
80102fe8:	66 90                	xchg   %ax,%ax
80102fea:	66 90                	xchg   %ax,%ax
80102fec:	66 90                	xchg   %ax,%ax
80102fee:	66 90                	xchg   %ax,%ax

80102ff0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102ff0:	55                   	push   %ebp
80102ff1:	89 e5                	mov    %esp,%ebp
80102ff3:	53                   	push   %ebx
80102ff4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102ff7:	e8 64 09 00 00       	call   80103960 <cpuid>
80102ffc:	89 c3                	mov    %eax,%ebx
80102ffe:	e8 5d 09 00 00       	call   80103960 <cpuid>
80103003:	83 ec 04             	sub    $0x4,%esp
80103006:	53                   	push   %ebx
80103007:	50                   	push   %eax
80103008:	68 04 79 10 80       	push   $0x80107904
8010300d:	e8 9e d6 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80103012:	e8 e9 2a 00 00       	call   80105b00 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103017:	e8 d4 08 00 00       	call   801038f0 <mycpu>
8010301c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010301e:	b8 01 00 00 00       	mov    $0x1,%eax
80103023:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010302a:	e8 21 0c 00 00       	call   80103c50 <scheduler>
8010302f:	90                   	nop

80103030 <mpenter>:
{
80103030:	f3 0f 1e fb          	endbr32 
80103034:	55                   	push   %ebp
80103035:	89 e5                	mov    %esp,%ebp
80103037:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
8010303a:	e8 c1 3c 00 00       	call   80106d00 <switchkvm>
  seginit();
8010303f:	e8 5c 3a 00 00       	call   80106aa0 <seginit>
  lapicinit();
80103044:	e8 67 f7 ff ff       	call   801027b0 <lapicinit>
  mpmain();
80103049:	e8 a2 ff ff ff       	call   80102ff0 <mpmain>
8010304e:	66 90                	xchg   %ax,%ax

80103050 <main>:
{
80103050:	f3 0f 1e fb          	endbr32 
80103054:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103058:	83 e4 f0             	and    $0xfffffff0,%esp
8010305b:	ff 71 fc             	pushl  -0x4(%ecx)
8010305e:	55                   	push   %ebp
8010305f:	89 e5                	mov    %esp,%ebp
80103061:	53                   	push   %ebx
80103062:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103063:	83 ec 08             	sub    $0x8,%esp
80103066:	68 00 00 40 80       	push   $0x80400000
8010306b:	68 a8 55 11 80       	push   $0x801155a8
80103070:	e8 fb f4 ff ff       	call   80102570 <kinit1>
  kvmalloc();      // kernel page table
80103075:	e8 76 41 00 00       	call   801071f0 <kvmalloc>
  mpinit();        // detect other processors
8010307a:	e8 81 01 00 00       	call   80103200 <mpinit>
  lapicinit();     // interrupt controller
8010307f:	e8 2c f7 ff ff       	call   801027b0 <lapicinit>
  seginit();       // segment descriptors
80103084:	e8 17 3a 00 00       	call   80106aa0 <seginit>
  picinit();       // disable pic
80103089:	e8 52 03 00 00       	call   801033e0 <picinit>
  ioapicinit();    // another interrupt controller
8010308e:	e8 fd f2 ff ff       	call   80102390 <ioapicinit>
  consoleinit();   // console hardware
80103093:	e8 98 d9 ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
80103098:	e8 83 2e 00 00       	call   80105f20 <uartinit>
  pinit();         // process table
8010309d:	e8 2e 08 00 00       	call   801038d0 <pinit>
  tvinit();        // trap vectors
801030a2:	e8 d9 29 00 00       	call   80105a80 <tvinit>
  binit();         // buffer cache
801030a7:	e8 94 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
801030ac:	e8 3f dd ff ff       	call   80100df0 <fileinit>
  ideinit();       // disk 
801030b1:	e8 aa f0 ff ff       	call   80102160 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801030b6:	83 c4 0c             	add    $0xc,%esp
801030b9:	68 8a 00 00 00       	push   $0x8a
801030be:	68 8c a4 10 80       	push   $0x8010a48c
801030c3:	68 00 70 00 80       	push   $0x80007000
801030c8:	e8 a3 16 00 00       	call   80104770 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030cd:	83 c4 10             	add    $0x10,%esp
801030d0:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
801030d7:	00 00 00 
801030da:	05 80 27 11 80       	add    $0x80112780,%eax
801030df:	3d 80 27 11 80       	cmp    $0x80112780,%eax
801030e4:	76 7a                	jbe    80103160 <main+0x110>
801030e6:	bb 80 27 11 80       	mov    $0x80112780,%ebx
801030eb:	eb 1c                	jmp    80103109 <main+0xb9>
801030ed:	8d 76 00             	lea    0x0(%esi),%esi
801030f0:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
801030f7:	00 00 00 
801030fa:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103100:	05 80 27 11 80       	add    $0x80112780,%eax
80103105:	39 c3                	cmp    %eax,%ebx
80103107:	73 57                	jae    80103160 <main+0x110>
    if(c == mycpu())  // We've started already.
80103109:	e8 e2 07 00 00       	call   801038f0 <mycpu>
8010310e:	39 c3                	cmp    %eax,%ebx
80103110:	74 de                	je     801030f0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103112:	e8 29 f5 ff ff       	call   80102640 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103117:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010311a:	c7 05 f8 6f 00 80 30 	movl   $0x80103030,0x80006ff8
80103121:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103124:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
8010312b:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010312e:	05 00 10 00 00       	add    $0x1000,%eax
80103133:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103138:	0f b6 03             	movzbl (%ebx),%eax
8010313b:	68 00 70 00 00       	push   $0x7000
80103140:	50                   	push   %eax
80103141:	e8 ba f7 ff ff       	call   80102900 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103146:	83 c4 10             	add    $0x10,%esp
80103149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103150:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103156:	85 c0                	test   %eax,%eax
80103158:	74 f6                	je     80103150 <main+0x100>
8010315a:	eb 94                	jmp    801030f0 <main+0xa0>
8010315c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103160:	83 ec 08             	sub    $0x8,%esp
80103163:	68 00 00 00 8e       	push   $0x8e000000
80103168:	68 00 00 40 80       	push   $0x80400000
8010316d:	e8 6e f4 ff ff       	call   801025e0 <kinit2>
  userinit();      // first user process
80103172:	e8 39 08 00 00       	call   801039b0 <userinit>
  mpmain();        // finish this processor's setup
80103177:	e8 74 fe ff ff       	call   80102ff0 <mpmain>
8010317c:	66 90                	xchg   %ax,%ax
8010317e:	66 90                	xchg   %ax,%ax

80103180 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103180:	55                   	push   %ebp
80103181:	89 e5                	mov    %esp,%ebp
80103183:	57                   	push   %edi
80103184:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103185:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010318b:	53                   	push   %ebx
  e = addr+len;
8010318c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010318f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103192:	39 de                	cmp    %ebx,%esi
80103194:	72 10                	jb     801031a6 <mpsearch1+0x26>
80103196:	eb 50                	jmp    801031e8 <mpsearch1+0x68>
80103198:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010319f:	90                   	nop
801031a0:	89 fe                	mov    %edi,%esi
801031a2:	39 fb                	cmp    %edi,%ebx
801031a4:	76 42                	jbe    801031e8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031a6:	83 ec 04             	sub    $0x4,%esp
801031a9:	8d 7e 10             	lea    0x10(%esi),%edi
801031ac:	6a 04                	push   $0x4
801031ae:	68 18 79 10 80       	push   $0x80107918
801031b3:	56                   	push   %esi
801031b4:	e8 67 15 00 00       	call   80104720 <memcmp>
801031b9:	83 c4 10             	add    $0x10,%esp
801031bc:	85 c0                	test   %eax,%eax
801031be:	75 e0                	jne    801031a0 <mpsearch1+0x20>
801031c0:	89 f2                	mov    %esi,%edx
801031c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031c8:	0f b6 0a             	movzbl (%edx),%ecx
801031cb:	83 c2 01             	add    $0x1,%edx
801031ce:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801031d0:	39 fa                	cmp    %edi,%edx
801031d2:	75 f4                	jne    801031c8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031d4:	84 c0                	test   %al,%al
801031d6:	75 c8                	jne    801031a0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801031d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031db:	89 f0                	mov    %esi,%eax
801031dd:	5b                   	pop    %ebx
801031de:	5e                   	pop    %esi
801031df:	5f                   	pop    %edi
801031e0:	5d                   	pop    %ebp
801031e1:	c3                   	ret    
801031e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801031eb:	31 f6                	xor    %esi,%esi
}
801031ed:	5b                   	pop    %ebx
801031ee:	89 f0                	mov    %esi,%eax
801031f0:	5e                   	pop    %esi
801031f1:	5f                   	pop    %edi
801031f2:	5d                   	pop    %ebp
801031f3:	c3                   	ret    
801031f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801031ff:	90                   	nop

80103200 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103200:	f3 0f 1e fb          	endbr32 
80103204:	55                   	push   %ebp
80103205:	89 e5                	mov    %esp,%ebp
80103207:	57                   	push   %edi
80103208:	56                   	push   %esi
80103209:	53                   	push   %ebx
8010320a:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
8010320d:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103214:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
8010321b:	c1 e0 08             	shl    $0x8,%eax
8010321e:	09 d0                	or     %edx,%eax
80103220:	c1 e0 04             	shl    $0x4,%eax
80103223:	75 1b                	jne    80103240 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103225:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010322c:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103233:	c1 e0 08             	shl    $0x8,%eax
80103236:	09 d0                	or     %edx,%eax
80103238:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
8010323b:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103240:	ba 00 04 00 00       	mov    $0x400,%edx
80103245:	e8 36 ff ff ff       	call   80103180 <mpsearch1>
8010324a:	89 c6                	mov    %eax,%esi
8010324c:	85 c0                	test   %eax,%eax
8010324e:	0f 84 4c 01 00 00    	je     801033a0 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103254:	8b 5e 04             	mov    0x4(%esi),%ebx
80103257:	85 db                	test   %ebx,%ebx
80103259:	0f 84 61 01 00 00    	je     801033c0 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
8010325f:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103262:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103268:	6a 04                	push   $0x4
8010326a:	68 1d 79 10 80       	push   $0x8010791d
8010326f:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103270:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103273:	e8 a8 14 00 00       	call   80104720 <memcmp>
80103278:	83 c4 10             	add    $0x10,%esp
8010327b:	85 c0                	test   %eax,%eax
8010327d:	0f 85 3d 01 00 00    	jne    801033c0 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
80103283:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
8010328a:	3c 01                	cmp    $0x1,%al
8010328c:	74 08                	je     80103296 <mpinit+0x96>
8010328e:	3c 04                	cmp    $0x4,%al
80103290:	0f 85 2a 01 00 00    	jne    801033c0 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
80103296:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
8010329d:	66 85 d2             	test   %dx,%dx
801032a0:	74 26                	je     801032c8 <mpinit+0xc8>
801032a2:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
801032a5:	89 d8                	mov    %ebx,%eax
  sum = 0;
801032a7:	31 d2                	xor    %edx,%edx
801032a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
801032b0:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
801032b7:	83 c0 01             	add    $0x1,%eax
801032ba:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801032bc:	39 f8                	cmp    %edi,%eax
801032be:	75 f0                	jne    801032b0 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
801032c0:	84 d2                	test   %dl,%dl
801032c2:	0f 85 f8 00 00 00    	jne    801033c0 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801032c8:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801032ce:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032d3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
801032d9:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
801032e0:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032e5:	03 55 e4             	add    -0x1c(%ebp),%edx
801032e8:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801032eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801032ef:	90                   	nop
801032f0:	39 c2                	cmp    %eax,%edx
801032f2:	76 15                	jbe    80103309 <mpinit+0x109>
    switch(*p){
801032f4:	0f b6 08             	movzbl (%eax),%ecx
801032f7:	80 f9 02             	cmp    $0x2,%cl
801032fa:	74 5c                	je     80103358 <mpinit+0x158>
801032fc:	77 42                	ja     80103340 <mpinit+0x140>
801032fe:	84 c9                	test   %cl,%cl
80103300:	74 6e                	je     80103370 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103302:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103305:	39 c2                	cmp    %eax,%edx
80103307:	77 eb                	ja     801032f4 <mpinit+0xf4>
80103309:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010330c:	85 db                	test   %ebx,%ebx
8010330e:	0f 84 b9 00 00 00    	je     801033cd <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103314:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103318:	74 15                	je     8010332f <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010331a:	b8 70 00 00 00       	mov    $0x70,%eax
8010331f:	ba 22 00 00 00       	mov    $0x22,%edx
80103324:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103325:	ba 23 00 00 00       	mov    $0x23,%edx
8010332a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010332b:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010332e:	ee                   	out    %al,(%dx)
  }
}
8010332f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103332:	5b                   	pop    %ebx
80103333:	5e                   	pop    %esi
80103334:	5f                   	pop    %edi
80103335:	5d                   	pop    %ebp
80103336:	c3                   	ret    
80103337:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010333e:	66 90                	xchg   %ax,%ax
    switch(*p){
80103340:	83 e9 03             	sub    $0x3,%ecx
80103343:	80 f9 01             	cmp    $0x1,%cl
80103346:	76 ba                	jbe    80103302 <mpinit+0x102>
80103348:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010334f:	eb 9f                	jmp    801032f0 <mpinit+0xf0>
80103351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103358:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
8010335c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010335f:	88 0d 60 27 11 80    	mov    %cl,0x80112760
      continue;
80103365:	eb 89                	jmp    801032f0 <mpinit+0xf0>
80103367:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010336e:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80103370:	8b 0d 00 2d 11 80    	mov    0x80112d00,%ecx
80103376:	83 f9 07             	cmp    $0x7,%ecx
80103379:	7f 19                	jg     80103394 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010337b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103381:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103385:	83 c1 01             	add    $0x1,%ecx
80103388:	89 0d 00 2d 11 80    	mov    %ecx,0x80112d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010338e:	88 9f 80 27 11 80    	mov    %bl,-0x7feed880(%edi)
      p += sizeof(struct mpproc);
80103394:	83 c0 14             	add    $0x14,%eax
      continue;
80103397:	e9 54 ff ff ff       	jmp    801032f0 <mpinit+0xf0>
8010339c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
801033a0:	ba 00 00 01 00       	mov    $0x10000,%edx
801033a5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801033aa:	e8 d1 fd ff ff       	call   80103180 <mpsearch1>
801033af:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801033b1:	85 c0                	test   %eax,%eax
801033b3:	0f 85 9b fe ff ff    	jne    80103254 <mpinit+0x54>
801033b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801033c0:	83 ec 0c             	sub    $0xc,%esp
801033c3:	68 22 79 10 80       	push   $0x80107922
801033c8:	e8 c3 cf ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801033cd:	83 ec 0c             	sub    $0xc,%esp
801033d0:	68 3c 79 10 80       	push   $0x8010793c
801033d5:	e8 b6 cf ff ff       	call   80100390 <panic>
801033da:	66 90                	xchg   %ax,%ax
801033dc:	66 90                	xchg   %ax,%ax
801033de:	66 90                	xchg   %ax,%ax

801033e0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801033e0:	f3 0f 1e fb          	endbr32 
801033e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801033e9:	ba 21 00 00 00       	mov    $0x21,%edx
801033ee:	ee                   	out    %al,(%dx)
801033ef:	ba a1 00 00 00       	mov    $0xa1,%edx
801033f4:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801033f5:	c3                   	ret    
801033f6:	66 90                	xchg   %ax,%ax
801033f8:	66 90                	xchg   %ax,%ax
801033fa:	66 90                	xchg   %ax,%ax
801033fc:	66 90                	xchg   %ax,%ax
801033fe:	66 90                	xchg   %ax,%ax

80103400 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103400:	f3 0f 1e fb          	endbr32 
80103404:	55                   	push   %ebp
80103405:	89 e5                	mov    %esp,%ebp
80103407:	57                   	push   %edi
80103408:	56                   	push   %esi
80103409:	53                   	push   %ebx
8010340a:	83 ec 0c             	sub    $0xc,%esp
8010340d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103410:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103413:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103419:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010341f:	e8 ec d9 ff ff       	call   80100e10 <filealloc>
80103424:	89 03                	mov    %eax,(%ebx)
80103426:	85 c0                	test   %eax,%eax
80103428:	0f 84 ac 00 00 00    	je     801034da <pipealloc+0xda>
8010342e:	e8 dd d9 ff ff       	call   80100e10 <filealloc>
80103433:	89 06                	mov    %eax,(%esi)
80103435:	85 c0                	test   %eax,%eax
80103437:	0f 84 8b 00 00 00    	je     801034c8 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
8010343d:	e8 fe f1 ff ff       	call   80102640 <kalloc>
80103442:	89 c7                	mov    %eax,%edi
80103444:	85 c0                	test   %eax,%eax
80103446:	0f 84 b4 00 00 00    	je     80103500 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
8010344c:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103453:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103456:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103459:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103460:	00 00 00 
  p->nwrite = 0;
80103463:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010346a:	00 00 00 
  p->nread = 0;
8010346d:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103474:	00 00 00 
  initlock(&p->lock, "pipe");
80103477:	68 5b 79 10 80       	push   $0x8010795b
8010347c:	50                   	push   %eax
8010347d:	e8 be 0f 00 00       	call   80104440 <initlock>
  (*f0)->type = FD_PIPE;
80103482:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103484:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103487:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
8010348d:	8b 03                	mov    (%ebx),%eax
8010348f:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103493:	8b 03                	mov    (%ebx),%eax
80103495:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103499:	8b 03                	mov    (%ebx),%eax
8010349b:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010349e:	8b 06                	mov    (%esi),%eax
801034a0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034a6:	8b 06                	mov    (%esi),%eax
801034a8:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801034ac:	8b 06                	mov    (%esi),%eax
801034ae:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034b2:	8b 06                	mov    (%esi),%eax
801034b4:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801034b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801034ba:	31 c0                	xor    %eax,%eax
}
801034bc:	5b                   	pop    %ebx
801034bd:	5e                   	pop    %esi
801034be:	5f                   	pop    %edi
801034bf:	5d                   	pop    %ebp
801034c0:	c3                   	ret    
801034c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
801034c8:	8b 03                	mov    (%ebx),%eax
801034ca:	85 c0                	test   %eax,%eax
801034cc:	74 1e                	je     801034ec <pipealloc+0xec>
    fileclose(*f0);
801034ce:	83 ec 0c             	sub    $0xc,%esp
801034d1:	50                   	push   %eax
801034d2:	e8 f9 d9 ff ff       	call   80100ed0 <fileclose>
801034d7:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801034da:	8b 06                	mov    (%esi),%eax
801034dc:	85 c0                	test   %eax,%eax
801034de:	74 0c                	je     801034ec <pipealloc+0xec>
    fileclose(*f1);
801034e0:	83 ec 0c             	sub    $0xc,%esp
801034e3:	50                   	push   %eax
801034e4:	e8 e7 d9 ff ff       	call   80100ed0 <fileclose>
801034e9:	83 c4 10             	add    $0x10,%esp
}
801034ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801034ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801034f4:	5b                   	pop    %ebx
801034f5:	5e                   	pop    %esi
801034f6:	5f                   	pop    %edi
801034f7:	5d                   	pop    %ebp
801034f8:	c3                   	ret    
801034f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103500:	8b 03                	mov    (%ebx),%eax
80103502:	85 c0                	test   %eax,%eax
80103504:	75 c8                	jne    801034ce <pipealloc+0xce>
80103506:	eb d2                	jmp    801034da <pipealloc+0xda>
80103508:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010350f:	90                   	nop

80103510 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103510:	f3 0f 1e fb          	endbr32 
80103514:	55                   	push   %ebp
80103515:	89 e5                	mov    %esp,%ebp
80103517:	56                   	push   %esi
80103518:	53                   	push   %ebx
80103519:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010351c:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010351f:	83 ec 0c             	sub    $0xc,%esp
80103522:	53                   	push   %ebx
80103523:	e8 98 10 00 00       	call   801045c0 <acquire>
  if(writable){
80103528:	83 c4 10             	add    $0x10,%esp
8010352b:	85 f6                	test   %esi,%esi
8010352d:	74 41                	je     80103570 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010352f:	83 ec 0c             	sub    $0xc,%esp
80103532:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103538:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010353f:	00 00 00 
    wakeup(&p->nread);
80103542:	50                   	push   %eax
80103543:	e8 f8 0b 00 00       	call   80104140 <wakeup>
80103548:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
8010354b:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103551:	85 d2                	test   %edx,%edx
80103553:	75 0a                	jne    8010355f <pipeclose+0x4f>
80103555:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
8010355b:	85 c0                	test   %eax,%eax
8010355d:	74 31                	je     80103590 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010355f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103562:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103565:	5b                   	pop    %ebx
80103566:	5e                   	pop    %esi
80103567:	5d                   	pop    %ebp
    release(&p->lock);
80103568:	e9 13 11 00 00       	jmp    80104680 <release>
8010356d:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103570:	83 ec 0c             	sub    $0xc,%esp
80103573:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103579:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103580:	00 00 00 
    wakeup(&p->nwrite);
80103583:	50                   	push   %eax
80103584:	e8 b7 0b 00 00       	call   80104140 <wakeup>
80103589:	83 c4 10             	add    $0x10,%esp
8010358c:	eb bd                	jmp    8010354b <pipeclose+0x3b>
8010358e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103590:	83 ec 0c             	sub    $0xc,%esp
80103593:	53                   	push   %ebx
80103594:	e8 e7 10 00 00       	call   80104680 <release>
    kfree((char*)p);
80103599:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010359c:	83 c4 10             	add    $0x10,%esp
}
8010359f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035a2:	5b                   	pop    %ebx
801035a3:	5e                   	pop    %esi
801035a4:	5d                   	pop    %ebp
    kfree((char*)p);
801035a5:	e9 d6 ee ff ff       	jmp    80102480 <kfree>
801035aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801035b0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035b0:	f3 0f 1e fb          	endbr32 
801035b4:	55                   	push   %ebp
801035b5:	89 e5                	mov    %esp,%ebp
801035b7:	57                   	push   %edi
801035b8:	56                   	push   %esi
801035b9:	53                   	push   %ebx
801035ba:	83 ec 28             	sub    $0x28,%esp
801035bd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801035c0:	53                   	push   %ebx
801035c1:	e8 fa 0f 00 00       	call   801045c0 <acquire>
  for(i = 0; i < n; i++){
801035c6:	8b 45 10             	mov    0x10(%ebp),%eax
801035c9:	83 c4 10             	add    $0x10,%esp
801035cc:	85 c0                	test   %eax,%eax
801035ce:	0f 8e bc 00 00 00    	jle    80103690 <pipewrite+0xe0>
801035d4:	8b 45 0c             	mov    0xc(%ebp),%eax
801035d7:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801035dd:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801035e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801035e6:	03 45 10             	add    0x10(%ebp),%eax
801035e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035ec:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801035f2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035f8:	89 ca                	mov    %ecx,%edx
801035fa:	05 00 02 00 00       	add    $0x200,%eax
801035ff:	39 c1                	cmp    %eax,%ecx
80103601:	74 3b                	je     8010363e <pipewrite+0x8e>
80103603:	eb 63                	jmp    80103668 <pipewrite+0xb8>
80103605:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80103608:	e8 73 03 00 00       	call   80103980 <myproc>
8010360d:	8b 48 24             	mov    0x24(%eax),%ecx
80103610:	85 c9                	test   %ecx,%ecx
80103612:	75 34                	jne    80103648 <pipewrite+0x98>
      wakeup(&p->nread);
80103614:	83 ec 0c             	sub    $0xc,%esp
80103617:	57                   	push   %edi
80103618:	e8 23 0b 00 00       	call   80104140 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010361d:	58                   	pop    %eax
8010361e:	5a                   	pop    %edx
8010361f:	53                   	push   %ebx
80103620:	56                   	push   %esi
80103621:	e8 5a 09 00 00       	call   80103f80 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103626:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010362c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103632:	83 c4 10             	add    $0x10,%esp
80103635:	05 00 02 00 00       	add    $0x200,%eax
8010363a:	39 c2                	cmp    %eax,%edx
8010363c:	75 2a                	jne    80103668 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010363e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103644:	85 c0                	test   %eax,%eax
80103646:	75 c0                	jne    80103608 <pipewrite+0x58>
        release(&p->lock);
80103648:	83 ec 0c             	sub    $0xc,%esp
8010364b:	53                   	push   %ebx
8010364c:	e8 2f 10 00 00       	call   80104680 <release>
        return -1;
80103651:	83 c4 10             	add    $0x10,%esp
80103654:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103659:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010365c:	5b                   	pop    %ebx
8010365d:	5e                   	pop    %esi
8010365e:	5f                   	pop    %edi
8010365f:	5d                   	pop    %ebp
80103660:	c3                   	ret    
80103661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103668:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010366b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010366e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103674:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010367a:	0f b6 06             	movzbl (%esi),%eax
8010367d:	83 c6 01             	add    $0x1,%esi
80103680:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80103683:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103687:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010368a:	0f 85 5c ff ff ff    	jne    801035ec <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103690:	83 ec 0c             	sub    $0xc,%esp
80103693:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103699:	50                   	push   %eax
8010369a:	e8 a1 0a 00 00       	call   80104140 <wakeup>
  release(&p->lock);
8010369f:	89 1c 24             	mov    %ebx,(%esp)
801036a2:	e8 d9 0f 00 00       	call   80104680 <release>
  return n;
801036a7:	8b 45 10             	mov    0x10(%ebp),%eax
801036aa:	83 c4 10             	add    $0x10,%esp
801036ad:	eb aa                	jmp    80103659 <pipewrite+0xa9>
801036af:	90                   	nop

801036b0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036b0:	f3 0f 1e fb          	endbr32 
801036b4:	55                   	push   %ebp
801036b5:	89 e5                	mov    %esp,%ebp
801036b7:	57                   	push   %edi
801036b8:	56                   	push   %esi
801036b9:	53                   	push   %ebx
801036ba:	83 ec 18             	sub    $0x18,%esp
801036bd:	8b 75 08             	mov    0x8(%ebp),%esi
801036c0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036c3:	56                   	push   %esi
801036c4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801036ca:	e8 f1 0e 00 00       	call   801045c0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036cf:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801036d5:	83 c4 10             	add    $0x10,%esp
801036d8:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801036de:	74 33                	je     80103713 <piperead+0x63>
801036e0:	eb 3b                	jmp    8010371d <piperead+0x6d>
801036e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
801036e8:	e8 93 02 00 00       	call   80103980 <myproc>
801036ed:	8b 48 24             	mov    0x24(%eax),%ecx
801036f0:	85 c9                	test   %ecx,%ecx
801036f2:	0f 85 88 00 00 00    	jne    80103780 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801036f8:	83 ec 08             	sub    $0x8,%esp
801036fb:	56                   	push   %esi
801036fc:	53                   	push   %ebx
801036fd:	e8 7e 08 00 00       	call   80103f80 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103702:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103708:	83 c4 10             	add    $0x10,%esp
8010370b:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103711:	75 0a                	jne    8010371d <piperead+0x6d>
80103713:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103719:	85 c0                	test   %eax,%eax
8010371b:	75 cb                	jne    801036e8 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010371d:	8b 55 10             	mov    0x10(%ebp),%edx
80103720:	31 db                	xor    %ebx,%ebx
80103722:	85 d2                	test   %edx,%edx
80103724:	7f 28                	jg     8010374e <piperead+0x9e>
80103726:	eb 34                	jmp    8010375c <piperead+0xac>
80103728:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010372f:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103730:	8d 48 01             	lea    0x1(%eax),%ecx
80103733:	25 ff 01 00 00       	and    $0x1ff,%eax
80103738:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010373e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103743:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103746:	83 c3 01             	add    $0x1,%ebx
80103749:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010374c:	74 0e                	je     8010375c <piperead+0xac>
    if(p->nread == p->nwrite)
8010374e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103754:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010375a:	75 d4                	jne    80103730 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010375c:	83 ec 0c             	sub    $0xc,%esp
8010375f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103765:	50                   	push   %eax
80103766:	e8 d5 09 00 00       	call   80104140 <wakeup>
  release(&p->lock);
8010376b:	89 34 24             	mov    %esi,(%esp)
8010376e:	e8 0d 0f 00 00       	call   80104680 <release>
  return i;
80103773:	83 c4 10             	add    $0x10,%esp
}
80103776:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103779:	89 d8                	mov    %ebx,%eax
8010377b:	5b                   	pop    %ebx
8010377c:	5e                   	pop    %esi
8010377d:	5f                   	pop    %edi
8010377e:	5d                   	pop    %ebp
8010377f:	c3                   	ret    
      release(&p->lock);
80103780:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103783:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103788:	56                   	push   %esi
80103789:	e8 f2 0e 00 00       	call   80104680 <release>
      return -1;
8010378e:	83 c4 10             	add    $0x10,%esp
}
80103791:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103794:	89 d8                	mov    %ebx,%eax
80103796:	5b                   	pop    %ebx
80103797:	5e                   	pop    %esi
80103798:	5f                   	pop    %edi
80103799:	5d                   	pop    %ebp
8010379a:	c3                   	ret    
8010379b:	66 90                	xchg   %ax,%ax
8010379d:	66 90                	xchg   %ax,%ax
8010379f:	90                   	nop

801037a0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801037a0:	55                   	push   %ebp
801037a1:	89 e5                	mov    %esp,%ebp
801037a3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037a4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
801037a9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801037ac:	68 20 2d 11 80       	push   $0x80112d20
801037b1:	e8 0a 0e 00 00       	call   801045c0 <acquire>
801037b6:	83 c4 10             	add    $0x10,%esp
801037b9:	eb 14                	jmp    801037cf <allocproc+0x2f>
801037bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037bf:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037c0:	83 eb 80             	sub    $0xffffff80,%ebx
801037c3:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
801037c9:	0f 84 81 00 00 00    	je     80103850 <allocproc+0xb0>
    if(p->state == UNUSED)
801037cf:	8b 43 0c             	mov    0xc(%ebx),%eax
801037d2:	85 c0                	test   %eax,%eax
801037d4:	75 ea                	jne    801037c0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801037d6:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
801037db:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801037de:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801037e5:	89 43 10             	mov    %eax,0x10(%ebx)
801037e8:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
801037eb:	68 20 2d 11 80       	push   $0x80112d20
  p->pid = nextpid++;
801037f0:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
801037f6:	e8 85 0e 00 00       	call   80104680 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801037fb:	e8 40 ee ff ff       	call   80102640 <kalloc>
80103800:	83 c4 10             	add    $0x10,%esp
80103803:	89 43 08             	mov    %eax,0x8(%ebx)
80103806:	85 c0                	test   %eax,%eax
80103808:	74 5f                	je     80103869 <allocproc+0xc9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010380a:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103810:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103813:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103818:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
8010381b:	c7 40 14 6c 5a 10 80 	movl   $0x80105a6c,0x14(%eax)
  p->context = (struct context*)sp;
80103822:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103825:	6a 14                	push   $0x14
80103827:	6a 00                	push   $0x0
80103829:	50                   	push   %eax
8010382a:	e8 a1 0e 00 00       	call   801046d0 <memset>
  p->context->eip = (uint)forkret;
8010382f:	8b 43 1c             	mov    0x1c(%ebx),%eax
  p->priority=DEFAULT_PRIORITY;

  return p;
80103832:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103835:	c7 40 10 80 38 10 80 	movl   $0x80103880,0x10(%eax)
}
8010383c:	89 d8                	mov    %ebx,%eax
  p->priority=DEFAULT_PRIORITY;
8010383e:	c7 43 7c 05 00 00 00 	movl   $0x5,0x7c(%ebx)
}
80103845:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103848:	c9                   	leave  
80103849:	c3                   	ret    
8010384a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80103850:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103853:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103855:	68 20 2d 11 80       	push   $0x80112d20
8010385a:	e8 21 0e 00 00       	call   80104680 <release>
}
8010385f:	89 d8                	mov    %ebx,%eax
  return 0;
80103861:	83 c4 10             	add    $0x10,%esp
}
80103864:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103867:	c9                   	leave  
80103868:	c3                   	ret    
    p->state = UNUSED;
80103869:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103870:	31 db                	xor    %ebx,%ebx
}
80103872:	89 d8                	mov    %ebx,%eax
80103874:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103877:	c9                   	leave  
80103878:	c3                   	ret    
80103879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103880 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103880:	f3 0f 1e fb          	endbr32 
80103884:	55                   	push   %ebp
80103885:	89 e5                	mov    %esp,%ebp
80103887:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
8010388a:	68 20 2d 11 80       	push   $0x80112d20
8010388f:	e8 ec 0d 00 00       	call   80104680 <release>

  if (first) {
80103894:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103899:	83 c4 10             	add    $0x10,%esp
8010389c:	85 c0                	test   %eax,%eax
8010389e:	75 08                	jne    801038a8 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801038a0:	c9                   	leave  
801038a1:	c3                   	ret    
801038a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
801038a8:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801038af:	00 00 00 
    iinit(ROOTDEV);
801038b2:	83 ec 0c             	sub    $0xc,%esp
801038b5:	6a 01                	push   $0x1
801038b7:	e8 94 dc ff ff       	call   80101550 <iinit>
    initlog(ROOTDEV);
801038bc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801038c3:	e8 d8 f3 ff ff       	call   80102ca0 <initlog>
}
801038c8:	83 c4 10             	add    $0x10,%esp
801038cb:	c9                   	leave  
801038cc:	c3                   	ret    
801038cd:	8d 76 00             	lea    0x0(%esi),%esi

801038d0 <pinit>:
{
801038d0:	f3 0f 1e fb          	endbr32 
801038d4:	55                   	push   %ebp
801038d5:	89 e5                	mov    %esp,%ebp
801038d7:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801038da:	68 60 79 10 80       	push   $0x80107960
801038df:	68 20 2d 11 80       	push   $0x80112d20
801038e4:	e8 57 0b 00 00       	call   80104440 <initlock>
}
801038e9:	83 c4 10             	add    $0x10,%esp
801038ec:	c9                   	leave  
801038ed:	c3                   	ret    
801038ee:	66 90                	xchg   %ax,%ax

801038f0 <mycpu>:
{
801038f0:	f3 0f 1e fb          	endbr32 
801038f4:	55                   	push   %ebp
801038f5:	89 e5                	mov    %esp,%ebp
801038f7:	56                   	push   %esi
801038f8:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801038f9:	9c                   	pushf  
801038fa:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801038fb:	f6 c4 02             	test   $0x2,%ah
801038fe:	75 4a                	jne    8010394a <mycpu+0x5a>
  apicid = lapicid();
80103900:	e8 ab ef ff ff       	call   801028b0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103905:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
  apicid = lapicid();
8010390b:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
8010390d:	85 f6                	test   %esi,%esi
8010390f:	7e 2c                	jle    8010393d <mycpu+0x4d>
80103911:	31 d2                	xor    %edx,%edx
80103913:	eb 0a                	jmp    8010391f <mycpu+0x2f>
80103915:	8d 76 00             	lea    0x0(%esi),%esi
80103918:	83 c2 01             	add    $0x1,%edx
8010391b:	39 f2                	cmp    %esi,%edx
8010391d:	74 1e                	je     8010393d <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
8010391f:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103925:	0f b6 81 80 27 11 80 	movzbl -0x7feed880(%ecx),%eax
8010392c:	39 d8                	cmp    %ebx,%eax
8010392e:	75 e8                	jne    80103918 <mycpu+0x28>
}
80103930:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103933:	8d 81 80 27 11 80    	lea    -0x7feed880(%ecx),%eax
}
80103939:	5b                   	pop    %ebx
8010393a:	5e                   	pop    %esi
8010393b:	5d                   	pop    %ebp
8010393c:	c3                   	ret    
  panic("unknown apicid\n");
8010393d:	83 ec 0c             	sub    $0xc,%esp
80103940:	68 67 79 10 80       	push   $0x80107967
80103945:	e8 46 ca ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
8010394a:	83 ec 0c             	sub    $0xc,%esp
8010394d:	68 44 7a 10 80       	push   $0x80107a44
80103952:	e8 39 ca ff ff       	call   80100390 <panic>
80103957:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010395e:	66 90                	xchg   %ax,%ax

80103960 <cpuid>:
cpuid() {
80103960:	f3 0f 1e fb          	endbr32 
80103964:	55                   	push   %ebp
80103965:	89 e5                	mov    %esp,%ebp
80103967:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
8010396a:	e8 81 ff ff ff       	call   801038f0 <mycpu>
}
8010396f:	c9                   	leave  
  return mycpu()-cpus;
80103970:	2d 80 27 11 80       	sub    $0x80112780,%eax
80103975:	c1 f8 04             	sar    $0x4,%eax
80103978:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010397e:	c3                   	ret    
8010397f:	90                   	nop

80103980 <myproc>:
myproc(void) {
80103980:	f3 0f 1e fb          	endbr32 
80103984:	55                   	push   %ebp
80103985:	89 e5                	mov    %esp,%ebp
80103987:	53                   	push   %ebx
80103988:	83 ec 04             	sub    $0x4,%esp
  pushcli();
8010398b:	e8 30 0b 00 00       	call   801044c0 <pushcli>
  c = mycpu();
80103990:	e8 5b ff ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80103995:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010399b:	e8 70 0b 00 00       	call   80104510 <popcli>
}
801039a0:	83 c4 04             	add    $0x4,%esp
801039a3:	89 d8                	mov    %ebx,%eax
801039a5:	5b                   	pop    %ebx
801039a6:	5d                   	pop    %ebp
801039a7:	c3                   	ret    
801039a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039af:	90                   	nop

801039b0 <userinit>:
{
801039b0:	f3 0f 1e fb          	endbr32 
801039b4:	55                   	push   %ebp
801039b5:	89 e5                	mov    %esp,%ebp
801039b7:	53                   	push   %ebx
801039b8:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801039bb:	e8 e0 fd ff ff       	call   801037a0 <allocproc>
801039c0:	89 c3                	mov    %eax,%ebx
  initproc = p;
801039c2:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
801039c7:	e8 a4 37 00 00       	call   80107170 <setupkvm>
801039cc:	89 43 04             	mov    %eax,0x4(%ebx)
801039cf:	85 c0                	test   %eax,%eax
801039d1:	0f 84 bd 00 00 00    	je     80103a94 <userinit+0xe4>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801039d7:	83 ec 04             	sub    $0x4,%esp
801039da:	68 2c 00 00 00       	push   $0x2c
801039df:	68 60 a4 10 80       	push   $0x8010a460
801039e4:	50                   	push   %eax
801039e5:	e8 46 34 00 00       	call   80106e30 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801039ea:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801039ed:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801039f3:	6a 4c                	push   $0x4c
801039f5:	6a 00                	push   $0x0
801039f7:	ff 73 18             	pushl  0x18(%ebx)
801039fa:	e8 d1 0c 00 00       	call   801046d0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801039ff:	8b 43 18             	mov    0x18(%ebx),%eax
80103a02:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a07:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a0a:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a0f:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a13:	8b 43 18             	mov    0x18(%ebx),%eax
80103a16:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103a1a:	8b 43 18             	mov    0x18(%ebx),%eax
80103a1d:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a21:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103a25:	8b 43 18             	mov    0x18(%ebx),%eax
80103a28:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a2c:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103a30:	8b 43 18             	mov    0x18(%ebx),%eax
80103a33:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103a3a:	8b 43 18             	mov    0x18(%ebx),%eax
80103a3d:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103a44:	8b 43 18             	mov    0x18(%ebx),%eax
80103a47:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a4e:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103a51:	6a 10                	push   $0x10
80103a53:	68 90 79 10 80       	push   $0x80107990
80103a58:	50                   	push   %eax
80103a59:	e8 32 0e 00 00       	call   80104890 <safestrcpy>
  p->cwd = namei("/");
80103a5e:	c7 04 24 99 79 10 80 	movl   $0x80107999,(%esp)
80103a65:	e8 d6 e5 ff ff       	call   80102040 <namei>
80103a6a:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103a6d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a74:	e8 47 0b 00 00       	call   801045c0 <acquire>
  p->state = RUNNABLE;
80103a79:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103a80:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a87:	e8 f4 0b 00 00       	call   80104680 <release>
}
80103a8c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a8f:	83 c4 10             	add    $0x10,%esp
80103a92:	c9                   	leave  
80103a93:	c3                   	ret    
    panic("userinit: out of memory?");
80103a94:	83 ec 0c             	sub    $0xc,%esp
80103a97:	68 77 79 10 80       	push   $0x80107977
80103a9c:	e8 ef c8 ff ff       	call   80100390 <panic>
80103aa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103aa8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103aaf:	90                   	nop

80103ab0 <growproc>:
{
80103ab0:	f3 0f 1e fb          	endbr32 
80103ab4:	55                   	push   %ebp
80103ab5:	89 e5                	mov    %esp,%ebp
80103ab7:	56                   	push   %esi
80103ab8:	53                   	push   %ebx
80103ab9:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103abc:	e8 ff 09 00 00       	call   801044c0 <pushcli>
  c = mycpu();
80103ac1:	e8 2a fe ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80103ac6:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103acc:	e8 3f 0a 00 00       	call   80104510 <popcli>
  sz = curproc->sz;
80103ad1:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103ad3:	85 f6                	test   %esi,%esi
80103ad5:	7f 19                	jg     80103af0 <growproc+0x40>
  } else if(n < 0){
80103ad7:	75 37                	jne    80103b10 <growproc+0x60>
  switchuvm(curproc);
80103ad9:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103adc:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103ade:	53                   	push   %ebx
80103adf:	e8 3c 32 00 00       	call   80106d20 <switchuvm>
  return 0;
80103ae4:	83 c4 10             	add    $0x10,%esp
80103ae7:	31 c0                	xor    %eax,%eax
}
80103ae9:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103aec:	5b                   	pop    %ebx
80103aed:	5e                   	pop    %esi
80103aee:	5d                   	pop    %ebp
80103aef:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103af0:	83 ec 04             	sub    $0x4,%esp
80103af3:	01 c6                	add    %eax,%esi
80103af5:	56                   	push   %esi
80103af6:	50                   	push   %eax
80103af7:	ff 73 04             	pushl  0x4(%ebx)
80103afa:	e8 81 34 00 00       	call   80106f80 <allocuvm>
80103aff:	83 c4 10             	add    $0x10,%esp
80103b02:	85 c0                	test   %eax,%eax
80103b04:	75 d3                	jne    80103ad9 <growproc+0x29>
      return -1;
80103b06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b0b:	eb dc                	jmp    80103ae9 <growproc+0x39>
80103b0d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b10:	83 ec 04             	sub    $0x4,%esp
80103b13:	01 c6                	add    %eax,%esi
80103b15:	56                   	push   %esi
80103b16:	50                   	push   %eax
80103b17:	ff 73 04             	pushl  0x4(%ebx)
80103b1a:	e8 a1 35 00 00       	call   801070c0 <deallocuvm>
80103b1f:	83 c4 10             	add    $0x10,%esp
80103b22:	85 c0                	test   %eax,%eax
80103b24:	75 b3                	jne    80103ad9 <growproc+0x29>
80103b26:	eb de                	jmp    80103b06 <growproc+0x56>
80103b28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b2f:	90                   	nop

80103b30 <fork>:
{
80103b30:	f3 0f 1e fb          	endbr32 
80103b34:	55                   	push   %ebp
80103b35:	89 e5                	mov    %esp,%ebp
80103b37:	57                   	push   %edi
80103b38:	56                   	push   %esi
80103b39:	53                   	push   %ebx
80103b3a:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103b3d:	e8 7e 09 00 00       	call   801044c0 <pushcli>
  c = mycpu();
80103b42:	e8 a9 fd ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80103b47:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b4d:	e8 be 09 00 00       	call   80104510 <popcli>
  if((np = allocproc()) == 0){
80103b52:	e8 49 fc ff ff       	call   801037a0 <allocproc>
80103b57:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b5a:	85 c0                	test   %eax,%eax
80103b5c:	0f 84 bb 00 00 00    	je     80103c1d <fork+0xed>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103b62:	83 ec 08             	sub    $0x8,%esp
80103b65:	ff 33                	pushl  (%ebx)
80103b67:	89 c7                	mov    %eax,%edi
80103b69:	ff 73 04             	pushl  0x4(%ebx)
80103b6c:	e8 cf 36 00 00       	call   80107240 <copyuvm>
80103b71:	83 c4 10             	add    $0x10,%esp
80103b74:	89 47 04             	mov    %eax,0x4(%edi)
80103b77:	85 c0                	test   %eax,%eax
80103b79:	0f 84 a5 00 00 00    	je     80103c24 <fork+0xf4>
  np->sz = curproc->sz;
80103b7f:	8b 03                	mov    (%ebx),%eax
80103b81:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103b84:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103b86:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103b89:	89 c8                	mov    %ecx,%eax
80103b8b:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103b8e:	b9 13 00 00 00       	mov    $0x13,%ecx
80103b93:	8b 73 18             	mov    0x18(%ebx),%esi
80103b96:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103b98:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103b9a:	8b 40 18             	mov    0x18(%eax),%eax
80103b9d:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103ba4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80103ba8:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103bac:	85 c0                	test   %eax,%eax
80103bae:	74 13                	je     80103bc3 <fork+0x93>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103bb0:	83 ec 0c             	sub    $0xc,%esp
80103bb3:	50                   	push   %eax
80103bb4:	e8 c7 d2 ff ff       	call   80100e80 <filedup>
80103bb9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103bbc:	83 c4 10             	add    $0x10,%esp
80103bbf:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103bc3:	83 c6 01             	add    $0x1,%esi
80103bc6:	83 fe 10             	cmp    $0x10,%esi
80103bc9:	75 dd                	jne    80103ba8 <fork+0x78>
  np->cwd = idup(curproc->cwd);
80103bcb:	83 ec 0c             	sub    $0xc,%esp
80103bce:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bd1:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103bd4:	e8 67 db ff ff       	call   80101740 <idup>
80103bd9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bdc:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103bdf:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103be2:	8d 47 6c             	lea    0x6c(%edi),%eax
80103be5:	6a 10                	push   $0x10
80103be7:	53                   	push   %ebx
80103be8:	50                   	push   %eax
80103be9:	e8 a2 0c 00 00       	call   80104890 <safestrcpy>
  pid = np->pid;
80103bee:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103bf1:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103bf8:	e8 c3 09 00 00       	call   801045c0 <acquire>
  np->state = RUNNABLE;
80103bfd:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103c04:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c0b:	e8 70 0a 00 00       	call   80104680 <release>
  return pid;
80103c10:	83 c4 10             	add    $0x10,%esp
}
80103c13:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c16:	89 d8                	mov    %ebx,%eax
80103c18:	5b                   	pop    %ebx
80103c19:	5e                   	pop    %esi
80103c1a:	5f                   	pop    %edi
80103c1b:	5d                   	pop    %ebp
80103c1c:	c3                   	ret    
    return -1;
80103c1d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c22:	eb ef                	jmp    80103c13 <fork+0xe3>
    kfree(np->kstack);
80103c24:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103c27:	83 ec 0c             	sub    $0xc,%esp
80103c2a:	ff 73 08             	pushl  0x8(%ebx)
80103c2d:	e8 4e e8 ff ff       	call   80102480 <kfree>
    np->kstack = 0;
80103c32:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103c39:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103c3c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103c43:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c48:	eb c9                	jmp    80103c13 <fork+0xe3>
80103c4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103c50 <scheduler>:
{
80103c50:	f3 0f 1e fb          	endbr32 
80103c54:	55                   	push   %ebp
80103c55:	89 e5                	mov    %esp,%ebp
80103c57:	57                   	push   %edi
80103c58:	56                   	push   %esi
80103c59:	53                   	push   %ebx
80103c5a:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80103c5d:	e8 8e fc ff ff       	call   801038f0 <mycpu>
  c->proc = 0;
80103c62:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103c69:	00 00 00 
  struct cpu *c = mycpu();
80103c6c:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103c6e:	8d 40 04             	lea    0x4(%eax),%eax
80103c71:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103c74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
80103c78:	fb                   	sti    
    acquire(&ptable.lock);
80103c79:	83 ec 0c             	sub    $0xc,%esp
    int max=-1, process_sched_pid=-1;
80103c7c:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80103c81:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    acquire(&ptable.lock);
80103c86:	68 20 2d 11 80       	push   $0x80112d20
80103c8b:	e8 30 09 00 00       	call   801045c0 <acquire>
80103c90:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c93:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103c98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c9f:	90                   	nop
         if(max<p->priority && p->state==RUNNABLE)
80103ca0:	8b 50 7c             	mov    0x7c(%eax),%edx
80103ca3:	39 da                	cmp    %ebx,%edx
80103ca5:	7e 11                	jle    80103cb8 <scheduler+0x68>
80103ca7:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103cab:	75 0b                	jne    80103cb8 <scheduler+0x68>
           process_sched_pid=p->pid;
80103cad:	8b 78 10             	mov    0x10(%eax),%edi
80103cb0:	89 d3                	mov    %edx,%ebx
80103cb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cb8:	83 e8 80             	sub    $0xffffff80,%eax
80103cbb:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103cc0:	75 de                	jne    80103ca0 <scheduler+0x50>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){     
80103cc2:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103cc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103cce:	66 90                	xchg   %ax,%ax
      if(p->pid!=process_sched_pid)
80103cd0:	39 7b 10             	cmp    %edi,0x10(%ebx)
80103cd3:	75 35                	jne    80103d0a <scheduler+0xba>
      switchuvm(p);
80103cd5:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103cd8:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103cde:	53                   	push   %ebx
80103cdf:	e8 3c 30 00 00       	call   80106d20 <switchuvm>
      p->state = RUNNING;
80103ce4:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103ceb:	58                   	pop    %eax
80103cec:	5a                   	pop    %edx
80103ced:	ff 73 1c             	pushl  0x1c(%ebx)
80103cf0:	ff 75 e4             	pushl  -0x1c(%ebp)
80103cf3:	e8 fb 0b 00 00       	call   801048f3 <swtch>
      switchkvm();
80103cf8:	e8 03 30 00 00       	call   80106d00 <switchkvm>
      c->proc = 0;
80103cfd:	83 c4 10             	add    $0x10,%esp
80103d00:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103d07:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){     
80103d0a:	83 eb 80             	sub    $0xffffff80,%ebx
80103d0d:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80103d13:	75 bb                	jne    80103cd0 <scheduler+0x80>
    release(&ptable.lock);
80103d15:	83 ec 0c             	sub    $0xc,%esp
80103d18:	68 20 2d 11 80       	push   $0x80112d20
80103d1d:	e8 5e 09 00 00       	call   80104680 <release>
  for(;;){
80103d22:	83 c4 10             	add    $0x10,%esp
80103d25:	e9 4e ff ff ff       	jmp    80103c78 <scheduler+0x28>
80103d2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103d30 <sched>:
{
80103d30:	f3 0f 1e fb          	endbr32 
80103d34:	55                   	push   %ebp
80103d35:	89 e5                	mov    %esp,%ebp
80103d37:	56                   	push   %esi
80103d38:	53                   	push   %ebx
  pushcli();
80103d39:	e8 82 07 00 00       	call   801044c0 <pushcli>
  c = mycpu();
80103d3e:	e8 ad fb ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80103d43:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d49:	e8 c2 07 00 00       	call   80104510 <popcli>
  if(!holding(&ptable.lock))
80103d4e:	83 ec 0c             	sub    $0xc,%esp
80103d51:	68 20 2d 11 80       	push   $0x80112d20
80103d56:	e8 15 08 00 00       	call   80104570 <holding>
80103d5b:	83 c4 10             	add    $0x10,%esp
80103d5e:	85 c0                	test   %eax,%eax
80103d60:	74 4f                	je     80103db1 <sched+0x81>
  if(mycpu()->ncli != 1)
80103d62:	e8 89 fb ff ff       	call   801038f0 <mycpu>
80103d67:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103d6e:	75 68                	jne    80103dd8 <sched+0xa8>
  if(p->state == RUNNING)
80103d70:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103d74:	74 55                	je     80103dcb <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103d76:	9c                   	pushf  
80103d77:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103d78:	f6 c4 02             	test   $0x2,%ah
80103d7b:	75 41                	jne    80103dbe <sched+0x8e>
  intena = mycpu()->intena;
80103d7d:	e8 6e fb ff ff       	call   801038f0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103d82:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103d85:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103d8b:	e8 60 fb ff ff       	call   801038f0 <mycpu>
80103d90:	83 ec 08             	sub    $0x8,%esp
80103d93:	ff 70 04             	pushl  0x4(%eax)
80103d96:	53                   	push   %ebx
80103d97:	e8 57 0b 00 00       	call   801048f3 <swtch>
  mycpu()->intena = intena;
80103d9c:	e8 4f fb ff ff       	call   801038f0 <mycpu>
}
80103da1:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103da4:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103daa:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103dad:	5b                   	pop    %ebx
80103dae:	5e                   	pop    %esi
80103daf:	5d                   	pop    %ebp
80103db0:	c3                   	ret    
    panic("sched ptable.lock");
80103db1:	83 ec 0c             	sub    $0xc,%esp
80103db4:	68 9b 79 10 80       	push   $0x8010799b
80103db9:	e8 d2 c5 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103dbe:	83 ec 0c             	sub    $0xc,%esp
80103dc1:	68 c7 79 10 80       	push   $0x801079c7
80103dc6:	e8 c5 c5 ff ff       	call   80100390 <panic>
    panic("sched running");
80103dcb:	83 ec 0c             	sub    $0xc,%esp
80103dce:	68 b9 79 10 80       	push   $0x801079b9
80103dd3:	e8 b8 c5 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103dd8:	83 ec 0c             	sub    $0xc,%esp
80103ddb:	68 ad 79 10 80       	push   $0x801079ad
80103de0:	e8 ab c5 ff ff       	call   80100390 <panic>
80103de5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103dec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103df0 <exit>:
{
80103df0:	f3 0f 1e fb          	endbr32 
80103df4:	55                   	push   %ebp
80103df5:	89 e5                	mov    %esp,%ebp
80103df7:	57                   	push   %edi
80103df8:	56                   	push   %esi
80103df9:	53                   	push   %ebx
80103dfa:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103dfd:	e8 be 06 00 00       	call   801044c0 <pushcli>
  c = mycpu();
80103e02:	e8 e9 fa ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80103e07:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103e0d:	e8 fe 06 00 00       	call   80104510 <popcli>
  if(curproc == initproc)
80103e12:	8d 5e 28             	lea    0x28(%esi),%ebx
80103e15:	8d 7e 68             	lea    0x68(%esi),%edi
80103e18:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
80103e1e:	0f 84 f3 00 00 00    	je     80103f17 <exit+0x127>
80103e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
80103e28:	8b 03                	mov    (%ebx),%eax
80103e2a:	85 c0                	test   %eax,%eax
80103e2c:	74 12                	je     80103e40 <exit+0x50>
      fileclose(curproc->ofile[fd]);
80103e2e:	83 ec 0c             	sub    $0xc,%esp
80103e31:	50                   	push   %eax
80103e32:	e8 99 d0 ff ff       	call   80100ed0 <fileclose>
      curproc->ofile[fd] = 0;
80103e37:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103e3d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103e40:	83 c3 04             	add    $0x4,%ebx
80103e43:	39 df                	cmp    %ebx,%edi
80103e45:	75 e1                	jne    80103e28 <exit+0x38>
  begin_op();
80103e47:	e8 f4 ee ff ff       	call   80102d40 <begin_op>
  iput(curproc->cwd);
80103e4c:	83 ec 0c             	sub    $0xc,%esp
80103e4f:	ff 76 68             	pushl  0x68(%esi)
80103e52:	e8 49 da ff ff       	call   801018a0 <iput>
  end_op();
80103e57:	e8 54 ef ff ff       	call   80102db0 <end_op>
  curproc->cwd = 0;
80103e5c:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103e63:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e6a:	e8 51 07 00 00       	call   801045c0 <acquire>
  wakeup1(curproc->parent);
80103e6f:	8b 56 14             	mov    0x14(%esi),%edx
80103e72:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e75:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103e7a:	eb 0e                	jmp    80103e8a <exit+0x9a>
80103e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e80:	83 e8 80             	sub    $0xffffff80,%eax
80103e83:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103e88:	74 1c                	je     80103ea6 <exit+0xb6>
    if(p->state == SLEEPING && p->chan == chan)
80103e8a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e8e:	75 f0                	jne    80103e80 <exit+0x90>
80103e90:	3b 50 20             	cmp    0x20(%eax),%edx
80103e93:	75 eb                	jne    80103e80 <exit+0x90>
      p->state = RUNNABLE;
80103e95:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e9c:	83 e8 80             	sub    $0xffffff80,%eax
80103e9f:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103ea4:	75 e4                	jne    80103e8a <exit+0x9a>
      p->parent = initproc;
80103ea6:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103eac:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103eb1:	eb 10                	jmp    80103ec3 <exit+0xd3>
80103eb3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103eb7:	90                   	nop
80103eb8:	83 ea 80             	sub    $0xffffff80,%edx
80103ebb:	81 fa 54 4d 11 80    	cmp    $0x80114d54,%edx
80103ec1:	74 3b                	je     80103efe <exit+0x10e>
    if(p->parent == curproc){
80103ec3:	39 72 14             	cmp    %esi,0x14(%edx)
80103ec6:	75 f0                	jne    80103eb8 <exit+0xc8>
      if(p->state == ZOMBIE)
80103ec8:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103ecc:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103ecf:	75 e7                	jne    80103eb8 <exit+0xc8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ed1:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103ed6:	eb 12                	jmp    80103eea <exit+0xfa>
80103ed8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103edf:	90                   	nop
80103ee0:	83 e8 80             	sub    $0xffffff80,%eax
80103ee3:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103ee8:	74 ce                	je     80103eb8 <exit+0xc8>
    if(p->state == SLEEPING && p->chan == chan)
80103eea:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103eee:	75 f0                	jne    80103ee0 <exit+0xf0>
80103ef0:	3b 48 20             	cmp    0x20(%eax),%ecx
80103ef3:	75 eb                	jne    80103ee0 <exit+0xf0>
      p->state = RUNNABLE;
80103ef5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103efc:	eb e2                	jmp    80103ee0 <exit+0xf0>
  curproc->state = ZOMBIE;
80103efe:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103f05:	e8 26 fe ff ff       	call   80103d30 <sched>
  panic("zombie exit");
80103f0a:	83 ec 0c             	sub    $0xc,%esp
80103f0d:	68 e8 79 10 80       	push   $0x801079e8
80103f12:	e8 79 c4 ff ff       	call   80100390 <panic>
    panic("init exiting");
80103f17:	83 ec 0c             	sub    $0xc,%esp
80103f1a:	68 db 79 10 80       	push   $0x801079db
80103f1f:	e8 6c c4 ff ff       	call   80100390 <panic>
80103f24:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f2f:	90                   	nop

80103f30 <yield>:
{
80103f30:	f3 0f 1e fb          	endbr32 
80103f34:	55                   	push   %ebp
80103f35:	89 e5                	mov    %esp,%ebp
80103f37:	53                   	push   %ebx
80103f38:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103f3b:	68 20 2d 11 80       	push   $0x80112d20
80103f40:	e8 7b 06 00 00       	call   801045c0 <acquire>
  pushcli();
80103f45:	e8 76 05 00 00       	call   801044c0 <pushcli>
  c = mycpu();
80103f4a:	e8 a1 f9 ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80103f4f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f55:	e8 b6 05 00 00       	call   80104510 <popcli>
  myproc()->state = RUNNABLE;
80103f5a:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103f61:	e8 ca fd ff ff       	call   80103d30 <sched>
  release(&ptable.lock);
80103f66:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103f6d:	e8 0e 07 00 00       	call   80104680 <release>
}
80103f72:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f75:	83 c4 10             	add    $0x10,%esp
80103f78:	c9                   	leave  
80103f79:	c3                   	ret    
80103f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103f80 <sleep>:
{
80103f80:	f3 0f 1e fb          	endbr32 
80103f84:	55                   	push   %ebp
80103f85:	89 e5                	mov    %esp,%ebp
80103f87:	57                   	push   %edi
80103f88:	56                   	push   %esi
80103f89:	53                   	push   %ebx
80103f8a:	83 ec 0c             	sub    $0xc,%esp
80103f8d:	8b 7d 08             	mov    0x8(%ebp),%edi
80103f90:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80103f93:	e8 28 05 00 00       	call   801044c0 <pushcli>
  c = mycpu();
80103f98:	e8 53 f9 ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80103f9d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103fa3:	e8 68 05 00 00       	call   80104510 <popcli>
  if(p == 0)
80103fa8:	85 db                	test   %ebx,%ebx
80103faa:	0f 84 83 00 00 00    	je     80104033 <sleep+0xb3>
  if(lk == 0)
80103fb0:	85 f6                	test   %esi,%esi
80103fb2:	74 72                	je     80104026 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103fb4:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103fba:	74 4c                	je     80104008 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103fbc:	83 ec 0c             	sub    $0xc,%esp
80103fbf:	68 20 2d 11 80       	push   $0x80112d20
80103fc4:	e8 f7 05 00 00       	call   801045c0 <acquire>
    release(lk);
80103fc9:	89 34 24             	mov    %esi,(%esp)
80103fcc:	e8 af 06 00 00       	call   80104680 <release>
  p->chan = chan;
80103fd1:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103fd4:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103fdb:	e8 50 fd ff ff       	call   80103d30 <sched>
  p->chan = 0;
80103fe0:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103fe7:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103fee:	e8 8d 06 00 00       	call   80104680 <release>
    acquire(lk);
80103ff3:	89 75 08             	mov    %esi,0x8(%ebp)
80103ff6:	83 c4 10             	add    $0x10,%esp
}
80103ff9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ffc:	5b                   	pop    %ebx
80103ffd:	5e                   	pop    %esi
80103ffe:	5f                   	pop    %edi
80103fff:	5d                   	pop    %ebp
    acquire(lk);
80104000:	e9 bb 05 00 00       	jmp    801045c0 <acquire>
80104005:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
80104008:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010400b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104012:	e8 19 fd ff ff       	call   80103d30 <sched>
  p->chan = 0;
80104017:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010401e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104021:	5b                   	pop    %ebx
80104022:	5e                   	pop    %esi
80104023:	5f                   	pop    %edi
80104024:	5d                   	pop    %ebp
80104025:	c3                   	ret    
    panic("sleep without lk");
80104026:	83 ec 0c             	sub    $0xc,%esp
80104029:	68 fa 79 10 80       	push   $0x801079fa
8010402e:	e8 5d c3 ff ff       	call   80100390 <panic>
    panic("sleep");
80104033:	83 ec 0c             	sub    $0xc,%esp
80104036:	68 f4 79 10 80       	push   $0x801079f4
8010403b:	e8 50 c3 ff ff       	call   80100390 <panic>

80104040 <wait>:
{
80104040:	f3 0f 1e fb          	endbr32 
80104044:	55                   	push   %ebp
80104045:	89 e5                	mov    %esp,%ebp
80104047:	56                   	push   %esi
80104048:	53                   	push   %ebx
  pushcli();
80104049:	e8 72 04 00 00       	call   801044c0 <pushcli>
  c = mycpu();
8010404e:	e8 9d f8 ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80104053:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104059:	e8 b2 04 00 00       	call   80104510 <popcli>
  acquire(&ptable.lock);
8010405e:	83 ec 0c             	sub    $0xc,%esp
80104061:	68 20 2d 11 80       	push   $0x80112d20
80104066:	e8 55 05 00 00       	call   801045c0 <acquire>
8010406b:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010406e:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104070:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80104075:	eb 14                	jmp    8010408b <wait+0x4b>
80104077:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010407e:	66 90                	xchg   %ax,%ax
80104080:	83 eb 80             	sub    $0xffffff80,%ebx
80104083:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80104089:	74 1b                	je     801040a6 <wait+0x66>
      if(p->parent != curproc)
8010408b:	39 73 14             	cmp    %esi,0x14(%ebx)
8010408e:	75 f0                	jne    80104080 <wait+0x40>
      if(p->state == ZOMBIE){
80104090:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104094:	74 32                	je     801040c8 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104096:	83 eb 80             	sub    $0xffffff80,%ebx
      havekids = 1;
80104099:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010409e:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
801040a4:	75 e5                	jne    8010408b <wait+0x4b>
    if(!havekids || curproc->killed){
801040a6:	85 c0                	test   %eax,%eax
801040a8:	74 74                	je     8010411e <wait+0xde>
801040aa:	8b 46 24             	mov    0x24(%esi),%eax
801040ad:	85 c0                	test   %eax,%eax
801040af:	75 6d                	jne    8010411e <wait+0xde>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801040b1:	83 ec 08             	sub    $0x8,%esp
801040b4:	68 20 2d 11 80       	push   $0x80112d20
801040b9:	56                   	push   %esi
801040ba:	e8 c1 fe ff ff       	call   80103f80 <sleep>
    havekids = 0;
801040bf:	83 c4 10             	add    $0x10,%esp
801040c2:	eb aa                	jmp    8010406e <wait+0x2e>
801040c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
801040c8:	83 ec 0c             	sub    $0xc,%esp
801040cb:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
801040ce:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801040d1:	e8 aa e3 ff ff       	call   80102480 <kfree>
        freevm(p->pgdir);
801040d6:	5a                   	pop    %edx
801040d7:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
801040da:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801040e1:	e8 0a 30 00 00       	call   801070f0 <freevm>
        release(&ptable.lock);
801040e6:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        p->pid = 0;
801040ed:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801040f4:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801040fb:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801040ff:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104106:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010410d:	e8 6e 05 00 00       	call   80104680 <release>
        return pid;
80104112:	83 c4 10             	add    $0x10,%esp
}
80104115:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104118:	89 f0                	mov    %esi,%eax
8010411a:	5b                   	pop    %ebx
8010411b:	5e                   	pop    %esi
8010411c:	5d                   	pop    %ebp
8010411d:	c3                   	ret    
      release(&ptable.lock);
8010411e:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104121:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104126:	68 20 2d 11 80       	push   $0x80112d20
8010412b:	e8 50 05 00 00       	call   80104680 <release>
      return -1;
80104130:	83 c4 10             	add    $0x10,%esp
80104133:	eb e0                	jmp    80104115 <wait+0xd5>
80104135:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010413c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104140 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104140:	f3 0f 1e fb          	endbr32 
80104144:	55                   	push   %ebp
80104145:	89 e5                	mov    %esp,%ebp
80104147:	53                   	push   %ebx
80104148:	83 ec 10             	sub    $0x10,%esp
8010414b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010414e:	68 20 2d 11 80       	push   $0x80112d20
80104153:	e8 68 04 00 00       	call   801045c0 <acquire>
80104158:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010415b:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80104160:	eb 10                	jmp    80104172 <wakeup+0x32>
80104162:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104168:	83 e8 80             	sub    $0xffffff80,%eax
8010416b:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80104170:	74 1c                	je     8010418e <wakeup+0x4e>
    if(p->state == SLEEPING && p->chan == chan)
80104172:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104176:	75 f0                	jne    80104168 <wakeup+0x28>
80104178:	3b 58 20             	cmp    0x20(%eax),%ebx
8010417b:	75 eb                	jne    80104168 <wakeup+0x28>
      p->state = RUNNABLE;
8010417d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104184:	83 e8 80             	sub    $0xffffff80,%eax
80104187:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
8010418c:	75 e4                	jne    80104172 <wakeup+0x32>
  wakeup1(chan);
  release(&ptable.lock);
8010418e:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80104195:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104198:	c9                   	leave  
  release(&ptable.lock);
80104199:	e9 e2 04 00 00       	jmp    80104680 <release>
8010419e:	66 90                	xchg   %ax,%ax

801041a0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801041a0:	f3 0f 1e fb          	endbr32 
801041a4:	55                   	push   %ebp
801041a5:	89 e5                	mov    %esp,%ebp
801041a7:	53                   	push   %ebx
801041a8:	83 ec 10             	sub    $0x10,%esp
801041ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801041ae:	68 20 2d 11 80       	push   $0x80112d20
801041b3:	e8 08 04 00 00       	call   801045c0 <acquire>
801041b8:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041bb:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801041c0:	eb 10                	jmp    801041d2 <kill+0x32>
801041c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801041c8:	83 e8 80             	sub    $0xffffff80,%eax
801041cb:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
801041d0:	74 36                	je     80104208 <kill+0x68>
    if(p->pid == pid){
801041d2:	39 58 10             	cmp    %ebx,0x10(%eax)
801041d5:	75 f1                	jne    801041c8 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801041d7:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801041db:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801041e2:	75 07                	jne    801041eb <kill+0x4b>
        p->state = RUNNABLE;
801041e4:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801041eb:	83 ec 0c             	sub    $0xc,%esp
801041ee:	68 20 2d 11 80       	push   $0x80112d20
801041f3:	e8 88 04 00 00       	call   80104680 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801041f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801041fb:	83 c4 10             	add    $0x10,%esp
801041fe:	31 c0                	xor    %eax,%eax
}
80104200:	c9                   	leave  
80104201:	c3                   	ret    
80104202:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104208:	83 ec 0c             	sub    $0xc,%esp
8010420b:	68 20 2d 11 80       	push   $0x80112d20
80104210:	e8 6b 04 00 00       	call   80104680 <release>
}
80104215:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104218:	83 c4 10             	add    $0x10,%esp
8010421b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104220:	c9                   	leave  
80104221:	c3                   	ret    
80104222:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104230 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104230:	f3 0f 1e fb          	endbr32 
80104234:	55                   	push   %ebp
80104235:	89 e5                	mov    %esp,%ebp
80104237:	57                   	push   %edi
80104238:	56                   	push   %esi
80104239:	8d 75 e8             	lea    -0x18(%ebp),%esi
8010423c:	53                   	push   %ebx
8010423d:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
80104242:	83 ec 3c             	sub    $0x3c,%esp
80104245:	eb 28                	jmp    8010426f <procdump+0x3f>
80104247:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010424e:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104250:	83 ec 0c             	sub    $0xc,%esp
80104253:	68 55 7c 10 80       	push   $0x80107c55
80104258:	e8 53 c4 ff ff       	call   801006b0 <cprintf>
8010425d:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104260:	83 eb 80             	sub    $0xffffff80,%ebx
80104263:	81 fb c0 4d 11 80    	cmp    $0x80114dc0,%ebx
80104269:	0f 84 81 00 00 00    	je     801042f0 <procdump+0xc0>
    if(p->state == UNUSED)
8010426f:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104272:	85 c0                	test   %eax,%eax
80104274:	74 ea                	je     80104260 <procdump+0x30>
      state = "???";
80104276:	ba 0b 7a 10 80       	mov    $0x80107a0b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010427b:	83 f8 05             	cmp    $0x5,%eax
8010427e:	77 11                	ja     80104291 <procdump+0x61>
80104280:	8b 14 85 6c 7a 10 80 	mov    -0x7fef8594(,%eax,4),%edx
      state = "???";
80104287:	b8 0b 7a 10 80       	mov    $0x80107a0b,%eax
8010428c:	85 d2                	test   %edx,%edx
8010428e:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104291:	53                   	push   %ebx
80104292:	52                   	push   %edx
80104293:	ff 73 a4             	pushl  -0x5c(%ebx)
80104296:	68 0f 7a 10 80       	push   $0x80107a0f
8010429b:	e8 10 c4 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
801042a0:	83 c4 10             	add    $0x10,%esp
801042a3:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801042a7:	75 a7                	jne    80104250 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801042a9:	83 ec 08             	sub    $0x8,%esp
801042ac:	8d 45 c0             	lea    -0x40(%ebp),%eax
801042af:	8d 7d c0             	lea    -0x40(%ebp),%edi
801042b2:	50                   	push   %eax
801042b3:	8b 43 b0             	mov    -0x50(%ebx),%eax
801042b6:	8b 40 0c             	mov    0xc(%eax),%eax
801042b9:	83 c0 08             	add    $0x8,%eax
801042bc:	50                   	push   %eax
801042bd:	e8 9e 01 00 00       	call   80104460 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801042c2:	83 c4 10             	add    $0x10,%esp
801042c5:	8d 76 00             	lea    0x0(%esi),%esi
801042c8:	8b 17                	mov    (%edi),%edx
801042ca:	85 d2                	test   %edx,%edx
801042cc:	74 82                	je     80104250 <procdump+0x20>
        cprintf(" %p", pc[i]);
801042ce:	83 ec 08             	sub    $0x8,%esp
801042d1:	83 c7 04             	add    $0x4,%edi
801042d4:	52                   	push   %edx
801042d5:	68 61 74 10 80       	push   $0x80107461
801042da:	e8 d1 c3 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801042df:	83 c4 10             	add    $0x10,%esp
801042e2:	39 fe                	cmp    %edi,%esi
801042e4:	75 e2                	jne    801042c8 <procdump+0x98>
801042e6:	e9 65 ff ff ff       	jmp    80104250 <procdump+0x20>
801042eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042ef:	90                   	nop
  }
}
801042f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042f3:	5b                   	pop    %ebx
801042f4:	5e                   	pop    %esi
801042f5:	5f                   	pop    %edi
801042f6:	5d                   	pop    %ebp
801042f7:	c3                   	ret    
801042f8:	66 90                	xchg   %ax,%ax
801042fa:	66 90                	xchg   %ax,%ax
801042fc:	66 90                	xchg   %ax,%ax
801042fe:	66 90                	xchg   %ax,%ax

80104300 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104300:	f3 0f 1e fb          	endbr32 
80104304:	55                   	push   %ebp
80104305:	89 e5                	mov    %esp,%ebp
80104307:	53                   	push   %ebx
80104308:	83 ec 0c             	sub    $0xc,%esp
8010430b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010430e:	68 84 7a 10 80       	push   $0x80107a84
80104313:	8d 43 04             	lea    0x4(%ebx),%eax
80104316:	50                   	push   %eax
80104317:	e8 24 01 00 00       	call   80104440 <initlock>
  lk->name = name;
8010431c:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010431f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104325:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104328:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010432f:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104332:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104335:	c9                   	leave  
80104336:	c3                   	ret    
80104337:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010433e:	66 90                	xchg   %ax,%ax

80104340 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104340:	f3 0f 1e fb          	endbr32 
80104344:	55                   	push   %ebp
80104345:	89 e5                	mov    %esp,%ebp
80104347:	56                   	push   %esi
80104348:	53                   	push   %ebx
80104349:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010434c:	8d 73 04             	lea    0x4(%ebx),%esi
8010434f:	83 ec 0c             	sub    $0xc,%esp
80104352:	56                   	push   %esi
80104353:	e8 68 02 00 00       	call   801045c0 <acquire>
  while (lk->locked) {
80104358:	8b 13                	mov    (%ebx),%edx
8010435a:	83 c4 10             	add    $0x10,%esp
8010435d:	85 d2                	test   %edx,%edx
8010435f:	74 1a                	je     8010437b <acquiresleep+0x3b>
80104361:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104368:	83 ec 08             	sub    $0x8,%esp
8010436b:	56                   	push   %esi
8010436c:	53                   	push   %ebx
8010436d:	e8 0e fc ff ff       	call   80103f80 <sleep>
  while (lk->locked) {
80104372:	8b 03                	mov    (%ebx),%eax
80104374:	83 c4 10             	add    $0x10,%esp
80104377:	85 c0                	test   %eax,%eax
80104379:	75 ed                	jne    80104368 <acquiresleep+0x28>
  }
  lk->locked = 1;
8010437b:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104381:	e8 fa f5 ff ff       	call   80103980 <myproc>
80104386:	8b 40 10             	mov    0x10(%eax),%eax
80104389:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
8010438c:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010438f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104392:	5b                   	pop    %ebx
80104393:	5e                   	pop    %esi
80104394:	5d                   	pop    %ebp
  release(&lk->lk);
80104395:	e9 e6 02 00 00       	jmp    80104680 <release>
8010439a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801043a0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801043a0:	f3 0f 1e fb          	endbr32 
801043a4:	55                   	push   %ebp
801043a5:	89 e5                	mov    %esp,%ebp
801043a7:	56                   	push   %esi
801043a8:	53                   	push   %ebx
801043a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801043ac:	8d 73 04             	lea    0x4(%ebx),%esi
801043af:	83 ec 0c             	sub    $0xc,%esp
801043b2:	56                   	push   %esi
801043b3:	e8 08 02 00 00       	call   801045c0 <acquire>
  lk->locked = 0;
801043b8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801043be:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801043c5:	89 1c 24             	mov    %ebx,(%esp)
801043c8:	e8 73 fd ff ff       	call   80104140 <wakeup>
  release(&lk->lk);
801043cd:	89 75 08             	mov    %esi,0x8(%ebp)
801043d0:	83 c4 10             	add    $0x10,%esp
}
801043d3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801043d6:	5b                   	pop    %ebx
801043d7:	5e                   	pop    %esi
801043d8:	5d                   	pop    %ebp
  release(&lk->lk);
801043d9:	e9 a2 02 00 00       	jmp    80104680 <release>
801043de:	66 90                	xchg   %ax,%ax

801043e0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801043e0:	f3 0f 1e fb          	endbr32 
801043e4:	55                   	push   %ebp
801043e5:	89 e5                	mov    %esp,%ebp
801043e7:	57                   	push   %edi
801043e8:	31 ff                	xor    %edi,%edi
801043ea:	56                   	push   %esi
801043eb:	53                   	push   %ebx
801043ec:	83 ec 18             	sub    $0x18,%esp
801043ef:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801043f2:	8d 73 04             	lea    0x4(%ebx),%esi
801043f5:	56                   	push   %esi
801043f6:	e8 c5 01 00 00       	call   801045c0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801043fb:	8b 03                	mov    (%ebx),%eax
801043fd:	83 c4 10             	add    $0x10,%esp
80104400:	85 c0                	test   %eax,%eax
80104402:	75 1c                	jne    80104420 <holdingsleep+0x40>
  release(&lk->lk);
80104404:	83 ec 0c             	sub    $0xc,%esp
80104407:	56                   	push   %esi
80104408:	e8 73 02 00 00       	call   80104680 <release>
  return r;
}
8010440d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104410:	89 f8                	mov    %edi,%eax
80104412:	5b                   	pop    %ebx
80104413:	5e                   	pop    %esi
80104414:	5f                   	pop    %edi
80104415:	5d                   	pop    %ebp
80104416:	c3                   	ret    
80104417:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010441e:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
80104420:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104423:	e8 58 f5 ff ff       	call   80103980 <myproc>
80104428:	39 58 10             	cmp    %ebx,0x10(%eax)
8010442b:	0f 94 c0             	sete   %al
8010442e:	0f b6 c0             	movzbl %al,%eax
80104431:	89 c7                	mov    %eax,%edi
80104433:	eb cf                	jmp    80104404 <holdingsleep+0x24>
80104435:	66 90                	xchg   %ax,%ax
80104437:	66 90                	xchg   %ax,%ax
80104439:	66 90                	xchg   %ax,%ax
8010443b:	66 90                	xchg   %ax,%ax
8010443d:	66 90                	xchg   %ax,%ax
8010443f:	90                   	nop

80104440 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104440:	f3 0f 1e fb          	endbr32 
80104444:	55                   	push   %ebp
80104445:	89 e5                	mov    %esp,%ebp
80104447:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
8010444a:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
8010444d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104453:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104456:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
8010445d:	5d                   	pop    %ebp
8010445e:	c3                   	ret    
8010445f:	90                   	nop

80104460 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104460:	f3 0f 1e fb          	endbr32 
80104464:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104465:	31 d2                	xor    %edx,%edx
{
80104467:	89 e5                	mov    %esp,%ebp
80104469:	53                   	push   %ebx
  ebp = (uint*)v - 2;
8010446a:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010446d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104470:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104473:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104477:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104478:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
8010447e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104484:	77 1a                	ja     801044a0 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104486:	8b 58 04             	mov    0x4(%eax),%ebx
80104489:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
8010448c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
8010448f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104491:	83 fa 0a             	cmp    $0xa,%edx
80104494:	75 e2                	jne    80104478 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104496:	5b                   	pop    %ebx
80104497:	5d                   	pop    %ebp
80104498:	c3                   	ret    
80104499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
801044a0:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801044a3:	8d 51 28             	lea    0x28(%ecx),%edx
801044a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044ad:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
801044b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801044b6:	83 c0 04             	add    $0x4,%eax
801044b9:	39 d0                	cmp    %edx,%eax
801044bb:	75 f3                	jne    801044b0 <getcallerpcs+0x50>
}
801044bd:	5b                   	pop    %ebx
801044be:	5d                   	pop    %ebp
801044bf:	c3                   	ret    

801044c0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801044c0:	f3 0f 1e fb          	endbr32 
801044c4:	55                   	push   %ebp
801044c5:	89 e5                	mov    %esp,%ebp
801044c7:	53                   	push   %ebx
801044c8:	83 ec 04             	sub    $0x4,%esp
801044cb:	9c                   	pushf  
801044cc:	5b                   	pop    %ebx
  asm volatile("cli");
801044cd:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801044ce:	e8 1d f4 ff ff       	call   801038f0 <mycpu>
801044d3:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801044d9:	85 c0                	test   %eax,%eax
801044db:	74 13                	je     801044f0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801044dd:	e8 0e f4 ff ff       	call   801038f0 <mycpu>
801044e2:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801044e9:	83 c4 04             	add    $0x4,%esp
801044ec:	5b                   	pop    %ebx
801044ed:	5d                   	pop    %ebp
801044ee:	c3                   	ret    
801044ef:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
801044f0:	e8 fb f3 ff ff       	call   801038f0 <mycpu>
801044f5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801044fb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104501:	eb da                	jmp    801044dd <pushcli+0x1d>
80104503:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010450a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104510 <popcli>:

void
popcli(void)
{
80104510:	f3 0f 1e fb          	endbr32 
80104514:	55                   	push   %ebp
80104515:	89 e5                	mov    %esp,%ebp
80104517:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010451a:	9c                   	pushf  
8010451b:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010451c:	f6 c4 02             	test   $0x2,%ah
8010451f:	75 31                	jne    80104552 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104521:	e8 ca f3 ff ff       	call   801038f0 <mycpu>
80104526:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
8010452d:	78 30                	js     8010455f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010452f:	e8 bc f3 ff ff       	call   801038f0 <mycpu>
80104534:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
8010453a:	85 d2                	test   %edx,%edx
8010453c:	74 02                	je     80104540 <popcli+0x30>
    sti();
}
8010453e:	c9                   	leave  
8010453f:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104540:	e8 ab f3 ff ff       	call   801038f0 <mycpu>
80104545:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010454b:	85 c0                	test   %eax,%eax
8010454d:	74 ef                	je     8010453e <popcli+0x2e>
  asm volatile("sti");
8010454f:	fb                   	sti    
}
80104550:	c9                   	leave  
80104551:	c3                   	ret    
    panic("popcli - interruptible");
80104552:	83 ec 0c             	sub    $0xc,%esp
80104555:	68 8f 7a 10 80       	push   $0x80107a8f
8010455a:	e8 31 be ff ff       	call   80100390 <panic>
    panic("popcli");
8010455f:	83 ec 0c             	sub    $0xc,%esp
80104562:	68 a6 7a 10 80       	push   $0x80107aa6
80104567:	e8 24 be ff ff       	call   80100390 <panic>
8010456c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104570 <holding>:
{
80104570:	f3 0f 1e fb          	endbr32 
80104574:	55                   	push   %ebp
80104575:	89 e5                	mov    %esp,%ebp
80104577:	56                   	push   %esi
80104578:	53                   	push   %ebx
80104579:	8b 75 08             	mov    0x8(%ebp),%esi
8010457c:	31 db                	xor    %ebx,%ebx
  pushcli();
8010457e:	e8 3d ff ff ff       	call   801044c0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104583:	8b 06                	mov    (%esi),%eax
80104585:	85 c0                	test   %eax,%eax
80104587:	75 0f                	jne    80104598 <holding+0x28>
  popcli();
80104589:	e8 82 ff ff ff       	call   80104510 <popcli>
}
8010458e:	89 d8                	mov    %ebx,%eax
80104590:	5b                   	pop    %ebx
80104591:	5e                   	pop    %esi
80104592:	5d                   	pop    %ebp
80104593:	c3                   	ret    
80104594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80104598:	8b 5e 08             	mov    0x8(%esi),%ebx
8010459b:	e8 50 f3 ff ff       	call   801038f0 <mycpu>
801045a0:	39 c3                	cmp    %eax,%ebx
801045a2:	0f 94 c3             	sete   %bl
  popcli();
801045a5:	e8 66 ff ff ff       	call   80104510 <popcli>
  r = lock->locked && lock->cpu == mycpu();
801045aa:	0f b6 db             	movzbl %bl,%ebx
}
801045ad:	89 d8                	mov    %ebx,%eax
801045af:	5b                   	pop    %ebx
801045b0:	5e                   	pop    %esi
801045b1:	5d                   	pop    %ebp
801045b2:	c3                   	ret    
801045b3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801045c0 <acquire>:
{
801045c0:	f3 0f 1e fb          	endbr32 
801045c4:	55                   	push   %ebp
801045c5:	89 e5                	mov    %esp,%ebp
801045c7:	56                   	push   %esi
801045c8:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
801045c9:	e8 f2 fe ff ff       	call   801044c0 <pushcli>
  if(holding(lk))
801045ce:	8b 5d 08             	mov    0x8(%ebp),%ebx
801045d1:	83 ec 0c             	sub    $0xc,%esp
801045d4:	53                   	push   %ebx
801045d5:	e8 96 ff ff ff       	call   80104570 <holding>
801045da:	83 c4 10             	add    $0x10,%esp
801045dd:	85 c0                	test   %eax,%eax
801045df:	0f 85 7f 00 00 00    	jne    80104664 <acquire+0xa4>
801045e5:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
801045e7:	ba 01 00 00 00       	mov    $0x1,%edx
801045ec:	eb 05                	jmp    801045f3 <acquire+0x33>
801045ee:	66 90                	xchg   %ax,%ax
801045f0:	8b 5d 08             	mov    0x8(%ebp),%ebx
801045f3:	89 d0                	mov    %edx,%eax
801045f5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
801045f8:	85 c0                	test   %eax,%eax
801045fa:	75 f4                	jne    801045f0 <acquire+0x30>
  __sync_synchronize();
801045fc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104601:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104604:	e8 e7 f2 ff ff       	call   801038f0 <mycpu>
80104609:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
8010460c:	89 e8                	mov    %ebp,%eax
8010460e:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104610:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80104616:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
8010461c:	77 22                	ja     80104640 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
8010461e:	8b 50 04             	mov    0x4(%eax),%edx
80104621:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80104625:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104628:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
8010462a:	83 fe 0a             	cmp    $0xa,%esi
8010462d:	75 e1                	jne    80104610 <acquire+0x50>
}
8010462f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104632:	5b                   	pop    %ebx
80104633:	5e                   	pop    %esi
80104634:	5d                   	pop    %ebp
80104635:	c3                   	ret    
80104636:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010463d:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80104640:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80104644:	83 c3 34             	add    $0x34,%ebx
80104647:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010464e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104650:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104656:	83 c0 04             	add    $0x4,%eax
80104659:	39 d8                	cmp    %ebx,%eax
8010465b:	75 f3                	jne    80104650 <acquire+0x90>
}
8010465d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104660:	5b                   	pop    %ebx
80104661:	5e                   	pop    %esi
80104662:	5d                   	pop    %ebp
80104663:	c3                   	ret    
    panic("acquire");
80104664:	83 ec 0c             	sub    $0xc,%esp
80104667:	68 ad 7a 10 80       	push   $0x80107aad
8010466c:	e8 1f bd ff ff       	call   80100390 <panic>
80104671:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104678:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010467f:	90                   	nop

80104680 <release>:
{
80104680:	f3 0f 1e fb          	endbr32 
80104684:	55                   	push   %ebp
80104685:	89 e5                	mov    %esp,%ebp
80104687:	53                   	push   %ebx
80104688:	83 ec 10             	sub    $0x10,%esp
8010468b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010468e:	53                   	push   %ebx
8010468f:	e8 dc fe ff ff       	call   80104570 <holding>
80104694:	83 c4 10             	add    $0x10,%esp
80104697:	85 c0                	test   %eax,%eax
80104699:	74 22                	je     801046bd <release+0x3d>
  lk->pcs[0] = 0;
8010469b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801046a2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801046a9:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801046ae:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801046b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046b7:	c9                   	leave  
  popcli();
801046b8:	e9 53 fe ff ff       	jmp    80104510 <popcli>
    panic("release");
801046bd:	83 ec 0c             	sub    $0xc,%esp
801046c0:	68 b5 7a 10 80       	push   $0x80107ab5
801046c5:	e8 c6 bc ff ff       	call   80100390 <panic>
801046ca:	66 90                	xchg   %ax,%ax
801046cc:	66 90                	xchg   %ax,%ax
801046ce:	66 90                	xchg   %ax,%ax

801046d0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801046d0:	f3 0f 1e fb          	endbr32 
801046d4:	55                   	push   %ebp
801046d5:	89 e5                	mov    %esp,%ebp
801046d7:	57                   	push   %edi
801046d8:	8b 55 08             	mov    0x8(%ebp),%edx
801046db:	8b 4d 10             	mov    0x10(%ebp),%ecx
801046de:	53                   	push   %ebx
801046df:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
801046e2:	89 d7                	mov    %edx,%edi
801046e4:	09 cf                	or     %ecx,%edi
801046e6:	83 e7 03             	and    $0x3,%edi
801046e9:	75 25                	jne    80104710 <memset+0x40>
    c &= 0xFF;
801046eb:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801046ee:	c1 e0 18             	shl    $0x18,%eax
801046f1:	89 fb                	mov    %edi,%ebx
801046f3:	c1 e9 02             	shr    $0x2,%ecx
801046f6:	c1 e3 10             	shl    $0x10,%ebx
801046f9:	09 d8                	or     %ebx,%eax
801046fb:	09 f8                	or     %edi,%eax
801046fd:	c1 e7 08             	shl    $0x8,%edi
80104700:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104702:	89 d7                	mov    %edx,%edi
80104704:	fc                   	cld    
80104705:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104707:	5b                   	pop    %ebx
80104708:	89 d0                	mov    %edx,%eax
8010470a:	5f                   	pop    %edi
8010470b:	5d                   	pop    %ebp
8010470c:	c3                   	ret    
8010470d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80104710:	89 d7                	mov    %edx,%edi
80104712:	fc                   	cld    
80104713:	f3 aa                	rep stos %al,%es:(%edi)
80104715:	5b                   	pop    %ebx
80104716:	89 d0                	mov    %edx,%eax
80104718:	5f                   	pop    %edi
80104719:	5d                   	pop    %ebp
8010471a:	c3                   	ret    
8010471b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010471f:	90                   	nop

80104720 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104720:	f3 0f 1e fb          	endbr32 
80104724:	55                   	push   %ebp
80104725:	89 e5                	mov    %esp,%ebp
80104727:	56                   	push   %esi
80104728:	8b 75 10             	mov    0x10(%ebp),%esi
8010472b:	8b 55 08             	mov    0x8(%ebp),%edx
8010472e:	53                   	push   %ebx
8010472f:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104732:	85 f6                	test   %esi,%esi
80104734:	74 2a                	je     80104760 <memcmp+0x40>
80104736:	01 c6                	add    %eax,%esi
80104738:	eb 10                	jmp    8010474a <memcmp+0x2a>
8010473a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104740:	83 c0 01             	add    $0x1,%eax
80104743:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104746:	39 f0                	cmp    %esi,%eax
80104748:	74 16                	je     80104760 <memcmp+0x40>
    if(*s1 != *s2)
8010474a:	0f b6 0a             	movzbl (%edx),%ecx
8010474d:	0f b6 18             	movzbl (%eax),%ebx
80104750:	38 d9                	cmp    %bl,%cl
80104752:	74 ec                	je     80104740 <memcmp+0x20>
      return *s1 - *s2;
80104754:	0f b6 c1             	movzbl %cl,%eax
80104757:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104759:	5b                   	pop    %ebx
8010475a:	5e                   	pop    %esi
8010475b:	5d                   	pop    %ebp
8010475c:	c3                   	ret    
8010475d:	8d 76 00             	lea    0x0(%esi),%esi
80104760:	5b                   	pop    %ebx
  return 0;
80104761:	31 c0                	xor    %eax,%eax
}
80104763:	5e                   	pop    %esi
80104764:	5d                   	pop    %ebp
80104765:	c3                   	ret    
80104766:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010476d:	8d 76 00             	lea    0x0(%esi),%esi

80104770 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104770:	f3 0f 1e fb          	endbr32 
80104774:	55                   	push   %ebp
80104775:	89 e5                	mov    %esp,%ebp
80104777:	57                   	push   %edi
80104778:	8b 55 08             	mov    0x8(%ebp),%edx
8010477b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010477e:	56                   	push   %esi
8010477f:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104782:	39 d6                	cmp    %edx,%esi
80104784:	73 2a                	jae    801047b0 <memmove+0x40>
80104786:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104789:	39 fa                	cmp    %edi,%edx
8010478b:	73 23                	jae    801047b0 <memmove+0x40>
8010478d:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104790:	85 c9                	test   %ecx,%ecx
80104792:	74 13                	je     801047a7 <memmove+0x37>
80104794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104798:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
8010479c:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
8010479f:	83 e8 01             	sub    $0x1,%eax
801047a2:	83 f8 ff             	cmp    $0xffffffff,%eax
801047a5:	75 f1                	jne    80104798 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801047a7:	5e                   	pop    %esi
801047a8:	89 d0                	mov    %edx,%eax
801047aa:	5f                   	pop    %edi
801047ab:	5d                   	pop    %ebp
801047ac:	c3                   	ret    
801047ad:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
801047b0:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
801047b3:	89 d7                	mov    %edx,%edi
801047b5:	85 c9                	test   %ecx,%ecx
801047b7:	74 ee                	je     801047a7 <memmove+0x37>
801047b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
801047c0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
801047c1:	39 f0                	cmp    %esi,%eax
801047c3:	75 fb                	jne    801047c0 <memmove+0x50>
}
801047c5:	5e                   	pop    %esi
801047c6:	89 d0                	mov    %edx,%eax
801047c8:	5f                   	pop    %edi
801047c9:	5d                   	pop    %ebp
801047ca:	c3                   	ret    
801047cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047cf:	90                   	nop

801047d0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801047d0:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
801047d4:	eb 9a                	jmp    80104770 <memmove>
801047d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047dd:	8d 76 00             	lea    0x0(%esi),%esi

801047e0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801047e0:	f3 0f 1e fb          	endbr32 
801047e4:	55                   	push   %ebp
801047e5:	89 e5                	mov    %esp,%ebp
801047e7:	56                   	push   %esi
801047e8:	8b 75 10             	mov    0x10(%ebp),%esi
801047eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
801047ee:	53                   	push   %ebx
801047ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
801047f2:	85 f6                	test   %esi,%esi
801047f4:	74 32                	je     80104828 <strncmp+0x48>
801047f6:	01 c6                	add    %eax,%esi
801047f8:	eb 14                	jmp    8010480e <strncmp+0x2e>
801047fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104800:	38 da                	cmp    %bl,%dl
80104802:	75 14                	jne    80104818 <strncmp+0x38>
    n--, p++, q++;
80104804:	83 c0 01             	add    $0x1,%eax
80104807:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010480a:	39 f0                	cmp    %esi,%eax
8010480c:	74 1a                	je     80104828 <strncmp+0x48>
8010480e:	0f b6 11             	movzbl (%ecx),%edx
80104811:	0f b6 18             	movzbl (%eax),%ebx
80104814:	84 d2                	test   %dl,%dl
80104816:	75 e8                	jne    80104800 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104818:	0f b6 c2             	movzbl %dl,%eax
8010481b:	29 d8                	sub    %ebx,%eax
}
8010481d:	5b                   	pop    %ebx
8010481e:	5e                   	pop    %esi
8010481f:	5d                   	pop    %ebp
80104820:	c3                   	ret    
80104821:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104828:	5b                   	pop    %ebx
    return 0;
80104829:	31 c0                	xor    %eax,%eax
}
8010482b:	5e                   	pop    %esi
8010482c:	5d                   	pop    %ebp
8010482d:	c3                   	ret    
8010482e:	66 90                	xchg   %ax,%ax

80104830 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104830:	f3 0f 1e fb          	endbr32 
80104834:	55                   	push   %ebp
80104835:	89 e5                	mov    %esp,%ebp
80104837:	57                   	push   %edi
80104838:	56                   	push   %esi
80104839:	8b 75 08             	mov    0x8(%ebp),%esi
8010483c:	53                   	push   %ebx
8010483d:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104840:	89 f2                	mov    %esi,%edx
80104842:	eb 1b                	jmp    8010485f <strncpy+0x2f>
80104844:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104848:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
8010484c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010484f:	83 c2 01             	add    $0x1,%edx
80104852:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80104856:	89 f9                	mov    %edi,%ecx
80104858:	88 4a ff             	mov    %cl,-0x1(%edx)
8010485b:	84 c9                	test   %cl,%cl
8010485d:	74 09                	je     80104868 <strncpy+0x38>
8010485f:	89 c3                	mov    %eax,%ebx
80104861:	83 e8 01             	sub    $0x1,%eax
80104864:	85 db                	test   %ebx,%ebx
80104866:	7f e0                	jg     80104848 <strncpy+0x18>
    ;
  while(n-- > 0)
80104868:	89 d1                	mov    %edx,%ecx
8010486a:	85 c0                	test   %eax,%eax
8010486c:	7e 15                	jle    80104883 <strncpy+0x53>
8010486e:	66 90                	xchg   %ax,%ax
    *s++ = 0;
80104870:	83 c1 01             	add    $0x1,%ecx
80104873:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
80104877:	89 c8                	mov    %ecx,%eax
80104879:	f7 d0                	not    %eax
8010487b:	01 d0                	add    %edx,%eax
8010487d:	01 d8                	add    %ebx,%eax
8010487f:	85 c0                	test   %eax,%eax
80104881:	7f ed                	jg     80104870 <strncpy+0x40>
  return os;
}
80104883:	5b                   	pop    %ebx
80104884:	89 f0                	mov    %esi,%eax
80104886:	5e                   	pop    %esi
80104887:	5f                   	pop    %edi
80104888:	5d                   	pop    %ebp
80104889:	c3                   	ret    
8010488a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104890 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104890:	f3 0f 1e fb          	endbr32 
80104894:	55                   	push   %ebp
80104895:	89 e5                	mov    %esp,%ebp
80104897:	56                   	push   %esi
80104898:	8b 55 10             	mov    0x10(%ebp),%edx
8010489b:	8b 75 08             	mov    0x8(%ebp),%esi
8010489e:	53                   	push   %ebx
8010489f:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
801048a2:	85 d2                	test   %edx,%edx
801048a4:	7e 21                	jle    801048c7 <safestrcpy+0x37>
801048a6:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
801048aa:	89 f2                	mov    %esi,%edx
801048ac:	eb 12                	jmp    801048c0 <safestrcpy+0x30>
801048ae:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801048b0:	0f b6 08             	movzbl (%eax),%ecx
801048b3:	83 c0 01             	add    $0x1,%eax
801048b6:	83 c2 01             	add    $0x1,%edx
801048b9:	88 4a ff             	mov    %cl,-0x1(%edx)
801048bc:	84 c9                	test   %cl,%cl
801048be:	74 04                	je     801048c4 <safestrcpy+0x34>
801048c0:	39 d8                	cmp    %ebx,%eax
801048c2:	75 ec                	jne    801048b0 <safestrcpy+0x20>
    ;
  *s = 0;
801048c4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
801048c7:	89 f0                	mov    %esi,%eax
801048c9:	5b                   	pop    %ebx
801048ca:	5e                   	pop    %esi
801048cb:	5d                   	pop    %ebp
801048cc:	c3                   	ret    
801048cd:	8d 76 00             	lea    0x0(%esi),%esi

801048d0 <strlen>:

int
strlen(const char *s)
{
801048d0:	f3 0f 1e fb          	endbr32 
801048d4:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801048d5:	31 c0                	xor    %eax,%eax
{
801048d7:	89 e5                	mov    %esp,%ebp
801048d9:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801048dc:	80 3a 00             	cmpb   $0x0,(%edx)
801048df:	74 10                	je     801048f1 <strlen+0x21>
801048e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048e8:	83 c0 01             	add    $0x1,%eax
801048eb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801048ef:	75 f7                	jne    801048e8 <strlen+0x18>
    ;
  return n;
}
801048f1:	5d                   	pop    %ebp
801048f2:	c3                   	ret    

801048f3 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801048f3:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801048f7:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801048fb:	55                   	push   %ebp
  pushl %ebx
801048fc:	53                   	push   %ebx
  pushl %esi
801048fd:	56                   	push   %esi
  pushl %edi
801048fe:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801048ff:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104901:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104903:	5f                   	pop    %edi
  popl %esi
80104904:	5e                   	pop    %esi
  popl %ebx
80104905:	5b                   	pop    %ebx
  popl %ebp
80104906:	5d                   	pop    %ebp
  ret
80104907:	c3                   	ret    
80104908:	66 90                	xchg   %ax,%ax
8010490a:	66 90                	xchg   %ax,%ax
8010490c:	66 90                	xchg   %ax,%ax
8010490e:	66 90                	xchg   %ax,%ax

80104910 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104910:	f3 0f 1e fb          	endbr32 
80104914:	55                   	push   %ebp
80104915:	89 e5                	mov    %esp,%ebp
80104917:	53                   	push   %ebx
80104918:	83 ec 04             	sub    $0x4,%esp
8010491b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010491e:	e8 5d f0 ff ff       	call   80103980 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104923:	8b 00                	mov    (%eax),%eax
80104925:	39 d8                	cmp    %ebx,%eax
80104927:	76 17                	jbe    80104940 <fetchint+0x30>
80104929:	8d 53 04             	lea    0x4(%ebx),%edx
8010492c:	39 d0                	cmp    %edx,%eax
8010492e:	72 10                	jb     80104940 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104930:	8b 45 0c             	mov    0xc(%ebp),%eax
80104933:	8b 13                	mov    (%ebx),%edx
80104935:	89 10                	mov    %edx,(%eax)
  return 0;
80104937:	31 c0                	xor    %eax,%eax
}
80104939:	83 c4 04             	add    $0x4,%esp
8010493c:	5b                   	pop    %ebx
8010493d:	5d                   	pop    %ebp
8010493e:	c3                   	ret    
8010493f:	90                   	nop
    return -1;
80104940:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104945:	eb f2                	jmp    80104939 <fetchint+0x29>
80104947:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010494e:	66 90                	xchg   %ax,%ax

80104950 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104950:	f3 0f 1e fb          	endbr32 
80104954:	55                   	push   %ebp
80104955:	89 e5                	mov    %esp,%ebp
80104957:	53                   	push   %ebx
80104958:	83 ec 04             	sub    $0x4,%esp
8010495b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010495e:	e8 1d f0 ff ff       	call   80103980 <myproc>

  if(addr >= curproc->sz)
80104963:	39 18                	cmp    %ebx,(%eax)
80104965:	76 31                	jbe    80104998 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80104967:	8b 55 0c             	mov    0xc(%ebp),%edx
8010496a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010496c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010496e:	39 d3                	cmp    %edx,%ebx
80104970:	73 26                	jae    80104998 <fetchstr+0x48>
80104972:	89 d8                	mov    %ebx,%eax
80104974:	eb 11                	jmp    80104987 <fetchstr+0x37>
80104976:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010497d:	8d 76 00             	lea    0x0(%esi),%esi
80104980:	83 c0 01             	add    $0x1,%eax
80104983:	39 c2                	cmp    %eax,%edx
80104985:	76 11                	jbe    80104998 <fetchstr+0x48>
    if(*s == 0)
80104987:	80 38 00             	cmpb   $0x0,(%eax)
8010498a:	75 f4                	jne    80104980 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
8010498c:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
8010498f:	29 d8                	sub    %ebx,%eax
}
80104991:	5b                   	pop    %ebx
80104992:	5d                   	pop    %ebp
80104993:	c3                   	ret    
80104994:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104998:	83 c4 04             	add    $0x4,%esp
    return -1;
8010499b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801049a0:	5b                   	pop    %ebx
801049a1:	5d                   	pop    %ebp
801049a2:	c3                   	ret    
801049a3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801049b0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801049b0:	f3 0f 1e fb          	endbr32 
801049b4:	55                   	push   %ebp
801049b5:	89 e5                	mov    %esp,%ebp
801049b7:	56                   	push   %esi
801049b8:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049b9:	e8 c2 ef ff ff       	call   80103980 <myproc>
801049be:	8b 55 08             	mov    0x8(%ebp),%edx
801049c1:	8b 40 18             	mov    0x18(%eax),%eax
801049c4:	8b 40 44             	mov    0x44(%eax),%eax
801049c7:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801049ca:	e8 b1 ef ff ff       	call   80103980 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049cf:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801049d2:	8b 00                	mov    (%eax),%eax
801049d4:	39 c6                	cmp    %eax,%esi
801049d6:	73 18                	jae    801049f0 <argint+0x40>
801049d8:	8d 53 08             	lea    0x8(%ebx),%edx
801049db:	39 d0                	cmp    %edx,%eax
801049dd:	72 11                	jb     801049f0 <argint+0x40>
  *ip = *(int*)(addr);
801049df:	8b 45 0c             	mov    0xc(%ebp),%eax
801049e2:	8b 53 04             	mov    0x4(%ebx),%edx
801049e5:	89 10                	mov    %edx,(%eax)
  return 0;
801049e7:	31 c0                	xor    %eax,%eax
}
801049e9:	5b                   	pop    %ebx
801049ea:	5e                   	pop    %esi
801049eb:	5d                   	pop    %ebp
801049ec:	c3                   	ret    
801049ed:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801049f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049f5:	eb f2                	jmp    801049e9 <argint+0x39>
801049f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049fe:	66 90                	xchg   %ax,%ax

80104a00 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104a00:	f3 0f 1e fb          	endbr32 
80104a04:	55                   	push   %ebp
80104a05:	89 e5                	mov    %esp,%ebp
80104a07:	56                   	push   %esi
80104a08:	53                   	push   %ebx
80104a09:	83 ec 10             	sub    $0x10,%esp
80104a0c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104a0f:	e8 6c ef ff ff       	call   80103980 <myproc>
 
  if(argint(n, &i) < 0)
80104a14:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80104a17:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80104a19:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a1c:	50                   	push   %eax
80104a1d:	ff 75 08             	pushl  0x8(%ebp)
80104a20:	e8 8b ff ff ff       	call   801049b0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104a25:	83 c4 10             	add    $0x10,%esp
80104a28:	85 c0                	test   %eax,%eax
80104a2a:	78 24                	js     80104a50 <argptr+0x50>
80104a2c:	85 db                	test   %ebx,%ebx
80104a2e:	78 20                	js     80104a50 <argptr+0x50>
80104a30:	8b 16                	mov    (%esi),%edx
80104a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a35:	39 c2                	cmp    %eax,%edx
80104a37:	76 17                	jbe    80104a50 <argptr+0x50>
80104a39:	01 c3                	add    %eax,%ebx
80104a3b:	39 da                	cmp    %ebx,%edx
80104a3d:	72 11                	jb     80104a50 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104a3f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a42:	89 02                	mov    %eax,(%edx)
  return 0;
80104a44:	31 c0                	xor    %eax,%eax
}
80104a46:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a49:	5b                   	pop    %ebx
80104a4a:	5e                   	pop    %esi
80104a4b:	5d                   	pop    %ebp
80104a4c:	c3                   	ret    
80104a4d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104a50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a55:	eb ef                	jmp    80104a46 <argptr+0x46>
80104a57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a5e:	66 90                	xchg   %ax,%ax

80104a60 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104a60:	f3 0f 1e fb          	endbr32 
80104a64:	55                   	push   %ebp
80104a65:	89 e5                	mov    %esp,%ebp
80104a67:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104a6a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a6d:	50                   	push   %eax
80104a6e:	ff 75 08             	pushl  0x8(%ebp)
80104a71:	e8 3a ff ff ff       	call   801049b0 <argint>
80104a76:	83 c4 10             	add    $0x10,%esp
80104a79:	85 c0                	test   %eax,%eax
80104a7b:	78 13                	js     80104a90 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104a7d:	83 ec 08             	sub    $0x8,%esp
80104a80:	ff 75 0c             	pushl  0xc(%ebp)
80104a83:	ff 75 f4             	pushl  -0xc(%ebp)
80104a86:	e8 c5 fe ff ff       	call   80104950 <fetchstr>
80104a8b:	83 c4 10             	add    $0x10,%esp
}
80104a8e:	c9                   	leave  
80104a8f:	c3                   	ret    
80104a90:	c9                   	leave  
    return -1;
80104a91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a96:	c3                   	ret    
80104a97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a9e:	66 90                	xchg   %ax,%ax

80104aa0 <syscall>:

};

void
syscall(void)
{
80104aa0:	f3 0f 1e fb          	endbr32 
80104aa4:	55                   	push   %ebp
80104aa5:	89 e5                	mov    %esp,%ebp
80104aa7:	53                   	push   %ebx
80104aa8:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104aab:	e8 d0 ee ff ff       	call   80103980 <myproc>
80104ab0:	89 c3                	mov    %eax,%ebx
 
  num = curproc->tf->eax;
80104ab2:	8b 40 18             	mov    0x18(%eax),%eax
80104ab5:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) { 
80104ab8:	8d 50 ff             	lea    -0x1(%eax),%edx
80104abb:	83 fa 18             	cmp    $0x18,%edx
80104abe:	77 20                	ja     80104ae0 <syscall+0x40>
80104ac0:	8b 14 85 e0 7a 10 80 	mov    -0x7fef8520(,%eax,4),%edx
80104ac7:	85 d2                	test   %edx,%edx
80104ac9:	74 15                	je     80104ae0 <syscall+0x40>
   curproc->tf->eax = syscalls[num]();
80104acb:	ff d2                	call   *%edx
80104acd:	89 c2                	mov    %eax,%edx
80104acf:	8b 43 18             	mov    0x18(%ebx),%eax
80104ad2:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104ad5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ad8:	c9                   	leave  
80104ad9:	c3                   	ret    
80104ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104ae0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104ae1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104ae4:	50                   	push   %eax
80104ae5:	ff 73 10             	pushl  0x10(%ebx)
80104ae8:	68 bd 7a 10 80       	push   $0x80107abd
80104aed:	e8 be bb ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80104af2:	8b 43 18             	mov    0x18(%ebx),%eax
80104af5:	83 c4 10             	add    $0x10,%esp
80104af8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104aff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b02:	c9                   	leave  
80104b03:	c3                   	ret    
80104b04:	66 90                	xchg   %ax,%ax
80104b06:	66 90                	xchg   %ax,%ax
80104b08:	66 90                	xchg   %ax,%ax
80104b0a:	66 90                	xchg   %ax,%ax
80104b0c:	66 90                	xchg   %ax,%ax
80104b0e:	66 90                	xchg   %ax,%ax

80104b10 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104b10:	55                   	push   %ebp
80104b11:	89 e5                	mov    %esp,%ebp
80104b13:	57                   	push   %edi
80104b14:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104b15:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104b18:	53                   	push   %ebx
80104b19:	83 ec 34             	sub    $0x34,%esp
80104b1c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104b1f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104b22:	57                   	push   %edi
80104b23:	50                   	push   %eax
{
80104b24:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104b27:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104b2a:	e8 31 d5 ff ff       	call   80102060 <nameiparent>
80104b2f:	83 c4 10             	add    $0x10,%esp
80104b32:	85 c0                	test   %eax,%eax
80104b34:	0f 84 46 01 00 00    	je     80104c80 <create+0x170>
    return 0;
  ilock(dp);
80104b3a:	83 ec 0c             	sub    $0xc,%esp
80104b3d:	89 c3                	mov    %eax,%ebx
80104b3f:	50                   	push   %eax
80104b40:	e8 2b cc ff ff       	call   80101770 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104b45:	83 c4 0c             	add    $0xc,%esp
80104b48:	6a 00                	push   $0x0
80104b4a:	57                   	push   %edi
80104b4b:	53                   	push   %ebx
80104b4c:	e8 6f d1 ff ff       	call   80101cc0 <dirlookup>
80104b51:	83 c4 10             	add    $0x10,%esp
80104b54:	89 c6                	mov    %eax,%esi
80104b56:	85 c0                	test   %eax,%eax
80104b58:	74 56                	je     80104bb0 <create+0xa0>
    iunlockput(dp);
80104b5a:	83 ec 0c             	sub    $0xc,%esp
80104b5d:	53                   	push   %ebx
80104b5e:	e8 ad ce ff ff       	call   80101a10 <iunlockput>
    ilock(ip);
80104b63:	89 34 24             	mov    %esi,(%esp)
80104b66:	e8 05 cc ff ff       	call   80101770 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104b6b:	83 c4 10             	add    $0x10,%esp
80104b6e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104b73:	75 1b                	jne    80104b90 <create+0x80>
80104b75:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104b7a:	75 14                	jne    80104b90 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104b7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b7f:	89 f0                	mov    %esi,%eax
80104b81:	5b                   	pop    %ebx
80104b82:	5e                   	pop    %esi
80104b83:	5f                   	pop    %edi
80104b84:	5d                   	pop    %ebp
80104b85:	c3                   	ret    
80104b86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b8d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80104b90:	83 ec 0c             	sub    $0xc,%esp
80104b93:	56                   	push   %esi
    return 0;
80104b94:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104b96:	e8 75 ce ff ff       	call   80101a10 <iunlockput>
    return 0;
80104b9b:	83 c4 10             	add    $0x10,%esp
}
80104b9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ba1:	89 f0                	mov    %esi,%eax
80104ba3:	5b                   	pop    %ebx
80104ba4:	5e                   	pop    %esi
80104ba5:	5f                   	pop    %edi
80104ba6:	5d                   	pop    %ebp
80104ba7:	c3                   	ret    
80104ba8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104baf:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104bb0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104bb4:	83 ec 08             	sub    $0x8,%esp
80104bb7:	50                   	push   %eax
80104bb8:	ff 33                	pushl  (%ebx)
80104bba:	e8 31 ca ff ff       	call   801015f0 <ialloc>
80104bbf:	83 c4 10             	add    $0x10,%esp
80104bc2:	89 c6                	mov    %eax,%esi
80104bc4:	85 c0                	test   %eax,%eax
80104bc6:	0f 84 cd 00 00 00    	je     80104c99 <create+0x189>
  ilock(ip);
80104bcc:	83 ec 0c             	sub    $0xc,%esp
80104bcf:	50                   	push   %eax
80104bd0:	e8 9b cb ff ff       	call   80101770 <ilock>
  ip->major = major;
80104bd5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104bd9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104bdd:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104be1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104be5:	b8 01 00 00 00       	mov    $0x1,%eax
80104bea:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104bee:	89 34 24             	mov    %esi,(%esp)
80104bf1:	e8 ba ca ff ff       	call   801016b0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104bf6:	83 c4 10             	add    $0x10,%esp
80104bf9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104bfe:	74 30                	je     80104c30 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104c00:	83 ec 04             	sub    $0x4,%esp
80104c03:	ff 76 04             	pushl  0x4(%esi)
80104c06:	57                   	push   %edi
80104c07:	53                   	push   %ebx
80104c08:	e8 73 d3 ff ff       	call   80101f80 <dirlink>
80104c0d:	83 c4 10             	add    $0x10,%esp
80104c10:	85 c0                	test   %eax,%eax
80104c12:	78 78                	js     80104c8c <create+0x17c>
  iunlockput(dp);
80104c14:	83 ec 0c             	sub    $0xc,%esp
80104c17:	53                   	push   %ebx
80104c18:	e8 f3 cd ff ff       	call   80101a10 <iunlockput>
  return ip;
80104c1d:	83 c4 10             	add    $0x10,%esp
}
80104c20:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c23:	89 f0                	mov    %esi,%eax
80104c25:	5b                   	pop    %ebx
80104c26:	5e                   	pop    %esi
80104c27:	5f                   	pop    %edi
80104c28:	5d                   	pop    %ebp
80104c29:	c3                   	ret    
80104c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104c30:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104c33:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104c38:	53                   	push   %ebx
80104c39:	e8 72 ca ff ff       	call   801016b0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104c3e:	83 c4 0c             	add    $0xc,%esp
80104c41:	ff 76 04             	pushl  0x4(%esi)
80104c44:	68 64 7b 10 80       	push   $0x80107b64
80104c49:	56                   	push   %esi
80104c4a:	e8 31 d3 ff ff       	call   80101f80 <dirlink>
80104c4f:	83 c4 10             	add    $0x10,%esp
80104c52:	85 c0                	test   %eax,%eax
80104c54:	78 18                	js     80104c6e <create+0x15e>
80104c56:	83 ec 04             	sub    $0x4,%esp
80104c59:	ff 73 04             	pushl  0x4(%ebx)
80104c5c:	68 63 7b 10 80       	push   $0x80107b63
80104c61:	56                   	push   %esi
80104c62:	e8 19 d3 ff ff       	call   80101f80 <dirlink>
80104c67:	83 c4 10             	add    $0x10,%esp
80104c6a:	85 c0                	test   %eax,%eax
80104c6c:	79 92                	jns    80104c00 <create+0xf0>
      panic("create dots");
80104c6e:	83 ec 0c             	sub    $0xc,%esp
80104c71:	68 57 7b 10 80       	push   $0x80107b57
80104c76:	e8 15 b7 ff ff       	call   80100390 <panic>
80104c7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c7f:	90                   	nop
}
80104c80:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104c83:	31 f6                	xor    %esi,%esi
}
80104c85:	5b                   	pop    %ebx
80104c86:	89 f0                	mov    %esi,%eax
80104c88:	5e                   	pop    %esi
80104c89:	5f                   	pop    %edi
80104c8a:	5d                   	pop    %ebp
80104c8b:	c3                   	ret    
    panic("create: dirlink");
80104c8c:	83 ec 0c             	sub    $0xc,%esp
80104c8f:	68 66 7b 10 80       	push   $0x80107b66
80104c94:	e8 f7 b6 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80104c99:	83 ec 0c             	sub    $0xc,%esp
80104c9c:	68 48 7b 10 80       	push   $0x80107b48
80104ca1:	e8 ea b6 ff ff       	call   80100390 <panic>
80104ca6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cad:	8d 76 00             	lea    0x0(%esi),%esi

80104cb0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104cb0:	55                   	push   %ebp
80104cb1:	89 e5                	mov    %esp,%ebp
80104cb3:	56                   	push   %esi
80104cb4:	89 d6                	mov    %edx,%esi
80104cb6:	53                   	push   %ebx
80104cb7:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104cb9:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104cbc:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104cbf:	50                   	push   %eax
80104cc0:	6a 00                	push   $0x0
80104cc2:	e8 e9 fc ff ff       	call   801049b0 <argint>
80104cc7:	83 c4 10             	add    $0x10,%esp
80104cca:	85 c0                	test   %eax,%eax
80104ccc:	78 2a                	js     80104cf8 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104cce:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104cd2:	77 24                	ja     80104cf8 <argfd.constprop.0+0x48>
80104cd4:	e8 a7 ec ff ff       	call   80103980 <myproc>
80104cd9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104cdc:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104ce0:	85 c0                	test   %eax,%eax
80104ce2:	74 14                	je     80104cf8 <argfd.constprop.0+0x48>
  if(pfd)
80104ce4:	85 db                	test   %ebx,%ebx
80104ce6:	74 02                	je     80104cea <argfd.constprop.0+0x3a>
    *pfd = fd;
80104ce8:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104cea:	89 06                	mov    %eax,(%esi)
  return 0;
80104cec:	31 c0                	xor    %eax,%eax
}
80104cee:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104cf1:	5b                   	pop    %ebx
80104cf2:	5e                   	pop    %esi
80104cf3:	5d                   	pop    %ebp
80104cf4:	c3                   	ret    
80104cf5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104cf8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cfd:	eb ef                	jmp    80104cee <argfd.constprop.0+0x3e>
80104cff:	90                   	nop

80104d00 <sys_dup>:
{
80104d00:	f3 0f 1e fb          	endbr32 
80104d04:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104d05:	31 c0                	xor    %eax,%eax
{
80104d07:	89 e5                	mov    %esp,%ebp
80104d09:	56                   	push   %esi
80104d0a:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104d0b:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104d0e:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104d11:	e8 9a ff ff ff       	call   80104cb0 <argfd.constprop.0>
80104d16:	85 c0                	test   %eax,%eax
80104d18:	78 1e                	js     80104d38 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
80104d1a:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104d1d:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104d1f:	e8 5c ec ff ff       	call   80103980 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104d24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80104d28:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104d2c:	85 d2                	test   %edx,%edx
80104d2e:	74 20                	je     80104d50 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
80104d30:	83 c3 01             	add    $0x1,%ebx
80104d33:	83 fb 10             	cmp    $0x10,%ebx
80104d36:	75 f0                	jne    80104d28 <sys_dup+0x28>
}
80104d38:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104d3b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104d40:	89 d8                	mov    %ebx,%eax
80104d42:	5b                   	pop    %ebx
80104d43:	5e                   	pop    %esi
80104d44:	5d                   	pop    %ebp
80104d45:	c3                   	ret    
80104d46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d4d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80104d50:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104d54:	83 ec 0c             	sub    $0xc,%esp
80104d57:	ff 75 f4             	pushl  -0xc(%ebp)
80104d5a:	e8 21 c1 ff ff       	call   80100e80 <filedup>
  return fd;
80104d5f:	83 c4 10             	add    $0x10,%esp
}
80104d62:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d65:	89 d8                	mov    %ebx,%eax
80104d67:	5b                   	pop    %ebx
80104d68:	5e                   	pop    %esi
80104d69:	5d                   	pop    %ebp
80104d6a:	c3                   	ret    
80104d6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d6f:	90                   	nop

80104d70 <sys_read>:
{
80104d70:	f3 0f 1e fb          	endbr32 
80104d74:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d75:	31 c0                	xor    %eax,%eax
{
80104d77:	89 e5                	mov    %esp,%ebp
80104d79:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d7c:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104d7f:	e8 2c ff ff ff       	call   80104cb0 <argfd.constprop.0>
80104d84:	85 c0                	test   %eax,%eax
80104d86:	78 48                	js     80104dd0 <sys_read+0x60>
80104d88:	83 ec 08             	sub    $0x8,%esp
80104d8b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104d8e:	50                   	push   %eax
80104d8f:	6a 02                	push   $0x2
80104d91:	e8 1a fc ff ff       	call   801049b0 <argint>
80104d96:	83 c4 10             	add    $0x10,%esp
80104d99:	85 c0                	test   %eax,%eax
80104d9b:	78 33                	js     80104dd0 <sys_read+0x60>
80104d9d:	83 ec 04             	sub    $0x4,%esp
80104da0:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104da3:	ff 75 f0             	pushl  -0x10(%ebp)
80104da6:	50                   	push   %eax
80104da7:	6a 01                	push   $0x1
80104da9:	e8 52 fc ff ff       	call   80104a00 <argptr>
80104dae:	83 c4 10             	add    $0x10,%esp
80104db1:	85 c0                	test   %eax,%eax
80104db3:	78 1b                	js     80104dd0 <sys_read+0x60>
  return fileread(f, p, n);
80104db5:	83 ec 04             	sub    $0x4,%esp
80104db8:	ff 75 f0             	pushl  -0x10(%ebp)
80104dbb:	ff 75 f4             	pushl  -0xc(%ebp)
80104dbe:	ff 75 ec             	pushl  -0x14(%ebp)
80104dc1:	e8 3a c2 ff ff       	call   80101000 <fileread>
80104dc6:	83 c4 10             	add    $0x10,%esp
}
80104dc9:	c9                   	leave  
80104dca:	c3                   	ret    
80104dcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104dcf:	90                   	nop
80104dd0:	c9                   	leave  
    return -1;
80104dd1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104dd6:	c3                   	ret    
80104dd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dde:	66 90                	xchg   %ax,%ax

80104de0 <sys_write>:
{
80104de0:	f3 0f 1e fb          	endbr32 
80104de4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104de5:	31 c0                	xor    %eax,%eax
{
80104de7:	89 e5                	mov    %esp,%ebp
80104de9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104dec:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104def:	e8 bc fe ff ff       	call   80104cb0 <argfd.constprop.0>
80104df4:	85 c0                	test   %eax,%eax
80104df6:	78 48                	js     80104e40 <sys_write+0x60>
80104df8:	83 ec 08             	sub    $0x8,%esp
80104dfb:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104dfe:	50                   	push   %eax
80104dff:	6a 02                	push   $0x2
80104e01:	e8 aa fb ff ff       	call   801049b0 <argint>
80104e06:	83 c4 10             	add    $0x10,%esp
80104e09:	85 c0                	test   %eax,%eax
80104e0b:	78 33                	js     80104e40 <sys_write+0x60>
80104e0d:	83 ec 04             	sub    $0x4,%esp
80104e10:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e13:	ff 75 f0             	pushl  -0x10(%ebp)
80104e16:	50                   	push   %eax
80104e17:	6a 01                	push   $0x1
80104e19:	e8 e2 fb ff ff       	call   80104a00 <argptr>
80104e1e:	83 c4 10             	add    $0x10,%esp
80104e21:	85 c0                	test   %eax,%eax
80104e23:	78 1b                	js     80104e40 <sys_write+0x60>
  return filewrite(f, p, n);
80104e25:	83 ec 04             	sub    $0x4,%esp
80104e28:	ff 75 f0             	pushl  -0x10(%ebp)
80104e2b:	ff 75 f4             	pushl  -0xc(%ebp)
80104e2e:	ff 75 ec             	pushl  -0x14(%ebp)
80104e31:	e8 6a c2 ff ff       	call   801010a0 <filewrite>
80104e36:	83 c4 10             	add    $0x10,%esp
}
80104e39:	c9                   	leave  
80104e3a:	c3                   	ret    
80104e3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e3f:	90                   	nop
80104e40:	c9                   	leave  
    return -1;
80104e41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e46:	c3                   	ret    
80104e47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e4e:	66 90                	xchg   %ax,%ax

80104e50 <sys_close>:
{
80104e50:	f3 0f 1e fb          	endbr32 
80104e54:	55                   	push   %ebp
80104e55:	89 e5                	mov    %esp,%ebp
80104e57:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80104e5a:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104e5d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e60:	e8 4b fe ff ff       	call   80104cb0 <argfd.constprop.0>
80104e65:	85 c0                	test   %eax,%eax
80104e67:	78 27                	js     80104e90 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80104e69:	e8 12 eb ff ff       	call   80103980 <myproc>
80104e6e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104e71:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104e74:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104e7b:	00 
  fileclose(f);
80104e7c:	ff 75 f4             	pushl  -0xc(%ebp)
80104e7f:	e8 4c c0 ff ff       	call   80100ed0 <fileclose>
  return 0;
80104e84:	83 c4 10             	add    $0x10,%esp
80104e87:	31 c0                	xor    %eax,%eax
}
80104e89:	c9                   	leave  
80104e8a:	c3                   	ret    
80104e8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e8f:	90                   	nop
80104e90:	c9                   	leave  
    return -1;
80104e91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e96:	c3                   	ret    
80104e97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e9e:	66 90                	xchg   %ax,%ax

80104ea0 <sys_fstat>:
{
80104ea0:	f3 0f 1e fb          	endbr32 
80104ea4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104ea5:	31 c0                	xor    %eax,%eax
{
80104ea7:	89 e5                	mov    %esp,%ebp
80104ea9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104eac:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104eaf:	e8 fc fd ff ff       	call   80104cb0 <argfd.constprop.0>
80104eb4:	85 c0                	test   %eax,%eax
80104eb6:	78 30                	js     80104ee8 <sys_fstat+0x48>
80104eb8:	83 ec 04             	sub    $0x4,%esp
80104ebb:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ebe:	6a 14                	push   $0x14
80104ec0:	50                   	push   %eax
80104ec1:	6a 01                	push   $0x1
80104ec3:	e8 38 fb ff ff       	call   80104a00 <argptr>
80104ec8:	83 c4 10             	add    $0x10,%esp
80104ecb:	85 c0                	test   %eax,%eax
80104ecd:	78 19                	js     80104ee8 <sys_fstat+0x48>
  return filestat(f, st);
80104ecf:	83 ec 08             	sub    $0x8,%esp
80104ed2:	ff 75 f4             	pushl  -0xc(%ebp)
80104ed5:	ff 75 f0             	pushl  -0x10(%ebp)
80104ed8:	e8 d3 c0 ff ff       	call   80100fb0 <filestat>
80104edd:	83 c4 10             	add    $0x10,%esp
}
80104ee0:	c9                   	leave  
80104ee1:	c3                   	ret    
80104ee2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ee8:	c9                   	leave  
    return -1;
80104ee9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104eee:	c3                   	ret    
80104eef:	90                   	nop

80104ef0 <sys_link>:
{
80104ef0:	f3 0f 1e fb          	endbr32 
80104ef4:	55                   	push   %ebp
80104ef5:	89 e5                	mov    %esp,%ebp
80104ef7:	57                   	push   %edi
80104ef8:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104ef9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104efc:	53                   	push   %ebx
80104efd:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104f00:	50                   	push   %eax
80104f01:	6a 00                	push   $0x0
80104f03:	e8 58 fb ff ff       	call   80104a60 <argstr>
80104f08:	83 c4 10             	add    $0x10,%esp
80104f0b:	85 c0                	test   %eax,%eax
80104f0d:	0f 88 ff 00 00 00    	js     80105012 <sys_link+0x122>
80104f13:	83 ec 08             	sub    $0x8,%esp
80104f16:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104f19:	50                   	push   %eax
80104f1a:	6a 01                	push   $0x1
80104f1c:	e8 3f fb ff ff       	call   80104a60 <argstr>
80104f21:	83 c4 10             	add    $0x10,%esp
80104f24:	85 c0                	test   %eax,%eax
80104f26:	0f 88 e6 00 00 00    	js     80105012 <sys_link+0x122>
  begin_op();
80104f2c:	e8 0f de ff ff       	call   80102d40 <begin_op>
  if((ip = namei(old)) == 0){
80104f31:	83 ec 0c             	sub    $0xc,%esp
80104f34:	ff 75 d4             	pushl  -0x2c(%ebp)
80104f37:	e8 04 d1 ff ff       	call   80102040 <namei>
80104f3c:	83 c4 10             	add    $0x10,%esp
80104f3f:	89 c3                	mov    %eax,%ebx
80104f41:	85 c0                	test   %eax,%eax
80104f43:	0f 84 e8 00 00 00    	je     80105031 <sys_link+0x141>
  ilock(ip);
80104f49:	83 ec 0c             	sub    $0xc,%esp
80104f4c:	50                   	push   %eax
80104f4d:	e8 1e c8 ff ff       	call   80101770 <ilock>
  if(ip->type == T_DIR){
80104f52:	83 c4 10             	add    $0x10,%esp
80104f55:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104f5a:	0f 84 b9 00 00 00    	je     80105019 <sys_link+0x129>
  iupdate(ip);
80104f60:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80104f63:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80104f68:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104f6b:	53                   	push   %ebx
80104f6c:	e8 3f c7 ff ff       	call   801016b0 <iupdate>
  iunlock(ip);
80104f71:	89 1c 24             	mov    %ebx,(%esp)
80104f74:	e8 d7 c8 ff ff       	call   80101850 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104f79:	58                   	pop    %eax
80104f7a:	5a                   	pop    %edx
80104f7b:	57                   	push   %edi
80104f7c:	ff 75 d0             	pushl  -0x30(%ebp)
80104f7f:	e8 dc d0 ff ff       	call   80102060 <nameiparent>
80104f84:	83 c4 10             	add    $0x10,%esp
80104f87:	89 c6                	mov    %eax,%esi
80104f89:	85 c0                	test   %eax,%eax
80104f8b:	74 5f                	je     80104fec <sys_link+0xfc>
  ilock(dp);
80104f8d:	83 ec 0c             	sub    $0xc,%esp
80104f90:	50                   	push   %eax
80104f91:	e8 da c7 ff ff       	call   80101770 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104f96:	8b 03                	mov    (%ebx),%eax
80104f98:	83 c4 10             	add    $0x10,%esp
80104f9b:	39 06                	cmp    %eax,(%esi)
80104f9d:	75 41                	jne    80104fe0 <sys_link+0xf0>
80104f9f:	83 ec 04             	sub    $0x4,%esp
80104fa2:	ff 73 04             	pushl  0x4(%ebx)
80104fa5:	57                   	push   %edi
80104fa6:	56                   	push   %esi
80104fa7:	e8 d4 cf ff ff       	call   80101f80 <dirlink>
80104fac:	83 c4 10             	add    $0x10,%esp
80104faf:	85 c0                	test   %eax,%eax
80104fb1:	78 2d                	js     80104fe0 <sys_link+0xf0>
  iunlockput(dp);
80104fb3:	83 ec 0c             	sub    $0xc,%esp
80104fb6:	56                   	push   %esi
80104fb7:	e8 54 ca ff ff       	call   80101a10 <iunlockput>
  iput(ip);
80104fbc:	89 1c 24             	mov    %ebx,(%esp)
80104fbf:	e8 dc c8 ff ff       	call   801018a0 <iput>
  end_op();
80104fc4:	e8 e7 dd ff ff       	call   80102db0 <end_op>
  return 0;
80104fc9:	83 c4 10             	add    $0x10,%esp
80104fcc:	31 c0                	xor    %eax,%eax
}
80104fce:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104fd1:	5b                   	pop    %ebx
80104fd2:	5e                   	pop    %esi
80104fd3:	5f                   	pop    %edi
80104fd4:	5d                   	pop    %ebp
80104fd5:	c3                   	ret    
80104fd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fdd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80104fe0:	83 ec 0c             	sub    $0xc,%esp
80104fe3:	56                   	push   %esi
80104fe4:	e8 27 ca ff ff       	call   80101a10 <iunlockput>
    goto bad;
80104fe9:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80104fec:	83 ec 0c             	sub    $0xc,%esp
80104fef:	53                   	push   %ebx
80104ff0:	e8 7b c7 ff ff       	call   80101770 <ilock>
  ip->nlink--;
80104ff5:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104ffa:	89 1c 24             	mov    %ebx,(%esp)
80104ffd:	e8 ae c6 ff ff       	call   801016b0 <iupdate>
  iunlockput(ip);
80105002:	89 1c 24             	mov    %ebx,(%esp)
80105005:	e8 06 ca ff ff       	call   80101a10 <iunlockput>
  end_op();
8010500a:	e8 a1 dd ff ff       	call   80102db0 <end_op>
  return -1;
8010500f:	83 c4 10             	add    $0x10,%esp
80105012:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105017:	eb b5                	jmp    80104fce <sys_link+0xde>
    iunlockput(ip);
80105019:	83 ec 0c             	sub    $0xc,%esp
8010501c:	53                   	push   %ebx
8010501d:	e8 ee c9 ff ff       	call   80101a10 <iunlockput>
    end_op();
80105022:	e8 89 dd ff ff       	call   80102db0 <end_op>
    return -1;
80105027:	83 c4 10             	add    $0x10,%esp
8010502a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010502f:	eb 9d                	jmp    80104fce <sys_link+0xde>
    end_op();
80105031:	e8 7a dd ff ff       	call   80102db0 <end_op>
    return -1;
80105036:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010503b:	eb 91                	jmp    80104fce <sys_link+0xde>
8010503d:	8d 76 00             	lea    0x0(%esi),%esi

80105040 <sys_unlink>:
{
80105040:	f3 0f 1e fb          	endbr32 
80105044:	55                   	push   %ebp
80105045:	89 e5                	mov    %esp,%ebp
80105047:	57                   	push   %edi
80105048:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105049:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
8010504c:	53                   	push   %ebx
8010504d:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80105050:	50                   	push   %eax
80105051:	6a 00                	push   $0x0
80105053:	e8 08 fa ff ff       	call   80104a60 <argstr>
80105058:	83 c4 10             	add    $0x10,%esp
8010505b:	85 c0                	test   %eax,%eax
8010505d:	0f 88 7d 01 00 00    	js     801051e0 <sys_unlink+0x1a0>
  begin_op();
80105063:	e8 d8 dc ff ff       	call   80102d40 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105068:	8d 5d ca             	lea    -0x36(%ebp),%ebx
8010506b:	83 ec 08             	sub    $0x8,%esp
8010506e:	53                   	push   %ebx
8010506f:	ff 75 c0             	pushl  -0x40(%ebp)
80105072:	e8 e9 cf ff ff       	call   80102060 <nameiparent>
80105077:	83 c4 10             	add    $0x10,%esp
8010507a:	89 c6                	mov    %eax,%esi
8010507c:	85 c0                	test   %eax,%eax
8010507e:	0f 84 66 01 00 00    	je     801051ea <sys_unlink+0x1aa>
  ilock(dp);
80105084:	83 ec 0c             	sub    $0xc,%esp
80105087:	50                   	push   %eax
80105088:	e8 e3 c6 ff ff       	call   80101770 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010508d:	58                   	pop    %eax
8010508e:	5a                   	pop    %edx
8010508f:	68 64 7b 10 80       	push   $0x80107b64
80105094:	53                   	push   %ebx
80105095:	e8 06 cc ff ff       	call   80101ca0 <namecmp>
8010509a:	83 c4 10             	add    $0x10,%esp
8010509d:	85 c0                	test   %eax,%eax
8010509f:	0f 84 03 01 00 00    	je     801051a8 <sys_unlink+0x168>
801050a5:	83 ec 08             	sub    $0x8,%esp
801050a8:	68 63 7b 10 80       	push   $0x80107b63
801050ad:	53                   	push   %ebx
801050ae:	e8 ed cb ff ff       	call   80101ca0 <namecmp>
801050b3:	83 c4 10             	add    $0x10,%esp
801050b6:	85 c0                	test   %eax,%eax
801050b8:	0f 84 ea 00 00 00    	je     801051a8 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
801050be:	83 ec 04             	sub    $0x4,%esp
801050c1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801050c4:	50                   	push   %eax
801050c5:	53                   	push   %ebx
801050c6:	56                   	push   %esi
801050c7:	e8 f4 cb ff ff       	call   80101cc0 <dirlookup>
801050cc:	83 c4 10             	add    $0x10,%esp
801050cf:	89 c3                	mov    %eax,%ebx
801050d1:	85 c0                	test   %eax,%eax
801050d3:	0f 84 cf 00 00 00    	je     801051a8 <sys_unlink+0x168>
  ilock(ip);
801050d9:	83 ec 0c             	sub    $0xc,%esp
801050dc:	50                   	push   %eax
801050dd:	e8 8e c6 ff ff       	call   80101770 <ilock>
  if(ip->nlink < 1)
801050e2:	83 c4 10             	add    $0x10,%esp
801050e5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801050ea:	0f 8e 23 01 00 00    	jle    80105213 <sys_unlink+0x1d3>
  if(ip->type == T_DIR && !isdirempty(ip)){
801050f0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801050f5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801050f8:	74 66                	je     80105160 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801050fa:	83 ec 04             	sub    $0x4,%esp
801050fd:	6a 10                	push   $0x10
801050ff:	6a 00                	push   $0x0
80105101:	57                   	push   %edi
80105102:	e8 c9 f5 ff ff       	call   801046d0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105107:	6a 10                	push   $0x10
80105109:	ff 75 c4             	pushl  -0x3c(%ebp)
8010510c:	57                   	push   %edi
8010510d:	56                   	push   %esi
8010510e:	e8 5d ca ff ff       	call   80101b70 <writei>
80105113:	83 c4 20             	add    $0x20,%esp
80105116:	83 f8 10             	cmp    $0x10,%eax
80105119:	0f 85 e7 00 00 00    	jne    80105206 <sys_unlink+0x1c6>
  if(ip->type == T_DIR){
8010511f:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105124:	0f 84 96 00 00 00    	je     801051c0 <sys_unlink+0x180>
  iunlockput(dp);
8010512a:	83 ec 0c             	sub    $0xc,%esp
8010512d:	56                   	push   %esi
8010512e:	e8 dd c8 ff ff       	call   80101a10 <iunlockput>
  ip->nlink--;
80105133:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105138:	89 1c 24             	mov    %ebx,(%esp)
8010513b:	e8 70 c5 ff ff       	call   801016b0 <iupdate>
  iunlockput(ip);
80105140:	89 1c 24             	mov    %ebx,(%esp)
80105143:	e8 c8 c8 ff ff       	call   80101a10 <iunlockput>
  end_op();
80105148:	e8 63 dc ff ff       	call   80102db0 <end_op>
  return 0;
8010514d:	83 c4 10             	add    $0x10,%esp
80105150:	31 c0                	xor    %eax,%eax
}
80105152:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105155:	5b                   	pop    %ebx
80105156:	5e                   	pop    %esi
80105157:	5f                   	pop    %edi
80105158:	5d                   	pop    %ebp
80105159:	c3                   	ret    
8010515a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105160:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105164:	76 94                	jbe    801050fa <sys_unlink+0xba>
80105166:	ba 20 00 00 00       	mov    $0x20,%edx
8010516b:	eb 0b                	jmp    80105178 <sys_unlink+0x138>
8010516d:	8d 76 00             	lea    0x0(%esi),%esi
80105170:	83 c2 10             	add    $0x10,%edx
80105173:	39 53 58             	cmp    %edx,0x58(%ebx)
80105176:	76 82                	jbe    801050fa <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105178:	6a 10                	push   $0x10
8010517a:	52                   	push   %edx
8010517b:	57                   	push   %edi
8010517c:	53                   	push   %ebx
8010517d:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80105180:	e8 eb c8 ff ff       	call   80101a70 <readi>
80105185:	83 c4 10             	add    $0x10,%esp
80105188:	8b 55 b4             	mov    -0x4c(%ebp),%edx
8010518b:	83 f8 10             	cmp    $0x10,%eax
8010518e:	75 69                	jne    801051f9 <sys_unlink+0x1b9>
    if(de.inum != 0)
80105190:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105195:	74 d9                	je     80105170 <sys_unlink+0x130>
    iunlockput(ip);
80105197:	83 ec 0c             	sub    $0xc,%esp
8010519a:	53                   	push   %ebx
8010519b:	e8 70 c8 ff ff       	call   80101a10 <iunlockput>
    goto bad;
801051a0:	83 c4 10             	add    $0x10,%esp
801051a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801051a7:	90                   	nop
  iunlockput(dp);
801051a8:	83 ec 0c             	sub    $0xc,%esp
801051ab:	56                   	push   %esi
801051ac:	e8 5f c8 ff ff       	call   80101a10 <iunlockput>
  end_op();
801051b1:	e8 fa db ff ff       	call   80102db0 <end_op>
  return -1;
801051b6:	83 c4 10             	add    $0x10,%esp
801051b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051be:	eb 92                	jmp    80105152 <sys_unlink+0x112>
    iupdate(dp);
801051c0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801051c3:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801051c8:	56                   	push   %esi
801051c9:	e8 e2 c4 ff ff       	call   801016b0 <iupdate>
801051ce:	83 c4 10             	add    $0x10,%esp
801051d1:	e9 54 ff ff ff       	jmp    8010512a <sys_unlink+0xea>
801051d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051dd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801051e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051e5:	e9 68 ff ff ff       	jmp    80105152 <sys_unlink+0x112>
    end_op();
801051ea:	e8 c1 db ff ff       	call   80102db0 <end_op>
    return -1;
801051ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051f4:	e9 59 ff ff ff       	jmp    80105152 <sys_unlink+0x112>
      panic("isdirempty: readi");
801051f9:	83 ec 0c             	sub    $0xc,%esp
801051fc:	68 88 7b 10 80       	push   $0x80107b88
80105201:	e8 8a b1 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105206:	83 ec 0c             	sub    $0xc,%esp
80105209:	68 9a 7b 10 80       	push   $0x80107b9a
8010520e:	e8 7d b1 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105213:	83 ec 0c             	sub    $0xc,%esp
80105216:	68 76 7b 10 80       	push   $0x80107b76
8010521b:	e8 70 b1 ff ff       	call   80100390 <panic>

80105220 <sys_open>:

int
sys_open(void)
{
80105220:	f3 0f 1e fb          	endbr32 
80105224:	55                   	push   %ebp
80105225:	89 e5                	mov    %esp,%ebp
80105227:	57                   	push   %edi
80105228:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105229:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
8010522c:	53                   	push   %ebx
8010522d:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105230:	50                   	push   %eax
80105231:	6a 00                	push   $0x0
80105233:	e8 28 f8 ff ff       	call   80104a60 <argstr>
80105238:	83 c4 10             	add    $0x10,%esp
8010523b:	85 c0                	test   %eax,%eax
8010523d:	0f 88 8a 00 00 00    	js     801052cd <sys_open+0xad>
80105243:	83 ec 08             	sub    $0x8,%esp
80105246:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105249:	50                   	push   %eax
8010524a:	6a 01                	push   $0x1
8010524c:	e8 5f f7 ff ff       	call   801049b0 <argint>
80105251:	83 c4 10             	add    $0x10,%esp
80105254:	85 c0                	test   %eax,%eax
80105256:	78 75                	js     801052cd <sys_open+0xad>
    return -1;

  begin_op();
80105258:	e8 e3 da ff ff       	call   80102d40 <begin_op>

  if(omode & O_CREATE){
8010525d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105261:	75 75                	jne    801052d8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105263:	83 ec 0c             	sub    $0xc,%esp
80105266:	ff 75 e0             	pushl  -0x20(%ebp)
80105269:	e8 d2 cd ff ff       	call   80102040 <namei>
8010526e:	83 c4 10             	add    $0x10,%esp
80105271:	89 c6                	mov    %eax,%esi
80105273:	85 c0                	test   %eax,%eax
80105275:	74 7e                	je     801052f5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105277:	83 ec 0c             	sub    $0xc,%esp
8010527a:	50                   	push   %eax
8010527b:	e8 f0 c4 ff ff       	call   80101770 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105280:	83 c4 10             	add    $0x10,%esp
80105283:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105288:	0f 84 c2 00 00 00    	je     80105350 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010528e:	e8 7d bb ff ff       	call   80100e10 <filealloc>
80105293:	89 c7                	mov    %eax,%edi
80105295:	85 c0                	test   %eax,%eax
80105297:	74 23                	je     801052bc <sys_open+0x9c>
  struct proc *curproc = myproc();
80105299:	e8 e2 e6 ff ff       	call   80103980 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010529e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801052a0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801052a4:	85 d2                	test   %edx,%edx
801052a6:	74 60                	je     80105308 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
801052a8:	83 c3 01             	add    $0x1,%ebx
801052ab:	83 fb 10             	cmp    $0x10,%ebx
801052ae:	75 f0                	jne    801052a0 <sys_open+0x80>
    if(f)
      fileclose(f);
801052b0:	83 ec 0c             	sub    $0xc,%esp
801052b3:	57                   	push   %edi
801052b4:	e8 17 bc ff ff       	call   80100ed0 <fileclose>
801052b9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801052bc:	83 ec 0c             	sub    $0xc,%esp
801052bf:	56                   	push   %esi
801052c0:	e8 4b c7 ff ff       	call   80101a10 <iunlockput>
    end_op();
801052c5:	e8 e6 da ff ff       	call   80102db0 <end_op>
    return -1;
801052ca:	83 c4 10             	add    $0x10,%esp
801052cd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801052d2:	eb 6d                	jmp    80105341 <sys_open+0x121>
801052d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801052d8:	83 ec 0c             	sub    $0xc,%esp
801052db:	8b 45 e0             	mov    -0x20(%ebp),%eax
801052de:	31 c9                	xor    %ecx,%ecx
801052e0:	ba 02 00 00 00       	mov    $0x2,%edx
801052e5:	6a 00                	push   $0x0
801052e7:	e8 24 f8 ff ff       	call   80104b10 <create>
    if(ip == 0){
801052ec:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801052ef:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801052f1:	85 c0                	test   %eax,%eax
801052f3:	75 99                	jne    8010528e <sys_open+0x6e>
      end_op();
801052f5:	e8 b6 da ff ff       	call   80102db0 <end_op>
      return -1;
801052fa:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801052ff:	eb 40                	jmp    80105341 <sys_open+0x121>
80105301:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105308:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010530b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010530f:	56                   	push   %esi
80105310:	e8 3b c5 ff ff       	call   80101850 <iunlock>
  end_op();
80105315:	e8 96 da ff ff       	call   80102db0 <end_op>

  f->type = FD_INODE;
8010531a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105320:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105323:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105326:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105329:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010532b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105332:	f7 d0                	not    %eax
80105334:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105337:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010533a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010533d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105341:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105344:	89 d8                	mov    %ebx,%eax
80105346:	5b                   	pop    %ebx
80105347:	5e                   	pop    %esi
80105348:	5f                   	pop    %edi
80105349:	5d                   	pop    %ebp
8010534a:	c3                   	ret    
8010534b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010534f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105350:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105353:	85 c9                	test   %ecx,%ecx
80105355:	0f 84 33 ff ff ff    	je     8010528e <sys_open+0x6e>
8010535b:	e9 5c ff ff ff       	jmp    801052bc <sys_open+0x9c>

80105360 <sys_mkdir>:

int
sys_mkdir(void)
{
80105360:	f3 0f 1e fb          	endbr32 
80105364:	55                   	push   %ebp
80105365:	89 e5                	mov    %esp,%ebp
80105367:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
8010536a:	e8 d1 d9 ff ff       	call   80102d40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010536f:	83 ec 08             	sub    $0x8,%esp
80105372:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105375:	50                   	push   %eax
80105376:	6a 00                	push   $0x0
80105378:	e8 e3 f6 ff ff       	call   80104a60 <argstr>
8010537d:	83 c4 10             	add    $0x10,%esp
80105380:	85 c0                	test   %eax,%eax
80105382:	78 34                	js     801053b8 <sys_mkdir+0x58>
80105384:	83 ec 0c             	sub    $0xc,%esp
80105387:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010538a:	31 c9                	xor    %ecx,%ecx
8010538c:	ba 01 00 00 00       	mov    $0x1,%edx
80105391:	6a 00                	push   $0x0
80105393:	e8 78 f7 ff ff       	call   80104b10 <create>
80105398:	83 c4 10             	add    $0x10,%esp
8010539b:	85 c0                	test   %eax,%eax
8010539d:	74 19                	je     801053b8 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010539f:	83 ec 0c             	sub    $0xc,%esp
801053a2:	50                   	push   %eax
801053a3:	e8 68 c6 ff ff       	call   80101a10 <iunlockput>
  end_op();
801053a8:	e8 03 da ff ff       	call   80102db0 <end_op>
  return 0;
801053ad:	83 c4 10             	add    $0x10,%esp
801053b0:	31 c0                	xor    %eax,%eax
}
801053b2:	c9                   	leave  
801053b3:	c3                   	ret    
801053b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
801053b8:	e8 f3 d9 ff ff       	call   80102db0 <end_op>
    return -1;
801053bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053c2:	c9                   	leave  
801053c3:	c3                   	ret    
801053c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801053cf:	90                   	nop

801053d0 <sys_mknod>:

int
sys_mknod(void)
{
801053d0:	f3 0f 1e fb          	endbr32 
801053d4:	55                   	push   %ebp
801053d5:	89 e5                	mov    %esp,%ebp
801053d7:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801053da:	e8 61 d9 ff ff       	call   80102d40 <begin_op>
  if((argstr(0, &path)) < 0 ||
801053df:	83 ec 08             	sub    $0x8,%esp
801053e2:	8d 45 ec             	lea    -0x14(%ebp),%eax
801053e5:	50                   	push   %eax
801053e6:	6a 00                	push   $0x0
801053e8:	e8 73 f6 ff ff       	call   80104a60 <argstr>
801053ed:	83 c4 10             	add    $0x10,%esp
801053f0:	85 c0                	test   %eax,%eax
801053f2:	78 64                	js     80105458 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
801053f4:	83 ec 08             	sub    $0x8,%esp
801053f7:	8d 45 f0             	lea    -0x10(%ebp),%eax
801053fa:	50                   	push   %eax
801053fb:	6a 01                	push   $0x1
801053fd:	e8 ae f5 ff ff       	call   801049b0 <argint>
  if((argstr(0, &path)) < 0 ||
80105402:	83 c4 10             	add    $0x10,%esp
80105405:	85 c0                	test   %eax,%eax
80105407:	78 4f                	js     80105458 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
80105409:	83 ec 08             	sub    $0x8,%esp
8010540c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010540f:	50                   	push   %eax
80105410:	6a 02                	push   $0x2
80105412:	e8 99 f5 ff ff       	call   801049b0 <argint>
     argint(1, &major) < 0 ||
80105417:	83 c4 10             	add    $0x10,%esp
8010541a:	85 c0                	test   %eax,%eax
8010541c:	78 3a                	js     80105458 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010541e:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105422:	83 ec 0c             	sub    $0xc,%esp
80105425:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105429:	ba 03 00 00 00       	mov    $0x3,%edx
8010542e:	50                   	push   %eax
8010542f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105432:	e8 d9 f6 ff ff       	call   80104b10 <create>
     argint(2, &minor) < 0 ||
80105437:	83 c4 10             	add    $0x10,%esp
8010543a:	85 c0                	test   %eax,%eax
8010543c:	74 1a                	je     80105458 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010543e:	83 ec 0c             	sub    $0xc,%esp
80105441:	50                   	push   %eax
80105442:	e8 c9 c5 ff ff       	call   80101a10 <iunlockput>
  end_op();
80105447:	e8 64 d9 ff ff       	call   80102db0 <end_op>
  return 0;
8010544c:	83 c4 10             	add    $0x10,%esp
8010544f:	31 c0                	xor    %eax,%eax
}
80105451:	c9                   	leave  
80105452:	c3                   	ret    
80105453:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105457:	90                   	nop
    end_op();
80105458:	e8 53 d9 ff ff       	call   80102db0 <end_op>
    return -1;
8010545d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105462:	c9                   	leave  
80105463:	c3                   	ret    
80105464:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010546b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010546f:	90                   	nop

80105470 <sys_chdir>:

int
sys_chdir(void)
{
80105470:	f3 0f 1e fb          	endbr32 
80105474:	55                   	push   %ebp
80105475:	89 e5                	mov    %esp,%ebp
80105477:	56                   	push   %esi
80105478:	53                   	push   %ebx
80105479:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
8010547c:	e8 ff e4 ff ff       	call   80103980 <myproc>
80105481:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105483:	e8 b8 d8 ff ff       	call   80102d40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105488:	83 ec 08             	sub    $0x8,%esp
8010548b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010548e:	50                   	push   %eax
8010548f:	6a 00                	push   $0x0
80105491:	e8 ca f5 ff ff       	call   80104a60 <argstr>
80105496:	83 c4 10             	add    $0x10,%esp
80105499:	85 c0                	test   %eax,%eax
8010549b:	78 73                	js     80105510 <sys_chdir+0xa0>
8010549d:	83 ec 0c             	sub    $0xc,%esp
801054a0:	ff 75 f4             	pushl  -0xc(%ebp)
801054a3:	e8 98 cb ff ff       	call   80102040 <namei>
801054a8:	83 c4 10             	add    $0x10,%esp
801054ab:	89 c3                	mov    %eax,%ebx
801054ad:	85 c0                	test   %eax,%eax
801054af:	74 5f                	je     80105510 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801054b1:	83 ec 0c             	sub    $0xc,%esp
801054b4:	50                   	push   %eax
801054b5:	e8 b6 c2 ff ff       	call   80101770 <ilock>
  if(ip->type != T_DIR){
801054ba:	83 c4 10             	add    $0x10,%esp
801054bd:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801054c2:	75 2c                	jne    801054f0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801054c4:	83 ec 0c             	sub    $0xc,%esp
801054c7:	53                   	push   %ebx
801054c8:	e8 83 c3 ff ff       	call   80101850 <iunlock>
  iput(curproc->cwd);
801054cd:	58                   	pop    %eax
801054ce:	ff 76 68             	pushl  0x68(%esi)
801054d1:	e8 ca c3 ff ff       	call   801018a0 <iput>
  end_op();
801054d6:	e8 d5 d8 ff ff       	call   80102db0 <end_op>
  curproc->cwd = ip;
801054db:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801054de:	83 c4 10             	add    $0x10,%esp
801054e1:	31 c0                	xor    %eax,%eax
}
801054e3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801054e6:	5b                   	pop    %ebx
801054e7:	5e                   	pop    %esi
801054e8:	5d                   	pop    %ebp
801054e9:	c3                   	ret    
801054ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
801054f0:	83 ec 0c             	sub    $0xc,%esp
801054f3:	53                   	push   %ebx
801054f4:	e8 17 c5 ff ff       	call   80101a10 <iunlockput>
    end_op();
801054f9:	e8 b2 d8 ff ff       	call   80102db0 <end_op>
    return -1;
801054fe:	83 c4 10             	add    $0x10,%esp
80105501:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105506:	eb db                	jmp    801054e3 <sys_chdir+0x73>
80105508:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010550f:	90                   	nop
    end_op();
80105510:	e8 9b d8 ff ff       	call   80102db0 <end_op>
    return -1;
80105515:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010551a:	eb c7                	jmp    801054e3 <sys_chdir+0x73>
8010551c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105520 <sys_exec>:

int
sys_exec(void)
{
80105520:	f3 0f 1e fb          	endbr32 
80105524:	55                   	push   %ebp
80105525:	89 e5                	mov    %esp,%ebp
80105527:	57                   	push   %edi
80105528:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105529:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010552f:	53                   	push   %ebx
80105530:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105536:	50                   	push   %eax
80105537:	6a 00                	push   $0x0
80105539:	e8 22 f5 ff ff       	call   80104a60 <argstr>
8010553e:	83 c4 10             	add    $0x10,%esp
80105541:	85 c0                	test   %eax,%eax
80105543:	0f 88 8b 00 00 00    	js     801055d4 <sys_exec+0xb4>
80105549:	83 ec 08             	sub    $0x8,%esp
8010554c:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105552:	50                   	push   %eax
80105553:	6a 01                	push   $0x1
80105555:	e8 56 f4 ff ff       	call   801049b0 <argint>
8010555a:	83 c4 10             	add    $0x10,%esp
8010555d:	85 c0                	test   %eax,%eax
8010555f:	78 73                	js     801055d4 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105561:	83 ec 04             	sub    $0x4,%esp
80105564:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
8010556a:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
8010556c:	68 80 00 00 00       	push   $0x80
80105571:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105577:	6a 00                	push   $0x0
80105579:	50                   	push   %eax
8010557a:	e8 51 f1 ff ff       	call   801046d0 <memset>
8010557f:	83 c4 10             	add    $0x10,%esp
80105582:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105588:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
8010558e:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105595:	83 ec 08             	sub    $0x8,%esp
80105598:	57                   	push   %edi
80105599:	01 f0                	add    %esi,%eax
8010559b:	50                   	push   %eax
8010559c:	e8 6f f3 ff ff       	call   80104910 <fetchint>
801055a1:	83 c4 10             	add    $0x10,%esp
801055a4:	85 c0                	test   %eax,%eax
801055a6:	78 2c                	js     801055d4 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
801055a8:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801055ae:	85 c0                	test   %eax,%eax
801055b0:	74 36                	je     801055e8 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801055b2:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
801055b8:	83 ec 08             	sub    $0x8,%esp
801055bb:	8d 14 31             	lea    (%ecx,%esi,1),%edx
801055be:	52                   	push   %edx
801055bf:	50                   	push   %eax
801055c0:	e8 8b f3 ff ff       	call   80104950 <fetchstr>
801055c5:	83 c4 10             	add    $0x10,%esp
801055c8:	85 c0                	test   %eax,%eax
801055ca:	78 08                	js     801055d4 <sys_exec+0xb4>
  for(i=0;; i++){
801055cc:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801055cf:	83 fb 20             	cmp    $0x20,%ebx
801055d2:	75 b4                	jne    80105588 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
801055d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801055d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055dc:	5b                   	pop    %ebx
801055dd:	5e                   	pop    %esi
801055de:	5f                   	pop    %edi
801055df:	5d                   	pop    %ebp
801055e0:	c3                   	ret    
801055e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
801055e8:	83 ec 08             	sub    $0x8,%esp
801055eb:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
801055f1:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801055f8:	00 00 00 00 
  return exec(path, argv);
801055fc:	50                   	push   %eax
801055fd:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105603:	e8 78 b4 ff ff       	call   80100a80 <exec>
80105608:	83 c4 10             	add    $0x10,%esp
}
8010560b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010560e:	5b                   	pop    %ebx
8010560f:	5e                   	pop    %esi
80105610:	5f                   	pop    %edi
80105611:	5d                   	pop    %ebp
80105612:	c3                   	ret    
80105613:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010561a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105620 <sys_pipe>:

int
sys_pipe(void)
{
80105620:	f3 0f 1e fb          	endbr32 
80105624:	55                   	push   %ebp
80105625:	89 e5                	mov    %esp,%ebp
80105627:	57                   	push   %edi
80105628:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105629:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
8010562c:	53                   	push   %ebx
8010562d:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105630:	6a 08                	push   $0x8
80105632:	50                   	push   %eax
80105633:	6a 00                	push   $0x0
80105635:	e8 c6 f3 ff ff       	call   80104a00 <argptr>
8010563a:	83 c4 10             	add    $0x10,%esp
8010563d:	85 c0                	test   %eax,%eax
8010563f:	78 4e                	js     8010568f <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105641:	83 ec 08             	sub    $0x8,%esp
80105644:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105647:	50                   	push   %eax
80105648:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010564b:	50                   	push   %eax
8010564c:	e8 af dd ff ff       	call   80103400 <pipealloc>
80105651:	83 c4 10             	add    $0x10,%esp
80105654:	85 c0                	test   %eax,%eax
80105656:	78 37                	js     8010568f <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105658:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010565b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010565d:	e8 1e e3 ff ff       	call   80103980 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105662:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80105668:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010566c:	85 f6                	test   %esi,%esi
8010566e:	74 30                	je     801056a0 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
80105670:	83 c3 01             	add    $0x1,%ebx
80105673:	83 fb 10             	cmp    $0x10,%ebx
80105676:	75 f0                	jne    80105668 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105678:	83 ec 0c             	sub    $0xc,%esp
8010567b:	ff 75 e0             	pushl  -0x20(%ebp)
8010567e:	e8 4d b8 ff ff       	call   80100ed0 <fileclose>
    fileclose(wf);
80105683:	58                   	pop    %eax
80105684:	ff 75 e4             	pushl  -0x1c(%ebp)
80105687:	e8 44 b8 ff ff       	call   80100ed0 <fileclose>
    return -1;
8010568c:	83 c4 10             	add    $0x10,%esp
8010568f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105694:	eb 5b                	jmp    801056f1 <sys_pipe+0xd1>
80105696:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010569d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
801056a0:	8d 73 08             	lea    0x8(%ebx),%esi
801056a3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801056a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801056aa:	e8 d1 e2 ff ff       	call   80103980 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801056af:	31 d2                	xor    %edx,%edx
801056b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801056b8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801056bc:	85 c9                	test   %ecx,%ecx
801056be:	74 20                	je     801056e0 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
801056c0:	83 c2 01             	add    $0x1,%edx
801056c3:	83 fa 10             	cmp    $0x10,%edx
801056c6:	75 f0                	jne    801056b8 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
801056c8:	e8 b3 e2 ff ff       	call   80103980 <myproc>
801056cd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801056d4:	00 
801056d5:	eb a1                	jmp    80105678 <sys_pipe+0x58>
801056d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056de:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801056e0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
801056e4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801056e7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801056e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801056ec:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801056ef:	31 c0                	xor    %eax,%eax
}
801056f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056f4:	5b                   	pop    %ebx
801056f5:	5e                   	pop    %esi
801056f6:	5f                   	pop    %edi
801056f7:	5d                   	pop    %ebp
801056f8:	c3                   	ret    
801056f9:	66 90                	xchg   %ax,%ax
801056fb:	66 90                	xchg   %ax,%ax
801056fd:	66 90                	xchg   %ax,%ax
801056ff:	90                   	nop

80105700 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105700:	f3 0f 1e fb          	endbr32 
  return fork();
80105704:	e9 27 e4 ff ff       	jmp    80103b30 <fork>
80105709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105710 <sys_exit>:
}

int
sys_exit(void)
{
80105710:	f3 0f 1e fb          	endbr32 
80105714:	55                   	push   %ebp
80105715:	89 e5                	mov    %esp,%ebp
80105717:	83 ec 08             	sub    $0x8,%esp
  exit();
8010571a:	e8 d1 e6 ff ff       	call   80103df0 <exit>
  return 0;  // not reached
}
8010571f:	31 c0                	xor    %eax,%eax
80105721:	c9                   	leave  
80105722:	c3                   	ret    
80105723:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010572a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105730 <sys_wait>:

int
sys_wait(void)
{
80105730:	f3 0f 1e fb          	endbr32 
  return wait();
80105734:	e9 07 e9 ff ff       	jmp    80104040 <wait>
80105739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105740 <sys_kill>:
}

int
sys_kill(void)
{
80105740:	f3 0f 1e fb          	endbr32 
80105744:	55                   	push   %ebp
80105745:	89 e5                	mov    %esp,%ebp
80105747:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010574a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010574d:	50                   	push   %eax
8010574e:	6a 00                	push   $0x0
80105750:	e8 5b f2 ff ff       	call   801049b0 <argint>
80105755:	83 c4 10             	add    $0x10,%esp
80105758:	85 c0                	test   %eax,%eax
8010575a:	78 14                	js     80105770 <sys_kill+0x30>
    return -1;
  return kill(pid);
8010575c:	83 ec 0c             	sub    $0xc,%esp
8010575f:	ff 75 f4             	pushl  -0xc(%ebp)
80105762:	e8 39 ea ff ff       	call   801041a0 <kill>
80105767:	83 c4 10             	add    $0x10,%esp
}
8010576a:	c9                   	leave  
8010576b:	c3                   	ret    
8010576c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105770:	c9                   	leave  
    return -1;
80105771:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105776:	c3                   	ret    
80105777:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010577e:	66 90                	xchg   %ax,%ax

80105780 <sys_getpid>:

int
sys_getpid(void)
{
80105780:	f3 0f 1e fb          	endbr32 
80105784:	55                   	push   %ebp
80105785:	89 e5                	mov    %esp,%ebp
80105787:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
8010578a:	e8 f1 e1 ff ff       	call   80103980 <myproc>
8010578f:	8b 40 10             	mov    0x10(%eax),%eax
}
80105792:	c9                   	leave  
80105793:	c3                   	ret    
80105794:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010579b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010579f:	90                   	nop

801057a0 <sys_sbrk>:

int
sys_sbrk(void)
{
801057a0:	f3 0f 1e fb          	endbr32 
801057a4:	55                   	push   %ebp
801057a5:	89 e5                	mov    %esp,%ebp
801057a7:	53                   	push   %ebx
  int addr;
  int n;
  if(argint(0, &n) < 0)
801057a8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801057ab:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801057ae:	50                   	push   %eax
801057af:	6a 00                	push   $0x0
801057b1:	e8 fa f1 ff ff       	call   801049b0 <argint>
801057b6:	83 c4 10             	add    $0x10,%esp
801057b9:	85 c0                	test   %eax,%eax
801057bb:	78 23                	js     801057e0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801057bd:	e8 be e1 ff ff       	call   80103980 <myproc>
 // myproc()->sz+=n;
  if(growproc(n) < 0)
801057c2:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801057c5:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801057c7:	ff 75 f4             	pushl  -0xc(%ebp)
801057ca:	e8 e1 e2 ff ff       	call   80103ab0 <growproc>
801057cf:	83 c4 10             	add    $0x10,%esp
801057d2:	85 c0                	test   %eax,%eax
801057d4:	78 0a                	js     801057e0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801057d6:	89 d8                	mov    %ebx,%eax
801057d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801057db:	c9                   	leave  
801057dc:	c3                   	ret    
801057dd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801057e0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801057e5:	eb ef                	jmp    801057d6 <sys_sbrk+0x36>
801057e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057ee:	66 90                	xchg   %ax,%ax

801057f0 <sys_sleep>:

int
sys_sleep(void)
{
801057f0:	f3 0f 1e fb          	endbr32 
801057f4:	55                   	push   %ebp
801057f5:	89 e5                	mov    %esp,%ebp
801057f7:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801057f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801057fb:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801057fe:	50                   	push   %eax
801057ff:	6a 00                	push   $0x0
80105801:	e8 aa f1 ff ff       	call   801049b0 <argint>
80105806:	83 c4 10             	add    $0x10,%esp
80105809:	85 c0                	test   %eax,%eax
8010580b:	0f 88 86 00 00 00    	js     80105897 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105811:	83 ec 0c             	sub    $0xc,%esp
80105814:	68 60 4d 11 80       	push   $0x80114d60
80105819:	e8 a2 ed ff ff       	call   801045c0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010581e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105821:	8b 1d a0 55 11 80    	mov    0x801155a0,%ebx
  while(ticks - ticks0 < n){
80105827:	83 c4 10             	add    $0x10,%esp
8010582a:	85 d2                	test   %edx,%edx
8010582c:	75 23                	jne    80105851 <sys_sleep+0x61>
8010582e:	eb 50                	jmp    80105880 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105830:	83 ec 08             	sub    $0x8,%esp
80105833:	68 60 4d 11 80       	push   $0x80114d60
80105838:	68 a0 55 11 80       	push   $0x801155a0
8010583d:	e8 3e e7 ff ff       	call   80103f80 <sleep>
  while(ticks - ticks0 < n){
80105842:	a1 a0 55 11 80       	mov    0x801155a0,%eax
80105847:	83 c4 10             	add    $0x10,%esp
8010584a:	29 d8                	sub    %ebx,%eax
8010584c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010584f:	73 2f                	jae    80105880 <sys_sleep+0x90>
    if(myproc()->killed){
80105851:	e8 2a e1 ff ff       	call   80103980 <myproc>
80105856:	8b 40 24             	mov    0x24(%eax),%eax
80105859:	85 c0                	test   %eax,%eax
8010585b:	74 d3                	je     80105830 <sys_sleep+0x40>
      release(&tickslock);
8010585d:	83 ec 0c             	sub    $0xc,%esp
80105860:	68 60 4d 11 80       	push   $0x80114d60
80105865:	e8 16 ee ff ff       	call   80104680 <release>
  }
  release(&tickslock);
  return 0;
}
8010586a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010586d:	83 c4 10             	add    $0x10,%esp
80105870:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105875:	c9                   	leave  
80105876:	c3                   	ret    
80105877:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010587e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105880:	83 ec 0c             	sub    $0xc,%esp
80105883:	68 60 4d 11 80       	push   $0x80114d60
80105888:	e8 f3 ed ff ff       	call   80104680 <release>
  return 0;
8010588d:	83 c4 10             	add    $0x10,%esp
80105890:	31 c0                	xor    %eax,%eax
}
80105892:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105895:	c9                   	leave  
80105896:	c3                   	ret    
    return -1;
80105897:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010589c:	eb f4                	jmp    80105892 <sys_sleep+0xa2>
8010589e:	66 90                	xchg   %ax,%ax

801058a0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801058a0:	f3 0f 1e fb          	endbr32 
801058a4:	55                   	push   %ebp
801058a5:	89 e5                	mov    %esp,%ebp
801058a7:	53                   	push   %ebx
801058a8:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801058ab:	68 60 4d 11 80       	push   $0x80114d60
801058b0:	e8 0b ed ff ff       	call   801045c0 <acquire>
  xticks = ticks;
801058b5:	8b 1d a0 55 11 80    	mov    0x801155a0,%ebx
  release(&tickslock);
801058bb:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
801058c2:	e8 b9 ed ff ff       	call   80104680 <release>
  return xticks;
}
801058c7:	89 d8                	mov    %ebx,%eax
801058c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801058cc:	c9                   	leave  
801058cd:	c3                   	ret    
801058ce:	66 90                	xchg   %ax,%ax

801058d0 <sys_mydate>:
int
sys_mydate(void)
{
801058d0:	f3 0f 1e fb          	endbr32 
801058d4:	55                   	push   %ebp
801058d5:	89 e5                	mov    %esp,%ebp
801058d7:	83 ec 1c             	sub    $0x1c,%esp
   struct rtcdate* r;
   if(argptr(0,(void*)&r, sizeof(*r) ) <0 )
801058da:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058dd:	6a 18                	push   $0x18
801058df:	50                   	push   %eax
801058e0:	6a 00                	push   $0x0
801058e2:	e8 19 f1 ff ff       	call   80104a00 <argptr>
801058e7:	83 c4 10             	add    $0x10,%esp
801058ea:	85 c0                	test   %eax,%eax
801058ec:	78 12                	js     80105900 <sys_mydate+0x30>
      return -1;
  cmostime(r) ;   
801058ee:	83 ec 0c             	sub    $0xc,%esp
801058f1:	ff 75 f4             	pushl  -0xc(%ebp)
801058f4:	e8 a7 d0 ff ff       	call   801029a0 <cmostime>
  //r->day=2;
 // r->hour=4;
  return 0;
801058f9:	83 c4 10             	add    $0x10,%esp
801058fc:	31 c0                	xor    %eax,%eax
}
801058fe:	c9                   	leave  
801058ff:	c3                   	ret    
80105900:	c9                   	leave  
      return -1;
80105901:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105906:	c3                   	ret    
80105907:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010590e:	66 90                	xchg   %ax,%ax

80105910 <sys_mypgtPrint>:


// System call for printing Page Table
int
sys_mypgtPrint(void)
{
80105910:	f3 0f 1e fb          	endbr32 
80105914:	55                   	push   %ebp
80105915:	89 e5                	mov    %esp,%ebp
80105917:	57                   	push   %edi
  pde_t *pde;
  pte_t *pagetable;
  

  uint i, j, k;
  j = 0;
80105918:	31 ff                	xor    %edi,%edi
{
8010591a:	56                   	push   %esi
8010591b:	53                   	push   %ebx
8010591c:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *pgdir = myproc()->pgdir;
8010591f:	e8 5c e0 ff ff       	call   80103980 <myproc>
 

  for (i = 0; i < NPDENTRIES; i++)
80105924:	31 c9                	xor    %ecx,%ecx
  pde_t *pgdir = myproc()->pgdir;
80105926:	8b 40 04             	mov    0x4(%eax),%eax
80105929:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for (i = 0; i < NPDENTRIES; i++)
8010592c:	eb 0d                	jmp    8010593b <sys_mypgtPrint+0x2b>
8010592e:	66 90                	xchg   %ax,%ax
80105930:	83 c1 01             	add    $0x1,%ecx
80105933:	81 f9 00 04 00 00    	cmp    $0x400,%ecx
80105939:	74 7d                	je     801059b8 <sys_mypgtPrint+0xa8>
  {
    pde=&pgdir[i];
    if (*pde & PTE_P)
8010593b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010593e:	8b 34 88             	mov    (%eax,%ecx,4),%esi
    {
      if (*pde & PTE_U)
80105941:	89 f0                	mov    %esi,%eax
80105943:	83 e0 05             	and    $0x5,%eax
80105946:	83 f8 05             	cmp    $0x5,%eax
80105949:	75 e5                	jne    80105930 <sys_mypgtPrint+0x20>
      {
        pagetable = (pte_t *)P2V(PTE_ADDR(*pde));
8010594b:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80105951:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80105954:	8d 9e 00 00 00 80    	lea    -0x80000000(%esi),%ebx
        for (k = 0; k < NPTENTRIES; k++)
8010595a:	81 ee 00 f0 ff 7f    	sub    $0x7ffff000,%esi
80105960:	89 f0                	mov    %esi,%eax
80105962:	89 fe                	mov    %edi,%esi
80105964:	89 c7                	mov    %eax,%edi
80105966:	eb 0f                	jmp    80105977 <sys_mypgtPrint+0x67>
80105968:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010596f:	90                   	nop
80105970:	83 c3 04             	add    $0x4,%ebx
80105973:	39 fb                	cmp    %edi,%ebx
80105975:	74 31                	je     801059a8 <sys_mypgtPrint+0x98>
        {
          pte_t pte = pagetable[k];
80105977:	8b 03                	mov    (%ebx),%eax
          if (pte & PTE_P)
          {
            if (pte & PTE_U)
80105979:	89 c1                	mov    %eax,%ecx
8010597b:	83 e1 05             	and    $0x5,%ecx
8010597e:	83 f9 05             	cmp    $0x5,%ecx
80105981:	75 ed                	jne    80105970 <sys_mypgtPrint+0x60>
            {
              cprintf("Pgdir entrynum: %d, Entry number: %d, Virtual address: %p, Physical address: %p\n",i, j,P2V(pte), pte);
80105983:	83 ec 0c             	sub    $0xc,%esp
80105986:	83 c3 04             	add    $0x4,%ebx
80105989:	50                   	push   %eax
8010598a:	05 00 00 00 80       	add    $0x80000000,%eax
8010598f:	50                   	push   %eax
80105990:	56                   	push   %esi
              j++;
80105991:	83 c6 01             	add    $0x1,%esi
              cprintf("Pgdir entrynum: %d, Entry number: %d, Virtual address: %p, Physical address: %p\n",i, j,P2V(pte), pte);
80105994:	ff 75 e4             	pushl  -0x1c(%ebp)
80105997:	68 ac 7b 10 80       	push   $0x80107bac
8010599c:	e8 0f ad ff ff       	call   801006b0 <cprintf>
              j++;
801059a1:	83 c4 20             	add    $0x20,%esp
        for (k = 0; k < NPTENTRIES; k++)
801059a4:	39 fb                	cmp    %edi,%ebx
801059a6:	75 cf                	jne    80105977 <sys_mypgtPrint+0x67>
801059a8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801059ab:	89 f7                	mov    %esi,%edi
  for (i = 0; i < NPDENTRIES; i++)
801059ad:	83 c1 01             	add    $0x1,%ecx
801059b0:	81 f9 00 04 00 00    	cmp    $0x400,%ecx
801059b6:	75 83                	jne    8010593b <sys_mypgtPrint+0x2b>
        }
      }
    }
  }
  return 0;
}
801059b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059bb:	31 c0                	xor    %eax,%eax
801059bd:	5b                   	pop    %ebx
801059be:	5e                   	pop    %esi
801059bf:	5f                   	pop    %edi
801059c0:	5d                   	pop    %ebp
801059c1:	c3                   	ret    
801059c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801059d0 <sys_setPriority>:
int
sys_setPriority(void)
{
801059d0:	f3 0f 1e fb          	endbr32 
801059d4:	55                   	push   %ebp
801059d5:	89 e5                	mov    %esp,%ebp
801059d7:	83 ec 20             	sub    $0x20,%esp
  int priority;
  if(argint(0, &priority) < 0)
801059da:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059dd:	50                   	push   %eax
801059de:	6a 00                	push   $0x0
801059e0:	e8 cb ef ff ff       	call   801049b0 <argint>
801059e5:	83 c4 10             	add    $0x10,%esp
801059e8:	85 c0                	test   %eax,%eax
801059ea:	78 4a                	js     80105a36 <sys_setPriority+0x66>
    return -1;
  if(priority>9 || priority<0)
801059ec:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801059f0:	77 16                	ja     80105a08 <sys_setPriority+0x38>
  {
    cprintf("Tried to change incorrect Priority with %d as priority for pid: \n",priority,myproc()->pid);
    cprintf("Priority Unchanged!\n");
    return -1;
  }  
  myproc()->priority=priority;
801059f2:	e8 89 df ff ff       	call   80103980 <myproc>
801059f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801059fa:	89 50 7c             	mov    %edx,0x7c(%eax)
  return 0;
801059fd:	31 c0                	xor    %eax,%eax
}
801059ff:	c9                   	leave  
80105a00:	c3                   	ret    
80105a01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf("Tried to change incorrect Priority with %d as priority for pid: \n",priority,myproc()->pid);
80105a08:	e8 73 df ff ff       	call   80103980 <myproc>
80105a0d:	83 ec 04             	sub    $0x4,%esp
80105a10:	ff 70 10             	pushl  0x10(%eax)
80105a13:	ff 75 f4             	pushl  -0xc(%ebp)
80105a16:	68 00 7c 10 80       	push   $0x80107c00
80105a1b:	e8 90 ac ff ff       	call   801006b0 <cprintf>
    cprintf("Priority Unchanged!\n");
80105a20:	c7 04 24 42 7c 10 80 	movl   $0x80107c42,(%esp)
80105a27:	e8 84 ac ff ff       	call   801006b0 <cprintf>
    return -1;
80105a2c:	83 c4 10             	add    $0x10,%esp
80105a2f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a34:	c9                   	leave  
80105a35:	c3                   	ret    
80105a36:	c9                   	leave  
    return -1;
80105a37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a3c:	c3                   	ret    
80105a3d:	8d 76 00             	lea    0x0(%esi),%esi

80105a40 <sys_getPriority>:

int 
sys_getPriority()
{
80105a40:	f3 0f 1e fb          	endbr32 
80105a44:	55                   	push   %ebp
80105a45:	89 e5                	mov    %esp,%ebp
80105a47:	83 ec 08             	sub    $0x8,%esp
  return myproc()->priority;
80105a4a:	e8 31 df ff ff       	call   80103980 <myproc>
80105a4f:	8b 40 7c             	mov    0x7c(%eax),%eax
}
80105a52:	c9                   	leave  
80105a53:	c3                   	ret    

80105a54 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105a54:	1e                   	push   %ds
  pushl %es
80105a55:	06                   	push   %es
  pushl %fs
80105a56:	0f a0                	push   %fs
  pushl %gs
80105a58:	0f a8                	push   %gs
  pushal
80105a5a:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105a5b:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105a5f:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105a61:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105a63:	54                   	push   %esp
  call trap
80105a64:	e8 c7 01 00 00       	call   80105c30 <trap>
  addl $4, %esp
80105a69:	83 c4 04             	add    $0x4,%esp

80105a6c <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105a6c:	61                   	popa   
  popl %gs
80105a6d:	0f a9                	pop    %gs
  popl %fs
80105a6f:	0f a1                	pop    %fs
  popl %es
80105a71:	07                   	pop    %es
  popl %ds
80105a72:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105a73:	83 c4 08             	add    $0x8,%esp
  iret
80105a76:	cf                   	iret   
80105a77:	66 90                	xchg   %ax,%ax
80105a79:	66 90                	xchg   %ax,%ax
80105a7b:	66 90                	xchg   %ax,%ax
80105a7d:	66 90                	xchg   %ax,%ax
80105a7f:	90                   	nop

80105a80 <tvinit>:
uint ticks;
void pg_fault_handler(void);
int mappages(pde_t *, void *, uint, uint, int);
pte_t *walkpgdir(pde_t *, const void *, int);
void tvinit(void)
{
80105a80:	f3 0f 1e fb          	endbr32 
80105a84:	55                   	push   %ebp
  int i;

  for (i = 0; i < 256; i++)
80105a85:	31 c0                	xor    %eax,%eax
{
80105a87:	89 e5                	mov    %esp,%ebp
80105a89:	83 ec 08             	sub    $0x8,%esp
80105a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE << 3, vectors[i], 0);
80105a90:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105a97:	c7 04 c5 a2 4d 11 80 	movl   $0x8e000008,-0x7feeb25e(,%eax,8)
80105a9e:	08 00 00 8e 
80105aa2:	66 89 14 c5 a0 4d 11 	mov    %dx,-0x7feeb260(,%eax,8)
80105aa9:	80 
80105aaa:	c1 ea 10             	shr    $0x10,%edx
80105aad:	66 89 14 c5 a6 4d 11 	mov    %dx,-0x7feeb25a(,%eax,8)
80105ab4:	80 
  for (i = 0; i < 256; i++)
80105ab5:	83 c0 01             	add    $0x1,%eax
80105ab8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105abd:	75 d1                	jne    80105a90 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105abf:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
80105ac2:	a1 08 a1 10 80       	mov    0x8010a108,%eax
80105ac7:	c7 05 a2 4f 11 80 08 	movl   $0xef000008,0x80114fa2
80105ace:	00 00 ef 
  initlock(&tickslock, "time");
80105ad1:	68 57 7c 10 80       	push   $0x80107c57
80105ad6:	68 60 4d 11 80       	push   $0x80114d60
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
80105adb:	66 a3 a0 4f 11 80    	mov    %ax,0x80114fa0
80105ae1:	c1 e8 10             	shr    $0x10,%eax
80105ae4:	66 a3 a6 4f 11 80    	mov    %ax,0x80114fa6
  initlock(&tickslock, "time");
80105aea:	e8 51 e9 ff ff       	call   80104440 <initlock>
}
80105aef:	83 c4 10             	add    $0x10,%esp
80105af2:	c9                   	leave  
80105af3:	c3                   	ret    
80105af4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105afb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105aff:	90                   	nop

80105b00 <idtinit>:

void idtinit(void)
{
80105b00:	f3 0f 1e fb          	endbr32 
80105b04:	55                   	push   %ebp
  pd[0] = size-1;
80105b05:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105b0a:	89 e5                	mov    %esp,%ebp
80105b0c:	83 ec 10             	sub    $0x10,%esp
80105b0f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105b13:	b8 a0 4d 11 80       	mov    $0x80114da0,%eax
80105b18:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105b1c:	c1 e8 10             	shr    $0x10,%eax
80105b1f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105b23:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105b26:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105b29:	c9                   	leave  
80105b2a:	c3                   	ret    
80105b2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b2f:	90                   	nop

80105b30 <pg_fault_handler>:
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
    exit();
}
// Trap Handler
void pg_fault_handler(void)
{
80105b30:	f3 0f 1e fb          	endbr32 
80105b34:	55                   	push   %ebp
80105b35:	89 e5                	mov    %esp,%ebp
80105b37:	57                   	push   %edi
80105b38:	56                   	push   %esi
80105b39:	53                   	push   %ebx
80105b3a:	83 ec 24             	sub    $0x24,%esp

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105b3d:	0f 20 d7             	mov    %cr2,%edi

  uint fault_adr = rcr2();
  cprintf("page fault occurred, doing demand paging for address: %p\n", fault_adr);
80105b40:	57                   	push   %edi
  
  // Code for allocating the pages taken from allocuvm
  char *mem;
  uint a;
  a = PGROUNDUP(fault_adr);
80105b41:	8d b7 ff 0f 00 00    	lea    0xfff(%edi),%esi
  cprintf("page fault occurred, doing demand paging for address: %p\n", fault_adr);
80105b47:	68 98 7c 10 80       	push   $0x80107c98
  a = PGROUNDUP(fault_adr);
80105b4c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  cprintf("page fault occurred, doing demand paging for address: %p\n", fault_adr);
80105b52:	e8 59 ab ff ff       	call   801006b0 <cprintf>

  mem = kalloc();
80105b57:	e8 e4 ca ff ff       	call   80102640 <kalloc>
  if (mem == 0)
80105b5c:	83 c4 10             	add    $0x10,%esp
  mem = kalloc();
80105b5f:	89 c3                	mov    %eax,%ebx
  if (mem == 0)
80105b61:	85 c0                	test   %eax,%eax
80105b63:	0f 84 87 00 00 00    	je     80105bf0 <pg_fault_handler+0xc0>
  {
    cprintf("allocuvm out of memory\n");
    deallocuvm(myproc()->pgdir, myproc()->sz, fault_adr);
  }
  memset(mem, 0, PGSIZE);
80105b69:	83 ec 04             	sub    $0x4,%esp
80105b6c:	68 00 10 00 00       	push   $0x1000
80105b71:	6a 00                	push   $0x0
80105b73:	53                   	push   %ebx
80105b74:	e8 57 eb ff ff       	call   801046d0 <memset>
  if (mappages(myproc()->pgdir, (char *)a, PGSIZE, V2P(mem), PTE_W | PTE_U) < 0)
80105b79:	e8 02 de ff ff       	call   80103980 <myproc>
80105b7e:	8d 93 00 00 00 80    	lea    -0x80000000(%ebx),%edx
80105b84:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
80105b8b:	52                   	push   %edx
80105b8c:	68 00 10 00 00       	push   $0x1000
80105b91:	56                   	push   %esi
80105b92:	ff 70 04             	pushl  0x4(%eax)
80105b95:	e8 d6 10 00 00       	call   80106c70 <mappages>
80105b9a:	83 c4 20             	add    $0x20,%esp
80105b9d:	85 c0                	test   %eax,%eax
80105b9f:	78 0f                	js     80105bb0 <pg_fault_handler+0x80>
    cprintf("allocuvm out of memory (2)\n");
    deallocuvm(myproc()->pgdir, myproc()->sz, fault_adr);
    kfree(mem);
  }

80105ba1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ba4:	5b                   	pop    %ebx
80105ba5:	5e                   	pop    %esi
80105ba6:	5f                   	pop    %edi
80105ba7:	5d                   	pop    %ebp
80105ba8:	c3                   	ret    
80105ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf("allocuvm out of memory (2)\n");
80105bb0:	83 ec 0c             	sub    $0xc,%esp
80105bb3:	68 74 7c 10 80       	push   $0x80107c74
80105bb8:	e8 f3 aa ff ff       	call   801006b0 <cprintf>
    deallocuvm(myproc()->pgdir, myproc()->sz, fault_adr);
80105bbd:	e8 be dd ff ff       	call   80103980 <myproc>
80105bc2:	8b 30                	mov    (%eax),%esi
80105bc4:	e8 b7 dd ff ff       	call   80103980 <myproc>
80105bc9:	83 c4 0c             	add    $0xc,%esp
80105bcc:	57                   	push   %edi
80105bcd:	56                   	push   %esi
80105bce:	ff 70 04             	pushl  0x4(%eax)
80105bd1:	e8 ea 14 00 00       	call   801070c0 <deallocuvm>
    kfree(mem);
80105bd6:	89 1c 24             	mov    %ebx,(%esp)
80105bd9:	e8 a2 c8 ff ff       	call   80102480 <kfree>
80105bde:	83 c4 10             	add    $0x10,%esp
80105be1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105be4:	5b                   	pop    %ebx
80105be5:	5e                   	pop    %esi
80105be6:	5f                   	pop    %edi
80105be7:	5d                   	pop    %ebp
80105be8:	c3                   	ret    
80105be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf("allocuvm out of memory\n");
80105bf0:	83 ec 0c             	sub    $0xc,%esp
80105bf3:	68 5c 7c 10 80       	push   $0x80107c5c
80105bf8:	e8 b3 aa ff ff       	call   801006b0 <cprintf>
    deallocuvm(myproc()->pgdir, myproc()->sz, fault_adr);
80105bfd:	e8 7e dd ff ff       	call   80103980 <myproc>
80105c02:	8b 10                	mov    (%eax),%edx
80105c04:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80105c07:	e8 74 dd ff ff       	call   80103980 <myproc>
80105c0c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80105c0f:	83 c4 0c             	add    $0xc,%esp
80105c12:	57                   	push   %edi
80105c13:	52                   	push   %edx
80105c14:	ff 70 04             	pushl  0x4(%eax)
80105c17:	e8 a4 14 00 00       	call   801070c0 <deallocuvm>
80105c1c:	83 c4 10             	add    $0x10,%esp
80105c1f:	e9 45 ff ff ff       	jmp    80105b69 <pg_fault_handler+0x39>
80105c24:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c2f:	90                   	nop

80105c30 <trap>:
{
80105c30:	f3 0f 1e fb          	endbr32 
80105c34:	55                   	push   %ebp
80105c35:	89 e5                	mov    %esp,%ebp
80105c37:	57                   	push   %edi
80105c38:	56                   	push   %esi
80105c39:	53                   	push   %ebx
80105c3a:	83 ec 1c             	sub    $0x1c,%esp
80105c3d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (tf->trapno == T_SYSCALL)
80105c40:	8b 43 30             	mov    0x30(%ebx),%eax
80105c43:	83 f8 40             	cmp    $0x40,%eax
80105c46:	0f 84 d4 01 00 00    	je     80105e20 <trap+0x1f0>
  switch (tf->trapno)
80105c4c:	83 e8 0e             	sub    $0xe,%eax
80105c4f:	83 f8 31             	cmp    $0x31,%eax
80105c52:	77 08                	ja     80105c5c <trap+0x2c>
80105c54:	3e ff 24 85 70 7d 10 	notrack jmp *-0x7fef8290(,%eax,4)
80105c5b:	80 
    if (myproc() == 0 || (tf->cs & 3) == 0)
80105c5c:	e8 1f dd ff ff       	call   80103980 <myproc>
80105c61:	8b 7b 38             	mov    0x38(%ebx),%edi
80105c64:	85 c0                	test   %eax,%eax
80105c66:	0f 84 03 02 00 00    	je     80105e6f <trap+0x23f>
80105c6c:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105c70:	0f 84 f9 01 00 00    	je     80105e6f <trap+0x23f>
80105c76:	0f 20 d1             	mov    %cr2,%ecx
80105c79:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c7c:	e8 df dc ff ff       	call   80103960 <cpuid>
80105c81:	8b 73 30             	mov    0x30(%ebx),%esi
80105c84:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105c87:	8b 43 34             	mov    0x34(%ebx),%eax
80105c8a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105c8d:	e8 ee dc ff ff       	call   80103980 <myproc>
80105c92:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105c95:	e8 e6 dc ff ff       	call   80103980 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c9a:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105c9d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105ca0:	51                   	push   %ecx
80105ca1:	57                   	push   %edi
80105ca2:	52                   	push   %edx
80105ca3:	ff 75 e4             	pushl  -0x1c(%ebp)
80105ca6:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105ca7:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105caa:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105cad:	56                   	push   %esi
80105cae:	ff 70 10             	pushl  0x10(%eax)
80105cb1:	68 2c 7d 10 80       	push   $0x80107d2c
80105cb6:	e8 f5 a9 ff ff       	call   801006b0 <cprintf>
    myproc()->killed = 1;
80105cbb:	83 c4 20             	add    $0x20,%esp
80105cbe:	e8 bd dc ff ff       	call   80103980 <myproc>
80105cc3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80105cca:	e8 b1 dc ff ff       	call   80103980 <myproc>
80105ccf:	85 c0                	test   %eax,%eax
80105cd1:	74 1d                	je     80105cf0 <trap+0xc0>
80105cd3:	e8 a8 dc ff ff       	call   80103980 <myproc>
80105cd8:	8b 50 24             	mov    0x24(%eax),%edx
80105cdb:	85 d2                	test   %edx,%edx
80105cdd:	74 11                	je     80105cf0 <trap+0xc0>
80105cdf:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105ce3:	83 e0 03             	and    $0x3,%eax
80105ce6:	66 83 f8 03          	cmp    $0x3,%ax
80105cea:	0f 84 68 01 00 00    	je     80105e58 <trap+0x228>
  if (myproc() && myproc()->state == RUNNING &&
80105cf0:	e8 8b dc ff ff       	call   80103980 <myproc>
80105cf5:	85 c0                	test   %eax,%eax
80105cf7:	74 0f                	je     80105d08 <trap+0xd8>
80105cf9:	e8 82 dc ff ff       	call   80103980 <myproc>
80105cfe:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105d02:	0f 84 00 01 00 00    	je     80105e08 <trap+0x1d8>
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80105d08:	e8 73 dc ff ff       	call   80103980 <myproc>
80105d0d:	85 c0                	test   %eax,%eax
80105d0f:	74 1d                	je     80105d2e <trap+0xfe>
80105d11:	e8 6a dc ff ff       	call   80103980 <myproc>
80105d16:	8b 40 24             	mov    0x24(%eax),%eax
80105d19:	85 c0                	test   %eax,%eax
80105d1b:	74 11                	je     80105d2e <trap+0xfe>
80105d1d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105d21:	83 e0 03             	and    $0x3,%eax
80105d24:	66 83 f8 03          	cmp    $0x3,%ax
80105d28:	0f 84 1b 01 00 00    	je     80105e49 <trap+0x219>
}
80105d2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d31:	5b                   	pop    %ebx
80105d32:	5e                   	pop    %esi
80105d33:	5f                   	pop    %edi
80105d34:	5d                   	pop    %ebp
80105d35:	c3                   	ret    
    ideintr();
80105d36:	e8 b5 c4 ff ff       	call   801021f0 <ideintr>
    lapiceoi();
80105d3b:	e8 90 cb ff ff       	call   801028d0 <lapiceoi>
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80105d40:	e8 3b dc ff ff       	call   80103980 <myproc>
80105d45:	85 c0                	test   %eax,%eax
80105d47:	75 8a                	jne    80105cd3 <trap+0xa3>
80105d49:	eb a5                	jmp    80105cf0 <trap+0xc0>
    pg_fault_handler();
80105d4b:	e8 e0 fd ff ff       	call   80105b30 <pg_fault_handler>
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80105d50:	e8 2b dc ff ff       	call   80103980 <myproc>
80105d55:	85 c0                	test   %eax,%eax
80105d57:	0f 85 76 ff ff ff    	jne    80105cd3 <trap+0xa3>
80105d5d:	eb 91                	jmp    80105cf0 <trap+0xc0>
    if (cpuid() == 0)
80105d5f:	e8 fc db ff ff       	call   80103960 <cpuid>
80105d64:	85 c0                	test   %eax,%eax
80105d66:	75 d3                	jne    80105d3b <trap+0x10b>
      acquire(&tickslock);
80105d68:	83 ec 0c             	sub    $0xc,%esp
80105d6b:	68 60 4d 11 80       	push   $0x80114d60
80105d70:	e8 4b e8 ff ff       	call   801045c0 <acquire>
      wakeup(&ticks);
80105d75:	c7 04 24 a0 55 11 80 	movl   $0x801155a0,(%esp)
      ticks++;
80105d7c:	83 05 a0 55 11 80 01 	addl   $0x1,0x801155a0
      wakeup(&ticks);
80105d83:	e8 b8 e3 ff ff       	call   80104140 <wakeup>
      release(&tickslock);
80105d88:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
80105d8f:	e8 ec e8 ff ff       	call   80104680 <release>
80105d94:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105d97:	eb a2                	jmp    80105d3b <trap+0x10b>
    kbdintr();
80105d99:	e8 f2 c9 ff ff       	call   80102790 <kbdintr>
    lapiceoi();
80105d9e:	e8 2d cb ff ff       	call   801028d0 <lapiceoi>
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80105da3:	e8 d8 db ff ff       	call   80103980 <myproc>
80105da8:	85 c0                	test   %eax,%eax
80105daa:	0f 85 23 ff ff ff    	jne    80105cd3 <trap+0xa3>
80105db0:	e9 3b ff ff ff       	jmp    80105cf0 <trap+0xc0>
    uartintr();
80105db5:	e8 56 02 00 00       	call   80106010 <uartintr>
    lapiceoi();
80105dba:	e8 11 cb ff ff       	call   801028d0 <lapiceoi>
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80105dbf:	e8 bc db ff ff       	call   80103980 <myproc>
80105dc4:	85 c0                	test   %eax,%eax
80105dc6:	0f 85 07 ff ff ff    	jne    80105cd3 <trap+0xa3>
80105dcc:	e9 1f ff ff ff       	jmp    80105cf0 <trap+0xc0>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105dd1:	8b 7b 38             	mov    0x38(%ebx),%edi
80105dd4:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105dd8:	e8 83 db ff ff       	call   80103960 <cpuid>
80105ddd:	57                   	push   %edi
80105dde:	56                   	push   %esi
80105ddf:	50                   	push   %eax
80105de0:	68 d4 7c 10 80       	push   $0x80107cd4
80105de5:	e8 c6 a8 ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80105dea:	e8 e1 ca ff ff       	call   801028d0 <lapiceoi>
    break;
80105def:	83 c4 10             	add    $0x10,%esp
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80105df2:	e8 89 db ff ff       	call   80103980 <myproc>
80105df7:	85 c0                	test   %eax,%eax
80105df9:	0f 85 d4 fe ff ff    	jne    80105cd3 <trap+0xa3>
80105dff:	e9 ec fe ff ff       	jmp    80105cf0 <trap+0xc0>
80105e04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (myproc() && myproc()->state == RUNNING &&
80105e08:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105e0c:	0f 85 f6 fe ff ff    	jne    80105d08 <trap+0xd8>
    yield();
80105e12:	e8 19 e1 ff ff       	call   80103f30 <yield>
80105e17:	e9 ec fe ff ff       	jmp    80105d08 <trap+0xd8>
80105e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (myproc()->killed)
80105e20:	e8 5b db ff ff       	call   80103980 <myproc>
80105e25:	8b 70 24             	mov    0x24(%eax),%esi
80105e28:	85 f6                	test   %esi,%esi
80105e2a:	75 3c                	jne    80105e68 <trap+0x238>
    myproc()->tf = tf;
80105e2c:	e8 4f db ff ff       	call   80103980 <myproc>
80105e31:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105e34:	e8 67 ec ff ff       	call   80104aa0 <syscall>
    if (myproc()->killed)
80105e39:	e8 42 db ff ff       	call   80103980 <myproc>
80105e3e:	8b 48 24             	mov    0x24(%eax),%ecx
80105e41:	85 c9                	test   %ecx,%ecx
80105e43:	0f 84 e5 fe ff ff    	je     80105d2e <trap+0xfe>
}
80105e49:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e4c:	5b                   	pop    %ebx
80105e4d:	5e                   	pop    %esi
80105e4e:	5f                   	pop    %edi
80105e4f:	5d                   	pop    %ebp
      exit();
80105e50:	e9 9b df ff ff       	jmp    80103df0 <exit>
80105e55:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80105e58:	e8 93 df ff ff       	call   80103df0 <exit>
80105e5d:	e9 8e fe ff ff       	jmp    80105cf0 <trap+0xc0>
80105e62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105e68:	e8 83 df ff ff       	call   80103df0 <exit>
80105e6d:	eb bd                	jmp    80105e2c <trap+0x1fc>
80105e6f:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105e72:	e8 e9 da ff ff       	call   80103960 <cpuid>
80105e77:	83 ec 0c             	sub    $0xc,%esp
80105e7a:	56                   	push   %esi
80105e7b:	57                   	push   %edi
80105e7c:	50                   	push   %eax
80105e7d:	ff 73 30             	pushl  0x30(%ebx)
80105e80:	68 f8 7c 10 80       	push   $0x80107cf8
80105e85:	e8 26 a8 ff ff       	call   801006b0 <cprintf>
      panic("trap");
80105e8a:	83 c4 14             	add    $0x14,%esp
80105e8d:	68 90 7c 10 80       	push   $0x80107c90
80105e92:	e8 f9 a4 ff ff       	call   80100390 <panic>
80105e97:	66 90                	xchg   %ax,%ax
80105e99:	66 90                	xchg   %ax,%ax
80105e9b:	66 90                	xchg   %ax,%ax
80105e9d:	66 90                	xchg   %ax,%ax
80105e9f:	90                   	nop

80105ea0 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105ea0:	f3 0f 1e fb          	endbr32 
  if(!uart)
80105ea4:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
80105ea9:	85 c0                	test   %eax,%eax
80105eab:	74 1b                	je     80105ec8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105ead:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105eb2:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105eb3:	a8 01                	test   $0x1,%al
80105eb5:	74 11                	je     80105ec8 <uartgetc+0x28>
80105eb7:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ebc:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105ebd:	0f b6 c0             	movzbl %al,%eax
80105ec0:	c3                   	ret    
80105ec1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105ec8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ecd:	c3                   	ret    
80105ece:	66 90                	xchg   %ax,%ax

80105ed0 <uartputc.part.0>:
uartputc(int c)
80105ed0:	55                   	push   %ebp
80105ed1:	89 e5                	mov    %esp,%ebp
80105ed3:	57                   	push   %edi
80105ed4:	89 c7                	mov    %eax,%edi
80105ed6:	56                   	push   %esi
80105ed7:	be fd 03 00 00       	mov    $0x3fd,%esi
80105edc:	53                   	push   %ebx
80105edd:	bb 80 00 00 00       	mov    $0x80,%ebx
80105ee2:	83 ec 0c             	sub    $0xc,%esp
80105ee5:	eb 1b                	jmp    80105f02 <uartputc.part.0+0x32>
80105ee7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105eee:	66 90                	xchg   %ax,%ax
    microdelay(10);
80105ef0:	83 ec 0c             	sub    $0xc,%esp
80105ef3:	6a 0a                	push   $0xa
80105ef5:	e8 f6 c9 ff ff       	call   801028f0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105efa:	83 c4 10             	add    $0x10,%esp
80105efd:	83 eb 01             	sub    $0x1,%ebx
80105f00:	74 07                	je     80105f09 <uartputc.part.0+0x39>
80105f02:	89 f2                	mov    %esi,%edx
80105f04:	ec                   	in     (%dx),%al
80105f05:	a8 20                	test   $0x20,%al
80105f07:	74 e7                	je     80105ef0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105f09:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f0e:	89 f8                	mov    %edi,%eax
80105f10:	ee                   	out    %al,(%dx)
}
80105f11:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f14:	5b                   	pop    %ebx
80105f15:	5e                   	pop    %esi
80105f16:	5f                   	pop    %edi
80105f17:	5d                   	pop    %ebp
80105f18:	c3                   	ret    
80105f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f20 <uartinit>:
{
80105f20:	f3 0f 1e fb          	endbr32 
80105f24:	55                   	push   %ebp
80105f25:	31 c9                	xor    %ecx,%ecx
80105f27:	89 c8                	mov    %ecx,%eax
80105f29:	89 e5                	mov    %esp,%ebp
80105f2b:	57                   	push   %edi
80105f2c:	56                   	push   %esi
80105f2d:	53                   	push   %ebx
80105f2e:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105f33:	89 da                	mov    %ebx,%edx
80105f35:	83 ec 0c             	sub    $0xc,%esp
80105f38:	ee                   	out    %al,(%dx)
80105f39:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105f3e:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105f43:	89 fa                	mov    %edi,%edx
80105f45:	ee                   	out    %al,(%dx)
80105f46:	b8 0c 00 00 00       	mov    $0xc,%eax
80105f4b:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f50:	ee                   	out    %al,(%dx)
80105f51:	be f9 03 00 00       	mov    $0x3f9,%esi
80105f56:	89 c8                	mov    %ecx,%eax
80105f58:	89 f2                	mov    %esi,%edx
80105f5a:	ee                   	out    %al,(%dx)
80105f5b:	b8 03 00 00 00       	mov    $0x3,%eax
80105f60:	89 fa                	mov    %edi,%edx
80105f62:	ee                   	out    %al,(%dx)
80105f63:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105f68:	89 c8                	mov    %ecx,%eax
80105f6a:	ee                   	out    %al,(%dx)
80105f6b:	b8 01 00 00 00       	mov    $0x1,%eax
80105f70:	89 f2                	mov    %esi,%edx
80105f72:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105f73:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105f78:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105f79:	3c ff                	cmp    $0xff,%al
80105f7b:	74 52                	je     80105fcf <uartinit+0xaf>
  uart = 1;
80105f7d:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105f84:	00 00 00 
80105f87:	89 da                	mov    %ebx,%edx
80105f89:	ec                   	in     (%dx),%al
80105f8a:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f8f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105f90:	83 ec 08             	sub    $0x8,%esp
80105f93:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80105f98:	bb 38 7e 10 80       	mov    $0x80107e38,%ebx
  ioapicenable(IRQ_COM1, 0);
80105f9d:	6a 00                	push   $0x0
80105f9f:	6a 04                	push   $0x4
80105fa1:	e8 9a c4 ff ff       	call   80102440 <ioapicenable>
80105fa6:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105fa9:	b8 78 00 00 00       	mov    $0x78,%eax
80105fae:	eb 04                	jmp    80105fb4 <uartinit+0x94>
80105fb0:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80105fb4:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80105fba:	85 d2                	test   %edx,%edx
80105fbc:	74 08                	je     80105fc6 <uartinit+0xa6>
    uartputc(*p);
80105fbe:	0f be c0             	movsbl %al,%eax
80105fc1:	e8 0a ff ff ff       	call   80105ed0 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80105fc6:	89 f0                	mov    %esi,%eax
80105fc8:	83 c3 01             	add    $0x1,%ebx
80105fcb:	84 c0                	test   %al,%al
80105fcd:	75 e1                	jne    80105fb0 <uartinit+0x90>
}
80105fcf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105fd2:	5b                   	pop    %ebx
80105fd3:	5e                   	pop    %esi
80105fd4:	5f                   	pop    %edi
80105fd5:	5d                   	pop    %ebp
80105fd6:	c3                   	ret    
80105fd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fde:	66 90                	xchg   %ax,%ax

80105fe0 <uartputc>:
{
80105fe0:	f3 0f 1e fb          	endbr32 
80105fe4:	55                   	push   %ebp
  if(!uart)
80105fe5:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
{
80105feb:	89 e5                	mov    %esp,%ebp
80105fed:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80105ff0:	85 d2                	test   %edx,%edx
80105ff2:	74 0c                	je     80106000 <uartputc+0x20>
}
80105ff4:	5d                   	pop    %ebp
80105ff5:	e9 d6 fe ff ff       	jmp    80105ed0 <uartputc.part.0>
80105ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106000:	5d                   	pop    %ebp
80106001:	c3                   	ret    
80106002:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106010 <uartintr>:

void
uartintr(void)
{
80106010:	f3 0f 1e fb          	endbr32 
80106014:	55                   	push   %ebp
80106015:	89 e5                	mov    %esp,%ebp
80106017:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
8010601a:	68 a0 5e 10 80       	push   $0x80105ea0
8010601f:	e8 3c a8 ff ff       	call   80100860 <consoleintr>
}
80106024:	83 c4 10             	add    $0x10,%esp
80106027:	c9                   	leave  
80106028:	c3                   	ret    

80106029 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106029:	6a 00                	push   $0x0
  pushl $0
8010602b:	6a 00                	push   $0x0
  jmp alltraps
8010602d:	e9 22 fa ff ff       	jmp    80105a54 <alltraps>

80106032 <vector1>:
.globl vector1
vector1:
  pushl $0
80106032:	6a 00                	push   $0x0
  pushl $1
80106034:	6a 01                	push   $0x1
  jmp alltraps
80106036:	e9 19 fa ff ff       	jmp    80105a54 <alltraps>

8010603b <vector2>:
.globl vector2
vector2:
  pushl $0
8010603b:	6a 00                	push   $0x0
  pushl $2
8010603d:	6a 02                	push   $0x2
  jmp alltraps
8010603f:	e9 10 fa ff ff       	jmp    80105a54 <alltraps>

80106044 <vector3>:
.globl vector3
vector3:
  pushl $0
80106044:	6a 00                	push   $0x0
  pushl $3
80106046:	6a 03                	push   $0x3
  jmp alltraps
80106048:	e9 07 fa ff ff       	jmp    80105a54 <alltraps>

8010604d <vector4>:
.globl vector4
vector4:
  pushl $0
8010604d:	6a 00                	push   $0x0
  pushl $4
8010604f:	6a 04                	push   $0x4
  jmp alltraps
80106051:	e9 fe f9 ff ff       	jmp    80105a54 <alltraps>

80106056 <vector5>:
.globl vector5
vector5:
  pushl $0
80106056:	6a 00                	push   $0x0
  pushl $5
80106058:	6a 05                	push   $0x5
  jmp alltraps
8010605a:	e9 f5 f9 ff ff       	jmp    80105a54 <alltraps>

8010605f <vector6>:
.globl vector6
vector6:
  pushl $0
8010605f:	6a 00                	push   $0x0
  pushl $6
80106061:	6a 06                	push   $0x6
  jmp alltraps
80106063:	e9 ec f9 ff ff       	jmp    80105a54 <alltraps>

80106068 <vector7>:
.globl vector7
vector7:
  pushl $0
80106068:	6a 00                	push   $0x0
  pushl $7
8010606a:	6a 07                	push   $0x7
  jmp alltraps
8010606c:	e9 e3 f9 ff ff       	jmp    80105a54 <alltraps>

80106071 <vector8>:
.globl vector8
vector8:
  pushl $8
80106071:	6a 08                	push   $0x8
  jmp alltraps
80106073:	e9 dc f9 ff ff       	jmp    80105a54 <alltraps>

80106078 <vector9>:
.globl vector9
vector9:
  pushl $0
80106078:	6a 00                	push   $0x0
  pushl $9
8010607a:	6a 09                	push   $0x9
  jmp alltraps
8010607c:	e9 d3 f9 ff ff       	jmp    80105a54 <alltraps>

80106081 <vector10>:
.globl vector10
vector10:
  pushl $10
80106081:	6a 0a                	push   $0xa
  jmp alltraps
80106083:	e9 cc f9 ff ff       	jmp    80105a54 <alltraps>

80106088 <vector11>:
.globl vector11
vector11:
  pushl $11
80106088:	6a 0b                	push   $0xb
  jmp alltraps
8010608a:	e9 c5 f9 ff ff       	jmp    80105a54 <alltraps>

8010608f <vector12>:
.globl vector12
vector12:
  pushl $12
8010608f:	6a 0c                	push   $0xc
  jmp alltraps
80106091:	e9 be f9 ff ff       	jmp    80105a54 <alltraps>

80106096 <vector13>:
.globl vector13
vector13:
  pushl $13
80106096:	6a 0d                	push   $0xd
  jmp alltraps
80106098:	e9 b7 f9 ff ff       	jmp    80105a54 <alltraps>

8010609d <vector14>:
.globl vector14
vector14:
  pushl $14
8010609d:	6a 0e                	push   $0xe
  jmp alltraps
8010609f:	e9 b0 f9 ff ff       	jmp    80105a54 <alltraps>

801060a4 <vector15>:
.globl vector15
vector15:
  pushl $0
801060a4:	6a 00                	push   $0x0
  pushl $15
801060a6:	6a 0f                	push   $0xf
  jmp alltraps
801060a8:	e9 a7 f9 ff ff       	jmp    80105a54 <alltraps>

801060ad <vector16>:
.globl vector16
vector16:
  pushl $0
801060ad:	6a 00                	push   $0x0
  pushl $16
801060af:	6a 10                	push   $0x10
  jmp alltraps
801060b1:	e9 9e f9 ff ff       	jmp    80105a54 <alltraps>

801060b6 <vector17>:
.globl vector17
vector17:
  pushl $17
801060b6:	6a 11                	push   $0x11
  jmp alltraps
801060b8:	e9 97 f9 ff ff       	jmp    80105a54 <alltraps>

801060bd <vector18>:
.globl vector18
vector18:
  pushl $0
801060bd:	6a 00                	push   $0x0
  pushl $18
801060bf:	6a 12                	push   $0x12
  jmp alltraps
801060c1:	e9 8e f9 ff ff       	jmp    80105a54 <alltraps>

801060c6 <vector19>:
.globl vector19
vector19:
  pushl $0
801060c6:	6a 00                	push   $0x0
  pushl $19
801060c8:	6a 13                	push   $0x13
  jmp alltraps
801060ca:	e9 85 f9 ff ff       	jmp    80105a54 <alltraps>

801060cf <vector20>:
.globl vector20
vector20:
  pushl $0
801060cf:	6a 00                	push   $0x0
  pushl $20
801060d1:	6a 14                	push   $0x14
  jmp alltraps
801060d3:	e9 7c f9 ff ff       	jmp    80105a54 <alltraps>

801060d8 <vector21>:
.globl vector21
vector21:
  pushl $0
801060d8:	6a 00                	push   $0x0
  pushl $21
801060da:	6a 15                	push   $0x15
  jmp alltraps
801060dc:	e9 73 f9 ff ff       	jmp    80105a54 <alltraps>

801060e1 <vector22>:
.globl vector22
vector22:
  pushl $0
801060e1:	6a 00                	push   $0x0
  pushl $22
801060e3:	6a 16                	push   $0x16
  jmp alltraps
801060e5:	e9 6a f9 ff ff       	jmp    80105a54 <alltraps>

801060ea <vector23>:
.globl vector23
vector23:
  pushl $0
801060ea:	6a 00                	push   $0x0
  pushl $23
801060ec:	6a 17                	push   $0x17
  jmp alltraps
801060ee:	e9 61 f9 ff ff       	jmp    80105a54 <alltraps>

801060f3 <vector24>:
.globl vector24
vector24:
  pushl $0
801060f3:	6a 00                	push   $0x0
  pushl $24
801060f5:	6a 18                	push   $0x18
  jmp alltraps
801060f7:	e9 58 f9 ff ff       	jmp    80105a54 <alltraps>

801060fc <vector25>:
.globl vector25
vector25:
  pushl $0
801060fc:	6a 00                	push   $0x0
  pushl $25
801060fe:	6a 19                	push   $0x19
  jmp alltraps
80106100:	e9 4f f9 ff ff       	jmp    80105a54 <alltraps>

80106105 <vector26>:
.globl vector26
vector26:
  pushl $0
80106105:	6a 00                	push   $0x0
  pushl $26
80106107:	6a 1a                	push   $0x1a
  jmp alltraps
80106109:	e9 46 f9 ff ff       	jmp    80105a54 <alltraps>

8010610e <vector27>:
.globl vector27
vector27:
  pushl $0
8010610e:	6a 00                	push   $0x0
  pushl $27
80106110:	6a 1b                	push   $0x1b
  jmp alltraps
80106112:	e9 3d f9 ff ff       	jmp    80105a54 <alltraps>

80106117 <vector28>:
.globl vector28
vector28:
  pushl $0
80106117:	6a 00                	push   $0x0
  pushl $28
80106119:	6a 1c                	push   $0x1c
  jmp alltraps
8010611b:	e9 34 f9 ff ff       	jmp    80105a54 <alltraps>

80106120 <vector29>:
.globl vector29
vector29:
  pushl $0
80106120:	6a 00                	push   $0x0
  pushl $29
80106122:	6a 1d                	push   $0x1d
  jmp alltraps
80106124:	e9 2b f9 ff ff       	jmp    80105a54 <alltraps>

80106129 <vector30>:
.globl vector30
vector30:
  pushl $0
80106129:	6a 00                	push   $0x0
  pushl $30
8010612b:	6a 1e                	push   $0x1e
  jmp alltraps
8010612d:	e9 22 f9 ff ff       	jmp    80105a54 <alltraps>

80106132 <vector31>:
.globl vector31
vector31:
  pushl $0
80106132:	6a 00                	push   $0x0
  pushl $31
80106134:	6a 1f                	push   $0x1f
  jmp alltraps
80106136:	e9 19 f9 ff ff       	jmp    80105a54 <alltraps>

8010613b <vector32>:
.globl vector32
vector32:
  pushl $0
8010613b:	6a 00                	push   $0x0
  pushl $32
8010613d:	6a 20                	push   $0x20
  jmp alltraps
8010613f:	e9 10 f9 ff ff       	jmp    80105a54 <alltraps>

80106144 <vector33>:
.globl vector33
vector33:
  pushl $0
80106144:	6a 00                	push   $0x0
  pushl $33
80106146:	6a 21                	push   $0x21
  jmp alltraps
80106148:	e9 07 f9 ff ff       	jmp    80105a54 <alltraps>

8010614d <vector34>:
.globl vector34
vector34:
  pushl $0
8010614d:	6a 00                	push   $0x0
  pushl $34
8010614f:	6a 22                	push   $0x22
  jmp alltraps
80106151:	e9 fe f8 ff ff       	jmp    80105a54 <alltraps>

80106156 <vector35>:
.globl vector35
vector35:
  pushl $0
80106156:	6a 00                	push   $0x0
  pushl $35
80106158:	6a 23                	push   $0x23
  jmp alltraps
8010615a:	e9 f5 f8 ff ff       	jmp    80105a54 <alltraps>

8010615f <vector36>:
.globl vector36
vector36:
  pushl $0
8010615f:	6a 00                	push   $0x0
  pushl $36
80106161:	6a 24                	push   $0x24
  jmp alltraps
80106163:	e9 ec f8 ff ff       	jmp    80105a54 <alltraps>

80106168 <vector37>:
.globl vector37
vector37:
  pushl $0
80106168:	6a 00                	push   $0x0
  pushl $37
8010616a:	6a 25                	push   $0x25
  jmp alltraps
8010616c:	e9 e3 f8 ff ff       	jmp    80105a54 <alltraps>

80106171 <vector38>:
.globl vector38
vector38:
  pushl $0
80106171:	6a 00                	push   $0x0
  pushl $38
80106173:	6a 26                	push   $0x26
  jmp alltraps
80106175:	e9 da f8 ff ff       	jmp    80105a54 <alltraps>

8010617a <vector39>:
.globl vector39
vector39:
  pushl $0
8010617a:	6a 00                	push   $0x0
  pushl $39
8010617c:	6a 27                	push   $0x27
  jmp alltraps
8010617e:	e9 d1 f8 ff ff       	jmp    80105a54 <alltraps>

80106183 <vector40>:
.globl vector40
vector40:
  pushl $0
80106183:	6a 00                	push   $0x0
  pushl $40
80106185:	6a 28                	push   $0x28
  jmp alltraps
80106187:	e9 c8 f8 ff ff       	jmp    80105a54 <alltraps>

8010618c <vector41>:
.globl vector41
vector41:
  pushl $0
8010618c:	6a 00                	push   $0x0
  pushl $41
8010618e:	6a 29                	push   $0x29
  jmp alltraps
80106190:	e9 bf f8 ff ff       	jmp    80105a54 <alltraps>

80106195 <vector42>:
.globl vector42
vector42:
  pushl $0
80106195:	6a 00                	push   $0x0
  pushl $42
80106197:	6a 2a                	push   $0x2a
  jmp alltraps
80106199:	e9 b6 f8 ff ff       	jmp    80105a54 <alltraps>

8010619e <vector43>:
.globl vector43
vector43:
  pushl $0
8010619e:	6a 00                	push   $0x0
  pushl $43
801061a0:	6a 2b                	push   $0x2b
  jmp alltraps
801061a2:	e9 ad f8 ff ff       	jmp    80105a54 <alltraps>

801061a7 <vector44>:
.globl vector44
vector44:
  pushl $0
801061a7:	6a 00                	push   $0x0
  pushl $44
801061a9:	6a 2c                	push   $0x2c
  jmp alltraps
801061ab:	e9 a4 f8 ff ff       	jmp    80105a54 <alltraps>

801061b0 <vector45>:
.globl vector45
vector45:
  pushl $0
801061b0:	6a 00                	push   $0x0
  pushl $45
801061b2:	6a 2d                	push   $0x2d
  jmp alltraps
801061b4:	e9 9b f8 ff ff       	jmp    80105a54 <alltraps>

801061b9 <vector46>:
.globl vector46
vector46:
  pushl $0
801061b9:	6a 00                	push   $0x0
  pushl $46
801061bb:	6a 2e                	push   $0x2e
  jmp alltraps
801061bd:	e9 92 f8 ff ff       	jmp    80105a54 <alltraps>

801061c2 <vector47>:
.globl vector47
vector47:
  pushl $0
801061c2:	6a 00                	push   $0x0
  pushl $47
801061c4:	6a 2f                	push   $0x2f
  jmp alltraps
801061c6:	e9 89 f8 ff ff       	jmp    80105a54 <alltraps>

801061cb <vector48>:
.globl vector48
vector48:
  pushl $0
801061cb:	6a 00                	push   $0x0
  pushl $48
801061cd:	6a 30                	push   $0x30
  jmp alltraps
801061cf:	e9 80 f8 ff ff       	jmp    80105a54 <alltraps>

801061d4 <vector49>:
.globl vector49
vector49:
  pushl $0
801061d4:	6a 00                	push   $0x0
  pushl $49
801061d6:	6a 31                	push   $0x31
  jmp alltraps
801061d8:	e9 77 f8 ff ff       	jmp    80105a54 <alltraps>

801061dd <vector50>:
.globl vector50
vector50:
  pushl $0
801061dd:	6a 00                	push   $0x0
  pushl $50
801061df:	6a 32                	push   $0x32
  jmp alltraps
801061e1:	e9 6e f8 ff ff       	jmp    80105a54 <alltraps>

801061e6 <vector51>:
.globl vector51
vector51:
  pushl $0
801061e6:	6a 00                	push   $0x0
  pushl $51
801061e8:	6a 33                	push   $0x33
  jmp alltraps
801061ea:	e9 65 f8 ff ff       	jmp    80105a54 <alltraps>

801061ef <vector52>:
.globl vector52
vector52:
  pushl $0
801061ef:	6a 00                	push   $0x0
  pushl $52
801061f1:	6a 34                	push   $0x34
  jmp alltraps
801061f3:	e9 5c f8 ff ff       	jmp    80105a54 <alltraps>

801061f8 <vector53>:
.globl vector53
vector53:
  pushl $0
801061f8:	6a 00                	push   $0x0
  pushl $53
801061fa:	6a 35                	push   $0x35
  jmp alltraps
801061fc:	e9 53 f8 ff ff       	jmp    80105a54 <alltraps>

80106201 <vector54>:
.globl vector54
vector54:
  pushl $0
80106201:	6a 00                	push   $0x0
  pushl $54
80106203:	6a 36                	push   $0x36
  jmp alltraps
80106205:	e9 4a f8 ff ff       	jmp    80105a54 <alltraps>

8010620a <vector55>:
.globl vector55
vector55:
  pushl $0
8010620a:	6a 00                	push   $0x0
  pushl $55
8010620c:	6a 37                	push   $0x37
  jmp alltraps
8010620e:	e9 41 f8 ff ff       	jmp    80105a54 <alltraps>

80106213 <vector56>:
.globl vector56
vector56:
  pushl $0
80106213:	6a 00                	push   $0x0
  pushl $56
80106215:	6a 38                	push   $0x38
  jmp alltraps
80106217:	e9 38 f8 ff ff       	jmp    80105a54 <alltraps>

8010621c <vector57>:
.globl vector57
vector57:
  pushl $0
8010621c:	6a 00                	push   $0x0
  pushl $57
8010621e:	6a 39                	push   $0x39
  jmp alltraps
80106220:	e9 2f f8 ff ff       	jmp    80105a54 <alltraps>

80106225 <vector58>:
.globl vector58
vector58:
  pushl $0
80106225:	6a 00                	push   $0x0
  pushl $58
80106227:	6a 3a                	push   $0x3a
  jmp alltraps
80106229:	e9 26 f8 ff ff       	jmp    80105a54 <alltraps>

8010622e <vector59>:
.globl vector59
vector59:
  pushl $0
8010622e:	6a 00                	push   $0x0
  pushl $59
80106230:	6a 3b                	push   $0x3b
  jmp alltraps
80106232:	e9 1d f8 ff ff       	jmp    80105a54 <alltraps>

80106237 <vector60>:
.globl vector60
vector60:
  pushl $0
80106237:	6a 00                	push   $0x0
  pushl $60
80106239:	6a 3c                	push   $0x3c
  jmp alltraps
8010623b:	e9 14 f8 ff ff       	jmp    80105a54 <alltraps>

80106240 <vector61>:
.globl vector61
vector61:
  pushl $0
80106240:	6a 00                	push   $0x0
  pushl $61
80106242:	6a 3d                	push   $0x3d
  jmp alltraps
80106244:	e9 0b f8 ff ff       	jmp    80105a54 <alltraps>

80106249 <vector62>:
.globl vector62
vector62:
  pushl $0
80106249:	6a 00                	push   $0x0
  pushl $62
8010624b:	6a 3e                	push   $0x3e
  jmp alltraps
8010624d:	e9 02 f8 ff ff       	jmp    80105a54 <alltraps>

80106252 <vector63>:
.globl vector63
vector63:
  pushl $0
80106252:	6a 00                	push   $0x0
  pushl $63
80106254:	6a 3f                	push   $0x3f
  jmp alltraps
80106256:	e9 f9 f7 ff ff       	jmp    80105a54 <alltraps>

8010625b <vector64>:
.globl vector64
vector64:
  pushl $0
8010625b:	6a 00                	push   $0x0
  pushl $64
8010625d:	6a 40                	push   $0x40
  jmp alltraps
8010625f:	e9 f0 f7 ff ff       	jmp    80105a54 <alltraps>

80106264 <vector65>:
.globl vector65
vector65:
  pushl $0
80106264:	6a 00                	push   $0x0
  pushl $65
80106266:	6a 41                	push   $0x41
  jmp alltraps
80106268:	e9 e7 f7 ff ff       	jmp    80105a54 <alltraps>

8010626d <vector66>:
.globl vector66
vector66:
  pushl $0
8010626d:	6a 00                	push   $0x0
  pushl $66
8010626f:	6a 42                	push   $0x42
  jmp alltraps
80106271:	e9 de f7 ff ff       	jmp    80105a54 <alltraps>

80106276 <vector67>:
.globl vector67
vector67:
  pushl $0
80106276:	6a 00                	push   $0x0
  pushl $67
80106278:	6a 43                	push   $0x43
  jmp alltraps
8010627a:	e9 d5 f7 ff ff       	jmp    80105a54 <alltraps>

8010627f <vector68>:
.globl vector68
vector68:
  pushl $0
8010627f:	6a 00                	push   $0x0
  pushl $68
80106281:	6a 44                	push   $0x44
  jmp alltraps
80106283:	e9 cc f7 ff ff       	jmp    80105a54 <alltraps>

80106288 <vector69>:
.globl vector69
vector69:
  pushl $0
80106288:	6a 00                	push   $0x0
  pushl $69
8010628a:	6a 45                	push   $0x45
  jmp alltraps
8010628c:	e9 c3 f7 ff ff       	jmp    80105a54 <alltraps>

80106291 <vector70>:
.globl vector70
vector70:
  pushl $0
80106291:	6a 00                	push   $0x0
  pushl $70
80106293:	6a 46                	push   $0x46
  jmp alltraps
80106295:	e9 ba f7 ff ff       	jmp    80105a54 <alltraps>

8010629a <vector71>:
.globl vector71
vector71:
  pushl $0
8010629a:	6a 00                	push   $0x0
  pushl $71
8010629c:	6a 47                	push   $0x47
  jmp alltraps
8010629e:	e9 b1 f7 ff ff       	jmp    80105a54 <alltraps>

801062a3 <vector72>:
.globl vector72
vector72:
  pushl $0
801062a3:	6a 00                	push   $0x0
  pushl $72
801062a5:	6a 48                	push   $0x48
  jmp alltraps
801062a7:	e9 a8 f7 ff ff       	jmp    80105a54 <alltraps>

801062ac <vector73>:
.globl vector73
vector73:
  pushl $0
801062ac:	6a 00                	push   $0x0
  pushl $73
801062ae:	6a 49                	push   $0x49
  jmp alltraps
801062b0:	e9 9f f7 ff ff       	jmp    80105a54 <alltraps>

801062b5 <vector74>:
.globl vector74
vector74:
  pushl $0
801062b5:	6a 00                	push   $0x0
  pushl $74
801062b7:	6a 4a                	push   $0x4a
  jmp alltraps
801062b9:	e9 96 f7 ff ff       	jmp    80105a54 <alltraps>

801062be <vector75>:
.globl vector75
vector75:
  pushl $0
801062be:	6a 00                	push   $0x0
  pushl $75
801062c0:	6a 4b                	push   $0x4b
  jmp alltraps
801062c2:	e9 8d f7 ff ff       	jmp    80105a54 <alltraps>

801062c7 <vector76>:
.globl vector76
vector76:
  pushl $0
801062c7:	6a 00                	push   $0x0
  pushl $76
801062c9:	6a 4c                	push   $0x4c
  jmp alltraps
801062cb:	e9 84 f7 ff ff       	jmp    80105a54 <alltraps>

801062d0 <vector77>:
.globl vector77
vector77:
  pushl $0
801062d0:	6a 00                	push   $0x0
  pushl $77
801062d2:	6a 4d                	push   $0x4d
  jmp alltraps
801062d4:	e9 7b f7 ff ff       	jmp    80105a54 <alltraps>

801062d9 <vector78>:
.globl vector78
vector78:
  pushl $0
801062d9:	6a 00                	push   $0x0
  pushl $78
801062db:	6a 4e                	push   $0x4e
  jmp alltraps
801062dd:	e9 72 f7 ff ff       	jmp    80105a54 <alltraps>

801062e2 <vector79>:
.globl vector79
vector79:
  pushl $0
801062e2:	6a 00                	push   $0x0
  pushl $79
801062e4:	6a 4f                	push   $0x4f
  jmp alltraps
801062e6:	e9 69 f7 ff ff       	jmp    80105a54 <alltraps>

801062eb <vector80>:
.globl vector80
vector80:
  pushl $0
801062eb:	6a 00                	push   $0x0
  pushl $80
801062ed:	6a 50                	push   $0x50
  jmp alltraps
801062ef:	e9 60 f7 ff ff       	jmp    80105a54 <alltraps>

801062f4 <vector81>:
.globl vector81
vector81:
  pushl $0
801062f4:	6a 00                	push   $0x0
  pushl $81
801062f6:	6a 51                	push   $0x51
  jmp alltraps
801062f8:	e9 57 f7 ff ff       	jmp    80105a54 <alltraps>

801062fd <vector82>:
.globl vector82
vector82:
  pushl $0
801062fd:	6a 00                	push   $0x0
  pushl $82
801062ff:	6a 52                	push   $0x52
  jmp alltraps
80106301:	e9 4e f7 ff ff       	jmp    80105a54 <alltraps>

80106306 <vector83>:
.globl vector83
vector83:
  pushl $0
80106306:	6a 00                	push   $0x0
  pushl $83
80106308:	6a 53                	push   $0x53
  jmp alltraps
8010630a:	e9 45 f7 ff ff       	jmp    80105a54 <alltraps>

8010630f <vector84>:
.globl vector84
vector84:
  pushl $0
8010630f:	6a 00                	push   $0x0
  pushl $84
80106311:	6a 54                	push   $0x54
  jmp alltraps
80106313:	e9 3c f7 ff ff       	jmp    80105a54 <alltraps>

80106318 <vector85>:
.globl vector85
vector85:
  pushl $0
80106318:	6a 00                	push   $0x0
  pushl $85
8010631a:	6a 55                	push   $0x55
  jmp alltraps
8010631c:	e9 33 f7 ff ff       	jmp    80105a54 <alltraps>

80106321 <vector86>:
.globl vector86
vector86:
  pushl $0
80106321:	6a 00                	push   $0x0
  pushl $86
80106323:	6a 56                	push   $0x56
  jmp alltraps
80106325:	e9 2a f7 ff ff       	jmp    80105a54 <alltraps>

8010632a <vector87>:
.globl vector87
vector87:
  pushl $0
8010632a:	6a 00                	push   $0x0
  pushl $87
8010632c:	6a 57                	push   $0x57
  jmp alltraps
8010632e:	e9 21 f7 ff ff       	jmp    80105a54 <alltraps>

80106333 <vector88>:
.globl vector88
vector88:
  pushl $0
80106333:	6a 00                	push   $0x0
  pushl $88
80106335:	6a 58                	push   $0x58
  jmp alltraps
80106337:	e9 18 f7 ff ff       	jmp    80105a54 <alltraps>

8010633c <vector89>:
.globl vector89
vector89:
  pushl $0
8010633c:	6a 00                	push   $0x0
  pushl $89
8010633e:	6a 59                	push   $0x59
  jmp alltraps
80106340:	e9 0f f7 ff ff       	jmp    80105a54 <alltraps>

80106345 <vector90>:
.globl vector90
vector90:
  pushl $0
80106345:	6a 00                	push   $0x0
  pushl $90
80106347:	6a 5a                	push   $0x5a
  jmp alltraps
80106349:	e9 06 f7 ff ff       	jmp    80105a54 <alltraps>

8010634e <vector91>:
.globl vector91
vector91:
  pushl $0
8010634e:	6a 00                	push   $0x0
  pushl $91
80106350:	6a 5b                	push   $0x5b
  jmp alltraps
80106352:	e9 fd f6 ff ff       	jmp    80105a54 <alltraps>

80106357 <vector92>:
.globl vector92
vector92:
  pushl $0
80106357:	6a 00                	push   $0x0
  pushl $92
80106359:	6a 5c                	push   $0x5c
  jmp alltraps
8010635b:	e9 f4 f6 ff ff       	jmp    80105a54 <alltraps>

80106360 <vector93>:
.globl vector93
vector93:
  pushl $0
80106360:	6a 00                	push   $0x0
  pushl $93
80106362:	6a 5d                	push   $0x5d
  jmp alltraps
80106364:	e9 eb f6 ff ff       	jmp    80105a54 <alltraps>

80106369 <vector94>:
.globl vector94
vector94:
  pushl $0
80106369:	6a 00                	push   $0x0
  pushl $94
8010636b:	6a 5e                	push   $0x5e
  jmp alltraps
8010636d:	e9 e2 f6 ff ff       	jmp    80105a54 <alltraps>

80106372 <vector95>:
.globl vector95
vector95:
  pushl $0
80106372:	6a 00                	push   $0x0
  pushl $95
80106374:	6a 5f                	push   $0x5f
  jmp alltraps
80106376:	e9 d9 f6 ff ff       	jmp    80105a54 <alltraps>

8010637b <vector96>:
.globl vector96
vector96:
  pushl $0
8010637b:	6a 00                	push   $0x0
  pushl $96
8010637d:	6a 60                	push   $0x60
  jmp alltraps
8010637f:	e9 d0 f6 ff ff       	jmp    80105a54 <alltraps>

80106384 <vector97>:
.globl vector97
vector97:
  pushl $0
80106384:	6a 00                	push   $0x0
  pushl $97
80106386:	6a 61                	push   $0x61
  jmp alltraps
80106388:	e9 c7 f6 ff ff       	jmp    80105a54 <alltraps>

8010638d <vector98>:
.globl vector98
vector98:
  pushl $0
8010638d:	6a 00                	push   $0x0
  pushl $98
8010638f:	6a 62                	push   $0x62
  jmp alltraps
80106391:	e9 be f6 ff ff       	jmp    80105a54 <alltraps>

80106396 <vector99>:
.globl vector99
vector99:
  pushl $0
80106396:	6a 00                	push   $0x0
  pushl $99
80106398:	6a 63                	push   $0x63
  jmp alltraps
8010639a:	e9 b5 f6 ff ff       	jmp    80105a54 <alltraps>

8010639f <vector100>:
.globl vector100
vector100:
  pushl $0
8010639f:	6a 00                	push   $0x0
  pushl $100
801063a1:	6a 64                	push   $0x64
  jmp alltraps
801063a3:	e9 ac f6 ff ff       	jmp    80105a54 <alltraps>

801063a8 <vector101>:
.globl vector101
vector101:
  pushl $0
801063a8:	6a 00                	push   $0x0
  pushl $101
801063aa:	6a 65                	push   $0x65
  jmp alltraps
801063ac:	e9 a3 f6 ff ff       	jmp    80105a54 <alltraps>

801063b1 <vector102>:
.globl vector102
vector102:
  pushl $0
801063b1:	6a 00                	push   $0x0
  pushl $102
801063b3:	6a 66                	push   $0x66
  jmp alltraps
801063b5:	e9 9a f6 ff ff       	jmp    80105a54 <alltraps>

801063ba <vector103>:
.globl vector103
vector103:
  pushl $0
801063ba:	6a 00                	push   $0x0
  pushl $103
801063bc:	6a 67                	push   $0x67
  jmp alltraps
801063be:	e9 91 f6 ff ff       	jmp    80105a54 <alltraps>

801063c3 <vector104>:
.globl vector104
vector104:
  pushl $0
801063c3:	6a 00                	push   $0x0
  pushl $104
801063c5:	6a 68                	push   $0x68
  jmp alltraps
801063c7:	e9 88 f6 ff ff       	jmp    80105a54 <alltraps>

801063cc <vector105>:
.globl vector105
vector105:
  pushl $0
801063cc:	6a 00                	push   $0x0
  pushl $105
801063ce:	6a 69                	push   $0x69
  jmp alltraps
801063d0:	e9 7f f6 ff ff       	jmp    80105a54 <alltraps>

801063d5 <vector106>:
.globl vector106
vector106:
  pushl $0
801063d5:	6a 00                	push   $0x0
  pushl $106
801063d7:	6a 6a                	push   $0x6a
  jmp alltraps
801063d9:	e9 76 f6 ff ff       	jmp    80105a54 <alltraps>

801063de <vector107>:
.globl vector107
vector107:
  pushl $0
801063de:	6a 00                	push   $0x0
  pushl $107
801063e0:	6a 6b                	push   $0x6b
  jmp alltraps
801063e2:	e9 6d f6 ff ff       	jmp    80105a54 <alltraps>

801063e7 <vector108>:
.globl vector108
vector108:
  pushl $0
801063e7:	6a 00                	push   $0x0
  pushl $108
801063e9:	6a 6c                	push   $0x6c
  jmp alltraps
801063eb:	e9 64 f6 ff ff       	jmp    80105a54 <alltraps>

801063f0 <vector109>:
.globl vector109
vector109:
  pushl $0
801063f0:	6a 00                	push   $0x0
  pushl $109
801063f2:	6a 6d                	push   $0x6d
  jmp alltraps
801063f4:	e9 5b f6 ff ff       	jmp    80105a54 <alltraps>

801063f9 <vector110>:
.globl vector110
vector110:
  pushl $0
801063f9:	6a 00                	push   $0x0
  pushl $110
801063fb:	6a 6e                	push   $0x6e
  jmp alltraps
801063fd:	e9 52 f6 ff ff       	jmp    80105a54 <alltraps>

80106402 <vector111>:
.globl vector111
vector111:
  pushl $0
80106402:	6a 00                	push   $0x0
  pushl $111
80106404:	6a 6f                	push   $0x6f
  jmp alltraps
80106406:	e9 49 f6 ff ff       	jmp    80105a54 <alltraps>

8010640b <vector112>:
.globl vector112
vector112:
  pushl $0
8010640b:	6a 00                	push   $0x0
  pushl $112
8010640d:	6a 70                	push   $0x70
  jmp alltraps
8010640f:	e9 40 f6 ff ff       	jmp    80105a54 <alltraps>

80106414 <vector113>:
.globl vector113
vector113:
  pushl $0
80106414:	6a 00                	push   $0x0
  pushl $113
80106416:	6a 71                	push   $0x71
  jmp alltraps
80106418:	e9 37 f6 ff ff       	jmp    80105a54 <alltraps>

8010641d <vector114>:
.globl vector114
vector114:
  pushl $0
8010641d:	6a 00                	push   $0x0
  pushl $114
8010641f:	6a 72                	push   $0x72
  jmp alltraps
80106421:	e9 2e f6 ff ff       	jmp    80105a54 <alltraps>

80106426 <vector115>:
.globl vector115
vector115:
  pushl $0
80106426:	6a 00                	push   $0x0
  pushl $115
80106428:	6a 73                	push   $0x73
  jmp alltraps
8010642a:	e9 25 f6 ff ff       	jmp    80105a54 <alltraps>

8010642f <vector116>:
.globl vector116
vector116:
  pushl $0
8010642f:	6a 00                	push   $0x0
  pushl $116
80106431:	6a 74                	push   $0x74
  jmp alltraps
80106433:	e9 1c f6 ff ff       	jmp    80105a54 <alltraps>

80106438 <vector117>:
.globl vector117
vector117:
  pushl $0
80106438:	6a 00                	push   $0x0
  pushl $117
8010643a:	6a 75                	push   $0x75
  jmp alltraps
8010643c:	e9 13 f6 ff ff       	jmp    80105a54 <alltraps>

80106441 <vector118>:
.globl vector118
vector118:
  pushl $0
80106441:	6a 00                	push   $0x0
  pushl $118
80106443:	6a 76                	push   $0x76
  jmp alltraps
80106445:	e9 0a f6 ff ff       	jmp    80105a54 <alltraps>

8010644a <vector119>:
.globl vector119
vector119:
  pushl $0
8010644a:	6a 00                	push   $0x0
  pushl $119
8010644c:	6a 77                	push   $0x77
  jmp alltraps
8010644e:	e9 01 f6 ff ff       	jmp    80105a54 <alltraps>

80106453 <vector120>:
.globl vector120
vector120:
  pushl $0
80106453:	6a 00                	push   $0x0
  pushl $120
80106455:	6a 78                	push   $0x78
  jmp alltraps
80106457:	e9 f8 f5 ff ff       	jmp    80105a54 <alltraps>

8010645c <vector121>:
.globl vector121
vector121:
  pushl $0
8010645c:	6a 00                	push   $0x0
  pushl $121
8010645e:	6a 79                	push   $0x79
  jmp alltraps
80106460:	e9 ef f5 ff ff       	jmp    80105a54 <alltraps>

80106465 <vector122>:
.globl vector122
vector122:
  pushl $0
80106465:	6a 00                	push   $0x0
  pushl $122
80106467:	6a 7a                	push   $0x7a
  jmp alltraps
80106469:	e9 e6 f5 ff ff       	jmp    80105a54 <alltraps>

8010646e <vector123>:
.globl vector123
vector123:
  pushl $0
8010646e:	6a 00                	push   $0x0
  pushl $123
80106470:	6a 7b                	push   $0x7b
  jmp alltraps
80106472:	e9 dd f5 ff ff       	jmp    80105a54 <alltraps>

80106477 <vector124>:
.globl vector124
vector124:
  pushl $0
80106477:	6a 00                	push   $0x0
  pushl $124
80106479:	6a 7c                	push   $0x7c
  jmp alltraps
8010647b:	e9 d4 f5 ff ff       	jmp    80105a54 <alltraps>

80106480 <vector125>:
.globl vector125
vector125:
  pushl $0
80106480:	6a 00                	push   $0x0
  pushl $125
80106482:	6a 7d                	push   $0x7d
  jmp alltraps
80106484:	e9 cb f5 ff ff       	jmp    80105a54 <alltraps>

80106489 <vector126>:
.globl vector126
vector126:
  pushl $0
80106489:	6a 00                	push   $0x0
  pushl $126
8010648b:	6a 7e                	push   $0x7e
  jmp alltraps
8010648d:	e9 c2 f5 ff ff       	jmp    80105a54 <alltraps>

80106492 <vector127>:
.globl vector127
vector127:
  pushl $0
80106492:	6a 00                	push   $0x0
  pushl $127
80106494:	6a 7f                	push   $0x7f
  jmp alltraps
80106496:	e9 b9 f5 ff ff       	jmp    80105a54 <alltraps>

8010649b <vector128>:
.globl vector128
vector128:
  pushl $0
8010649b:	6a 00                	push   $0x0
  pushl $128
8010649d:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801064a2:	e9 ad f5 ff ff       	jmp    80105a54 <alltraps>

801064a7 <vector129>:
.globl vector129
vector129:
  pushl $0
801064a7:	6a 00                	push   $0x0
  pushl $129
801064a9:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801064ae:	e9 a1 f5 ff ff       	jmp    80105a54 <alltraps>

801064b3 <vector130>:
.globl vector130
vector130:
  pushl $0
801064b3:	6a 00                	push   $0x0
  pushl $130
801064b5:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801064ba:	e9 95 f5 ff ff       	jmp    80105a54 <alltraps>

801064bf <vector131>:
.globl vector131
vector131:
  pushl $0
801064bf:	6a 00                	push   $0x0
  pushl $131
801064c1:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801064c6:	e9 89 f5 ff ff       	jmp    80105a54 <alltraps>

801064cb <vector132>:
.globl vector132
vector132:
  pushl $0
801064cb:	6a 00                	push   $0x0
  pushl $132
801064cd:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801064d2:	e9 7d f5 ff ff       	jmp    80105a54 <alltraps>

801064d7 <vector133>:
.globl vector133
vector133:
  pushl $0
801064d7:	6a 00                	push   $0x0
  pushl $133
801064d9:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801064de:	e9 71 f5 ff ff       	jmp    80105a54 <alltraps>

801064e3 <vector134>:
.globl vector134
vector134:
  pushl $0
801064e3:	6a 00                	push   $0x0
  pushl $134
801064e5:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801064ea:	e9 65 f5 ff ff       	jmp    80105a54 <alltraps>

801064ef <vector135>:
.globl vector135
vector135:
  pushl $0
801064ef:	6a 00                	push   $0x0
  pushl $135
801064f1:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801064f6:	e9 59 f5 ff ff       	jmp    80105a54 <alltraps>

801064fb <vector136>:
.globl vector136
vector136:
  pushl $0
801064fb:	6a 00                	push   $0x0
  pushl $136
801064fd:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106502:	e9 4d f5 ff ff       	jmp    80105a54 <alltraps>

80106507 <vector137>:
.globl vector137
vector137:
  pushl $0
80106507:	6a 00                	push   $0x0
  pushl $137
80106509:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010650e:	e9 41 f5 ff ff       	jmp    80105a54 <alltraps>

80106513 <vector138>:
.globl vector138
vector138:
  pushl $0
80106513:	6a 00                	push   $0x0
  pushl $138
80106515:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
8010651a:	e9 35 f5 ff ff       	jmp    80105a54 <alltraps>

8010651f <vector139>:
.globl vector139
vector139:
  pushl $0
8010651f:	6a 00                	push   $0x0
  pushl $139
80106521:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106526:	e9 29 f5 ff ff       	jmp    80105a54 <alltraps>

8010652b <vector140>:
.globl vector140
vector140:
  pushl $0
8010652b:	6a 00                	push   $0x0
  pushl $140
8010652d:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106532:	e9 1d f5 ff ff       	jmp    80105a54 <alltraps>

80106537 <vector141>:
.globl vector141
vector141:
  pushl $0
80106537:	6a 00                	push   $0x0
  pushl $141
80106539:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010653e:	e9 11 f5 ff ff       	jmp    80105a54 <alltraps>

80106543 <vector142>:
.globl vector142
vector142:
  pushl $0
80106543:	6a 00                	push   $0x0
  pushl $142
80106545:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
8010654a:	e9 05 f5 ff ff       	jmp    80105a54 <alltraps>

8010654f <vector143>:
.globl vector143
vector143:
  pushl $0
8010654f:	6a 00                	push   $0x0
  pushl $143
80106551:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106556:	e9 f9 f4 ff ff       	jmp    80105a54 <alltraps>

8010655b <vector144>:
.globl vector144
vector144:
  pushl $0
8010655b:	6a 00                	push   $0x0
  pushl $144
8010655d:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106562:	e9 ed f4 ff ff       	jmp    80105a54 <alltraps>

80106567 <vector145>:
.globl vector145
vector145:
  pushl $0
80106567:	6a 00                	push   $0x0
  pushl $145
80106569:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010656e:	e9 e1 f4 ff ff       	jmp    80105a54 <alltraps>

80106573 <vector146>:
.globl vector146
vector146:
  pushl $0
80106573:	6a 00                	push   $0x0
  pushl $146
80106575:	68 92 00 00 00       	push   $0x92
  jmp alltraps
8010657a:	e9 d5 f4 ff ff       	jmp    80105a54 <alltraps>

8010657f <vector147>:
.globl vector147
vector147:
  pushl $0
8010657f:	6a 00                	push   $0x0
  pushl $147
80106581:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106586:	e9 c9 f4 ff ff       	jmp    80105a54 <alltraps>

8010658b <vector148>:
.globl vector148
vector148:
  pushl $0
8010658b:	6a 00                	push   $0x0
  pushl $148
8010658d:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106592:	e9 bd f4 ff ff       	jmp    80105a54 <alltraps>

80106597 <vector149>:
.globl vector149
vector149:
  pushl $0
80106597:	6a 00                	push   $0x0
  pushl $149
80106599:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010659e:	e9 b1 f4 ff ff       	jmp    80105a54 <alltraps>

801065a3 <vector150>:
.globl vector150
vector150:
  pushl $0
801065a3:	6a 00                	push   $0x0
  pushl $150
801065a5:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801065aa:	e9 a5 f4 ff ff       	jmp    80105a54 <alltraps>

801065af <vector151>:
.globl vector151
vector151:
  pushl $0
801065af:	6a 00                	push   $0x0
  pushl $151
801065b1:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801065b6:	e9 99 f4 ff ff       	jmp    80105a54 <alltraps>

801065bb <vector152>:
.globl vector152
vector152:
  pushl $0
801065bb:	6a 00                	push   $0x0
  pushl $152
801065bd:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801065c2:	e9 8d f4 ff ff       	jmp    80105a54 <alltraps>

801065c7 <vector153>:
.globl vector153
vector153:
  pushl $0
801065c7:	6a 00                	push   $0x0
  pushl $153
801065c9:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801065ce:	e9 81 f4 ff ff       	jmp    80105a54 <alltraps>

801065d3 <vector154>:
.globl vector154
vector154:
  pushl $0
801065d3:	6a 00                	push   $0x0
  pushl $154
801065d5:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801065da:	e9 75 f4 ff ff       	jmp    80105a54 <alltraps>

801065df <vector155>:
.globl vector155
vector155:
  pushl $0
801065df:	6a 00                	push   $0x0
  pushl $155
801065e1:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801065e6:	e9 69 f4 ff ff       	jmp    80105a54 <alltraps>

801065eb <vector156>:
.globl vector156
vector156:
  pushl $0
801065eb:	6a 00                	push   $0x0
  pushl $156
801065ed:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801065f2:	e9 5d f4 ff ff       	jmp    80105a54 <alltraps>

801065f7 <vector157>:
.globl vector157
vector157:
  pushl $0
801065f7:	6a 00                	push   $0x0
  pushl $157
801065f9:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801065fe:	e9 51 f4 ff ff       	jmp    80105a54 <alltraps>

80106603 <vector158>:
.globl vector158
vector158:
  pushl $0
80106603:	6a 00                	push   $0x0
  pushl $158
80106605:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
8010660a:	e9 45 f4 ff ff       	jmp    80105a54 <alltraps>

8010660f <vector159>:
.globl vector159
vector159:
  pushl $0
8010660f:	6a 00                	push   $0x0
  pushl $159
80106611:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106616:	e9 39 f4 ff ff       	jmp    80105a54 <alltraps>

8010661b <vector160>:
.globl vector160
vector160:
  pushl $0
8010661b:	6a 00                	push   $0x0
  pushl $160
8010661d:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106622:	e9 2d f4 ff ff       	jmp    80105a54 <alltraps>

80106627 <vector161>:
.globl vector161
vector161:
  pushl $0
80106627:	6a 00                	push   $0x0
  pushl $161
80106629:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010662e:	e9 21 f4 ff ff       	jmp    80105a54 <alltraps>

80106633 <vector162>:
.globl vector162
vector162:
  pushl $0
80106633:	6a 00                	push   $0x0
  pushl $162
80106635:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
8010663a:	e9 15 f4 ff ff       	jmp    80105a54 <alltraps>

8010663f <vector163>:
.globl vector163
vector163:
  pushl $0
8010663f:	6a 00                	push   $0x0
  pushl $163
80106641:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106646:	e9 09 f4 ff ff       	jmp    80105a54 <alltraps>

8010664b <vector164>:
.globl vector164
vector164:
  pushl $0
8010664b:	6a 00                	push   $0x0
  pushl $164
8010664d:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106652:	e9 fd f3 ff ff       	jmp    80105a54 <alltraps>

80106657 <vector165>:
.globl vector165
vector165:
  pushl $0
80106657:	6a 00                	push   $0x0
  pushl $165
80106659:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010665e:	e9 f1 f3 ff ff       	jmp    80105a54 <alltraps>

80106663 <vector166>:
.globl vector166
vector166:
  pushl $0
80106663:	6a 00                	push   $0x0
  pushl $166
80106665:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
8010666a:	e9 e5 f3 ff ff       	jmp    80105a54 <alltraps>

8010666f <vector167>:
.globl vector167
vector167:
  pushl $0
8010666f:	6a 00                	push   $0x0
  pushl $167
80106671:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106676:	e9 d9 f3 ff ff       	jmp    80105a54 <alltraps>

8010667b <vector168>:
.globl vector168
vector168:
  pushl $0
8010667b:	6a 00                	push   $0x0
  pushl $168
8010667d:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106682:	e9 cd f3 ff ff       	jmp    80105a54 <alltraps>

80106687 <vector169>:
.globl vector169
vector169:
  pushl $0
80106687:	6a 00                	push   $0x0
  pushl $169
80106689:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010668e:	e9 c1 f3 ff ff       	jmp    80105a54 <alltraps>

80106693 <vector170>:
.globl vector170
vector170:
  pushl $0
80106693:	6a 00                	push   $0x0
  pushl $170
80106695:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
8010669a:	e9 b5 f3 ff ff       	jmp    80105a54 <alltraps>

8010669f <vector171>:
.globl vector171
vector171:
  pushl $0
8010669f:	6a 00                	push   $0x0
  pushl $171
801066a1:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801066a6:	e9 a9 f3 ff ff       	jmp    80105a54 <alltraps>

801066ab <vector172>:
.globl vector172
vector172:
  pushl $0
801066ab:	6a 00                	push   $0x0
  pushl $172
801066ad:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801066b2:	e9 9d f3 ff ff       	jmp    80105a54 <alltraps>

801066b7 <vector173>:
.globl vector173
vector173:
  pushl $0
801066b7:	6a 00                	push   $0x0
  pushl $173
801066b9:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801066be:	e9 91 f3 ff ff       	jmp    80105a54 <alltraps>

801066c3 <vector174>:
.globl vector174
vector174:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $174
801066c5:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801066ca:	e9 85 f3 ff ff       	jmp    80105a54 <alltraps>

801066cf <vector175>:
.globl vector175
vector175:
  pushl $0
801066cf:	6a 00                	push   $0x0
  pushl $175
801066d1:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801066d6:	e9 79 f3 ff ff       	jmp    80105a54 <alltraps>

801066db <vector176>:
.globl vector176
vector176:
  pushl $0
801066db:	6a 00                	push   $0x0
  pushl $176
801066dd:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801066e2:	e9 6d f3 ff ff       	jmp    80105a54 <alltraps>

801066e7 <vector177>:
.globl vector177
vector177:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $177
801066e9:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801066ee:	e9 61 f3 ff ff       	jmp    80105a54 <alltraps>

801066f3 <vector178>:
.globl vector178
vector178:
  pushl $0
801066f3:	6a 00                	push   $0x0
  pushl $178
801066f5:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801066fa:	e9 55 f3 ff ff       	jmp    80105a54 <alltraps>

801066ff <vector179>:
.globl vector179
vector179:
  pushl $0
801066ff:	6a 00                	push   $0x0
  pushl $179
80106701:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106706:	e9 49 f3 ff ff       	jmp    80105a54 <alltraps>

8010670b <vector180>:
.globl vector180
vector180:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $180
8010670d:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106712:	e9 3d f3 ff ff       	jmp    80105a54 <alltraps>

80106717 <vector181>:
.globl vector181
vector181:
  pushl $0
80106717:	6a 00                	push   $0x0
  pushl $181
80106719:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010671e:	e9 31 f3 ff ff       	jmp    80105a54 <alltraps>

80106723 <vector182>:
.globl vector182
vector182:
  pushl $0
80106723:	6a 00                	push   $0x0
  pushl $182
80106725:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
8010672a:	e9 25 f3 ff ff       	jmp    80105a54 <alltraps>

8010672f <vector183>:
.globl vector183
vector183:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $183
80106731:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106736:	e9 19 f3 ff ff       	jmp    80105a54 <alltraps>

8010673b <vector184>:
.globl vector184
vector184:
  pushl $0
8010673b:	6a 00                	push   $0x0
  pushl $184
8010673d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106742:	e9 0d f3 ff ff       	jmp    80105a54 <alltraps>

80106747 <vector185>:
.globl vector185
vector185:
  pushl $0
80106747:	6a 00                	push   $0x0
  pushl $185
80106749:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010674e:	e9 01 f3 ff ff       	jmp    80105a54 <alltraps>

80106753 <vector186>:
.globl vector186
vector186:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $186
80106755:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
8010675a:	e9 f5 f2 ff ff       	jmp    80105a54 <alltraps>

8010675f <vector187>:
.globl vector187
vector187:
  pushl $0
8010675f:	6a 00                	push   $0x0
  pushl $187
80106761:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106766:	e9 e9 f2 ff ff       	jmp    80105a54 <alltraps>

8010676b <vector188>:
.globl vector188
vector188:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $188
8010676d:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106772:	e9 dd f2 ff ff       	jmp    80105a54 <alltraps>

80106777 <vector189>:
.globl vector189
vector189:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $189
80106779:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010677e:	e9 d1 f2 ff ff       	jmp    80105a54 <alltraps>

80106783 <vector190>:
.globl vector190
vector190:
  pushl $0
80106783:	6a 00                	push   $0x0
  pushl $190
80106785:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
8010678a:	e9 c5 f2 ff ff       	jmp    80105a54 <alltraps>

8010678f <vector191>:
.globl vector191
vector191:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $191
80106791:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106796:	e9 b9 f2 ff ff       	jmp    80105a54 <alltraps>

8010679b <vector192>:
.globl vector192
vector192:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $192
8010679d:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801067a2:	e9 ad f2 ff ff       	jmp    80105a54 <alltraps>

801067a7 <vector193>:
.globl vector193
vector193:
  pushl $0
801067a7:	6a 00                	push   $0x0
  pushl $193
801067a9:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801067ae:	e9 a1 f2 ff ff       	jmp    80105a54 <alltraps>

801067b3 <vector194>:
.globl vector194
vector194:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $194
801067b5:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801067ba:	e9 95 f2 ff ff       	jmp    80105a54 <alltraps>

801067bf <vector195>:
.globl vector195
vector195:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $195
801067c1:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801067c6:	e9 89 f2 ff ff       	jmp    80105a54 <alltraps>

801067cb <vector196>:
.globl vector196
vector196:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $196
801067cd:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801067d2:	e9 7d f2 ff ff       	jmp    80105a54 <alltraps>

801067d7 <vector197>:
.globl vector197
vector197:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $197
801067d9:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801067de:	e9 71 f2 ff ff       	jmp    80105a54 <alltraps>

801067e3 <vector198>:
.globl vector198
vector198:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $198
801067e5:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801067ea:	e9 65 f2 ff ff       	jmp    80105a54 <alltraps>

801067ef <vector199>:
.globl vector199
vector199:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $199
801067f1:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801067f6:	e9 59 f2 ff ff       	jmp    80105a54 <alltraps>

801067fb <vector200>:
.globl vector200
vector200:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $200
801067fd:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106802:	e9 4d f2 ff ff       	jmp    80105a54 <alltraps>

80106807 <vector201>:
.globl vector201
vector201:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $201
80106809:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010680e:	e9 41 f2 ff ff       	jmp    80105a54 <alltraps>

80106813 <vector202>:
.globl vector202
vector202:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $202
80106815:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
8010681a:	e9 35 f2 ff ff       	jmp    80105a54 <alltraps>

8010681f <vector203>:
.globl vector203
vector203:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $203
80106821:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106826:	e9 29 f2 ff ff       	jmp    80105a54 <alltraps>

8010682b <vector204>:
.globl vector204
vector204:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $204
8010682d:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106832:	e9 1d f2 ff ff       	jmp    80105a54 <alltraps>

80106837 <vector205>:
.globl vector205
vector205:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $205
80106839:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010683e:	e9 11 f2 ff ff       	jmp    80105a54 <alltraps>

80106843 <vector206>:
.globl vector206
vector206:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $206
80106845:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
8010684a:	e9 05 f2 ff ff       	jmp    80105a54 <alltraps>

8010684f <vector207>:
.globl vector207
vector207:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $207
80106851:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106856:	e9 f9 f1 ff ff       	jmp    80105a54 <alltraps>

8010685b <vector208>:
.globl vector208
vector208:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $208
8010685d:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106862:	e9 ed f1 ff ff       	jmp    80105a54 <alltraps>

80106867 <vector209>:
.globl vector209
vector209:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $209
80106869:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010686e:	e9 e1 f1 ff ff       	jmp    80105a54 <alltraps>

80106873 <vector210>:
.globl vector210
vector210:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $210
80106875:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
8010687a:	e9 d5 f1 ff ff       	jmp    80105a54 <alltraps>

8010687f <vector211>:
.globl vector211
vector211:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $211
80106881:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106886:	e9 c9 f1 ff ff       	jmp    80105a54 <alltraps>

8010688b <vector212>:
.globl vector212
vector212:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $212
8010688d:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106892:	e9 bd f1 ff ff       	jmp    80105a54 <alltraps>

80106897 <vector213>:
.globl vector213
vector213:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $213
80106899:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010689e:	e9 b1 f1 ff ff       	jmp    80105a54 <alltraps>

801068a3 <vector214>:
.globl vector214
vector214:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $214
801068a5:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801068aa:	e9 a5 f1 ff ff       	jmp    80105a54 <alltraps>

801068af <vector215>:
.globl vector215
vector215:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $215
801068b1:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801068b6:	e9 99 f1 ff ff       	jmp    80105a54 <alltraps>

801068bb <vector216>:
.globl vector216
vector216:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $216
801068bd:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801068c2:	e9 8d f1 ff ff       	jmp    80105a54 <alltraps>

801068c7 <vector217>:
.globl vector217
vector217:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $217
801068c9:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801068ce:	e9 81 f1 ff ff       	jmp    80105a54 <alltraps>

801068d3 <vector218>:
.globl vector218
vector218:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $218
801068d5:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801068da:	e9 75 f1 ff ff       	jmp    80105a54 <alltraps>

801068df <vector219>:
.globl vector219
vector219:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $219
801068e1:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801068e6:	e9 69 f1 ff ff       	jmp    80105a54 <alltraps>

801068eb <vector220>:
.globl vector220
vector220:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $220
801068ed:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801068f2:	e9 5d f1 ff ff       	jmp    80105a54 <alltraps>

801068f7 <vector221>:
.globl vector221
vector221:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $221
801068f9:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801068fe:	e9 51 f1 ff ff       	jmp    80105a54 <alltraps>

80106903 <vector222>:
.globl vector222
vector222:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $222
80106905:	68 de 00 00 00       	push   $0xde
  jmp alltraps
8010690a:	e9 45 f1 ff ff       	jmp    80105a54 <alltraps>

8010690f <vector223>:
.globl vector223
vector223:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $223
80106911:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106916:	e9 39 f1 ff ff       	jmp    80105a54 <alltraps>

8010691b <vector224>:
.globl vector224
vector224:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $224
8010691d:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106922:	e9 2d f1 ff ff       	jmp    80105a54 <alltraps>

80106927 <vector225>:
.globl vector225
vector225:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $225
80106929:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010692e:	e9 21 f1 ff ff       	jmp    80105a54 <alltraps>

80106933 <vector226>:
.globl vector226
vector226:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $226
80106935:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
8010693a:	e9 15 f1 ff ff       	jmp    80105a54 <alltraps>

8010693f <vector227>:
.globl vector227
vector227:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $227
80106941:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106946:	e9 09 f1 ff ff       	jmp    80105a54 <alltraps>

8010694b <vector228>:
.globl vector228
vector228:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $228
8010694d:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106952:	e9 fd f0 ff ff       	jmp    80105a54 <alltraps>

80106957 <vector229>:
.globl vector229
vector229:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $229
80106959:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010695e:	e9 f1 f0 ff ff       	jmp    80105a54 <alltraps>

80106963 <vector230>:
.globl vector230
vector230:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $230
80106965:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
8010696a:	e9 e5 f0 ff ff       	jmp    80105a54 <alltraps>

8010696f <vector231>:
.globl vector231
vector231:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $231
80106971:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106976:	e9 d9 f0 ff ff       	jmp    80105a54 <alltraps>

8010697b <vector232>:
.globl vector232
vector232:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $232
8010697d:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106982:	e9 cd f0 ff ff       	jmp    80105a54 <alltraps>

80106987 <vector233>:
.globl vector233
vector233:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $233
80106989:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010698e:	e9 c1 f0 ff ff       	jmp    80105a54 <alltraps>

80106993 <vector234>:
.globl vector234
vector234:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $234
80106995:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
8010699a:	e9 b5 f0 ff ff       	jmp    80105a54 <alltraps>

8010699f <vector235>:
.globl vector235
vector235:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $235
801069a1:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801069a6:	e9 a9 f0 ff ff       	jmp    80105a54 <alltraps>

801069ab <vector236>:
.globl vector236
vector236:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $236
801069ad:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801069b2:	e9 9d f0 ff ff       	jmp    80105a54 <alltraps>

801069b7 <vector237>:
.globl vector237
vector237:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $237
801069b9:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801069be:	e9 91 f0 ff ff       	jmp    80105a54 <alltraps>

801069c3 <vector238>:
.globl vector238
vector238:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $238
801069c5:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801069ca:	e9 85 f0 ff ff       	jmp    80105a54 <alltraps>

801069cf <vector239>:
.globl vector239
vector239:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $239
801069d1:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801069d6:	e9 79 f0 ff ff       	jmp    80105a54 <alltraps>

801069db <vector240>:
.globl vector240
vector240:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $240
801069dd:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801069e2:	e9 6d f0 ff ff       	jmp    80105a54 <alltraps>

801069e7 <vector241>:
.globl vector241
vector241:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $241
801069e9:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801069ee:	e9 61 f0 ff ff       	jmp    80105a54 <alltraps>

801069f3 <vector242>:
.globl vector242
vector242:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $242
801069f5:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801069fa:	e9 55 f0 ff ff       	jmp    80105a54 <alltraps>

801069ff <vector243>:
.globl vector243
vector243:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $243
80106a01:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106a06:	e9 49 f0 ff ff       	jmp    80105a54 <alltraps>

80106a0b <vector244>:
.globl vector244
vector244:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $244
80106a0d:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106a12:	e9 3d f0 ff ff       	jmp    80105a54 <alltraps>

80106a17 <vector245>:
.globl vector245
vector245:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $245
80106a19:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106a1e:	e9 31 f0 ff ff       	jmp    80105a54 <alltraps>

80106a23 <vector246>:
.globl vector246
vector246:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $246
80106a25:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106a2a:	e9 25 f0 ff ff       	jmp    80105a54 <alltraps>

80106a2f <vector247>:
.globl vector247
vector247:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $247
80106a31:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106a36:	e9 19 f0 ff ff       	jmp    80105a54 <alltraps>

80106a3b <vector248>:
.globl vector248
vector248:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $248
80106a3d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106a42:	e9 0d f0 ff ff       	jmp    80105a54 <alltraps>

80106a47 <vector249>:
.globl vector249
vector249:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $249
80106a49:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106a4e:	e9 01 f0 ff ff       	jmp    80105a54 <alltraps>

80106a53 <vector250>:
.globl vector250
vector250:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $250
80106a55:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106a5a:	e9 f5 ef ff ff       	jmp    80105a54 <alltraps>

80106a5f <vector251>:
.globl vector251
vector251:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $251
80106a61:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106a66:	e9 e9 ef ff ff       	jmp    80105a54 <alltraps>

80106a6b <vector252>:
.globl vector252
vector252:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $252
80106a6d:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106a72:	e9 dd ef ff ff       	jmp    80105a54 <alltraps>

80106a77 <vector253>:
.globl vector253
vector253:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $253
80106a79:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106a7e:	e9 d1 ef ff ff       	jmp    80105a54 <alltraps>

80106a83 <vector254>:
.globl vector254
vector254:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $254
80106a85:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106a8a:	e9 c5 ef ff ff       	jmp    80105a54 <alltraps>

80106a8f <vector255>:
.globl vector255
vector255:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $255
80106a91:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106a96:	e9 b9 ef ff ff       	jmp    80105a54 <alltraps>
80106a9b:	66 90                	xchg   %ax,%ax
80106a9d:	66 90                	xchg   %ax,%ax
80106a9f:	90                   	nop

80106aa0 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80106aa0:	f3 0f 1e fb          	endbr32 
80106aa4:	55                   	push   %ebp
80106aa5:	89 e5                	mov    %esp,%ebp
80106aa7:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80106aaa:	e8 b1 ce ff ff       	call   80103960 <cpuid>
  pd[0] = size-1;
80106aaf:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106ab4:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106aba:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106abe:	c7 80 f8 27 11 80 ff 	movl   $0xffff,-0x7feed808(%eax)
80106ac5:	ff 00 00 
80106ac8:	c7 80 fc 27 11 80 00 	movl   $0xcf9a00,-0x7feed804(%eax)
80106acf:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106ad2:	c7 80 00 28 11 80 ff 	movl   $0xffff,-0x7feed800(%eax)
80106ad9:	ff 00 00 
80106adc:	c7 80 04 28 11 80 00 	movl   $0xcf9200,-0x7feed7fc(%eax)
80106ae3:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106ae6:	c7 80 08 28 11 80 ff 	movl   $0xffff,-0x7feed7f8(%eax)
80106aed:	ff 00 00 
80106af0:	c7 80 0c 28 11 80 00 	movl   $0xcffa00,-0x7feed7f4(%eax)
80106af7:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106afa:	c7 80 10 28 11 80 ff 	movl   $0xffff,-0x7feed7f0(%eax)
80106b01:	ff 00 00 
80106b04:	c7 80 14 28 11 80 00 	movl   $0xcff200,-0x7feed7ec(%eax)
80106b0b:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106b0e:	05 f0 27 11 80       	add    $0x801127f0,%eax
  pd[1] = (uint)p;
80106b13:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106b17:	c1 e8 10             	shr    $0x10,%eax
80106b1a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106b1e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106b21:	0f 01 10             	lgdtl  (%eax)
}
80106b24:	c9                   	leave  
80106b25:	c3                   	ret    
80106b26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b2d:	8d 76 00             	lea    0x0(%esi),%esi

80106b30 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106b30:	f3 0f 1e fb          	endbr32 
80106b34:	55                   	push   %ebp
80106b35:	89 e5                	mov    %esp,%ebp
80106b37:	57                   	push   %edi
80106b38:	56                   	push   %esi
80106b39:	53                   	push   %ebx
80106b3a:	83 ec 0c             	sub    $0xc,%esp
80106b3d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106b40:	8b 55 08             	mov    0x8(%ebp),%edx
80106b43:	89 fe                	mov    %edi,%esi
80106b45:	c1 ee 16             	shr    $0x16,%esi
80106b48:	8d 34 b2             	lea    (%edx,%esi,4),%esi
  if(*pde & PTE_P){
80106b4b:	8b 1e                	mov    (%esi),%ebx
80106b4d:	f6 c3 01             	test   $0x1,%bl
80106b50:	74 26                	je     80106b78 <walkpgdir+0x48>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106b52:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106b58:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106b5e:	89 f8                	mov    %edi,%eax
}
80106b60:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106b63:	c1 e8 0a             	shr    $0xa,%eax
80106b66:	25 fc 0f 00 00       	and    $0xffc,%eax
80106b6b:	01 d8                	add    %ebx,%eax
}
80106b6d:	5b                   	pop    %ebx
80106b6e:	5e                   	pop    %esi
80106b6f:	5f                   	pop    %edi
80106b70:	5d                   	pop    %ebp
80106b71:	c3                   	ret    
80106b72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106b78:	8b 45 10             	mov    0x10(%ebp),%eax
80106b7b:	85 c0                	test   %eax,%eax
80106b7d:	74 31                	je     80106bb0 <walkpgdir+0x80>
80106b7f:	e8 bc ba ff ff       	call   80102640 <kalloc>
80106b84:	89 c3                	mov    %eax,%ebx
80106b86:	85 c0                	test   %eax,%eax
80106b88:	74 26                	je     80106bb0 <walkpgdir+0x80>
    memset(pgtab, 0, PGSIZE);
80106b8a:	83 ec 04             	sub    $0x4,%esp
80106b8d:	68 00 10 00 00       	push   $0x1000
80106b92:	6a 00                	push   $0x0
80106b94:	50                   	push   %eax
80106b95:	e8 36 db ff ff       	call   801046d0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106b9a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106ba0:	83 c4 10             	add    $0x10,%esp
80106ba3:	83 c8 07             	or     $0x7,%eax
80106ba6:	89 06                	mov    %eax,(%esi)
80106ba8:	eb b4                	jmp    80106b5e <walkpgdir+0x2e>
80106baa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
80106bb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106bb3:	31 c0                	xor    %eax,%eax
}
80106bb5:	5b                   	pop    %ebx
80106bb6:	5e                   	pop    %esi
80106bb7:	5f                   	pop    %edi
80106bb8:	5d                   	pop    %ebp
80106bb9:	c3                   	ret    
80106bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106bc0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106bc0:	55                   	push   %ebp
80106bc1:	89 e5                	mov    %esp,%ebp
80106bc3:	57                   	push   %edi
80106bc4:	56                   	push   %esi
80106bc5:	89 c6                	mov    %eax,%esi
80106bc7:	53                   	push   %ebx
80106bc8:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106bca:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
80106bd0:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106bd6:	83 ec 1c             	sub    $0x1c,%esp
80106bd9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106bdc:	39 da                	cmp    %ebx,%edx
80106bde:	73 5c                	jae    80106c3c <deallocuvm.part.0+0x7c>
80106be0:	89 d7                	mov    %edx,%edi
80106be2:	eb 0e                	jmp    80106bf2 <deallocuvm.part.0+0x32>
80106be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106be8:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106bee:	39 fb                	cmp    %edi,%ebx
80106bf0:	76 4a                	jbe    80106c3c <deallocuvm.part.0+0x7c>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106bf2:	83 ec 04             	sub    $0x4,%esp
80106bf5:	6a 00                	push   $0x0
80106bf7:	57                   	push   %edi
80106bf8:	56                   	push   %esi
80106bf9:	e8 32 ff ff ff       	call   80106b30 <walkpgdir>
    if(!pte)
80106bfe:	83 c4 10             	add    $0x10,%esp
80106c01:	85 c0                	test   %eax,%eax
80106c03:	74 4b                	je     80106c50 <deallocuvm.part.0+0x90>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106c05:	8b 08                	mov    (%eax),%ecx
80106c07:	f6 c1 01             	test   $0x1,%cl
80106c0a:	74 dc                	je     80106be8 <deallocuvm.part.0+0x28>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106c0c:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
80106c12:	74 4c                	je     80106c60 <deallocuvm.part.0+0xa0>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106c14:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106c17:	81 c1 00 00 00 80    	add    $0x80000000,%ecx
80106c1d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80106c20:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106c26:	51                   	push   %ecx
80106c27:	e8 54 b8 ff ff       	call   80102480 <kfree>
      *pte = 0;
80106c2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c2f:	83 c4 10             	add    $0x10,%esp
80106c32:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106c38:	39 fb                	cmp    %edi,%ebx
80106c3a:	77 b6                	ja     80106bf2 <deallocuvm.part.0+0x32>
    }
  }
  return newsz;
}
80106c3c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106c3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c42:	5b                   	pop    %ebx
80106c43:	5e                   	pop    %esi
80106c44:	5f                   	pop    %edi
80106c45:	5d                   	pop    %ebp
80106c46:	c3                   	ret    
80106c47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c4e:	66 90                	xchg   %ax,%ax
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106c50:	89 fa                	mov    %edi,%edx
80106c52:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
80106c58:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
80106c5e:	eb 8e                	jmp    80106bee <deallocuvm.part.0+0x2e>
        panic("kfree");
80106c60:	83 ec 0c             	sub    $0xc,%esp
80106c63:	68 86 76 10 80       	push   $0x80107686
80106c68:	e8 23 97 ff ff       	call   80100390 <panic>
80106c6d:	8d 76 00             	lea    0x0(%esi),%esi

80106c70 <mappages>:
{
80106c70:	f3 0f 1e fb          	endbr32 
80106c74:	55                   	push   %ebp
80106c75:	89 e5                	mov    %esp,%ebp
80106c77:	57                   	push   %edi
80106c78:	56                   	push   %esi
80106c79:	53                   	push   %ebx
80106c7a:	83 ec 1c             	sub    $0x1c,%esp
80106c7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106c80:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106c83:	8b 75 14             	mov    0x14(%ebp),%esi
  a = (char*)PGROUNDDOWN((uint)va);
80106c86:	89 c7                	mov    %eax,%edi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106c88:	8d 44 08 ff          	lea    -0x1(%eax,%ecx,1),%eax
  a = (char*)PGROUNDDOWN((uint)va);
80106c8c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106c92:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106c97:	29 fe                	sub    %edi,%esi
80106c99:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106c9c:	89 f0                	mov    %esi,%eax
80106c9e:	89 fe                	mov    %edi,%esi
80106ca0:	89 c7                	mov    %eax,%edi
80106ca2:	eb 1c                	jmp    80106cc0 <mappages+0x50>
80106ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(*pte & PTE_P)
80106ca8:	f6 00 01             	testb  $0x1,(%eax)
80106cab:	75 45                	jne    80106cf2 <mappages+0x82>
    *pte = pa | perm | PTE_P;
80106cad:	0b 5d 18             	or     0x18(%ebp),%ebx
80106cb0:	83 cb 01             	or     $0x1,%ebx
80106cb3:	89 18                	mov    %ebx,(%eax)
    if(a == last)
80106cb5:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
80106cb8:	74 2e                	je     80106ce8 <mappages+0x78>
    a += PGSIZE;
80106cba:	81 c6 00 10 00 00    	add    $0x1000,%esi
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106cc0:	83 ec 04             	sub    $0x4,%esp
80106cc3:	8d 1c 3e             	lea    (%esi,%edi,1),%ebx
80106cc6:	6a 01                	push   $0x1
80106cc8:	56                   	push   %esi
80106cc9:	ff 75 08             	pushl  0x8(%ebp)
80106ccc:	e8 5f fe ff ff       	call   80106b30 <walkpgdir>
80106cd1:	83 c4 10             	add    $0x10,%esp
80106cd4:	85 c0                	test   %eax,%eax
80106cd6:	75 d0                	jne    80106ca8 <mappages+0x38>
}
80106cd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1; 
80106cdb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106ce0:	5b                   	pop    %ebx
80106ce1:	5e                   	pop    %esi
80106ce2:	5f                   	pop    %edi
80106ce3:	5d                   	pop    %ebp
80106ce4:	c3                   	ret    
80106ce5:	8d 76 00             	lea    0x0(%esi),%esi
80106ce8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106ceb:	31 c0                	xor    %eax,%eax
}
80106ced:	5b                   	pop    %ebx
80106cee:	5e                   	pop    %esi
80106cef:	5f                   	pop    %edi
80106cf0:	5d                   	pop    %ebp
80106cf1:	c3                   	ret    
      panic("remap");
80106cf2:	83 ec 0c             	sub    $0xc,%esp
80106cf5:	68 40 7e 10 80       	push   $0x80107e40
80106cfa:	e8 91 96 ff ff       	call   80100390 <panic>
80106cff:	90                   	nop

80106d00 <switchkvm>:
{
80106d00:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106d04:	a1 a4 55 11 80       	mov    0x801155a4,%eax
80106d09:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106d0e:	0f 22 d8             	mov    %eax,%cr3
}
80106d11:	c3                   	ret    
80106d12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106d20 <switchuvm>:
{
80106d20:	f3 0f 1e fb          	endbr32 
80106d24:	55                   	push   %ebp
80106d25:	89 e5                	mov    %esp,%ebp
80106d27:	57                   	push   %edi
80106d28:	56                   	push   %esi
80106d29:	53                   	push   %ebx
80106d2a:	83 ec 1c             	sub    $0x1c,%esp
80106d2d:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106d30:	85 f6                	test   %esi,%esi
80106d32:	0f 84 cb 00 00 00    	je     80106e03 <switchuvm+0xe3>
  if(p->kstack == 0)
80106d38:	8b 46 08             	mov    0x8(%esi),%eax
80106d3b:	85 c0                	test   %eax,%eax
80106d3d:	0f 84 da 00 00 00    	je     80106e1d <switchuvm+0xfd>
  if(p->pgdir == 0)
80106d43:	8b 46 04             	mov    0x4(%esi),%eax
80106d46:	85 c0                	test   %eax,%eax
80106d48:	0f 84 c2 00 00 00    	je     80106e10 <switchuvm+0xf0>
  pushcli();
80106d4e:	e8 6d d7 ff ff       	call   801044c0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106d53:	e8 98 cb ff ff       	call   801038f0 <mycpu>
80106d58:	89 c3                	mov    %eax,%ebx
80106d5a:	e8 91 cb ff ff       	call   801038f0 <mycpu>
80106d5f:	89 c7                	mov    %eax,%edi
80106d61:	e8 8a cb ff ff       	call   801038f0 <mycpu>
80106d66:	83 c7 08             	add    $0x8,%edi
80106d69:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106d6c:	e8 7f cb ff ff       	call   801038f0 <mycpu>
80106d71:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106d74:	ba 67 00 00 00       	mov    $0x67,%edx
80106d79:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106d80:	83 c0 08             	add    $0x8,%eax
80106d83:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106d8a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106d8f:	83 c1 08             	add    $0x8,%ecx
80106d92:	c1 e8 18             	shr    $0x18,%eax
80106d95:	c1 e9 10             	shr    $0x10,%ecx
80106d98:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106d9e:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106da4:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106da9:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106db0:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106db5:	e8 36 cb ff ff       	call   801038f0 <mycpu>
80106dba:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106dc1:	e8 2a cb ff ff       	call   801038f0 <mycpu>
80106dc6:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106dca:	8b 5e 08             	mov    0x8(%esi),%ebx
80106dcd:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106dd3:	e8 18 cb ff ff       	call   801038f0 <mycpu>
80106dd8:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106ddb:	e8 10 cb ff ff       	call   801038f0 <mycpu>
80106de0:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106de4:	b8 28 00 00 00       	mov    $0x28,%eax
80106de9:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106dec:	8b 46 04             	mov    0x4(%esi),%eax
80106def:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106df4:	0f 22 d8             	mov    %eax,%cr3
}
80106df7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106dfa:	5b                   	pop    %ebx
80106dfb:	5e                   	pop    %esi
80106dfc:	5f                   	pop    %edi
80106dfd:	5d                   	pop    %ebp
  popcli();
80106dfe:	e9 0d d7 ff ff       	jmp    80104510 <popcli>
    panic("switchuvm: no process");
80106e03:	83 ec 0c             	sub    $0xc,%esp
80106e06:	68 46 7e 10 80       	push   $0x80107e46
80106e0b:	e8 80 95 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80106e10:	83 ec 0c             	sub    $0xc,%esp
80106e13:	68 71 7e 10 80       	push   $0x80107e71
80106e18:	e8 73 95 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80106e1d:	83 ec 0c             	sub    $0xc,%esp
80106e20:	68 5c 7e 10 80       	push   $0x80107e5c
80106e25:	e8 66 95 ff ff       	call   80100390 <panic>
80106e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106e30 <inituvm>:
{
80106e30:	f3 0f 1e fb          	endbr32 
80106e34:	55                   	push   %ebp
80106e35:	89 e5                	mov    %esp,%ebp
80106e37:	57                   	push   %edi
80106e38:	56                   	push   %esi
80106e39:	53                   	push   %ebx
80106e3a:	83 ec 1c             	sub    $0x1c,%esp
80106e3d:	8b 75 10             	mov    0x10(%ebp),%esi
80106e40:	8b 55 08             	mov    0x8(%ebp),%edx
80106e43:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80106e46:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106e4c:	77 50                	ja     80106e9e <inituvm+0x6e>
80106e4e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  mem = kalloc();
80106e51:	e8 ea b7 ff ff       	call   80102640 <kalloc>
  memset(mem, 0, PGSIZE);
80106e56:	83 ec 04             	sub    $0x4,%esp
80106e59:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106e5e:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106e60:	6a 00                	push   $0x0
80106e62:	50                   	push   %eax
80106e63:	e8 68 d8 ff ff       	call   801046d0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106e68:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106e6b:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106e71:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
80106e78:	50                   	push   %eax
80106e79:	68 00 10 00 00       	push   $0x1000
80106e7e:	6a 00                	push   $0x0
80106e80:	52                   	push   %edx
80106e81:	e8 ea fd ff ff       	call   80106c70 <mappages>
  memmove(mem, init, sz);
80106e86:	89 75 10             	mov    %esi,0x10(%ebp)
80106e89:	83 c4 20             	add    $0x20,%esp
80106e8c:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106e8f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106e92:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e95:	5b                   	pop    %ebx
80106e96:	5e                   	pop    %esi
80106e97:	5f                   	pop    %edi
80106e98:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106e99:	e9 d2 d8 ff ff       	jmp    80104770 <memmove>
    panic("inituvm: more than a page");
80106e9e:	83 ec 0c             	sub    $0xc,%esp
80106ea1:	68 85 7e 10 80       	push   $0x80107e85
80106ea6:	e8 e5 94 ff ff       	call   80100390 <panic>
80106eab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106eaf:	90                   	nop

80106eb0 <loaduvm>:
{
80106eb0:	f3 0f 1e fb          	endbr32 
80106eb4:	55                   	push   %ebp
80106eb5:	89 e5                	mov    %esp,%ebp
80106eb7:	57                   	push   %edi
80106eb8:	56                   	push   %esi
80106eb9:	53                   	push   %ebx
80106eba:	83 ec 1c             	sub    $0x1c,%esp
80106ebd:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ec0:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106ec3:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106ec8:	0f 85 99 00 00 00    	jne    80106f67 <loaduvm+0xb7>
  for(i = 0; i < sz; i += PGSIZE){
80106ece:	01 f0                	add    %esi,%eax
80106ed0:	89 f3                	mov    %esi,%ebx
80106ed2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106ed5:	8b 45 14             	mov    0x14(%ebp),%eax
80106ed8:	01 f0                	add    %esi,%eax
80106eda:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80106edd:	85 f6                	test   %esi,%esi
80106edf:	75 15                	jne    80106ef6 <loaduvm+0x46>
80106ee1:	eb 6d                	jmp    80106f50 <loaduvm+0xa0>
80106ee3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106ee7:	90                   	nop
80106ee8:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106eee:	89 f0                	mov    %esi,%eax
80106ef0:	29 d8                	sub    %ebx,%eax
80106ef2:	39 c6                	cmp    %eax,%esi
80106ef4:	76 5a                	jbe    80106f50 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106ef6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ef9:	83 ec 04             	sub    $0x4,%esp
80106efc:	6a 00                	push   $0x0
80106efe:	29 d8                	sub    %ebx,%eax
80106f00:	50                   	push   %eax
80106f01:	ff 75 08             	pushl  0x8(%ebp)
80106f04:	e8 27 fc ff ff       	call   80106b30 <walkpgdir>
80106f09:	83 c4 10             	add    $0x10,%esp
80106f0c:	85 c0                	test   %eax,%eax
80106f0e:	74 4a                	je     80106f5a <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
80106f10:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106f12:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80106f15:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106f1a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106f1f:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106f25:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106f28:	29 d9                	sub    %ebx,%ecx
80106f2a:	05 00 00 00 80       	add    $0x80000000,%eax
80106f2f:	57                   	push   %edi
80106f30:	51                   	push   %ecx
80106f31:	50                   	push   %eax
80106f32:	ff 75 10             	pushl  0x10(%ebp)
80106f35:	e8 36 ab ff ff       	call   80101a70 <readi>
80106f3a:	83 c4 10             	add    $0x10,%esp
80106f3d:	39 f8                	cmp    %edi,%eax
80106f3f:	74 a7                	je     80106ee8 <loaduvm+0x38>
}
80106f41:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106f44:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106f49:	5b                   	pop    %ebx
80106f4a:	5e                   	pop    %esi
80106f4b:	5f                   	pop    %edi
80106f4c:	5d                   	pop    %ebp
80106f4d:	c3                   	ret    
80106f4e:	66 90                	xchg   %ax,%ax
80106f50:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106f53:	31 c0                	xor    %eax,%eax
}
80106f55:	5b                   	pop    %ebx
80106f56:	5e                   	pop    %esi
80106f57:	5f                   	pop    %edi
80106f58:	5d                   	pop    %ebp
80106f59:	c3                   	ret    
      panic("loaduvm: address should exist");
80106f5a:	83 ec 0c             	sub    $0xc,%esp
80106f5d:	68 9f 7e 10 80       	push   $0x80107e9f
80106f62:	e8 29 94 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80106f67:	83 ec 0c             	sub    $0xc,%esp
80106f6a:	68 0c 7f 10 80       	push   $0x80107f0c
80106f6f:	e8 1c 94 ff ff       	call   80100390 <panic>
80106f74:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106f7f:	90                   	nop

80106f80 <allocuvm>:
{
80106f80:	f3 0f 1e fb          	endbr32 
80106f84:	55                   	push   %ebp
80106f85:	89 e5                	mov    %esp,%ebp
80106f87:	57                   	push   %edi
80106f88:	56                   	push   %esi
80106f89:	53                   	push   %ebx
80106f8a:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106f8d:	8b 7d 10             	mov    0x10(%ebp),%edi
80106f90:	85 ff                	test   %edi,%edi
80106f92:	0f 88 c0 00 00 00    	js     80107058 <allocuvm+0xd8>
  if(newsz < oldsz)
80106f98:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106f9b:	0f 82 a7 00 00 00    	jb     80107048 <allocuvm+0xc8>
  a = PGROUNDUP(oldsz);
80106fa1:	8b 45 0c             	mov    0xc(%ebp),%eax
80106fa4:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80106faa:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80106fb0:	39 75 10             	cmp    %esi,0x10(%ebp)
80106fb3:	0f 86 92 00 00 00    	jbe    8010704b <allocuvm+0xcb>
80106fb9:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106fbc:	8b 7d 08             	mov    0x8(%ebp),%edi
80106fbf:	eb 47                	jmp    80107008 <allocuvm+0x88>
80106fc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80106fc8:	83 ec 04             	sub    $0x4,%esp
80106fcb:	68 00 10 00 00       	push   $0x1000
80106fd0:	6a 00                	push   $0x0
80106fd2:	50                   	push   %eax
80106fd3:	e8 f8 d6 ff ff       	call   801046d0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106fd8:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106fde:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
80106fe5:	50                   	push   %eax
80106fe6:	68 00 10 00 00       	push   $0x1000
80106feb:	56                   	push   %esi
80106fec:	57                   	push   %edi
80106fed:	e8 7e fc ff ff       	call   80106c70 <mappages>
80106ff2:	83 c4 20             	add    $0x20,%esp
80106ff5:	85 c0                	test   %eax,%eax
80106ff7:	78 6f                	js     80107068 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80106ff9:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106fff:	39 75 10             	cmp    %esi,0x10(%ebp)
80107002:	0f 86 a0 00 00 00    	jbe    801070a8 <allocuvm+0x128>
    mem = kalloc();
80107008:	e8 33 b6 ff ff       	call   80102640 <kalloc>
8010700d:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
8010700f:	85 c0                	test   %eax,%eax
80107011:	75 b5                	jne    80106fc8 <allocuvm+0x48>
      cprintf("allocuvm out of memory\n");
80107013:	83 ec 0c             	sub    $0xc,%esp
80107016:	68 5c 7c 10 80       	push   $0x80107c5c
8010701b:	e8 90 96 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80107020:	8b 45 0c             	mov    0xc(%ebp),%eax
80107023:	83 c4 10             	add    $0x10,%esp
80107026:	39 45 10             	cmp    %eax,0x10(%ebp)
80107029:	74 2d                	je     80107058 <allocuvm+0xd8>
8010702b:	8b 55 10             	mov    0x10(%ebp),%edx
8010702e:	89 c1                	mov    %eax,%ecx
80107030:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80107033:	31 ff                	xor    %edi,%edi
80107035:	e8 86 fb ff ff       	call   80106bc0 <deallocuvm.part.0>
}
8010703a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010703d:	89 f8                	mov    %edi,%eax
8010703f:	5b                   	pop    %ebx
80107040:	5e                   	pop    %esi
80107041:	5f                   	pop    %edi
80107042:	5d                   	pop    %ebp
80107043:	c3                   	ret    
80107044:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107048:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
8010704b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010704e:	89 f8                	mov    %edi,%eax
80107050:	5b                   	pop    %ebx
80107051:	5e                   	pop    %esi
80107052:	5f                   	pop    %edi
80107053:	5d                   	pop    %ebp
80107054:	c3                   	ret    
80107055:	8d 76 00             	lea    0x0(%esi),%esi
80107058:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
8010705b:	31 ff                	xor    %edi,%edi
}
8010705d:	5b                   	pop    %ebx
8010705e:	89 f8                	mov    %edi,%eax
80107060:	5e                   	pop    %esi
80107061:	5f                   	pop    %edi
80107062:	5d                   	pop    %ebp
80107063:	c3                   	ret    
80107064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("allocuvm out of memory (2)\n");
80107068:	83 ec 0c             	sub    $0xc,%esp
8010706b:	68 74 7c 10 80       	push   $0x80107c74
80107070:	e8 3b 96 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80107075:	8b 45 0c             	mov    0xc(%ebp),%eax
80107078:	83 c4 10             	add    $0x10,%esp
8010707b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010707e:	74 0d                	je     8010708d <allocuvm+0x10d>
80107080:	89 c1                	mov    %eax,%ecx
80107082:	8b 55 10             	mov    0x10(%ebp),%edx
80107085:	8b 45 08             	mov    0x8(%ebp),%eax
80107088:	e8 33 fb ff ff       	call   80106bc0 <deallocuvm.part.0>
      kfree(mem);
8010708d:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80107090:	31 ff                	xor    %edi,%edi
      kfree(mem);
80107092:	53                   	push   %ebx
80107093:	e8 e8 b3 ff ff       	call   80102480 <kfree>
      return 0;
80107098:	83 c4 10             	add    $0x10,%esp
}
8010709b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010709e:	89 f8                	mov    %edi,%eax
801070a0:	5b                   	pop    %ebx
801070a1:	5e                   	pop    %esi
801070a2:	5f                   	pop    %edi
801070a3:	5d                   	pop    %ebp
801070a4:	c3                   	ret    
801070a5:	8d 76 00             	lea    0x0(%esi),%esi
801070a8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801070ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070ae:	5b                   	pop    %ebx
801070af:	5e                   	pop    %esi
801070b0:	89 f8                	mov    %edi,%eax
801070b2:	5f                   	pop    %edi
801070b3:	5d                   	pop    %ebp
801070b4:	c3                   	ret    
801070b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801070c0 <deallocuvm>:
{
801070c0:	f3 0f 1e fb          	endbr32 
801070c4:	55                   	push   %ebp
801070c5:	89 e5                	mov    %esp,%ebp
801070c7:	8b 55 0c             	mov    0xc(%ebp),%edx
801070ca:	8b 4d 10             	mov    0x10(%ebp),%ecx
801070cd:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801070d0:	39 d1                	cmp    %edx,%ecx
801070d2:	73 0c                	jae    801070e0 <deallocuvm+0x20>
}
801070d4:	5d                   	pop    %ebp
801070d5:	e9 e6 fa ff ff       	jmp    80106bc0 <deallocuvm.part.0>
801070da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801070e0:	89 d0                	mov    %edx,%eax
801070e2:	5d                   	pop    %ebp
801070e3:	c3                   	ret    
801070e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801070ef:	90                   	nop

801070f0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801070f0:	f3 0f 1e fb          	endbr32 
801070f4:	55                   	push   %ebp
801070f5:	89 e5                	mov    %esp,%ebp
801070f7:	57                   	push   %edi
801070f8:	56                   	push   %esi
801070f9:	53                   	push   %ebx
801070fa:	83 ec 0c             	sub    $0xc,%esp
801070fd:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107100:	85 f6                	test   %esi,%esi
80107102:	74 55                	je     80107159 <freevm+0x69>
  if(newsz >= oldsz)
80107104:	31 c9                	xor    %ecx,%ecx
80107106:	ba 00 00 00 80       	mov    $0x80000000,%edx
8010710b:	89 f0                	mov    %esi,%eax
8010710d:	89 f3                	mov    %esi,%ebx
8010710f:	e8 ac fa ff ff       	call   80106bc0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107114:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
8010711a:	eb 0b                	jmp    80107127 <freevm+0x37>
8010711c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107120:	83 c3 04             	add    $0x4,%ebx
80107123:	39 df                	cmp    %ebx,%edi
80107125:	74 23                	je     8010714a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107127:	8b 03                	mov    (%ebx),%eax
80107129:	a8 01                	test   $0x1,%al
8010712b:	74 f3                	je     80107120 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010712d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107132:	83 ec 0c             	sub    $0xc,%esp
80107135:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107138:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010713d:	50                   	push   %eax
8010713e:	e8 3d b3 ff ff       	call   80102480 <kfree>
80107143:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107146:	39 df                	cmp    %ebx,%edi
80107148:	75 dd                	jne    80107127 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010714a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010714d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107150:	5b                   	pop    %ebx
80107151:	5e                   	pop    %esi
80107152:	5f                   	pop    %edi
80107153:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107154:	e9 27 b3 ff ff       	jmp    80102480 <kfree>
    panic("freevm: no pgdir");
80107159:	83 ec 0c             	sub    $0xc,%esp
8010715c:	68 bd 7e 10 80       	push   $0x80107ebd
80107161:	e8 2a 92 ff ff       	call   80100390 <panic>
80107166:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010716d:	8d 76 00             	lea    0x0(%esi),%esi

80107170 <setupkvm>:
{
80107170:	f3 0f 1e fb          	endbr32 
80107174:	55                   	push   %ebp
80107175:	89 e5                	mov    %esp,%ebp
80107177:	56                   	push   %esi
80107178:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107179:	e8 c2 b4 ff ff       	call   80102640 <kalloc>
8010717e:	89 c6                	mov    %eax,%esi
80107180:	85 c0                	test   %eax,%eax
80107182:	74 42                	je     801071c6 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
80107184:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107187:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
8010718c:	68 00 10 00 00       	push   $0x1000
80107191:	6a 00                	push   $0x0
80107193:	50                   	push   %eax
80107194:	e8 37 d5 ff ff       	call   801046d0 <memset>
80107199:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
8010719c:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010719f:	8b 53 08             	mov    0x8(%ebx),%edx
801071a2:	83 ec 0c             	sub    $0xc,%esp
801071a5:	ff 73 0c             	pushl  0xc(%ebx)
801071a8:	29 c2                	sub    %eax,%edx
801071aa:	50                   	push   %eax
801071ab:	52                   	push   %edx
801071ac:	ff 33                	pushl  (%ebx)
801071ae:	56                   	push   %esi
801071af:	e8 bc fa ff ff       	call   80106c70 <mappages>
801071b4:	83 c4 20             	add    $0x20,%esp
801071b7:	85 c0                	test   %eax,%eax
801071b9:	78 15                	js     801071d0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801071bb:	83 c3 10             	add    $0x10,%ebx
801071be:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
801071c4:	75 d6                	jne    8010719c <setupkvm+0x2c>
}
801071c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801071c9:	89 f0                	mov    %esi,%eax
801071cb:	5b                   	pop    %ebx
801071cc:	5e                   	pop    %esi
801071cd:	5d                   	pop    %ebp
801071ce:	c3                   	ret    
801071cf:	90                   	nop
      freevm(pgdir);
801071d0:	83 ec 0c             	sub    $0xc,%esp
801071d3:	56                   	push   %esi
      return 0;
801071d4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801071d6:	e8 15 ff ff ff       	call   801070f0 <freevm>
      return 0;
801071db:	83 c4 10             	add    $0x10,%esp
}
801071de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801071e1:	89 f0                	mov    %esi,%eax
801071e3:	5b                   	pop    %ebx
801071e4:	5e                   	pop    %esi
801071e5:	5d                   	pop    %ebp
801071e6:	c3                   	ret    
801071e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071ee:	66 90                	xchg   %ax,%ax

801071f0 <kvmalloc>:
{
801071f0:	f3 0f 1e fb          	endbr32 
801071f4:	55                   	push   %ebp
801071f5:	89 e5                	mov    %esp,%ebp
801071f7:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801071fa:	e8 71 ff ff ff       	call   80107170 <setupkvm>
801071ff:	a3 a4 55 11 80       	mov    %eax,0x801155a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107204:	05 00 00 00 80       	add    $0x80000000,%eax
80107209:	0f 22 d8             	mov    %eax,%cr3
}
8010720c:	c9                   	leave  
8010720d:	c3                   	ret    
8010720e:	66 90                	xchg   %ax,%ax

80107210 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107210:	f3 0f 1e fb          	endbr32 
80107214:	55                   	push   %ebp
80107215:	89 e5                	mov    %esp,%ebp
80107217:	83 ec 0c             	sub    $0xc,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010721a:	6a 00                	push   $0x0
8010721c:	ff 75 0c             	pushl  0xc(%ebp)
8010721f:	ff 75 08             	pushl  0x8(%ebp)
80107222:	e8 09 f9 ff ff       	call   80106b30 <walkpgdir>
  if(pte == 0)
80107227:	83 c4 10             	add    $0x10,%esp
8010722a:	85 c0                	test   %eax,%eax
8010722c:	74 05                	je     80107233 <clearpteu+0x23>
    panic("clearpteu");
  *pte &= ~PTE_U;
8010722e:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107231:	c9                   	leave  
80107232:	c3                   	ret    
    panic("clearpteu");
80107233:	83 ec 0c             	sub    $0xc,%esp
80107236:	68 ce 7e 10 80       	push   $0x80107ece
8010723b:	e8 50 91 ff ff       	call   80100390 <panic>

80107240 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107240:	f3 0f 1e fb          	endbr32 
80107244:	55                   	push   %ebp
80107245:	89 e5                	mov    %esp,%ebp
80107247:	57                   	push   %edi
80107248:	56                   	push   %esi
80107249:	53                   	push   %ebx
8010724a:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
8010724d:	e8 1e ff ff ff       	call   80107170 <setupkvm>
80107252:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107255:	85 c0                	test   %eax,%eax
80107257:	0f 84 a3 00 00 00    	je     80107300 <copyuvm+0xc0>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
8010725d:	8b 55 0c             	mov    0xc(%ebp),%edx
80107260:	85 d2                	test   %edx,%edx
80107262:	0f 84 98 00 00 00    	je     80107300 <copyuvm+0xc0>
80107268:	31 f6                	xor    %esi,%esi
8010726a:	eb 44                	jmp    801072b0 <copyuvm+0x70>
8010726c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107270:	83 ec 04             	sub    $0x4,%esp
80107273:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107279:	68 00 10 00 00       	push   $0x1000
8010727e:	53                   	push   %ebx
8010727f:	50                   	push   %eax
80107280:	e8 eb d4 ff ff       	call   80104770 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107285:	58                   	pop    %eax
80107286:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
8010728c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010728f:	50                   	push   %eax
80107290:	68 00 10 00 00       	push   $0x1000
80107295:	56                   	push   %esi
80107296:	ff 75 e0             	pushl  -0x20(%ebp)
80107299:	e8 d2 f9 ff ff       	call   80106c70 <mappages>
8010729e:	83 c4 20             	add    $0x20,%esp
801072a1:	85 c0                	test   %eax,%eax
801072a3:	78 6b                	js     80107310 <copyuvm+0xd0>
  for(i = 0; i < sz; i += PGSIZE){
801072a5:	81 c6 00 10 00 00    	add    $0x1000,%esi
801072ab:	39 75 0c             	cmp    %esi,0xc(%ebp)
801072ae:	76 50                	jbe    80107300 <copyuvm+0xc0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801072b0:	83 ec 04             	sub    $0x4,%esp
801072b3:	6a 00                	push   $0x0
801072b5:	56                   	push   %esi
801072b6:	ff 75 08             	pushl  0x8(%ebp)
801072b9:	e8 72 f8 ff ff       	call   80106b30 <walkpgdir>
801072be:	83 c4 10             	add    $0x10,%esp
801072c1:	85 c0                	test   %eax,%eax
801072c3:	74 66                	je     8010732b <copyuvm+0xeb>
    if(!(*pte & PTE_P))
801072c5:	8b 38                	mov    (%eax),%edi
801072c7:	f7 c7 01 00 00 00    	test   $0x1,%edi
801072cd:	74 4f                	je     8010731e <copyuvm+0xde>
    pa = PTE_ADDR(*pte);
801072cf:	89 fb                	mov    %edi,%ebx
    flags = PTE_FLAGS(*pte);
801072d1:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
801072d7:	89 7d e4             	mov    %edi,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
801072da:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    if((mem = kalloc()) == 0)
801072e0:	e8 5b b3 ff ff       	call   80102640 <kalloc>
801072e5:	89 c7                	mov    %eax,%edi
801072e7:	85 c0                	test   %eax,%eax
801072e9:	75 85                	jne    80107270 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
801072eb:	83 ec 0c             	sub    $0xc,%esp
801072ee:	ff 75 e0             	pushl  -0x20(%ebp)
801072f1:	e8 fa fd ff ff       	call   801070f0 <freevm>
  return 0;
801072f6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801072fd:	83 c4 10             	add    $0x10,%esp
}
80107300:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107303:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107306:	5b                   	pop    %ebx
80107307:	5e                   	pop    %esi
80107308:	5f                   	pop    %edi
80107309:	5d                   	pop    %ebp
8010730a:	c3                   	ret    
8010730b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010730f:	90                   	nop
      kfree(mem);
80107310:	83 ec 0c             	sub    $0xc,%esp
80107313:	57                   	push   %edi
80107314:	e8 67 b1 ff ff       	call   80102480 <kfree>
      goto bad;
80107319:	83 c4 10             	add    $0x10,%esp
8010731c:	eb cd                	jmp    801072eb <copyuvm+0xab>
      panic("copyuvm: page not present");
8010731e:	83 ec 0c             	sub    $0xc,%esp
80107321:	68 f2 7e 10 80       	push   $0x80107ef2
80107326:	e8 65 90 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
8010732b:	83 ec 0c             	sub    $0xc,%esp
8010732e:	68 d8 7e 10 80       	push   $0x80107ed8
80107333:	e8 58 90 ff ff       	call   80100390 <panic>
80107338:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010733f:	90                   	nop

80107340 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107340:	f3 0f 1e fb          	endbr32 
80107344:	55                   	push   %ebp
80107345:	89 e5                	mov    %esp,%ebp
80107347:	83 ec 0c             	sub    $0xc,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010734a:	6a 00                	push   $0x0
8010734c:	ff 75 0c             	pushl  0xc(%ebp)
8010734f:	ff 75 08             	pushl  0x8(%ebp)
80107352:	e8 d9 f7 ff ff       	call   80106b30 <walkpgdir>
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
80107357:	83 c4 10             	add    $0x10,%esp
  if((*pte & PTE_P) == 0)
8010735a:	8b 00                	mov    (%eax),%eax
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
8010735c:	c9                   	leave  
  if((*pte & PTE_U) == 0)
8010735d:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010735f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107364:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107367:	05 00 00 00 80       	add    $0x80000000,%eax
8010736c:	83 fa 05             	cmp    $0x5,%edx
8010736f:	ba 00 00 00 00       	mov    $0x0,%edx
80107374:	0f 45 c2             	cmovne %edx,%eax
}
80107377:	c3                   	ret    
80107378:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010737f:	90                   	nop

80107380 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107380:	f3 0f 1e fb          	endbr32 
80107384:	55                   	push   %ebp
80107385:	89 e5                	mov    %esp,%ebp
80107387:	57                   	push   %edi
80107388:	56                   	push   %esi
80107389:	53                   	push   %ebx
8010738a:	83 ec 0c             	sub    $0xc,%esp
8010738d:	8b 75 14             	mov    0x14(%ebp),%esi
80107390:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107393:	85 f6                	test   %esi,%esi
80107395:	75 3c                	jne    801073d3 <copyout+0x53>
80107397:	eb 67                	jmp    80107400 <copyout+0x80>
80107399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801073a0:	8b 55 0c             	mov    0xc(%ebp),%edx
801073a3:	89 fb                	mov    %edi,%ebx
801073a5:	29 d3                	sub    %edx,%ebx
801073a7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
801073ad:	39 f3                	cmp    %esi,%ebx
801073af:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801073b2:	29 fa                	sub    %edi,%edx
801073b4:	83 ec 04             	sub    $0x4,%esp
801073b7:	01 c2                	add    %eax,%edx
801073b9:	53                   	push   %ebx
801073ba:	ff 75 10             	pushl  0x10(%ebp)
801073bd:	52                   	push   %edx
801073be:	e8 ad d3 ff ff       	call   80104770 <memmove>
    len -= n;
    buf += n;
801073c3:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
801073c6:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
801073cc:	83 c4 10             	add    $0x10,%esp
801073cf:	29 de                	sub    %ebx,%esi
801073d1:	74 2d                	je     80107400 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
801073d3:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
801073d5:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
801073d8:	89 55 0c             	mov    %edx,0xc(%ebp)
801073db:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
801073e1:	57                   	push   %edi
801073e2:	ff 75 08             	pushl  0x8(%ebp)
801073e5:	e8 56 ff ff ff       	call   80107340 <uva2ka>
    if(pa0 == 0)
801073ea:	83 c4 10             	add    $0x10,%esp
801073ed:	85 c0                	test   %eax,%eax
801073ef:	75 af                	jne    801073a0 <copyout+0x20>
  }
  return 0;
}
801073f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801073f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801073f9:	5b                   	pop    %ebx
801073fa:	5e                   	pop    %esi
801073fb:	5f                   	pop    %edi
801073fc:	5d                   	pop    %ebp
801073fd:	c3                   	ret    
801073fe:	66 90                	xchg   %ax,%ax
80107400:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107403:	31 c0                	xor    %eax,%eax
}
80107405:	5b                   	pop    %ebx
80107406:	5e                   	pop    %esi
80107407:	5f                   	pop    %edi
80107408:	5d                   	pop    %ebp
80107409:	c3                   	ret    
