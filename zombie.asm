
_zombie:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 10             	sub    $0x10,%esp
  if(fork() > 0)
   9:	e8 8a 02 00 00       	call   298 <fork>
   e:	85 c0                	test   %eax,%eax
  10:	7e 0c                	jle    1e <main+0x1e>
    sleep(5);  // Let child exit before parent.
  12:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  19:	e8 12 03 00 00       	call   330 <sleep>
  exit();
  1e:	e8 7d 02 00 00       	call   2a0 <exit>
  23:	90                   	nop

00000024 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  24:	55                   	push   %ebp
  25:	89 e5                	mov    %esp,%ebp
  27:	57                   	push   %edi
  28:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  29:	8b 4d 08             	mov    0x8(%ebp),%ecx
  2c:	8b 55 10             	mov    0x10(%ebp),%edx
  2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  32:	89 cb                	mov    %ecx,%ebx
  34:	89 df                	mov    %ebx,%edi
  36:	89 d1                	mov    %edx,%ecx
  38:	fc                   	cld    
  39:	f3 aa                	rep stos %al,%es:(%edi)
  3b:	89 ca                	mov    %ecx,%edx
  3d:	89 fb                	mov    %edi,%ebx
  3f:	89 5d 08             	mov    %ebx,0x8(%ebp)
  42:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  45:	5b                   	pop    %ebx
  46:	5f                   	pop    %edi
  47:	5d                   	pop    %ebp
  48:	c3                   	ret    

00000049 <strcpy>:
#include "x86.h"
#include "signal.h"

char*
strcpy(char *s, char *t)
{
  49:	55                   	push   %ebp
  4a:	89 e5                	mov    %esp,%ebp
  4c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  4f:	8b 45 08             	mov    0x8(%ebp),%eax
  52:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  55:	90                   	nop
  56:	8b 45 0c             	mov    0xc(%ebp),%eax
  59:	8a 10                	mov    (%eax),%dl
  5b:	8b 45 08             	mov    0x8(%ebp),%eax
  5e:	88 10                	mov    %dl,(%eax)
  60:	8b 45 08             	mov    0x8(%ebp),%eax
  63:	8a 00                	mov    (%eax),%al
  65:	84 c0                	test   %al,%al
  67:	0f 95 c0             	setne  %al
  6a:	ff 45 08             	incl   0x8(%ebp)
  6d:	ff 45 0c             	incl   0xc(%ebp)
  70:	84 c0                	test   %al,%al
  72:	75 e2                	jne    56 <strcpy+0xd>
    ;
  return os;
  74:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  77:	c9                   	leave  
  78:	c3                   	ret    

00000079 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  79:	55                   	push   %ebp
  7a:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  7c:	eb 06                	jmp    84 <strcmp+0xb>
    p++, q++;
  7e:	ff 45 08             	incl   0x8(%ebp)
  81:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  84:	8b 45 08             	mov    0x8(%ebp),%eax
  87:	8a 00                	mov    (%eax),%al
  89:	84 c0                	test   %al,%al
  8b:	74 0e                	je     9b <strcmp+0x22>
  8d:	8b 45 08             	mov    0x8(%ebp),%eax
  90:	8a 10                	mov    (%eax),%dl
  92:	8b 45 0c             	mov    0xc(%ebp),%eax
  95:	8a 00                	mov    (%eax),%al
  97:	38 c2                	cmp    %al,%dl
  99:	74 e3                	je     7e <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  9b:	8b 45 08             	mov    0x8(%ebp),%eax
  9e:	8a 00                	mov    (%eax),%al
  a0:	0f b6 d0             	movzbl %al,%edx
  a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  a6:	8a 00                	mov    (%eax),%al
  a8:	0f b6 c0             	movzbl %al,%eax
  ab:	89 d1                	mov    %edx,%ecx
  ad:	29 c1                	sub    %eax,%ecx
  af:	89 c8                	mov    %ecx,%eax
}
  b1:	5d                   	pop    %ebp
  b2:	c3                   	ret    

000000b3 <strlen>:

