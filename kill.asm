
_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
  int i;

  if(argc < 2){
   9:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
   d:	7f 19                	jg     28 <main+0x28>
    printf(2, "usage: kill pid...\n");
   f:	c7 44 24 04 3b 08 00 	movl   $0x83b,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 51 04 00 00       	call   474 <printf>
    exit();
  23:	e8 bc 02 00 00       	call   2e4 <exit>
  }
  for(i=1; i<argc; i++)
  28:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  2f:	00 
  30:	eb 26                	jmp    58 <main+0x58>
    kill(atoi(argv[i]));
  32:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  36:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  40:	01 d0                	add    %edx,%eax
  42:	8b 00                	mov    (%eax),%eax
  44:	89 04 24             	mov    %eax,(%esp)
  47:	e8 df 01 00 00       	call   22b <atoi>
  4c:	89 04 24             	mov    %eax,(%esp)
  4f:	e8 c0 02 00 00       	call   314 <kill>

  if(argc < 2){
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
  54:	ff 44 24 1c          	incl   0x1c(%esp)
  58:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  5c:	3b 45 08             	cmp    0x8(%ebp),%eax
  5f:	7c d1                	jl     32 <main+0x32>
    kill(atoi(argv[i]));
  exit();
  61:	e8 7e 02 00 00       	call   2e4 <exit>
  66:	66 90                	xchg   %ax,%ax

00000068 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  68:	55                   	push   %ebp
  69:	89 e5                	mov    %esp,%ebp
  6b:	57                   	push   %edi
  6c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  6d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  70:	8b 55 10             	mov    0x10(%ebp),%edx
  73:	8b 45 0c             	mov    0xc(%ebp),%eax
  76:	89 cb                	mov    %ecx,%ebx
  78:	89 df                	mov    %ebx,%edi
  7a:	89 d1                	mov    %edx,%ecx
  7c:	fc                   	cld    
  7d:	f3 aa                	rep stos %al,%es:(%edi)
  7f:	89 ca                	mov    %ecx,%edx
  81:	89 fb                	mov    %edi,%ebx
  83:	89 5d 08             	mov    %ebx,0x8(%ebp)
  86:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  89:	5b                   	pop    %ebx
  8a:	5f                   	pop    %edi
  8b:	5d                   	pop    %ebp
  8c:	c3                   	ret    

0000008d <strcpy>:
#include "x86.h"
#include "signal.h"

char*
strcpy(char *s, char *t)
{
  8d:	55                   	push   %ebp
  8e:	89 e5                	mov    %esp,%ebp
  90:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  93:	8b 45 08             	mov    0x8(%ebp),%eax
  96:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  99:	90                   	nop
  9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  9d:	8a 10                	mov    (%eax),%dl
  9f:	8b 45 08             	mov    0x8(%ebp),%eax
  a2:	88 10                	mov    %dl,(%eax)
  a4:	8b 45 08             	mov    0x8(%ebp),%eax
  a7:	8a 00                	mov    (%eax),%al
  a9:	84 c0                	test   %al,%al
  ab:	0f 95 c0             	setne  %al
  ae:	ff 45 08             	incl   0x8(%ebp)
  b1:	ff 45 0c             	incl   0xc(%ebp)
  b4:	84 c0                	test   %al,%al
  b6:	75 e2                	jne    9a <strcpy+0xd>
    ;
  return os;
  b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  bb:	c9                   	leave  
  bc:	c3                   	ret    

000000bd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  bd:	55                   	push   %ebp
  be:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  c0:	eb 06                	jmp    c8 <strcmp+0xb>
    p++, q++;
  c2:	ff 45 08             	incl   0x8(%ebp)
  c5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  c8:	8b 45 08             	mov    0x8(%ebp),%eax
  cb:	8a 00                	mov    (%eax),%al
  cd:	84 c0                	test   %al,%al
  cf:	74 0e                	je     df <strcmp+0x22>
  d1:	8b 45 08             	mov    0x8(%ebp),%eax
  d4:	8a 10                	mov    (%eax),%dl
  d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  d9:	8a 00                	mov    (%eax),%al
  db:	38 c2                	cmp    %al,%dl
  dd:	74 e3                	je     c2 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  df:	8b 45 08             	mov    0x8(%ebp),%eax
  e2:	8a 00                	mov    (%eax),%al
  e4:	0f b6 d0             	movzbl %al,%edx
  e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  ea:	8a 00                	mov    (%eax),%al
  ec:	0f b6 c0             	movzbl %al,%eax
  ef:	89 d1                	mov    %edx,%ecx
  f1:	29 c1                	sub    %eax,%ecx
  f3:	89 c8                	mov    %ecx,%eax
}
  f5:	5d                   	pop    %ebp
  f6:	c3                   	ret    

000000f7 <strlen>:

uint
strlen(char *s)
{
  f7:	55                   	push   %ebp
  f8:	89 e5                	mov    %esp,%ebp
  fa:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 104:	eb 03                	jmp    109 <strlen+0x12>
 106:	ff 45 fc             	incl   -0x4(%ebp)
 109:	8b 55 fc             	mov    -0x4(%ebp),%edx
 10c:	8b 45 08             	mov    0x8(%ebp),%eax
 10f:	01 d0                	add    %edx,%eax
 111:	8a 00                	mov    (%eax),%al
 113:	84 c0                	test   %al,%al
 115:	75 ef                	jne    106 <strlen+0xf>
    ;
  return n;
 117:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 11a:	c9                   	leave  
 11b:	c3                   	ret    

0000011c <memset>:

void*
memset(void *dst, int c, uint n)
{
 11c:	55                   	push   %ebp
 11d:	89 e5                	mov    %esp,%ebp
 11f:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 122:	8b 45 10             	mov    0x10(%ebp),%eax
 125:	89 44 24 08          	mov    %eax,0x8(%esp)
 129:	8b 45 0c             	mov    0xc(%ebp),%eax
 12c:	89 44 24 04          	mov    %eax,0x4(%esp)
 130:	8b 45 08             	mov    0x8(%ebp),%eax
 133:	89 04 24             	mov    %eax,(%esp)
 136:	e8 2d ff ff ff       	call   68 <stosb>
  return dst;
 13b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 13e:	c9                   	leave  
 13f:	c3                   	ret    

00000140 <strchr>:

char*
strchr(const char *s, char c)
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	83 ec 04             	sub    $0x4,%esp
 146:	8b 45 0c             	mov    0xc(%ebp),%eax
 149:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 14c:	eb 12                	jmp    160 <strchr+0x20>
    if(*s == c)
 14e:	8b 45 08             	mov    0x8(%ebp),%eax
 151:	8a 00                	mov    (%eax),%al
 153:	3a 45 fc             	cmp    -0x4(%ebp),%al
 156:	75 05                	jne    15d <strchr+0x1d>
      return (char*)s;
 158:	8b 45 08             	mov    0x8(%ebp),%eax
 15b:	eb 11                	jmp    16e <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 15d:	ff 45 08             	incl   0x8(%ebp)
 160:	8b 45 08             	mov    0x8(%ebp),%eax
 163:	8a 00                	mov    (%eax),%al
 165:	84 c0                	test   %al,%al
 167:	75 e5                	jne    14e <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 169:	b8 00 00 00 00       	mov    $0x0,%eax
}
 16e:	c9                   	leave  
 16f:	c3                   	ret    

00000170 <gets>:

char*
gets(char *buf, int max)
{
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 176:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 17d:	eb 42                	jmp    1c1 <gets+0x51>
    cc = read(0, &c, 1);
 17f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 186:	00 
 187:	8d 45 ef             	lea    -0x11(%ebp),%eax
 18a:	89 44 24 04          	mov    %eax,0x4(%esp)
 18e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 195:	e8 62 01 00 00       	call   2fc <read>
 19a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 19d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1a1:	7e 29                	jle    1cc <gets+0x5c>
      break;
    buf[i++] = c;
 1a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1a6:	8b 45 08             	mov    0x8(%ebp),%eax
 1a9:	01 c2                	add    %eax,%edx
 1ab:	8a 45 ef             	mov    -0x11(%ebp),%al
 1ae:	88 02                	mov    %al,(%edx)
 1b0:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 1b3:	8a 45 ef             	mov    -0x11(%ebp),%al
 1b6:	3c 0a                	cmp    $0xa,%al
 1b8:	74 13                	je     1cd <gets+0x5d>
 1ba:	8a 45 ef             	mov    -0x11(%ebp),%al
 1bd:	3c 0d                	cmp    $0xd,%al
 1bf:	74 0c                	je     1cd <gets+0x5d>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c4:	40                   	inc    %eax
 1c5:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1c8:	7c b5                	jl     17f <gets+0xf>
 1ca:	eb 01                	jmp    1cd <gets+0x5d>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1cc:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1d0:	8b 45 08             	mov    0x8(%ebp),%eax
 1d3:	01 d0                	add    %edx,%eax
 1d5:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1d8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1db:	c9                   	leave  
 1dc:	c3                   	ret    

000001dd <stat>:

int
stat(char *n, struct stat *st)
{
 1dd:	55                   	push   %ebp
 1de:	89 e5                	mov    %esp,%ebp
 1e0:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1ea:	00 
 1eb:	8b 45 08             	mov    0x8(%ebp),%eax
 1ee:	89 04 24             	mov    %eax,(%esp)
 1f1:	e8 2e 01 00 00       	call   324 <open>
 1f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1fd:	79 07                	jns    206 <stat+0x29>
    return -1;
 1ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 204:	eb 23                	jmp    229 <stat+0x4c>
  r = fstat(fd, st);
 206:	8b 45 0c             	mov    0xc(%ebp),%eax
 209:	89 44 24 04          	mov    %eax,0x4(%esp)
 20d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 210:	89 04 24             	mov    %eax,(%esp)
 213:	e8 24 01 00 00       	call   33c <fstat>
 218:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 21b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 21e:	89 04 24             	mov    %eax,(%esp)
 221:	e8 e6 00 00 00       	call   30c <close>
  return r;
 226:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 229:	c9                   	leave  
 22a:	c3                   	ret    

0000022b <atoi>:

int
atoi(const char *s)
{
 22b:	55                   	push   %ebp
 22c:	89 e5                	mov    %esp,%ebp
 22e:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 231:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 238:	eb 21                	jmp    25b <atoi+0x30>
    n = n*10 + *s++ - '0';
 23a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 23d:	89 d0                	mov    %edx,%eax
 23f:	c1 e0 02             	shl    $0x2,%eax
 242:	01 d0                	add    %edx,%eax
 244:	d1 e0                	shl    %eax
 246:	89 c2                	mov    %eax,%edx
 248:	8b 45 08             	mov    0x8(%ebp),%eax
 24b:	8a 00                	mov    (%eax),%al
 24d:	0f be c0             	movsbl %al,%eax
 250:	01 d0                	add    %edx,%eax
 252:	83 e8 30             	sub    $0x30,%eax
 255:	89 45 fc             	mov    %eax,-0x4(%ebp)
 258:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 25b:	8b 45 08             	mov    0x8(%ebp),%eax
 25e:	8a 00                	mov    (%eax),%al
 260:	3c 2f                	cmp    $0x2f,%al
 262:	7e 09                	jle    26d <atoi+0x42>
 264:	8b 45 08             	mov    0x8(%ebp),%eax
 267:	8a 00                	mov    (%eax),%al
 269:	3c 39                	cmp    $0x39,%al
 26b:	7e cd                	jle    23a <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 26d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 270:	c9                   	leave  
 271:	c3                   	ret    

00000272 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 272:	55                   	push   %ebp
 273:	89 e5                	mov    %esp,%ebp
 275:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 278:	8b 45 08             	mov    0x8(%ebp),%eax
 27b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 27e:	8b 45 0c             	mov    0xc(%ebp),%eax
 281:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 284:	eb 10                	jmp    296 <memmove+0x24>
    *dst++ = *src++;
 286:	8b 45 f8             	mov    -0x8(%ebp),%eax
 289:	8a 10                	mov    (%eax),%dl
 28b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 28e:	88 10                	mov    %dl,(%eax)
 290:	ff 45 fc             	incl   -0x4(%ebp)
 293:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 296:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 29a:	0f 9f c0             	setg   %al
 29d:	ff 4d 10             	decl   0x10(%ebp)
 2a0:	84 c0                	test   %al,%al
 2a2:	75 e2                	jne    286 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2a4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2a7:	c9                   	leave  
 2a8:	c3                   	ret    

000002a9 <trampoline>:
 2a9:	5a                   	pop    %edx
 2aa:	59                   	pop    %ecx
 2ab:	58                   	pop    %eax
 2ac:	03 25 04 00 00 00    	add    0x4,%esp
 2b2:	c9                   	leave  
 2b3:	c3                   	ret    

000002b4 <signal>:
	"addl 4, %esp\n\t"
	"leave\n\t"
	"ret\n\t"
);
int signal(int signum, sighandler_t handler) 
{
 2b4:	55                   	push   %ebp
 2b5:	89 e5                	mov    %esp,%ebp
 2b7:	83 ec 18             	sub    $0x18,%esp
	register_signal_handler(signum, handler, trampoline);
 2ba:	c7 44 24 08 a9 02 00 	movl   $0x2a9,0x8(%esp)
 2c1:	00 
 2c2:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c5:	89 44 24 04          	mov    %eax,0x4(%esp)
 2c9:	8b 45 08             	mov    0x8(%ebp),%eax
 2cc:	89 04 24             	mov    %eax,(%esp)
 2cf:	e8 b8 00 00 00       	call   38c <register_signal_handler>
	return 0;
 2d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2d9:	c9                   	leave  
 2da:	c3                   	ret    
 2db:	90                   	nop

000002dc <fork>:
 2dc:	b8 01 00 00 00       	mov    $0x1,%eax
 2e1:	cd 40                	int    $0x40
 2e3:	c3                   	ret    

000002e4 <exit>:
 2e4:	b8 02 00 00 00       	mov    $0x2,%eax
 2e9:	cd 40                	int    $0x40
 2eb:	c3                   	ret    

000002ec <wait>:
 2ec:	b8 03 00 00 00       	mov    $0x3,%eax
 2f1:	cd 40                	int    $0x40
 2f3:	c3                   	ret    

000002f4 <pipe>:
 2f4:	b8 04 00 00 00       	mov    $0x4,%eax
 2f9:	cd 40                	int    $0x40
 2fb:	c3                   	ret    

000002fc <read>:
 2fc:	b8 05 00 00 00       	mov    $0x5,%eax
 301:	cd 40                	int    $0x40
 303:	c3                   	ret    

00000304 <write>:
 304:	b8 10 00 00 00       	mov    $0x10,%eax
 309:	cd 40                	int    $0x40
 30b:	c3                   	ret    

0000030c <close>:
 30c:	b8 15 00 00 00       	mov    $0x15,%eax
 311:	cd 40                	int    $0x40
 313:	c3                   	ret    

00000314 <kill>:
 314:	b8 06 00 00 00       	mov    $0x6,%eax
 319:	cd 40                	int    $0x40
 31b:	c3                   	ret    

0000031c <exec>:
 31c:	b8 07 00 00 00       	mov    $0x7,%eax
 321:	cd 40                	int    $0x40
 323:	c3                   	ret    

00000324 <open>:
 324:	b8 0f 00 00 00       	mov    $0xf,%eax
 329:	cd 40                	int    $0x40
 32b:	c3                   	ret    

0000032c <mknod>:
 32c:	b8 11 00 00 00       	mov    $0x11,%eax
 331:	cd 40                	int    $0x40
 333:	c3                   	ret    

00000334 <unlink>:
 334:	b8 12 00 00 00       	mov    $0x12,%eax
 339:	cd 40                	int    $0x40
 33b:	c3                   	ret    

0000033c <fstat>:
 33c:	b8 08 00 00 00       	mov    $0x8,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <link>:
 344:	b8 13 00 00 00       	mov    $0x13,%eax
 349:	cd 40                	int    $0x40
 34b:	c3                   	ret    

0000034c <mkdir>:
 34c:	b8 14 00 00 00       	mov    $0x14,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <chdir>:
 354:	b8 09 00 00 00       	mov    $0x9,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <dup>:
 35c:	b8 0a 00 00 00       	mov    $0xa,%eax
 361:	cd 40                	int    $0x40
 363:	c3                   	ret    

00000364 <getpid>:
 364:	b8 0b 00 00 00       	mov    $0xb,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret    

0000036c <sbrk>:
 36c:	b8 0c 00 00 00       	mov    $0xc,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret    

00000374 <sleep>:
 374:	b8 0d 00 00 00       	mov    $0xd,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <uptime>:
 37c:	b8 0e 00 00 00       	mov    $0xe,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <halt>:
 384:	b8 16 00 00 00       	mov    $0x16,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <register_signal_handler>:
 38c:	b8 17 00 00 00       	mov    $0x17,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <alarm>:
 394:	b8 18 00 00 00       	mov    $0x18,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 39c:	55                   	push   %ebp
 39d:	89 e5                	mov    %esp,%ebp
 39f:	83 ec 28             	sub    $0x28,%esp
 3a2:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a5:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3a8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3af:	00 
 3b0:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3b3:	89 44 24 04          	mov    %eax,0x4(%esp)
 3b7:	8b 45 08             	mov    0x8(%ebp),%eax
 3ba:	89 04 24             	mov    %eax,(%esp)
 3bd:	e8 42 ff ff ff       	call   304 <write>
}
 3c2:	c9                   	leave  
 3c3:	c3                   	ret    

000003c4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3c4:	55                   	push   %ebp
 3c5:	89 e5                	mov    %esp,%ebp
 3c7:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3ca:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3d1:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3d5:	74 17                	je     3ee <printint+0x2a>
 3d7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3db:	79 11                	jns    3ee <printint+0x2a>
    neg = 1;
 3dd:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3e4:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e7:	f7 d8                	neg    %eax
 3e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3ec:	eb 06                	jmp    3f4 <printint+0x30>
  } else {
    x = xx;
 3ee:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3fb:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
 401:	ba 00 00 00 00       	mov    $0x0,%edx
 406:	f7 f1                	div    %ecx
 408:	89 d0                	mov    %edx,%eax
 40a:	8a 80 b4 0a 00 00    	mov    0xab4(%eax),%al
 410:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 413:	8b 55 f4             	mov    -0xc(%ebp),%edx
 416:	01 ca                	add    %ecx,%edx
 418:	88 02                	mov    %al,(%edx)
 41a:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 41d:	8b 55 10             	mov    0x10(%ebp),%edx
 420:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 423:	8b 45 ec             	mov    -0x14(%ebp),%eax
 426:	ba 00 00 00 00       	mov    $0x0,%edx
 42b:	f7 75 d4             	divl   -0x2c(%ebp)
 42e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 431:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 435:	75 c4                	jne    3fb <printint+0x37>
  if(neg)
 437:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 43b:	74 2c                	je     469 <printint+0xa5>
    buf[i++] = '-';
 43d:	8d 55 dc             	lea    -0x24(%ebp),%edx
 440:	8b 45 f4             	mov    -0xc(%ebp),%eax
 443:	01 d0                	add    %edx,%eax
 445:	c6 00 2d             	movb   $0x2d,(%eax)
 448:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 44b:	eb 1c                	jmp    469 <printint+0xa5>
    putc(fd, buf[i]);
 44d:	8d 55 dc             	lea    -0x24(%ebp),%edx
 450:	8b 45 f4             	mov    -0xc(%ebp),%eax
 453:	01 d0                	add    %edx,%eax
 455:	8a 00                	mov    (%eax),%al
 457:	0f be c0             	movsbl %al,%eax
 45a:	89 44 24 04          	mov    %eax,0x4(%esp)
 45e:	8b 45 08             	mov    0x8(%ebp),%eax
 461:	89 04 24             	mov    %eax,(%esp)
 464:	e8 33 ff ff ff       	call   39c <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 469:	ff 4d f4             	decl   -0xc(%ebp)
 46c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 470:	79 db                	jns    44d <printint+0x89>
    putc(fd, buf[i]);
}
 472:	c9                   	leave  
 473:	c3                   	ret    

00000474 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 474:	55                   	push   %ebp
 475:	89 e5                	mov    %esp,%ebp
 477:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 47a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 481:	8d 45 0c             	lea    0xc(%ebp),%eax
 484:	83 c0 04             	add    $0x4,%eax
 487:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 48a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 491:	e9 78 01 00 00       	jmp    60e <printf+0x19a>
    c = fmt[i] & 0xff;
 496:	8b 55 0c             	mov    0xc(%ebp),%edx
 499:	8b 45 f0             	mov    -0x10(%ebp),%eax
 49c:	01 d0                	add    %edx,%eax
 49e:	8a 00                	mov    (%eax),%al
 4a0:	0f be c0             	movsbl %al,%eax
 4a3:	25 ff 00 00 00       	and    $0xff,%eax
 4a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4ab:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4af:	75 2c                	jne    4dd <printf+0x69>
      if(c == '%'){
 4b1:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4b5:	75 0c                	jne    4c3 <printf+0x4f>
        state = '%';
 4b7:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4be:	e9 48 01 00 00       	jmp    60b <printf+0x197>
      } else {
        putc(fd, c);
 4c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4c6:	0f be c0             	movsbl %al,%eax
 4c9:	89 44 24 04          	mov    %eax,0x4(%esp)
 4cd:	8b 45 08             	mov    0x8(%ebp),%eax
 4d0:	89 04 24             	mov    %eax,(%esp)
 4d3:	e8 c4 fe ff ff       	call   39c <putc>
 4d8:	e9 2e 01 00 00       	jmp    60b <printf+0x197>
      }
    } else if(state == '%'){
 4dd:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4e1:	0f 85 24 01 00 00    	jne    60b <printf+0x197>
      if(c == 'd'){
 4e7:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4eb:	75 2d                	jne    51a <printf+0xa6>
        printint(fd, *ap, 10, 1);
 4ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4f0:	8b 00                	mov    (%eax),%eax
 4f2:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4f9:	00 
 4fa:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 501:	00 
 502:	89 44 24 04          	mov    %eax,0x4(%esp)
 506:	8b 45 08             	mov    0x8(%ebp),%eax
 509:	89 04 24             	mov    %eax,(%esp)
 50c:	e8 b3 fe ff ff       	call   3c4 <printint>
        ap++;
 511:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 515:	e9 ea 00 00 00       	jmp    604 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 51a:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 51e:	74 06                	je     526 <printf+0xb2>
 520:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 524:	75 2d                	jne    553 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 526:	8b 45 e8             	mov    -0x18(%ebp),%eax
 529:	8b 00                	mov    (%eax),%eax
 52b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 532:	00 
 533:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 53a:	00 
 53b:	89 44 24 04          	mov    %eax,0x4(%esp)
 53f:	8b 45 08             	mov    0x8(%ebp),%eax
 542:	89 04 24             	mov    %eax,(%esp)
 545:	e8 7a fe ff ff       	call   3c4 <printint>
        ap++;
 54a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 54e:	e9 b1 00 00 00       	jmp    604 <printf+0x190>
      } else if(c == 's'){
 553:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 557:	75 43                	jne    59c <printf+0x128>
        s = (char*)*ap;
 559:	8b 45 e8             	mov    -0x18(%ebp),%eax
 55c:	8b 00                	mov    (%eax),%eax
 55e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 561:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 565:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 569:	75 25                	jne    590 <printf+0x11c>
          s = "(null)";
 56b:	c7 45 f4 4f 08 00 00 	movl   $0x84f,-0xc(%ebp)
        while(*s != 0){
 572:	eb 1c                	jmp    590 <printf+0x11c>
          putc(fd, *s);
 574:	8b 45 f4             	mov    -0xc(%ebp),%eax
 577:	8a 00                	mov    (%eax),%al
 579:	0f be c0             	movsbl %al,%eax
 57c:	89 44 24 04          	mov    %eax,0x4(%esp)
 580:	8b 45 08             	mov    0x8(%ebp),%eax
 583:	89 04 24             	mov    %eax,(%esp)
 586:	e8 11 fe ff ff       	call   39c <putc>
          s++;
 58b:	ff 45 f4             	incl   -0xc(%ebp)
 58e:	eb 01                	jmp    591 <printf+0x11d>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 590:	90                   	nop
 591:	8b 45 f4             	mov    -0xc(%ebp),%eax
 594:	8a 00                	mov    (%eax),%al
 596:	84 c0                	test   %al,%al
 598:	75 da                	jne    574 <printf+0x100>
 59a:	eb 68                	jmp    604 <printf+0x190>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 59c:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5a0:	75 1d                	jne    5bf <printf+0x14b>
        putc(fd, *ap);
 5a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5a5:	8b 00                	mov    (%eax),%eax
 5a7:	0f be c0             	movsbl %al,%eax
 5aa:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ae:	8b 45 08             	mov    0x8(%ebp),%eax
 5b1:	89 04 24             	mov    %eax,(%esp)
 5b4:	e8 e3 fd ff ff       	call   39c <putc>
        ap++;
 5b9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5bd:	eb 45                	jmp    604 <printf+0x190>
      } else if(c == '%'){
 5bf:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5c3:	75 17                	jne    5dc <printf+0x168>
        putc(fd, c);
 5c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5c8:	0f be c0             	movsbl %al,%eax
 5cb:	89 44 24 04          	mov    %eax,0x4(%esp)
 5cf:	8b 45 08             	mov    0x8(%ebp),%eax
 5d2:	89 04 24             	mov    %eax,(%esp)
 5d5:	e8 c2 fd ff ff       	call   39c <putc>
 5da:	eb 28                	jmp    604 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5dc:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5e3:	00 
 5e4:	8b 45 08             	mov    0x8(%ebp),%eax
 5e7:	89 04 24             	mov    %eax,(%esp)
 5ea:	e8 ad fd ff ff       	call   39c <putc>
        putc(fd, c);
 5ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5f2:	0f be c0             	movsbl %al,%eax
 5f5:	89 44 24 04          	mov    %eax,0x4(%esp)
 5f9:	8b 45 08             	mov    0x8(%ebp),%eax
 5fc:	89 04 24             	mov    %eax,(%esp)
 5ff:	e8 98 fd ff ff       	call   39c <putc>
      }
      state = 0;
 604:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 60b:	ff 45 f0             	incl   -0x10(%ebp)
 60e:	8b 55 0c             	mov    0xc(%ebp),%edx
 611:	8b 45 f0             	mov    -0x10(%ebp),%eax
 614:	01 d0                	add    %edx,%eax
 616:	8a 00                	mov    (%eax),%al
 618:	84 c0                	test   %al,%al
 61a:	0f 85 76 fe ff ff    	jne    496 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 620:	c9                   	leave  
 621:	c3                   	ret    
 622:	66 90                	xchg   %ax,%ax

00000624 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 624:	55                   	push   %ebp
 625:	89 e5                	mov    %esp,%ebp
 627:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 62a:	8b 45 08             	mov    0x8(%ebp),%eax
 62d:	83 e8 08             	sub    $0x8,%eax
 630:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 633:	a1 d0 0a 00 00       	mov    0xad0,%eax
 638:	89 45 fc             	mov    %eax,-0x4(%ebp)
 63b:	eb 24                	jmp    661 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 63d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 640:	8b 00                	mov    (%eax),%eax
 642:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 645:	77 12                	ja     659 <free+0x35>
 647:	8b 45 f8             	mov    -0x8(%ebp),%eax
 64a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 64d:	77 24                	ja     673 <free+0x4f>
 64f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 652:	8b 00                	mov    (%eax),%eax
 654:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 657:	77 1a                	ja     673 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 659:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65c:	8b 00                	mov    (%eax),%eax
 65e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 661:	8b 45 f8             	mov    -0x8(%ebp),%eax
 664:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 667:	76 d4                	jbe    63d <free+0x19>
 669:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66c:	8b 00                	mov    (%eax),%eax
 66e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 671:	76 ca                	jbe    63d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 673:	8b 45 f8             	mov    -0x8(%ebp),%eax
 676:	8b 40 04             	mov    0x4(%eax),%eax
 679:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 680:	8b 45 f8             	mov    -0x8(%ebp),%eax
 683:	01 c2                	add    %eax,%edx
 685:	8b 45 fc             	mov    -0x4(%ebp),%eax
 688:	8b 00                	mov    (%eax),%eax
 68a:	39 c2                	cmp    %eax,%edx
 68c:	75 24                	jne    6b2 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 68e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 691:	8b 50 04             	mov    0x4(%eax),%edx
 694:	8b 45 fc             	mov    -0x4(%ebp),%eax
 697:	8b 00                	mov    (%eax),%eax
 699:	8b 40 04             	mov    0x4(%eax),%eax
 69c:	01 c2                	add    %eax,%edx
 69e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a1:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a7:	8b 00                	mov    (%eax),%eax
 6a9:	8b 10                	mov    (%eax),%edx
 6ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ae:	89 10                	mov    %edx,(%eax)
 6b0:	eb 0a                	jmp    6bc <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b5:	8b 10                	mov    (%eax),%edx
 6b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ba:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bf:	8b 40 04             	mov    0x4(%eax),%eax
 6c2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cc:	01 d0                	add    %edx,%eax
 6ce:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6d1:	75 20                	jne    6f3 <free+0xcf>
    p->s.size += bp->s.size;
 6d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d6:	8b 50 04             	mov    0x4(%eax),%edx
 6d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6dc:	8b 40 04             	mov    0x4(%eax),%eax
 6df:	01 c2                	add    %eax,%edx
 6e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e4:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ea:	8b 10                	mov    (%eax),%edx
 6ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ef:	89 10                	mov    %edx,(%eax)
 6f1:	eb 08                	jmp    6fb <free+0xd7>
  } else
    p->s.ptr = bp;
 6f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f6:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6f9:	89 10                	mov    %edx,(%eax)
  freep = p;
 6fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fe:	a3 d0 0a 00 00       	mov    %eax,0xad0
}
 703:	c9                   	leave  
 704:	c3                   	ret    

00000705 <morecore>:

static Header*
morecore(uint nu)
{
 705:	55                   	push   %ebp
 706:	89 e5                	mov    %esp,%ebp
 708:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 70b:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 712:	77 07                	ja     71b <morecore+0x16>
    nu = 4096;
 714:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 71b:	8b 45 08             	mov    0x8(%ebp),%eax
 71e:	c1 e0 03             	shl    $0x3,%eax
 721:	89 04 24             	mov    %eax,(%esp)
 724:	e8 43 fc ff ff       	call   36c <sbrk>
 729:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 72c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 730:	75 07                	jne    739 <morecore+0x34>
    return 0;
 732:	b8 00 00 00 00       	mov    $0x0,%eax
 737:	eb 22                	jmp    75b <morecore+0x56>
  hp = (Header*)p;
 739:	8b 45 f4             	mov    -0xc(%ebp),%eax
 73c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 73f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 742:	8b 55 08             	mov    0x8(%ebp),%edx
 745:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 748:	8b 45 f0             	mov    -0x10(%ebp),%eax
 74b:	83 c0 08             	add    $0x8,%eax
 74e:	89 04 24             	mov    %eax,(%esp)
 751:	e8 ce fe ff ff       	call   624 <free>
  return freep;
 756:	a1 d0 0a 00 00       	mov    0xad0,%eax
}
 75b:	c9                   	leave  
 75c:	c3                   	ret    

0000075d <malloc>:

void*
malloc(uint nbytes)
{
 75d:	55                   	push   %ebp
 75e:	89 e5                	mov    %esp,%ebp
 760:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 763:	8b 45 08             	mov    0x8(%ebp),%eax
 766:	83 c0 07             	add    $0x7,%eax
 769:	c1 e8 03             	shr    $0x3,%eax
 76c:	40                   	inc    %eax
 76d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 770:	a1 d0 0a 00 00       	mov    0xad0,%eax
 775:	89 45 f0             	mov    %eax,-0x10(%ebp)
 778:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 77c:	75 23                	jne    7a1 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 77e:	c7 45 f0 c8 0a 00 00 	movl   $0xac8,-0x10(%ebp)
 785:	8b 45 f0             	mov    -0x10(%ebp),%eax
 788:	a3 d0 0a 00 00       	mov    %eax,0xad0
 78d:	a1 d0 0a 00 00       	mov    0xad0,%eax
 792:	a3 c8 0a 00 00       	mov    %eax,0xac8
    base.s.size = 0;
 797:	c7 05 cc 0a 00 00 00 	movl   $0x0,0xacc
 79e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a4:	8b 00                	mov    (%eax),%eax
 7a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ac:	8b 40 04             	mov    0x4(%eax),%eax
 7af:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7b2:	72 4d                	jb     801 <malloc+0xa4>
      if(p->s.size == nunits)
 7b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b7:	8b 40 04             	mov    0x4(%eax),%eax
 7ba:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7bd:	75 0c                	jne    7cb <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 7bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c2:	8b 10                	mov    (%eax),%edx
 7c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c7:	89 10                	mov    %edx,(%eax)
 7c9:	eb 26                	jmp    7f1 <malloc+0x94>
      else {
        p->s.size -= nunits;
 7cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ce:	8b 40 04             	mov    0x4(%eax),%eax
 7d1:	89 c2                	mov    %eax,%edx
 7d3:	2b 55 ec             	sub    -0x14(%ebp),%edx
 7d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7df:	8b 40 04             	mov    0x4(%eax),%eax
 7e2:	c1 e0 03             	shl    $0x3,%eax
 7e5:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7eb:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7ee:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f4:	a3 d0 0a 00 00       	mov    %eax,0xad0
      return (void*)(p + 1);
 7f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fc:	83 c0 08             	add    $0x8,%eax
 7ff:	eb 38                	jmp    839 <malloc+0xdc>
    }
    if(p == freep)
 801:	a1 d0 0a 00 00       	mov    0xad0,%eax
 806:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 809:	75 1b                	jne    826 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 80b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 80e:	89 04 24             	mov    %eax,(%esp)
 811:	e8 ef fe ff ff       	call   705 <morecore>
 816:	89 45 f4             	mov    %eax,-0xc(%ebp)
 819:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 81d:	75 07                	jne    826 <malloc+0xc9>
        return 0;
 81f:	b8 00 00 00 00       	mov    $0x0,%eax
 824:	eb 13                	jmp    839 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 826:	8b 45 f4             	mov    -0xc(%ebp),%eax
 829:	89 45 f0             	mov    %eax,-0x10(%ebp)
 82c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82f:	8b 00                	mov    (%eax),%eax
 831:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 834:	e9 70 ff ff ff       	jmp    7a9 <malloc+0x4c>
}
 839:	c9                   	leave  
 83a:	c3                   	ret    
