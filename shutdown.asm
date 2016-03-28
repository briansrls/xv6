
_shutdown:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
	halt();
   6:	e8 35 03 00 00       	call   340 <halt>
	exit();
   b:	e8 90 02 00 00       	call   2a0 <exit>

00000010 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  10:	55                   	push   %ebp
  11:	89 e5                	mov    %esp,%ebp
  13:	57                   	push   %edi
  14:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  15:	8b 4d 08             	mov    0x8(%ebp),%ecx
  18:	8b 55 10             	mov    0x10(%ebp),%edx
  1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  1e:	89 cb                	mov    %ecx,%ebx
  20:	89 df                	mov    %ebx,%edi
  22:	89 d1                	mov    %edx,%ecx
  24:	fc                   	cld    
  25:	f3 aa                	rep stos %al,%es:(%edi)
  27:	89 ca                	mov    %ecx,%edx
  29:	89 fb                	mov    %edi,%ebx
  2b:	89 5d 08             	mov    %ebx,0x8(%ebp)
  2e:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  31:	5b                   	pop    %ebx
  32:	5f                   	pop    %edi
  33:	5d                   	pop    %ebp
  34:	c3                   	ret    

00000035 <strcpy>:
#include "x86.h"
#include "signal.h"

char*
strcpy(char *s, char *t)
{
  35:	55                   	push   %ebp
  36:	89 e5                	mov    %esp,%ebp
  38:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  3b:	8b 45 08             	mov    0x8(%ebp),%eax
  3e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  41:	8b 45 0c             	mov    0xc(%ebp),%eax
  44:	0f b6 10             	movzbl (%eax),%edx
  47:	8b 45 08             	mov    0x8(%ebp),%eax
  4a:	88 10                	mov    %dl,(%eax)
  4c:	8b 45 08             	mov    0x8(%ebp),%eax
  4f:	0f b6 00             	movzbl (%eax),%eax
  52:	84 c0                	test   %al,%al
  54:	0f 95 c0             	setne  %al
  57:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  5b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  5f:	84 c0                	test   %al,%al
  61:	75 de                	jne    41 <strcpy+0xc>
    ;
  return os;
  63:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  66:	c9                   	leave  
  67:	c3                   	ret    

00000068 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  68:	55                   	push   %ebp
  69:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  6b:	eb 08                	jmp    75 <strcmp+0xd>
    p++, q++;
  6d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  71:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  75:	8b 45 08             	mov    0x8(%ebp),%eax
  78:	0f b6 00             	movzbl (%eax),%eax
  7b:	84 c0                	test   %al,%al
  7d:	74 10                	je     8f <strcmp+0x27>
  7f:	8b 45 08             	mov    0x8(%ebp),%eax
  82:	0f b6 10             	movzbl (%eax),%edx
  85:	8b 45 0c             	mov    0xc(%ebp),%eax
  88:	0f b6 00             	movzbl (%eax),%eax
  8b:	38 c2                	cmp    %al,%dl
  8d:	74 de                	je     6d <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  8f:	8b 45 08             	mov    0x8(%ebp),%eax
  92:	0f b6 00             	movzbl (%eax),%eax
  95:	0f b6 d0             	movzbl %al,%edx
  98:	8b 45 0c             	mov    0xc(%ebp),%eax
  9b:	0f b6 00             	movzbl (%eax),%eax
  9e:	0f b6 c0             	movzbl %al,%eax
  a1:	89 d1                	mov    %edx,%ecx
  a3:	29 c1                	sub    %eax,%ecx
  a5:	89 c8                	mov    %ecx,%eax
}
  a7:	5d                   	pop    %ebp
  a8:	c3                   	ret    

000000a9 <strlen>:

