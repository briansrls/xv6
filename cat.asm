
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
   f:	c7 44 24 04 60 09 00 	movl   $0x960,0x4(%esp)
  16:	00 
  17:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1e:	e8 9d 03 00 00       	call   3c0 <write>
void
cat(int fd)
{
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
  23:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  2a:	00 
  2b:	c7 44 24 04 60 09 00 	movl   $0x960,0x4(%esp)
  32:	00 
  33:	8b 45 08             	mov    0x8(%ebp),%eax
  36:	89 04 24             	mov    %eax,(%esp)
  39:	e8 7a 03 00 00       	call   3b8 <read>
  3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  45:	7f c1                	jg     8 <cat+0x8>
    write(1, buf, n);
  if(n < 0){
  47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  4b:	79 19                	jns    66 <cat+0x66>
    printf(1, "cat: read error\n");
  4d:	c7 44 24 04 fb 08 00 	movl   $0x8fb,0x4(%esp)
  54:	00 
  55:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  5c:	e8 d3 04 00 00       	call   534 <printf>
    exit();
  61:	e8 3a 03 00 00       	call   3a0 <exit>
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
  83:	e8 18 03 00 00       	call   3a0 <exit>
  }

  for(i = 1; i < argc; i++){
  88:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  8f:	00 
  90:	eb 6d                	jmp    ff <main+0x97>
    if((fd = open(argv[i], 0)) < 0){
  92:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  96:	c1 e0 02             	shl    $0x2,%eax
  99:	03 45 0c             	add    0xc(%ebp),%eax
  9c:	8b 00                	mov    (%eax),%eax
  9e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  a5:	00 
  a6:	89 04 24             	mov    %eax,(%esp)
  a9:	e8 32 03 00 00       	call   3e0 <open>
  ae:	89 44 24 18          	mov    %eax,0x18(%esp)
  b2:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  b7:	79 29                	jns    e2 <main+0x7a>
      printf(1, "cat: cannot open %s\n", argv[i]);
  b9:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  bd:	c1 e0 02             	shl    $0x2,%eax
  c0:	03 45 0c             	add    0xc(%ebp),%eax
  c3:	8b 00                	mov    (%eax),%eax
  c5:	89 44 24 08          	mov    %eax,0x8(%esp)
  c9:	c7 44 24 04 0c 09 00 	movl   $0x90c,0x4(%esp)
  d0:	00 
  d1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  d8:	e8 57 04 00 00       	call   534 <printf>
      exit();
  dd:	e8 be 02 00 00       	call   3a0 <exit>
    }
    cat(fd);
  e2:	8b 44 24 18          	mov    0x18(%esp),%eax
  e6:	89 04 24             	mov    %eax,(%esp)
  e9:	e8 12 ff ff ff       	call   0 <cat>
    close(fd);
  ee:	8b 44 24 18          	mov    0x18(%esp),%eax
  f2:	89 04 24             	mov    %eax,(%esp)
  f5:	e8 ce 02 00 00       	call   3c8 <close>
  if(argc <= 1){
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
  fa:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  ff:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 103:	3b 45 08             	cmp    0x8(%ebp),%eax
 106:	7c 8a                	jl     92 <main+0x2a>
      exit();
    }
    cat(fd);
    close(fd);
  }
  exit();
 108:	e8 93 02 00 00       	call   3a0 <exit>
 10d:	90                   	nop
 10e:	90                   	nop
 10f:	90                   	nop

00000110 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	57                   	push   %edi
 114:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 115:	8b 4d 08             	mov    0x8(%ebp),%ecx
 118:	8b 55 10             	mov    0x10(%ebp),%edx
 11b:	8b 45 0c             	mov    0xc(%ebp),%eax
 11e:	89 cb                	mov    %ecx,%ebx
 120:	89 df                	mov    %ebx,%edi
 122:	89 d1                	mov    %edx,%ecx
 124:	fc                   	cld    
 125:	f3 aa                	rep stos %al,%es:(%edi)
 127:	89 ca                	mov    %ecx,%edx
 129:	89 fb                	mov    %edi,%ebx
 12b:	89 5d 08             	mov    %ebx,0x8(%ebp)
 12e:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 131:	5b                   	pop    %ebx
 132:	5f                   	pop    %edi
 133:	5d                   	pop    %ebp
 134:	c3                   	ret    

00000135 <strcpy>:
#include "x86.h"
#include "signal.h"

char*
strcpy(char *s, char *t)
{
 135:	55                   	push   %ebp
 136:	89 e5                	mov    %esp,%ebp
 138:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 13b:	8b 45 08             	mov    0x8(%ebp),%eax
 13e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 141:	8b 45 0c             	mov    0xc(%ebp),%eax
 144:	0f b6 10             	movzbl (%eax),%edx
 147:	8b 45 08             	mov    0x8(%ebp),%eax
 14a:	88 10                	mov    %dl,(%eax)
 14c:	8b 45 08             	mov    0x8(%ebp),%eax
 14f:	0f b6 00             	movzbl (%eax),%eax
 152:	84 c0                	test   %al,%al
 154:	0f 95 c0             	setne  %al
 157:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 15b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 15f:	84 c0                	test   %al,%al
 161:	75 de                	jne    141 <strcpy+0xc>
    ;
  return os;
 163:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 166:	c9                   	leave  
 167:	c3                   	ret    

00000168 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 168:	55                   	push   %ebp
 169:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 16b:	eb 08                	jmp    175 <strcmp+0xd>
    p++, q++;
 16d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 171:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 175:	8b 45 08             	mov    0x8(%ebp),%eax
 178:	0f b6 00             	movzbl (%eax),%eax
 17b:	84 c0                	test   %al,%al
 17d:	74 10                	je     18f <strcmp+0x27>
 17f:	8b 45 08             	mov    0x8(%ebp),%eax
 182:	0f b6 10             	movzbl (%eax),%edx
 185:	8b 45 0c             	mov    0xc(%ebp),%eax
 188:	0f b6 00             	movzbl (%eax),%eax
 18b:	38 c2                	cmp    %al,%dl
 18d:	74 de                	je     16d <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 18f:	8b 45 08             	mov    0x8(%ebp),%eax
 192:	0f b6 00             	movzbl (%eax),%eax
 195:	0f b6 d0             	movzbl %al,%edx
 198:	8b 45 0c             	mov    0xc(%ebp),%eax
 19b:	0f b6 00             	movzbl (%eax),%eax
 19e:	0f b6 c0             	movzbl %al,%eax
 1a1:	89 d1                	mov    %edx,%ecx
 1a3:	29 c1                	sub    %eax,%ecx
 1a5:	89 c8                	mov    %ecx,%eax
}
 1a7:	5d                   	pop    %ebp
 1a8:	c3                   	ret    

000001a9 <strlen>:

uint
strlen(char *s)
{
 1a9:	55                   	push   %ebp
 1aa:	89 e5                	mov    %esp,%ebp
 1ac:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1b6:	eb 04                	jmp    1bc <strlen+0x13>
 1b8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 1bf:	03 45 08             	add    0x8(%ebp),%eax
 1c2:	0f b6 00             	movzbl (%eax),%eax
 1c5:	84 c0                	test   %al,%al
 1c7:	75 ef                	jne    1b8 <strlen+0xf>
    ;
  return n;
 1c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1cc:	c9                   	leave  
 1cd:	c3                   	ret    

000001ce <memset>:

void*
memset(void *dst, int c, uint n)
{
 1ce:	55                   	push   %ebp
 1cf:	89 e5                	mov    %esp,%ebp
 1d1:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1d4:	8b 45 10             	mov    0x10(%ebp),%eax
 1d7:	89 44 24 08          	mov    %eax,0x8(%esp)
 1db:	8b 45 0c             	mov    0xc(%ebp),%eax
 1de:	89 44 24 04          	mov    %eax,0x4(%esp)
 1e2:	8b 45 08             	mov    0x8(%ebp),%eax
 1e5:	89 04 24             	mov    %eax,(%esp)
 1e8:	e8 23 ff ff ff       	call   110 <stosb>
  return dst;
 1ed:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1f0:	c9                   	leave  
 1f1:	c3                   	ret    

000001f2 <strchr>:

char*
strchr(const char *s, char c)
{
 1f2:	55                   	push   %ebp
 1f3:	89 e5                	mov    %esp,%ebp
 1f5:	83 ec 04             	sub    $0x4,%esp
 1f8:	8b 45 0c             	mov    0xc(%ebp),%eax
 1fb:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1fe:	eb 14                	jmp    214 <strchr+0x22>
    if(*s == c)
 200:	8b 45 08             	mov    0x8(%ebp),%eax
 203:	0f b6 00             	movzbl (%eax),%eax
 206:	3a 45 fc             	cmp    -0x4(%ebp),%al
 209:	75 05                	jne    210 <strchr+0x1e>
      return (char*)s;
 20b:	8b 45 08             	mov    0x8(%ebp),%eax
 20e:	eb 13                	jmp    223 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 210:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 214:	8b 45 08             	mov    0x8(%ebp),%eax
 217:	0f b6 00             	movzbl (%eax),%eax
 21a:	84 c0                	test   %al,%al
 21c:	75 e2                	jne    200 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 21e:	b8 00 00 00 00       	mov    $0x0,%eax
}
 223:	c9                   	leave  
 224:	c3                   	ret    

00000225 <gets>:

char*
gets(char *buf, int max)
{
 225:	55                   	push   %ebp
 226:	89 e5                	mov    %esp,%ebp
 228:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 22b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 232:	eb 44                	jmp    278 <gets+0x53>
    cc = read(0, &c, 1);
 234:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 23b:	00 
 23c:	8d 45 ef             	lea    -0x11(%ebp),%eax
 23f:	89 44 24 04          	mov    %eax,0x4(%esp)
 243:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 24a:	e8 69 01 00 00       	call   3b8 <read>
 24f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(cc < 1)
 252:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 256:	7e 2d                	jle    285 <gets+0x60>
      break;
    buf[i++] = c;
 258:	8b 45 f0             	mov    -0x10(%ebp),%eax
 25b:	03 45 08             	add    0x8(%ebp),%eax
 25e:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 262:	88 10                	mov    %dl,(%eax)
 264:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    if(c == '\n' || c == '\r')
 268:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 26c:	3c 0a                	cmp    $0xa,%al
 26e:	74 16                	je     286 <gets+0x61>
 270:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 274:	3c 0d                	cmp    $0xd,%al
 276:	74 0e                	je     286 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 278:	8b 45 f0             	mov    -0x10(%ebp),%eax
 27b:	83 c0 01             	add    $0x1,%eax
 27e:	3b 45 0c             	cmp    0xc(%ebp),%eax
 281:	7c b1                	jl     234 <gets+0xf>
 283:	eb 01                	jmp    286 <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 285:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 286:	8b 45 f0             	mov    -0x10(%ebp),%eax
 289:	03 45 08             	add    0x8(%ebp),%eax
 28c:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 28f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 292:	c9                   	leave  
 293:	c3                   	ret    

00000294 <stat>:

int
stat(char *n, struct stat *st)
{
 294:	55                   	push   %ebp
 295:	89 e5                	mov    %esp,%ebp
 297:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 29a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2a1:	00 
 2a2:	8b 45 08             	mov    0x8(%ebp),%eax
 2a5:	89 04 24             	mov    %eax,(%esp)
 2a8:	e8 33 01 00 00       	call   3e0 <open>
 2ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0)
 2b0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2b4:	79 07                	jns    2bd <stat+0x29>
    return -1;
 2b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2bb:	eb 23                	jmp    2e0 <stat+0x4c>
  r = fstat(fd, st);
 2bd:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c0:	89 44 24 04          	mov    %eax,0x4(%esp)
 2c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 2c7:	89 04 24             	mov    %eax,(%esp)
 2ca:	e8 29 01 00 00       	call   3f8 <fstat>
 2cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  close(fd);
 2d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 2d5:	89 04 24             	mov    %eax,(%esp)
 2d8:	e8 eb 00 00 00       	call   3c8 <close>
  return r;
 2dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 2e0:	c9                   	leave  
 2e1:	c3                   	ret    

000002e2 <atoi>:

int
atoi(const char *s)
{
 2e2:	55                   	push   %ebp
 2e3:	89 e5                	mov    %esp,%ebp
 2e5:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2ef:	eb 24                	jmp    315 <atoi+0x33>
    n = n*10 + *s++ - '0';
 2f1:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2f4:	89 d0                	mov    %edx,%eax
 2f6:	c1 e0 02             	shl    $0x2,%eax
 2f9:	01 d0                	add    %edx,%eax
 2fb:	01 c0                	add    %eax,%eax
 2fd:	89 c2                	mov    %eax,%edx
 2ff:	8b 45 08             	mov    0x8(%ebp),%eax
 302:	0f b6 00             	movzbl (%eax),%eax
 305:	0f be c0             	movsbl %al,%eax
 308:	8d 04 02             	lea    (%edx,%eax,1),%eax
 30b:	83 e8 30             	sub    $0x30,%eax
 30e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 311:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 315:	8b 45 08             	mov    0x8(%ebp),%eax
 318:	0f b6 00             	movzbl (%eax),%eax
 31b:	3c 2f                	cmp    $0x2f,%al
 31d:	7e 0a                	jle    329 <atoi+0x47>
 31f:	8b 45 08             	mov    0x8(%ebp),%eax
 322:	0f b6 00             	movzbl (%eax),%eax
 325:	3c 39                	cmp    $0x39,%al
 327:	7e c8                	jle    2f1 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 329:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 32c:	c9                   	leave  
 32d:	c3                   	ret    

0000032e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 32e:	55                   	push   %ebp
 32f:	89 e5                	mov    %esp,%ebp
 331:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 334:	8b 45 08             	mov    0x8(%ebp),%eax
 337:	89 45 f8             	mov    %eax,-0x8(%ebp)
  src = vsrc;
 33a:	8b 45 0c             	mov    0xc(%ebp),%eax
 33d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0)
 340:	eb 13                	jmp    355 <memmove+0x27>
    *dst++ = *src++;
 342:	8b 45 fc             	mov    -0x4(%ebp),%eax
 345:	0f b6 10             	movzbl (%eax),%edx
 348:	8b 45 f8             	mov    -0x8(%ebp),%eax
 34b:	88 10                	mov    %dl,(%eax)
 34d:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 351:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 355:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 359:	0f 9f c0             	setg   %al
 35c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 360:	84 c0                	test   %al,%al
 362:	75 de                	jne    342 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 364:	8b 45 08             	mov    0x8(%ebp),%eax
}
 367:	c9                   	leave  
 368:	c3                   	ret    

00000369 <trampoline>:
 369:	5a                   	pop    %edx
 36a:	59                   	pop    %ecx
 36b:	58                   	pop    %eax
 36c:	c9                   	leave  
 36d:	c3                   	ret    

0000036e <signal>:
//	"addl 4, %esp\n\t"
	"leave\n\t"
	"ret\n\t"
);
int signal(int signum, sighandler_t handler) 
{
 36e:	55                   	push   %ebp
 36f:	89 e5                	mov    %esp,%ebp
 371:	83 ec 18             	sub    $0x18,%esp
	register_signal_handler(signum, handler, trampoline);
 374:	c7 44 24 08 69 03 00 	movl   $0x369,0x8(%esp)
 37b:	00 
 37c:	8b 45 0c             	mov    0xc(%ebp),%eax
 37f:	89 44 24 04          	mov    %eax,0x4(%esp)
 383:	8b 45 08             	mov    0x8(%ebp),%eax
 386:	89 04 24             	mov    %eax,(%esp)
 389:	e8 ba 00 00 00       	call   448 <register_signal_handler>
	return 0;
 38e:	b8 00 00 00 00       	mov    $0x0,%eax
}
 393:	c9                   	leave  
 394:	c3                   	ret    
 395:	90                   	nop
 396:	90                   	nop
 397:	90                   	nop

00000398 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 398:	b8 01 00 00 00       	mov    $0x1,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <exit>:
SYSCALL(exit)
 3a0:	b8 02 00 00 00       	mov    $0x2,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <wait>:
SYSCALL(wait)
 3a8:	b8 03 00 00 00       	mov    $0x3,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <pipe>:
SYSCALL(pipe)
 3b0:	b8 04 00 00 00       	mov    $0x4,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <read>:
SYSCALL(read)
 3b8:	b8 05 00 00 00       	mov    $0x5,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <write>:
SYSCALL(write)
 3c0:	b8 10 00 00 00       	mov    $0x10,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <close>:
SYSCALL(close)
 3c8:	b8 15 00 00 00       	mov    $0x15,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <kill>:
SYSCALL(kill)
 3d0:	b8 06 00 00 00       	mov    $0x6,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <exec>:
SYSCALL(exec)
 3d8:	b8 07 00 00 00       	mov    $0x7,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <open>:
SYSCALL(open)
 3e0:	b8 0f 00 00 00       	mov    $0xf,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    

000003e8 <mknod>:
SYSCALL(mknod)
 3e8:	b8 11 00 00 00       	mov    $0x11,%eax
 3ed:	cd 40                	int    $0x40
 3ef:	c3                   	ret    

000003f0 <unlink>:
SYSCALL(unlink)
 3f0:	b8 12 00 00 00       	mov    $0x12,%eax
 3f5:	cd 40                	int    $0x40
 3f7:	c3                   	ret    

000003f8 <fstat>:
SYSCALL(fstat)
 3f8:	b8 08 00 00 00       	mov    $0x8,%eax
 3fd:	cd 40                	int    $0x40
 3ff:	c3                   	ret    

00000400 <link>:
SYSCALL(link)
 400:	b8 13 00 00 00       	mov    $0x13,%eax
 405:	cd 40                	int    $0x40
 407:	c3                   	ret    

00000408 <mkdir>:
SYSCALL(mkdir)
 408:	b8 14 00 00 00       	mov    $0x14,%eax
 40d:	cd 40                	int    $0x40
 40f:	c3                   	ret    

00000410 <chdir>:
SYSCALL(chdir)
 410:	b8 09 00 00 00       	mov    $0x9,%eax
 415:	cd 40                	int    $0x40
 417:	c3                   	ret    

00000418 <dup>:
SYSCALL(dup)
 418:	b8 0a 00 00 00       	mov    $0xa,%eax
 41d:	cd 40                	int    $0x40
 41f:	c3                   	ret    

00000420 <getpid>:
SYSCALL(getpid)
 420:	b8 0b 00 00 00       	mov    $0xb,%eax
 425:	cd 40                	int    $0x40
 427:	c3                   	ret    

00000428 <sbrk>:
SYSCALL(sbrk)
 428:	b8 0c 00 00 00       	mov    $0xc,%eax
 42d:	cd 40                	int    $0x40
 42f:	c3                   	ret    

00000430 <sleep>:
SYSCALL(sleep)
 430:	b8 0d 00 00 00       	mov    $0xd,%eax
 435:	cd 40                	int    $0x40
 437:	c3                   	ret    

00000438 <uptime>:
SYSCALL(uptime)
 438:	b8 0e 00 00 00       	mov    $0xe,%eax
 43d:	cd 40                	int    $0x40
 43f:	c3                   	ret    

00000440 <halt>:
SYSCALL(halt)
 440:	b8 16 00 00 00       	mov    $0x16,%eax
 445:	cd 40                	int    $0x40
 447:	c3                   	ret    

00000448 <register_signal_handler>:
SYSCALL(register_signal_handler)
 448:	b8 17 00 00 00       	mov    $0x17,%eax
 44d:	cd 40                	int    $0x40
 44f:	c3                   	ret    

00000450 <alarm>:
SYSCALL(alarm)
 450:	b8 18 00 00 00       	mov    $0x18,%eax
 455:	cd 40                	int    $0x40
 457:	c3                   	ret    

00000458 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 458:	55                   	push   %ebp
 459:	89 e5                	mov    %esp,%ebp
 45b:	83 ec 28             	sub    $0x28,%esp
 45e:	8b 45 0c             	mov    0xc(%ebp),%eax
 461:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 464:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 46b:	00 
 46c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 46f:	89 44 24 04          	mov    %eax,0x4(%esp)
 473:	8b 45 08             	mov    0x8(%ebp),%eax
 476:	89 04 24             	mov    %eax,(%esp)
 479:	e8 42 ff ff ff       	call   3c0 <write>
}
 47e:	c9                   	leave  
 47f:	c3                   	ret    

00000480 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 480:	55                   	push   %ebp
 481:	89 e5                	mov    %esp,%ebp
 483:	53                   	push   %ebx
 484:	83 ec 44             	sub    $0x44,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 487:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 48e:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 492:	74 17                	je     4ab <printint+0x2b>
 494:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 498:	79 11                	jns    4ab <printint+0x2b>
    neg = 1;
 49a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4a1:	8b 45 0c             	mov    0xc(%ebp),%eax
 4a4:	f7 d8                	neg    %eax
 4a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4a9:	eb 06                	jmp    4b1 <printint+0x31>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4ab:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }

  i = 0;
 4b1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  do{
    buf[i++] = digits[x % base];
 4b8:	8b 4d ec             	mov    -0x14(%ebp),%ecx
 4bb:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4be:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4c1:	ba 00 00 00 00       	mov    $0x0,%edx
 4c6:	f7 f3                	div    %ebx
 4c8:	89 d0                	mov    %edx,%eax
 4ca:	0f b6 80 28 09 00 00 	movzbl 0x928(%eax),%eax
 4d1:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
 4d5:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  }while((x /= base) != 0);
 4d9:	8b 45 10             	mov    0x10(%ebp),%eax
 4dc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 4df:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4e2:	ba 00 00 00 00       	mov    $0x0,%edx
 4e7:	f7 75 d4             	divl   -0x2c(%ebp)
 4ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4f1:	75 c5                	jne    4b8 <printint+0x38>
  if(neg)
 4f3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4f7:	74 2a                	je     523 <printint+0xa3>
    buf[i++] = '-';
 4f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4fc:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)
 501:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)

  while(--i >= 0)
 505:	eb 1d                	jmp    524 <printint+0xa4>
    putc(fd, buf[i]);
 507:	8b 45 ec             	mov    -0x14(%ebp),%eax
 50a:	0f b6 44 05 dc       	movzbl -0x24(%ebp,%eax,1),%eax
 50f:	0f be c0             	movsbl %al,%eax
 512:	89 44 24 04          	mov    %eax,0x4(%esp)
 516:	8b 45 08             	mov    0x8(%ebp),%eax
 519:	89 04 24             	mov    %eax,(%esp)
 51c:	e8 37 ff ff ff       	call   458 <putc>
 521:	eb 01                	jmp    524 <printint+0xa4>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 523:	90                   	nop
 524:	83 6d ec 01          	subl   $0x1,-0x14(%ebp)
 528:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 52c:	79 d9                	jns    507 <printint+0x87>
    putc(fd, buf[i]);
}
 52e:	83 c4 44             	add    $0x44,%esp
 531:	5b                   	pop    %ebx
 532:	5d                   	pop    %ebp
 533:	c3                   	ret    

