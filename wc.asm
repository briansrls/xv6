
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
   6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
   d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10:	89 45 ec             	mov    %eax,-0x14(%ebp)
  13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  16:	89 45 e8             	mov    %eax,-0x18(%ebp)
  inword = 0;
  19:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
  20:	eb 66                	jmp    88 <wc+0x88>
    for(i=0; i<n; i++){
  22:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  29:	eb 55                	jmp    80 <wc+0x80>
      c++;
  2b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      if(buf[i] == '\n')
  2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  32:	0f b6 80 40 0a 00 00 	movzbl 0xa40(%eax),%eax
  39:	3c 0a                	cmp    $0xa,%al
  3b:	75 04                	jne    41 <wc+0x41>
        l++;
  3d:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
      if(strchr(" \r\t\n\v", buf[i]))
  41:	8b 45 e0             	mov    -0x20(%ebp),%eax
  44:	0f b6 80 40 0a 00 00 	movzbl 0xa40(%eax),%eax
  4b:	0f be c0             	movsbl %al,%eax
  4e:	89 44 24 04          	mov    %eax,0x4(%esp)
  52:	c7 04 24 af 09 00 00 	movl   $0x9af,(%esp)
  59:	e8 48 02 00 00       	call   2a6 <strchr>
  5e:	85 c0                	test   %eax,%eax
  60:	74 09                	je     6b <wc+0x6b>
        inword = 0;
  62:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  69:	eb 11                	jmp    7c <wc+0x7c>
      else if(!inword){
  6b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  6f:	75 0b                	jne    7c <wc+0x7c>
        w++;
  71:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
        inword = 1;
  75:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
  7c:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
  80:	8b 45 e0             	mov    -0x20(%ebp),%eax
  83:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  86:	7c a3                	jl     2b <wc+0x2b>
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
  88:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  8f:	00 
  90:	c7 44 24 04 40 0a 00 	movl   $0xa40,0x4(%esp)
  97:	00 
  98:	8b 45 08             	mov    0x8(%ebp),%eax
  9b:	89 04 24             	mov    %eax,(%esp)
  9e:	e8 c9 03 00 00       	call   46c <read>
  a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  a6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  aa:	0f 8f 72 ff ff ff    	jg     22 <wc+0x22>
        w++;
        inword = 1;
      }
    }
  }
  if(n < 0){
  b0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  b4:	79 19                	jns    cf <wc+0xcf>
    printf(1, "wc: read error\n");
  b6:	c7 44 24 04 b5 09 00 	movl   $0x9b5,0x4(%esp)
  bd:	00 
  be:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  c5:	e8 1e 05 00 00       	call   5e8 <printf>
    exit();
  ca:	e8 85 03 00 00       	call   454 <exit>
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
  cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  d2:	89 44 24 14          	mov    %eax,0x14(%esp)
  d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  d9:	89 44 24 10          	mov    %eax,0x10(%esp)
  dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  e0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  e7:	89 44 24 08          	mov    %eax,0x8(%esp)
  eb:	c7 44 24 04 c5 09 00 	movl   $0x9c5,0x4(%esp)
  f2:	00 
  f3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  fa:	e8 e9 04 00 00       	call   5e8 <printf>
}
  ff:	c9                   	leave  
 100:	c3                   	ret    

00000101 <main>:

int
main(int argc, char *argv[])
{
 101:	55                   	push   %ebp
 102:	89 e5                	mov    %esp,%ebp
 104:	83 e4 f0             	and    $0xfffffff0,%esp
 107:	83 ec 20             	sub    $0x20,%esp
  int fd, i;

  if(argc <= 1){
 10a:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 10e:	7f 19                	jg     129 <main+0x28>
    wc(0, "");
 110:	c7 44 24 04 d2 09 00 	movl   $0x9d2,0x4(%esp)
 117:	00 
 118:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 11f:	e8 dc fe ff ff       	call   0 <wc>
    exit();
 124:	e8 2b 03 00 00       	call   454 <exit>
  }

  for(i = 1; i < argc; i++){
 129:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
 130:	00 
 131:	eb 7d                	jmp    1b0 <main+0xaf>
    if((fd = open(argv[i], 0)) < 0){
 133:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 137:	c1 e0 02             	shl    $0x2,%eax
 13a:	03 45 0c             	add    0xc(%ebp),%eax
 13d:	8b 00                	mov    (%eax),%eax
 13f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 146:	00 
 147:	89 04 24             	mov    %eax,(%esp)
 14a:	e8 45 03 00 00       	call   494 <open>
 14f:	89 44 24 18          	mov    %eax,0x18(%esp)
 153:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
 158:	79 29                	jns    183 <main+0x82>
      printf(1, "wc: cannot open %s\n", argv[i]);
 15a:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 15e:	c1 e0 02             	shl    $0x2,%eax
 161:	03 45 0c             	add    0xc(%ebp),%eax
 164:	8b 00                	mov    (%eax),%eax
 166:	89 44 24 08          	mov    %eax,0x8(%esp)
 16a:	c7 44 24 04 d3 09 00 	movl   $0x9d3,0x4(%esp)
 171:	00 
 172:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 179:	e8 6a 04 00 00       	call   5e8 <printf>
      exit();
 17e:	e8 d1 02 00 00       	call   454 <exit>
    }
    wc(fd, argv[i]);
 183:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 187:	c1 e0 02             	shl    $0x2,%eax
 18a:	03 45 0c             	add    0xc(%ebp),%eax
 18d:	8b 00                	mov    (%eax),%eax
 18f:	89 44 24 04          	mov    %eax,0x4(%esp)
 193:	8b 44 24 18          	mov    0x18(%esp),%eax
 197:	89 04 24             	mov    %eax,(%esp)
 19a:	e8 61 fe ff ff       	call   0 <wc>
    close(fd);
 19f:	8b 44 24 18          	mov    0x18(%esp),%eax
 1a3:	89 04 24             	mov    %eax,(%esp)
 1a6:	e8 d1 02 00 00       	call   47c <close>
  if(argc <= 1){
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
 1ab:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
 1b0:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 1b4:	3b 45 08             	cmp    0x8(%ebp),%eax
 1b7:	0f 8c 76 ff ff ff    	jl     133 <main+0x32>
      exit();
    }
    wc(fd, argv[i]);
    close(fd);
  }
  exit();
 1bd:	e8 92 02 00 00       	call   454 <exit>
 1c2:	90                   	nop
 1c3:	90                   	nop

000001c4 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1c4:	55                   	push   %ebp
 1c5:	89 e5                	mov    %esp,%ebp
 1c7:	57                   	push   %edi
 1c8:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1cc:	8b 55 10             	mov    0x10(%ebp),%edx
 1cf:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d2:	89 cb                	mov    %ecx,%ebx
 1d4:	89 df                	mov    %ebx,%edi
 1d6:	89 d1                	mov    %edx,%ecx
 1d8:	fc                   	cld    
 1d9:	f3 aa                	rep stos %al,%es:(%edi)
 1db:	89 ca                	mov    %ecx,%edx
 1dd:	89 fb                	mov    %edi,%ebx
 1df:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1e2:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1e5:	5b                   	pop    %ebx
 1e6:	5f                   	pop    %edi
 1e7:	5d                   	pop    %ebp
 1e8:	c3                   	ret    

000001e9 <strcpy>:
#include "x86.h"
#include "signal.h"

char*
strcpy(char *s, char *t)
{
 1e9:	55                   	push   %ebp
 1ea:	89 e5                	mov    %esp,%ebp
 1ec:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1ef:	8b 45 08             	mov    0x8(%ebp),%eax
 1f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1f5:	8b 45 0c             	mov    0xc(%ebp),%eax
 1f8:	0f b6 10             	movzbl (%eax),%edx
 1fb:	8b 45 08             	mov    0x8(%ebp),%eax
 1fe:	88 10                	mov    %dl,(%eax)
 200:	8b 45 08             	mov    0x8(%ebp),%eax
 203:	0f b6 00             	movzbl (%eax),%eax
 206:	84 c0                	test   %al,%al
 208:	0f 95 c0             	setne  %al
 20b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 20f:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 213:	84 c0                	test   %al,%al
 215:	75 de                	jne    1f5 <strcpy+0xc>
    ;
  return os;
 217:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 21a:	c9                   	leave  
 21b:	c3                   	ret    

0000021c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 21c:	55                   	push   %ebp
 21d:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 21f:	eb 08                	jmp    229 <strcmp+0xd>
    p++, q++;
 221:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 225:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 229:	8b 45 08             	mov    0x8(%ebp),%eax
 22c:	0f b6 00             	movzbl (%eax),%eax
 22f:	84 c0                	test   %al,%al
 231:	74 10                	je     243 <strcmp+0x27>
 233:	8b 45 08             	mov    0x8(%ebp),%eax
 236:	0f b6 10             	movzbl (%eax),%edx
 239:	8b 45 0c             	mov    0xc(%ebp),%eax
 23c:	0f b6 00             	movzbl (%eax),%eax
 23f:	38 c2                	cmp    %al,%dl
 241:	74 de                	je     221 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 243:	8b 45 08             	mov    0x8(%ebp),%eax
 246:	0f b6 00             	movzbl (%eax),%eax
 249:	0f b6 d0             	movzbl %al,%edx
 24c:	8b 45 0c             	mov    0xc(%ebp),%eax
 24f:	0f b6 00             	movzbl (%eax),%eax
 252:	0f b6 c0             	movzbl %al,%eax
 255:	89 d1                	mov    %edx,%ecx
 257:	29 c1                	sub    %eax,%ecx
 259:	89 c8                	mov    %ecx,%eax
}
 25b:	5d                   	pop    %ebp
 25c:	c3                   	ret    

0000025d <strlen>:

uint
strlen(char *s)
{
 25d:	55                   	push   %ebp
 25e:	89 e5                	mov    %esp,%ebp
 260:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 263:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 26a:	eb 04                	jmp    270 <strlen+0x13>
 26c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 270:	8b 45 fc             	mov    -0x4(%ebp),%eax
 273:	03 45 08             	add    0x8(%ebp),%eax
 276:	0f b6 00             	movzbl (%eax),%eax
 279:	84 c0                	test   %al,%al
 27b:	75 ef                	jne    26c <strlen+0xf>
    ;
  return n;
 27d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 280:	c9                   	leave  
 281:	c3                   	ret    

00000282 <memset>:

void*
memset(void *dst, int c, uint n)
{
 282:	55                   	push   %ebp
 283:	89 e5                	mov    %esp,%ebp
 285:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 288:	8b 45 10             	mov    0x10(%ebp),%eax
 28b:	89 44 24 08          	mov    %eax,0x8(%esp)
 28f:	8b 45 0c             	mov    0xc(%ebp),%eax
 292:	89 44 24 04          	mov    %eax,0x4(%esp)
 296:	8b 45 08             	mov    0x8(%ebp),%eax
 299:	89 04 24             	mov    %eax,(%esp)
 29c:	e8 23 ff ff ff       	call   1c4 <stosb>
  return dst;
 2a1:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2a4:	c9                   	leave  
 2a5:	c3                   	ret    

000002a6 <strchr>:

char*
strchr(const char *s, char c)
{
 2a6:	55                   	push   %ebp
 2a7:	89 e5                	mov    %esp,%ebp
 2a9:	83 ec 04             	sub    $0x4,%esp
 2ac:	8b 45 0c             	mov    0xc(%ebp),%eax
 2af:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2b2:	eb 14                	jmp    2c8 <strchr+0x22>
    if(*s == c)
 2b4:	8b 45 08             	mov    0x8(%ebp),%eax
 2b7:	0f b6 00             	movzbl (%eax),%eax
 2ba:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2bd:	75 05                	jne    2c4 <strchr+0x1e>
      return (char*)s;
 2bf:	8b 45 08             	mov    0x8(%ebp),%eax
 2c2:	eb 13                	jmp    2d7 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2c4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2c8:	8b 45 08             	mov    0x8(%ebp),%eax
 2cb:	0f b6 00             	movzbl (%eax),%eax
 2ce:	84 c0                	test   %al,%al
 2d0:	75 e2                	jne    2b4 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2d7:	c9                   	leave  
 2d8:	c3                   	ret    

000002d9 <gets>:

char*
gets(char *buf, int max)
{
 2d9:	55                   	push   %ebp
 2da:	89 e5                	mov    %esp,%ebp
 2dc:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2df:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 2e6:	eb 44                	jmp    32c <gets+0x53>
    cc = read(0, &c, 1);
 2e8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 2ef:	00 
 2f0:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2f3:	89 44 24 04          	mov    %eax,0x4(%esp)
 2f7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 2fe:	e8 69 01 00 00       	call   46c <read>
 303:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(cc < 1)
 306:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 30a:	7e 2d                	jle    339 <gets+0x60>
      break;
    buf[i++] = c;
 30c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 30f:	03 45 08             	add    0x8(%ebp),%eax
 312:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 316:	88 10                	mov    %dl,(%eax)
 318:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    if(c == '\n' || c == '\r')
 31c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 320:	3c 0a                	cmp    $0xa,%al
 322:	74 16                	je     33a <gets+0x61>
 324:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 328:	3c 0d                	cmp    $0xd,%al
 32a:	74 0e                	je     33a <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 32c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 32f:	83 c0 01             	add    $0x1,%eax
 332:	3b 45 0c             	cmp    0xc(%ebp),%eax
 335:	7c b1                	jl     2e8 <gets+0xf>
 337:	eb 01                	jmp    33a <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 339:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 33a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 33d:	03 45 08             	add    0x8(%ebp),%eax
 340:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 343:	8b 45 08             	mov    0x8(%ebp),%eax
}
 346:	c9                   	leave  
 347:	c3                   	ret    

00000348 <stat>:

int
stat(char *n, struct stat *st)
{
 348:	55                   	push   %ebp
 349:	89 e5                	mov    %esp,%ebp
 34b:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 34e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 355:	00 
 356:	8b 45 08             	mov    0x8(%ebp),%eax
 359:	89 04 24             	mov    %eax,(%esp)
 35c:	e8 33 01 00 00       	call   494 <open>
 361:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0)
 364:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 368:	79 07                	jns    371 <stat+0x29>
    return -1;
 36a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 36f:	eb 23                	jmp    394 <stat+0x4c>
  r = fstat(fd, st);
 371:	8b 45 0c             	mov    0xc(%ebp),%eax
 374:	89 44 24 04          	mov    %eax,0x4(%esp)
 378:	8b 45 f0             	mov    -0x10(%ebp),%eax
 37b:	89 04 24             	mov    %eax,(%esp)
 37e:	e8 29 01 00 00       	call   4ac <fstat>
 383:	89 45 f4             	mov    %eax,-0xc(%ebp)
  close(fd);
 386:	8b 45 f0             	mov    -0x10(%ebp),%eax
 389:	89 04 24             	mov    %eax,(%esp)
 38c:	e8 eb 00 00 00       	call   47c <close>
  return r;
 391:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 394:	c9                   	leave  
 395:	c3                   	ret    

00000396 <atoi>:

int
atoi(const char *s)
{
 396:	55                   	push   %ebp
 397:	89 e5                	mov    %esp,%ebp
 399:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 39c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 3a3:	eb 24                	jmp    3c9 <atoi+0x33>
    n = n*10 + *s++ - '0';
 3a5:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3a8:	89 d0                	mov    %edx,%eax
 3aa:	c1 e0 02             	shl    $0x2,%eax
 3ad:	01 d0                	add    %edx,%eax
 3af:	01 c0                	add    %eax,%eax
 3b1:	89 c2                	mov    %eax,%edx
 3b3:	8b 45 08             	mov    0x8(%ebp),%eax
 3b6:	0f b6 00             	movzbl (%eax),%eax
 3b9:	0f be c0             	movsbl %al,%eax
 3bc:	8d 04 02             	lea    (%edx,%eax,1),%eax
 3bf:	83 e8 30             	sub    $0x30,%eax
 3c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 3c5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3c9:	8b 45 08             	mov    0x8(%ebp),%eax
 3cc:	0f b6 00             	movzbl (%eax),%eax
 3cf:	3c 2f                	cmp    $0x2f,%al
 3d1:	7e 0a                	jle    3dd <atoi+0x47>
 3d3:	8b 45 08             	mov    0x8(%ebp),%eax
 3d6:	0f b6 00             	movzbl (%eax),%eax
 3d9:	3c 39                	cmp    $0x39,%al
 3db:	7e c8                	jle    3a5 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 3dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3e0:	c9                   	leave  
 3e1:	c3                   	ret    

000003e2 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3e2:	55                   	push   %ebp
 3e3:	89 e5                	mov    %esp,%ebp
 3e5:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 3e8:	8b 45 08             	mov    0x8(%ebp),%eax
 3eb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  src = vsrc;
 3ee:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0)
 3f4:	eb 13                	jmp    409 <memmove+0x27>
    *dst++ = *src++;
 3f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3f9:	0f b6 10             	movzbl (%eax),%edx
 3fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3ff:	88 10                	mov    %dl,(%eax)
 401:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 405:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 409:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 40d:	0f 9f c0             	setg   %al
 410:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 414:	84 c0                	test   %al,%al
 416:	75 de                	jne    3f6 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 418:	8b 45 08             	mov    0x8(%ebp),%eax
}
 41b:	c9                   	leave  
 41c:	c3                   	ret    

0000041d <trampoline>:
 41d:	5a                   	pop    %edx
 41e:	59                   	pop    %ecx
 41f:	58                   	pop    %eax
 420:	c9                   	leave  
 421:	c3                   	ret    

00000422 <signal>:
//	"addl 4, %esp\n\t"
	"leave\n\t"
	"ret\n\t"
);
int signal(int signum, sighandler_t handler) 
{
 422:	55                   	push   %ebp
 423:	89 e5                	mov    %esp,%ebp
 425:	83 ec 18             	sub    $0x18,%esp
	register_signal_handler(signum, handler, trampoline);
 428:	c7 44 24 08 1d 04 00 	movl   $0x41d,0x8(%esp)
 42f:	00 
 430:	8b 45 0c             	mov    0xc(%ebp),%eax
 433:	89 44 24 04          	mov    %eax,0x4(%esp)
 437:	8b 45 08             	mov    0x8(%ebp),%eax
 43a:	89 04 24             	mov    %eax,(%esp)
 43d:	e8 ba 00 00 00       	call   4fc <register_signal_handler>
	return 0;
 442:	b8 00 00 00 00       	mov    $0x0,%eax
}
 447:	c9                   	leave  
 448:	c3                   	ret    
 449:	90                   	nop
 44a:	90                   	nop
 44b:	90                   	nop

0000044c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 44c:	b8 01 00 00 00       	mov    $0x1,%eax
 451:	cd 40                	int    $0x40
 453:	c3                   	ret    

00000454 <exit>:
SYSCALL(exit)
 454:	b8 02 00 00 00       	mov    $0x2,%eax
 459:	cd 40                	int    $0x40
 45b:	c3                   	ret    

0000045c <wait>:
SYSCALL(wait)
 45c:	b8 03 00 00 00       	mov    $0x3,%eax
 461:	cd 40                	int    $0x40
 463:	c3                   	ret    

00000464 <pipe>:
SYSCALL(pipe)
 464:	b8 04 00 00 00       	mov    $0x4,%eax
 469:	cd 40                	int    $0x40
 46b:	c3                   	ret    

0000046c <read>:
SYSCALL(read)
 46c:	b8 05 00 00 00       	mov    $0x5,%eax
 471:	cd 40                	int    $0x40
 473:	c3                   	ret    

00000474 <write>:
SYSCALL(write)
 474:	b8 10 00 00 00       	mov    $0x10,%eax
 479:	cd 40                	int    $0x40
 47b:	c3                   	ret    

0000047c <close>:
SYSCALL(close)
 47c:	b8 15 00 00 00       	mov    $0x15,%eax
 481:	cd 40                	int    $0x40
 483:	c3                   	ret    

00000484 <kill>:
SYSCALL(kill)
 484:	b8 06 00 00 00       	mov    $0x6,%eax
 489:	cd 40                	int    $0x40
 48b:	c3                   	ret    

0000048c <exec>:
SYSCALL(exec)
 48c:	b8 07 00 00 00       	mov    $0x7,%eax
 491:	cd 40                	int    $0x40
 493:	c3                   	ret    

00000494 <open>:
SYSCALL(open)
 494:	b8 0f 00 00 00       	mov    $0xf,%eax
 499:	cd 40                	int    $0x40
 49b:	c3                   	ret    

0000049c <mknod>:
SYSCALL(mknod)
 49c:	b8 11 00 00 00       	mov    $0x11,%eax
 4a1:	cd 40                	int    $0x40
 4a3:	c3                   	ret    

000004a4 <unlink>:
SYSCALL(unlink)
 4a4:	b8 12 00 00 00       	mov    $0x12,%eax
 4a9:	cd 40                	int    $0x40
 4ab:	c3                   	ret    

000004ac <fstat>:
SYSCALL(fstat)
 4ac:	b8 08 00 00 00       	mov    $0x8,%eax
 4b1:	cd 40                	int    $0x40
 4b3:	c3                   	ret    

000004b4 <link>:
SYSCALL(link)
 4b4:	b8 13 00 00 00       	mov    $0x13,%eax
 4b9:	cd 40                	int    $0x40
 4bb:	c3                   	ret    

000004bc <mkdir>:
SYSCALL(mkdir)
 4bc:	b8 14 00 00 00       	mov    $0x14,%eax
 4c1:	cd 40                	int    $0x40
 4c3:	c3                   	ret    

000004c4 <chdir>:
SYSCALL(chdir)
 4c4:	b8 09 00 00 00       	mov    $0x9,%eax
 4c9:	cd 40                	int    $0x40
 4cb:	c3                   	ret    

000004cc <dup>:
SYSCALL(dup)
 4cc:	b8 0a 00 00 00       	mov    $0xa,%eax
 4d1:	cd 40                	int    $0x40
 4d3:	c3                   	ret    

000004d4 <getpid>:
SYSCALL(getpid)
 4d4:	b8 0b 00 00 00       	mov    $0xb,%eax
 4d9:	cd 40                	int    $0x40
 4db:	c3                   	ret    

000004dc <sbrk>:
SYSCALL(sbrk)
 4dc:	b8 0c 00 00 00       	mov    $0xc,%eax
 4e1:	cd 40                	int    $0x40
 4e3:	c3                   	ret    

000004e4 <sleep>:
SYSCALL(sleep)
 4e4:	b8 0d 00 00 00       	mov    $0xd,%eax
 4e9:	cd 40                	int    $0x40
 4eb:	c3                   	ret    

000004ec <uptime>:
SYSCALL(uptime)
 4ec:	b8 0e 00 00 00       	mov    $0xe,%eax
 4f1:	cd 40                	int    $0x40
 4f3:	c3                   	ret    

000004f4 <halt>:
SYSCALL(halt)
 4f4:	b8 16 00 00 00       	mov    $0x16,%eax
 4f9:	cd 40                	int    $0x40
 4fb:	c3                   	ret    

000004fc <register_signal_handler>:
SYSCALL(register_signal_handler)
 4fc:	b8 17 00 00 00       	mov    $0x17,%eax
 501:	cd 40                	int    $0x40
 503:	c3                   	ret    

00000504 <alarm>:
SYSCALL(alarm)
 504:	b8 18 00 00 00       	mov    $0x18,%eax
 509:	cd 40                	int    $0x40
 50b:	c3                   	ret    

0000050c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 50c:	55                   	push   %ebp
 50d:	89 e5                	mov    %esp,%ebp
 50f:	83 ec 28             	sub    $0x28,%esp
 512:	8b 45 0c             	mov    0xc(%ebp),%eax
 515:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 518:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 51f:	00 
 520:	8d 45 f4             	lea    -0xc(%ebp),%eax
 523:	89 44 24 04          	mov    %eax,0x4(%esp)
 527:	8b 45 08             	mov    0x8(%ebp),%eax
 52a:	89 04 24             	mov    %eax,(%esp)
 52d:	e8 42 ff ff ff       	call   474 <write>
}
 532:	c9                   	leave  
 533:	c3                   	ret    

00000534 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 534:	55                   	push   %ebp
 535:	89 e5                	mov    %esp,%ebp
 537:	53                   	push   %ebx
 538:	83 ec 44             	sub    $0x44,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 53b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 542:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 546:	74 17                	je     55f <printint+0x2b>
 548:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 54c:	79 11                	jns    55f <printint+0x2b>
    neg = 1;
 54e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 555:	8b 45 0c             	mov    0xc(%ebp),%eax
 558:	f7 d8                	neg    %eax
 55a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 55d:	eb 06                	jmp    565 <printint+0x31>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 55f:	8b 45 0c             	mov    0xc(%ebp),%eax
 562:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }

  i = 0;
 565:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  do{
    buf[i++] = digits[x % base];
 56c:	8b 4d ec             	mov    -0x14(%ebp),%ecx
 56f:	8b 5d 10             	mov    0x10(%ebp),%ebx
 572:	8b 45 f4             	mov    -0xc(%ebp),%eax
 575:	ba 00 00 00 00       	mov    $0x0,%edx
 57a:	f7 f3                	div    %ebx
 57c:	89 d0                	mov    %edx,%eax
 57e:	0f b6 80 f0 09 00 00 	movzbl 0x9f0(%eax),%eax
 585:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
 589:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  }while((x /= base) != 0);
 58d:	8b 45 10             	mov    0x10(%ebp),%eax
 590:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 593:	8b 45 f4             	mov    -0xc(%ebp),%eax
 596:	ba 00 00 00 00       	mov    $0x0,%edx
 59b:	f7 75 d4             	divl   -0x2c(%ebp)
 59e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 5a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5a5:	75 c5                	jne    56c <printint+0x38>
  if(neg)
 5a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5ab:	74 2a                	je     5d7 <printint+0xa3>
    buf[i++] = '-';
 5ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5b0:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)
 5b5:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)

  while(--i >= 0)
 5b9:	eb 1d                	jmp    5d8 <printint+0xa4>
    putc(fd, buf[i]);
 5bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5be:	0f b6 44 05 dc       	movzbl -0x24(%ebp,%eax,1),%eax
 5c3:	0f be c0             	movsbl %al,%eax
 5c6:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ca:	8b 45 08             	mov    0x8(%ebp),%eax
 5cd:	89 04 24             	mov    %eax,(%esp)
 5d0:	e8 37 ff ff ff       	call   50c <putc>
 5d5:	eb 01                	jmp    5d8 <printint+0xa4>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5d7:	90                   	nop
 5d8:	83 6d ec 01          	subl   $0x1,-0x14(%ebp)
 5dc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5e0:	79 d9                	jns    5bb <printint+0x87>
    putc(fd, buf[i]);
}
 5e2:	83 c4 44             	add    $0x44,%esp
 5e5:	5b                   	pop    %ebx
 5e6:	5d                   	pop    %ebp
 5e7:	c3                   	ret    