uint
strlen(char *s)
{
  b3:	55                   	push   %ebp
  b4:	89 e5                	mov    %esp,%ebp
  b6:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  c0:	eb 03                	jmp    c5 <strlen+0x12>
  c2:	ff 45 fc             	incl   -0x4(%ebp)
  c5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  c8:	8b 45 08             	mov    0x8(%ebp),%eax
  cb:	01 d0                	add    %edx,%eax
  cd:	8a 00                	mov    (%eax),%al
  cf:	84 c0                	test   %al,%al
  d1:	75 ef                	jne    c2 <strlen+0xf>
    ;
  return n;
  d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  d6:	c9                   	leave  
  d7:	c3                   	ret    

000000d8 <memset>:

void*
memset(void *dst, int c, uint n)
{
  d8:	55                   	push   %ebp
  d9:	89 e5                	mov    %esp,%ebp
  db:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
  de:	8b 45 10             	mov    0x10(%ebp),%eax
  e1:	89 44 24 08          	mov    %eax,0x8(%esp)
  e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  ec:	8b 45 08             	mov    0x8(%ebp),%eax
  ef:	89 04 24             	mov    %eax,(%esp)
  f2:	e8 2d ff ff ff       	call   24 <stosb>
  return dst;
  f7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  fa:	c9                   	leave  
  fb:	c3                   	ret    

000000fc <strchr>:

char*
strchr(const char *s, char c)
{
  fc:	55                   	push   %ebp
  fd:	89 e5                	mov    %esp,%ebp
  ff:	83 ec 04             	sub    $0x4,%esp
 102:	8b 45 0c             	mov    0xc(%ebp),%eax
 105:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 108:	eb 12                	jmp    11c <strchr+0x20>
    if(*s == c)
 10a:	8b 45 08             	mov    0x8(%ebp),%eax
 10d:	8a 00                	mov    (%eax),%al
 10f:	3a 45 fc             	cmp    -0x4(%ebp),%al
 112:	75 05                	jne    119 <strchr+0x1d>
      return (char*)s;
 114:	8b 45 08             	mov    0x8(%ebp),%eax
 117:	eb 11                	jmp    12a <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 119:	ff 45 08             	incl   0x8(%ebp)
 11c:	8b 45 08             	mov    0x8(%ebp),%eax
 11f:	8a 00                	mov    (%eax),%al
 121:	84 c0                	test   %al,%al
 123:	75 e5                	jne    10a <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 125:	b8 00 00 00 00       	mov    $0x0,%eax
}
 12a:	c9                   	leave  
 12b:	c3                   	ret    

0000012c <gets>:

char*
gets(char *buf, int max)
{
 12c:	55                   	push   %ebp
 12d:	89 e5                	mov    %esp,%ebp
 12f:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 132:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 139:	eb 42                	jmp    17d <gets+0x51>
    cc = read(0, &c, 1);
 13b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 142:	00 
 143:	8d 45 ef             	lea    -0x11(%ebp),%eax
 146:	89 44 24 04          	mov    %eax,0x4(%esp)
 14a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 151:	e8 62 01 00 00       	call   2b8 <read>
 156:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 159:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 15d:	7e 29                	jle    188 <gets+0x5c>
      break;
    buf[i++] = c;
 15f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 162:	8b 45 08             	mov    0x8(%ebp),%eax
 165:	01 c2                	add    %eax,%edx
 167:	8a 45 ef             	mov    -0x11(%ebp),%al
 16a:	88 02                	mov    %al,(%edx)
 16c:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 16f:	8a 45 ef             	mov    -0x11(%ebp),%al
 172:	3c 0a                	cmp    $0xa,%al
 174:	74 13                	je     189 <gets+0x5d>
 176:	8a 45 ef             	mov    -0x11(%ebp),%al
 179:	3c 0d                	cmp    $0xd,%al
 17b:	74 0c                	je     189 <gets+0x5d>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 17d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 180:	40                   	inc    %eax
 181:	3b 45 0c             	cmp    0xc(%ebp),%eax
 184:	7c b5                	jl     13b <gets+0xf>
 186:	eb 01                	jmp    189 <gets+0x5d>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 188:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 189:	8b 55 f4             	mov    -0xc(%ebp),%edx
 18c:	8b 45 08             	mov    0x8(%ebp),%eax
 18f:	01 d0                	add    %edx,%eax
 191:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 194:	8b 45 08             	mov    0x8(%ebp),%eax
}
 197:	c9                   	leave  
 198:	c3                   	ret    

00000199 <stat>:

int
stat(char *n, struct stat *st)
{
 199:	55                   	push   %ebp
 19a:	89 e5                	mov    %esp,%ebp
 19c:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 19f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1a6:	00 
 1a7:	8b 45 08             	mov    0x8(%ebp),%eax
 1aa:	89 04 24             	mov    %eax,(%esp)
 1ad:	e8 2e 01 00 00       	call   2e0 <open>
 1b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1b9:	79 07                	jns    1c2 <stat+0x29>
    return -1;
 1bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1c0:	eb 23                	jmp    1e5 <stat+0x4c>
  r = fstat(fd, st);
 1c2:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c5:	89 44 24 04          	mov    %eax,0x4(%esp)
 1c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1cc:	89 04 24             	mov    %eax,(%esp)
 1cf:	e8 24 01 00 00       	call   2f8 <fstat>
 1d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1da:	89 04 24             	mov    %eax,(%esp)
 1dd:	e8 e6 00 00 00       	call   2c8 <close>
  return r;
 1e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1e5:	c9                   	leave  
 1e6:	c3                   	ret    

000001e7 <atoi>:

int
atoi(const char *s)
{
 1e7:	55                   	push   %ebp
 1e8:	89 e5                	mov    %esp,%ebp
 1ea:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 1ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 1f4:	eb 21                	jmp    217 <atoi+0x30>
    n = n*10 + *s++ - '0';
 1f6:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1f9:	89 d0                	mov    %edx,%eax
 1fb:	c1 e0 02             	shl    $0x2,%eax
 1fe:	01 d0                	add    %edx,%eax
 200:	d1 e0                	shl    %eax
 202:	89 c2                	mov    %eax,%edx
 204:	8b 45 08             	mov    0x8(%ebp),%eax
 207:	8a 00                	mov    (%eax),%al
 209:	0f be c0             	movsbl %al,%eax
 20c:	01 d0                	add    %edx,%eax
 20e:	83 e8 30             	sub    $0x30,%eax
 211:	89 45 fc             	mov    %eax,-0x4(%ebp)
 214:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 217:	8b 45 08             	mov    0x8(%ebp),%eax
 21a:	8a 00                	mov    (%eax),%al
 21c:	3c 2f                	cmp    $0x2f,%al
 21e:	7e 09                	jle    229 <atoi+0x42>
 220:	8b 45 08             	mov    0x8(%ebp),%eax
 223:	8a 00                	mov    (%eax),%al
 225:	3c 39                	cmp    $0x39,%al
 227:	7e cd                	jle    1f6 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 229:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 22c:	c9                   	leave  
 22d:	c3                   	ret    

0000022e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 22e:	55                   	push   %ebp
 22f:	89 e5                	mov    %esp,%ebp
 231:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 234:	8b 45 08             	mov    0x8(%ebp),%eax
 237:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 23a:	8b 45 0c             	mov    0xc(%ebp),%eax
 23d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 240:	eb 10                	jmp    252 <memmove+0x24>
    *dst++ = *src++;
 242:	8b 45 f8             	mov    -0x8(%ebp),%eax
 245:	8a 10                	mov    (%eax),%dl
 247:	8b 45 fc             	mov    -0x4(%ebp),%eax
 24a:	88 10                	mov    %dl,(%eax)
 24c:	ff 45 fc             	incl   -0x4(%ebp)
 24f:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 252:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 256:	0f 9f c0             	setg   %al
 259:	ff 4d 10             	decl   0x10(%ebp)
 25c:	84 c0                	test   %al,%al
 25e:	75 e2                	jne    242 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 260:	8b 45 08             	mov    0x8(%ebp),%eax
}
 263:	c9                   	leave  
 264:	c3                   	ret    

00000265 <trampoline>:
 265:	5a                   	pop    %edx
 266:	59                   	pop    %ecx
 267:	58                   	pop    %eax
 268:	03 25 04 00 00 00    	add    0x4,%esp
 26e:	c9                   	leave  
 26f:	c3                   	ret    

00000270 <signal>:
	"addl 4, %esp\n\t"
	"leave\n\t"
	"ret\n\t"
);
int signal(int signum, sighandler_t handler) 
{
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	83 ec 18             	sub    $0x18,%esp
	register_signal_handler(signum, handler, trampoline);
 276:	c7 44 24 08 65 02 00 	movl   $0x265,0x8(%esp)
 27d:	00 
 27e:	8b 45 0c             	mov    0xc(%ebp),%eax
 281:	89 44 24 04          	mov    %eax,0x4(%esp)
 285:	8b 45 08             	mov    0x8(%ebp),%eax
 288:	89 04 24             	mov    %eax,(%esp)
 28b:	e8 b8 00 00 00       	call   348 <register_signal_handler>
	return 0;
 290:	b8 00 00 00 00       	mov    $0x0,%eax
}
 295:	c9                   	leave  
 296:	c3                   	ret    
 297:	90                   	nop

00000298 <fork>:
 298:	b8 01 00 00 00       	mov    $0x1,%eax
 29d:	cd 40                	int    $0x40
 29f:	c3                   	ret    

000002a0 <exit>:
 2a0:	b8 02 00 00 00       	mov    $0x2,%eax
 2a5:	cd 40                	int    $0x40
 2a7:	c3                   	ret    

000002a8 <wait>:
 2a8:	b8 03 00 00 00       	mov    $0x3,%eax
 2ad:	cd 40                	int    $0x40
 2af:	c3                   	ret    

000002b0 <pipe>:
 2b0:	b8 04 00 00 00       	mov    $0x4,%eax
 2b5:	cd 40                	int    $0x40
 2b7:	c3                   	ret    

000002b8 <read>:
 2b8:	b8 05 00 00 00       	mov    $0x5,%eax
 2bd:	cd 40                	int    $0x40
 2bf:	c3                   	ret    

000002c0 <write>:
 2c0:	b8 10 00 00 00       	mov    $0x10,%eax
 2c5:	cd 40                	int    $0x40
 2c7:	c3                   	ret    

000002c8 <close>:
 2c8:	b8 15 00 00 00       	mov    $0x15,%eax
 2cd:	cd 40                	int    $0x40
 2cf:	c3                   	ret    

000002d0 <kill>:
 2d0:	b8 06 00 00 00       	mov    $0x6,%eax
 2d5:	cd 40                	int    $0x40
 2d7:	c3                   	ret    

000002d8 <exec>:
 2d8:	b8 07 00 00 00       	mov    $0x7,%eax
 2dd:	cd 40                	int    $0x40
 2df:	c3                   	ret    

000002e0 <open>:
 2e0:	b8 0f 00 00 00       	mov    $0xf,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <mknod>:
 2e8:	b8 11 00 00 00       	mov    $0x11,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <unlink>:
 2f0:	b8 12 00 00 00       	mov    $0x12,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <fstat>:
 2f8:	b8 08 00 00 00       	mov    $0x8,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <link>:
 300:	b8 13 00 00 00       	mov    $0x13,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <mkdir>:
 308:	b8 14 00 00 00       	mov    $0x14,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <chdir>:
 310:	b8 09 00 00 00       	mov    $0x9,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <dup>:
 318:	b8 0a 00 00 00       	mov    $0xa,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <getpid>:
 320:	b8 0b 00 00 00       	mov    $0xb,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <sbrk>:
 328:	b8 0c 00 00 00       	mov    $0xc,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <sleep>:
 330:	b8 0d 00 00 00       	mov    $0xd,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <uptime>:
 338:	b8 0e 00 00 00       	mov    $0xe,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <halt>:
 340:	b8 16 00 00 00       	mov    $0x16,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <register_signal_handler>:
 348:	b8 17 00 00 00       	mov    $0x17,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <alarm>:
 350:	b8 18 00 00 00       	mov    $0x18,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 358:	55                   	push   %ebp
 359:	89 e5                	mov    %esp,%ebp
 35b:	83 ec 28             	sub    $0x28,%esp
 35e:	8b 45 0c             	mov    0xc(%ebp),%eax
 361:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 364:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 36b:	00 
 36c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 36f:	89 44 24 04          	mov    %eax,0x4(%esp)
 373:	8b 45 08             	mov    0x8(%ebp),%eax
 376:	89 04 24             	mov    %eax,(%esp)
 379:	e8 42 ff ff ff       	call   2c0 <write>
}
 37e:	c9                   	leave  
 37f:	c3                   	ret    

00000380 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 386:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 38d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 391:	74 17                	je     3aa <printint+0x2a>
 393:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 397:	79 11                	jns    3aa <printint+0x2a>
    neg = 1;
 399:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3a0:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a3:	f7 d8                	neg    %eax
 3a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3a8:	eb 06                	jmp    3b0 <printint+0x30>
  } else {
    x = xx;
 3aa:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3b0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3bd:	ba 00 00 00 00       	mov    $0x0,%edx
 3c2:	f7 f1                	div    %ecx
 3c4:	89 d0                	mov    %edx,%eax
 3c6:	8a 80 5c 0a 00 00    	mov    0xa5c(%eax),%al
 3cc:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 3cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3d2:	01 ca                	add    %ecx,%edx
 3d4:	88 02                	mov    %al,(%edx)
 3d6:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 3d9:	8b 55 10             	mov    0x10(%ebp),%edx
 3dc:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 3df:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3e2:	ba 00 00 00 00       	mov    $0x0,%edx
 3e7:	f7 75 d4             	divl   -0x2c(%ebp)
 3ea:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3ed:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3f1:	75 c4                	jne    3b7 <printint+0x37>
  if(neg)
 3f3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3f7:	74 2c                	je     425 <printint+0xa5>
    buf[i++] = '-';
 3f9:	8d 55 dc             	lea    -0x24(%ebp),%edx
 3fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3ff:	01 d0                	add    %edx,%eax
 401:	c6 00 2d             	movb   $0x2d,(%eax)
 404:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 407:	eb 1c                	jmp    425 <printint+0xa5>
    putc(fd, buf[i]);
 409:	8d 55 dc             	lea    -0x24(%ebp),%edx
 40c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 40f:	01 d0                	add    %edx,%eax
 411:	8a 00                	mov    (%eax),%al
 413:	0f be c0             	movsbl %al,%eax
 416:	89 44 24 04          	mov    %eax,0x4(%esp)
 41a:	8b 45 08             	mov    0x8(%ebp),%eax
 41d:	89 04 24             	mov    %eax,(%esp)
 420:	e8 33 ff ff ff       	call   358 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 425:	ff 4d f4             	decl   -0xc(%ebp)
 428:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 42c:	79 db                	jns    409 <printint+0x89>
    putc(fd, buf[i]);
}
 42e:	c9                   	leave  
 42f:	c3                   	ret    