uint
strlen(char *s)
{
  a9:	55                   	push   %ebp
  aa:	89 e5                	mov    %esp,%ebp
  ac:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  b6:	eb 04                	jmp    bc <strlen+0x13>
  b8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  bf:	03 45 08             	add    0x8(%ebp),%eax
  c2:	0f b6 00             	movzbl (%eax),%eax
  c5:	84 c0                	test   %al,%al
  c7:	75 ef                	jne    b8 <strlen+0xf>
    ;
  return n;
  c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  cc:	c9                   	leave  
  cd:	c3                   	ret    

000000ce <memset>:

void*
memset(void *dst, int c, uint n)
{
  ce:	55                   	push   %ebp
  cf:	89 e5                	mov    %esp,%ebp
  d1:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
  d4:	8b 45 10             	mov    0x10(%ebp),%eax
  d7:	89 44 24 08          	mov    %eax,0x8(%esp)
  db:	8b 45 0c             	mov    0xc(%ebp),%eax
  de:	89 44 24 04          	mov    %eax,0x4(%esp)
  e2:	8b 45 08             	mov    0x8(%ebp),%eax
  e5:	89 04 24             	mov    %eax,(%esp)
  e8:	e8 23 ff ff ff       	call   10 <stosb>
  return dst;
  ed:	8b 45 08             	mov    0x8(%ebp),%eax
}
  f0:	c9                   	leave  
  f1:	c3                   	ret    

000000f2 <strchr>:

char*
strchr(const char *s, char c)
{
  f2:	55                   	push   %ebp
  f3:	89 e5                	mov    %esp,%ebp
  f5:	83 ec 04             	sub    $0x4,%esp
  f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  fb:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
  fe:	eb 14                	jmp    114 <strchr+0x22>
    if(*s == c)
 100:	8b 45 08             	mov    0x8(%ebp),%eax
 103:	0f b6 00             	movzbl (%eax),%eax
 106:	3a 45 fc             	cmp    -0x4(%ebp),%al
 109:	75 05                	jne    110 <strchr+0x1e>
      return (char*)s;
 10b:	8b 45 08             	mov    0x8(%ebp),%eax
 10e:	eb 13                	jmp    123 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 110:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 114:	8b 45 08             	mov    0x8(%ebp),%eax
 117:	0f b6 00             	movzbl (%eax),%eax
 11a:	84 c0                	test   %al,%al
 11c:	75 e2                	jne    100 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 11e:	b8 00 00 00 00       	mov    $0x0,%eax
}
 123:	c9                   	leave  
 124:	c3                   	ret    

00000125 <gets>:

char*
gets(char *buf, int max)
{
 125:	55                   	push   %ebp
 126:	89 e5                	mov    %esp,%ebp
 128:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 12b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 132:	eb 44                	jmp    178 <gets+0x53>
    cc = read(0, &c, 1);
 134:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 13b:	00 
 13c:	8d 45 ef             	lea    -0x11(%ebp),%eax
 13f:	89 44 24 04          	mov    %eax,0x4(%esp)
 143:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 14a:	e8 69 01 00 00       	call   2b8 <read>
 14f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(cc < 1)
 152:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 156:	7e 2d                	jle    185 <gets+0x60>
      break;
    buf[i++] = c;
 158:	8b 45 f0             	mov    -0x10(%ebp),%eax
 15b:	03 45 08             	add    0x8(%ebp),%eax
 15e:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 162:	88 10                	mov    %dl,(%eax)
 164:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    if(c == '\n' || c == '\r')
 168:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 16c:	3c 0a                	cmp    $0xa,%al
 16e:	74 16                	je     186 <gets+0x61>
 170:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 174:	3c 0d                	cmp    $0xd,%al
 176:	74 0e                	je     186 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 178:	8b 45 f0             	mov    -0x10(%ebp),%eax
 17b:	83 c0 01             	add    $0x1,%eax
 17e:	3b 45 0c             	cmp    0xc(%ebp),%eax
 181:	7c b1                	jl     134 <gets+0xf>
 183:	eb 01                	jmp    186 <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 185:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 186:	8b 45 f0             	mov    -0x10(%ebp),%eax
 189:	03 45 08             	add    0x8(%ebp),%eax
 18c:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 18f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 192:	c9                   	leave  
 193:	c3                   	ret    

00000194 <stat>:

int
stat(char *n, struct stat *st)
{
 194:	55                   	push   %ebp
 195:	89 e5                	mov    %esp,%ebp
 197:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 19a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1a1:	00 
 1a2:	8b 45 08             	mov    0x8(%ebp),%eax
 1a5:	89 04 24             	mov    %eax,(%esp)
 1a8:	e8 33 01 00 00       	call   2e0 <open>
 1ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0)
 1b0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1b4:	79 07                	jns    1bd <stat+0x29>
    return -1;
 1b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1bb:	eb 23                	jmp    1e0 <stat+0x4c>
  r = fstat(fd, st);
 1bd:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c0:	89 44 24 04          	mov    %eax,0x4(%esp)
 1c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1c7:	89 04 24             	mov    %eax,(%esp)
 1ca:	e8 29 01 00 00       	call   2f8 <fstat>
 1cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  close(fd);
 1d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1d5:	89 04 24             	mov    %eax,(%esp)
 1d8:	e8 eb 00 00 00       	call   2c8 <close>
  return r;
 1dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 1e0:	c9                   	leave  
 1e1:	c3                   	ret    

000001e2 <atoi>:

int
atoi(const char *s)
{
 1e2:	55                   	push   %ebp
 1e3:	89 e5                	mov    %esp,%ebp
 1e5:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 1e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 1ef:	eb 24                	jmp    215 <atoi+0x33>
    n = n*10 + *s++ - '0';
 1f1:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1f4:	89 d0                	mov    %edx,%eax
 1f6:	c1 e0 02             	shl    $0x2,%eax
 1f9:	01 d0                	add    %edx,%eax
 1fb:	01 c0                	add    %eax,%eax
 1fd:	89 c2                	mov    %eax,%edx
 1ff:	8b 45 08             	mov    0x8(%ebp),%eax
 202:	0f b6 00             	movzbl (%eax),%eax
 205:	0f be c0             	movsbl %al,%eax
 208:	8d 04 02             	lea    (%edx,%eax,1),%eax
 20b:	83 e8 30             	sub    $0x30,%eax
 20e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 211:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 215:	8b 45 08             	mov    0x8(%ebp),%eax
 218:	0f b6 00             	movzbl (%eax),%eax
 21b:	3c 2f                	cmp    $0x2f,%al
 21d:	7e 0a                	jle    229 <atoi+0x47>
 21f:	8b 45 08             	mov    0x8(%ebp),%eax
 222:	0f b6 00             	movzbl (%eax),%eax
 225:	3c 39                	cmp    $0x39,%al
 227:	7e c8                	jle    1f1 <atoi+0xf>
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
 237:	89 45 f8             	mov    %eax,-0x8(%ebp)
  src = vsrc;
 23a:	8b 45 0c             	mov    0xc(%ebp),%eax
 23d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0)
 240:	eb 13                	jmp    255 <memmove+0x27>
    *dst++ = *src++;
 242:	8b 45 fc             	mov    -0x4(%ebp),%eax
 245:	0f b6 10             	movzbl (%eax),%edx
 248:	8b 45 f8             	mov    -0x8(%ebp),%eax
 24b:	88 10                	mov    %dl,(%eax)
 24d:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 251:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 255:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 259:	0f 9f c0             	setg   %al
 25c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 260:	84 c0                	test   %al,%al
 262:	75 de                	jne    242 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 264:	8b 45 08             	mov    0x8(%ebp),%eax
}
 267:	c9                   	leave  
 268:	c3                   	ret    

00000269 <trampoline>:
 269:	5a                   	pop    %edx
 26a:	59                   	pop    %ecx
 26b:	58                   	pop    %eax
 26c:	c9                   	leave  
 26d:	c3                   	ret    

0000026e <signal>:
//	"addl 4, %esp\n\t"
	"leave\n\t"
	"ret\n\t"
);
int signal(int signum, sighandler_t handler) 
{
 26e:	55                   	push   %ebp
 26f:	89 e5                	mov    %esp,%ebp
 271:	83 ec 18             	sub    $0x18,%esp
	register_signal_handler(signum, handler, trampoline);
 274:	c7 44 24 08 69 02 00 	movl   $0x269,0x8(%esp)
 27b:	00 
 27c:	8b 45 0c             	mov    0xc(%ebp),%eax
 27f:	89 44 24 04          	mov    %eax,0x4(%esp)
 283:	8b 45 08             	mov    0x8(%ebp),%eax
 286:	89 04 24             	mov    %eax,(%esp)
 289:	e8 ba 00 00 00       	call   348 <register_signal_handler>
	return 0;
 28e:	b8 00 00 00 00       	mov    $0x0,%eax
}
 293:	c9                   	leave  
 294:	c3                   	ret    
 295:	90                   	nop
 296:	90                   	nop
 297:	90                   	nop

