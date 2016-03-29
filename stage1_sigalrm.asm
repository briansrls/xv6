
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
   6:	c7 44 24 04 b0 08 00 	movl   $0x8b0,0x4(%esp)
   d:	00 
   e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  15:	e8 ce 04 00 00       	call   4e8 <printf>
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
  29:	c7 44 24 04 d9 08 00 	movl   $0x8d9,0x4(%esp)
  30:	00 
  31:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  38:	e8 ab 04 00 00       	call   4e8 <printf>
	if (info.signum == SIGALRM)
  3d:	8b 45 08             	mov    0x8(%ebp),%eax
  40:	83 f8 01             	cmp    $0x1,%eax
  43:	75 16                	jne    5b <handle_signal+0x3f>
		printf(1, "TEST PASSED\n");
  45:	c7 44 24 04 ee 08 00 	movl   $0x8ee,0x4(%esp)
  4c:	00 
  4d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  54:	e8 8f 04 00 00       	call   4e8 <printf>
  59:	eb 14                	jmp    6f <handle_signal+0x53>
	else
		printf(1, "TEST FAILED: wrong signal sent.\n");
  5b:	c7 44 24 04 fc 08 00 	movl   $0x8fc,0x4(%esp)
  62:	00 
  63:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  6a:	e8 79 04 00 00       	call   4e8 <printf>
	exit();
  6f:	e8 e4 02 00 00       	call   358 <exit>

00000074 <main>:
}

int main(int argc, char *argv[])
{
  74:	55                   	push   %ebp
  75:	89 e5                	mov    %esp,%ebp
  77:	83 e4 f0             	and    $0xfffffff0,%esp
  7a:	83 ec 20             	sub    $0x20,%esp
	int start = uptime();
  7d:	e8 6e 03 00 00       	call   3f0 <uptime>
  82:	89 44 24 1c          	mov    %eax,0x1c(%esp)

	signal(SIGALRM, handle_signal);
  86:	c7 44 24 04 1c 00 00 	movl   $0x1c,0x4(%esp)
  8d:	00 
  8e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  95:	e8 8e 02 00 00       	call   328 <signal>

	alarm(1);
  9a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  a1:	e8 62 03 00 00       	call   408 <alarm>

	while(!flag && uptime() < start + 2000);
  a6:	90                   	nop
  a7:	a1 f0 0b 00 00       	mov    0xbf0,%eax
  ac:	85 c0                	test   %eax,%eax
  ae:	75 13                	jne    c3 <main+0x4f>
  b0:	e8 3b 03 00 00       	call   3f0 <uptime>
  b5:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  b9:	81 c2 d0 07 00 00    	add    $0x7d0,%edx
  bf:	39 d0                	cmp    %edx,%eax
  c1:	7c e4                	jl     a7 <main+0x33>

	printf(1, "TEST FAILED: no signal sent.\n");
  c3:	c7 44 24 04 1d 09 00 	movl   $0x91d,0x4(%esp)
  ca:	00 
  cb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  d2:	e8 11 04 00 00       	call   4e8 <printf>
	
	exit();
  d7:	e8 7c 02 00 00       	call   358 <exit>

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
 10d:	90                   	nop
 10e:	8b 45 0c             	mov    0xc(%ebp),%eax
 111:	8a 10                	mov    (%eax),%dl
 113:	8b 45 08             	mov    0x8(%ebp),%eax
 116:	88 10                	mov    %dl,(%eax)
 118:	8b 45 08             	mov    0x8(%ebp),%eax
 11b:	8a 00                	mov    (%eax),%al
 11d:	84 c0                	test   %al,%al
 11f:	0f 95 c0             	setne  %al
 122:	ff 45 08             	incl   0x8(%ebp)
 125:	ff 45 0c             	incl   0xc(%ebp)
 128:	84 c0                	test   %al,%al
 12a:	75 e2                	jne    10e <strcpy+0xd>
    ;
  return os;
 12c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 12f:	c9                   	leave  
 130:	c3                   	ret    

00000131 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 131:	55                   	push   %ebp
 132:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 134:	eb 06                	jmp    13c <strcmp+0xb>
    p++, q++;
 136:	ff 45 08             	incl   0x8(%ebp)
 139:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 13c:	8b 45 08             	mov    0x8(%ebp),%eax
 13f:	8a 00                	mov    (%eax),%al
 141:	84 c0                	test   %al,%al
 143:	74 0e                	je     153 <strcmp+0x22>
 145:	8b 45 08             	mov    0x8(%ebp),%eax
 148:	8a 10                	mov    (%eax),%dl
 14a:	8b 45 0c             	mov    0xc(%ebp),%eax
 14d:	8a 00                	mov    (%eax),%al
 14f:	38 c2                	cmp    %al,%dl
 151:	74 e3                	je     136 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 153:	8b 45 08             	mov    0x8(%ebp),%eax
 156:	8a 00                	mov    (%eax),%al
 158:	0f b6 d0             	movzbl %al,%edx
 15b:	8b 45 0c             	mov    0xc(%ebp),%eax
 15e:	8a 00                	mov    (%eax),%al
 160:	0f b6 c0             	movzbl %al,%eax
 163:	89 d1                	mov    %edx,%ecx
 165:	29 c1                	sub    %eax,%ecx
 167:	89 c8                	mov    %ecx,%eax
}
 169:	5d                   	pop    %ebp
 16a:	c3                   	ret    