00000430 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 436:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 43d:	8d 45 0c             	lea    0xc(%ebp),%eax
 440:	83 c0 04             	add    $0x4,%eax
 443:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 446:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 44d:	e9 78 01 00 00       	jmp    5ca <printf+0x19a>
    c = fmt[i] & 0xff;
 452:	8b 55 0c             	mov    0xc(%ebp),%edx
 455:	8b 45 f0             	mov    -0x10(%ebp),%eax
 458:	01 d0                	add    %edx,%eax
 45a:	8a 00                	mov    (%eax),%al
 45c:	0f be c0             	movsbl %al,%eax
 45f:	25 ff 00 00 00       	and    $0xff,%eax
 464:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 467:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 46b:	75 2c                	jne    499 <printf+0x69>
      if(c == '%'){
 46d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 471:	75 0c                	jne    47f <printf+0x4f>
        state = '%';
 473:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 47a:	e9 48 01 00 00       	jmp    5c7 <printf+0x197>
      } else {
        putc(fd, c);
 47f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 482:	0f be c0             	movsbl %al,%eax
 485:	89 44 24 04          	mov    %eax,0x4(%esp)
 489:	8b 45 08             	mov    0x8(%ebp),%eax
 48c:	89 04 24             	mov    %eax,(%esp)
 48f:	e8 c4 fe ff ff       	call   358 <putc>
 494:	e9 2e 01 00 00       	jmp    5c7 <printf+0x197>
      }
    } else if(state == '%'){
 499:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 49d:	0f 85 24 01 00 00    	jne    5c7 <printf+0x197>
      if(c == 'd'){
 4a3:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4a7:	75 2d                	jne    4d6 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 4a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4ac:	8b 00                	mov    (%eax),%eax
 4ae:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4b5:	00 
 4b6:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4bd:	00 
 4be:	89 44 24 04          	mov    %eax,0x4(%esp)
 4c2:	8b 45 08             	mov    0x8(%ebp),%eax
 4c5:	89 04 24             	mov    %eax,(%esp)
 4c8:	e8 b3 fe ff ff       	call   380 <printint>
        ap++;
 4cd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4d1:	e9 ea 00 00 00       	jmp    5c0 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 4d6:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4da:	74 06                	je     4e2 <printf+0xb2>
 4dc:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4e0:	75 2d                	jne    50f <printf+0xdf>
        printint(fd, *ap, 16, 0);
 4e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4e5:	8b 00                	mov    (%eax),%eax
 4e7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 4ee:	00 
 4ef:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 4f6:	00 
 4f7:	89 44 24 04          	mov    %eax,0x4(%esp)
 4fb:	8b 45 08             	mov    0x8(%ebp),%eax
 4fe:	89 04 24             	mov    %eax,(%esp)
 501:	e8 7a fe ff ff       	call   380 <printint>
        ap++;
 506:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 50a:	e9 b1 00 00 00       	jmp    5c0 <printf+0x190>
      } else if(c == 's'){
 50f:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 513:	75 43                	jne    558 <printf+0x128>
        s = (char*)*ap;
 515:	8b 45 e8             	mov    -0x18(%ebp),%eax
 518:	8b 00                	mov    (%eax),%eax
 51a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 51d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 521:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 525:	75 25                	jne    54c <printf+0x11c>
          s = "(null)";
 527:	c7 45 f4 f7 07 00 00 	movl   $0x7f7,-0xc(%ebp)
        while(*s != 0){
 52e:	eb 1c                	jmp    54c <printf+0x11c>
          putc(fd, *s);
 530:	8b 45 f4             	mov    -0xc(%ebp),%eax
 533:	8a 00                	mov    (%eax),%al
 535:	0f be c0             	movsbl %al,%eax
 538:	89 44 24 04          	mov    %eax,0x4(%esp)
 53c:	8b 45 08             	mov    0x8(%ebp),%eax
 53f:	89 04 24             	mov    %eax,(%esp)
 542:	e8 11 fe ff ff       	call   358 <putc>
          s++;
 547:	ff 45 f4             	incl   -0xc(%ebp)
 54a:	eb 01                	jmp    54d <printf+0x11d>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 54c:	90                   	nop
 54d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 550:	8a 00                	mov    (%eax),%al
 552:	84 c0                	test   %al,%al
 554:	75 da                	jne    530 <printf+0x100>
 556:	eb 68                	jmp    5c0 <printf+0x190>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 558:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 55c:	75 1d                	jne    57b <printf+0x14b>
        putc(fd, *ap);
 55e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 561:	8b 00                	mov    (%eax),%eax
 563:	0f be c0             	movsbl %al,%eax
 566:	89 44 24 04          	mov    %eax,0x4(%esp)
 56a:	8b 45 08             	mov    0x8(%ebp),%eax
 56d:	89 04 24             	mov    %eax,(%esp)
 570:	e8 e3 fd ff ff       	call   358 <putc>
        ap++;
 575:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 579:	eb 45                	jmp    5c0 <printf+0x190>
      } else if(c == '%'){
 57b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 57f:	75 17                	jne    598 <printf+0x168>
        putc(fd, c);
 581:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 584:	0f be c0             	movsbl %al,%eax
 587:	89 44 24 04          	mov    %eax,0x4(%esp)
 58b:	8b 45 08             	mov    0x8(%ebp),%eax
 58e:	89 04 24             	mov    %eax,(%esp)
 591:	e8 c2 fd ff ff       	call   358 <putc>
 596:	eb 28                	jmp    5c0 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 598:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 59f:	00 
 5a0:	8b 45 08             	mov    0x8(%ebp),%eax
 5a3:	89 04 24             	mov    %eax,(%esp)
 5a6:	e8 ad fd ff ff       	call   358 <putc>
        putc(fd, c);
 5ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5ae:	0f be c0             	movsbl %al,%eax
 5b1:	89 44 24 04          	mov    %eax,0x4(%esp)
 5b5:	8b 45 08             	mov    0x8(%ebp),%eax
 5b8:	89 04 24             	mov    %eax,(%esp)
 5bb:	e8 98 fd ff ff       	call   358 <putc>
      }
      state = 0;
 5c0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5c7:	ff 45 f0             	incl   -0x10(%ebp)
 5ca:	8b 55 0c             	mov    0xc(%ebp),%edx
 5cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5d0:	01 d0                	add    %edx,%eax
 5d2:	8a 00                	mov    (%eax),%al
 5d4:	84 c0                	test   %al,%al
 5d6:	0f 85 76 fe ff ff    	jne    452 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5dc:	c9                   	leave  
 5dd:	c3                   	ret    
 5de:	66 90                	xchg   %ax,%ax

000005e0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5e0:	55                   	push   %ebp
 5e1:	89 e5                	mov    %esp,%ebp
 5e3:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5e6:	8b 45 08             	mov    0x8(%ebp),%eax
 5e9:	83 e8 08             	sub    $0x8,%eax
 5ec:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5ef:	a1 78 0a 00 00       	mov    0xa78,%eax
 5f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5f7:	eb 24                	jmp    61d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5fc:	8b 00                	mov    (%eax),%eax
 5fe:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 601:	77 12                	ja     615 <free+0x35>
 603:	8b 45 f8             	mov    -0x8(%ebp),%eax
 606:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 609:	77 24                	ja     62f <free+0x4f>
 60b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 60e:	8b 00                	mov    (%eax),%eax
 610:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 613:	77 1a                	ja     62f <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 615:	8b 45 fc             	mov    -0x4(%ebp),%eax
 618:	8b 00                	mov    (%eax),%eax
 61a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 61d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 620:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 623:	76 d4                	jbe    5f9 <free+0x19>
 625:	8b 45 fc             	mov    -0x4(%ebp),%eax
 628:	8b 00                	mov    (%eax),%eax
 62a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 62d:	76 ca                	jbe    5f9 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 62f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 632:	8b 40 04             	mov    0x4(%eax),%eax
 635:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 63c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63f:	01 c2                	add    %eax,%edx
 641:	8b 45 fc             	mov    -0x4(%ebp),%eax
 644:	8b 00                	mov    (%eax),%eax
 646:	39 c2                	cmp    %eax,%edx
 648:	75 24                	jne    66e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 64a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 64d:	8b 50 04             	mov    0x4(%eax),%edx
 650:	8b 45 fc             	mov    -0x4(%ebp),%eax
 653:	8b 00                	mov    (%eax),%eax
 655:	8b 40 04             	mov    0x4(%eax),%eax
 658:	01 c2                	add    %eax,%edx
 65a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 660:	8b 45 fc             	mov    -0x4(%ebp),%eax
 663:	8b 00                	mov    (%eax),%eax
 665:	8b 10                	mov    (%eax),%edx
 667:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66a:	89 10                	mov    %edx,(%eax)
 66c:	eb 0a                	jmp    678 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 66e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 671:	8b 10                	mov    (%eax),%edx
 673:	8b 45 f8             	mov    -0x8(%ebp),%eax
 676:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 678:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67b:	8b 40 04             	mov    0x4(%eax),%eax
 67e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 685:	8b 45 fc             	mov    -0x4(%ebp),%eax
 688:	01 d0                	add    %edx,%eax
 68a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 68d:	75 20                	jne    6af <free+0xcf>
    p->s.size += bp->s.size;
 68f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 692:	8b 50 04             	mov    0x4(%eax),%edx
 695:	8b 45 f8             	mov    -0x8(%ebp),%eax
 698:	8b 40 04             	mov    0x4(%eax),%eax
 69b:	01 c2                	add    %eax,%edx
 69d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a0:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a6:	8b 10                	mov    (%eax),%edx
 6a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ab:	89 10                	mov    %edx,(%eax)
 6ad:	eb 08                	jmp    6b7 <free+0xd7>
  } else
    p->s.ptr = bp;
 6af:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b2:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6b5:	89 10                	mov    %edx,(%eax)
  freep = p;
 6b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ba:	a3 78 0a 00 00       	mov    %eax,0xa78
}
 6bf:	c9                   	leave  
 6c0:	c3                   	ret    

