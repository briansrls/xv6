
_mkdir:     file format elf32-i386


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
   6:	83 ec 20             	sub    $0x20,%esp
  int i;

  if(argc < 2){
   9:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
   d:	7f 19                	jg     28 <main+0x28>
    printf(2, "Usage: mkdir files...\n");
   f:	c7 44 24 04 6f 08 00 	movl   $0x86f,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 85 04 00 00       	call   4a8 <printf>
    exit();
  23:	e8 ec 02 00 00       	call   314 <exit>
  }

  for(i = 1; i < argc; i++){
  28:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  2f:	00 
  30:	eb 43                	jmp    75 <main+0x75>
    if(mkdir(argv[i]) < 0){
  32:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  36:	c1 e0 02             	shl    $0x2,%eax
  39:	03 45 0c             	add    0xc(%ebp),%eax
  3c:	8b 00                	mov    (%eax),%eax
  3e:	89 04 24             	mov    %eax,(%esp)
  41:	e8 36 03 00 00       	call   37c <mkdir>
  46:	85 c0                	test   %eax,%eax
  48:	79 26                	jns    70 <main+0x70>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
  4a:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  4e:	c1 e0 02             	shl    $0x2,%eax
  51:	03 45 0c             	add    0xc(%ebp),%eax
  54:	8b 00                	mov    (%eax),%eax
  56:	89 44 24 08          	mov    %eax,0x8(%esp)
  5a:	c7 44 24 04 86 08 00 	movl   $0x886,0x4(%esp)
  61:	00 
  62:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  69:	e8 3a 04 00 00       	call   4a8 <printf>
      break;
  6e:	eb 0e                	jmp    7e <main+0x7e>
  if(argc < 2){
    printf(2, "Usage: mkdir files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
  70:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  75:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  79:	3b 45 08             	cmp    0x8(%ebp),%eax
  7c:	7c b4                	jl     32 <main+0x32>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
      break;
    }
  }

  exit();
  7e:	e8 91 02 00 00       	call   314 <exit>
  83:	90                   	nop

00000084 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  84:	55                   	push   %ebp
  85:	89 e5                	mov    %esp,%ebp
  87:	57                   	push   %edi
  88:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  89:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8c:	8b 55 10             	mov    0x10(%ebp),%edx
  8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  92:	89 cb                	mov    %ecx,%ebx
  94:	89 df                	mov    %ebx,%edi
  96:	89 d1                	mov    %edx,%ecx
  98:	fc                   	cld    
  99:	f3 aa                	rep stos %al,%es:(%edi)
  9b:	89 ca                	mov    %ecx,%edx
  9d:	89 fb                	mov    %edi,%ebx
  9f:	89 5d 08             	mov    %ebx,0x8(%ebp)
  a2:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  a5:	5b                   	pop    %ebx
  a6:	5f                   	pop    %edi
  a7:	5d                   	pop    %ebp
  a8:	c3                   	ret    

000000a9 <strcpy>:
#include "x86.h"
#include "signal.h"

char*
strcpy(char *s, char *t)
{
  a9:	55                   	push   %ebp
  aa:	89 e5                	mov    %esp,%ebp
  ac:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  af:	8b 45 08             	mov    0x8(%ebp),%eax
  b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  b8:	0f b6 10             	movzbl (%eax),%edx
  bb:	8b 45 08             	mov    0x8(%ebp),%eax
  be:	88 10                	mov    %dl,(%eax)
  c0:	8b 45 08             	mov    0x8(%ebp),%eax
  c3:	0f b6 00             	movzbl (%eax),%eax
  c6:	84 c0                	test   %al,%al
  c8:	0f 95 c0             	setne  %al
  cb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  cf:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  d3:	84 c0                	test   %al,%al
  d5:	75 de                	jne    b5 <strcpy+0xc>
    ;
  return os;
  d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  da:	c9                   	leave  
  db:	c3                   	ret    

000000dc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  dc:	55                   	push   %ebp
  dd:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  df:	eb 08                	jmp    e9 <strcmp+0xd>
    p++, q++;
  e1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  e5:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  e9:	8b 45 08             	mov    0x8(%ebp),%eax
  ec:	0f b6 00             	movzbl (%eax),%eax
  ef:	84 c0                	test   %al,%al
  f1:	74 10                	je     103 <strcmp+0x27>
  f3:	8b 45 08             	mov    0x8(%ebp),%eax
  f6:	0f b6 10             	movzbl (%eax),%edx
  f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  fc:	0f b6 00             	movzbl (%eax),%eax
  ff:	38 c2                	cmp    %al,%dl
 101:	74 de                	je     e1 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 103:	8b 45 08             	mov    0x8(%ebp),%eax
 106:	0f b6 00             	movzbl (%eax),%eax
 109:	0f b6 d0             	movzbl %al,%edx
 10c:	8b 45 0c             	mov    0xc(%ebp),%eax
 10f:	0f b6 00             	movzbl (%eax),%eax
 112:	0f b6 c0             	movzbl %al,%eax
 115:	89 d1                	mov    %edx,%ecx
 117:	29 c1                	sub    %eax,%ecx
 119:	89 c8                	mov    %ecx,%eax
}
 11b:	5d                   	pop    %ebp
 11c:	c3                   	ret    

0000011d <strlen>:

uint
strlen(char *s)
{
 11d:	55                   	push   %ebp
 11e:	89 e5                	mov    %esp,%ebp
 120:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 123:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 12a:	eb 04                	jmp    130 <strlen+0x13>
 12c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 130:	8b 45 fc             	mov    -0x4(%ebp),%eax
 133:	03 45 08             	add    0x8(%ebp),%eax
 136:	0f b6 00             	movzbl (%eax),%eax
 139:	84 c0                	test   %al,%al
 13b:	75 ef                	jne    12c <strlen+0xf>
    ;
  return n;
 13d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 140:	c9                   	leave  
 141:	c3                   	ret    

00000142 <memset>:

void*
memset(void *dst, int c, uint n)
{
 142:	55                   	push   %ebp
 143:	89 e5                	mov    %esp,%ebp
 145:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 148:	8b 45 10             	mov    0x10(%ebp),%eax
 14b:	89 44 24 08          	mov    %eax,0x8(%esp)
 14f:	8b 45 0c             	mov    0xc(%ebp),%eax
 152:	89 44 24 04          	mov    %eax,0x4(%esp)
 156:	8b 45 08             	mov    0x8(%ebp),%eax
 159:	89 04 24             	mov    %eax,(%esp)
 15c:	e8 23 ff ff ff       	call   84 <stosb>
  return dst;
 161:	8b 45 08             	mov    0x8(%ebp),%eax
}
 164:	c9                   	leave  
 165:	c3                   	ret    

00000166 <strchr>:

char*
strchr(const char *s, char c)
{
 166:	55                   	push   %ebp
 167:	89 e5                	mov    %esp,%ebp
 169:	83 ec 04             	sub    $0x4,%esp
 16c:	8b 45 0c             	mov    0xc(%ebp),%eax
 16f:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 172:	eb 14                	jmp    188 <strchr+0x22>
    if(*s == c)
 174:	8b 45 08             	mov    0x8(%ebp),%eax
 177:	0f b6 00             	movzbl (%eax),%eax
 17a:	3a 45 fc             	cmp    -0x4(%ebp),%al
 17d:	75 05                	jne    184 <strchr+0x1e>
      return (char*)s;
 17f:	8b 45 08             	mov    0x8(%ebp),%eax
 182:	eb 13                	jmp    197 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 184:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 188:	8b 45 08             	mov    0x8(%ebp),%eax
 18b:	0f b6 00             	movzbl (%eax),%eax
 18e:	84 c0                	test   %al,%al
 190:	75 e2                	jne    174 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 192:	b8 00 00 00 00       	mov    $0x0,%eax
}
 197:	c9                   	leave  
 198:	c3                   	ret    

00000199 <gets>:

char*
gets(char *buf, int max)
{
 199:	55                   	push   %ebp
 19a:	89 e5                	mov    %esp,%ebp
 19c:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 19f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 1a6:	eb 44                	jmp    1ec <gets+0x53>
    cc = read(0, &c, 1);
 1a8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1af:	00 
 1b0:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1b3:	89 44 24 04          	mov    %eax,0x4(%esp)
 1b7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1be:	e8 69 01 00 00       	call   32c <read>
 1c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(cc < 1)
 1c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1ca:	7e 2d                	jle    1f9 <gets+0x60>
      break;
    buf[i++] = c;
 1cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1cf:	03 45 08             	add    0x8(%ebp),%eax
 1d2:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 1d6:	88 10                	mov    %dl,(%eax)
 1d8:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    if(c == '\n' || c == '\r')
 1dc:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1e0:	3c 0a                	cmp    $0xa,%al
 1e2:	74 16                	je     1fa <gets+0x61>
 1e4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1e8:	3c 0d                	cmp    $0xd,%al
 1ea:	74 0e                	je     1fa <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1ef:	83 c0 01             	add    $0x1,%eax
 1f2:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1f5:	7c b1                	jl     1a8 <gets+0xf>
 1f7:	eb 01                	jmp    1fa <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1f9:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1fd:	03 45 08             	add    0x8(%ebp),%eax
 200:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 203:	8b 45 08             	mov    0x8(%ebp),%eax
}
 206:	c9                   	leave  
 207:	c3                   	ret    

00000208 <stat>:

int
stat(char *n, struct stat *st)
{
 208:	55                   	push   %ebp
 209:	89 e5                	mov    %esp,%ebp
 20b:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 20e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 215:	00 
 216:	8b 45 08             	mov    0x8(%ebp),%eax
 219:	89 04 24             	mov    %eax,(%esp)
 21c:	e8 33 01 00 00       	call   354 <open>
 221:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0)
 224:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 228:	79 07                	jns    231 <stat+0x29>
    return -1;
 22a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 22f:	eb 23                	jmp    254 <stat+0x4c>
  r = fstat(fd, st);
 231:	8b 45 0c             	mov    0xc(%ebp),%eax
 234:	89 44 24 04          	mov    %eax,0x4(%esp)
 238:	8b 45 f0             	mov    -0x10(%ebp),%eax
 23b:	89 04 24             	mov    %eax,(%esp)
 23e:	e8 29 01 00 00       	call   36c <fstat>
 243:	89 45 f4             	mov    %eax,-0xc(%ebp)
  close(fd);
 246:	8b 45 f0             	mov    -0x10(%ebp),%eax
 249:	89 04 24             	mov    %eax,(%esp)
 24c:	e8 eb 00 00 00       	call   33c <close>
  return r;
 251:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 254:	c9                   	leave  
 255:	c3                   	ret    

00000256 <atoi>:

int
atoi(const char *s)
{
 256:	55                   	push   %ebp
 257:	89 e5                	mov    %esp,%ebp
 259:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 25c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 263:	eb 24                	jmp    289 <atoi+0x33>
    n = n*10 + *s++ - '0';
 265:	8b 55 fc             	mov    -0x4(%ebp),%edx
 268:	89 d0                	mov    %edx,%eax
 26a:	c1 e0 02             	shl    $0x2,%eax
 26d:	01 d0                	add    %edx,%eax
 26f:	01 c0                	add    %eax,%eax
 271:	89 c2                	mov    %eax,%edx
 273:	8b 45 08             	mov    0x8(%ebp),%eax
 276:	0f b6 00             	movzbl (%eax),%eax
 279:	0f be c0             	movsbl %al,%eax
 27c:	8d 04 02             	lea    (%edx,%eax,1),%eax
 27f:	83 e8 30             	sub    $0x30,%eax
 282:	89 45 fc             	mov    %eax,-0x4(%ebp)
 285:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 289:	8b 45 08             	mov    0x8(%ebp),%eax
 28c:	0f b6 00             	movzbl (%eax),%eax
 28f:	3c 2f                	cmp    $0x2f,%al
 291:	7e 0a                	jle    29d <atoi+0x47>
 293:	8b 45 08             	mov    0x8(%ebp),%eax
 296:	0f b6 00             	movzbl (%eax),%eax
 299:	3c 39                	cmp    $0x39,%al
 29b:	7e c8                	jle    265 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 29d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2a0:	c9                   	leave  
 2a1:	c3                   	ret    

000002a2 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2a2:	55                   	push   %ebp
 2a3:	89 e5                	mov    %esp,%ebp
 2a5:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2a8:	8b 45 08             	mov    0x8(%ebp),%eax
 2ab:	89 45 f8             	mov    %eax,-0x8(%ebp)
  src = vsrc;
 2ae:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0)
 2b4:	eb 13                	jmp    2c9 <memmove+0x27>
    *dst++ = *src++;
 2b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2b9:	0f b6 10             	movzbl (%eax),%edx
 2bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2bf:	88 10                	mov    %dl,(%eax)
 2c1:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 2c5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2c9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 2cd:	0f 9f c0             	setg   %al
 2d0:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 2d4:	84 c0                	test   %al,%al
 2d6:	75 de                	jne    2b6 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2d8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2db:	c9                   	leave  
 2dc:	c3                   	ret    

000002dd <trampoline>:
 2dd:	5a                   	pop    %edx
 2de:	59                   	pop    %ecx
 2df:	58                   	pop    %eax
 2e0:	c9                   	leave  
 2e1:	c3                   	ret    

000002e2 <signal>:
//	"addl 4, %esp\n\t"
	"leave\n\t"
	"ret\n\t"
);
int signal(int signum, sighandler_t handler) 
{
 2e2:	55                   	push   %ebp
 2e3:	89 e5                	mov    %esp,%ebp
 2e5:	83 ec 18             	sub    $0x18,%esp
	register_signal_handler(signum, handler, trampoline);
 2e8:	c7 44 24 08 dd 02 00 	movl   $0x2dd,0x8(%esp)
 2ef:	00 
 2f0:	8b 45 0c             	mov    0xc(%ebp),%eax
 2f3:	89 44 24 04          	mov    %eax,0x4(%esp)
 2f7:	8b 45 08             	mov    0x8(%ebp),%eax
 2fa:	89 04 24             	mov    %eax,(%esp)
 2fd:	e8 ba 00 00 00       	call   3bc <register_signal_handler>
	return 0;
 302:	b8 00 00 00 00       	mov    $0x0,%eax
}
 307:	c9                   	leave  
 308:	c3                   	ret    
 309:	90                   	nop
 30a:	90                   	nop
 30b:	90                   	nop

0000030c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 30c:	b8 01 00 00 00       	mov    $0x1,%eax
 311:	cd 40                	int    $0x40
 313:	c3                   	ret    

00000314 <exit>:
SYSCALL(exit)
 314:	b8 02 00 00 00       	mov    $0x2,%eax
 319:	cd 40                	int    $0x40
 31b:	c3                   	ret    

0000031c <wait>:
SYSCALL(wait)
 31c:	b8 03 00 00 00       	mov    $0x3,%eax
 321:	cd 40                	int    $0x40
 323:	c3                   	ret    

00000324 <pipe>:
SYSCALL(pipe)
 324:	b8 04 00 00 00       	mov    $0x4,%eax
 329:	cd 40                	int    $0x40
 32b:	c3                   	ret    

0000032c <read>:
SYSCALL(read)
 32c:	b8 05 00 00 00       	mov    $0x5,%eax
 331:	cd 40                	int    $0x40
 333:	c3                   	ret    

00000334 <write>:
SYSCALL(write)
 334:	b8 10 00 00 00       	mov    $0x10,%eax
 339:	cd 40                	int    $0x40
 33b:	c3                   	ret    

0000033c <close>:
SYSCALL(close)
 33c:	b8 15 00 00 00       	mov    $0x15,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <kill>:
SYSCALL(kill)
 344:	b8 06 00 00 00       	mov    $0x6,%eax
 349:	cd 40                	int    $0x40
 34b:	c3                   	ret    

0000034c <exec>:
SYSCALL(exec)
 34c:	b8 07 00 00 00       	mov    $0x7,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <open>:
SYSCALL(open)
 354:	b8 0f 00 00 00       	mov    $0xf,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <mknod>:
SYSCALL(mknod)
 35c:	b8 11 00 00 00       	mov    $0x11,%eax
 361:	cd 40                	int    $0x40
 363:	c3                   	ret    

00000364 <unlink>:
SYSCALL(unlink)
 364:	b8 12 00 00 00       	mov    $0x12,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret    

0000036c <fstat>:
SYSCALL(fstat)
 36c:	b8 08 00 00 00       	mov    $0x8,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret    

00000374 <link>:
SYSCALL(link)
 374:	b8 13 00 00 00       	mov    $0x13,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <mkdir>:
SYSCALL(mkdir)
 37c:	b8 14 00 00 00       	mov    $0x14,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <chdir>:
SYSCALL(chdir)
 384:	b8 09 00 00 00       	mov    $0x9,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <dup>:
SYSCALL(dup)
 38c:	b8 0a 00 00 00       	mov    $0xa,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <getpid>:
SYSCALL(getpid)
 394:	b8 0b 00 00 00       	mov    $0xb,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <sbrk>:
SYSCALL(sbrk)
 39c:	b8 0c 00 00 00       	mov    $0xc,%eax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret    

000003a4 <sleep>:
SYSCALL(sleep)
 3a4:	b8 0d 00 00 00       	mov    $0xd,%eax
 3a9:	cd 40                	int    $0x40
 3ab:	c3                   	ret    

000003ac <uptime>:
SYSCALL(uptime)
 3ac:	b8 0e 00 00 00       	mov    $0xe,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret    

000003b4 <halt>:
SYSCALL(halt)
 3b4:	b8 16 00 00 00       	mov    $0x16,%eax
 3b9:	cd 40                	int    $0x40
 3bb:	c3                   	ret    

000003bc <register_signal_handler>:
SYSCALL(register_signal_handler)
 3bc:	b8 17 00 00 00       	mov    $0x17,%eax
 3c1:	cd 40                	int    $0x40
 3c3:	c3                   	ret    

000003c4 <alarm>:
SYSCALL(alarm)
 3c4:	b8 18 00 00 00       	mov    $0x18,%eax
 3c9:	cd 40                	int    $0x40
 3cb:	c3                   	ret    

000003cc <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3cc:	55                   	push   %ebp
 3cd:	89 e5                	mov    %esp,%ebp
 3cf:	83 ec 28             	sub    $0x28,%esp
 3d2:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d5:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3d8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3df:	00 
 3e0:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3e3:	89 44 24 04          	mov    %eax,0x4(%esp)
 3e7:	8b 45 08             	mov    0x8(%ebp),%eax
 3ea:	89 04 24             	mov    %eax,(%esp)
 3ed:	e8 42 ff ff ff       	call   334 <write>
}
 3f2:	c9                   	leave  
 3f3:	c3                   	ret    

000003f4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3f4:	55                   	push   %ebp
 3f5:	89 e5                	mov    %esp,%ebp
 3f7:	53                   	push   %ebx
 3f8:	83 ec 44             	sub    $0x44,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3fb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 402:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 406:	74 17                	je     41f <printint+0x2b>
 408:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 40c:	79 11                	jns    41f <printint+0x2b>
    neg = 1;
 40e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 415:	8b 45 0c             	mov    0xc(%ebp),%eax
 418:	f7 d8                	neg    %eax
 41a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 41d:	eb 06                	jmp    425 <printint+0x31>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 41f:	8b 45 0c             	mov    0xc(%ebp),%eax
 422:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }

  i = 0;
 425:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  do{
    buf[i++] = digits[x % base];
 42c:	8b 4d ec             	mov    -0x14(%ebp),%ecx
 42f:	8b 5d 10             	mov    0x10(%ebp),%ebx
 432:	8b 45 f4             	mov    -0xc(%ebp),%eax
 435:	ba 00 00 00 00       	mov    $0x0,%edx
 43a:	f7 f3                	div    %ebx
 43c:	89 d0                	mov    %edx,%eax
 43e:	0f b6 80 ac 08 00 00 	movzbl 0x8ac(%eax),%eax
 445:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
 449:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  }while((x /= base) != 0);
 44d:	8b 45 10             	mov    0x10(%ebp),%eax
 450:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 453:	8b 45 f4             	mov    -0xc(%ebp),%eax
 456:	ba 00 00 00 00       	mov    $0x0,%edx
 45b:	f7 75 d4             	divl   -0x2c(%ebp)
 45e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 461:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 465:	75 c5                	jne    42c <printint+0x38>
  if(neg)
 467:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 46b:	74 2a                	je     497 <printint+0xa3>
    buf[i++] = '-';
 46d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 470:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)
 475:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)

  while(--i >= 0)
 479:	eb 1d                	jmp    498 <printint+0xa4>
    putc(fd, buf[i]);
 47b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 47e:	0f b6 44 05 dc       	movzbl -0x24(%ebp,%eax,1),%eax
 483:	0f be c0             	movsbl %al,%eax
 486:	89 44 24 04          	mov    %eax,0x4(%esp)
 48a:	8b 45 08             	mov    0x8(%ebp),%eax
 48d:	89 04 24             	mov    %eax,(%esp)
 490:	e8 37 ff ff ff       	call   3cc <putc>
 495:	eb 01                	jmp    498 <printint+0xa4>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 497:	90                   	nop
 498:	83 6d ec 01          	subl   $0x1,-0x14(%ebp)
 49c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4a0:	79 d9                	jns    47b <printint+0x87>
    putc(fd, buf[i]);
}
 4a2:	83 c4 44             	add    $0x44,%esp
 4a5:	5b                   	pop    %ebx
 4a6:	5d                   	pop    %ebp
 4a7:	c3                   	ret    