0000016b <strlen>:

uint
strlen(char *s)
{
 16b:	55                   	push   %ebp
 16c:	89 e5                	mov    %esp,%ebp
 16e:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 171:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 178:	eb 03                	jmp    17d <strlen+0x12>
 17a:	ff 45 fc             	incl   -0x4(%ebp)
 17d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 180:	8b 45 08             	mov    0x8(%ebp),%eax
 183:	01 d0                	add    %edx,%eax
 185:	8a 00                	mov    (%eax),%al
 187:	84 c0                	test   %al,%al
 189:	75 ef                	jne    17a <strlen+0xf>
    ;
  return n;
 18b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 18e:	c9                   	leave  
 18f:	c3                   	ret    

00000190 <memset>:

void*
memset(void *dst, int c, uint n)
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 196:	8b 45 10             	mov    0x10(%ebp),%eax
 199:	89 44 24 08          	mov    %eax,0x8(%esp)
 19d:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a0:	89 44 24 04          	mov    %eax,0x4(%esp)
 1a4:	8b 45 08             	mov    0x8(%ebp),%eax
 1a7:	89 04 24             	mov    %eax,(%esp)
 1aa:	e8 2d ff ff ff       	call   dc <stosb>
  return dst;
 1af:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1b2:	c9                   	leave  
 1b3:	c3                   	ret    

000001b4 <strchr>:

char*
strchr(const char *s, char c)
{
 1b4:	55                   	push   %ebp
 1b5:	89 e5                	mov    %esp,%ebp
 1b7:	83 ec 04             	sub    $0x4,%esp
 1ba:	8b 45 0c             	mov    0xc(%ebp),%eax
 1bd:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1c0:	eb 12                	jmp    1d4 <strchr+0x20>
    if(*s == c)
 1c2:	8b 45 08             	mov    0x8(%ebp),%eax
 1c5:	8a 00                	mov    (%eax),%al
 1c7:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1ca:	75 05                	jne    1d1 <strchr+0x1d>
      return (char*)s;
 1cc:	8b 45 08             	mov    0x8(%ebp),%eax
 1cf:	eb 11                	jmp    1e2 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1d1:	ff 45 08             	incl   0x8(%ebp)
 1d4:	8b 45 08             	mov    0x8(%ebp),%eax
 1d7:	8a 00                	mov    (%eax),%al
 1d9:	84 c0                	test   %al,%al
 1db:	75 e5                	jne    1c2 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1e2:	c9                   	leave  
 1e3:	c3                   	ret    

000001e4 <gets>:

char*
gets(char *buf, int max)
{
 1e4:	55                   	push   %ebp
 1e5:	89 e5                	mov    %esp,%ebp
 1e7:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1f1:	eb 42                	jmp    235 <gets+0x51>
    cc = read(0, &c, 1);
 1f3:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1fa:	00 
 1fb:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1fe:	89 44 24 04          	mov    %eax,0x4(%esp)
 202:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 209:	e8 62 01 00 00       	call   370 <read>
 20e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 211:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 215:	7e 29                	jle    240 <gets+0x5c>
      break;
    buf[i++] = c;
 217:	8b 55 f4             	mov    -0xc(%ebp),%edx
 21a:	8b 45 08             	mov    0x8(%ebp),%eax
 21d:	01 c2                	add    %eax,%edx
 21f:	8a 45 ef             	mov    -0x11(%ebp),%al
 222:	88 02                	mov    %al,(%edx)
 224:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 227:	8a 45 ef             	mov    -0x11(%ebp),%al
 22a:	3c 0a                	cmp    $0xa,%al
 22c:	74 13                	je     241 <gets+0x5d>
 22e:	8a 45 ef             	mov    -0x11(%ebp),%al
 231:	3c 0d                	cmp    $0xd,%al
 233:	74 0c                	je     241 <gets+0x5d>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 235:	8b 45 f4             	mov    -0xc(%ebp),%eax
 238:	40                   	inc    %eax
 239:	3b 45 0c             	cmp    0xc(%ebp),%eax
 23c:	7c b5                	jl     1f3 <gets+0xf>
 23e:	eb 01                	jmp    241 <gets+0x5d>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 240:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 241:	8b 55 f4             	mov    -0xc(%ebp),%edx
 244:	8b 45 08             	mov    0x8(%ebp),%eax
 247:	01 d0                	add    %edx,%eax
 249:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 24c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 24f:	c9                   	leave  
 250:	c3                   	ret    

00000251 <stat>:

int
stat(char *n, struct stat *st)
{
 251:	55                   	push   %ebp
 252:	89 e5                	mov    %esp,%ebp
 254:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 257:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 25e:	00 
 25f:	8b 45 08             	mov    0x8(%ebp),%eax
 262:	89 04 24             	mov    %eax,(%esp)
 265:	e8 2e 01 00 00       	call   398 <open>
 26a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 26d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 271:	79 07                	jns    27a <stat+0x29>
    return -1;
 273:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 278:	eb 23                	jmp    29d <stat+0x4c>
  r = fstat(fd, st);
 27a:	8b 45 0c             	mov    0xc(%ebp),%eax
 27d:	89 44 24 04          	mov    %eax,0x4(%esp)
 281:	8b 45 f4             	mov    -0xc(%ebp),%eax
 284:	89 04 24             	mov    %eax,(%esp)
 287:	e8 24 01 00 00       	call   3b0 <fstat>
 28c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 28f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 292:	89 04 24             	mov    %eax,(%esp)
 295:	e8 e6 00 00 00       	call   380 <close>
  return r;
 29a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 29d:	c9                   	leave  
 29e:	c3                   	ret    

0000029f <atoi>:

int
atoi(const char *s)
{
 29f:	55                   	push   %ebp
 2a0:	89 e5                	mov    %esp,%ebp
 2a2:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2ac:	eb 21                	jmp    2cf <atoi+0x30>
    n = n*10 + *s++ - '0';
 2ae:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2b1:	89 d0                	mov    %edx,%eax
 2b3:	c1 e0 02             	shl    $0x2,%eax
 2b6:	01 d0                	add    %edx,%eax
 2b8:	d1 e0                	shl    %eax
 2ba:	89 c2                	mov    %eax,%edx
 2bc:	8b 45 08             	mov    0x8(%ebp),%eax
 2bf:	8a 00                	mov    (%eax),%al
 2c1:	0f be c0             	movsbl %al,%eax
 2c4:	01 d0                	add    %edx,%eax
 2c6:	83 e8 30             	sub    $0x30,%eax
 2c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
 2cc:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2cf:	8b 45 08             	mov    0x8(%ebp),%eax
 2d2:	8a 00                	mov    (%eax),%al
 2d4:	3c 2f                	cmp    $0x2f,%al
 2d6:	7e 09                	jle    2e1 <atoi+0x42>
 2d8:	8b 45 08             	mov    0x8(%ebp),%eax
 2db:	8a 00                	mov    (%eax),%al
 2dd:	3c 39                	cmp    $0x39,%al
 2df:	7e cd                	jle    2ae <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2e4:	c9                   	leave  
 2e5:	c3                   	ret    

000002e6 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2e6:	55                   	push   %ebp
 2e7:	89 e5                	mov    %esp,%ebp
 2e9:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2ec:	8b 45 08             	mov    0x8(%ebp),%eax
 2ef:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2f2:	8b 45 0c             	mov    0xc(%ebp),%eax
 2f5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2f8:	eb 10                	jmp    30a <memmove+0x24>
    *dst++ = *src++;
 2fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2fd:	8a 10                	mov    (%eax),%dl
 2ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
 302:	88 10                	mov    %dl,(%eax)
 304:	ff 45 fc             	incl   -0x4(%ebp)
 307:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 30a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 30e:	0f 9f c0             	setg   %al
 311:	ff 4d 10             	decl   0x10(%ebp)
 314:	84 c0                	test   %al,%al
 316:	75 e2                	jne    2fa <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 318:	8b 45 08             	mov    0x8(%ebp),%eax
}
 31b:	c9                   	leave  
 31c:	c3                   	ret    

0000031d <trampoline>:
 31d:	5a                   	pop    %edx
 31e:	59                   	pop    %ecx
 31f:	58                   	pop    %eax
 320:	03 25 04 00 00 00    	add    0x4,%esp
 326:	c9                   	leave  
 327:	c3                   	ret    

00000328 <signal>:
	"addl 4, %esp\n\t"
	"leave\n\t"
	"ret\n\t"
);
int signal(int signum, sighandler_t handler) 
{
 328:	55                   	push   %ebp
 329:	89 e5                	mov    %esp,%ebp
 32b:	83 ec 18             	sub    $0x18,%esp
	register_signal_handler(signum, handler, trampoline);
 32e:	c7 44 24 08 1d 03 00 	movl   $0x31d,0x8(%esp)
 335:	00 
 336:	8b 45 0c             	mov    0xc(%ebp),%eax
 339:	89 44 24 04          	mov    %eax,0x4(%esp)
 33d:	8b 45 08             	mov    0x8(%ebp),%eax
 340:	89 04 24             	mov    %eax,(%esp)
 343:	e8 b8 00 00 00       	call   400 <register_signal_handler>
	return 0;
 348:	b8 00 00 00 00       	mov    $0x0,%eax
}
 34d:	c9                   	leave  
 34e:	c3                   	ret    
 34f:	90                   	nop

00000350 <fork>:
 350:	b8 01 00 00 00       	mov    $0x1,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <exit>:
 358:	b8 02 00 00 00       	mov    $0x2,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <wait>:
 360:	b8 03 00 00 00       	mov    $0x3,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <pipe>:
 368:	b8 04 00 00 00       	mov    $0x4,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <read>:
 370:	b8 05 00 00 00       	mov    $0x5,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <write>:
 378:	b8 10 00 00 00       	mov    $0x10,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <close>:
 380:	b8 15 00 00 00       	mov    $0x15,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <kill>:
 388:	b8 06 00 00 00       	mov    $0x6,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <exec>:
 390:	b8 07 00 00 00       	mov    $0x7,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <open>:
 398:	b8 0f 00 00 00       	mov    $0xf,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <mknod>:
 3a0:	b8 11 00 00 00       	mov    $0x11,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <unlink>:
 3a8:	b8 12 00 00 00       	mov    $0x12,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <fstat>:
 3b0:	b8 08 00 00 00       	mov    $0x8,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <link>:
 3b8:	b8 13 00 00 00       	mov    $0x13,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <mkdir>:
 3c0:	b8 14 00 00 00       	mov    $0x14,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <chdir>:
 3c8:	b8 09 00 00 00       	mov    $0x9,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <dup>:
 3d0:	b8 0a 00 00 00       	mov    $0xa,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <getpid>:
 3d8:	b8 0b 00 00 00       	mov    $0xb,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <sbrk>:
 3e0:	b8 0c 00 00 00       	mov    $0xc,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    

000003e8 <sleep>:
 3e8:	b8 0d 00 00 00       	mov    $0xd,%eax
 3ed:	cd 40                	int    $0x40
 3ef:	c3                   	ret    

000003f0 <uptime>:
 3f0:	b8 0e 00 00 00       	mov    $0xe,%eax
 3f5:	cd 40                	int    $0x40
 3f7:	c3                   	ret    

000003f8 <halt>:
 3f8:	b8 16 00 00 00       	mov    $0x16,%eax
 3fd:	cd 40                	int    $0x40
 3ff:	c3                   	ret    

00000400 <register_signal_handler>:
 400:	b8 17 00 00 00       	mov    $0x17,%eax
 405:	cd 40                	int    $0x40
 407:	c3                   	ret    

00000408 <alarm>:
 408:	b8 18 00 00 00       	mov    $0x18,%eax
 40d:	cd 40                	int    $0x40
 40f:	c3                   	ret    

00000410 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 410:	55                   	push   %ebp
 411:	89 e5                	mov    %esp,%ebp
 413:	83 ec 28             	sub    $0x28,%esp
 416:	8b 45 0c             	mov    0xc(%ebp),%eax
 419:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 41c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 423:	00 
 424:	8d 45 f4             	lea    -0xc(%ebp),%eax
 427:	89 44 24 04          	mov    %eax,0x4(%esp)
 42b:	8b 45 08             	mov    0x8(%ebp),%eax
 42e:	89 04 24             	mov    %eax,(%esp)
 431:	e8 42 ff ff ff       	call   378 <write>
}
 436:	c9                   	leave  
 437:	c3                   	ret    

00000438 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 438:	55                   	push   %ebp
 439:	89 e5                	mov    %esp,%ebp
 43b:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 43e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 445:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 449:	74 17                	je     462 <printint+0x2a>
 44b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 44f:	79 11                	jns    462 <printint+0x2a>
    neg = 1;
 451:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 458:	8b 45 0c             	mov    0xc(%ebp),%eax
 45b:	f7 d8                	neg    %eax
 45d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 460:	eb 06                	jmp    468 <printint+0x30>
  } else {
    x = xx;
 462:	8b 45 0c             	mov    0xc(%ebp),%eax
 465:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 468:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 46f:	8b 4d 10             	mov    0x10(%ebp),%ecx
 472:	8b 45 ec             	mov    -0x14(%ebp),%eax
 475:	ba 00 00 00 00       	mov    $0x0,%edx
 47a:	f7 f1                	div    %ecx
 47c:	89 d0                	mov    %edx,%eax
 47e:	8a 80 dc 0b 00 00    	mov    0xbdc(%eax),%al
 484:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 487:	8b 55 f4             	mov    -0xc(%ebp),%edx
 48a:	01 ca                	add    %ecx,%edx
 48c:	88 02                	mov    %al,(%edx)
 48e:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 491:	8b 55 10             	mov    0x10(%ebp),%edx
 494:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 497:	8b 45 ec             	mov    -0x14(%ebp),%eax
 49a:	ba 00 00 00 00       	mov    $0x0,%edx
 49f:	f7 75 d4             	divl   -0x2c(%ebp)
 4a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4a5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4a9:	75 c4                	jne    46f <printint+0x37>
  if(neg)
 4ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4af:	74 2c                	je     4dd <printint+0xa5>
    buf[i++] = '-';
 4b1:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4b7:	01 d0                	add    %edx,%eax
 4b9:	c6 00 2d             	movb   $0x2d,(%eax)
 4bc:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 4bf:	eb 1c                	jmp    4dd <printint+0xa5>
    putc(fd, buf[i]);
 4c1:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4c7:	01 d0                	add    %edx,%eax
 4c9:	8a 00                	mov    (%eax),%al
 4cb:	0f be c0             	movsbl %al,%eax
 4ce:	89 44 24 04          	mov    %eax,0x4(%esp)
 4d2:	8b 45 08             	mov    0x8(%ebp),%eax
 4d5:	89 04 24             	mov    %eax,(%esp)
 4d8:	e8 33 ff ff ff       	call   410 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4dd:	ff 4d f4             	decl   -0xc(%ebp)
 4e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4e4:	79 db                	jns    4c1 <printint+0x89>
    putc(fd, buf[i]);
}
 4e6:	c9                   	leave  
 4e7:	c3                   	ret    

000004e8 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4e8:	55                   	push   %ebp
 4e9:	89 e5                	mov    %esp,%ebp
 4eb:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4ee:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4f5:	8d 45 0c             	lea    0xc(%ebp),%eax
 4f8:	83 c0 04             	add    $0x4,%eax
 4fb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4fe:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 505:	e9 78 01 00 00       	jmp    682 <printf+0x19a>
    c = fmt[i] & 0xff;
 50a:	8b 55 0c             	mov    0xc(%ebp),%edx
 50d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 510:	01 d0                	add    %edx,%eax
 512:	8a 00                	mov    (%eax),%al
 514:	0f be c0             	movsbl %al,%eax
 517:	25 ff 00 00 00       	and    $0xff,%eax
 51c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 51f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 523:	75 2c                	jne    551 <printf+0x69>
      if(c == '%'){
 525:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 529:	75 0c                	jne    537 <printf+0x4f>
        state = '%';
 52b:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 532:	e9 48 01 00 00       	jmp    67f <printf+0x197>
      } else {
        putc(fd, c);
 537:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 53a:	0f be c0             	movsbl %al,%eax
 53d:	89 44 24 04          	mov    %eax,0x4(%esp)
 541:	8b 45 08             	mov    0x8(%ebp),%eax
 544:	89 04 24             	mov    %eax,(%esp)
 547:	e8 c4 fe ff ff       	call   410 <putc>
 54c:	e9 2e 01 00 00       	jmp    67f <printf+0x197>
      }
    } else if(state == '%'){
 551:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 555:	0f 85 24 01 00 00    	jne    67f <printf+0x197>
      if(c == 'd'){
 55b:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 55f:	75 2d                	jne    58e <printf+0xa6>
        printint(fd, *ap, 10, 1);
 561:	8b 45 e8             	mov    -0x18(%ebp),%eax
 564:	8b 00                	mov    (%eax),%eax
 566:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 56d:	00 
 56e:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 575:	00 
 576:	89 44 24 04          	mov    %eax,0x4(%esp)
 57a:	8b 45 08             	mov    0x8(%ebp),%eax
 57d:	89 04 24             	mov    %eax,(%esp)
 580:	e8 b3 fe ff ff       	call   438 <printint>
        ap++;
 585:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 589:	e9 ea 00 00 00       	jmp    678 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 58e:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 592:	74 06                	je     59a <printf+0xb2>
 594:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 598:	75 2d                	jne    5c7 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 59a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 59d:	8b 00                	mov    (%eax),%eax
 59f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 5a6:	00 
 5a7:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 5ae:	00 
 5af:	89 44 24 04          	mov    %eax,0x4(%esp)
 5b3:	8b 45 08             	mov    0x8(%ebp),%eax
 5b6:	89 04 24             	mov    %eax,(%esp)
 5b9:	e8 7a fe ff ff       	call   438 <printint>
        ap++;
 5be:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5c2:	e9 b1 00 00 00       	jmp    678 <printf+0x190>
      } else if(c == 's'){
 5c7:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5cb:	75 43                	jne    610 <printf+0x128>
        s = (char*)*ap;
 5cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5d0:	8b 00                	mov    (%eax),%eax
 5d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5d5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5dd:	75 25                	jne    604 <printf+0x11c>
          s = "(null)";
 5df:	c7 45 f4 3b 09 00 00 	movl   $0x93b,-0xc(%ebp)
        while(*s != 0){
 5e6:	eb 1c                	jmp    604 <printf+0x11c>
          putc(fd, *s);
 5e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5eb:	8a 00                	mov    (%eax),%al
 5ed:	0f be c0             	movsbl %al,%eax
 5f0:	89 44 24 04          	mov    %eax,0x4(%esp)
 5f4:	8b 45 08             	mov    0x8(%ebp),%eax
 5f7:	89 04 24             	mov    %eax,(%esp)
 5fa:	e8 11 fe ff ff       	call   410 <putc>
          s++;
 5ff:	ff 45 f4             	incl   -0xc(%ebp)
 602:	eb 01                	jmp    605 <printf+0x11d>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 604:	90                   	nop
 605:	8b 45 f4             	mov    -0xc(%ebp),%eax
 608:	8a 00                	mov    (%eax),%al
 60a:	84 c0                	test   %al,%al
 60c:	75 da                	jne    5e8 <printf+0x100>
 60e:	eb 68                	jmp    678 <printf+0x190>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 610:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 614:	75 1d                	jne    633 <printf+0x14b>
        putc(fd, *ap);
 616:	8b 45 e8             	mov    -0x18(%ebp),%eax
 619:	8b 00                	mov    (%eax),%eax
 61b:	0f be c0             	movsbl %al,%eax
 61e:	89 44 24 04          	mov    %eax,0x4(%esp)
 622:	8b 45 08             	mov    0x8(%ebp),%eax
 625:	89 04 24             	mov    %eax,(%esp)
 628:	e8 e3 fd ff ff       	call   410 <putc>
        ap++;
 62d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 631:	eb 45                	jmp    678 <printf+0x190>
      } else if(c == '%'){
 633:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 637:	75 17                	jne    650 <printf+0x168>
        putc(fd, c);
 639:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 63c:	0f be c0             	movsbl %al,%eax
 63f:	89 44 24 04          	mov    %eax,0x4(%esp)
 643:	8b 45 08             	mov    0x8(%ebp),%eax
 646:	89 04 24             	mov    %eax,(%esp)
 649:	e8 c2 fd ff ff       	call   410 <putc>
 64e:	eb 28                	jmp    678 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 650:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 657:	00 
 658:	8b 45 08             	mov    0x8(%ebp),%eax
 65b:	89 04 24             	mov    %eax,(%esp)
 65e:	e8 ad fd ff ff       	call   410 <putc>
        putc(fd, c);
 663:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 666:	0f be c0             	movsbl %al,%eax
 669:	89 44 24 04          	mov    %eax,0x4(%esp)
 66d:	8b 45 08             	mov    0x8(%ebp),%eax
 670:	89 04 24             	mov    %eax,(%esp)
 673:	e8 98 fd ff ff       	call   410 <putc>
      }
      state = 0;
 678:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 67f:	ff 45 f0             	incl   -0x10(%ebp)
 682:	8b 55 0c             	mov    0xc(%ebp),%edx
 685:	8b 45 f0             	mov    -0x10(%ebp),%eax
 688:	01 d0                	add    %edx,%eax
 68a:	8a 00                	mov    (%eax),%al
 68c:	84 c0                	test   %al,%al
 68e:	0f 85 76 fe ff ff    	jne    50a <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 694:	c9                   	leave  
 695:	c3                   	ret    
 696:	66 90                	xchg   %ax,%ax

00000698 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 698:	55                   	push   %ebp
 699:	89 e5                	mov    %esp,%ebp
 69b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 69e:	8b 45 08             	mov    0x8(%ebp),%eax
 6a1:	83 e8 08             	sub    $0x8,%eax
 6a4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a7:	a1 fc 0b 00 00       	mov    0xbfc,%eax
 6ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6af:	eb 24                	jmp    6d5 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b4:	8b 00                	mov    (%eax),%eax
 6b6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6b9:	77 12                	ja     6cd <free+0x35>
 6bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6be:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6c1:	77 24                	ja     6e7 <free+0x4f>
 6c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c6:	8b 00                	mov    (%eax),%eax
 6c8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6cb:	77 1a                	ja     6e7 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d0:	8b 00                	mov    (%eax),%eax
 6d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6db:	76 d4                	jbe    6b1 <free+0x19>
 6dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e0:	8b 00                	mov    (%eax),%eax
 6e2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6e5:	76 ca                	jbe    6b1 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ea:	8b 40 04             	mov    0x4(%eax),%eax
 6ed:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f7:	01 c2                	add    %eax,%edx
 6f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fc:	8b 00                	mov    (%eax),%eax
 6fe:	39 c2                	cmp    %eax,%edx
 700:	75 24                	jne    726 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 702:	8b 45 f8             	mov    -0x8(%ebp),%eax
 705:	8b 50 04             	mov    0x4(%eax),%edx
 708:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70b:	8b 00                	mov    (%eax),%eax
 70d:	8b 40 04             	mov    0x4(%eax),%eax
 710:	01 c2                	add    %eax,%edx
 712:	8b 45 f8             	mov    -0x8(%ebp),%eax
 715:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 718:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71b:	8b 00                	mov    (%eax),%eax
 71d:	8b 10                	mov    (%eax),%edx
 71f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 722:	89 10                	mov    %edx,(%eax)
 724:	eb 0a                	jmp    730 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 726:	8b 45 fc             	mov    -0x4(%ebp),%eax
 729:	8b 10                	mov    (%eax),%edx
 72b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 730:	8b 45 fc             	mov    -0x4(%ebp),%eax
 733:	8b 40 04             	mov    0x4(%eax),%eax
 736:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 73d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 740:	01 d0                	add    %edx,%eax
 742:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 745:	75 20                	jne    767 <free+0xcf>
    p->s.size += bp->s.size;
 747:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74a:	8b 50 04             	mov    0x4(%eax),%edx
 74d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 750:	8b 40 04             	mov    0x4(%eax),%eax
 753:	01 c2                	add    %eax,%edx
 755:	8b 45 fc             	mov    -0x4(%ebp),%eax
 758:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 75b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 75e:	8b 10                	mov    (%eax),%edx
 760:	8b 45 fc             	mov    -0x4(%ebp),%eax
 763:	89 10                	mov    %edx,(%eax)
 765:	eb 08                	jmp    76f <free+0xd7>
  } else
    p->s.ptr = bp;
 767:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 76d:	89 10                	mov    %edx,(%eax)
  freep = p;
 76f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 772:	a3 fc 0b 00 00       	mov    %eax,0xbfc
}
 777:	c9                   	leave  
 778:	c3                   	ret    