000006c1 <morecore>:

static Header*
morecore(uint nu)
{
 6c1:	55                   	push   %ebp
 6c2:	89 e5                	mov    %esp,%ebp
 6c4:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6c7:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6ce:	77 07                	ja     6d7 <morecore+0x16>
    nu = 4096;
 6d0:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6d7:	8b 45 08             	mov    0x8(%ebp),%eax
 6da:	c1 e0 03             	shl    $0x3,%eax
 6dd:	89 04 24             	mov    %eax,(%esp)
 6e0:	e8 43 fc ff ff       	call   328 <sbrk>
 6e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6e8:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6ec:	75 07                	jne    6f5 <morecore+0x34>
    return 0;
 6ee:	b8 00 00 00 00       	mov    $0x0,%eax
 6f3:	eb 22                	jmp    717 <morecore+0x56>
  hp = (Header*)p;
 6f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6fe:	8b 55 08             	mov    0x8(%ebp),%edx
 701:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 704:	8b 45 f0             	mov    -0x10(%ebp),%eax
 707:	83 c0 08             	add    $0x8,%eax
 70a:	89 04 24             	mov    %eax,(%esp)
 70d:	e8 ce fe ff ff       	call   5e0 <free>
  return freep;
 712:	a1 78 0a 00 00       	mov    0xa78,%eax
}
 717:	c9                   	leave  
 718:	c3                   	ret    

