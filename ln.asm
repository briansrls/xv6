
_ln:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 10             	sub    $0x10,%esp
  if(argc != 3){
   9:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
   d:	74 19                	je     28 <main+0x28>
    printf(2, "Usage: ln old new\n");
   f:	c7 44 24 04 67 08 00 	movl   $0x867,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 7d 04 00 00       	call   4a0 <printf>
    exit();
  23:	e8 e4 02 00 00       	call   30c <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  28:	8b 45 0c             	mov    0xc(%ebp),%eax
  2b:	83 c0 08             	add    $0x8,%eax
  2e:	8b 10                	mov    (%eax),%edx
  30:	8b 45 0c             	mov    0xc(%ebp),%eax
  33:	83 c0 04             	add    $0x4,%eax
  36:	8b 00                	mov    (%eax),%eax
  38:	89 54 24 04          	mov    %edx,0x4(%esp)
  3c:	89 04 24             	mov    %eax,(%esp)
  3f:	e8 28 03 00 00       	call   36c <link>
  44:	85 c0                	test   %eax,%eax
  46:	79 2c                	jns    74 <main+0x74>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  48:	8b 45 0c             	mov    0xc(%ebp),%eax
  4b:	83 c0 08             	add    $0x8,%eax
  4e:	8b 10                	mov    (%eax),%edx
  50:	8b 45 0c             	mov    0xc(%ebp),%eax
  53:	83 c0 04             	add    $0x4,%eax
  56:	8b 00                	mov    (%eax),%eax
  58:	89 54 24 0c          	mov    %edx,0xc(%esp)
  5c:	89 44 24 08          	mov    %eax,0x8(%esp)
  60:	c7 44 24 04 7a 08 00 	movl   $0x87a,0x4(%esp)
  67:	00 
  68:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  6f:	e8 2c 04 00 00       	call   4a0 <printf>
  exit();
  74:	e8 93 02 00 00       	call   30c <exit>
  79:	90                   	nop
  7a:	90                   	nop
  7b:	90                   	nop

0000007c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  7c:	55                   	push   %ebp
  7d:	89 e5                	mov    %esp,%ebp
  7f:	57                   	push   %edi
  80:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  81:	8b 4d 08             	mov    0x8(%ebp),%ecx
  84:	8b 55 10             	mov    0x10(%ebp),%edx
  87:	8b 45 0c             	mov    0xc(%ebp),%eax
  8a:	89 cb                	mov    %ecx,%ebx
  8c:	89 df                	mov    %ebx,%edi
  8e:	89 d1                	mov    %edx,%ecx
  90:	fc                   	cld    
  91:	f3 aa                	rep stos %al,%es:(%edi)
  93:	89 ca                	mov    %ecx,%edx
  95:	89 fb                	mov    %edi,%ebx
  97:	89 5d 08             	mov    %ebx,0x8(%ebp)
  9a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  9d:	5b                   	pop    %ebx
  9e:	5f                   	pop    %edi
  9f:	5d                   	pop    %ebp
  a0:	c3                   	ret    

000000a1 <strcpy>:
#include "x86.h"
#include "signal.h"

char*
strcpy(char *s, char *t)
{
  a1:	55                   	push   %ebp
  a2:	89 e5                	mov    %esp,%ebp
  a4:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  a7:	8b 45 08             	mov    0x8(%ebp),%eax
  aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  b0:	0f b6 10             	movzbl (%eax),%edx
  b3:	8b 45 08             	mov    0x8(%ebp),%eax
  b6:	88 10                	mov    %dl,(%eax)
  b8:	8b 45 08             	mov    0x8(%ebp),%eax
  bb:	0f b6 00             	movzbl (%eax),%eax
  be:	84 c0                	test   %al,%al
  c0:	0f 95 c0             	setne  %al
  c3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  c7:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  cb:	84 c0                	test   %al,%al
  cd:	75 de                	jne    ad <strcpy+0xc>
    ;
  return os;
  cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  d2:	c9                   	leave  
  d3:	c3                   	ret    

000000d4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  d4:	55                   	push   %ebp
  d5:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  d7:	eb 08                	jmp    e1 <strcmp+0xd>
    p++, q++;
  d9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  dd:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  e1:	8b 45 08             	mov    0x8(%ebp),%eax
  e4:	0f b6 00             	movzbl (%eax),%eax
  e7:	84 c0                	test   %al,%al
  e9:	74 10                	je     fb <strcmp+0x27>
  eb:	8b 45 08             	mov    0x8(%ebp),%eax
  ee:	0f b6 10             	movzbl (%eax),%edx
  f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  f4:	0f b6 00             	movzbl (%eax),%eax
  f7:	38 c2                	cmp    %al,%dl
  f9:	74 de                	je     d9 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  fb:	8b 45 08             	mov    0x8(%ebp),%eax
  fe:	0f b6 00             	movzbl (%eax),%eax
 101:	0f b6 d0             	movzbl %al,%edx
 104:	8b 45 0c             	mov    0xc(%ebp),%eax
 107:	0f b6 00             	movzbl (%eax),%eax
 10a:	0f b6 c0             	movzbl %al,%eax
 10d:	89 d1                	mov    %edx,%ecx
 10f:	29 c1                	sub    %eax,%ecx
 111:	89 c8                	mov    %ecx,%eax
}
 113:	5d                   	pop    %ebp
 114:	c3                   	ret    

00000115 <strlen>:

uint
strlen(char *s)
{
 115:	55                   	push   %ebp
 116:	89 e5                	mov    %esp,%ebp
 118:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 11b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 122:	eb 04                	jmp    128 <strlen+0x13>
 124:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 128:	8b 45 fc             	mov    -0x4(%ebp),%eax
 12b:	03 45 08             	add    0x8(%ebp),%eax
 12e:	0f b6 00             	movzbl (%eax),%eax
 131:	84 c0                	test   %al,%al
 133:	75 ef                	jne    124 <strlen+0xf>
    ;
  return n;
 135:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 138:	c9                   	leave  
 139:	c3                   	ret    

0000013a <memset>:

void*
memset(void *dst, int c, uint n)
{
 13a:	55                   	push   %ebp
 13b:	89 e5                	mov    %esp,%ebp
 13d:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 140:	8b 45 10             	mov    0x10(%ebp),%eax
 143:	89 44 24 08          	mov    %eax,0x8(%esp)
 147:	8b 45 0c             	mov    0xc(%ebp),%eax
 14a:	89 44 24 04          	mov    %eax,0x4(%esp)
 14e:	8b 45 08             	mov    0x8(%ebp),%eax
 151:	89 04 24             	mov    %eax,(%esp)
 154:	e8 23 ff ff ff       	call   7c <stosb>
  return dst;
 159:	8b 45 08             	mov    0x8(%ebp),%eax
}
 15c:	c9                   	leave  
 15d:	c3                   	ret    

0000015e <strchr>:

char*
strchr(const char *s, char c)
{
 15e:	55                   	push   %ebp
 15f:	89 e5                	mov    %esp,%ebp
 161:	83 ec 04             	sub    $0x4,%esp
 164:	8b 45 0c             	mov    0xc(%ebp),%eax
 167:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 16a:	eb 14                	jmp    180 <strchr+0x22>
    if(*s == c)
 16c:	8b 45 08             	mov    0x8(%ebp),%eax
 16f:	0f b6 00             	movzbl (%eax),%eax
 172:	3a 45 fc             	cmp    -0x4(%ebp),%al
 175:	75 05                	jne    17c <strchr+0x1e>
      return (char*)s;
 177:	8b 45 08             	mov    0x8(%ebp),%eax
 17a:	eb 13                	jmp    18f <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 17c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 180:	8b 45 08             	mov    0x8(%ebp),%eax
 183:	0f b6 00             	movzbl (%eax),%eax
 186:	84 c0                	test   %al,%al
 188:	75 e2                	jne    16c <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 18a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 18f:	c9                   	leave  
 190:	c3                   	ret    

00000191 <gets>:

char*
gets(char *buf, int max)
{
 191:	55                   	push   %ebp
 192:	89 e5                	mov    %esp,%ebp
 194:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 197:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 19e:	eb 44                	jmp    1e4 <gets+0x53>
    cc = read(0, &c, 1);
 1a0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1a7:	00 
 1a8:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1ab:	89 44 24 04          	mov    %eax,0x4(%esp)
 1af:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1b6:	e8 69 01 00 00       	call   324 <read>
 1bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(cc < 1)
 1be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1c2:	7e 2d                	jle    1f1 <gets+0x60>
      break;
    buf[i++] = c;
 1c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1c7:	03 45 08             	add    0x8(%ebp),%eax
 1ca:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 1ce:	88 10                	mov    %dl,(%eax)
 1d0:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    if(c == '\n' || c == '\r')
 1d4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d8:	3c 0a                	cmp    $0xa,%al
 1da:	74 16                	je     1f2 <gets+0x61>
 1dc:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1e0:	3c 0d                	cmp    $0xd,%al
 1e2:	74 0e                	je     1f2 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1e7:	83 c0 01             	add    $0x1,%eax
 1ea:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1ed:	7c b1                	jl     1a0 <gets+0xf>
 1ef:	eb 01                	jmp    1f2 <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1f1:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1f5:	03 45 08             	add    0x8(%ebp),%eax
 1f8:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1fb:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1fe:	c9                   	leave  
 1ff:	c3                   	ret    

00000200 <stat>:

int
stat(char *n, struct stat *st)
{
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 206:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 20d:	00 
 20e:	8b 45 08             	mov    0x8(%ebp),%eax
 211:	89 04 24             	mov    %eax,(%esp)
 214:	e8 33 01 00 00       	call   34c <open>
 219:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0)
 21c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 220:	79 07                	jns    229 <stat+0x29>
    return -1;
 222:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 227:	eb 23                	jmp    24c <stat+0x4c>
  r = fstat(fd, st);
 229:	8b 45 0c             	mov    0xc(%ebp),%eax
 22c:	89 44 24 04          	mov    %eax,0x4(%esp)
 230:	8b 45 f0             	mov    -0x10(%ebp),%eax
 233:	89 04 24             	mov    %eax,(%esp)
 236:	e8 29 01 00 00       	call   364 <fstat>
 23b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  close(fd);
 23e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 241:	89 04 24             	mov    %eax,(%esp)
 244:	e8 eb 00 00 00       	call   334 <close>
  return r;
 249:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 24c:	c9                   	leave  
 24d:	c3                   	ret    

0000024e <atoi>:

int
atoi(const char *s)
{
 24e:	55                   	push   %ebp
 24f:	89 e5                	mov    %esp,%ebp
 251:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 254:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 25b:	eb 24                	jmp    281 <atoi+0x33>
    n = n*10 + *s++ - '0';
 25d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 260:	89 d0                	mov    %edx,%eax
 262:	c1 e0 02             	shl    $0x2,%eax
 265:	01 d0                	add    %edx,%eax
 267:	01 c0                	add    %eax,%eax
 269:	89 c2                	mov    %eax,%edx
 26b:	8b 45 08             	mov    0x8(%ebp),%eax
 26e:	0f b6 00             	movzbl (%eax),%eax
 271:	0f be c0             	movsbl %al,%eax
 274:	8d 04 02             	lea    (%edx,%eax,1),%eax
 277:	83 e8 30             	sub    $0x30,%eax
 27a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 27d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 281:	8b 45 08             	mov    0x8(%ebp),%eax
 284:	0f b6 00             	movzbl (%eax),%eax
 287:	3c 2f                	cmp    $0x2f,%al
 289:	7e 0a                	jle    295 <atoi+0x47>
 28b:	8b 45 08             	mov    0x8(%ebp),%eax
 28e:	0f b6 00             	movzbl (%eax),%eax
 291:	3c 39                	cmp    $0x39,%al
 293:	7e c8                	jle    25d <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 295:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 298:	c9                   	leave  
 299:	c3                   	ret    

0000029a <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 29a:	55                   	push   %ebp
 29b:	89 e5                	mov    %esp,%ebp
 29d:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2a0:	8b 45 08             	mov    0x8(%ebp),%eax
 2a3:	89 45 f8             	mov    %eax,-0x8(%ebp)
  src = vsrc;
 2a6:	8b 45 0c             	mov    0xc(%ebp),%eax
 2a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0)
 2ac:	eb 13                	jmp    2c1 <memmove+0x27>
    *dst++ = *src++;
 2ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2b1:	0f b6 10             	movzbl (%eax),%edx
 2b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2b7:	88 10                	mov    %dl,(%eax)
 2b9:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 2bd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2c1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 2c5:	0f 9f c0             	setg   %al
 2c8:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 2cc:	84 c0                	test   %al,%al
 2ce:	75 de                	jne    2ae <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2d0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2d3:	c9                   	leave  
 2d4:	c3                   	ret    

000002d5 <trampoline>:
 2d5:	5a                   	pop    %edx
 2d6:	59                   	pop    %ecx
 2d7:	58                   	pop    %eax
 2d8:	c9                   	leave  
 2d9:	c3                   	ret    

000002da <signal>:
//	"addl 4, %esp\n\t"
	"leave\n\t"
	"ret\n\t"
);
int signal(int signum, sighandler_t handler) 
{
 2da:	55                   	push   %ebp
 2db:	89 e5                	mov    %esp,%ebp
 2dd:	83 ec 18             	sub    $0x18,%esp
	register_signal_handler(signum, handler, trampoline);
 2e0:	c7 44 24 08 d5 02 00 	movl   $0x2d5,0x8(%esp)
 2e7:	00 
 2e8:	8b 45 0c             	mov    0xc(%ebp),%eax
 2eb:	89 44 24 04          	mov    %eax,0x4(%esp)
 2ef:	8b 45 08             	mov    0x8(%ebp),%eax
 2f2:	89 04 24             	mov    %eax,(%esp)
 2f5:	e8 ba 00 00 00       	call   3b4 <register_signal_handler>
	return 0;
 2fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2ff:	c9                   	leave  
 300:	c3                   	ret    
 301:	90                   	nop
 302:	90                   	nop
 303:	90                   	nop

00000304 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 304:	b8 01 00 00 00       	mov    $0x1,%eax
 309:	cd 40                	int    $0x40
 30b:	c3                   	ret    

0000030c <exit>:
SYSCALL(exit)
 30c:	b8 02 00 00 00       	mov    $0x2,%eax
 311:	cd 40                	int    $0x40
 313:	c3                   	ret    

00000314 <wait>:
SYSCALL(wait)
 314:	b8 03 00 00 00       	mov    $0x3,%eax
 319:	cd 40                	int    $0x40
 31b:	c3                   	ret    

0000031c <pipe>:
SYSCALL(pipe)
 31c:	b8 04 00 00 00       	mov    $0x4,%eax
 321:	cd 40                	int    $0x40
 323:	c3                   	ret    

00000324 <read>:
SYSCALL(read)
 324:	b8 05 00 00 00       	mov    $0x5,%eax
 329:	cd 40                	int    $0x40
 32b:	c3                   	ret    

0000032c <write>:
SYSCALL(write)
 32c:	b8 10 00 00 00       	mov    $0x10,%eax
 331:	cd 40                	int    $0x40
 333:	c3                   	ret    

00000334 <close>:
SYSCALL(close)
 334:	b8 15 00 00 00       	mov    $0x15,%eax
 339:	cd 40                	int    $0x40
 33b:	c3                   	ret    

0000033c <kill>:
SYSCALL(kill)
 33c:	b8 06 00 00 00       	mov    $0x6,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <exec>:
SYSCALL(exec)
 344:	b8 07 00 00 00       	mov    $0x7,%eax
 349:	cd 40                	int    $0x40
 34b:	c3                   	ret    

0000034c <open>:
SYSCALL(open)
 34c:	b8 0f 00 00 00       	mov    $0xf,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <mknod>:
SYSCALL(mknod)
 354:	b8 11 00 00 00       	mov    $0x11,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <unlink>:
SYSCALL(unlink)
 35c:	b8 12 00 00 00       	mov    $0x12,%eax
 361:	cd 40                	int    $0x40
 363:	c3                   	ret    

00000364 <fstat>:
SYSCALL(fstat)
 364:	b8 08 00 00 00       	mov    $0x8,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret    

0000036c <link>:
SYSCALL(link)
 36c:	b8 13 00 00 00       	mov    $0x13,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret    

00000374 <mkdir>:
SYSCALL(mkdir)
 374:	b8 14 00 00 00       	mov    $0x14,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <chdir>:
SYSCALL(chdir)
 37c:	b8 09 00 00 00       	mov    $0x9,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <dup>:
SYSCALL(dup)
 384:	b8 0a 00 00 00       	mov    $0xa,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <getpid>:
SYSCALL(getpid)
 38c:	b8 0b 00 00 00       	mov    $0xb,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <sbrk>:
SYSCALL(sbrk)
 394:	b8 0c 00 00 00       	mov    $0xc,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <sleep>:
SYSCALL(sleep)
 39c:	b8 0d 00 00 00       	mov    $0xd,%eax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret    

000003a4 <uptime>:
SYSCALL(uptime)
 3a4:	b8 0e 00 00 00       	mov    $0xe,%eax
 3a9:	cd 40                	int    $0x40
 3ab:	c3                   	ret    

000003ac <halt>:
SYSCALL(halt)
 3ac:	b8 16 00 00 00       	mov    $0x16,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret    

000003b4 <register_signal_handler>:
SYSCALL(register_signal_handler)
 3b4:	b8 17 00 00 00       	mov    $0x17,%eax
 3b9:	cd 40                	int    $0x40
 3bb:	c3                   	ret    

000003bc <alarm>:
SYSCALL(alarm)
 3bc:	b8 18 00 00 00       	mov    $0x18,%eax
 3c1:	cd 40                	int    $0x40
 3c3:	c3                   	ret    

000003c4 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3c4:	55                   	push   %ebp
 3c5:	89 e5                	mov    %esp,%ebp
 3c7:	83 ec 28             	sub    $0x28,%esp
 3ca:	8b 45 0c             	mov    0xc(%ebp),%eax
 3cd:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3d0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3d7:	00 
 3d8:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3db:	89 44 24 04          	mov    %eax,0x4(%esp)
 3df:	8b 45 08             	mov    0x8(%ebp),%eax
 3e2:	89 04 24             	mov    %eax,(%esp)
 3e5:	e8 42 ff ff ff       	call   32c <write>
}
 3ea:	c9                   	leave  
 3eb:	c3                   	ret    

000003ec <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3ec:	55                   	push   %ebp
 3ed:	89 e5                	mov    %esp,%ebp
 3ef:	53                   	push   %ebx
 3f0:	83 ec 44             	sub    $0x44,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3f3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3fa:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3fe:	74 17                	je     417 <printint+0x2b>
 400:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 404:	79 11                	jns    417 <printint+0x2b>
    neg = 1;
 406:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 40d:	8b 45 0c             	mov    0xc(%ebp),%eax
 410:	f7 d8                	neg    %eax
 412:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 415:	eb 06                	jmp    41d <printint+0x31>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 417:	8b 45 0c             	mov    0xc(%ebp),%eax
 41a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }

  i = 0;
 41d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  do{
    buf[i++] = digits[x % base];
 424:	8b 4d ec             	mov    -0x14(%ebp),%ecx
 427:	8b 5d 10             	mov    0x10(%ebp),%ebx
 42a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 42d:	ba 00 00 00 00       	mov    $0x0,%edx
 432:	f7 f3                	div    %ebx
 434:	89 d0                	mov    %edx,%eax
 436:	0f b6 80 98 08 00 00 	movzbl 0x898(%eax),%eax
 43d:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
 441:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  }while((x /= base) != 0);
 445:	8b 45 10             	mov    0x10(%ebp),%eax
 448:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 44b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 44e:	ba 00 00 00 00       	mov    $0x0,%edx
 453:	f7 75 d4             	divl   -0x2c(%ebp)
 456:	89 45 f4             	mov    %eax,-0xc(%ebp)
 459:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 45d:	75 c5                	jne    424 <printint+0x38>
  if(neg)
 45f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 463:	74 2a                	je     48f <printint+0xa3>
    buf[i++] = '-';
 465:	8b 45 ec             	mov    -0x14(%ebp),%eax
 468:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)
 46d:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)

  while(--i >= 0)
 471:	eb 1d                	jmp    490 <printint+0xa4>
    putc(fd, buf[i]);
 473:	8b 45 ec             	mov    -0x14(%ebp),%eax
 476:	0f b6 44 05 dc       	movzbl -0x24(%ebp,%eax,1),%eax
 47b:	0f be c0             	movsbl %al,%eax
 47e:	89 44 24 04          	mov    %eax,0x4(%esp)
 482:	8b 45 08             	mov    0x8(%ebp),%eax
 485:	89 04 24             	mov    %eax,(%esp)
 488:	e8 37 ff ff ff       	call   3c4 <putc>
 48d:	eb 01                	jmp    490 <printint+0xa4>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 48f:	90                   	nop
 490:	83 6d ec 01          	subl   $0x1,-0x14(%ebp)
 494:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 498:	79 d9                	jns    473 <printint+0x87>
    putc(fd, buf[i]);
}
 49a:	83 c4 44             	add    $0x44,%esp
 49d:	5b                   	pop    %ebx
 49e:	5d                   	pop    %ebp
 49f:	c3                   	ret    