00000298 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 298:	b8 01 00 00 00       	mov    $0x1,%eax
 29d:	cd 40                	int    $0x40
 29f:	c3                   	ret    

000002a0 <exit>:
SYSCALL(exit)
 2a0:	b8 02 00 00 00       	mov    $0x2,%eax
 2a5:	cd 40                	int    $0x40
 2a7:	c3                   	ret    

000002a8 <wait>:
SYSCALL(wait)
 2a8:	b8 03 00 00 00       	mov    $0x3,%eax
 2ad:	cd 40                	int    $0x40
 2af:	c3                   	ret    

000002b0 <pipe>:
SYSCALL(pipe)
 2b0:	b8 04 00 00 00       	mov    $0x4,%eax
 2b5:	cd 40                	int    $0x40
 2b7:	c3                   	ret    

000002b8 <read>:
SYSCALL(read)
 2b8:	b8 05 00 00 00       	mov    $0x5,%eax
 2bd:	cd 40                	int    $0x40
 2bf:	c3                   	ret    

000002c0 <write>:
SYSCALL(write)
 2c0:	b8 10 00 00 00       	mov    $0x10,%eax
 2c5:	cd 40                	int    $0x40
 2c7:	c3                   	ret    

000002c8 <close>:
SYSCALL(close)
 2c8:	b8 15 00 00 00       	mov    $0x15,%eax
 2cd:	cd 40                	int    $0x40
 2cf:	c3                   	ret    