00000719 <malloc>:

void*
malloc(uint nbytes)
{
 719:	55                   	push   %ebp
 71a:	89 e5                	mov    %esp,%ebp
 71c:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 71f:	8b 45 08             	mov    0x8(%ebp),%eax
 722:	83 c0 07             	add    $0x7,%eax
 725:	c1 e8 03             	shr    $0x3,%eax
 728:	40                   	inc    %eax
 729:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 72c:	a1 78 0a 00 00       	mov    0xa78,%eax
 731:	89 45 f0             	mov    %eax,-0x10(%ebp)
 734:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 738:	75 23                	jne    75d <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 73a:	c7 45 f0 70 0a 00 00 	movl   $0xa70,-0x10(%ebp)
 741:	8b 45 f0             	mov    -0x10(%ebp),%eax
 744:	a3 78 0a 00 00       	mov    %eax,0xa78
 749:	a1 78 0a 00 00       	mov    0xa78,%eax
 74e:	a3 70 0a 00 00       	mov    %eax,0xa70
    base.s.size = 0;
 753:	c7 05 74 0a 00 00 00 	movl   $0x0,0xa74
 75a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 75d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 760:	8b 00                	mov    (%eax),%eax
 762:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 765:	8b 45 f4             	mov    -0xc(%ebp),%eax
 768:	8b 40 04             	mov    0x4(%eax),%eax
 76b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 76e:	72 4d                	jb     7bd <malloc+0xa4>
      if(p->s.size == nunits)
 770:	8b 45 f4             	mov    -0xc(%ebp),%eax
 773:	8b 40 04             	mov    0x4(%eax),%eax
 776:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 779:	75 0c                	jne    787 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 77b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77e:	8b 10                	mov    (%eax),%edx
 780:	8b 45 f0             	mov    -0x10(%ebp),%eax
 783:	89 10                	mov    %edx,(%eax)
 785:	eb 26                	jmp    7ad <malloc+0x94>
      else {
        p->s.size -= nunits;
 787:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78a:	8b 40 04             	mov    0x4(%eax),%eax
 78d:	89 c2                	mov    %eax,%edx
 78f:	2b 55 ec             	sub    -0x14(%ebp),%edx
 792:	8b 45 f4             	mov    -0xc(%ebp),%eax
 795:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 798:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79b:	8b 40 04             	mov    0x4(%eax),%eax
 79e:	c1 e0 03             	shl    $0x3,%eax
 7a1:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a7:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7aa:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b0:	a3 78 0a 00 00       	mov    %eax,0xa78
      return (void*)(p + 1);
 7b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b8:	83 c0 08             	add    $0x8,%eax
 7bb:	eb 38                	jmp    7f5 <malloc+0xdc>
    }
    if(p == freep)
 7bd:	a1 78 0a 00 00       	mov    0xa78,%eax
 7c2:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7c5:	75 1b                	jne    7e2 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 7c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7ca:	89 04 24             	mov    %eax,(%esp)
 7cd:	e8 ef fe ff ff       	call   6c1 <morecore>
 7d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7d9:	75 07                	jne    7e2 <malloc+0xc9>
        return 0;
 7db:	b8 00 00 00 00       	mov    $0x0,%eax
 7e0:	eb 13                	jmp    7f5 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7eb:	8b 00                	mov    (%eax),%eax
 7ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 7f0:	e9 70 ff ff ff       	jmp    765 <malloc+0x4c>
}
 7f5:	c9                   	leave  
 7f6:	c3                   	ret    