00000534 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 534:	55                   	push   %ebp
 535:	89 e5                	mov    %esp,%ebp
 537:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 53a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 541:	8d 45 0c             	lea    0xc(%ebp),%eax
 544:	83 c0 04             	add    $0x4,%eax
 547:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i = 0; fmt[i]; i++){
 54a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 551:	e9 7e 01 00 00       	jmp    6d4 <printf+0x1a0>
    c = fmt[i] & 0xff;
 556:	8b 55 0c             	mov    0xc(%ebp),%edx
 559:	8b 45 ec             	mov    -0x14(%ebp),%eax
 55c:	8d 04 02             	lea    (%edx,%eax,1),%eax
 55f:	0f b6 00             	movzbl (%eax),%eax
 562:	0f be c0             	movsbl %al,%eax
 565:	25 ff 00 00 00       	and    $0xff,%eax
 56a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(state == 0){
 56d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 571:	75 2c                	jne    59f <printf+0x6b>
      if(c == '%'){
 573:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 577:	75 0c                	jne    585 <printf+0x51>
        state = '%';
 579:	c7 45 f0 25 00 00 00 	movl   $0x25,-0x10(%ebp)
 580:	e9 4b 01 00 00       	jmp    6d0 <printf+0x19c>
      } else {
        putc(fd, c);
 585:	8b 45 e8             	mov    -0x18(%ebp),%eax
 588:	0f be c0             	movsbl %al,%eax
 58b:	89 44 24 04          	mov    %eax,0x4(%esp)
 58f:	8b 45 08             	mov    0x8(%ebp),%eax
 592:	89 04 24             	mov    %eax,(%esp)
 595:	e8 be fe ff ff       	call   458 <putc>
 59a:	e9 31 01 00 00       	jmp    6d0 <printf+0x19c>
      }
    } else if(state == '%'){
 59f:	83 7d f0 25          	cmpl   $0x25,-0x10(%ebp)
 5a3:	0f 85 27 01 00 00    	jne    6d0 <printf+0x19c>
      if(c == 'd'){
 5a9:	83 7d e8 64          	cmpl   $0x64,-0x18(%ebp)
 5ad:	75 2d                	jne    5dc <printf+0xa8>
        printint(fd, *ap, 10, 1);
 5af:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5b2:	8b 00                	mov    (%eax),%eax
 5b4:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 5bb:	00 
 5bc:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 5c3:	00 
 5c4:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c8:	8b 45 08             	mov    0x8(%ebp),%eax
 5cb:	89 04 24             	mov    %eax,(%esp)
 5ce:	e8 ad fe ff ff       	call   480 <printint>
        ap++;
 5d3:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 5d7:	e9 ed 00 00 00       	jmp    6c9 <printf+0x195>
      } else if(c == 'x' || c == 'p'){
 5dc:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
 5e0:	74 06                	je     5e8 <printf+0xb4>
 5e2:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
 5e6:	75 2d                	jne    615 <printf+0xe1>
        printint(fd, *ap, 16, 0);
 5e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5eb:	8b 00                	mov    (%eax),%eax
 5ed:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 5f4:	00 
 5f5:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 5fc:	00 
 5fd:	89 44 24 04          	mov    %eax,0x4(%esp)
 601:	8b 45 08             	mov    0x8(%ebp),%eax
 604:	89 04 24             	mov    %eax,(%esp)
 607:	e8 74 fe ff ff       	call   480 <printint>
        ap++;
 60c:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 610:	e9 b4 00 00 00       	jmp    6c9 <printf+0x195>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 615:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
 619:	75 46                	jne    661 <printf+0x12d>
        s = (char*)*ap;
 61b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 61e:	8b 00                	mov    (%eax),%eax
 620:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ap++;
 623:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
        if(s == 0)
 627:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 62b:	75 27                	jne    654 <printf+0x120>
          s = "(null)";
 62d:	c7 45 e4 21 09 00 00 	movl   $0x921,-0x1c(%ebp)
        while(*s != 0){
 634:	eb 1f                	jmp    655 <printf+0x121>
          putc(fd, *s);
 636:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 639:	0f b6 00             	movzbl (%eax),%eax
 63c:	0f be c0             	movsbl %al,%eax
 63f:	89 44 24 04          	mov    %eax,0x4(%esp)
 643:	8b 45 08             	mov    0x8(%ebp),%eax
 646:	89 04 24             	mov    %eax,(%esp)
 649:	e8 0a fe ff ff       	call   458 <putc>
          s++;
 64e:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 652:	eb 01                	jmp    655 <printf+0x121>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 654:	90                   	nop
 655:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 658:	0f b6 00             	movzbl (%eax),%eax
 65b:	84 c0                	test   %al,%al
 65d:	75 d7                	jne    636 <printf+0x102>
 65f:	eb 68                	jmp    6c9 <printf+0x195>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 661:	83 7d e8 63          	cmpl   $0x63,-0x18(%ebp)
 665:	75 1d                	jne    684 <printf+0x150>
        putc(fd, *ap);
 667:	8b 45 f4             	mov    -0xc(%ebp),%eax
 66a:	8b 00                	mov    (%eax),%eax
 66c:	0f be c0             	movsbl %al,%eax
 66f:	89 44 24 04          	mov    %eax,0x4(%esp)
 673:	8b 45 08             	mov    0x8(%ebp),%eax
 676:	89 04 24             	mov    %eax,(%esp)
 679:	e8 da fd ff ff       	call   458 <putc>
        ap++;
 67e:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 682:	eb 45                	jmp    6c9 <printf+0x195>
      } else if(c == '%'){
 684:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 688:	75 17                	jne    6a1 <printf+0x16d>
        putc(fd, c);
 68a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 68d:	0f be c0             	movsbl %al,%eax
 690:	89 44 24 04          	mov    %eax,0x4(%esp)
 694:	8b 45 08             	mov    0x8(%ebp),%eax
 697:	89 04 24             	mov    %eax,(%esp)
 69a:	e8 b9 fd ff ff       	call   458 <putc>
 69f:	eb 28                	jmp    6c9 <printf+0x195>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6a1:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 6a8:	00 
 6a9:	8b 45 08             	mov    0x8(%ebp),%eax
 6ac:	89 04 24             	mov    %eax,(%esp)
 6af:	e8 a4 fd ff ff       	call   458 <putc>
        putc(fd, c);
 6b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6b7:	0f be c0             	movsbl %al,%eax
 6ba:	89 44 24 04          	mov    %eax,0x4(%esp)
 6be:	8b 45 08             	mov    0x8(%ebp),%eax
 6c1:	89 04 24             	mov    %eax,(%esp)
 6c4:	e8 8f fd ff ff       	call   458 <putc>
      }
      state = 0;
 6c9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6d0:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 6d4:	8b 55 0c             	mov    0xc(%ebp),%edx
 6d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6da:	8d 04 02             	lea    (%edx,%eax,1),%eax
 6dd:	0f b6 00             	movzbl (%eax),%eax
 6e0:	84 c0                	test   %al,%al
 6e2:	0f 85 6e fe ff ff    	jne    556 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6e8:	c9                   	leave  
 6e9:	c3                   	ret    
 6ea:	90                   	nop
 6eb:	90                   	nop

000006ec <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6ec:	55                   	push   %ebp
 6ed:	89 e5                	mov    %esp,%ebp
 6ef:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6f2:	8b 45 08             	mov    0x8(%ebp),%eax
 6f5:	83 e8 08             	sub    $0x8,%eax
 6f8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6fb:	a1 48 09 00 00       	mov    0x948,%eax
 700:	89 45 fc             	mov    %eax,-0x4(%ebp)
 703:	eb 24                	jmp    729 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 705:	8b 45 fc             	mov    -0x4(%ebp),%eax
 708:	8b 00                	mov    (%eax),%eax
 70a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 70d:	77 12                	ja     721 <free+0x35>
 70f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 712:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 715:	77 24                	ja     73b <free+0x4f>
 717:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71a:	8b 00                	mov    (%eax),%eax
 71c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 71f:	77 1a                	ja     73b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 721:	8b 45 fc             	mov    -0x4(%ebp),%eax
 724:	8b 00                	mov    (%eax),%eax
 726:	89 45 fc             	mov    %eax,-0x4(%ebp)
 729:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 72f:	76 d4                	jbe    705 <free+0x19>
 731:	8b 45 fc             	mov    -0x4(%ebp),%eax
 734:	8b 00                	mov    (%eax),%eax
 736:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 739:	76 ca                	jbe    705 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 73b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73e:	8b 40 04             	mov    0x4(%eax),%eax
 741:	c1 e0 03             	shl    $0x3,%eax
 744:	89 c2                	mov    %eax,%edx
 746:	03 55 f8             	add    -0x8(%ebp),%edx
 749:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74c:	8b 00                	mov    (%eax),%eax
 74e:	39 c2                	cmp    %eax,%edx
 750:	75 24                	jne    776 <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 752:	8b 45 f8             	mov    -0x8(%ebp),%eax
 755:	8b 50 04             	mov    0x4(%eax),%edx
 758:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75b:	8b 00                	mov    (%eax),%eax
 75d:	8b 40 04             	mov    0x4(%eax),%eax
 760:	01 c2                	add    %eax,%edx
 762:	8b 45 f8             	mov    -0x8(%ebp),%eax
 765:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 768:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76b:	8b 00                	mov    (%eax),%eax
 76d:	8b 10                	mov    (%eax),%edx
 76f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 772:	89 10                	mov    %edx,(%eax)
 774:	eb 0a                	jmp    780 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 776:	8b 45 fc             	mov    -0x4(%ebp),%eax
 779:	8b 10                	mov    (%eax),%edx
 77b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 780:	8b 45 fc             	mov    -0x4(%ebp),%eax
 783:	8b 40 04             	mov    0x4(%eax),%eax
 786:	c1 e0 03             	shl    $0x3,%eax
 789:	03 45 fc             	add    -0x4(%ebp),%eax
 78c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 78f:	75 20                	jne    7b1 <free+0xc5>
    p->s.size += bp->s.size;
 791:	8b 45 fc             	mov    -0x4(%ebp),%eax
 794:	8b 50 04             	mov    0x4(%eax),%edx
 797:	8b 45 f8             	mov    -0x8(%ebp),%eax
 79a:	8b 40 04             	mov    0x4(%eax),%eax
 79d:	01 c2                	add    %eax,%edx
 79f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a2:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a8:	8b 10                	mov    (%eax),%edx
 7aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ad:	89 10                	mov    %edx,(%eax)
 7af:	eb 08                	jmp    7b9 <free+0xcd>
  } else
    p->s.ptr = bp;
 7b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b4:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7b7:	89 10                	mov    %edx,(%eax)
  freep = p;
 7b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7bc:	a3 48 09 00 00       	mov    %eax,0x948
}
 7c1:	c9                   	leave  
 7c2:	c3                   	ret    

000007c3 <morecore>:

static Header*
morecore(uint nu)
{
 7c3:	55                   	push   %ebp
 7c4:	89 e5                	mov    %esp,%ebp
 7c6:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7c9:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7d0:	77 07                	ja     7d9 <morecore+0x16>
    nu = 4096;
 7d2:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7d9:	8b 45 08             	mov    0x8(%ebp),%eax
 7dc:	c1 e0 03             	shl    $0x3,%eax
 7df:	89 04 24             	mov    %eax,(%esp)
 7e2:	e8 41 fc ff ff       	call   428 <sbrk>
 7e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(p == (char*)-1)
 7ea:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
 7ee:	75 07                	jne    7f7 <morecore+0x34>
    return 0;
 7f0:	b8 00 00 00 00       	mov    $0x0,%eax
 7f5:	eb 22                	jmp    819 <morecore+0x56>
  hp = (Header*)p;
 7f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  hp->s.size = nu;
 7fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 800:	8b 55 08             	mov    0x8(%ebp),%edx
 803:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 806:	8b 45 f4             	mov    -0xc(%ebp),%eax
 809:	83 c0 08             	add    $0x8,%eax
 80c:	89 04 24             	mov    %eax,(%esp)
 80f:	e8 d8 fe ff ff       	call   6ec <free>
  return freep;
 814:	a1 48 09 00 00       	mov    0x948,%eax
}
 819:	c9                   	leave  
 81a:	c3                   	ret    

0000081b <malloc>:

void*
malloc(uint nbytes)
{
 81b:	55                   	push   %ebp
 81c:	89 e5                	mov    %esp,%ebp
 81e:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 821:	8b 45 08             	mov    0x8(%ebp),%eax
 824:	83 c0 07             	add    $0x7,%eax
 827:	c1 e8 03             	shr    $0x3,%eax
 82a:	83 c0 01             	add    $0x1,%eax
 82d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((prevp = freep) == 0){
 830:	a1 48 09 00 00       	mov    0x948,%eax
 835:	89 45 f0             	mov    %eax,-0x10(%ebp)
 838:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 83c:	75 23                	jne    861 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 83e:	c7 45 f0 40 09 00 00 	movl   $0x940,-0x10(%ebp)
 845:	8b 45 f0             	mov    -0x10(%ebp),%eax
 848:	a3 48 09 00 00       	mov    %eax,0x948
 84d:	a1 48 09 00 00       	mov    0x948,%eax
 852:	a3 40 09 00 00       	mov    %eax,0x940
    base.s.size = 0;
 857:	c7 05 44 09 00 00 00 	movl   $0x0,0x944
 85e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 861:	8b 45 f0             	mov    -0x10(%ebp),%eax
 864:	8b 00                	mov    (%eax),%eax
 866:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(p->s.size >= nunits){
 869:	8b 45 ec             	mov    -0x14(%ebp),%eax
 86c:	8b 40 04             	mov    0x4(%eax),%eax
 86f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 872:	72 4d                	jb     8c1 <malloc+0xa6>
      if(p->s.size == nunits)
 874:	8b 45 ec             	mov    -0x14(%ebp),%eax
 877:	8b 40 04             	mov    0x4(%eax),%eax
 87a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 87d:	75 0c                	jne    88b <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 87f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 882:	8b 10                	mov    (%eax),%edx
 884:	8b 45 f0             	mov    -0x10(%ebp),%eax
 887:	89 10                	mov    %edx,(%eax)
 889:	eb 26                	jmp    8b1 <malloc+0x96>
      else {
        p->s.size -= nunits;
 88b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 88e:	8b 40 04             	mov    0x4(%eax),%eax
 891:	89 c2                	mov    %eax,%edx
 893:	2b 55 f4             	sub    -0xc(%ebp),%edx
 896:	8b 45 ec             	mov    -0x14(%ebp),%eax
 899:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 89c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 89f:	8b 40 04             	mov    0x4(%eax),%eax
 8a2:	c1 e0 03             	shl    $0x3,%eax
 8a5:	01 45 ec             	add    %eax,-0x14(%ebp)
        p->s.size = nunits;
 8a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
 8ae:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b4:	a3 48 09 00 00       	mov    %eax,0x948
      return (void*)(p + 1);
 8b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8bc:	83 c0 08             	add    $0x8,%eax
 8bf:	eb 38                	jmp    8f9 <malloc+0xde>
    }
    if(p == freep)
 8c1:	a1 48 09 00 00       	mov    0x948,%eax
 8c6:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 8c9:	75 1b                	jne    8e6 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 8cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ce:	89 04 24             	mov    %eax,(%esp)
 8d1:	e8 ed fe ff ff       	call   7c3 <morecore>
 8d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 8d9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 8dd:	75 07                	jne    8e6 <malloc+0xcb>
        return 0;
 8df:	b8 00 00 00 00       	mov    $0x0,%eax
 8e4:	eb 13                	jmp    8f9 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8ef:	8b 00                	mov    (%eax),%eax
 8f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8f4:	e9 70 ff ff ff       	jmp    869 <malloc+0x4e>
}
 8f9:	c9                   	leave  
 8fa:	c3                   	ret    