00000779 <morecore>:

static Header*
morecore(uint nu)
{
 779:	55                   	push   %ebp
 77a:	89 e5                	mov    %esp,%ebp
 77c:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 77f:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 786:	77 07                	ja     78f <morecore+0x16>
    nu = 4096;
 788:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 78f:	8b 45 08             	mov    0x8(%ebp),%eax
 792:	c1 e0 03             	shl    $0x3,%eax
 795:	89 04 24             	mov    %eax,(%esp)
 798:	e8 43 fc ff ff       	call   3e0 <sbrk>
 79d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7a0:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7a4:	75 07                	jne    7ad <morecore+0x34>
    return 0;
 7a6:	b8 00 00 00 00       	mov    $0x0,%eax
 7ab:	eb 22                	jmp    7cf <morecore+0x56>
  hp = (Header*)p;
 7ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b6:	8b 55 08             	mov    0x8(%ebp),%edx
 7b9:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7bf:	83 c0 08             	add    $0x8,%eax
 7c2:	89 04 24             	mov    %eax,(%esp)
 7c5:	e8 ce fe ff ff       	call   698 <free>
  return freep;
 7ca:	a1 fc 0b 00 00       	mov    0xbfc,%eax
}
 7cf:	c9                   	leave  
 7d0:	c3                   	ret    

