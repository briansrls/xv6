
_wc:     file format elf32-i386


Disassembly of section .text:

00000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 48             	sub    $0x48,%esp
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
   6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
   d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10:	89 45 ec             	mov    %eax,-0x14(%ebp)
  13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  inword = 0;
  19:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
  20:	eb 62                	jmp    84 <wc+0x84>
    for(i=0; i<n; i++){
  22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  29:	eb 51                	jmp    7c <wc+0x7c>
      c++;
  2b:	ff 45 e8             	incl   -0x18(%ebp)
      if(buf[i] == '\n')
  2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  31:	05 a0 0c 00 00       	add    $0xca0,%eax
  36:	8a 00                	mov    (%eax),%al
  38:	3c 0a                	cmp    $0xa,%al
  3a:	75 03                	jne    3f <wc+0x3f>
        l++;
  3c:	ff 45 f0             	incl   -0x10(%ebp)
      if(strchr(" \r\t\n\v", buf[i]))
  3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  42:	05 a0 0c 00 00       	add    $0xca0,%eax
  47:	8a 00                	mov    (%eax),%al
  49:	0f be c0             	movsbl %al,%eax
  4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  50:	c7 04 24 a7 09 00 00 	movl   $0x9a7,(%esp)
  57:	e8 50 02 00 00       	call   2ac <strchr>
  5c:	85 c0                	test   %eax,%eax
  5e:	74 09                	je     69 <wc+0x69>
        inword = 0;
  60:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  67:	eb 10                	jmp    79 <wc+0x79>
      else if(!inword){
  69:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  6d:	75 0a                	jne    79 <wc+0x79>
        w++;
  6f:	ff 45 ec             	incl   -0x14(%ebp)
        inword = 1;
  72:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
  79:	ff 45 f4             	incl   -0xc(%ebp)
  7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  7f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  82:	7c a7                	jl     2b <wc+0x2b>
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
  84:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  8b:	00 
  8c:	c7 44 24 04 a0 0c 00 	movl   $0xca0,0x4(%esp)
  93:	00 
  94:	8b 45 08             	mov    0x8(%ebp),%eax
  97:	89 04 24             	mov    %eax,(%esp)
  9a:	e8 c9 03 00 00       	call   468 <read>
  9f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  a2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  a6:	0f 8f 76 ff ff ff    	jg     22 <wc+0x22>
        w++;
        inword = 1;
      }
    }
  }
  if(n < 0){
  ac:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  b0:	79 19                	jns    cb <wc+0xcb>
    printf(1, "wc: read error\n");
  b2:	c7 44 24 04 ad 09 00 	movl   $0x9ad,0x4(%esp)
  b9:	00 
  ba:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  c1:	e8 1a 05 00 00       	call   5e0 <printf>
    exit();
  c6:	e8 85 03 00 00       	call   450 <exit>
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
  cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  ce:	89 44 24 14          	mov    %eax,0x14(%esp)
  d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  d5:	89 44 24 10          	mov    %eax,0x10(%esp)
  d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  dc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  e3:	89 44 24 08          	mov    %eax,0x8(%esp)
  e7:	c7 44 24 04 bd 09 00 	movl   $0x9bd,0x4(%esp)
  ee:	00 
  ef:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  f6:	e8 e5 04 00 00       	call   5e0 <printf>
}
  fb:	c9                   	leave  
  fc:	c3                   	ret    

000000fd <main>:

int
main(int argc, char *argv[])
{
  fd:	55                   	push   %ebp
  fe:	89 e5                	mov    %esp,%ebp
 100:	83 e4 f0             	and    $0xfffffff0,%esp
 103:	83 ec 20             	sub    $0x20,%esp
  int fd, i;

  if(argc <= 1){
 106:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 10a:	7f 19                	jg     125 <main+0x28>
    wc(0, "");
 10c:	c7 44 24 04 ca 09 00 	movl   $0x9ca,0x4(%esp)
 113:	00 
 114:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 11b:	e8 e0 fe ff ff       	call   0 <wc>
    exit();
 120:	e8 2b 03 00 00       	call   450 <exit>
  }

  for(i = 1; i < argc; i++){
 125:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
 12c:	00 
 12d:	e9 8e 00 00 00       	jmp    1c0 <main+0xc3>
    if((fd = open(argv[i], 0)) < 0){
 132:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 136:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 13d:	8b 45 0c             	mov    0xc(%ebp),%eax
 140:	01 d0                	add    %edx,%eax
 142:	8b 00                	mov    (%eax),%eax
 144:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 14b:	00 
 14c:	89 04 24             	mov    %eax,(%esp)
 14f:	e8 3c 03 00 00       	call   490 <open>
 154:	89 44 24 18          	mov    %eax,0x18(%esp)
 158:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
 15d:	79 2f                	jns    18e <main+0x91>
      printf(1, "wc: cannot open %s\n", argv[i]);
 15f:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 163:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 16a:	8b 45 0c             	mov    0xc(%ebp),%eax
 16d:	01 d0                	add    %edx,%eax
 16f:	8b 00                	mov    (%eax),%eax
 171:	89 44 24 08          	mov    %eax,0x8(%esp)
 175:	c7 44 24 04 cb 09 00 	movl   $0x9cb,0x4(%esp)
 17c:	00 
 17d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 184:	e8 57 04 00 00       	call   5e0 <printf>
      exit();
 189:	e8 c2 02 00 00       	call   450 <exit>
    }
    wc(fd, argv[i]);
 18e:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 192:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 199:	8b 45 0c             	mov    0xc(%ebp),%eax
 19c:	01 d0                	add    %edx,%eax
 19e:	8b 00                	mov    (%eax),%eax
 1a0:	89 44 24 04          	mov    %eax,0x4(%esp)
 1a4:	8b 44 24 18          	mov    0x18(%esp),%eax
 1a8:	89 04 24             	mov    %eax,(%esp)
 1ab:	e8 50 fe ff ff       	call   0 <wc>
    close(fd);
 1b0:	8b 44 24 18          	mov    0x18(%esp),%eax
 1b4:	89 04 24             	mov    %eax,(%esp)
 1b7:	e8 bc 02 00 00       	call   478 <close>
  if(argc <= 1){
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
 1bc:	ff 44 24 1c          	incl   0x1c(%esp)
 1c0:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 1c4:	3b 45 08             	cmp    0x8(%ebp),%eax
 1c7:	0f 8c 65 ff ff ff    	jl     132 <main+0x35>
      exit();
    }
    wc(fd, argv[i]);
    close(fd);
  }
  exit();
 1cd:	e8 7e 02 00 00       	call   450 <exit>
 1d2:	66 90                	xchg   %ax,%ax

000001d4 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1d4:	55                   	push   %ebp
 1d5:	89 e5                	mov    %esp,%ebp
 1d7:	57                   	push   %edi
 1d8:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1dc:	8b 55 10             	mov    0x10(%ebp),%edx
 1df:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e2:	89 cb                	mov    %ecx,%ebx
 1e4:	89 df                	mov    %ebx,%edi
 1e6:	89 d1                	mov    %edx,%ecx
 1e8:	fc                   	cld    
 1e9:	f3 aa                	rep stos %al,%es:(%edi)
 1eb:	89 ca                	mov    %ecx,%edx
 1ed:	89 fb                	mov    %edi,%ebx
 1ef:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1f2:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1f5:	5b                   	pop    %ebx
 1f6:	5f                   	pop    %edi
 1f7:	5d                   	pop    %ebp
 1f8:	c3                   	ret    

000001f9 <strcpy>:
#include "x86.h"
#include "signal.h"

char*
strcpy(char *s, char *t)
{
 1f9:	55                   	push   %ebp
 1fa:	89 e5                	mov    %esp,%ebp
 1fc:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1ff:	8b 45 08             	mov    0x8(%ebp),%eax
 202:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 205:	90                   	nop
 206:	8b 45 0c             	mov    0xc(%ebp),%eax
 209:	8a 10                	mov    (%eax),%dl
 20b:	8b 45 08             	mov    0x8(%ebp),%eax
 20e:	88 10                	mov    %dl,(%eax)
 210:	8b 45 08             	mov    0x8(%ebp),%eax
 213:	8a 00                	mov    (%eax),%al
 215:	84 c0                	test   %al,%al
 217:	0f 95 c0             	setne  %al
 21a:	ff 45 08             	incl   0x8(%ebp)
 21d:	ff 45 0c             	incl   0xc(%ebp)
 220:	84 c0                	test   %al,%al
 222:	75 e2                	jne    206 <strcpy+0xd>
    ;
  return os;
 224:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 227:	c9                   	leave  
 228:	c3                   	ret    

00000229 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 229:	55                   	push   %ebp
 22a:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 22c:	eb 06                	jmp    234 <strcmp+0xb>
    p++, q++;
 22e:	ff 45 08             	incl   0x8(%ebp)
 231:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 234:	8b 45 08             	mov    0x8(%ebp),%eax
 237:	8a 00                	mov    (%eax),%al
 239:	84 c0                	test   %al,%al
 23b:	74 0e                	je     24b <strcmp+0x22>
 23d:	8b 45 08             	mov    0x8(%ebp),%eax
 240:	8a 10                	mov    (%eax),%dl
 242:	8b 45 0c             	mov    0xc(%ebp),%eax
 245:	8a 00                	mov    (%eax),%al
 247:	38 c2                	cmp    %al,%dl
 249:	74 e3                	je     22e <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 24b:	8b 45 08             	mov    0x8(%ebp),%eax
 24e:	8a 00                	mov    (%eax),%al
 250:	0f b6 d0             	movzbl %al,%edx
 253:	8b 45 0c             	mov    0xc(%ebp),%eax
 256:	8a 00                	mov    (%eax),%al
 258:	0f b6 c0             	movzbl %al,%eax
 25b:	89 d1                	mov    %edx,%ecx
 25d:	29 c1                	sub    %eax,%ecx
 25f:	89 c8                	mov    %ecx,%eax
}
 261:	5d                   	pop    %ebp
 262:	c3                   	ret    

00000263 <strlen>:

uint
strlen(char *s)
{
 263:	55                   	push   %ebp
 264:	89 e5                	mov    %esp,%ebp
 266:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 269:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 270:	eb 03                	jmp    275 <strlen+0x12>
 272:	ff 45 fc             	incl   -0x4(%ebp)
 275:	8b 55 fc             	mov    -0x4(%ebp),%edx
 278:	8b 45 08             	mov    0x8(%ebp),%eax
 27b:	01 d0                	add    %edx,%eax
 27d:	8a 00                	mov    (%eax),%al
 27f:	84 c0                	test   %al,%al
 281:	75 ef                	jne    272 <strlen+0xf>
    ;
  return n;
 283:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 286:	c9                   	leave  
 287:	c3                   	ret    

00000288 <memset>:

void*
memset(void *dst, int c, uint n)
{
 288:	55                   	push   %ebp
 289:	89 e5                	mov    %esp,%ebp
 28b:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 28e:	8b 45 10             	mov    0x10(%ebp),%eax
 291:	89 44 24 08          	mov    %eax,0x8(%esp)
 295:	8b 45 0c             	mov    0xc(%ebp),%eax
 298:	89 44 24 04          	mov    %eax,0x4(%esp)
 29c:	8b 45 08             	mov    0x8(%ebp),%eax
 29f:	89 04 24             	mov    %eax,(%esp)
 2a2:	e8 2d ff ff ff       	call   1d4 <stosb>
  return dst;
 2a7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2aa:	c9                   	leave  
 2ab:	c3                   	ret    

000002ac <strchr>:

char*
strchr(const char *s, char c)
{
 2ac:	55                   	push   %ebp
 2ad:	89 e5                	mov    %esp,%ebp
 2af:	83 ec 04             	sub    $0x4,%esp
 2b2:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b5:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2b8:	eb 12                	jmp    2cc <strchr+0x20>
    if(*s == c)
 2ba:	8b 45 08             	mov    0x8(%ebp),%eax
 2bd:	8a 00                	mov    (%eax),%al
 2bf:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2c2:	75 05                	jne    2c9 <strchr+0x1d>
      return (char*)s;
 2c4:	8b 45 08             	mov    0x8(%ebp),%eax
 2c7:	eb 11                	jmp    2da <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2c9:	ff 45 08             	incl   0x8(%ebp)
 2cc:	8b 45 08             	mov    0x8(%ebp),%eax
 2cf:	8a 00                	mov    (%eax),%al
 2d1:	84 c0                	test   %al,%al
 2d3:	75 e5                	jne    2ba <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2da:	c9                   	leave  
 2db:	c3                   	ret    

000002dc <gets>:

char*
gets(char *buf, int max)
{
 2dc:	55                   	push   %ebp
 2dd:	89 e5                	mov    %esp,%ebp
 2df:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2e2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2e9:	eb 42                	jmp    32d <gets+0x51>
    cc = read(0, &c, 1);
 2eb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 2f2:	00 
 2f3:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2f6:	89 44 24 04          	mov    %eax,0x4(%esp)
 2fa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 301:	e8 62 01 00 00       	call   468 <read>
 306:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 309:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 30d:	7e 29                	jle    338 <gets+0x5c>
      break;
    buf[i++] = c;
 30f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 312:	8b 45 08             	mov    0x8(%ebp),%eax
 315:	01 c2                	add    %eax,%edx
 317:	8a 45 ef             	mov    -0x11(%ebp),%al
 31a:	88 02                	mov    %al,(%edx)
 31c:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 31f:	8a 45 ef             	mov    -0x11(%ebp),%al
 322:	3c 0a                	cmp    $0xa,%al
 324:	74 13                	je     339 <gets+0x5d>
 326:	8a 45 ef             	mov    -0x11(%ebp),%al
 329:	3c 0d                	cmp    $0xd,%al
 32b:	74 0c                	je     339 <gets+0x5d>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 32d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 330:	40                   	inc    %eax
 331:	3b 45 0c             	cmp    0xc(%ebp),%eax
 334:	7c b5                	jl     2eb <gets+0xf>
 336:	eb 01                	jmp    339 <gets+0x5d>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 338:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 339:	8b 55 f4             	mov    -0xc(%ebp),%edx
 33c:	8b 45 08             	mov    0x8(%ebp),%eax
 33f:	01 d0                	add    %edx,%eax
 341:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 344:	8b 45 08             	mov    0x8(%ebp),%eax
}
 347:	c9                   	leave  
 348:	c3                   	ret    

00000349 <stat>:

int
stat(char *n, struct stat *st)
{
 349:	55                   	push   %ebp
 34a:	89 e5                	mov    %esp,%ebp
 34c:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 34f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 356:	00 
 357:	8b 45 08             	mov    0x8(%ebp),%eax
 35a:	89 04 24             	mov    %eax,(%esp)
 35d:	e8 2e 01 00 00       	call   490 <open>
 362:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 365:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 369:	79 07                	jns    372 <stat+0x29>
    return -1;
 36b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 370:	eb 23                	jmp    395 <stat+0x4c>
  r = fstat(fd, st);
 372:	8b 45 0c             	mov    0xc(%ebp),%eax
 375:	89 44 24 04          	mov    %eax,0x4(%esp)
 379:	8b 45 f4             	mov    -0xc(%ebp),%eax
 37c:	89 04 24             	mov    %eax,(%esp)
 37f:	e8 24 01 00 00       	call   4a8 <fstat>
 384:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 387:	8b 45 f4             	mov    -0xc(%ebp),%eax
 38a:	89 04 24             	mov    %eax,(%esp)
 38d:	e8 e6 00 00 00       	call   478 <close>
  return r;
 392:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 395:	c9                   	leave  
 396:	c3                   	ret    

00000397 <atoi>:

int
atoi(const char *s)
{
 397:	55                   	push   %ebp
 398:	89 e5                	mov    %esp,%ebp
 39a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 39d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 3a4:	eb 21                	jmp    3c7 <atoi+0x30>
    n = n*10 + *s++ - '0';
 3a6:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3a9:	89 d0                	mov    %edx,%eax
 3ab:	c1 e0 02             	shl    $0x2,%eax
 3ae:	01 d0                	add    %edx,%eax
 3b0:	d1 e0                	shl    %eax
 3b2:	89 c2                	mov    %eax,%edx
 3b4:	8b 45 08             	mov    0x8(%ebp),%eax
 3b7:	8a 00                	mov    (%eax),%al
 3b9:	0f be c0             	movsbl %al,%eax
 3bc:	01 d0                	add    %edx,%eax
 3be:	83 e8 30             	sub    $0x30,%eax
 3c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
 3c4:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3c7:	8b 45 08             	mov    0x8(%ebp),%eax
 3ca:	8a 00                	mov    (%eax),%al
 3cc:	3c 2f                	cmp    $0x2f,%al
 3ce:	7e 09                	jle    3d9 <atoi+0x42>
 3d0:	8b 45 08             	mov    0x8(%ebp),%eax
 3d3:	8a 00                	mov    (%eax),%al
 3d5:	3c 39                	cmp    $0x39,%al
 3d7:	7e cd                	jle    3a6 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 3d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3dc:	c9                   	leave  
 3dd:	c3                   	ret    

000003de <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3de:	55                   	push   %ebp
 3df:	89 e5                	mov    %esp,%ebp
 3e1:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 3e4:	8b 45 08             	mov    0x8(%ebp),%eax
 3e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3ea:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ed:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3f0:	eb 10                	jmp    402 <memmove+0x24>
    *dst++ = *src++;
 3f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3f5:	8a 10                	mov    (%eax),%dl
 3f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3fa:	88 10                	mov    %dl,(%eax)
 3fc:	ff 45 fc             	incl   -0x4(%ebp)
 3ff:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 402:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 406:	0f 9f c0             	setg   %al
 409:	ff 4d 10             	decl   0x10(%ebp)
 40c:	84 c0                	test   %al,%al
 40e:	75 e2                	jne    3f2 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 410:	8b 45 08             	mov    0x8(%ebp),%eax
}
 413:	c9                   	leave  
 414:	c3                   	ret    

00000415 <trampoline>:
 415:	5a                   	pop    %edx
 416:	59                   	pop    %ecx
 417:	58                   	pop    %eax
 418:	03 25 04 00 00 00    	add    0x4,%esp
 41e:	c9                   	leave  
 41f:	c3                   	ret    

00000420 <signal>:
	"addl 4, %esp\n\t"
	"leave\n\t"
	"ret\n\t"
);
int signal(int signum, sighandler_t handler) 
{
 420:	55                   	push   %ebp
 421:	89 e5                	mov    %esp,%ebp
 423:	83 ec 18             	sub    $0x18,%esp
	register_signal_handler(signum, handler, trampoline);
 426:	c7 44 24 08 15 04 00 	movl   $0x415,0x8(%esp)
 42d:	00 
 42e:	8b 45 0c             	mov    0xc(%ebp),%eax
 431:	89 44 24 04          	mov    %eax,0x4(%esp)
 435:	8b 45 08             	mov    0x8(%ebp),%eax
 438:	89 04 24             	mov    %eax,(%esp)
 43b:	e8 b8 00 00 00       	call   4f8 <register_signal_handler>
	return 0;
 440:	b8 00 00 00 00       	mov    $0x0,%eax
}
 445:	c9                   	leave  
 446:	c3                   	ret    
 447:	90                   	nop

00000448 <fork>:
 448:	b8 01 00 00 00       	mov    $0x1,%eax
 44d:	cd 40                	int    $0x40
 44f:	c3                   	ret    

00000450 <exit>:
 450:	b8 02 00 00 00       	mov    $0x2,%eax
 455:	cd 40                	int    $0x40
 457:	c3                   	ret    

00000458 <wait>:
 458:	b8 03 00 00 00       	mov    $0x3,%eax
 45d:	cd 40                	int    $0x40
 45f:	c3                   	ret    

00000460 <pipe>:
 460:	b8 04 00 00 00       	mov    $0x4,%eax
 465:	cd 40                	int    $0x40
 467:	c3                   	ret    

00000468 <read>:
 468:	b8 05 00 00 00       	mov    $0x5,%eax
 46d:	cd 40                	int    $0x40
 46f:	c3                   	ret    

00000470 <write>:
 470:	b8 10 00 00 00       	mov    $0x10,%eax
 475:	cd 40                	int    $0x40
 477:	c3                   	ret    

00000478 <close>:
 478:	b8 15 00 00 00       	mov    $0x15,%eax
 47d:	cd 40                	int    $0x40
 47f:	c3                   	ret    

00000480 <kill>:
 480:	b8 06 00 00 00       	mov    $0x6,%eax
 485:	cd 40                	int    $0x40
 487:	c3                   	ret    

00000488 <exec>:
 488:	b8 07 00 00 00       	mov    $0x7,%eax
 48d:	cd 40                	int    $0x40
 48f:	c3                   	ret    

00000490 <open>:
 490:	b8 0f 00 00 00       	mov    $0xf,%eax
 495:	cd 40                	int    $0x40
 497:	c3                   	ret    

00000498 <mknod>:
 498:	b8 11 00 00 00       	mov    $0x11,%eax
 49d:	cd 40                	int    $0x40
 49f:	c3                   	ret    

000004a0 <unlink>:
 4a0:	b8 12 00 00 00       	mov    $0x12,%eax
 4a5:	cd 40                	int    $0x40
 4a7:	c3                   	ret    

000004a8 <fstat>:
 4a8:	b8 08 00 00 00       	mov    $0x8,%eax
 4ad:	cd 40                	int    $0x40
 4af:	c3                   	ret    

000004b0 <link>:
 4b0:	b8 13 00 00 00       	mov    $0x13,%eax
 4b5:	cd 40                	int    $0x40
 4b7:	c3                   	ret    

000004b8 <mkdir>:
 4b8:	b8 14 00 00 00       	mov    $0x14,%eax
 4bd:	cd 40                	int    $0x40
 4bf:	c3                   	ret    

000004c0 <chdir>:
 4c0:	b8 09 00 00 00       	mov    $0x9,%eax
 4c5:	cd 40                	int    $0x40
 4c7:	c3                   	ret    

000004c8 <dup>:
 4c8:	b8 0a 00 00 00       	mov    $0xa,%eax
 4cd:	cd 40                	int    $0x40
 4cf:	c3                   	ret    

000004d0 <getpid>:
 4d0:	b8 0b 00 00 00       	mov    $0xb,%eax
 4d5:	cd 40                	int    $0x40
 4d7:	c3                   	ret    

000004d8 <sbrk>:
 4d8:	b8 0c 00 00 00       	mov    $0xc,%eax
 4dd:	cd 40                	int    $0x40
 4df:	c3                   	ret    

000004e0 <sleep>:
 4e0:	b8 0d 00 00 00       	mov    $0xd,%eax
 4e5:	cd 40                	int    $0x40
 4e7:	c3                   	ret    

000004e8 <uptime>:
 4e8:	b8 0e 00 00 00       	mov    $0xe,%eax
 4ed:	cd 40                	int    $0x40
 4ef:	c3                   	ret    

000004f0 <halt>:
 4f0:	b8 16 00 00 00       	mov    $0x16,%eax
 4f5:	cd 40                	int    $0x40
 4f7:	c3                   	ret    

000004f8 <register_signal_handler>:
 4f8:	b8 17 00 00 00       	mov    $0x17,%eax
 4fd:	cd 40                	int    $0x40
 4ff:	c3                   	ret    

00000500 <alarm>:
 500:	b8 18 00 00 00       	mov    $0x18,%eax
 505:	cd 40                	int    $0x40
 507:	c3                   	ret    

00000508 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 508:	55                   	push   %ebp
 509:	89 e5                	mov    %esp,%ebp
 50b:	83 ec 28             	sub    $0x28,%esp
 50e:	8b 45 0c             	mov    0xc(%ebp),%eax
 511:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 514:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 51b:	00 
 51c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 51f:	89 44 24 04          	mov    %eax,0x4(%esp)
 523:	8b 45 08             	mov    0x8(%ebp),%eax
 526:	89 04 24             	mov    %eax,(%esp)
 529:	e8 42 ff ff ff       	call   470 <write>
}
 52e:	c9                   	leave  
 52f:	c3                   	ret    

00000530 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 530:	55                   	push   %ebp
 531:	89 e5                	mov    %esp,%ebp
 533:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 536:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 53d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 541:	74 17                	je     55a <printint+0x2a>
 543:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 547:	79 11                	jns    55a <printint+0x2a>
    neg = 1;
 549:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 550:	8b 45 0c             	mov    0xc(%ebp),%eax
 553:	f7 d8                	neg    %eax
 555:	89 45 ec             	mov    %eax,-0x14(%ebp)
 558:	eb 06                	jmp    560 <printint+0x30>
  } else {
    x = xx;
 55a:	8b 45 0c             	mov    0xc(%ebp),%eax
 55d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 560:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 567:	8b 4d 10             	mov    0x10(%ebp),%ecx
 56a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 56d:	ba 00 00 00 00       	mov    $0x0,%edx
 572:	f7 f1                	div    %ecx
 574:	89 d0                	mov    %edx,%eax
 576:	8a 80 64 0c 00 00    	mov    0xc64(%eax),%al
 57c:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 57f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 582:	01 ca                	add    %ecx,%edx
 584:	88 02                	mov    %al,(%edx)
 586:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 589:	8b 55 10             	mov    0x10(%ebp),%edx
 58c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 58f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 592:	ba 00 00 00 00       	mov    $0x0,%edx
 597:	f7 75 d4             	divl   -0x2c(%ebp)
 59a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 59d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5a1:	75 c4                	jne    567 <printint+0x37>
  if(neg)
 5a3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5a7:	74 2c                	je     5d5 <printint+0xa5>
    buf[i++] = '-';
 5a9:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5af:	01 d0                	add    %edx,%eax
 5b1:	c6 00 2d             	movb   $0x2d,(%eax)
 5b4:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 5b7:	eb 1c                	jmp    5d5 <printint+0xa5>
    putc(fd, buf[i]);
 5b9:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5bf:	01 d0                	add    %edx,%eax
 5c1:	8a 00                	mov    (%eax),%al
 5c3:	0f be c0             	movsbl %al,%eax
 5c6:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ca:	8b 45 08             	mov    0x8(%ebp),%eax
 5cd:	89 04 24             	mov    %eax,(%esp)
 5d0:	e8 33 ff ff ff       	call   508 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5d5:	ff 4d f4             	decl   -0xc(%ebp)
 5d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5dc:	79 db                	jns    5b9 <printint+0x89>
    putc(fd, buf[i]);
}
 5de:	c9                   	leave  
 5df:	c3                   	ret    

000005e0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5e0:	55                   	push   %ebp
 5e1:	89 e5                	mov    %esp,%ebp
 5e3:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5e6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5ed:	8d 45 0c             	lea    0xc(%ebp),%eax
 5f0:	83 c0 04             	add    $0x4,%eax
 5f3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5f6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5fd:	e9 78 01 00 00       	jmp    77a <printf+0x19a>
    c = fmt[i] & 0xff;
 602:	8b 55 0c             	mov    0xc(%ebp),%edx
 605:	8b 45 f0             	mov    -0x10(%ebp),%eax
 608:	01 d0                	add    %edx,%eax
 60a:	8a 00                	mov    (%eax),%al
 60c:	0f be c0             	movsbl %al,%eax
 60f:	25 ff 00 00 00       	and    $0xff,%eax
 614:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 617:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 61b:	75 2c                	jne    649 <printf+0x69>
      if(c == '%'){
 61d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 621:	75 0c                	jne    62f <printf+0x4f>
        state = '%';
 623:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 62a:	e9 48 01 00 00       	jmp    777 <printf+0x197>
      } else {
        putc(fd, c);
 62f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 632:	0f be c0             	movsbl %al,%eax
 635:	89 44 24 04          	mov    %eax,0x4(%esp)
 639:	8b 45 08             	mov    0x8(%ebp),%eax
 63c:	89 04 24             	mov    %eax,(%esp)
 63f:	e8 c4 fe ff ff       	call   508 <putc>
 644:	e9 2e 01 00 00       	jmp    777 <printf+0x197>
      }
    } else if(state == '%'){
 649:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 64d:	0f 85 24 01 00 00    	jne    777 <printf+0x197>
      if(c == 'd'){
 653:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 657:	75 2d                	jne    686 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 659:	8b 45 e8             	mov    -0x18(%ebp),%eax
 65c:	8b 00                	mov    (%eax),%eax
 65e:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 665:	00 
 666:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 66d:	00 
 66e:	89 44 24 04          	mov    %eax,0x4(%esp)
 672:	8b 45 08             	mov    0x8(%ebp),%eax
 675:	89 04 24             	mov    %eax,(%esp)
 678:	e8 b3 fe ff ff       	call   530 <printint>
        ap++;
 67d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 681:	e9 ea 00 00 00       	jmp    770 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 686:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 68a:	74 06                	je     692 <printf+0xb2>
 68c:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 690:	75 2d                	jne    6bf <printf+0xdf>
        printint(fd, *ap, 16, 0);
 692:	8b 45 e8             	mov    -0x18(%ebp),%eax
 695:	8b 00                	mov    (%eax),%eax
 697:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 69e:	00 
 69f:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 6a6:	00 
 6a7:	89 44 24 04          	mov    %eax,0x4(%esp)
 6ab:	8b 45 08             	mov    0x8(%ebp),%eax
 6ae:	89 04 24             	mov    %eax,(%esp)
 6b1:	e8 7a fe ff ff       	call   530 <printint>
        ap++;
 6b6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6ba:	e9 b1 00 00 00       	jmp    770 <printf+0x190>
      } else if(c == 's'){
 6bf:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6c3:	75 43                	jne    708 <printf+0x128>
        s = (char*)*ap;
 6c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6c8:	8b 00                	mov    (%eax),%eax
 6ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6cd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6d5:	75 25                	jne    6fc <printf+0x11c>
          s = "(null)";
 6d7:	c7 45 f4 df 09 00 00 	movl   $0x9df,-0xc(%ebp)
        while(*s != 0){
 6de:	eb 1c                	jmp    6fc <printf+0x11c>
          putc(fd, *s);
 6e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6e3:	8a 00                	mov    (%eax),%al
 6e5:	0f be c0             	movsbl %al,%eax
 6e8:	89 44 24 04          	mov    %eax,0x4(%esp)
 6ec:	8b 45 08             	mov    0x8(%ebp),%eax
 6ef:	89 04 24             	mov    %eax,(%esp)
 6f2:	e8 11 fe ff ff       	call   508 <putc>
          s++;
 6f7:	ff 45 f4             	incl   -0xc(%ebp)
 6fa:	eb 01                	jmp    6fd <printf+0x11d>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6fc:	90                   	nop
 6fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 700:	8a 00                	mov    (%eax),%al
 702:	84 c0                	test   %al,%al
 704:	75 da                	jne    6e0 <printf+0x100>
 706:	eb 68                	jmp    770 <printf+0x190>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 708:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 70c:	75 1d                	jne    72b <printf+0x14b>
        putc(fd, *ap);
 70e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 711:	8b 00                	mov    (%eax),%eax
 713:	0f be c0             	movsbl %al,%eax
 716:	89 44 24 04          	mov    %eax,0x4(%esp)
 71a:	8b 45 08             	mov    0x8(%ebp),%eax
 71d:	89 04 24             	mov    %eax,(%esp)
 720:	e8 e3 fd ff ff       	call   508 <putc>
        ap++;
 725:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 729:	eb 45                	jmp    770 <printf+0x190>
      } else if(c == '%'){
 72b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 72f:	75 17                	jne    748 <printf+0x168>
        putc(fd, c);
 731:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 734:	0f be c0             	movsbl %al,%eax
 737:	89 44 24 04          	mov    %eax,0x4(%esp)
 73b:	8b 45 08             	mov    0x8(%ebp),%eax
 73e:	89 04 24             	mov    %eax,(%esp)
 741:	e8 c2 fd ff ff       	call   508 <putc>
 746:	eb 28                	jmp    770 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 748:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 74f:	00 
 750:	8b 45 08             	mov    0x8(%ebp),%eax
 753:	89 04 24             	mov    %eax,(%esp)
 756:	e8 ad fd ff ff       	call   508 <putc>
        putc(fd, c);
 75b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 75e:	0f be c0             	movsbl %al,%eax
 761:	89 44 24 04          	mov    %eax,0x4(%esp)
 765:	8b 45 08             	mov    0x8(%ebp),%eax
 768:	89 04 24             	mov    %eax,(%esp)
 76b:	e8 98 fd ff ff       	call   508 <putc>
      }
      state = 0;
 770:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 777:	ff 45 f0             	incl   -0x10(%ebp)
 77a:	8b 55 0c             	mov    0xc(%ebp),%edx
 77d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 780:	01 d0                	add    %edx,%eax
 782:	8a 00                	mov    (%eax),%al
 784:	84 c0                	test   %al,%al
 786:	0f 85 76 fe ff ff    	jne    602 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 78c:	c9                   	leave  
 78d:	c3                   	ret    
 78e:	66 90                	xchg   %ax,%ax

00000790 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 790:	55                   	push   %ebp
 791:	89 e5                	mov    %esp,%ebp
 793:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 796:	8b 45 08             	mov    0x8(%ebp),%eax
 799:	83 e8 08             	sub    $0x8,%eax
 79c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 79f:	a1 88 0c 00 00       	mov    0xc88,%eax
 7a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7a7:	eb 24                	jmp    7cd <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ac:	8b 00                	mov    (%eax),%eax
 7ae:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7b1:	77 12                	ja     7c5 <free+0x35>
 7b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7b9:	77 24                	ja     7df <free+0x4f>
 7bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7be:	8b 00                	mov    (%eax),%eax
 7c0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7c3:	77 1a                	ja     7df <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c8:	8b 00                	mov    (%eax),%eax
 7ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7d3:	76 d4                	jbe    7a9 <free+0x19>
 7d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d8:	8b 00                	mov    (%eax),%eax
 7da:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7dd:	76 ca                	jbe    7a9 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7df:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e2:	8b 40 04             	mov    0x4(%eax),%eax
 7e5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ef:	01 c2                	add    %eax,%edx
 7f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f4:	8b 00                	mov    (%eax),%eax
 7f6:	39 c2                	cmp    %eax,%edx
 7f8:	75 24                	jne    81e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7fd:	8b 50 04             	mov    0x4(%eax),%edx
 800:	8b 45 fc             	mov    -0x4(%ebp),%eax
 803:	8b 00                	mov    (%eax),%eax
 805:	8b 40 04             	mov    0x4(%eax),%eax
 808:	01 c2                	add    %eax,%edx
 80a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 80d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 810:	8b 45 fc             	mov    -0x4(%ebp),%eax
 813:	8b 00                	mov    (%eax),%eax
 815:	8b 10                	mov    (%eax),%edx
 817:	8b 45 f8             	mov    -0x8(%ebp),%eax
 81a:	89 10                	mov    %edx,(%eax)
 81c:	eb 0a                	jmp    828 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 81e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 821:	8b 10                	mov    (%eax),%edx
 823:	8b 45 f8             	mov    -0x8(%ebp),%eax
 826:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 828:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82b:	8b 40 04             	mov    0x4(%eax),%eax
 82e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 835:	8b 45 fc             	mov    -0x4(%ebp),%eax
 838:	01 d0                	add    %edx,%eax
 83a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 83d:	75 20                	jne    85f <free+0xcf>
    p->s.size += bp->s.size;
 83f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 842:	8b 50 04             	mov    0x4(%eax),%edx
 845:	8b 45 f8             	mov    -0x8(%ebp),%eax
 848:	8b 40 04             	mov    0x4(%eax),%eax
 84b:	01 c2                	add    %eax,%edx
 84d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 850:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 853:	8b 45 f8             	mov    -0x8(%ebp),%eax
 856:	8b 10                	mov    (%eax),%edx
 858:	8b 45 fc             	mov    -0x4(%ebp),%eax
 85b:	89 10                	mov    %edx,(%eax)
 85d:	eb 08                	jmp    867 <free+0xd7>
  } else
    p->s.ptr = bp;
 85f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 862:	8b 55 f8             	mov    -0x8(%ebp),%edx
 865:	89 10                	mov    %edx,(%eax)
  freep = p;
 867:	8b 45 fc             	mov    -0x4(%ebp),%eax
 86a:	a3 88 0c 00 00       	mov    %eax,0xc88
}
 86f:	c9                   	leave  
 870:	c3                   	ret    

00000871 <morecore>:

static Header*
morecore(uint nu)
{
 871:	55                   	push   %ebp
 872:	89 e5                	mov    %esp,%ebp
 874:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 877:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 87e:	77 07                	ja     887 <morecore+0x16>
    nu = 4096;
 880:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 887:	8b 45 08             	mov    0x8(%ebp),%eax
 88a:	c1 e0 03             	shl    $0x3,%eax
 88d:	89 04 24             	mov    %eax,(%esp)
 890:	e8 43 fc ff ff       	call   4d8 <sbrk>
 895:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 898:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 89c:	75 07                	jne    8a5 <morecore+0x34>
    return 0;
 89e:	b8 00 00 00 00       	mov    $0x0,%eax
 8a3:	eb 22                	jmp    8c7 <morecore+0x56>
  hp = (Header*)p;
 8a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 8ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ae:	8b 55 08             	mov    0x8(%ebp),%edx
 8b1:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b7:	83 c0 08             	add    $0x8,%eax
 8ba:	89 04 24             	mov    %eax,(%esp)
 8bd:	e8 ce fe ff ff       	call   790 <free>
  return freep;
 8c2:	a1 88 0c 00 00       	mov    0xc88,%eax
}
 8c7:	c9                   	leave  
 8c8:	c3                   	ret    

000008c9 <malloc>:

void*
malloc(uint nbytes)
{
 8c9:	55                   	push   %ebp
 8ca:	89 e5                	mov    %esp,%ebp
 8cc:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8cf:	8b 45 08             	mov    0x8(%ebp),%eax
 8d2:	83 c0 07             	add    $0x7,%eax
 8d5:	c1 e8 03             	shr    $0x3,%eax
 8d8:	40                   	inc    %eax
 8d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8dc:	a1 88 0c 00 00       	mov    0xc88,%eax
 8e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8e4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8e8:	75 23                	jne    90d <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 8ea:	c7 45 f0 80 0c 00 00 	movl   $0xc80,-0x10(%ebp)
 8f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8f4:	a3 88 0c 00 00       	mov    %eax,0xc88
 8f9:	a1 88 0c 00 00       	mov    0xc88,%eax
 8fe:	a3 80 0c 00 00       	mov    %eax,0xc80
    base.s.size = 0;
 903:	c7 05 84 0c 00 00 00 	movl   $0x0,0xc84
 90a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 90d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 910:	8b 00                	mov    (%eax),%eax
 912:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 915:	8b 45 f4             	mov    -0xc(%ebp),%eax
 918:	8b 40 04             	mov    0x4(%eax),%eax
 91b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 91e:	72 4d                	jb     96d <malloc+0xa4>
      if(p->s.size == nunits)
 920:	8b 45 f4             	mov    -0xc(%ebp),%eax
 923:	8b 40 04             	mov    0x4(%eax),%eax
 926:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 929:	75 0c                	jne    937 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 92b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 92e:	8b 10                	mov    (%eax),%edx
 930:	8b 45 f0             	mov    -0x10(%ebp),%eax
 933:	89 10                	mov    %edx,(%eax)
 935:	eb 26                	jmp    95d <malloc+0x94>
      else {
        p->s.size -= nunits;
 937:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93a:	8b 40 04             	mov    0x4(%eax),%eax
 93d:	89 c2                	mov    %eax,%edx
 93f:	2b 55 ec             	sub    -0x14(%ebp),%edx
 942:	8b 45 f4             	mov    -0xc(%ebp),%eax
 945:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 948:	8b 45 f4             	mov    -0xc(%ebp),%eax
 94b:	8b 40 04             	mov    0x4(%eax),%eax
 94e:	c1 e0 03             	shl    $0x3,%eax
 951:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 954:	8b 45 f4             	mov    -0xc(%ebp),%eax
 957:	8b 55 ec             	mov    -0x14(%ebp),%edx
 95a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 95d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 960:	a3 88 0c 00 00       	mov    %eax,0xc88
      return (void*)(p + 1);
 965:	8b 45 f4             	mov    -0xc(%ebp),%eax
 968:	83 c0 08             	add    $0x8,%eax
 96b:	eb 38                	jmp    9a5 <malloc+0xdc>
    }
    if(p == freep)
 96d:	a1 88 0c 00 00       	mov    0xc88,%eax
 972:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 975:	75 1b                	jne    992 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 977:	8b 45 ec             	mov    -0x14(%ebp),%eax
 97a:	89 04 24             	mov    %eax,(%esp)
 97d:	e8 ef fe ff ff       	call   871 <morecore>
 982:	89 45 f4             	mov    %eax,-0xc(%ebp)
 985:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 989:	75 07                	jne    992 <malloc+0xc9>
        return 0;
 98b:	b8 00 00 00 00       	mov    $0x0,%eax
 990:	eb 13                	jmp    9a5 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 992:	8b 45 f4             	mov    -0xc(%ebp),%eax
 995:	89 45 f0             	mov    %eax,-0x10(%ebp)
 998:	8b 45 f4             	mov    -0xc(%ebp),%eax
 99b:	8b 00                	mov    (%eax),%eax
 99d:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 9a0:	e9 70 ff ff ff       	jmp    915 <malloc+0x4c>
}
 9a5:	c9                   	leave  
 9a6:	c3                   	ret    