000004a0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4a0:	55                   	push   %ebp
 4a1:	89 e5                	mov    %esp,%ebp
 4a3:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4a6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4ad:	8d 45 0c             	lea    0xc(%ebp),%eax
 4b0:	83 c0 04             	add    $0x4,%eax
 4b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i = 0; fmt[i]; i++){
 4b6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 4bd:	e9 7e 01 00 00       	jmp    640 <printf+0x1a0>
    c = fmt[i] & 0xff;
 4c2:	8b 55 0c             	mov    0xc(%ebp),%edx
 4c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4c8:	8d 04 02             	lea    (%edx,%eax,1),%eax
 4cb:	0f b6 00             	movzbl (%eax),%eax
 4ce:	0f be c0             	movsbl %al,%eax
 4d1:	25 ff 00 00 00       	and    $0xff,%eax
 4d6:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(state == 0){
 4d9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4dd:	75 2c                	jne    50b <printf+0x6b>
      if(c == '%'){
 4df:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 4e3:	75 0c                	jne    4f1 <printf+0x51>
        state = '%';
 4e5:	c7 45 f0 25 00 00 00 	movl   $0x25,-0x10(%ebp)
 4ec:	e9 4b 01 00 00       	jmp    63c <printf+0x19c>
      } else {
        putc(fd, c);
 4f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4f4:	0f be c0             	movsbl %al,%eax
 4f7:	89 44 24 04          	mov    %eax,0x4(%esp)
 4fb:	8b 45 08             	mov    0x8(%ebp),%eax
 4fe:	89 04 24             	mov    %eax,(%esp)
 501:	e8 be fe ff ff       	call   3c4 <putc>
 506:	e9 31 01 00 00       	jmp    63c <printf+0x19c>
      }
    } else if(state == '%'){
 50b:	83 7d f0 25          	cmpl   $0x25,-0x10(%ebp)
 50f:	0f 85 27 01 00 00    	jne    63c <printf+0x19c>
      if(c == 'd'){
 515:	83 7d e8 64          	cmpl   $0x64,-0x18(%ebp)
 519:	75 2d                	jne    548 <printf+0xa8>
        printint(fd, *ap, 10, 1);
 51b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 51e:	8b 00                	mov    (%eax),%eax
 520:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 527:	00 
 528:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 52f:	00 
 530:	89 44 24 04          	mov    %eax,0x4(%esp)
 534:	8b 45 08             	mov    0x8(%ebp),%eax
 537:	89 04 24             	mov    %eax,(%esp)
 53a:	e8 ad fe ff ff       	call   3ec <printint>
        ap++;
 53f:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 543:	e9 ed 00 00 00       	jmp    635 <printf+0x195>
      } else if(c == 'x' || c == 'p'){
 548:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
 54c:	74 06                	je     554 <printf+0xb4>
 54e:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
 552:	75 2d                	jne    581 <printf+0xe1>
        printint(fd, *ap, 16, 0);
 554:	8b 45 f4             	mov    -0xc(%ebp),%eax
 557:	8b 00                	mov    (%eax),%eax
 559:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 560:	00 
 561:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 568:	00 
 569:	89 44 24 04          	mov    %eax,0x4(%esp)
 56d:	8b 45 08             	mov    0x8(%ebp),%eax
 570:	89 04 24             	mov    %eax,(%esp)
 573:	e8 74 fe ff ff       	call   3ec <printint>
        ap++;
 578:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 57c:	e9 b4 00 00 00       	jmp    635 <printf+0x195>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 581:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
 585:	75 46                	jne    5cd <printf+0x12d>
        s = (char*)*ap;
 587:	8b 45 f4             	mov    -0xc(%ebp),%eax
 58a:	8b 00                	mov    (%eax),%eax
 58c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ap++;
 58f:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
        if(s == 0)
 593:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 597:	75 27                	jne    5c0 <printf+0x120>
          s = "(null)";
 599:	c7 45 e4 8e 08 00 00 	movl   $0x88e,-0x1c(%ebp)
        while(*s != 0){
 5a0:	eb 1f                	jmp    5c1 <printf+0x121>
          putc(fd, *s);
 5a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5a5:	0f b6 00             	movzbl (%eax),%eax
 5a8:	0f be c0             	movsbl %al,%eax
 5ab:	89 44 24 04          	mov    %eax,0x4(%esp)
 5af:	8b 45 08             	mov    0x8(%ebp),%eax
 5b2:	89 04 24             	mov    %eax,(%esp)
 5b5:	e8 0a fe ff ff       	call   3c4 <putc>
          s++;
 5ba:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 5be:	eb 01                	jmp    5c1 <printf+0x121>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5c0:	90                   	nop
 5c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5c4:	0f b6 00             	movzbl (%eax),%eax
 5c7:	84 c0                	test   %al,%al
 5c9:	75 d7                	jne    5a2 <printf+0x102>
 5cb:	eb 68                	jmp    635 <printf+0x195>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5cd:	83 7d e8 63          	cmpl   $0x63,-0x18(%ebp)
 5d1:	75 1d                	jne    5f0 <printf+0x150>
        putc(fd, *ap);
 5d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5d6:	8b 00                	mov    (%eax),%eax
 5d8:	0f be c0             	movsbl %al,%eax
 5db:	89 44 24 04          	mov    %eax,0x4(%esp)
 5df:	8b 45 08             	mov    0x8(%ebp),%eax
 5e2:	89 04 24             	mov    %eax,(%esp)
 5e5:	e8 da fd ff ff       	call   3c4 <putc>
        ap++;
 5ea:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 5ee:	eb 45                	jmp    635 <printf+0x195>
      } else if(c == '%'){
 5f0:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 5f4:	75 17                	jne    60d <printf+0x16d>
        putc(fd, c);
 5f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5f9:	0f be c0             	movsbl %al,%eax
 5fc:	89 44 24 04          	mov    %eax,0x4(%esp)
 600:	8b 45 08             	mov    0x8(%ebp),%eax
 603:	89 04 24             	mov    %eax,(%esp)
 606:	e8 b9 fd ff ff       	call   3c4 <putc>
 60b:	eb 28                	jmp    635 <printf+0x195>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 60d:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 614:	00 
 615:	8b 45 08             	mov    0x8(%ebp),%eax
 618:	89 04 24             	mov    %eax,(%esp)
 61b:	e8 a4 fd ff ff       	call   3c4 <putc>
        putc(fd, c);
 620:	8b 45 e8             	mov    -0x18(%ebp),%eax
 623:	0f be c0             	movsbl %al,%eax
 626:	89 44 24 04          	mov    %eax,0x4(%esp)
 62a:	8b 45 08             	mov    0x8(%ebp),%eax
 62d:	89 04 24             	mov    %eax,(%esp)
 630:	e8 8f fd ff ff       	call   3c4 <putc>
      }
      state = 0;
 635:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 63c:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 640:	8b 55 0c             	mov    0xc(%ebp),%edx
 643:	8b 45 ec             	mov    -0x14(%ebp),%eax
 646:	8d 04 02             	lea    (%edx,%eax,1),%eax
 649:	0f b6 00             	movzbl (%eax),%eax
 64c:	84 c0                	test   %al,%al
 64e:	0f 85 6e fe ff ff    	jne    4c2 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 654:	c9                   	leave  
 655:	c3                   	ret    
 656:	90                   	nop
 657:	90                   	nop

00000658 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 658:	55                   	push   %ebp
 659:	89 e5                	mov    %esp,%ebp
 65b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 65e:	8b 45 08             	mov    0x8(%ebp),%eax
 661:	83 e8 08             	sub    $0x8,%eax
 664:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 667:	a1 b4 08 00 00       	mov    0x8b4,%eax
 66c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 66f:	eb 24                	jmp    695 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 671:	8b 45 fc             	mov    -0x4(%ebp),%eax
 674:	8b 00                	mov    (%eax),%eax
 676:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 679:	77 12                	ja     68d <free+0x35>
 67b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 681:	77 24                	ja     6a7 <free+0x4f>
 683:	8b 45 fc             	mov    -0x4(%ebp),%eax
 686:	8b 00                	mov    (%eax),%eax
 688:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 68b:	77 1a                	ja     6a7 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 68d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 690:	8b 00                	mov    (%eax),%eax
 692:	89 45 fc             	mov    %eax,-0x4(%ebp)
 695:	8b 45 f8             	mov    -0x8(%ebp),%eax
 698:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 69b:	76 d4                	jbe    671 <free+0x19>
 69d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a0:	8b 00                	mov    (%eax),%eax
 6a2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6a5:	76 ca                	jbe    671 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6aa:	8b 40 04             	mov    0x4(%eax),%eax
 6ad:	c1 e0 03             	shl    $0x3,%eax
 6b0:	89 c2                	mov    %eax,%edx
 6b2:	03 55 f8             	add    -0x8(%ebp),%edx
 6b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b8:	8b 00                	mov    (%eax),%eax
 6ba:	39 c2                	cmp    %eax,%edx
 6bc:	75 24                	jne    6e2 <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 6be:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c1:	8b 50 04             	mov    0x4(%eax),%edx
 6c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c7:	8b 00                	mov    (%eax),%eax
 6c9:	8b 40 04             	mov    0x4(%eax),%eax
 6cc:	01 c2                	add    %eax,%edx
 6ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d1:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d7:	8b 00                	mov    (%eax),%eax
 6d9:	8b 10                	mov    (%eax),%edx
 6db:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6de:	89 10                	mov    %edx,(%eax)
 6e0:	eb 0a                	jmp    6ec <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 6e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e5:	8b 10                	mov    (%eax),%edx
 6e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ea:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ef:	8b 40 04             	mov    0x4(%eax),%eax
 6f2:	c1 e0 03             	shl    $0x3,%eax
 6f5:	03 45 fc             	add    -0x4(%ebp),%eax
 6f8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6fb:	75 20                	jne    71d <free+0xc5>
    p->s.size += bp->s.size;
 6fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 700:	8b 50 04             	mov    0x4(%eax),%edx
 703:	8b 45 f8             	mov    -0x8(%ebp),%eax
 706:	8b 40 04             	mov    0x4(%eax),%eax
 709:	01 c2                	add    %eax,%edx
 70b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70e:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 711:	8b 45 f8             	mov    -0x8(%ebp),%eax
 714:	8b 10                	mov    (%eax),%edx
 716:	8b 45 fc             	mov    -0x4(%ebp),%eax
 719:	89 10                	mov    %edx,(%eax)
 71b:	eb 08                	jmp    725 <free+0xcd>
  } else
    p->s.ptr = bp;
 71d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 720:	8b 55 f8             	mov    -0x8(%ebp),%edx
 723:	89 10                	mov    %edx,(%eax)
  freep = p;
 725:	8b 45 fc             	mov    -0x4(%ebp),%eax
 728:	a3 b4 08 00 00       	mov    %eax,0x8b4
}
 72d:	c9                   	leave  
 72e:	c3                   	ret    

0000072f <morecore>:

static Header*
morecore(uint nu)
{
 72f:	55                   	push   %ebp
 730:	89 e5                	mov    %esp,%ebp
 732:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 735:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 73c:	77 07                	ja     745 <morecore+0x16>
    nu = 4096;
 73e:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 745:	8b 45 08             	mov    0x8(%ebp),%eax
 748:	c1 e0 03             	shl    $0x3,%eax
 74b:	89 04 24             	mov    %eax,(%esp)
 74e:	e8 41 fc ff ff       	call   394 <sbrk>
 753:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(p == (char*)-1)
 756:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
 75a:	75 07                	jne    763 <morecore+0x34>
    return 0;
 75c:	b8 00 00 00 00       	mov    $0x0,%eax
 761:	eb 22                	jmp    785 <morecore+0x56>
  hp = (Header*)p;
 763:	8b 45 f0             	mov    -0x10(%ebp),%eax
 766:	89 45 f4             	mov    %eax,-0xc(%ebp)
  hp->s.size = nu;
 769:	8b 45 f4             	mov    -0xc(%ebp),%eax
 76c:	8b 55 08             	mov    0x8(%ebp),%edx
 76f:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 772:	8b 45 f4             	mov    -0xc(%ebp),%eax
 775:	83 c0 08             	add    $0x8,%eax
 778:	89 04 24             	mov    %eax,(%esp)
 77b:	e8 d8 fe ff ff       	call   658 <free>
  return freep;
 780:	a1 b4 08 00 00       	mov    0x8b4,%eax
}
 785:	c9                   	leave  
 786:	c3                   	ret    

00000787 <malloc>:

void*
malloc(uint nbytes)
{
 787:	55                   	push   %ebp
 788:	89 e5                	mov    %esp,%ebp
 78a:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 78d:	8b 45 08             	mov    0x8(%ebp),%eax
 790:	83 c0 07             	add    $0x7,%eax
 793:	c1 e8 03             	shr    $0x3,%eax
 796:	83 c0 01             	add    $0x1,%eax
 799:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((prevp = freep) == 0){
 79c:	a1 b4 08 00 00       	mov    0x8b4,%eax
 7a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7a8:	75 23                	jne    7cd <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7aa:	c7 45 f0 ac 08 00 00 	movl   $0x8ac,-0x10(%ebp)
 7b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b4:	a3 b4 08 00 00       	mov    %eax,0x8b4
 7b9:	a1 b4 08 00 00       	mov    0x8b4,%eax
 7be:	a3 ac 08 00 00       	mov    %eax,0x8ac
    base.s.size = 0;
 7c3:	c7 05 b0 08 00 00 00 	movl   $0x0,0x8b0
 7ca:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d0:	8b 00                	mov    (%eax),%eax
 7d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(p->s.size >= nunits){
 7d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7d8:	8b 40 04             	mov    0x4(%eax),%eax
 7db:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 7de:	72 4d                	jb     82d <malloc+0xa6>
      if(p->s.size == nunits)
 7e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7e3:	8b 40 04             	mov    0x4(%eax),%eax
 7e6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 7e9:	75 0c                	jne    7f7 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7ee:	8b 10                	mov    (%eax),%edx
 7f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f3:	89 10                	mov    %edx,(%eax)
 7f5:	eb 26                	jmp    81d <malloc+0x96>
      else {
        p->s.size -= nunits;
 7f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7fa:	8b 40 04             	mov    0x4(%eax),%eax
 7fd:	89 c2                	mov    %eax,%edx
 7ff:	2b 55 f4             	sub    -0xc(%ebp),%edx
 802:	8b 45 ec             	mov    -0x14(%ebp),%eax
 805:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 808:	8b 45 ec             	mov    -0x14(%ebp),%eax
 80b:	8b 40 04             	mov    0x4(%eax),%eax
 80e:	c1 e0 03             	shl    $0x3,%eax
 811:	01 45 ec             	add    %eax,-0x14(%ebp)
        p->s.size = nunits;
 814:	8b 45 ec             	mov    -0x14(%ebp),%eax
 817:	8b 55 f4             	mov    -0xc(%ebp),%edx
 81a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 81d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 820:	a3 b4 08 00 00       	mov    %eax,0x8b4
      return (void*)(p + 1);
 825:	8b 45 ec             	mov    -0x14(%ebp),%eax
 828:	83 c0 08             	add    $0x8,%eax
 82b:	eb 38                	jmp    865 <malloc+0xde>
    }
    if(p == freep)
 82d:	a1 b4 08 00 00       	mov    0x8b4,%eax
 832:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 835:	75 1b                	jne    852 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 837:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83a:	89 04 24             	mov    %eax,(%esp)
 83d:	e8 ed fe ff ff       	call   72f <morecore>
 842:	89 45 ec             	mov    %eax,-0x14(%ebp)
 845:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 849:	75 07                	jne    852 <malloc+0xcb>
        return 0;
 84b:	b8 00 00 00 00       	mov    $0x0,%eax
 850:	eb 13                	jmp    865 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 852:	8b 45 ec             	mov    -0x14(%ebp),%eax
 855:	89 45 f0             	mov    %eax,-0x10(%ebp)
 858:	8b 45 ec             	mov    -0x14(%ebp),%eax
 85b:	8b 00                	mov    (%eax),%eax
 85d:	89 45 ec             	mov    %eax,-0x14(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 860:	e9 70 ff ff ff       	jmp    7d5 <malloc+0x4e>
}
 865:	c9                   	leave  
 866:	c3                   	ret    
