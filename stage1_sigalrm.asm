
_stage1_sigalrm:     file format elf32-i386


Disassembly of section .text:

00000000 <dummy>:
#include "signal.h"

volatile int flag = 0;

void dummy(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
	printf(1, "TEST FAILED: this should never execute.\n");
   6:	c7 44 24 04 c8 08 00 	movl   $0x8c8,0x4(%esp)
   d:	00 
   e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  15:	e8 e6 04 00 00       	call   500 <printf>
}
  1a:	c9                   	leave  
  1b:	c3                   	ret    

0000001c <handle_signal>:

void handle_signal(siginfo_t info)
{
  1c:	55                   	push   %ebp
  1d:	89 e5                	mov    %esp,%ebp
  1f:	83 ec 18             	sub    $0x18,%esp
	printf(1, "Caught signal %d...\n", info.signum);
  22:	8b 45 08             	mov    0x8(%ebp),%eax
  25:	89 44 24 08          	mov    %eax,0x8(%esp)
  29:	c7 44 24 04 f1 08 00 	movl   $0x8f1,0x4(%esp)
  30:	00 
  31:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  38:	e8 c3 04 00 00       	call   500 <printf>
	if (info.signum == SIGALRM)
  3d:	8b 45 08             	mov    0x8(%ebp),%eax
  40:	83 f8 01             	cmp    $0x1,%eax
  43:	75 16                	jne    5b <handle_signal+0x3f>
		printf(1, "TEST PASSED\n");
  45:	c7 44 24 04 06 09 00 	movl   $0x906,0x4(%esp)
  4c:	00 
  4d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  54:	e8 a7 04 00 00       	call   500 <printf>
  59:	eb 14                	jmp    6f <handle_signal+0x53>
	else
		printf(1, "TEST FAILED: wrong signal sent.\n");
  5b:	c7 44 24 04 14 09 00 	movl   $0x914,0x4(%esp)
  62:	00 
  63:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  6a:	e8 91 04 00 00       	call   500 <printf>
	exit();
  6f:	e8 f8 02 00 00       	call   36c <exit>

00000074 <main>:
}