000004a8 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4a8:	55                   	push   %ebp
 4a9:	89 e5                	mov    %esp,%ebp
 4ab:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4ae:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4b5:	8d 45 0c             	lea    0xc(%ebp),%eax
 4b8:	83 c0 04             	add    $0x4,%eax
 4bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i = 0; fmt[i]; i++){
 4be:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 4c5:	e9 7e 01 00 00       	jmp    648 <printf+0x1a0>
    c = fmt[i] & 0xff;
 4ca:	8b 55 0c             	mov    0xc(%ebp),%edx
 4cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4d0:	8d 04 02             	lea    (%edx,%eax,1),%eax
 4d3:	0f b6 00             	movzbl (%eax),%eax
 4d6:	0f be c0             	movsbl %al,%eax
 4d9:	25 ff 00 00 00       	and    $0xff,%eax
 4de:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(state == 0){
 4e1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4e5:	75 2c                	jne    513 <printf+0x6b>
      if(c == '%'){
 4e7:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 4eb:	75 0c                	jne    4f9 <printf+0x51>
        state = '%';
 4ed:	c7 45 f0 25 00 00 00 	movl   $0x25,-0x10(%ebp)
 4f4:	e9 4b 01 00 00       	jmp    644 <printf+0x19c>
      } else {
        putc(fd, c);
 4f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4fc:	0f be c0             	movsbl %al,%eax
 4ff:	89 44 24 04          	mov    %eax,0x4(%esp)
 503:	8b 45 08             	mov    0x8(%ebp),%eax
 506:	89 04 24             	mov    %eax,(%esp)
 509:	e8 be fe ff ff       	call   3cc <putc>
 50e:	e9 31 01 00 00       	jmp    644 <printf+0x19c>
      }
    } else if(state == '%'){
 513:	83 7d f0 25          	cmpl   $0x25,-0x10(%ebp)
 517:	0f 85 27 01 00 00    	jne    644 <printf+0x19c>
      if(c == 'd'){
 51d:	83 7d e8 64          	cmpl   $0x64,-0x18(%ebp)
 521:	75 2d                	jne    550 <printf+0xa8>
        printint(fd, *ap, 10, 1);
 523:	8b 45 f4             	mov    -0xc(%ebp),%eax
 526:	8b 00                	mov    (%eax),%eax
 528:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 52f:	00 
 530:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 537:	00 
 538:	89 44 24 04          	mov    %eax,0x4(%esp)
 53c:	8b 45 08             	mov    0x8(%ebp),%eax
 53f:	89 04 24             	mov    %eax,(%esp)
 542:	e8 ad fe ff ff       	call   3f4 <printint>
        ap++;
 547:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 54b:	e9 ed 00 00 00       	jmp    63d <printf+0x195>
      } else if(c == 'x' || c == 'p'){
 550:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
 554:	74 06                	je     55c <printf+0xb4>
 556:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
 55a:	75 2d                	jne    589 <printf+0xe1>
        printint(fd, *ap, 16, 0);
 55c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 55f:	8b 00                	mov    (%eax),%eax
 561:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 568:	00 
 569:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 570:	00 
 571:	89 44 24 04          	mov    %eax,0x4(%esp)
 575:	8b 45 08             	mov    0x8(%ebp),%eax
 578:	89 04 24             	mov    %eax,(%esp)
 57b:	e8 74 fe ff ff       	call   3f4 <printint>
        ap++;
 580:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 584:	e9 b4 00 00 00       	jmp    63d <printf+0x195>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 589:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
 58d:	75 46                	jne    5d5 <printf+0x12d>
        s = (char*)*ap;
 58f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 592:	8b 00                	mov    (%eax),%eax
 594:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ap++;
 597:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
        if(s == 0)
 59b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 59f:	75 27                	jne    5c8 <printf+0x120>
          s = "(null)";
 5a1:	c7 45 e4 a2 08 00 00 	movl   $0x8a2,-0x1c(%ebp)
        while(*s != 0){
 5a8:	eb 1f                	jmp    5c9 <printf+0x121>
          putc(fd, *s);
 5aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5ad:	0f b6 00             	movzbl (%eax),%eax
 5b0:	0f be c0             	movsbl %al,%eax
 5b3:	89 44 24 04          	mov    %eax,0x4(%esp)
 5b7:	8b 45 08             	mov    0x8(%ebp),%eax
 5ba:	89 04 24             	mov    %eax,(%esp)
 5bd:	e8 0a fe ff ff       	call   3cc <putc>
          s++;
 5c2:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 5c6:	eb 01                	jmp    5c9 <printf+0x121>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5c8:	90                   	nop
 5c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5cc:	0f b6 00             	movzbl (%eax),%eax
 5cf:	84 c0                	test   %al,%al
 5d1:	75 d7                	jne    5aa <printf+0x102>
 5d3:	eb 68                	jmp    63d <printf+0x195>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5d5:	83 7d e8 63          	cmpl   $0x63,-0x18(%ebp)
 5d9:	75 1d                	jne    5f8 <printf+0x150>
        putc(fd, *ap);
 5db:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5de:	8b 00                	mov    (%eax),%eax
 5e0:	0f be c0             	movsbl %al,%eax
 5e3:	89 44 24 04          	mov    %eax,0x4(%esp)
 5e7:	8b 45 08             	mov    0x8(%ebp),%eax
 5ea:	89 04 24             	mov    %eax,(%esp)
 5ed:	e8 da fd ff ff       	call   3cc <putc>
        ap++;
 5f2:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 5f6:	eb 45                	jmp    63d <printf+0x195>
      } else if(c == '%'){
 5f8:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 5fc:	75 17                	jne    615 <printf+0x16d>
        putc(fd, c);
 5fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
 601:	0f be c0             	movsbl %al,%eax
 604:	89 44 24 04          	mov    %eax,0x4(%esp)
 608:	8b 45 08             	mov    0x8(%ebp),%eax
 60b:	89 04 24             	mov    %eax,(%esp)
 60e:	e8 b9 fd ff ff       	call   3cc <putc>
 613:	eb 28                	jmp    63d <printf+0x195>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 615:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 61c:	00 
 61d:	8b 45 08             	mov    0x8(%ebp),%eax
 620:	89 04 24             	mov    %eax,(%esp)
 623:	e8 a4 fd ff ff       	call   3cc <putc>
        putc(fd, c);
 628:	8b 45 e8             	mov    -0x18(%ebp),%eax
 62b:	0f be c0             	movsbl %al,%eax
 62e:	89 44 24 04          	mov    %eax,0x4(%esp)
 632:	8b 45 08             	mov    0x8(%ebp),%eax
 635:	89 04 24             	mov    %eax,(%esp)
 638:	e8 8f fd ff ff       	call   3cc <putc>
      }
      state = 0;
 63d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 644:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 648:	8b 55 0c             	mov    0xc(%ebp),%edx
 64b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 64e:	8d 04 02             	lea    (%edx,%eax,1),%eax
 651:	0f b6 00             	movzbl (%eax),%eax
 654:	84 c0                	test   %al,%al
 656:	0f 85 6e fe ff ff    	jne    4ca <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 65c:	c9                   	leave  
 65d:	c3                   	ret    
 65e:	90                   	nop
 65f:	90                   	nop

00000660 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 660:	55                   	push   %ebp
 661:	89 e5                	mov    %esp,%ebp
 663:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 666:	8b 45 08             	mov    0x8(%ebp),%eax
 669:	83 e8 08             	sub    $0x8,%eax
 66c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 66f:	a1 c8 08 00 00       	mov    0x8c8,%eax
 674:	89 45 fc             	mov    %eax,-0x4(%ebp)
 677:	eb 24                	jmp    69d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 679:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67c:	8b 00                	mov    (%eax),%eax
 67e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 681:	77 12                	ja     695 <free+0x35>
 683:	8b 45 f8             	mov    -0x8(%ebp),%eax
 686:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 689:	77 24                	ja     6af <free+0x4f>
 68b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68e:	8b 00                	mov    (%eax),%eax
 690:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 693:	77 1a                	ja     6af <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 695:	8b 45 fc             	mov    -0x4(%ebp),%eax
 698:	8b 00                	mov    (%eax),%eax
 69a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 69d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6a3:	76 d4                	jbe    679 <free+0x19>
 6a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a8:	8b 00                	mov    (%eax),%eax
 6aa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6ad:	76 ca                	jbe    679 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6af:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b2:	8b 40 04             	mov    0x4(%eax),%eax
 6b5:	c1 e0 03             	shl    $0x3,%eax
 6b8:	89 c2                	mov    %eax,%edx
 6ba:	03 55 f8             	add    -0x8(%ebp),%edx
 6bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c0:	8b 00                	mov    (%eax),%eax
 6c2:	39 c2                	cmp    %eax,%edx
 6c4:	75 24                	jne    6ea <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 6c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c9:	8b 50 04             	mov    0x4(%eax),%edx
 6cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cf:	8b 00                	mov    (%eax),%eax
 6d1:	8b 40 04             	mov    0x4(%eax),%eax
 6d4:	01 c2                	add    %eax,%edx
 6d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d9:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6df:	8b 00                	mov    (%eax),%eax
 6e1:	8b 10                	mov    (%eax),%edx
 6e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e6:	89 10                	mov    %edx,(%eax)
 6e8:	eb 0a                	jmp    6f4 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 6ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ed:	8b 10                	mov    (%eax),%edx
 6ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f2:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f7:	8b 40 04             	mov    0x4(%eax),%eax
 6fa:	c1 e0 03             	shl    $0x3,%eax
 6fd:	03 45 fc             	add    -0x4(%ebp),%eax
 700:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 703:	75 20                	jne    725 <free+0xc5>
    p->s.size += bp->s.size;
 705:	8b 45 fc             	mov    -0x4(%ebp),%eax
 708:	8b 50 04             	mov    0x4(%eax),%edx
 70b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70e:	8b 40 04             	mov    0x4(%eax),%eax
 711:	01 c2                	add    %eax,%edx
 713:	8b 45 fc             	mov    -0x4(%ebp),%eax
 716:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 719:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71c:	8b 10                	mov    (%eax),%edx
 71e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 721:	89 10                	mov    %edx,(%eax)
 723:	eb 08                	jmp    72d <free+0xcd>
  } else
    p->s.ptr = bp;
 725:	8b 45 fc             	mov    -0x4(%ebp),%eax
 728:	8b 55 f8             	mov    -0x8(%ebp),%edx
 72b:	89 10                	mov    %edx,(%eax)
  freep = p;
 72d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 730:	a3 c8 08 00 00       	mov    %eax,0x8c8
}
 735:	c9                   	leave  
 736:	c3                   	ret    

00000737 <morecore>:

static Header*
morecore(uint nu)
{
 737:	55                   	push   %ebp
 738:	89 e5                	mov    %esp,%ebp
 73a:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 73d:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 744:	77 07                	ja     74d <morecore+0x16>
    nu = 4096;
 746:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 74d:	8b 45 08             	mov    0x8(%ebp),%eax
 750:	c1 e0 03             	shl    $0x3,%eax
 753:	89 04 24             	mov    %eax,(%esp)
 756:	e8 41 fc ff ff       	call   39c <sbrk>
 75b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(p == (char*)-1)
 75e:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
 762:	75 07                	jne    76b <morecore+0x34>
    return 0;
 764:	b8 00 00 00 00       	mov    $0x0,%eax
 769:	eb 22                	jmp    78d <morecore+0x56>
  hp = (Header*)p;
 76b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 76e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  hp->s.size = nu;
 771:	8b 45 f4             	mov    -0xc(%ebp),%eax
 774:	8b 55 08             	mov    0x8(%ebp),%edx
 777:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 77a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77d:	83 c0 08             	add    $0x8,%eax
 780:	89 04 24             	mov    %eax,(%esp)
 783:	e8 d8 fe ff ff       	call   660 <free>
  return freep;
 788:	a1 c8 08 00 00       	mov    0x8c8,%eax
}
 78d:	c9                   	leave  
 78e:	c3                   	ret    

0000078f <malloc>:

void*
malloc(uint nbytes)
{
 78f:	55                   	push   %ebp
 790:	89 e5                	mov    %esp,%ebp
 792:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 795:	8b 45 08             	mov    0x8(%ebp),%eax
 798:	83 c0 07             	add    $0x7,%eax
 79b:	c1 e8 03             	shr    $0x3,%eax
 79e:	83 c0 01             	add    $0x1,%eax
 7a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((prevp = freep) == 0){
 7a4:	a1 c8 08 00 00       	mov    0x8c8,%eax
 7a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7b0:	75 23                	jne    7d5 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7b2:	c7 45 f0 c0 08 00 00 	movl   $0x8c0,-0x10(%ebp)
 7b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7bc:	a3 c8 08 00 00       	mov    %eax,0x8c8
 7c1:	a1 c8 08 00 00       	mov    0x8c8,%eax
 7c6:	a3 c0 08 00 00       	mov    %eax,0x8c0
    base.s.size = 0;
 7cb:	c7 05 c4 08 00 00 00 	movl   $0x0,0x8c4
 7d2:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d8:	8b 00                	mov    (%eax),%eax
 7da:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(p->s.size >= nunits){
 7dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7e0:	8b 40 04             	mov    0x4(%eax),%eax
 7e3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 7e6:	72 4d                	jb     835 <malloc+0xa6>
      if(p->s.size == nunits)
 7e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7eb:	8b 40 04             	mov    0x4(%eax),%eax
 7ee:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 7f1:	75 0c                	jne    7ff <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7f6:	8b 10                	mov    (%eax),%edx
 7f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7fb:	89 10                	mov    %edx,(%eax)
 7fd:	eb 26                	jmp    825 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
 802:	8b 40 04             	mov    0x4(%eax),%eax
 805:	89 c2                	mov    %eax,%edx
 807:	2b 55 f4             	sub    -0xc(%ebp),%edx
 80a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 80d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 810:	8b 45 ec             	mov    -0x14(%ebp),%eax
 813:	8b 40 04             	mov    0x4(%eax),%eax
 816:	c1 e0 03             	shl    $0x3,%eax
 819:	01 45 ec             	add    %eax,-0x14(%ebp)
        p->s.size = nunits;
 81c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 81f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 822:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 825:	8b 45 f0             	mov    -0x10(%ebp),%eax
 828:	a3 c8 08 00 00       	mov    %eax,0x8c8
      return (void*)(p + 1);
 82d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 830:	83 c0 08             	add    $0x8,%eax
 833:	eb 38                	jmp    86d <malloc+0xde>
    }
    if(p == freep)
 835:	a1 c8 08 00 00       	mov    0x8c8,%eax
 83a:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 83d:	75 1b                	jne    85a <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 83f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 842:	89 04 24             	mov    %eax,(%esp)
 845:	e8 ed fe ff ff       	call   737 <morecore>
 84a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 84d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 851:	75 07                	jne    85a <malloc+0xcb>
        return 0;
 853:	b8 00 00 00 00       	mov    $0x0,%eax
 858:	eb 13                	jmp    86d <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 85a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 85d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 860:	8b 45 ec             	mov    -0x14(%ebp),%eax
 863:	8b 00                	mov    (%eax),%eax
 865:	89 45 ec             	mov    %eax,-0x14(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 868:	e9 70 ff ff ff       	jmp    7dd <malloc+0x4e>
}
 86d:	c9                   	leave  
 86e:	c3                   	ret    
