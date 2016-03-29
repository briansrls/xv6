
_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
   6:	eb 1b                	jmp    23 <cat+0x23>
    write(1, buf, n);
   8:	8b 45 f4             	mov    -0xc(%ebp),%eax
   b:	89 44 24 08          	mov    %eax,0x8(%esp)
   f:	c7 44 24 04 e0 0b 00 	movl   $0xbe0,0x4(%esp)
  16:	00 
  17:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1e:	e8 95 03 00 00       	call   3b8 <write>
void
cat(int fd)
{
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
  23:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  2a:	00 
  2b:	c7 44 24 04 e0 0b 00 	movl   $0xbe0,0x4(%esp)
  32:	00 
  33:	8b 45 08             	mov    0x8(%ebp),%eax
  36:	89 04 24             	mov    %eax,(%esp)
  39:	e8 72 03 00 00       	call   3b0 <read>
  3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  45:	7f c1                	jg     8 <cat+0x8>
    write(1, buf, n);
  if(n < 0){
  47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  4b:	79 19                	jns    66 <cat+0x66>
    printf(1, "cat: read error\n");
  4d:	c7 44 24 04 ef 08 00 	movl   $0x8ef,0x4(%esp)
  54:	00 
  55:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  5c:	e8 c7 04 00 00       	call   528 <printf>
    exit();
  61:	e8 32 03 00 00       	call   398 <exit>
  }
}
  66:	c9                   	leave  
  67:	c3                   	ret    

00000068 <main>:

int
main(int argc, char *argv[])
{
  68:	55                   	push   %ebp
  69:	89 e5                	mov    %esp,%ebp
  6b:	83 e4 f0             	and    $0xfffffff0,%esp
  6e:	83 ec 20             	sub    $0x20,%esp
  int fd, i;

  if(argc <= 1){
  71:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  75:	7f 11                	jg     88 <main+0x20>
    cat(0);
  77:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  7e:	e8 7d ff ff ff       	call   0 <cat>
    exit();
  83:	e8 10 03 00 00       	call   398 <exit>
  }

  for(i = 1; i < argc; i++){
  88:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  8f:	00 
  90:	eb 78                	jmp    10a <main+0xa2>
    if((fd = open(argv[i], 0)) < 0){
  92:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  96:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  a0:	01 d0                	add    %edx,%eax
  a2:	8b 00                	mov    (%eax),%eax
  a4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  ab:	00 
  ac:	89 04 24             	mov    %eax,(%esp)
  af:	e8 24 03 00 00       	call   3d8 <open>
  b4:	89 44 24 18          	mov    %eax,0x18(%esp)
  b8:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  bd:	79 2f                	jns    ee <main+0x86>
      printf(1, "cat: cannot open %s\n", argv[i]);
  bf:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  cd:	01 d0                	add    %edx,%eax
  cf:	8b 00                	mov    (%eax),%eax
  d1:	89 44 24 08          	mov    %eax,0x8(%esp)
  d5:	c7 44 24 04 00 09 00 	movl   $0x900,0x4(%esp)
  dc:	00 
  dd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  e4:	e8 3f 04 00 00       	call   528 <printf>
      exit();
  e9:	e8 aa 02 00 00       	call   398 <exit>
    }
    cat(fd);
  ee:	8b 44 24 18          	mov    0x18(%esp),%eax
  f2:	89 04 24             	mov    %eax,(%esp)
  f5:	e8 06 ff ff ff       	call   0 <cat>
    close(fd);
  fa:	8b 44 24 18          	mov    0x18(%esp),%eax
  fe:	89 04 24             	mov    %eax,(%esp)
 101:	e8 ba 02 00 00       	call   3c0 <close>
  if(argc <= 1){
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
 106:	ff 44 24 1c          	incl   0x1c(%esp)
 10a:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 10e:	3b 45 08             	cmp    0x8(%ebp),%eax
 111:	0f 8c 7b ff ff ff    	jl     92 <main+0x2a>
      exit();
    }
    cat(fd);
    close(fd);
  }
  exit();
 117:	e8 7c 02 00 00       	call   398 <exit>

0000011c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 11c:	55                   	push   %ebp
 11d:	89 e5                	mov    %esp,%ebp
 11f:	57                   	push   %edi
 120:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 121:	8b 4d 08             	mov    0x8(%ebp),%ecx
 124:	8b 55 10             	mov    0x10(%ebp),%edx
 127:	8b 45 0c             	mov    0xc(%ebp),%eax
 12a:	89 cb                	mov    %ecx,%ebx
 12c:	89 df                	mov    %ebx,%edi
 12e:	89 d1                	mov    %edx,%ecx
 130:	fc                   	cld    
 131:	f3 aa                	rep stos %al,%es:(%edi)
 133:	89 ca                	mov    %ecx,%edx
 135:	89 fb                	mov    %edi,%ebx
 137:	89 5d 08             	mov    %ebx,0x8(%ebp)
 13a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 13d:	5b                   	pop    %ebx
 13e:	5f                   	pop    %edi
 13f:	5d                   	pop    %ebp
 140:	c3                   	ret    

00000141 <strcpy>:
#include "x86.h"
#include "signal.h"

char*
strcpy(char *s, char *t)
{
 141:	55                   	push   %ebp
 142:	89 e5                	mov    %esp,%ebp
 144:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 147:	8b 45 08             	mov    0x8(%ebp),%eax
 14a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 14d:	90                   	nop
 14e:	8b 45 0c             	mov    0xc(%ebp),%eax
 151:	8a 10                	mov    (%eax),%dl
 153:	8b 45 08             	mov    0x8(%ebp),%eax
 156:	88 10                	mov    %dl,(%eax)
 158:	8b 45 08             	mov    0x8(%ebp),%eax
 15b:	8a 00                	mov    (%eax),%al
 15d:	84 c0                	test   %al,%al
 15f:	0f 95 c0             	setne  %al
 162:	ff 45 08             	incl   0x8(%ebp)
 165:	ff 45 0c             	incl   0xc(%ebp)
 168:	84 c0                	test   %al,%al
 16a:	75 e2                	jne    14e <strcpy+0xd>
    ;
  return os;
 16c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 16f:	c9                   	leave  
 170:	c3                   	ret    

00000171 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 171:	55                   	push   %ebp
 172:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 174:	eb 06                	jmp    17c <strcmp+0xb>
    p++, q++;
 176:	ff 45 08             	incl   0x8(%ebp)
 179:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 17c:	8b 45 08             	mov    0x8(%ebp),%eax
 17f:	8a 00                	mov    (%eax),%al
 181:	84 c0                	test   %al,%al
 183:	74 0e                	je     193 <strcmp+0x22>
 185:	8b 45 08             	mov    0x8(%ebp),%eax
 188:	8a 10                	mov    (%eax),%dl
 18a:	8b 45 0c             	mov    0xc(%ebp),%eax
 18d:	8a 00                	mov    (%eax),%al
 18f:	38 c2                	cmp    %al,%dl
 191:	74 e3                	je     176 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 193:	8b 45 08             	mov    0x8(%ebp),%eax
 196:	8a 00                	mov    (%eax),%al
 198:	0f b6 d0             	movzbl %al,%edx
 19b:	8b 45 0c             	mov    0xc(%ebp),%eax
 19e:	8a 00                	mov    (%eax),%al
 1a0:	0f b6 c0             	movzbl %al,%eax
 1a3:	89 d1                	mov    %edx,%ecx
 1a5:	29 c1                	sub    %eax,%ecx
 1a7:	89 c8                	mov    %ecx,%eax
}
 1a9:	5d                   	pop    %ebp
 1aa:	c3                   	ret    

000001ab <strlen>:

uint
strlen(char *s)
{
 1ab:	55                   	push   %ebp
 1ac:	89 e5                	mov    %esp,%ebp
 1ae:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1b8:	eb 03                	jmp    1bd <strlen+0x12>
 1ba:	ff 45 fc             	incl   -0x4(%ebp)
 1bd:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1c0:	8b 45 08             	mov    0x8(%ebp),%eax
 1c3:	01 d0                	add    %edx,%eax
 1c5:	8a 00                	mov    (%eax),%al
 1c7:	84 c0                	test   %al,%al
 1c9:	75 ef                	jne    1ba <strlen+0xf>
    ;
  return n;
 1cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1ce:	c9                   	leave  
 1cf:	c3                   	ret    

000001d0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1d6:	8b 45 10             	mov    0x10(%ebp),%eax
 1d9:	89 44 24 08          	mov    %eax,0x8(%esp)
 1dd:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e0:	89 44 24 04          	mov    %eax,0x4(%esp)
 1e4:	8b 45 08             	mov    0x8(%ebp),%eax
 1e7:	89 04 24             	mov    %eax,(%esp)
 1ea:	e8 2d ff ff ff       	call   11c <stosb>
  return dst;
 1ef:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1f2:	c9                   	leave  
 1f3:	c3                   	ret    

000001f4 <strchr>:

char*
strchr(const char *s, char c)
{
 1f4:	55                   	push   %ebp
 1f5:	89 e5                	mov    %esp,%ebp
 1f7:	83 ec 04             	sub    $0x4,%esp
 1fa:	8b 45 0c             	mov    0xc(%ebp),%eax
 1fd:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 200:	eb 12                	jmp    214 <strchr+0x20>
    if(*s == c)
 202:	8b 45 08             	mov    0x8(%ebp),%eax
 205:	8a 00                	mov    (%eax),%al
 207:	3a 45 fc             	cmp    -0x4(%ebp),%al
 20a:	75 05                	jne    211 <strchr+0x1d>
      return (char*)s;
 20c:	8b 45 08             	mov    0x8(%ebp),%eax
 20f:	eb 11                	jmp    222 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 211:	ff 45 08             	incl   0x8(%ebp)
 214:	8b 45 08             	mov    0x8(%ebp),%eax
 217:	8a 00                	mov    (%eax),%al
 219:	84 c0                	test   %al,%al
 21b:	75 e5                	jne    202 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 21d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 222:	c9                   	leave  
 223:	c3                   	ret    

00000224 <gets>:

char*
gets(char *buf, int max)
{
 224:	55                   	push   %ebp
 225:	89 e5                	mov    %esp,%ebp
 227:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 22a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 231:	eb 42                	jmp    275 <gets+0x51>
    cc = read(0, &c, 1);
 233:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 23a:	00 
 23b:	8d 45 ef             	lea    -0x11(%ebp),%eax
 23e:	89 44 24 04          	mov    %eax,0x4(%esp)
 242:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 249:	e8 62 01 00 00       	call   3b0 <read>
 24e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 251:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 255:	7e 29                	jle    280 <gets+0x5c>
      break;
    buf[i++] = c;
 257:	8b 55 f4             	mov    -0xc(%ebp),%edx
 25a:	8b 45 08             	mov    0x8(%ebp),%eax
 25d:	01 c2                	add    %eax,%edx
 25f:	8a 45 ef             	mov    -0x11(%ebp),%al
 262:	88 02                	mov    %al,(%edx)
 264:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 267:	8a 45 ef             	mov    -0x11(%ebp),%al
 26a:	3c 0a                	cmp    $0xa,%al
 26c:	74 13                	je     281 <gets+0x5d>
 26e:	8a 45 ef             	mov    -0x11(%ebp),%al
 271:	3c 0d                	cmp    $0xd,%al
 273:	74 0c                	je     281 <gets+0x5d>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 275:	8b 45 f4             	mov    -0xc(%ebp),%eax
 278:	40                   	inc    %eax
 279:	3b 45 0c             	cmp    0xc(%ebp),%eax
 27c:	7c b5                	jl     233 <gets+0xf>
 27e:	eb 01                	jmp    281 <gets+0x5d>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 280:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 281:	8b 55 f4             	mov    -0xc(%ebp),%edx
 284:	8b 45 08             	mov    0x8(%ebp),%eax
 287:	01 d0                	add    %edx,%eax
 289:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 28c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 28f:	c9                   	leave  
 290:	c3                   	ret    

00000291 <stat>:

int
stat(char *n, struct stat *st)
{
 291:	55                   	push   %ebp
 292:	89 e5                	mov    %esp,%ebp
 294:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 297:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 29e:	00 
 29f:	8b 45 08             	mov    0x8(%ebp),%eax
 2a2:	89 04 24             	mov    %eax,(%esp)
 2a5:	e8 2e 01 00 00       	call   3d8 <open>
 2aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2b1:	79 07                	jns    2ba <stat+0x29>
    return -1;
 2b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2b8:	eb 23                	jmp    2dd <stat+0x4c>
  r = fstat(fd, st);
 2ba:	8b 45 0c             	mov    0xc(%ebp),%eax
 2bd:	89 44 24 04          	mov    %eax,0x4(%esp)
 2c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2c4:	89 04 24             	mov    %eax,(%esp)
 2c7:	e8 24 01 00 00       	call   3f0 <fstat>
 2cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2d2:	89 04 24             	mov    %eax,(%esp)
 2d5:	e8 e6 00 00 00       	call   3c0 <close>
  return r;
 2da:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2dd:	c9                   	leave  
 2de:	c3                   	ret    

000002df <atoi>:

int
atoi(const char *s)
{
 2df:	55                   	push   %ebp
 2e0:	89 e5                	mov    %esp,%ebp
 2e2:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2ec:	eb 21                	jmp    30f <atoi+0x30>
    n = n*10 + *s++ - '0';
 2ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2f1:	89 d0                	mov    %edx,%eax
 2f3:	c1 e0 02             	shl    $0x2,%eax
 2f6:	01 d0                	add    %edx,%eax
 2f8:	d1 e0                	shl    %eax
 2fa:	89 c2                	mov    %eax,%edx
 2fc:	8b 45 08             	mov    0x8(%ebp),%eax
 2ff:	8a 00                	mov    (%eax),%al
 301:	0f be c0             	movsbl %al,%eax
 304:	01 d0                	add    %edx,%eax
 306:	83 e8 30             	sub    $0x30,%eax
 309:	89 45 fc             	mov    %eax,-0x4(%ebp)
 30c:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 30f:	8b 45 08             	mov    0x8(%ebp),%eax
 312:	8a 00                	mov    (%eax),%al
 314:	3c 2f                	cmp    $0x2f,%al
 316:	7e 09                	jle    321 <atoi+0x42>
 318:	8b 45 08             	mov    0x8(%ebp),%eax
 31b:	8a 00                	mov    (%eax),%al
 31d:	3c 39                	cmp    $0x39,%al
 31f:	7e cd                	jle    2ee <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 321:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 324:	c9                   	leave  
 325:	c3                   	ret    

00000326 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 326:	55                   	push   %ebp
 327:	89 e5                	mov    %esp,%ebp
 329:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 32c:	8b 45 08             	mov    0x8(%ebp),%eax
 32f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 332:	8b 45 0c             	mov    0xc(%ebp),%eax
 335:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 338:	eb 10                	jmp    34a <memmove+0x24>
    *dst++ = *src++;
 33a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 33d:	8a 10                	mov    (%eax),%dl
 33f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 342:	88 10                	mov    %dl,(%eax)
 344:	ff 45 fc             	incl   -0x4(%ebp)
 347:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 34a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 34e:	0f 9f c0             	setg   %al
 351:	ff 4d 10             	decl   0x10(%ebp)
 354:	84 c0                	test   %al,%al
 356:	75 e2                	jne    33a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 358:	8b 45 08             	mov    0x8(%ebp),%eax
}
 35b:	c9                   	leave  
 35c:	c3                   	ret    

0000035d <trampoline>:
 35d:	5a                   	pop    %edx
 35e:	59                   	pop    %ecx
 35f:	58                   	pop    %eax
 360:	03 25 04 00 00 00    	add    0x4,%esp
 366:	c9                   	leave  
 367:	c3                   	ret    

00000368 <signal>:
	"addl 4, %esp\n\t"
	"leave\n\t"
	"ret\n\t"
);
int signal(int signum, sighandler_t handler) 
{
 368:	55                   	push   %ebp
 369:	89 e5                	mov    %esp,%ebp
 36b:	83 ec 18             	sub    $0x18,%esp
	register_signal_handler(signum, handler, trampoline);
 36e:	c7 44 24 08 5d 03 00 	movl   $0x35d,0x8(%esp)
 375:	00 
 376:	8b 45 0c             	mov    0xc(%ebp),%eax
 379:	89 44 24 04          	mov    %eax,0x4(%esp)
 37d:	8b 45 08             	mov    0x8(%ebp),%eax
 380:	89 04 24             	mov    %eax,(%esp)
 383:	e8 b8 00 00 00       	call   440 <register_signal_handler>
	return 0;
 388:	b8 00 00 00 00       	mov    $0x0,%eax
}
 38d:	c9                   	leave  
 38e:	c3                   	ret    
 38f:	90                   	nop

00000390 <fork>:
 390:	b8 01 00 00 00       	mov    $0x1,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <exit>:
 398:	b8 02 00 00 00       	mov    $0x2,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <wait>:
 3a0:	b8 03 00 00 00       	mov    $0x3,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <pipe>:
 3a8:	b8 04 00 00 00       	mov    $0x4,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <read>:
 3b0:	b8 05 00 00 00       	mov    $0x5,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <write>:
 3b8:	b8 10 00 00 00       	mov    $0x10,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <close>:
 3c0:	b8 15 00 00 00       	mov    $0x15,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <kill>:
 3c8:	b8 06 00 00 00       	mov    $0x6,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <exec>:
 3d0:	b8 07 00 00 00       	mov    $0x7,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <open>:
 3d8:	b8 0f 00 00 00       	mov    $0xf,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <mknod>:
 3e0:	b8 11 00 00 00       	mov    $0x11,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    

000003e8 <unlink>:
 3e8:	b8 12 00 00 00       	mov    $0x12,%eax
 3ed:	cd 40                	int    $0x40
 3ef:	c3                   	ret    

000003f0 <fstat>:
 3f0:	b8 08 00 00 00       	mov    $0x8,%eax
 3f5:	cd 40                	int    $0x40
 3f7:	c3                   	ret    

000003f8 <link>:
 3f8:	b8 13 00 00 00       	mov    $0x13,%eax
 3fd:	cd 40                	int    $0x40
 3ff:	c3                   	ret    

00000400 <mkdir>:
 400:	b8 14 00 00 00       	mov    $0x14,%eax
 405:	cd 40                	int    $0x40
 407:	c3                   	ret    

00000408 <chdir>:
 408:	b8 09 00 00 00       	mov    $0x9,%eax
 40d:	cd 40                	int    $0x40
 40f:	c3                   	ret    

00000410 <dup>:
 410:	b8 0a 00 00 00       	mov    $0xa,%eax
 415:	cd 40                	int    $0x40
 417:	c3                   	ret    

00000418 <getpid>:
 418:	b8 0b 00 00 00       	mov    $0xb,%eax
 41d:	cd 40                	int    $0x40
 41f:	c3                   	ret    

00000420 <sbrk>:
 420:	b8 0c 00 00 00       	mov    $0xc,%eax
 425:	cd 40                	int    $0x40
 427:	c3                   	ret    

00000428 <sleep>:
 428:	b8 0d 00 00 00       	mov    $0xd,%eax
 42d:	cd 40                	int    $0x40
 42f:	c3                   	ret    

00000430 <uptime>:
 430:	b8 0e 00 00 00       	mov    $0xe,%eax
 435:	cd 40                	int    $0x40
 437:	c3                   	ret    

00000438 <halt>:
 438:	b8 16 00 00 00       	mov    $0x16,%eax
 43d:	cd 40                	int    $0x40
 43f:	c3                   	ret    

00000440 <register_signal_handler>:
 440:	b8 17 00 00 00       	mov    $0x17,%eax
 445:	cd 40                	int    $0x40
 447:	c3                   	ret    

00000448 <alarm>:
 448:	b8 18 00 00 00       	mov    $0x18,%eax
 44d:	cd 40                	int    $0x40
 44f:	c3                   	ret    

00000450 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 450:	55                   	push   %ebp
 451:	89 e5                	mov    %esp,%ebp
 453:	83 ec 28             	sub    $0x28,%esp
 456:	8b 45 0c             	mov    0xc(%ebp),%eax
 459:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 45c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 463:	00 
 464:	8d 45 f4             	lea    -0xc(%ebp),%eax
 467:	89 44 24 04          	mov    %eax,0x4(%esp)
 46b:	8b 45 08             	mov    0x8(%ebp),%eax
 46e:	89 04 24             	mov    %eax,(%esp)
 471:	e8 42 ff ff ff       	call   3b8 <write>
}
 476:	c9                   	leave  
 477:	c3                   	ret    

00000478 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 478:	55                   	push   %ebp
 479:	89 e5                	mov    %esp,%ebp
 47b:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 47e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 485:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 489:	74 17                	je     4a2 <printint+0x2a>
 48b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 48f:	79 11                	jns    4a2 <printint+0x2a>
    neg = 1;
 491:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 498:	8b 45 0c             	mov    0xc(%ebp),%eax
 49b:	f7 d8                	neg    %eax
 49d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4a0:	eb 06                	jmp    4a8 <printint+0x30>
  } else {
    x = xx;
 4a2:	8b 45 0c             	mov    0xc(%ebp),%eax
 4a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4af:	8b 4d 10             	mov    0x10(%ebp),%ecx
 4b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4b5:	ba 00 00 00 00       	mov    $0x0,%edx
 4ba:	f7 f1                	div    %ecx
 4bc:	89 d0                	mov    %edx,%eax
 4be:	8a 80 98 0b 00 00    	mov    0xb98(%eax),%al
 4c4:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 4c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4ca:	01 ca                	add    %ecx,%edx
 4cc:	88 02                	mov    %al,(%edx)
 4ce:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 4d1:	8b 55 10             	mov    0x10(%ebp),%edx
 4d4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 4d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4da:	ba 00 00 00 00       	mov    $0x0,%edx
 4df:	f7 75 d4             	divl   -0x2c(%ebp)
 4e2:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4e5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4e9:	75 c4                	jne    4af <printint+0x37>
  if(neg)
 4eb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4ef:	74 2c                	je     51d <printint+0xa5>
    buf[i++] = '-';
 4f1:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4f7:	01 d0                	add    %edx,%eax
 4f9:	c6 00 2d             	movb   $0x2d,(%eax)
 4fc:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 4ff:	eb 1c                	jmp    51d <printint+0xa5>
    putc(fd, buf[i]);
 501:	8d 55 dc             	lea    -0x24(%ebp),%edx
 504:	8b 45 f4             	mov    -0xc(%ebp),%eax
 507:	01 d0                	add    %edx,%eax
 509:	8a 00                	mov    (%eax),%al
 50b:	0f be c0             	movsbl %al,%eax
 50e:	89 44 24 04          	mov    %eax,0x4(%esp)
 512:	8b 45 08             	mov    0x8(%ebp),%eax
 515:	89 04 24             	mov    %eax,(%esp)
 518:	e8 33 ff ff ff       	call   450 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 51d:	ff 4d f4             	decl   -0xc(%ebp)
 520:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 524:	79 db                	jns    501 <printint+0x89>
    putc(fd, buf[i]);
}
 526:	c9                   	leave  
 527:	c3                   	ret    

00000528 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 528:	55                   	push   %ebp
 529:	89 e5                	mov    %esp,%ebp
 52b:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 52e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 535:	8d 45 0c             	lea    0xc(%ebp),%eax
 538:	83 c0 04             	add    $0x4,%eax
 53b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 53e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 545:	e9 78 01 00 00       	jmp    6c2 <printf+0x19a>
    c = fmt[i] & 0xff;
 54a:	8b 55 0c             	mov    0xc(%ebp),%edx
 54d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 550:	01 d0                	add    %edx,%eax
 552:	8a 00                	mov    (%eax),%al
 554:	0f be c0             	movsbl %al,%eax
 557:	25 ff 00 00 00       	and    $0xff,%eax
 55c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 55f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 563:	75 2c                	jne    591 <printf+0x69>
      if(c == '%'){
 565:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 569:	75 0c                	jne    577 <printf+0x4f>
        state = '%';
 56b:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 572:	e9 48 01 00 00       	jmp    6bf <printf+0x197>
      } else {
        putc(fd, c);
 577:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 57a:	0f be c0             	movsbl %al,%eax
 57d:	89 44 24 04          	mov    %eax,0x4(%esp)
 581:	8b 45 08             	mov    0x8(%ebp),%eax
 584:	89 04 24             	mov    %eax,(%esp)
 587:	e8 c4 fe ff ff       	call   450 <putc>
 58c:	e9 2e 01 00 00       	jmp    6bf <printf+0x197>
      }
    } else if(state == '%'){
 591:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 595:	0f 85 24 01 00 00    	jne    6bf <printf+0x197>
      if(c == 'd'){
 59b:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 59f:	75 2d                	jne    5ce <printf+0xa6>
        printint(fd, *ap, 10, 1);
 5a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5a4:	8b 00                	mov    (%eax),%eax
 5a6:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 5ad:	00 
 5ae:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 5b5:	00 
 5b6:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ba:	8b 45 08             	mov    0x8(%ebp),%eax
 5bd:	89 04 24             	mov    %eax,(%esp)
 5c0:	e8 b3 fe ff ff       	call   478 <printint>
        ap++;
 5c5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5c9:	e9 ea 00 00 00       	jmp    6b8 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 5ce:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5d2:	74 06                	je     5da <printf+0xb2>
 5d4:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5d8:	75 2d                	jne    607 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 5da:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5dd:	8b 00                	mov    (%eax),%eax
 5df:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 5e6:	00 
 5e7:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 5ee:	00 
 5ef:	89 44 24 04          	mov    %eax,0x4(%esp)
 5f3:	8b 45 08             	mov    0x8(%ebp),%eax
 5f6:	89 04 24             	mov    %eax,(%esp)
 5f9:	e8 7a fe ff ff       	call   478 <printint>
        ap++;
 5fe:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 602:	e9 b1 00 00 00       	jmp    6b8 <printf+0x190>
      } else if(c == 's'){
 607:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 60b:	75 43                	jne    650 <printf+0x128>
        s = (char*)*ap;
 60d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 610:	8b 00                	mov    (%eax),%eax
 612:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 615:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 619:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 61d:	75 25                	jne    644 <printf+0x11c>
          s = "(null)";
 61f:	c7 45 f4 15 09 00 00 	movl   $0x915,-0xc(%ebp)
        while(*s != 0){
 626:	eb 1c                	jmp    644 <printf+0x11c>
          putc(fd, *s);
 628:	8b 45 f4             	mov    -0xc(%ebp),%eax
 62b:	8a 00                	mov    (%eax),%al
 62d:	0f be c0             	movsbl %al,%eax
 630:	89 44 24 04          	mov    %eax,0x4(%esp)
 634:	8b 45 08             	mov    0x8(%ebp),%eax
 637:	89 04 24             	mov    %eax,(%esp)
 63a:	e8 11 fe ff ff       	call   450 <putc>
          s++;
 63f:	ff 45 f4             	incl   -0xc(%ebp)
 642:	eb 01                	jmp    645 <printf+0x11d>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 644:	90                   	nop
 645:	8b 45 f4             	mov    -0xc(%ebp),%eax
 648:	8a 00                	mov    (%eax),%al
 64a:	84 c0                	test   %al,%al
 64c:	75 da                	jne    628 <printf+0x100>
 64e:	eb 68                	jmp    6b8 <printf+0x190>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 650:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 654:	75 1d                	jne    673 <printf+0x14b>
        putc(fd, *ap);
 656:	8b 45 e8             	mov    -0x18(%ebp),%eax
 659:	8b 00                	mov    (%eax),%eax
 65b:	0f be c0             	movsbl %al,%eax
 65e:	89 44 24 04          	mov    %eax,0x4(%esp)
 662:	8b 45 08             	mov    0x8(%ebp),%eax
 665:	89 04 24             	mov    %eax,(%esp)
 668:	e8 e3 fd ff ff       	call   450 <putc>
        ap++;
 66d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 671:	eb 45                	jmp    6b8 <printf+0x190>
      } else if(c == '%'){
 673:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 677:	75 17                	jne    690 <printf+0x168>
        putc(fd, c);
 679:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 67c:	0f be c0             	movsbl %al,%eax
 67f:	89 44 24 04          	mov    %eax,0x4(%esp)
 683:	8b 45 08             	mov    0x8(%ebp),%eax
 686:	89 04 24             	mov    %eax,(%esp)
 689:	e8 c2 fd ff ff       	call   450 <putc>
 68e:	eb 28                	jmp    6b8 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 690:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 697:	00 
 698:	8b 45 08             	mov    0x8(%ebp),%eax
 69b:	89 04 24             	mov    %eax,(%esp)
 69e:	e8 ad fd ff ff       	call   450 <putc>
        putc(fd, c);
 6a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6a6:	0f be c0             	movsbl %al,%eax
 6a9:	89 44 24 04          	mov    %eax,0x4(%esp)
 6ad:	8b 45 08             	mov    0x8(%ebp),%eax
 6b0:	89 04 24             	mov    %eax,(%esp)
 6b3:	e8 98 fd ff ff       	call   450 <putc>
      }
      state = 0;
 6b8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6bf:	ff 45 f0             	incl   -0x10(%ebp)
 6c2:	8b 55 0c             	mov    0xc(%ebp),%edx
 6c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6c8:	01 d0                	add    %edx,%eax
 6ca:	8a 00                	mov    (%eax),%al
 6cc:	84 c0                	test   %al,%al
 6ce:	0f 85 76 fe ff ff    	jne    54a <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6d4:	c9                   	leave  
 6d5:	c3                   	ret    
 6d6:	66 90                	xchg   %ax,%ax

000006d8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6d8:	55                   	push   %ebp
 6d9:	89 e5                	mov    %esp,%ebp
 6db:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6de:	8b 45 08             	mov    0x8(%ebp),%eax
 6e1:	83 e8 08             	sub    $0x8,%eax
 6e4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e7:	a1 c8 0b 00 00       	mov    0xbc8,%eax
 6ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6ef:	eb 24                	jmp    715 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f4:	8b 00                	mov    (%eax),%eax
 6f6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6f9:	77 12                	ja     70d <free+0x35>
 6fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fe:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 701:	77 24                	ja     727 <free+0x4f>
 703:	8b 45 fc             	mov    -0x4(%ebp),%eax
 706:	8b 00                	mov    (%eax),%eax
 708:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 70b:	77 1a                	ja     727 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 70d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 710:	8b 00                	mov    (%eax),%eax
 712:	89 45 fc             	mov    %eax,-0x4(%ebp)
 715:	8b 45 f8             	mov    -0x8(%ebp),%eax
 718:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 71b:	76 d4                	jbe    6f1 <free+0x19>
 71d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 720:	8b 00                	mov    (%eax),%eax
 722:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 725:	76 ca                	jbe    6f1 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 727:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72a:	8b 40 04             	mov    0x4(%eax),%eax
 72d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 734:	8b 45 f8             	mov    -0x8(%ebp),%eax
 737:	01 c2                	add    %eax,%edx
 739:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73c:	8b 00                	mov    (%eax),%eax
 73e:	39 c2                	cmp    %eax,%edx
 740:	75 24                	jne    766 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 742:	8b 45 f8             	mov    -0x8(%ebp),%eax
 745:	8b 50 04             	mov    0x4(%eax),%edx
 748:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74b:	8b 00                	mov    (%eax),%eax
 74d:	8b 40 04             	mov    0x4(%eax),%eax
 750:	01 c2                	add    %eax,%edx
 752:	8b 45 f8             	mov    -0x8(%ebp),%eax
 755:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 758:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75b:	8b 00                	mov    (%eax),%eax
 75d:	8b 10                	mov    (%eax),%edx
 75f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 762:	89 10                	mov    %edx,(%eax)
 764:	eb 0a                	jmp    770 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 766:	8b 45 fc             	mov    -0x4(%ebp),%eax
 769:	8b 10                	mov    (%eax),%edx
 76b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 76e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 770:	8b 45 fc             	mov    -0x4(%ebp),%eax
 773:	8b 40 04             	mov    0x4(%eax),%eax
 776:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 77d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 780:	01 d0                	add    %edx,%eax
 782:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 785:	75 20                	jne    7a7 <free+0xcf>
    p->s.size += bp->s.size;
 787:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78a:	8b 50 04             	mov    0x4(%eax),%edx
 78d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 790:	8b 40 04             	mov    0x4(%eax),%eax
 793:	01 c2                	add    %eax,%edx
 795:	8b 45 fc             	mov    -0x4(%ebp),%eax
 798:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 79b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 79e:	8b 10                	mov    (%eax),%edx
 7a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a3:	89 10                	mov    %edx,(%eax)
 7a5:	eb 08                	jmp    7af <free+0xd7>
  } else
    p->s.ptr = bp;
 7a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7aa:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7ad:	89 10                	mov    %edx,(%eax)
  freep = p;
 7af:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b2:	a3 c8 0b 00 00       	mov    %eax,0xbc8
}
 7b7:	c9                   	leave  
 7b8:	c3                   	ret    

000007b9 <morecore>:

static Header*
morecore(uint nu)
{
 7b9:	55                   	push   %ebp
 7ba:	89 e5                	mov    %esp,%ebp
 7bc:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7bf:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7c6:	77 07                	ja     7cf <morecore+0x16>
    nu = 4096;
 7c8:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7cf:	8b 45 08             	mov    0x8(%ebp),%eax
 7d2:	c1 e0 03             	shl    $0x3,%eax
 7d5:	89 04 24             	mov    %eax,(%esp)
 7d8:	e8 43 fc ff ff       	call   420 <sbrk>
 7dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7e0:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7e4:	75 07                	jne    7ed <morecore+0x34>
    return 0;
 7e6:	b8 00 00 00 00       	mov    $0x0,%eax
 7eb:	eb 22                	jmp    80f <morecore+0x56>
  hp = (Header*)p;
 7ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f6:	8b 55 08             	mov    0x8(%ebp),%edx
 7f9:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ff:	83 c0 08             	add    $0x8,%eax
 802:	89 04 24             	mov    %eax,(%esp)
 805:	e8 ce fe ff ff       	call   6d8 <free>
  return freep;
 80a:	a1 c8 0b 00 00       	mov    0xbc8,%eax
}
 80f:	c9                   	leave  
 810:	c3                   	ret    

00000811 <malloc>:

void*
malloc(uint nbytes)
{
 811:	55                   	push   %ebp
 812:	89 e5                	mov    %esp,%ebp
 814:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 817:	8b 45 08             	mov    0x8(%ebp),%eax
 81a:	83 c0 07             	add    $0x7,%eax
 81d:	c1 e8 03             	shr    $0x3,%eax
 820:	40                   	inc    %eax
 821:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 824:	a1 c8 0b 00 00       	mov    0xbc8,%eax
 829:	89 45 f0             	mov    %eax,-0x10(%ebp)
 82c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 830:	75 23                	jne    855 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 832:	c7 45 f0 c0 0b 00 00 	movl   $0xbc0,-0x10(%ebp)
 839:	8b 45 f0             	mov    -0x10(%ebp),%eax
 83c:	a3 c8 0b 00 00       	mov    %eax,0xbc8
 841:	a1 c8 0b 00 00       	mov    0xbc8,%eax
 846:	a3 c0 0b 00 00       	mov    %eax,0xbc0
    base.s.size = 0;
 84b:	c7 05 c4 0b 00 00 00 	movl   $0x0,0xbc4
 852:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 855:	8b 45 f0             	mov    -0x10(%ebp),%eax
 858:	8b 00                	mov    (%eax),%eax
 85a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 85d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 860:	8b 40 04             	mov    0x4(%eax),%eax
 863:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 866:	72 4d                	jb     8b5 <malloc+0xa4>
      if(p->s.size == nunits)
 868:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86b:	8b 40 04             	mov    0x4(%eax),%eax
 86e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 871:	75 0c                	jne    87f <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 873:	8b 45 f4             	mov    -0xc(%ebp),%eax
 876:	8b 10                	mov    (%eax),%edx
 878:	8b 45 f0             	mov    -0x10(%ebp),%eax
 87b:	89 10                	mov    %edx,(%eax)
 87d:	eb 26                	jmp    8a5 <malloc+0x94>
      else {
        p->s.size -= nunits;
 87f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 882:	8b 40 04             	mov    0x4(%eax),%eax
 885:	89 c2                	mov    %eax,%edx
 887:	2b 55 ec             	sub    -0x14(%ebp),%edx
 88a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 890:	8b 45 f4             	mov    -0xc(%ebp),%eax
 893:	8b 40 04             	mov    0x4(%eax),%eax
 896:	c1 e0 03             	shl    $0x3,%eax
 899:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 89c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89f:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8a2:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a8:	a3 c8 0b 00 00       	mov    %eax,0xbc8
      return (void*)(p + 1);
 8ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b0:	83 c0 08             	add    $0x8,%eax
 8b3:	eb 38                	jmp    8ed <malloc+0xdc>
    }
    if(p == freep)
 8b5:	a1 c8 0b 00 00       	mov    0xbc8,%eax
 8ba:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8bd:	75 1b                	jne    8da <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 8bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8c2:	89 04 24             	mov    %eax,(%esp)
 8c5:	e8 ef fe ff ff       	call   7b9 <morecore>
 8ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8d1:	75 07                	jne    8da <malloc+0xc9>
        return 0;
 8d3:	b8 00 00 00 00       	mov    $0x0,%eax
 8d8:	eb 13                	jmp    8ed <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8da:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e3:	8b 00                	mov    (%eax),%eax
 8e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8e8:	e9 70 ff ff ff       	jmp    85d <malloc+0x4c>
}
 8ed:	c9                   	leave  
 8ee:	c3                   	ret    