int main(int argc, char *argv[])
{
  74:	55                   	push   %ebp
  75:	89 e5                	mov    %esp,%ebp
  77:	83 e4 f0             	and    $0xfffffff0,%esp
  7a:	83 ec 20             	sub    $0x20,%esp
	int start = uptime();
  7d:	e8 82 03 00 00       	call   404 <uptime>
  82:	89 44 24 1c          	mov    %eax,0x1c(%esp)

	signal(SIGALRM, handle_signal);
  86:	c7 44 24 04 1c 00 00 	movl   $0x1c,0x4(%esp)
  8d:	00 
  8e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  95:	e8 a0 02 00 00       	call   33a <signal>

	alarm(1);
  9a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  a1:	e8 76 03 00 00       	call   41c <alarm>

	while(!flag && uptime() < start + 2000);
  a6:	a1 70 09 00 00       	mov    0x970,%eax
  ab:	85 c0                	test   %eax,%eax
  ad:	75 13                	jne    c2 <main+0x4e>
  af:	e8 50 03 00 00       	call   404 <uptime>
  b4:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  b8:	81 c2 d0 07 00 00    	add    $0x7d0,%edx
  be:	39 d0                	cmp    %edx,%eax
  c0:	7c e4                	jl     a6 <main+0x32>

	printf(1, "TEST FAILED: no signal sent.\n");
  c2:	c7 44 24 04 35 09 00 	movl   $0x935,0x4(%esp)
  c9:	00 
  ca:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  d1:	e8 2a 04 00 00       	call   500 <printf>
	
	exit();
  d6:	e8 91 02 00 00       	call   36c <exit>
  db:	90                   	nop

000000dc <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  dc:	55                   	push   %ebp
  dd:	89 e5                	mov    %esp,%ebp
  df:	57                   	push   %edi
  e0:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  e4:	8b 55 10             	mov    0x10(%ebp),%edx
  e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  ea:	89 cb                	mov    %ecx,%ebx
  ec:	89 df                	mov    %ebx,%edi
  ee:	89 d1                	mov    %edx,%ecx
  f0:	fc                   	cld    
  f1:	f3 aa                	rep stos %al,%es:(%edi)
  f3:	89 ca                	mov    %ecx,%edx
  f5:	89 fb                	mov    %edi,%ebx
  f7:	89 5d 08             	mov    %ebx,0x8(%ebp)
  fa:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  fd:	5b                   	pop    %ebx
  fe:	5f                   	pop    %edi
  ff:	5d                   	pop    %ebp
 100:	c3                   	ret    

00000101 <strcpy>:
#include "x86.h"
#include "signal.h"

char*
strcpy(char *s, char *t)
{
 101:	55                   	push   %ebp
 102:	89 e5                	mov    %esp,%ebp
 104:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 107:	8b 45 08             	mov    0x8(%ebp),%eax
 10a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 10d:	8b 45 0c             	mov    0xc(%ebp),%eax
 110:	0f b6 10             	movzbl (%eax),%edx
 113:	8b 45 08             	mov    0x8(%ebp),%eax
 116:	88 10                	mov    %dl,(%eax)
 118:	8b 45 08             	mov    0x8(%ebp),%eax
 11b:	0f b6 00             	movzbl (%eax),%eax
 11e:	84 c0                	test   %al,%al
 120:	0f 95 c0             	setne  %al
 123:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 127:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 12b:	84 c0                	test   %al,%al
 12d:	75 de                	jne    10d <strcpy+0xc>
    ;
  return os;
 12f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 132:	c9                   	leave  
 133:	c3                   	ret    

00000134 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 134:	55                   	push   %ebp
 135:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 137:	eb 08                	jmp    141 <strcmp+0xd>
    p++, q++;
 139:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 13d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 141:	8b 45 08             	mov    0x8(%ebp),%eax
 144:	0f b6 00             	movzbl (%eax),%eax
 147:	84 c0                	test   %al,%al
 149:	74 10                	je     15b <strcmp+0x27>
 14b:	8b 45 08             	mov    0x8(%ebp),%eax
 14e:	0f b6 10             	movzbl (%eax),%edx
 151:	8b 45 0c             	mov    0xc(%ebp),%eax
 154:	0f b6 00             	movzbl (%eax),%eax
 157:	38 c2                	cmp    %al,%dl
 159:	74 de                	je     139 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 15b:	8b 45 08             	mov    0x8(%ebp),%eax
 15e:	0f b6 00             	movzbl (%eax),%eax
 161:	0f b6 d0             	movzbl %al,%edx
 164:	8b 45 0c             	mov    0xc(%ebp),%eax
 167:	0f b6 00             	movzbl (%eax),%eax
 16a:	0f b6 c0             	movzbl %al,%eax
 16d:	89 d1                	mov    %edx,%ecx
 16f:	29 c1                	sub    %eax,%ecx
 171:	89 c8                	mov    %ecx,%eax
}
 173:	5d                   	pop    %ebp
 174:	c3                   	ret    

00000175 <strlen>:

uint
strlen(char *s)
{
 175:	55                   	push   %ebp
 176:	89 e5                	mov    %esp,%ebp
 178:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 17b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 182:	eb 04                	jmp    188 <strlen+0x13>
 184:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 188:	8b 45 fc             	mov    -0x4(%ebp),%eax
 18b:	03 45 08             	add    0x8(%ebp),%eax
 18e:	0f b6 00             	movzbl (%eax),%eax
 191:	84 c0                	test   %al,%al
 193:	75 ef                	jne    184 <strlen+0xf>
    ;
  return n;
 195:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 198:	c9                   	leave  
 199:	c3                   	ret    

0000019a <memset>:

void*
memset(void *dst, int c, uint n)
{
 19a:	55                   	push   %ebp
 19b:	89 e5                	mov    %esp,%ebp
 19d:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1a0:	8b 45 10             	mov    0x10(%ebp),%eax
 1a3:	89 44 24 08          	mov    %eax,0x8(%esp)
 1a7:	8b 45 0c             	mov    0xc(%ebp),%eax
 1aa:	89 44 24 04          	mov    %eax,0x4(%esp)
 1ae:	8b 45 08             	mov    0x8(%ebp),%eax
 1b1:	89 04 24             	mov    %eax,(%esp)
 1b4:	e8 23 ff ff ff       	call   dc <stosb>
  return dst;
 1b9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1bc:	c9                   	leave  
 1bd:	c3                   	ret    

000001be <strchr>:

char*
strchr(const char *s, char c)
{
 1be:	55                   	push   %ebp
 1bf:	89 e5                	mov    %esp,%ebp
 1c1:	83 ec 04             	sub    $0x4,%esp
 1c4:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c7:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1ca:	eb 14                	jmp    1e0 <strchr+0x22>
    if(*s == c)
 1cc:	8b 45 08             	mov    0x8(%ebp),%eax
 1cf:	0f b6 00             	movzbl (%eax),%eax
 1d2:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1d5:	75 05                	jne    1dc <strchr+0x1e>
      return (char*)s;
 1d7:	8b 45 08             	mov    0x8(%ebp),%eax
 1da:	eb 13                	jmp    1ef <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1dc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1e0:	8b 45 08             	mov    0x8(%ebp),%eax
 1e3:	0f b6 00             	movzbl (%eax),%eax
 1e6:	84 c0                	test   %al,%al
 1e8:	75 e2                	jne    1cc <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1ef:	c9                   	leave  
 1f0:	c3                   	ret    

000001f1 <gets>:

char*
gets(char *buf, int max)
{
 1f1:	55                   	push   %ebp
 1f2:	89 e5                	mov    %esp,%ebp
 1f4:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 1fe:	eb 44                	jmp    244 <gets+0x53>
    cc = read(0, &c, 1);
 200:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 207:	00 
 208:	8d 45 ef             	lea    -0x11(%ebp),%eax
 20b:	89 44 24 04          	mov    %eax,0x4(%esp)
 20f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 216:	e8 69 01 00 00       	call   384 <read>
 21b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(cc < 1)
 21e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 222:	7e 2d                	jle    251 <gets+0x60>
      break;
    buf[i++] = c;
 224:	8b 45 f0             	mov    -0x10(%ebp),%eax
 227:	03 45 08             	add    0x8(%ebp),%eax
 22a:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 22e:	88 10                	mov    %dl,(%eax)
 230:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    if(c == '\n' || c == '\r')
 234:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 238:	3c 0a                	cmp    $0xa,%al
 23a:	74 16                	je     252 <gets+0x61>
 23c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 240:	3c 0d                	cmp    $0xd,%al
 242:	74 0e                	je     252 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 244:	8b 45 f0             	mov    -0x10(%ebp),%eax
 247:	83 c0 01             	add    $0x1,%eax
 24a:	3b 45 0c             	cmp    0xc(%ebp),%eax
 24d:	7c b1                	jl     200 <gets+0xf>
 24f:	eb 01                	jmp    252 <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 251:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 252:	8b 45 f0             	mov    -0x10(%ebp),%eax
 255:	03 45 08             	add    0x8(%ebp),%eax
 258:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 25b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 25e:	c9                   	leave  
 25f:	c3                   	ret    

00000260 <stat>:

int
stat(char *n, struct stat *st)
{
 260:	55                   	push   %ebp
 261:	89 e5                	mov    %esp,%ebp
 263:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 266:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 26d:	00 
 26e:	8b 45 08             	mov    0x8(%ebp),%eax
 271:	89 04 24             	mov    %eax,(%esp)
 274:	e8 33 01 00 00       	call   3ac <open>
 279:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0)
 27c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 280:	79 07                	jns    289 <stat+0x29>
    return -1;
 282:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 287:	eb 23                	jmp    2ac <stat+0x4c>
  r = fstat(fd, st);
 289:	8b 45 0c             	mov    0xc(%ebp),%eax
 28c:	89 44 24 04          	mov    %eax,0x4(%esp)
 290:	8b 45 f0             	mov    -0x10(%ebp),%eax
 293:	89 04 24             	mov    %eax,(%esp)
 296:	e8 29 01 00 00       	call   3c4 <fstat>
 29b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  close(fd);
 29e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 2a1:	89 04 24             	mov    %eax,(%esp)
 2a4:	e8 eb 00 00 00       	call   394 <close>
  return r;
 2a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 2ac:	c9                   	leave  
 2ad:	c3                   	ret    

000002ae <atoi>:

int
atoi(const char *s)
{
 2ae:	55                   	push   %ebp
 2af:	89 e5                	mov    %esp,%ebp
 2b1:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2bb:	eb 24                	jmp    2e1 <atoi+0x33>
    n = n*10 + *s++ - '0';
 2bd:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2c0:	89 d0                	mov    %edx,%eax
 2c2:	c1 e0 02             	shl    $0x2,%eax
 2c5:	01 d0                	add    %edx,%eax
 2c7:	01 c0                	add    %eax,%eax
 2c9:	89 c2                	mov    %eax,%edx
 2cb:	8b 45 08             	mov    0x8(%ebp),%eax
 2ce:	0f b6 00             	movzbl (%eax),%eax
 2d1:	0f be c0             	movsbl %al,%eax
 2d4:	8d 04 02             	lea    (%edx,%eax,1),%eax
 2d7:	83 e8 30             	sub    $0x30,%eax
 2da:	89 45 fc             	mov    %eax,-0x4(%ebp)
 2dd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2e1:	8b 45 08             	mov    0x8(%ebp),%eax
 2e4:	0f b6 00             	movzbl (%eax),%eax
 2e7:	3c 2f                	cmp    $0x2f,%al
 2e9:	7e 0a                	jle    2f5 <atoi+0x47>
 2eb:	8b 45 08             	mov    0x8(%ebp),%eax
 2ee:	0f b6 00             	movzbl (%eax),%eax
 2f1:	3c 39                	cmp    $0x39,%al
 2f3:	7e c8                	jle    2bd <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2f8:	c9                   	leave  
 2f9:	c3                   	ret    

000002fa <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2fa:	55                   	push   %ebp
 2fb:	89 e5                	mov    %esp,%ebp
 2fd:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 300:	8b 45 08             	mov    0x8(%ebp),%eax
 303:	89 45 f8             	mov    %eax,-0x8(%ebp)
  src = vsrc;
 306:	8b 45 0c             	mov    0xc(%ebp),%eax
 309:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0)
 30c:	eb 13                	jmp    321 <memmove+0x27>
    *dst++ = *src++;
 30e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 311:	0f b6 10             	movzbl (%eax),%edx
 314:	8b 45 f8             	mov    -0x8(%ebp),%eax
 317:	88 10                	mov    %dl,(%eax)
 319:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 31d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 321:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 325:	0f 9f c0             	setg   %al
 328:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 32c:	84 c0                	test   %al,%al
 32e:	75 de                	jne    30e <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 330:	8b 45 08             	mov    0x8(%ebp),%eax
}
 333:	c9                   	leave  
 334:	c3                   	ret    

00000335 <trampoline>:
 335:	5a                   	pop    %edx
 336:	59                   	pop    %ecx
 337:	58                   	pop    %eax
 338:	c9                   	leave  
 339:	c3                   	ret    

0000033a <signal>:
//	"addl 4, %esp\n\t"
	"leave\n\t"
	"ret\n\t"
);
int signal(int signum, sighandler_t handler) 
{
 33a:	55                   	push   %ebp
 33b:	89 e5                	mov    %esp,%ebp
 33d:	83 ec 18             	sub    $0x18,%esp
	register_signal_handler(signum, handler, trampoline);
 340:	c7 44 24 08 35 03 00 	movl   $0x335,0x8(%esp)
 347:	00 
 348:	8b 45 0c             	mov    0xc(%ebp),%eax
 34b:	89 44 24 04          	mov    %eax,0x4(%esp)
 34f:	8b 45 08             	mov    0x8(%ebp),%eax
 352:	89 04 24             	mov    %eax,(%esp)
 355:	e8 ba 00 00 00       	call   414 <register_signal_handler>
	return 0;
 35a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 35f:	c9                   	leave  
 360:	c3                   	ret    
 361:	90                   	nop
 362:	90                   	nop
 363:	90                   	nop

00000364 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 364:	b8 01 00 00 00       	mov    $0x1,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret    

0000036c <exit>:
SYSCALL(exit)
 36c:	b8 02 00 00 00       	mov    $0x2,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret    

00000374 <wait>:
SYSCALL(wait)
 374:	b8 03 00 00 00       	mov    $0x3,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <pipe>:
SYSCALL(pipe)
 37c:	b8 04 00 00 00       	mov    $0x4,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <read>:
SYSCALL(read)
 384:	b8 05 00 00 00       	mov    $0x5,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <write>:
SYSCALL(write)
 38c:	b8 10 00 00 00       	mov    $0x10,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <close>:
SYSCALL(close)
 394:	b8 15 00 00 00       	mov    $0x15,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <kill>:
SYSCALL(kill)
 39c:	b8 06 00 00 00       	mov    $0x6,%eax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret    

000003a4 <exec>:
SYSCALL(exec)
 3a4:	b8 07 00 00 00       	mov    $0x7,%eax
 3a9:	cd 40                	int    $0x40
 3ab:	c3                   	ret    

000003ac <open>:
SYSCALL(open)
 3ac:	b8 0f 00 00 00       	mov    $0xf,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret    

000003b4 <mknod>:
SYSCALL(mknod)
 3b4:	b8 11 00 00 00       	mov    $0x11,%eax
 3b9:	cd 40                	int    $0x40
 3bb:	c3                   	ret    

000003bc <unlink>:
SYSCALL(unlink)
 3bc:	b8 12 00 00 00       	mov    $0x12,%eax
 3c1:	cd 40                	int    $0x40
 3c3:	c3                   	ret    

000003c4 <fstat>:
SYSCALL(fstat)
 3c4:	b8 08 00 00 00       	mov    $0x8,%eax
 3c9:	cd 40                	int    $0x40
 3cb:	c3                   	ret    

000003cc <link>:
SYSCALL(link)
 3cc:	b8 13 00 00 00       	mov    $0x13,%eax
 3d1:	cd 40                	int    $0x40
 3d3:	c3                   	ret    

000003d4 <mkdir>:
SYSCALL(mkdir)
 3d4:	b8 14 00 00 00       	mov    $0x14,%eax
 3d9:	cd 40                	int    $0x40
 3db:	c3                   	ret    

000003dc <chdir>:
SYSCALL(chdir)
 3dc:	b8 09 00 00 00       	mov    $0x9,%eax
 3e1:	cd 40                	int    $0x40
 3e3:	c3                   	ret    

000003e4 <dup>:
SYSCALL(dup)
 3e4:	b8 0a 00 00 00       	mov    $0xa,%eax
 3e9:	cd 40                	int    $0x40
 3eb:	c3                   	ret    

000003ec <getpid>:
SYSCALL(getpid)
 3ec:	b8 0b 00 00 00       	mov    $0xb,%eax
 3f1:	cd 40                	int    $0x40
 3f3:	c3                   	ret    

000003f4 <sbrk>:
SYSCALL(sbrk)
 3f4:	b8 0c 00 00 00       	mov    $0xc,%eax
 3f9:	cd 40                	int    $0x40
 3fb:	c3                   	ret    

000003fc <sleep>:
SYSCALL(sleep)
 3fc:	b8 0d 00 00 00       	mov    $0xd,%eax
 401:	cd 40                	int    $0x40
 403:	c3                   	ret    

00000404 <uptime>:
SYSCALL(uptime)
 404:	b8 0e 00 00 00       	mov    $0xe,%eax
 409:	cd 40                	int    $0x40
 40b:	c3                   	ret    

0000040c <halt>:
SYSCALL(halt)
 40c:	b8 16 00 00 00       	mov    $0x16,%eax
 411:	cd 40                	int    $0x40
 413:	c3                   	ret    

00000414 <register_signal_handler>:
SYSCALL(register_signal_handler)
 414:	b8 17 00 00 00       	mov    $0x17,%eax
 419:	cd 40                	int    $0x40
 41b:	c3                   	ret    

0000041c <alarm>:
SYSCALL(alarm)
 41c:	b8 18 00 00 00       	mov    $0x18,%eax
 421:	cd 40                	int    $0x40
 423:	c3                   	ret    

00000424 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 424:	55                   	push   %ebp
 425:	89 e5                	mov    %esp,%ebp
 427:	83 ec 28             	sub    $0x28,%esp
 42a:	8b 45 0c             	mov    0xc(%ebp),%eax
 42d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 430:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 437:	00 
 438:	8d 45 f4             	lea    -0xc(%ebp),%eax
 43b:	89 44 24 04          	mov    %eax,0x4(%esp)
 43f:	8b 45 08             	mov    0x8(%ebp),%eax
 442:	89 04 24             	mov    %eax,(%esp)
 445:	e8 42 ff ff ff       	call   38c <write>
}
 44a:	c9                   	leave  
 44b:	c3                   	ret    

0000044c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 44c:	55                   	push   %ebp
 44d:	89 e5                	mov    %esp,%ebp
 44f:	53                   	push   %ebx
 450:	83 ec 44             	sub    $0x44,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 453:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 45a:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 45e:	74 17                	je     477 <printint+0x2b>
 460:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 464:	79 11                	jns    477 <printint+0x2b>
    neg = 1;
 466:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 46d:	8b 45 0c             	mov    0xc(%ebp),%eax
 470:	f7 d8                	neg    %eax
 472:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 475:	eb 06                	jmp    47d <printint+0x31>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 477:	8b 45 0c             	mov    0xc(%ebp),%eax
 47a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }

  i = 0;
 47d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  do{
    buf[i++] = digits[x % base];
 484:	8b 4d ec             	mov    -0x14(%ebp),%ecx
 487:	8b 5d 10             	mov    0x10(%ebp),%ebx
 48a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 48d:	ba 00 00 00 00       	mov    $0x0,%edx
 492:	f7 f3                	div    %ebx
 494:	89 d0                	mov    %edx,%eax
 496:	0f b6 80 5c 09 00 00 	movzbl 0x95c(%eax),%eax
 49d:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
 4a1:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  }while((x /= base) != 0);
 4a5:	8b 45 10             	mov    0x10(%ebp),%eax
 4a8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 4ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4ae:	ba 00 00 00 00       	mov    $0x0,%edx
 4b3:	f7 75 d4             	divl   -0x2c(%ebp)
 4b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4bd:	75 c5                	jne    484 <printint+0x38>
  if(neg)
 4bf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4c3:	74 2a                	je     4ef <printint+0xa3>
    buf[i++] = '-';
 4c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4c8:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)
 4cd:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)

  while(--i >= 0)
 4d1:	eb 1d                	jmp    4f0 <printint+0xa4>
    putc(fd, buf[i]);
 4d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4d6:	0f b6 44 05 dc       	movzbl -0x24(%ebp,%eax,1),%eax
 4db:	0f be c0             	movsbl %al,%eax
 4de:	89 44 24 04          	mov    %eax,0x4(%esp)
 4e2:	8b 45 08             	mov    0x8(%ebp),%eax
 4e5:	89 04 24             	mov    %eax,(%esp)
 4e8:	e8 37 ff ff ff       	call   424 <putc>
 4ed:	eb 01                	jmp    4f0 <printint+0xa4>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4ef:	90                   	nop
 4f0:	83 6d ec 01          	subl   $0x1,-0x14(%ebp)
 4f4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4f8:	79 d9                	jns    4d3 <printint+0x87>
    putc(fd, buf[i]);
}
 4fa:	83 c4 44             	add    $0x44,%esp
 4fd:	5b                   	pop    %ebx
 4fe:	5d                   	pop    %ebp
 4ff:	c3                   	ret    