000002d0 <kill>:
SYSCALL(kill)
 2d0:	b8 06 00 00 00       	mov    $0x6,%eax
 2d5:	cd 40                	int    $0x40
 2d7:	c3                   	ret    

000002d8 <exec>:
SYSCALL(exec)
 2d8:	b8 07 00 00 00       	mov    $0x7,%eax
 2dd:	cd 40                	int    $0x40
 2df:	c3                   	ret    

000002e0 <open>:
SYSCALL(open)
 2e0:	b8 0f 00 00 00       	mov    $0xf,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <mknod>:
SYSCALL(mknod)
 2e8:	b8 11 00 00 00       	mov    $0x11,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <unlink>:
SYSCALL(unlink)
 2f0:	b8 12 00 00 00       	mov    $0x12,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <fstat>:
SYSCALL(fstat)
 2f8:	b8 08 00 00 00       	mov    $0x8,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <link>:
SYSCALL(link)
 300:	b8 13 00 00 00       	mov    $0x13,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <mkdir>:
SYSCALL(mkdir)
 308:	b8 14 00 00 00       	mov    $0x14,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <chdir>:
SYSCALL(chdir)
 310:	b8 09 00 00 00       	mov    $0x9,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <dup>:
SYSCALL(dup)
 318:	b8 0a 00 00 00       	mov    $0xa,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <getpid>:
SYSCALL(getpid)
 320:	b8 0b 00 00 00       	mov    $0xb,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <sbrk>:
SYSCALL(sbrk)
 328:	b8 0c 00 00 00       	mov    $0xc,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <sleep>:
SYSCALL(sleep)
 330:	b8 0d 00 00 00       	mov    $0xd,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <uptime>:
SYSCALL(uptime)
 338:	b8 0e 00 00 00       	mov    $0xe,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <halt>:
SYSCALL(halt)
 340:	b8 16 00 00 00       	mov    $0x16,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <register_signal_handler>:
SYSCALL(register_signal_handler)
 348:	b8 17 00 00 00       	mov    $0x17,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <alarm>:
SYSCALL(alarm)
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
 383:	53                   	push   %ebx
 384:	83 ec 44             	sub    $0x44,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 387:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 38e:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 392:	74 17                	je     3ab <printint+0x2b>
 394:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 398:	79 11                	jns    3ab <printint+0x2b>
    neg = 1;
 39a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3a1:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a4:	f7 d8                	neg    %eax
 3a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3a9:	eb 06                	jmp    3b1 <printint+0x31>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3ab:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }

  i = 0;
 3b1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  do{
    buf[i++] = digits[x % base];
 3b8:	8b 4d ec             	mov    -0x14(%ebp),%ecx
 3bb:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3be:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3c1:	ba 00 00 00 00       	mov    $0x0,%edx
 3c6:	f7 f3                	div    %ebx
 3c8:	89 d0                	mov    %edx,%eax
 3ca:	0f b6 80 04 08 00 00 	movzbl 0x804(%eax),%eax
 3d1:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
 3d5:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  }while((x /= base) != 0);
 3d9:	8b 45 10             	mov    0x10(%ebp),%eax
 3dc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 3df:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3e2:	ba 00 00 00 00       	mov    $0x0,%edx
 3e7:	f7 75 d4             	divl   -0x2c(%ebp)
 3ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 3f1:	75 c5                	jne    3b8 <printint+0x38>
  if(neg)
 3f3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3f7:	74 2a                	je     423 <printint+0xa3>
    buf[i++] = '-';
 3f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3fc:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)
 401:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)

  while(--i >= 0)
 405:	eb 1d                	jmp    424 <printint+0xa4>
    putc(fd, buf[i]);
 407:	8b 45 ec             	mov    -0x14(%ebp),%eax
 40a:	0f b6 44 05 dc       	movzbl -0x24(%ebp,%eax,1),%eax
 40f:	0f be c0             	movsbl %al,%eax
 412:	89 44 24 04          	mov    %eax,0x4(%esp)
 416:	8b 45 08             	mov    0x8(%ebp),%eax
 419:	89 04 24             	mov    %eax,(%esp)
 41c:	e8 37 ff ff ff       	call   358 <putc>
 421:	eb 01                	jmp    424 <printint+0xa4>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 423:	90                   	nop
 424:	83 6d ec 01          	subl   $0x1,-0x14(%ebp)
 428:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 42c:	79 d9                	jns    407 <printint+0x87>
    putc(fd, buf[i]);
}
 42e:	83 c4 44             	add    $0x44,%esp
 431:	5b                   	pop    %ebx
 432:	5d                   	pop    %ebp
 433:	c3                   	ret    