000007d1 <malloc>:

void*
malloc(uint nbytes)
{
 7d1:	55                   	push   %ebp
 7d2:	89 e5                	mov    %esp,%ebp
 7d4:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7d7:	8b 45 08             	mov    0x8(%ebp),%eax
 7da:	83 c0 07             	add    $0x7,%eax
 7dd:	c1 e8 03             	shr    $0x3,%eax
 7e0:	40                   	inc    %eax
 7e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7e4:	a1 fc 0b 00 00       	mov    0xbfc,%eax
 7e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7f0:	75 23                	jne    815 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 7f2:	c7 45 f0 f4 0b 00 00 	movl   $0xbf4,-0x10(%ebp)
 7f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7fc:	a3 fc 0b 00 00       	mov    %eax,0xbfc
 801:	a1 fc 0b 00 00       	mov    0xbfc,%eax
 806:	a3 f4 0b 00 00       	mov    %eax,0xbf4
    base.s.size = 0;
 80b:	c7 05 f8 0b 00 00 00 	movl   $0x0,0xbf8
 812:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 815:	8b 45 f0             	mov    -0x10(%ebp),%eax
 818:	8b 00                	mov    (%eax),%eax
 81a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 81d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 820:	8b 40 04             	mov    0x4(%eax),%eax
 823:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 826:	72 4d                	jb     875 <malloc+0xa4>
      if(p->s.size == nunits)
 828:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82b:	8b 40 04             	mov    0x4(%eax),%eax
 82e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 831:	75 0c                	jne    83f <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 833:	8b 45 f4             	mov    -0xc(%ebp),%eax
 836:	8b 10                	mov    (%eax),%edx
 838:	8b 45 f0             	mov    -0x10(%ebp),%eax
 83b:	89 10                	mov    %edx,(%eax)
 83d:	eb 26                	jmp    865 <malloc+0x94>
      else {
        p->s.size -= nunits;
 83f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 842:	8b 40 04             	mov    0x4(%eax),%eax
 845:	89 c2                	mov    %eax,%edx
 847:	2b 55 ec             	sub    -0x14(%ebp),%edx
 84a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 850:	8b 45 f4             	mov    -0xc(%ebp),%eax
 853:	8b 40 04             	mov    0x4(%eax),%eax
 856:	c1 e0 03             	shl    $0x3,%eax
 859:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 85c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85f:	8b 55 ec             	mov    -0x14(%ebp),%edx
 862:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 865:	8b 45 f0             	mov    -0x10(%ebp),%eax
 868:	a3 fc 0b 00 00       	mov    %eax,0xbfc
      return (void*)(p + 1);
 86d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 870:	83 c0 08             	add    $0x8,%eax
 873:	eb 38                	jmp    8ad <malloc+0xdc>
    }
    if(p == freep)
 875:	a1 fc 0b 00 00       	mov    0xbfc,%eax
 87a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 87d:	75 1b                	jne    89a <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 87f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 882:	89 04 24             	mov    %eax,(%esp)
 885:	e8 ef fe ff ff       	call   779 <morecore>
 88a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 88d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 891:	75 07                	jne    89a <malloc+0xc9>
        return 0;
 893:	b8 00 00 00 00       	mov    $0x0,%eax
 898:	eb 13                	jmp    8ad <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 89a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a3:	8b 00                	mov    (%eax),%eax
 8a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8a8:	e9 70 ff ff ff       	jmp    81d <malloc+0x4c>
}
 8ad:	c9                   	leave  
 8ae:	c3                   	ret    