00000500 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 500:	55                   	push   %ebp
 501:	89 e5                	mov    %esp,%ebp
 503:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 506:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 50d:	8d 45 0c             	lea    0xc(%ebp),%eax
 510:	83 c0 04             	add    $0x4,%eax
 513:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i = 0; fmt[i]; i++){
 516:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 51d:	e9 7e 01 00 00       	jmp    6a0 <printf+0x1a0>
    c = fmt[i] & 0xff;
 522:	8b 55 0c             	mov    0xc(%ebp),%edx
 525:	8b 45 ec             	mov    -0x14(%ebp),%eax
 528:	8d 04 02             	lea    (%edx,%eax,1),%eax
 52b:	0f b6 00             	movzbl (%eax),%eax
 52e:	0f be c0             	movsbl %al,%eax
 531:	25 ff 00 00 00       	and    $0xff,%eax
 536:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(state == 0){
 539:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 53d:	75 2c                	jne    56b <printf+0x6b>
      if(c == '%'){
 53f:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 543:	75 0c                	jne    551 <printf+0x51>
        state = '%';
 545:	c7 45 f0 25 00 00 00 	movl   $0x25,-0x10(%ebp)
 54c:	e9 4b 01 00 00       	jmp    69c <printf+0x19c>
      } else {
        putc(fd, c);
 551:	8b 45 e8             	mov    -0x18(%ebp),%eax
 554:	0f be c0             	movsbl %al,%eax
 557:	89 44 24 04          	mov    %eax,0x4(%esp)
 55b:	8b 45 08             	mov    0x8(%ebp),%eax
 55e:	89 04 24             	mov    %eax,(%esp)
 561:	e8 be fe ff ff       	call   424 <putc>
 566:	e9 31 01 00 00       	jmp    69c <printf+0x19c>
      }
    } else if(state == '%'){
 56b:	83 7d f0 25          	cmpl   $0x25,-0x10(%ebp)
 56f:	0f 85 27 01 00 00    	jne    69c <printf+0x19c>
      if(c == 'd'){
 575:	83 7d e8 64          	cmpl   $0x64,-0x18(%ebp)
 579:	75 2d                	jne    5a8 <printf+0xa8>
        printint(fd, *ap, 10, 1);
 57b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 57e:	8b 00                	mov    (%eax),%eax
 580:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 587:	00 
 588:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 58f:	00 
 590:	89 44 24 04          	mov    %eax,0x4(%esp)
 594:	8b 45 08             	mov    0x8(%ebp),%eax
 597:	89 04 24             	mov    %eax,(%esp)
 59a:	e8 ad fe ff ff       	call   44c <printint>
        ap++;
 59f:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 5a3:	e9 ed 00 00 00       	jmp    695 <printf+0x195>
      } else if(c == 'x' || c == 'p'){
 5a8:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
 5ac:	74 06                	je     5b4 <printf+0xb4>
 5ae:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
 5b2:	75 2d                	jne    5e1 <printf+0xe1>
        printint(fd, *ap, 16, 0);
 5b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5b7:	8b 00                	mov    (%eax),%eax
 5b9:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 5c0:	00 
 5c1:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 5c8:	00 
 5c9:	89 44 24 04          	mov    %eax,0x4(%esp)
 5cd:	8b 45 08             	mov    0x8(%ebp),%eax
 5d0:	89 04 24             	mov    %eax,(%esp)
 5d3:	e8 74 fe ff ff       	call   44c <printint>
        ap++;
 5d8:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 5dc:	e9 b4 00 00 00       	jmp    695 <printf+0x195>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 5e1:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
 5e5:	75 46                	jne    62d <printf+0x12d>
        s = (char*)*ap;
 5e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5ea:	8b 00                	mov    (%eax),%eax
 5ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ap++;
 5ef:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
        if(s == 0)
 5f3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 5f7:	75 27                	jne    620 <printf+0x120>
          s = "(null)";
 5f9:	c7 45 e4 53 09 00 00 	movl   $0x953,-0x1c(%ebp)
        while(*s != 0){
 600:	eb 1f                	jmp    621 <printf+0x121>
          putc(fd, *s);
 602:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 605:	0f b6 00             	movzbl (%eax),%eax
 608:	0f be c0             	movsbl %al,%eax
 60b:	89 44 24 04          	mov    %eax,0x4(%esp)
 60f:	8b 45 08             	mov    0x8(%ebp),%eax
 612:	89 04 24             	mov    %eax,(%esp)
 615:	e8 0a fe ff ff       	call   424 <putc>
          s++;
 61a:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 61e:	eb 01                	jmp    621 <printf+0x121>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 620:	90                   	nop
 621:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 624:	0f b6 00             	movzbl (%eax),%eax
 627:	84 c0                	test   %al,%al
 629:	75 d7                	jne    602 <printf+0x102>
 62b:	eb 68                	jmp    695 <printf+0x195>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 62d:	83 7d e8 63          	cmpl   $0x63,-0x18(%ebp)
 631:	75 1d                	jne    650 <printf+0x150>
        putc(fd, *ap);
 633:	8b 45 f4             	mov    -0xc(%ebp),%eax
 636:	8b 00                	mov    (%eax),%eax
 638:	0f be c0             	movsbl %al,%eax
 63b:	89 44 24 04          	mov    %eax,0x4(%esp)
 63f:	8b 45 08             	mov    0x8(%ebp),%eax
 642:	89 04 24             	mov    %eax,(%esp)
 645:	e8 da fd ff ff       	call   424 <putc>
        ap++;
 64a:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 64e:	eb 45                	jmp    695 <printf+0x195>
      } else if(c == '%'){
 650:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 654:	75 17                	jne    66d <printf+0x16d>
        putc(fd, c);
 656:	8b 45 e8             	mov    -0x18(%ebp),%eax
 659:	0f be c0             	movsbl %al,%eax
 65c:	89 44 24 04          	mov    %eax,0x4(%esp)
 660:	8b 45 08             	mov    0x8(%ebp),%eax
 663:	89 04 24             	mov    %eax,(%esp)
 666:	e8 b9 fd ff ff       	call   424 <putc>
 66b:	eb 28                	jmp    695 <printf+0x195>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 66d:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 674:	00 
 675:	8b 45 08             	mov    0x8(%ebp),%eax
 678:	89 04 24             	mov    %eax,(%esp)
 67b:	e8 a4 fd ff ff       	call   424 <putc>
        putc(fd, c);
 680:	8b 45 e8             	mov    -0x18(%ebp),%eax
 683:	0f be c0             	movsbl %al,%eax
 686:	89 44 24 04          	mov    %eax,0x4(%esp)
 68a:	8b 45 08             	mov    0x8(%ebp),%eax
 68d:	89 04 24             	mov    %eax,(%esp)
 690:	e8 8f fd ff ff       	call   424 <putc>
      }
      state = 0;
 695:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 69c:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 6a0:	8b 55 0c             	mov    0xc(%ebp),%edx
 6a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6a6:	8d 04 02             	lea    (%edx,%eax,1),%eax
 6a9:	0f b6 00             	movzbl (%eax),%eax
 6ac:	84 c0                	test   %al,%al
 6ae:	0f 85 6e fe ff ff    	jne    522 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6b4:	c9                   	leave  
 6b5:	c3                   	ret    
 6b6:	90                   	nop
 6b7:	90                   	nop

000006b8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6b8:	55                   	push   %ebp
 6b9:	89 e5                	mov    %esp,%ebp
 6bb:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6be:	8b 45 08             	mov    0x8(%ebp),%eax
 6c1:	83 e8 08             	sub    $0x8,%eax
 6c4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c7:	a1 7c 09 00 00       	mov    0x97c,%eax
 6cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6cf:	eb 24                	jmp    6f5 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d4:	8b 00                	mov    (%eax),%eax
 6d6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6d9:	77 12                	ja     6ed <free+0x35>
 6db:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6de:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6e1:	77 24                	ja     707 <free+0x4f>
 6e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e6:	8b 00                	mov    (%eax),%eax
 6e8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6eb:	77 1a                	ja     707 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f0:	8b 00                	mov    (%eax),%eax
 6f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6fb:	76 d4                	jbe    6d1 <free+0x19>
 6fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 700:	8b 00                	mov    (%eax),%eax
 702:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 705:	76 ca                	jbe    6d1 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 707:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70a:	8b 40 04             	mov    0x4(%eax),%eax
 70d:	c1 e0 03             	shl    $0x3,%eax
 710:	89 c2                	mov    %eax,%edx
 712:	03 55 f8             	add    -0x8(%ebp),%edx
 715:	8b 45 fc             	mov    -0x4(%ebp),%eax
 718:	8b 00                	mov    (%eax),%eax
 71a:	39 c2                	cmp    %eax,%edx
 71c:	75 24                	jne    742 <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 71e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 721:	8b 50 04             	mov    0x4(%eax),%edx
 724:	8b 45 fc             	mov    -0x4(%ebp),%eax
 727:	8b 00                	mov    (%eax),%eax
 729:	8b 40 04             	mov    0x4(%eax),%eax
 72c:	01 c2                	add    %eax,%edx
 72e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 731:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 734:	8b 45 fc             	mov    -0x4(%ebp),%eax
 737:	8b 00                	mov    (%eax),%eax
 739:	8b 10                	mov    (%eax),%edx
 73b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73e:	89 10                	mov    %edx,(%eax)
 740:	eb 0a                	jmp    74c <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 742:	8b 45 fc             	mov    -0x4(%ebp),%eax
 745:	8b 10                	mov    (%eax),%edx
 747:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 74c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74f:	8b 40 04             	mov    0x4(%eax),%eax
 752:	c1 e0 03             	shl    $0x3,%eax
 755:	03 45 fc             	add    -0x4(%ebp),%eax
 758:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 75b:	75 20                	jne    77d <free+0xc5>
    p->s.size += bp->s.size;
 75d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 760:	8b 50 04             	mov    0x4(%eax),%edx
 763:	8b 45 f8             	mov    -0x8(%ebp),%eax
 766:	8b 40 04             	mov    0x4(%eax),%eax
 769:	01 c2                	add    %eax,%edx
 76b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76e:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 771:	8b 45 f8             	mov    -0x8(%ebp),%eax
 774:	8b 10                	mov    (%eax),%edx
 776:	8b 45 fc             	mov    -0x4(%ebp),%eax
 779:	89 10                	mov    %edx,(%eax)
 77b:	eb 08                	jmp    785 <free+0xcd>
  } else
    p->s.ptr = bp;
 77d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 780:	8b 55 f8             	mov    -0x8(%ebp),%edx
 783:	89 10                	mov    %edx,(%eax)
  freep = p;
 785:	8b 45 fc             	mov    -0x4(%ebp),%eax
 788:	a3 7c 09 00 00       	mov    %eax,0x97c
}
 78d:	c9                   	leave  
 78e:	c3                   	ret    

0000078f <morecore>:

static Header*
morecore(uint nu)
{
 78f:	55                   	push   %ebp
 790:	89 e5                	mov    %esp,%ebp
 792:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 795:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 79c:	77 07                	ja     7a5 <morecore+0x16>
    nu = 4096;
 79e:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7a5:	8b 45 08             	mov    0x8(%ebp),%eax
 7a8:	c1 e0 03             	shl    $0x3,%eax
 7ab:	89 04 24             	mov    %eax,(%esp)
 7ae:	e8 41 fc ff ff       	call   3f4 <sbrk>
 7b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(p == (char*)-1)
 7b6:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
 7ba:	75 07                	jne    7c3 <morecore+0x34>
    return 0;
 7bc:	b8 00 00 00 00       	mov    $0x0,%eax
 7c1:	eb 22                	jmp    7e5 <morecore+0x56>
  hp = (Header*)p;
 7c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  hp->s.size = nu;
 7c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cc:	8b 55 08             	mov    0x8(%ebp),%edx
 7cf:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d5:	83 c0 08             	add    $0x8,%eax
 7d8:	89 04 24             	mov    %eax,(%esp)
 7db:	e8 d8 fe ff ff       	call   6b8 <free>
  return freep;
 7e0:	a1 7c 09 00 00       	mov    0x97c,%eax
}
 7e5:	c9                   	leave  
 7e6:	c3                   	ret    

000007e7 <malloc>:

void*
malloc(uint nbytes)
{
 7e7:	55                   	push   %ebp
 7e8:	89 e5                	mov    %esp,%ebp
 7ea:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7ed:	8b 45 08             	mov    0x8(%ebp),%eax
 7f0:	83 c0 07             	add    $0x7,%eax
 7f3:	c1 e8 03             	shr    $0x3,%eax
 7f6:	83 c0 01             	add    $0x1,%eax
 7f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((prevp = freep) == 0){
 7fc:	a1 7c 09 00 00       	mov    0x97c,%eax
 801:	89 45 f0             	mov    %eax,-0x10(%ebp)
 804:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 808:	75 23                	jne    82d <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 80a:	c7 45 f0 74 09 00 00 	movl   $0x974,-0x10(%ebp)
 811:	8b 45 f0             	mov    -0x10(%ebp),%eax
 814:	a3 7c 09 00 00       	mov    %eax,0x97c
 819:	a1 7c 09 00 00       	mov    0x97c,%eax
 81e:	a3 74 09 00 00       	mov    %eax,0x974
    base.s.size = 0;
 823:	c7 05 78 09 00 00 00 	movl   $0x0,0x978
 82a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 82d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 830:	8b 00                	mov    (%eax),%eax
 832:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(p->s.size >= nunits){
 835:	8b 45 ec             	mov    -0x14(%ebp),%eax
 838:	8b 40 04             	mov    0x4(%eax),%eax
 83b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 83e:	72 4d                	jb     88d <malloc+0xa6>
      if(p->s.size == nunits)
 840:	8b 45 ec             	mov    -0x14(%ebp),%eax
 843:	8b 40 04             	mov    0x4(%eax),%eax
 846:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 849:	75 0c                	jne    857 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 84b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 84e:	8b 10                	mov    (%eax),%edx
 850:	8b 45 f0             	mov    -0x10(%ebp),%eax
 853:	89 10                	mov    %edx,(%eax)
 855:	eb 26                	jmp    87d <malloc+0x96>
      else {
        p->s.size -= nunits;
 857:	8b 45 ec             	mov    -0x14(%ebp),%eax
 85a:	8b 40 04             	mov    0x4(%eax),%eax
 85d:	89 c2                	mov    %eax,%edx
 85f:	2b 55 f4             	sub    -0xc(%ebp),%edx
 862:	8b 45 ec             	mov    -0x14(%ebp),%eax
 865:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 868:	8b 45 ec             	mov    -0x14(%ebp),%eax
 86b:	8b 40 04             	mov    0x4(%eax),%eax
 86e:	c1 e0 03             	shl    $0x3,%eax
 871:	01 45 ec             	add    %eax,-0x14(%ebp)
        p->s.size = nunits;
 874:	8b 45 ec             	mov    -0x14(%ebp),%eax
 877:	8b 55 f4             	mov    -0xc(%ebp),%edx
 87a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 87d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 880:	a3 7c 09 00 00       	mov    %eax,0x97c
      return (void*)(p + 1);
 885:	8b 45 ec             	mov    -0x14(%ebp),%eax
 888:	83 c0 08             	add    $0x8,%eax
 88b:	eb 38                	jmp    8c5 <malloc+0xde>
    }
    if(p == freep)
 88d:	a1 7c 09 00 00       	mov    0x97c,%eax
 892:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 895:	75 1b                	jne    8b2 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 897:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89a:	89 04 24             	mov    %eax,(%esp)
 89d:	e8 ed fe ff ff       	call   78f <morecore>
 8a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
 8a5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 8a9:	75 07                	jne    8b2 <malloc+0xcb>
        return 0;
 8ab:	b8 00 00 00 00       	mov    $0x0,%eax
 8b0:	eb 13                	jmp    8c5 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8bb:	8b 00                	mov    (%eax),%eax
 8bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8c0:	e9 70 ff ff ff       	jmp    835 <malloc+0x4e>
}
 8c5:	c9                   	leave  
 8c6:	c3                   	ret    