00000434 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 434:	55                   	push   %ebp
 435:	89 e5                	mov    %esp,%ebp
 437:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 43a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 441:	8d 45 0c             	lea    0xc(%ebp),%eax
 444:	83 c0 04             	add    $0x4,%eax
 447:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i = 0; fmt[i]; i++){
 44a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 451:	e9 7e 01 00 00       	jmp    5d4 <printf+0x1a0>
    c = fmt[i] & 0xff;
 456:	8b 55 0c             	mov    0xc(%ebp),%edx
 459:	8b 45 ec             	mov    -0x14(%ebp),%eax
 45c:	8d 04 02             	lea    (%edx,%eax,1),%eax
 45f:	0f b6 00             	movzbl (%eax),%eax
 462:	0f be c0             	movsbl %al,%eax
 465:	25 ff 00 00 00       	and    $0xff,%eax
 46a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(state == 0){
 46d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 471:	75 2c                	jne    49f <printf+0x6b>
      if(c == '%'){
 473:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 477:	75 0c                	jne    485 <printf+0x51>
        state = '%';
 479:	c7 45 f0 25 00 00 00 	movl   $0x25,-0x10(%ebp)
 480:	e9 4b 01 00 00       	jmp    5d0 <printf+0x19c>
      } else {
        putc(fd, c);
 485:	8b 45 e8             	mov    -0x18(%ebp),%eax
 488:	0f be c0             	movsbl %al,%eax
 48b:	89 44 24 04          	mov    %eax,0x4(%esp)
 48f:	8b 45 08             	mov    0x8(%ebp),%eax
 492:	89 04 24             	mov    %eax,(%esp)
 495:	e8 be fe ff ff       	call   358 <putc>
 49a:	e9 31 01 00 00       	jmp    5d0 <printf+0x19c>
      }
    } else if(state == '%'){
 49f:	83 7d f0 25          	cmpl   $0x25,-0x10(%ebp)
 4a3:	0f 85 27 01 00 00    	jne    5d0 <printf+0x19c>
      if(c == 'd'){
 4a9:	83 7d e8 64          	cmpl   $0x64,-0x18(%ebp)
 4ad:	75 2d                	jne    4dc <printf+0xa8>
        printint(fd, *ap, 10, 1);
 4af:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4b2:	8b 00                	mov    (%eax),%eax
 4b4:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4bb:	00 
 4bc:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4c3:	00 
 4c4:	89 44 24 04          	mov    %eax,0x4(%esp)
 4c8:	8b 45 08             	mov    0x8(%ebp),%eax
 4cb:	89 04 24             	mov    %eax,(%esp)
 4ce:	e8 ad fe ff ff       	call   380 <printint>
        ap++;
 4d3:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 4d7:	e9 ed 00 00 00       	jmp    5c9 <printf+0x195>
      } else if(c == 'x' || c == 'p'){
 4dc:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
 4e0:	74 06                	je     4e8 <printf+0xb4>
 4e2:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
 4e6:	75 2d                	jne    515 <printf+0xe1>
        printint(fd, *ap, 16, 0);
 4e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4eb:	8b 00                	mov    (%eax),%eax
 4ed:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 4f4:	00 
 4f5:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 4fc:	00 
 4fd:	89 44 24 04          	mov    %eax,0x4(%esp)
 501:	8b 45 08             	mov    0x8(%ebp),%eax
 504:	89 04 24             	mov    %eax,(%esp)
 507:	e8 74 fe ff ff       	call   380 <printint>
        ap++;
 50c:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 510:	e9 b4 00 00 00       	jmp    5c9 <printf+0x195>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 515:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
 519:	75 46                	jne    561 <printf+0x12d>
        s = (char*)*ap;
 51b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 51e:	8b 00                	mov    (%eax),%eax
 520:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ap++;
 523:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
        if(s == 0)
 527:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 52b:	75 27                	jne    554 <printf+0x120>
          s = "(null)";
 52d:	c7 45 e4 fb 07 00 00 	movl   $0x7fb,-0x1c(%ebp)
        while(*s != 0){
 534:	eb 1f                	jmp    555 <printf+0x121>
          putc(fd, *s);
 536:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 539:	0f b6 00             	movzbl (%eax),%eax
 53c:	0f be c0             	movsbl %al,%eax
 53f:	89 44 24 04          	mov    %eax,0x4(%esp)
 543:	8b 45 08             	mov    0x8(%ebp),%eax
 546:	89 04 24             	mov    %eax,(%esp)
 549:	e8 0a fe ff ff       	call   358 <putc>
          s++;
 54e:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 552:	eb 01                	jmp    555 <printf+0x121>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 554:	90                   	nop
 555:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 558:	0f b6 00             	movzbl (%eax),%eax
 55b:	84 c0                	test   %al,%al
 55d:	75 d7                	jne    536 <printf+0x102>
 55f:	eb 68                	jmp    5c9 <printf+0x195>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 561:	83 7d e8 63          	cmpl   $0x63,-0x18(%ebp)
 565:	75 1d                	jne    584 <printf+0x150>
        putc(fd, *ap);
 567:	8b 45 f4             	mov    -0xc(%ebp),%eax
 56a:	8b 00                	mov    (%eax),%eax
 56c:	0f be c0             	movsbl %al,%eax
 56f:	89 44 24 04          	mov    %eax,0x4(%esp)
 573:	8b 45 08             	mov    0x8(%ebp),%eax
 576:	89 04 24             	mov    %eax,(%esp)
 579:	e8 da fd ff ff       	call   358 <putc>
        ap++;
 57e:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 582:	eb 45                	jmp    5c9 <printf+0x195>
      } else if(c == '%'){
 584:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 588:	75 17                	jne    5a1 <printf+0x16d>
        putc(fd, c);
 58a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 58d:	0f be c0             	movsbl %al,%eax
 590:	89 44 24 04          	mov    %eax,0x4(%esp)
 594:	8b 45 08             	mov    0x8(%ebp),%eax
 597:	89 04 24             	mov    %eax,(%esp)
 59a:	e8 b9 fd ff ff       	call   358 <putc>
 59f:	eb 28                	jmp    5c9 <printf+0x195>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5a1:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5a8:	00 
 5a9:	8b 45 08             	mov    0x8(%ebp),%eax
 5ac:	89 04 24             	mov    %eax,(%esp)
 5af:	e8 a4 fd ff ff       	call   358 <putc>
        putc(fd, c);
 5b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5b7:	0f be c0             	movsbl %al,%eax
 5ba:	89 44 24 04          	mov    %eax,0x4(%esp)
 5be:	8b 45 08             	mov    0x8(%ebp),%eax
 5c1:	89 04 24             	mov    %eax,(%esp)
 5c4:	e8 8f fd ff ff       	call   358 <putc>
      }
      state = 0;
 5c9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5d0:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 5d4:	8b 55 0c             	mov    0xc(%ebp),%edx
 5d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5da:	8d 04 02             	lea    (%edx,%eax,1),%eax
 5dd:	0f b6 00             	movzbl (%eax),%eax
 5e0:	84 c0                	test   %al,%al
 5e2:	0f 85 6e fe ff ff    	jne    456 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5e8:	c9                   	leave  
 5e9:	c3                   	ret    
 5ea:	90                   	nop
 5eb:	90                   	nop

000005ec <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5ec:	55                   	push   %ebp
 5ed:	89 e5                	mov    %esp,%ebp
 5ef:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5f2:	8b 45 08             	mov    0x8(%ebp),%eax
 5f5:	83 e8 08             	sub    $0x8,%eax
 5f8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5fb:	a1 20 08 00 00       	mov    0x820,%eax
 600:	89 45 fc             	mov    %eax,-0x4(%ebp)
 603:	eb 24                	jmp    629 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 605:	8b 45 fc             	mov    -0x4(%ebp),%eax
 608:	8b 00                	mov    (%eax),%eax
 60a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 60d:	77 12                	ja     621 <free+0x35>
 60f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 612:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 615:	77 24                	ja     63b <free+0x4f>
 617:	8b 45 fc             	mov    -0x4(%ebp),%eax
 61a:	8b 00                	mov    (%eax),%eax
 61c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 61f:	77 1a                	ja     63b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 621:	8b 45 fc             	mov    -0x4(%ebp),%eax
 624:	8b 00                	mov    (%eax),%eax
 626:	89 45 fc             	mov    %eax,-0x4(%ebp)
 629:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 62f:	76 d4                	jbe    605 <free+0x19>
 631:	8b 45 fc             	mov    -0x4(%ebp),%eax
 634:	8b 00                	mov    (%eax),%eax
 636:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 639:	76 ca                	jbe    605 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 63b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63e:	8b 40 04             	mov    0x4(%eax),%eax
 641:	c1 e0 03             	shl    $0x3,%eax
 644:	89 c2                	mov    %eax,%edx
 646:	03 55 f8             	add    -0x8(%ebp),%edx
 649:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64c:	8b 00                	mov    (%eax),%eax
 64e:	39 c2                	cmp    %eax,%edx
 650:	75 24                	jne    676 <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 652:	8b 45 f8             	mov    -0x8(%ebp),%eax
 655:	8b 50 04             	mov    0x4(%eax),%edx
 658:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65b:	8b 00                	mov    (%eax),%eax
 65d:	8b 40 04             	mov    0x4(%eax),%eax
 660:	01 c2                	add    %eax,%edx
 662:	8b 45 f8             	mov    -0x8(%ebp),%eax
 665:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 668:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66b:	8b 00                	mov    (%eax),%eax
 66d:	8b 10                	mov    (%eax),%edx
 66f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 672:	89 10                	mov    %edx,(%eax)
 674:	eb 0a                	jmp    680 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 676:	8b 45 fc             	mov    -0x4(%ebp),%eax
 679:	8b 10                	mov    (%eax),%edx
 67b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 680:	8b 45 fc             	mov    -0x4(%ebp),%eax
 683:	8b 40 04             	mov    0x4(%eax),%eax
 686:	c1 e0 03             	shl    $0x3,%eax
 689:	03 45 fc             	add    -0x4(%ebp),%eax
 68c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 68f:	75 20                	jne    6b1 <free+0xc5>
    p->s.size += bp->s.size;
 691:	8b 45 fc             	mov    -0x4(%ebp),%eax
 694:	8b 50 04             	mov    0x4(%eax),%edx
 697:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69a:	8b 40 04             	mov    0x4(%eax),%eax
 69d:	01 c2                	add    %eax,%edx
 69f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a2:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a8:	8b 10                	mov    (%eax),%edx
 6aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ad:	89 10                	mov    %edx,(%eax)
 6af:	eb 08                	jmp    6b9 <free+0xcd>
  } else
    p->s.ptr = bp;
 6b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b4:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6b7:	89 10                	mov    %edx,(%eax)
  freep = p;
 6b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bc:	a3 20 08 00 00       	mov    %eax,0x820
}
 6c1:	c9                   	leave  
 6c2:	c3                   	ret    

000006c3 <morecore>:

static Header*
morecore(uint nu)
{
 6c3:	55                   	push   %ebp
 6c4:	89 e5                	mov    %esp,%ebp
 6c6:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6c9:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6d0:	77 07                	ja     6d9 <morecore+0x16>
    nu = 4096;
 6d2:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6d9:	8b 45 08             	mov    0x8(%ebp),%eax
 6dc:	c1 e0 03             	shl    $0x3,%eax
 6df:	89 04 24             	mov    %eax,(%esp)
 6e2:	e8 41 fc ff ff       	call   328 <sbrk>
 6e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(p == (char*)-1)
 6ea:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
 6ee:	75 07                	jne    6f7 <morecore+0x34>
    return 0;
 6f0:	b8 00 00 00 00       	mov    $0x0,%eax
 6f5:	eb 22                	jmp    719 <morecore+0x56>
  hp = (Header*)p;
 6f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  hp->s.size = nu;
 6fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 700:	8b 55 08             	mov    0x8(%ebp),%edx
 703:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 706:	8b 45 f4             	mov    -0xc(%ebp),%eax
 709:	83 c0 08             	add    $0x8,%eax
 70c:	89 04 24             	mov    %eax,(%esp)
 70f:	e8 d8 fe ff ff       	call   5ec <free>
  return freep;
 714:	a1 20 08 00 00       	mov    0x820,%eax
}
 719:	c9                   	leave  
 71a:	c3                   	ret    

0000071b <malloc>:

void*
malloc(uint nbytes)
{
 71b:	55                   	push   %ebp
 71c:	89 e5                	mov    %esp,%ebp
 71e:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 721:	8b 45 08             	mov    0x8(%ebp),%eax
 724:	83 c0 07             	add    $0x7,%eax
 727:	c1 e8 03             	shr    $0x3,%eax
 72a:	83 c0 01             	add    $0x1,%eax
 72d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((prevp = freep) == 0){
 730:	a1 20 08 00 00       	mov    0x820,%eax
 735:	89 45 f0             	mov    %eax,-0x10(%ebp)
 738:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 73c:	75 23                	jne    761 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 73e:	c7 45 f0 18 08 00 00 	movl   $0x818,-0x10(%ebp)
 745:	8b 45 f0             	mov    -0x10(%ebp),%eax
 748:	a3 20 08 00 00       	mov    %eax,0x820
 74d:	a1 20 08 00 00       	mov    0x820,%eax
 752:	a3 18 08 00 00       	mov    %eax,0x818
    base.s.size = 0;
 757:	c7 05 1c 08 00 00 00 	movl   $0x0,0x81c
 75e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 761:	8b 45 f0             	mov    -0x10(%ebp),%eax
 764:	8b 00                	mov    (%eax),%eax
 766:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(p->s.size >= nunits){
 769:	8b 45 ec             	mov    -0x14(%ebp),%eax
 76c:	8b 40 04             	mov    0x4(%eax),%eax
 76f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 772:	72 4d                	jb     7c1 <malloc+0xa6>
      if(p->s.size == nunits)
 774:	8b 45 ec             	mov    -0x14(%ebp),%eax
 777:	8b 40 04             	mov    0x4(%eax),%eax
 77a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 77d:	75 0c                	jne    78b <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 77f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 782:	8b 10                	mov    (%eax),%edx
 784:	8b 45 f0             	mov    -0x10(%ebp),%eax
 787:	89 10                	mov    %edx,(%eax)
 789:	eb 26                	jmp    7b1 <malloc+0x96>
      else {
        p->s.size -= nunits;
 78b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 78e:	8b 40 04             	mov    0x4(%eax),%eax
 791:	89 c2                	mov    %eax,%edx
 793:	2b 55 f4             	sub    -0xc(%ebp),%edx
 796:	8b 45 ec             	mov    -0x14(%ebp),%eax
 799:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 79c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 79f:	8b 40 04             	mov    0x4(%eax),%eax
 7a2:	c1 e0 03             	shl    $0x3,%eax
 7a5:	01 45 ec             	add    %eax,-0x14(%ebp)
        p->s.size = nunits;
 7a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
 7ae:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b4:	a3 20 08 00 00       	mov    %eax,0x820
      return (void*)(p + 1);
 7b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7bc:	83 c0 08             	add    $0x8,%eax
 7bf:	eb 38                	jmp    7f9 <malloc+0xde>
    }
    if(p == freep)
 7c1:	a1 20 08 00 00       	mov    0x820,%eax
 7c6:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 7c9:	75 1b                	jne    7e6 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 7cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ce:	89 04 24             	mov    %eax,(%esp)
 7d1:	e8 ed fe ff ff       	call   6c3 <morecore>
 7d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 7d9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 7dd:	75 07                	jne    7e6 <malloc+0xcb>
        return 0;
 7df:	b8 00 00 00 00       	mov    $0x0,%eax
 7e4:	eb 13                	jmp    7f9 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7ef:	8b 00                	mov    (%eax),%eax
 7f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 7f4:	e9 70 ff ff ff       	jmp    769 <malloc+0x4e>
}
 7f9:	c9                   	leave  
 7fa:	c3                   	ret    