000005e8 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5e8:	55                   	push   %ebp
 5e9:	89 e5                	mov    %esp,%ebp
 5eb:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5ee:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5f5:	8d 45 0c             	lea    0xc(%ebp),%eax
 5f8:	83 c0 04             	add    $0x4,%eax
 5fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i = 0; fmt[i]; i++){
 5fe:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 605:	e9 7e 01 00 00       	jmp    788 <printf+0x1a0>
    c = fmt[i] & 0xff;
 60a:	8b 55 0c             	mov    0xc(%ebp),%edx
 60d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 610:	8d 04 02             	lea    (%edx,%eax,1),%eax
 613:	0f b6 00             	movzbl (%eax),%eax
 616:	0f be c0             	movsbl %al,%eax
 619:	25 ff 00 00 00       	and    $0xff,%eax
 61e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(state == 0){
 621:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 625:	75 2c                	jne    653 <printf+0x6b>
      if(c == '%'){
 627:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 62b:	75 0c                	jne    639 <printf+0x51>
        state = '%';
 62d:	c7 45 f0 25 00 00 00 	movl   $0x25,-0x10(%ebp)
 634:	e9 4b 01 00 00       	jmp    784 <printf+0x19c>
      } else {
        putc(fd, c);
 639:	8b 45 e8             	mov    -0x18(%ebp),%eax
 63c:	0f be c0             	movsbl %al,%eax
 63f:	89 44 24 04          	mov    %eax,0x4(%esp)
 643:	8b 45 08             	mov    0x8(%ebp),%eax
 646:	89 04 24             	mov    %eax,(%esp)
 649:	e8 be fe ff ff       	call   50c <putc>
 64e:	e9 31 01 00 00       	jmp    784 <printf+0x19c>
      }
    } else if(state == '%'){
 653:	83 7d f0 25          	cmpl   $0x25,-0x10(%ebp)
 657:	0f 85 27 01 00 00    	jne    784 <printf+0x19c>
      if(c == 'd'){
 65d:	83 7d e8 64          	cmpl   $0x64,-0x18(%ebp)
 661:	75 2d                	jne    690 <printf+0xa8>
        printint(fd, *ap, 10, 1);
 663:	8b 45 f4             	mov    -0xc(%ebp),%eax
 666:	8b 00                	mov    (%eax),%eax
 668:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 66f:	00 
 670:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 677:	00 
 678:	89 44 24 04          	mov    %eax,0x4(%esp)
 67c:	8b 45 08             	mov    0x8(%ebp),%eax
 67f:	89 04 24             	mov    %eax,(%esp)
 682:	e8 ad fe ff ff       	call   534 <printint>
        ap++;
 687:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 68b:	e9 ed 00 00 00       	jmp    77d <printf+0x195>
      } else if(c == 'x' || c == 'p'){
 690:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
 694:	74 06                	je     69c <printf+0xb4>
 696:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
 69a:	75 2d                	jne    6c9 <printf+0xe1>
        printint(fd, *ap, 16, 0);
 69c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 69f:	8b 00                	mov    (%eax),%eax
 6a1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 6a8:	00 
 6a9:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 6b0:	00 
 6b1:	89 44 24 04          	mov    %eax,0x4(%esp)
 6b5:	8b 45 08             	mov    0x8(%ebp),%eax
 6b8:	89 04 24             	mov    %eax,(%esp)
 6bb:	e8 74 fe ff ff       	call   534 <printint>
        ap++;
 6c0:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 6c4:	e9 b4 00 00 00       	jmp    77d <printf+0x195>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 6c9:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
 6cd:	75 46                	jne    715 <printf+0x12d>
        s = (char*)*ap;
 6cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6d2:	8b 00                	mov    (%eax),%eax
 6d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ap++;
 6d7:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
        if(s == 0)
 6db:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 6df:	75 27                	jne    708 <printf+0x120>
          s = "(null)";
 6e1:	c7 45 e4 e7 09 00 00 	movl   $0x9e7,-0x1c(%ebp)
        while(*s != 0){
 6e8:	eb 1f                	jmp    709 <printf+0x121>
          putc(fd, *s);
 6ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6ed:	0f b6 00             	movzbl (%eax),%eax
 6f0:	0f be c0             	movsbl %al,%eax
 6f3:	89 44 24 04          	mov    %eax,0x4(%esp)
 6f7:	8b 45 08             	mov    0x8(%ebp),%eax
 6fa:	89 04 24             	mov    %eax,(%esp)
 6fd:	e8 0a fe ff ff       	call   50c <putc>
          s++;
 702:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 706:	eb 01                	jmp    709 <printf+0x121>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 708:	90                   	nop
 709:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 70c:	0f b6 00             	movzbl (%eax),%eax
 70f:	84 c0                	test   %al,%al
 711:	75 d7                	jne    6ea <printf+0x102>
 713:	eb 68                	jmp    77d <printf+0x195>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 715:	83 7d e8 63          	cmpl   $0x63,-0x18(%ebp)
 719:	75 1d                	jne    738 <printf+0x150>
        putc(fd, *ap);
 71b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 71e:	8b 00                	mov    (%eax),%eax
 720:	0f be c0             	movsbl %al,%eax
 723:	89 44 24 04          	mov    %eax,0x4(%esp)
 727:	8b 45 08             	mov    0x8(%ebp),%eax
 72a:	89 04 24             	mov    %eax,(%esp)
 72d:	e8 da fd ff ff       	call   50c <putc>
        ap++;
 732:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 736:	eb 45                	jmp    77d <printf+0x195>
      } else if(c == '%'){
 738:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 73c:	75 17                	jne    755 <printf+0x16d>
        putc(fd, c);
 73e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 741:	0f be c0             	movsbl %al,%eax
 744:	89 44 24 04          	mov    %eax,0x4(%esp)
 748:	8b 45 08             	mov    0x8(%ebp),%eax
 74b:	89 04 24             	mov    %eax,(%esp)
 74e:	e8 b9 fd ff ff       	call   50c <putc>
 753:	eb 28                	jmp    77d <printf+0x195>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 755:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 75c:	00 
 75d:	8b 45 08             	mov    0x8(%ebp),%eax
 760:	89 04 24             	mov    %eax,(%esp)
 763:	e8 a4 fd ff ff       	call   50c <putc>
        putc(fd, c);
 768:	8b 45 e8             	mov    -0x18(%ebp),%eax
 76b:	0f be c0             	movsbl %al,%eax
 76e:	89 44 24 04          	mov    %eax,0x4(%esp)
 772:	8b 45 08             	mov    0x8(%ebp),%eax
 775:	89 04 24             	mov    %eax,(%esp)
 778:	e8 8f fd ff ff       	call   50c <putc>
      }
      state = 0;
 77d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 784:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 788:	8b 55 0c             	mov    0xc(%ebp),%edx
 78b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 78e:	8d 04 02             	lea    (%edx,%eax,1),%eax
 791:	0f b6 00             	movzbl (%eax),%eax
 794:	84 c0                	test   %al,%al
 796:	0f 85 6e fe ff ff    	jne    60a <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 79c:	c9                   	leave  
 79d:	c3                   	ret    
 79e:	90                   	nop
 79f:	90                   	nop

000007a0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7a0:	55                   	push   %ebp
 7a1:	89 e5                	mov    %esp,%ebp
 7a3:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7a6:	8b 45 08             	mov    0x8(%ebp),%eax
 7a9:	83 e8 08             	sub    $0x8,%eax
 7ac:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7af:	a1 28 0a 00 00       	mov    0xa28,%eax
 7b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7b7:	eb 24                	jmp    7dd <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7bc:	8b 00                	mov    (%eax),%eax
 7be:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7c1:	77 12                	ja     7d5 <free+0x35>
 7c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7c9:	77 24                	ja     7ef <free+0x4f>
 7cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ce:	8b 00                	mov    (%eax),%eax
 7d0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7d3:	77 1a                	ja     7ef <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d8:	8b 00                	mov    (%eax),%eax
 7da:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7e3:	76 d4                	jbe    7b9 <free+0x19>
 7e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e8:	8b 00                	mov    (%eax),%eax
 7ea:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7ed:	76 ca                	jbe    7b9 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f2:	8b 40 04             	mov    0x4(%eax),%eax
 7f5:	c1 e0 03             	shl    $0x3,%eax
 7f8:	89 c2                	mov    %eax,%edx
 7fa:	03 55 f8             	add    -0x8(%ebp),%edx
 7fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 800:	8b 00                	mov    (%eax),%eax
 802:	39 c2                	cmp    %eax,%edx
 804:	75 24                	jne    82a <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 806:	8b 45 f8             	mov    -0x8(%ebp),%eax
 809:	8b 50 04             	mov    0x4(%eax),%edx
 80c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80f:	8b 00                	mov    (%eax),%eax
 811:	8b 40 04             	mov    0x4(%eax),%eax
 814:	01 c2                	add    %eax,%edx
 816:	8b 45 f8             	mov    -0x8(%ebp),%eax
 819:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 81c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 81f:	8b 00                	mov    (%eax),%eax
 821:	8b 10                	mov    (%eax),%edx
 823:	8b 45 f8             	mov    -0x8(%ebp),%eax
 826:	89 10                	mov    %edx,(%eax)
 828:	eb 0a                	jmp    834 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 82a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82d:	8b 10                	mov    (%eax),%edx
 82f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 832:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 834:	8b 45 fc             	mov    -0x4(%ebp),%eax
 837:	8b 40 04             	mov    0x4(%eax),%eax
 83a:	c1 e0 03             	shl    $0x3,%eax
 83d:	03 45 fc             	add    -0x4(%ebp),%eax
 840:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 843:	75 20                	jne    865 <free+0xc5>
    p->s.size += bp->s.size;
 845:	8b 45 fc             	mov    -0x4(%ebp),%eax
 848:	8b 50 04             	mov    0x4(%eax),%edx
 84b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 84e:	8b 40 04             	mov    0x4(%eax),%eax
 851:	01 c2                	add    %eax,%edx
 853:	8b 45 fc             	mov    -0x4(%ebp),%eax
 856:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 859:	8b 45 f8             	mov    -0x8(%ebp),%eax
 85c:	8b 10                	mov    (%eax),%edx
 85e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 861:	89 10                	mov    %edx,(%eax)
 863:	eb 08                	jmp    86d <free+0xcd>
  } else
    p->s.ptr = bp;
 865:	8b 45 fc             	mov    -0x4(%ebp),%eax
 868:	8b 55 f8             	mov    -0x8(%ebp),%edx
 86b:	89 10                	mov    %edx,(%eax)
  freep = p;
 86d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 870:	a3 28 0a 00 00       	mov    %eax,0xa28
}
 875:	c9                   	leave  
 876:	c3                   	ret    

00000877 <morecore>:

static Header*
morecore(uint nu)
{
 877:	55                   	push   %ebp
 878:	89 e5                	mov    %esp,%ebp
 87a:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 87d:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 884:	77 07                	ja     88d <morecore+0x16>
    nu = 4096;
 886:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 88d:	8b 45 08             	mov    0x8(%ebp),%eax
 890:	c1 e0 03             	shl    $0x3,%eax
 893:	89 04 24             	mov    %eax,(%esp)
 896:	e8 41 fc ff ff       	call   4dc <sbrk>
 89b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(p == (char*)-1)
 89e:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
 8a2:	75 07                	jne    8ab <morecore+0x34>
    return 0;
 8a4:	b8 00 00 00 00       	mov    $0x0,%eax
 8a9:	eb 22                	jmp    8cd <morecore+0x56>
  hp = (Header*)p;
 8ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  hp->s.size = nu;
 8b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b4:	8b 55 08             	mov    0x8(%ebp),%edx
 8b7:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8bd:	83 c0 08             	add    $0x8,%eax
 8c0:	89 04 24             	mov    %eax,(%esp)
 8c3:	e8 d8 fe ff ff       	call   7a0 <free>
  return freep;
 8c8:	a1 28 0a 00 00       	mov    0xa28,%eax
}
 8cd:	c9                   	leave  
 8ce:	c3                   	ret    

000008cf <malloc>:

void*
malloc(uint nbytes)
{
 8cf:	55                   	push   %ebp
 8d0:	89 e5                	mov    %esp,%ebp
 8d2:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8d5:	8b 45 08             	mov    0x8(%ebp),%eax
 8d8:	83 c0 07             	add    $0x7,%eax
 8db:	c1 e8 03             	shr    $0x3,%eax
 8de:	83 c0 01             	add    $0x1,%eax
 8e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((prevp = freep) == 0){
 8e4:	a1 28 0a 00 00       	mov    0xa28,%eax
 8e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8f0:	75 23                	jne    915 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8f2:	c7 45 f0 20 0a 00 00 	movl   $0xa20,-0x10(%ebp)
 8f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8fc:	a3 28 0a 00 00       	mov    %eax,0xa28
 901:	a1 28 0a 00 00       	mov    0xa28,%eax
 906:	a3 20 0a 00 00       	mov    %eax,0xa20
    base.s.size = 0;
 90b:	c7 05 24 0a 00 00 00 	movl   $0x0,0xa24
 912:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 915:	8b 45 f0             	mov    -0x10(%ebp),%eax
 918:	8b 00                	mov    (%eax),%eax
 91a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(p->s.size >= nunits){
 91d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 920:	8b 40 04             	mov    0x4(%eax),%eax
 923:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 926:	72 4d                	jb     975 <malloc+0xa6>
      if(p->s.size == nunits)
 928:	8b 45 ec             	mov    -0x14(%ebp),%eax
 92b:	8b 40 04             	mov    0x4(%eax),%eax
 92e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 931:	75 0c                	jne    93f <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 933:	8b 45 ec             	mov    -0x14(%ebp),%eax
 936:	8b 10                	mov    (%eax),%edx
 938:	8b 45 f0             	mov    -0x10(%ebp),%eax
 93b:	89 10                	mov    %edx,(%eax)
 93d:	eb 26                	jmp    965 <malloc+0x96>
      else {
        p->s.size -= nunits;
 93f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 942:	8b 40 04             	mov    0x4(%eax),%eax
 945:	89 c2                	mov    %eax,%edx
 947:	2b 55 f4             	sub    -0xc(%ebp),%edx
 94a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 94d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 950:	8b 45 ec             	mov    -0x14(%ebp),%eax
 953:	8b 40 04             	mov    0x4(%eax),%eax
 956:	c1 e0 03             	shl    $0x3,%eax
 959:	01 45 ec             	add    %eax,-0x14(%ebp)
        p->s.size = nunits;
 95c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 95f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 962:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 965:	8b 45 f0             	mov    -0x10(%ebp),%eax
 968:	a3 28 0a 00 00       	mov    %eax,0xa28
      return (void*)(p + 1);
 96d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 970:	83 c0 08             	add    $0x8,%eax
 973:	eb 38                	jmp    9ad <malloc+0xde>
    }
    if(p == freep)
 975:	a1 28 0a 00 00       	mov    0xa28,%eax
 97a:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 97d:	75 1b                	jne    99a <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 97f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 982:	89 04 24             	mov    %eax,(%esp)
 985:	e8 ed fe ff ff       	call   877 <morecore>
 98a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 98d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 991:	75 07                	jne    99a <malloc+0xcb>
        return 0;
 993:	b8 00 00 00 00       	mov    $0x0,%eax
 998:	eb 13                	jmp    9ad <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 99a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 99d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 9a3:	8b 00                	mov    (%eax),%eax
 9a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 9a8:	e9 70 ff ff ff       	jmp    91d <malloc+0x4e>
}
 9ad:	c9                   	leave  
 9ae:	c3                   	ret    
