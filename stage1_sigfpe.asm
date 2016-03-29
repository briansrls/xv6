
_stage1_sigfpe:     file format elf32-i386


Disassembly of section .text:

00000000 <dummy>:
#include "stat.h"
#include "user.h"
#include "signal.h"

void dummy(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp

}
   3:	5d                   	pop    %ebp
   4:	c3                   	ret    

00000005 <handle_signal>:

void handle_signal(siginfo_t info)
{
   5:	55                   	push   %ebp
   6:	89 e5                	mov    %esp,%ebp
   8:	83 ec 18             	sub    $0x18,%esp
	printf(1, "Caught signal %d...\n", info.signum);
   b:	8b 45 08             	mov    0x8(%ebp),%eax
   e:	89 44 24 08          	mov    %eax,0x8(%esp)
  12:	c7 44 24 04 84 08 00 	movl   $0x884,0x4(%esp)
  19:	00 
  1a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  21:	e8 96 04 00 00       	call   4bc <printf>
	if (info.signum == SIGFPE)
  26:	8b 45 08             	mov    0x8(%ebp),%eax
  29:	85 c0                	test   %eax,%eax
  2b:	75 16                	jne    43 <handle_signal+0x3e>
		printf(1, "TEST PASSED\n");
  2d:	c7 44 24 04 99 08 00 	movl   $0x899,0x4(%esp)
  34:	00 
  35:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  3c:	e8 7b 04 00 00       	call   4bc <printf>
  41:	eb 14                	jmp    57 <handle_signal+0x52>
	else
		printf(1, "TEST FAILED: wrong signal sent.\n");
  43:	c7 44 24 04 a8 08 00 	movl   $0x8a8,0x4(%esp)
  4a:	00 
  4b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  52:	e8 65 04 00 00       	call   4bc <printf>
	exit();
  57:	e8 d0 02 00 00       	call   32c <exit>

0000005c <main>:
}

int main(int argc, char *argv[])
{
  5c:	55                   	push   %ebp
  5d:	89 e5                	mov    %esp,%ebp
  5f:	83 e4 f0             	and    $0xfffffff0,%esp
  62:	83 ec 20             	sub    $0x20,%esp
	int x = 5;
  65:	c7 44 24 1c 05 00 00 	movl   $0x5,0x1c(%esp)
  6c:	00 
	int y = 0;
  6d:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  74:	00 

	signal(SIGFPE, handle_signal);
  75:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  7c:	00 
  7d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  84:	e8 73 02 00 00       	call   2fc <signal>

	x = x / y;
  89:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  8d:	99                   	cltd   
  8e:	f7 7c 24 18          	idivl  0x18(%esp)
  92:	89 44 24 1c          	mov    %eax,0x1c(%esp)

	printf(1, "TEST FAILED: no signal sent.\n");
  96:	c7 44 24 04 c9 08 00 	movl   $0x8c9,0x4(%esp)
  9d:	00 
  9e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  a5:	e8 12 04 00 00       	call   4bc <printf>
	
	exit();
  aa:	e8 7d 02 00 00       	call   32c <exit>
  af:	90                   	nop

000000b0 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  b0:	55                   	push   %ebp
  b1:	89 e5                	mov    %esp,%ebp
  b3:	57                   	push   %edi
  b4:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  b5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  b8:	8b 55 10             	mov    0x10(%ebp),%edx
  bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  be:	89 cb                	mov    %ecx,%ebx
  c0:	89 df                	mov    %ebx,%edi
  c2:	89 d1                	mov    %edx,%ecx
  c4:	fc                   	cld    
  c5:	f3 aa                	rep stos %al,%es:(%edi)
  c7:	89 ca                	mov    %ecx,%edx
  c9:	89 fb                	mov    %edi,%ebx
  cb:	89 5d 08             	mov    %ebx,0x8(%ebp)
  ce:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  d1:	5b                   	pop    %ebx
  d2:	5f                   	pop    %edi
  d3:	5d                   	pop    %ebp
  d4:	c3                   	ret    

000000d5 <strcpy>:
#include "x86.h"
#include "signal.h"

char*
strcpy(char *s, char *t)
{
  d5:	55                   	push   %ebp
  d6:	89 e5                	mov    %esp,%ebp
  d8:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  db:	8b 45 08             	mov    0x8(%ebp),%eax
  de:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  e1:	90                   	nop
  e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  e5:	8a 10                	mov    (%eax),%dl
  e7:	8b 45 08             	mov    0x8(%ebp),%eax
  ea:	88 10                	mov    %dl,(%eax)
  ec:	8b 45 08             	mov    0x8(%ebp),%eax
  ef:	8a 00                	mov    (%eax),%al
  f1:	84 c0                	test   %al,%al
  f3:	0f 95 c0             	setne  %al
  f6:	ff 45 08             	incl   0x8(%ebp)
  f9:	ff 45 0c             	incl   0xc(%ebp)
  fc:	84 c0                	test   %al,%al
  fe:	75 e2                	jne    e2 <strcpy+0xd>
    ;
  return os;
 100:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 103:	c9                   	leave  
 104:	c3                   	ret    

00000105 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 105:	55                   	push   %ebp
 106:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 108:	eb 06                	jmp    110 <strcmp+0xb>
    p++, q++;
 10a:	ff 45 08             	incl   0x8(%ebp)
 10d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 110:	8b 45 08             	mov    0x8(%ebp),%eax
 113:	8a 00                	mov    (%eax),%al
 115:	84 c0                	test   %al,%al
 117:	74 0e                	je     127 <strcmp+0x22>
 119:	8b 45 08             	mov    0x8(%ebp),%eax
 11c:	8a 10                	mov    (%eax),%dl
 11e:	8b 45 0c             	mov    0xc(%ebp),%eax
 121:	8a 00                	mov    (%eax),%al
 123:	38 c2                	cmp    %al,%dl
 125:	74 e3                	je     10a <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 127:	8b 45 08             	mov    0x8(%ebp),%eax
 12a:	8a 00                	mov    (%eax),%al
 12c:	0f b6 d0             	movzbl %al,%edx
 12f:	8b 45 0c             	mov    0xc(%ebp),%eax
 132:	8a 00                	mov    (%eax),%al
 134:	0f b6 c0             	movzbl %al,%eax
 137:	89 d1                	mov    %edx,%ecx
 139:	29 c1                	sub    %eax,%ecx
 13b:	89 c8                	mov    %ecx,%eax
}
 13d:	5d                   	pop    %ebp
 13e:	c3                   	ret    

0000013f <strlen>:

uint
strlen(char *s)
{
 13f:	55                   	push   %ebp
 140:	89 e5                	mov    %esp,%ebp
 142:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 145:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 14c:	eb 03                	jmp    151 <strlen+0x12>
 14e:	ff 45 fc             	incl   -0x4(%ebp)
 151:	8b 55 fc             	mov    -0x4(%ebp),%edx
 154:	8b 45 08             	mov    0x8(%ebp),%eax
 157:	01 d0                	add    %edx,%eax
 159:	8a 00                	mov    (%eax),%al
 15b:	84 c0                	test   %al,%al
 15d:	75 ef                	jne    14e <strlen+0xf>
    ;
  return n;
 15f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 162:	c9                   	leave  
 163:	c3                   	ret    

00000164 <memset>:

void*
memset(void *dst, int c, uint n)
{
 164:	55                   	push   %ebp
 165:	89 e5                	mov    %esp,%ebp
 167:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 16a:	8b 45 10             	mov    0x10(%ebp),%eax
 16d:	89 44 24 08          	mov    %eax,0x8(%esp)
 171:	8b 45 0c             	mov    0xc(%ebp),%eax
 174:	89 44 24 04          	mov    %eax,0x4(%esp)
 178:	8b 45 08             	mov    0x8(%ebp),%eax
 17b:	89 04 24             	mov    %eax,(%esp)
 17e:	e8 2d ff ff ff       	call   b0 <stosb>
  return dst;
 183:	8b 45 08             	mov    0x8(%ebp),%eax
}
 186:	c9                   	leave  
 187:	c3                   	ret    

00000188 <strchr>:

char*
strchr(const char *s, char c)
{
 188:	55                   	push   %ebp
 189:	89 e5                	mov    %esp,%ebp
 18b:	83 ec 04             	sub    $0x4,%esp
 18e:	8b 45 0c             	mov    0xc(%ebp),%eax
 191:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 194:	eb 12                	jmp    1a8 <strchr+0x20>
    if(*s == c)
 196:	8b 45 08             	mov    0x8(%ebp),%eax
 199:	8a 00                	mov    (%eax),%al
 19b:	3a 45 fc             	cmp    -0x4(%ebp),%al
 19e:	75 05                	jne    1a5 <strchr+0x1d>
      return (char*)s;
 1a0:	8b 45 08             	mov    0x8(%ebp),%eax
 1a3:	eb 11                	jmp    1b6 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1a5:	ff 45 08             	incl   0x8(%ebp)
 1a8:	8b 45 08             	mov    0x8(%ebp),%eax
 1ab:	8a 00                	mov    (%eax),%al
 1ad:	84 c0                	test   %al,%al
 1af:	75 e5                	jne    196 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1b6:	c9                   	leave  
 1b7:	c3                   	ret    

000001b8 <gets>:

char*
gets(char *buf, int max)
{
 1b8:	55                   	push   %ebp
 1b9:	89 e5                	mov    %esp,%ebp
 1bb:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1be:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1c5:	eb 42                	jmp    209 <gets+0x51>
    cc = read(0, &c, 1);
 1c7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1ce:	00 
 1cf:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1d2:	89 44 24 04          	mov    %eax,0x4(%esp)
 1d6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1dd:	e8 62 01 00 00       	call   344 <read>
 1e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1e5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1e9:	7e 29                	jle    214 <gets+0x5c>
      break;
    buf[i++] = c;
 1eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1ee:	8b 45 08             	mov    0x8(%ebp),%eax
 1f1:	01 c2                	add    %eax,%edx
 1f3:	8a 45 ef             	mov    -0x11(%ebp),%al
 1f6:	88 02                	mov    %al,(%edx)
 1f8:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 1fb:	8a 45 ef             	mov    -0x11(%ebp),%al
 1fe:	3c 0a                	cmp    $0xa,%al
 200:	74 13                	je     215 <gets+0x5d>
 202:	8a 45 ef             	mov    -0x11(%ebp),%al
 205:	3c 0d                	cmp    $0xd,%al
 207:	74 0c                	je     215 <gets+0x5d>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 209:	8b 45 f4             	mov    -0xc(%ebp),%eax
 20c:	40                   	inc    %eax
 20d:	3b 45 0c             	cmp    0xc(%ebp),%eax
 210:	7c b5                	jl     1c7 <gets+0xf>
 212:	eb 01                	jmp    215 <gets+0x5d>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 214:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 215:	8b 55 f4             	mov    -0xc(%ebp),%edx
 218:	8b 45 08             	mov    0x8(%ebp),%eax
 21b:	01 d0                	add    %edx,%eax
 21d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 220:	8b 45 08             	mov    0x8(%ebp),%eax
}
 223:	c9                   	leave  
 224:	c3                   	ret    

00000225 <stat>:

int
stat(char *n, struct stat *st)
{
 225:	55                   	push   %ebp
 226:	89 e5                	mov    %esp,%ebp
 228:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 22b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 232:	00 
 233:	8b 45 08             	mov    0x8(%ebp),%eax
 236:	89 04 24             	mov    %eax,(%esp)
 239:	e8 2e 01 00 00       	call   36c <open>
 23e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 241:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 245:	79 07                	jns    24e <stat+0x29>
    return -1;
 247:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 24c:	eb 23                	jmp    271 <stat+0x4c>
  r = fstat(fd, st);
 24e:	8b 45 0c             	mov    0xc(%ebp),%eax
 251:	89 44 24 04          	mov    %eax,0x4(%esp)
 255:	8b 45 f4             	mov    -0xc(%ebp),%eax
 258:	89 04 24             	mov    %eax,(%esp)
 25b:	e8 24 01 00 00       	call   384 <fstat>
 260:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 263:	8b 45 f4             	mov    -0xc(%ebp),%eax
 266:	89 04 24             	mov    %eax,(%esp)
 269:	e8 e6 00 00 00       	call   354 <close>
  return r;
 26e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 271:	c9                   	leave  
 272:	c3                   	ret    

00000273 <atoi>:

int
atoi(const char *s)
{
 273:	55                   	push   %ebp
 274:	89 e5                	mov    %esp,%ebp
 276:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 279:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 280:	eb 21                	jmp    2a3 <atoi+0x30>
    n = n*10 + *s++ - '0';
 282:	8b 55 fc             	mov    -0x4(%ebp),%edx
 285:	89 d0                	mov    %edx,%eax
 287:	c1 e0 02             	shl    $0x2,%eax
 28a:	01 d0                	add    %edx,%eax
 28c:	d1 e0                	shl    %eax
 28e:	89 c2                	mov    %eax,%edx
 290:	8b 45 08             	mov    0x8(%ebp),%eax
 293:	8a 00                	mov    (%eax),%al
 295:	0f be c0             	movsbl %al,%eax
 298:	01 d0                	add    %edx,%eax
 29a:	83 e8 30             	sub    $0x30,%eax
 29d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 2a0:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2a3:	8b 45 08             	mov    0x8(%ebp),%eax
 2a6:	8a 00                	mov    (%eax),%al
 2a8:	3c 2f                	cmp    $0x2f,%al
 2aa:	7e 09                	jle    2b5 <atoi+0x42>
 2ac:	8b 45 08             	mov    0x8(%ebp),%eax
 2af:	8a 00                	mov    (%eax),%al
 2b1:	3c 39                	cmp    $0x39,%al
 2b3:	7e cd                	jle    282 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2b8:	c9                   	leave  
 2b9:	c3                   	ret    

000002ba <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2ba:	55                   	push   %ebp
 2bb:	89 e5                	mov    %esp,%ebp
 2bd:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2c0:	8b 45 08             	mov    0x8(%ebp),%eax
 2c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2c6:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2cc:	eb 10                	jmp    2de <memmove+0x24>
    *dst++ = *src++;
 2ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2d1:	8a 10                	mov    (%eax),%dl
 2d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2d6:	88 10                	mov    %dl,(%eax)
 2d8:	ff 45 fc             	incl   -0x4(%ebp)
 2db:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2de:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 2e2:	0f 9f c0             	setg   %al
 2e5:	ff 4d 10             	decl   0x10(%ebp)
 2e8:	84 c0                	test   %al,%al
 2ea:	75 e2                	jne    2ce <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2ec:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2ef:	c9                   	leave  
 2f0:	c3                   	ret    

000002f1 <trampoline>:
 2f1:	5a                   	pop    %edx
 2f2:	59                   	pop    %ecx
 2f3:	58                   	pop    %eax
 2f4:	03 25 04 00 00 00    	add    0x4,%esp
 2fa:	c9                   	leave  
 2fb:	c3                   	ret    

000002fc <signal>:
	"addl 4, %esp\n\t"
	"leave\n\t"
	"ret\n\t"
);
int signal(int signum, sighandler_t handler) 
{
 2fc:	55                   	push   %ebp
 2fd:	89 e5                	mov    %esp,%ebp
 2ff:	83 ec 18             	sub    $0x18,%esp
	register_signal_handler(signum, handler, trampoline);
 302:	c7 44 24 08 f1 02 00 	movl   $0x2f1,0x8(%esp)
 309:	00 
 30a:	8b 45 0c             	mov    0xc(%ebp),%eax
 30d:	89 44 24 04          	mov    %eax,0x4(%esp)
 311:	8b 45 08             	mov    0x8(%ebp),%eax
 314:	89 04 24             	mov    %eax,(%esp)
 317:	e8 b8 00 00 00       	call   3d4 <register_signal_handler>
	return 0;
 31c:	b8 00 00 00 00       	mov    $0x0,%eax
}
 321:	c9                   	leave  
 322:	c3                   	ret    
 323:	90                   	nop

00000324 <fork>:
 324:	b8 01 00 00 00       	mov    $0x1,%eax
 329:	cd 40                	int    $0x40
 32b:	c3                   	ret    

0000032c <exit>:
 32c:	b8 02 00 00 00       	mov    $0x2,%eax
 331:	cd 40                	int    $0x40
 333:	c3                   	ret    

00000334 <wait>:
 334:	b8 03 00 00 00       	mov    $0x3,%eax
 339:	cd 40                	int    $0x40
 33b:	c3                   	ret    

0000033c <pipe>:
 33c:	b8 04 00 00 00       	mov    $0x4,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <read>:
 344:	b8 05 00 00 00       	mov    $0x5,%eax
 349:	cd 40                	int    $0x40
 34b:	c3                   	ret    

0000034c <write>:
 34c:	b8 10 00 00 00       	mov    $0x10,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <close>:
 354:	b8 15 00 00 00       	mov    $0x15,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <kill>:
 35c:	b8 06 00 00 00       	mov    $0x6,%eax
 361:	cd 40                	int    $0x40
 363:	c3                   	ret    

00000364 <exec>:
 364:	b8 07 00 00 00       	mov    $0x7,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret    

0000036c <open>:
 36c:	b8 0f 00 00 00       	mov    $0xf,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret    

00000374 <mknod>:
 374:	b8 11 00 00 00       	mov    $0x11,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <unlink>:
 37c:	b8 12 00 00 00       	mov    $0x12,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <fstat>:
 384:	b8 08 00 00 00       	mov    $0x8,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <link>:
 38c:	b8 13 00 00 00       	mov    $0x13,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <mkdir>:
 394:	b8 14 00 00 00       	mov    $0x14,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <chdir>:
 39c:	b8 09 00 00 00       	mov    $0x9,%eax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret    

000003a4 <dup>:
 3a4:	b8 0a 00 00 00       	mov    $0xa,%eax
 3a9:	cd 40                	int    $0x40
 3ab:	c3                   	ret    

000003ac <getpid>:
 3ac:	b8 0b 00 00 00       	mov    $0xb,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret    

000003b4 <sbrk>:
 3b4:	b8 0c 00 00 00       	mov    $0xc,%eax
 3b9:	cd 40                	int    $0x40
 3bb:	c3                   	ret    

000003bc <sleep>:
 3bc:	b8 0d 00 00 00       	mov    $0xd,%eax
 3c1:	cd 40                	int    $0x40
 3c3:	c3                   	ret    

000003c4 <uptime>:
 3c4:	b8 0e 00 00 00       	mov    $0xe,%eax
 3c9:	cd 40                	int    $0x40
 3cb:	c3                   	ret    

000003cc <halt>:
 3cc:	b8 16 00 00 00       	mov    $0x16,%eax
 3d1:	cd 40                	int    $0x40
 3d3:	c3                   	ret    

000003d4 <register_signal_handler>:
 3d4:	b8 17 00 00 00       	mov    $0x17,%eax
 3d9:	cd 40                	int    $0x40
 3db:	c3                   	ret    

000003dc <alarm>:
 3dc:	b8 18 00 00 00       	mov    $0x18,%eax
 3e1:	cd 40                	int    $0x40
 3e3:	c3                   	ret    

000003e4 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3e4:	55                   	push   %ebp
 3e5:	89 e5                	mov    %esp,%ebp
 3e7:	83 ec 28             	sub    $0x28,%esp
 3ea:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ed:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3f0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3f7:	00 
 3f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3fb:	89 44 24 04          	mov    %eax,0x4(%esp)
 3ff:	8b 45 08             	mov    0x8(%ebp),%eax
 402:	89 04 24             	mov    %eax,(%esp)
 405:	e8 42 ff ff ff       	call   34c <write>
}
 40a:	c9                   	leave  
 40b:	c3                   	ret    

0000040c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 40c:	55                   	push   %ebp
 40d:	89 e5                	mov    %esp,%ebp
 40f:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 412:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 419:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 41d:	74 17                	je     436 <printint+0x2a>
 41f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 423:	79 11                	jns    436 <printint+0x2a>
    neg = 1;
 425:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 42c:	8b 45 0c             	mov    0xc(%ebp),%eax
 42f:	f7 d8                	neg    %eax
 431:	89 45 ec             	mov    %eax,-0x14(%ebp)
 434:	eb 06                	jmp    43c <printint+0x30>
  } else {
    x = xx;
 436:	8b 45 0c             	mov    0xc(%ebp),%eax
 439:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 43c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 443:	8b 4d 10             	mov    0x10(%ebp),%ecx
 446:	8b 45 ec             	mov    -0x14(%ebp),%eax
 449:	ba 00 00 00 00       	mov    $0x0,%edx
 44e:	f7 f1                	div    %ecx
 450:	89 d0                	mov    %edx,%eax
 452:	8a 80 88 0b 00 00    	mov    0xb88(%eax),%al
 458:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 45b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 45e:	01 ca                	add    %ecx,%edx
 460:	88 02                	mov    %al,(%edx)
 462:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 465:	8b 55 10             	mov    0x10(%ebp),%edx
 468:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 46b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 46e:	ba 00 00 00 00       	mov    $0x0,%edx
 473:	f7 75 d4             	divl   -0x2c(%ebp)
 476:	89 45 ec             	mov    %eax,-0x14(%ebp)
 479:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 47d:	75 c4                	jne    443 <printint+0x37>
  if(neg)
 47f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 483:	74 2c                	je     4b1 <printint+0xa5>
    buf[i++] = '-';
 485:	8d 55 dc             	lea    -0x24(%ebp),%edx
 488:	8b 45 f4             	mov    -0xc(%ebp),%eax
 48b:	01 d0                	add    %edx,%eax
 48d:	c6 00 2d             	movb   $0x2d,(%eax)
 490:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 493:	eb 1c                	jmp    4b1 <printint+0xa5>
    putc(fd, buf[i]);
 495:	8d 55 dc             	lea    -0x24(%ebp),%edx
 498:	8b 45 f4             	mov    -0xc(%ebp),%eax
 49b:	01 d0                	add    %edx,%eax
 49d:	8a 00                	mov    (%eax),%al
 49f:	0f be c0             	movsbl %al,%eax
 4a2:	89 44 24 04          	mov    %eax,0x4(%esp)
 4a6:	8b 45 08             	mov    0x8(%ebp),%eax
 4a9:	89 04 24             	mov    %eax,(%esp)
 4ac:	e8 33 ff ff ff       	call   3e4 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4b1:	ff 4d f4             	decl   -0xc(%ebp)
 4b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4b8:	79 db                	jns    495 <printint+0x89>
    putc(fd, buf[i]);
}
 4ba:	c9                   	leave  
 4bb:	c3                   	ret    

000004bc <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4bc:	55                   	push   %ebp
 4bd:	89 e5                	mov    %esp,%ebp
 4bf:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4c2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4c9:	8d 45 0c             	lea    0xc(%ebp),%eax
 4cc:	83 c0 04             	add    $0x4,%eax
 4cf:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4d2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4d9:	e9 78 01 00 00       	jmp    656 <printf+0x19a>
    c = fmt[i] & 0xff;
 4de:	8b 55 0c             	mov    0xc(%ebp),%edx
 4e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4e4:	01 d0                	add    %edx,%eax
 4e6:	8a 00                	mov    (%eax),%al
 4e8:	0f be c0             	movsbl %al,%eax
 4eb:	25 ff 00 00 00       	and    $0xff,%eax
 4f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4f3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4f7:	75 2c                	jne    525 <printf+0x69>
      if(c == '%'){
 4f9:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4fd:	75 0c                	jne    50b <printf+0x4f>
        state = '%';
 4ff:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 506:	e9 48 01 00 00       	jmp    653 <printf+0x197>
      } else {
        putc(fd, c);
 50b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 50e:	0f be c0             	movsbl %al,%eax
 511:	89 44 24 04          	mov    %eax,0x4(%esp)
 515:	8b 45 08             	mov    0x8(%ebp),%eax
 518:	89 04 24             	mov    %eax,(%esp)
 51b:	e8 c4 fe ff ff       	call   3e4 <putc>
 520:	e9 2e 01 00 00       	jmp    653 <printf+0x197>
      }
    } else if(state == '%'){
 525:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 529:	0f 85 24 01 00 00    	jne    653 <printf+0x197>
      if(c == 'd'){
 52f:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 533:	75 2d                	jne    562 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 535:	8b 45 e8             	mov    -0x18(%ebp),%eax
 538:	8b 00                	mov    (%eax),%eax
 53a:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 541:	00 
 542:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 549:	00 
 54a:	89 44 24 04          	mov    %eax,0x4(%esp)
 54e:	8b 45 08             	mov    0x8(%ebp),%eax
 551:	89 04 24             	mov    %eax,(%esp)
 554:	e8 b3 fe ff ff       	call   40c <printint>
        ap++;
 559:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 55d:	e9 ea 00 00 00       	jmp    64c <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 562:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 566:	74 06                	je     56e <printf+0xb2>
 568:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 56c:	75 2d                	jne    59b <printf+0xdf>
        printint(fd, *ap, 16, 0);
 56e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 571:	8b 00                	mov    (%eax),%eax
 573:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 57a:	00 
 57b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 582:	00 
 583:	89 44 24 04          	mov    %eax,0x4(%esp)
 587:	8b 45 08             	mov    0x8(%ebp),%eax
 58a:	89 04 24             	mov    %eax,(%esp)
 58d:	e8 7a fe ff ff       	call   40c <printint>
        ap++;
 592:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 596:	e9 b1 00 00 00       	jmp    64c <printf+0x190>
      } else if(c == 's'){
 59b:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 59f:	75 43                	jne    5e4 <printf+0x128>
        s = (char*)*ap;
 5a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5a4:	8b 00                	mov    (%eax),%eax
 5a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5a9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5b1:	75 25                	jne    5d8 <printf+0x11c>
          s = "(null)";
 5b3:	c7 45 f4 e7 08 00 00 	movl   $0x8e7,-0xc(%ebp)
        while(*s != 0){
 5ba:	eb 1c                	jmp    5d8 <printf+0x11c>
          putc(fd, *s);
 5bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5bf:	8a 00                	mov    (%eax),%al
 5c1:	0f be c0             	movsbl %al,%eax
 5c4:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c8:	8b 45 08             	mov    0x8(%ebp),%eax
 5cb:	89 04 24             	mov    %eax,(%esp)
 5ce:	e8 11 fe ff ff       	call   3e4 <putc>
          s++;
 5d3:	ff 45 f4             	incl   -0xc(%ebp)
 5d6:	eb 01                	jmp    5d9 <printf+0x11d>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5d8:	90                   	nop
 5d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5dc:	8a 00                	mov    (%eax),%al
 5de:	84 c0                	test   %al,%al
 5e0:	75 da                	jne    5bc <printf+0x100>
 5e2:	eb 68                	jmp    64c <printf+0x190>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5e4:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5e8:	75 1d                	jne    607 <printf+0x14b>
        putc(fd, *ap);
 5ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ed:	8b 00                	mov    (%eax),%eax
 5ef:	0f be c0             	movsbl %al,%eax
 5f2:	89 44 24 04          	mov    %eax,0x4(%esp)
 5f6:	8b 45 08             	mov    0x8(%ebp),%eax
 5f9:	89 04 24             	mov    %eax,(%esp)
 5fc:	e8 e3 fd ff ff       	call   3e4 <putc>
        ap++;
 601:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 605:	eb 45                	jmp    64c <printf+0x190>
      } else if(c == '%'){
 607:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 60b:	75 17                	jne    624 <printf+0x168>
        putc(fd, c);
 60d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 610:	0f be c0             	movsbl %al,%eax
 613:	89 44 24 04          	mov    %eax,0x4(%esp)
 617:	8b 45 08             	mov    0x8(%ebp),%eax
 61a:	89 04 24             	mov    %eax,(%esp)
 61d:	e8 c2 fd ff ff       	call   3e4 <putc>
 622:	eb 28                	jmp    64c <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 624:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 62b:	00 
 62c:	8b 45 08             	mov    0x8(%ebp),%eax
 62f:	89 04 24             	mov    %eax,(%esp)
 632:	e8 ad fd ff ff       	call   3e4 <putc>
        putc(fd, c);
 637:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 63a:	0f be c0             	movsbl %al,%eax
 63d:	89 44 24 04          	mov    %eax,0x4(%esp)
 641:	8b 45 08             	mov    0x8(%ebp),%eax
 644:	89 04 24             	mov    %eax,(%esp)
 647:	e8 98 fd ff ff       	call   3e4 <putc>
      }
      state = 0;
 64c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 653:	ff 45 f0             	incl   -0x10(%ebp)
 656:	8b 55 0c             	mov    0xc(%ebp),%edx
 659:	8b 45 f0             	mov    -0x10(%ebp),%eax
 65c:	01 d0                	add    %edx,%eax
 65e:	8a 00                	mov    (%eax),%al
 660:	84 c0                	test   %al,%al
 662:	0f 85 76 fe ff ff    	jne    4de <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 668:	c9                   	leave  
 669:	c3                   	ret    
 66a:	66 90                	xchg   %ax,%ax

0000066c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 66c:	55                   	push   %ebp
 66d:	89 e5                	mov    %esp,%ebp
 66f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 672:	8b 45 08             	mov    0x8(%ebp),%eax
 675:	83 e8 08             	sub    $0x8,%eax
 678:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 67b:	a1 a4 0b 00 00       	mov    0xba4,%eax
 680:	89 45 fc             	mov    %eax,-0x4(%ebp)
 683:	eb 24                	jmp    6a9 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 685:	8b 45 fc             	mov    -0x4(%ebp),%eax
 688:	8b 00                	mov    (%eax),%eax
 68a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 68d:	77 12                	ja     6a1 <free+0x35>
 68f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 692:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 695:	77 24                	ja     6bb <free+0x4f>
 697:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69a:	8b 00                	mov    (%eax),%eax
 69c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 69f:	77 1a                	ja     6bb <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a4:	8b 00                	mov    (%eax),%eax
 6a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ac:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6af:	76 d4                	jbe    685 <free+0x19>
 6b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b4:	8b 00                	mov    (%eax),%eax
 6b6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6b9:	76 ca                	jbe    685 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6be:	8b 40 04             	mov    0x4(%eax),%eax
 6c1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6cb:	01 c2                	add    %eax,%edx
 6cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d0:	8b 00                	mov    (%eax),%eax
 6d2:	39 c2                	cmp    %eax,%edx
 6d4:	75 24                	jne    6fa <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d9:	8b 50 04             	mov    0x4(%eax),%edx
 6dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6df:	8b 00                	mov    (%eax),%eax
 6e1:	8b 40 04             	mov    0x4(%eax),%eax
 6e4:	01 c2                	add    %eax,%edx
 6e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e9:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ef:	8b 00                	mov    (%eax),%eax
 6f1:	8b 10                	mov    (%eax),%edx
 6f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f6:	89 10                	mov    %edx,(%eax)
 6f8:	eb 0a                	jmp    704 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fd:	8b 10                	mov    (%eax),%edx
 6ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
 702:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 704:	8b 45 fc             	mov    -0x4(%ebp),%eax
 707:	8b 40 04             	mov    0x4(%eax),%eax
 70a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 711:	8b 45 fc             	mov    -0x4(%ebp),%eax
 714:	01 d0                	add    %edx,%eax
 716:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 719:	75 20                	jne    73b <free+0xcf>
    p->s.size += bp->s.size;
 71b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71e:	8b 50 04             	mov    0x4(%eax),%edx
 721:	8b 45 f8             	mov    -0x8(%ebp),%eax
 724:	8b 40 04             	mov    0x4(%eax),%eax
 727:	01 c2                	add    %eax,%edx
 729:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 72f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 732:	8b 10                	mov    (%eax),%edx
 734:	8b 45 fc             	mov    -0x4(%ebp),%eax
 737:	89 10                	mov    %edx,(%eax)
 739:	eb 08                	jmp    743 <free+0xd7>
  } else
    p->s.ptr = bp;
 73b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 741:	89 10                	mov    %edx,(%eax)
  freep = p;
 743:	8b 45 fc             	mov    -0x4(%ebp),%eax
 746:	a3 a4 0b 00 00       	mov    %eax,0xba4
}
 74b:	c9                   	leave  
 74c:	c3                   	ret    

0000074d <morecore>:

static Header*
morecore(uint nu)
{
 74d:	55                   	push   %ebp
 74e:	89 e5                	mov    %esp,%ebp
 750:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 753:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 75a:	77 07                	ja     763 <morecore+0x16>
    nu = 4096;
 75c:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 763:	8b 45 08             	mov    0x8(%ebp),%eax
 766:	c1 e0 03             	shl    $0x3,%eax
 769:	89 04 24             	mov    %eax,(%esp)
 76c:	e8 43 fc ff ff       	call   3b4 <sbrk>
 771:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 774:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 778:	75 07                	jne    781 <morecore+0x34>
    return 0;
 77a:	b8 00 00 00 00       	mov    $0x0,%eax
 77f:	eb 22                	jmp    7a3 <morecore+0x56>
  hp = (Header*)p;
 781:	8b 45 f4             	mov    -0xc(%ebp),%eax
 784:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 787:	8b 45 f0             	mov    -0x10(%ebp),%eax
 78a:	8b 55 08             	mov    0x8(%ebp),%edx
 78d:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 790:	8b 45 f0             	mov    -0x10(%ebp),%eax
 793:	83 c0 08             	add    $0x8,%eax
 796:	89 04 24             	mov    %eax,(%esp)
 799:	e8 ce fe ff ff       	call   66c <free>
  return freep;
 79e:	a1 a4 0b 00 00       	mov    0xba4,%eax
}
 7a3:	c9                   	leave  
 7a4:	c3                   	ret    

000007a5 <malloc>:

void*
malloc(uint nbytes)
{
 7a5:	55                   	push   %ebp
 7a6:	89 e5                	mov    %esp,%ebp
 7a8:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7ab:	8b 45 08             	mov    0x8(%ebp),%eax
 7ae:	83 c0 07             	add    $0x7,%eax
 7b1:	c1 e8 03             	shr    $0x3,%eax
 7b4:	40                   	inc    %eax
 7b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7b8:	a1 a4 0b 00 00       	mov    0xba4,%eax
 7bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7c0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7c4:	75 23                	jne    7e9 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 7c6:	c7 45 f0 9c 0b 00 00 	movl   $0xb9c,-0x10(%ebp)
 7cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d0:	a3 a4 0b 00 00       	mov    %eax,0xba4
 7d5:	a1 a4 0b 00 00       	mov    0xba4,%eax
 7da:	a3 9c 0b 00 00       	mov    %eax,0xb9c
    base.s.size = 0;
 7df:	c7 05 a0 0b 00 00 00 	movl   $0x0,0xba0
 7e6:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ec:	8b 00                	mov    (%eax),%eax
 7ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f4:	8b 40 04             	mov    0x4(%eax),%eax
 7f7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7fa:	72 4d                	jb     849 <malloc+0xa4>
      if(p->s.size == nunits)
 7fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ff:	8b 40 04             	mov    0x4(%eax),%eax
 802:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 805:	75 0c                	jne    813 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 807:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80a:	8b 10                	mov    (%eax),%edx
 80c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80f:	89 10                	mov    %edx,(%eax)
 811:	eb 26                	jmp    839 <malloc+0x94>
      else {
        p->s.size -= nunits;
 813:	8b 45 f4             	mov    -0xc(%ebp),%eax
 816:	8b 40 04             	mov    0x4(%eax),%eax
 819:	89 c2                	mov    %eax,%edx
 81b:	2b 55 ec             	sub    -0x14(%ebp),%edx
 81e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 821:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 824:	8b 45 f4             	mov    -0xc(%ebp),%eax
 827:	8b 40 04             	mov    0x4(%eax),%eax
 82a:	c1 e0 03             	shl    $0x3,%eax
 82d:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 830:	8b 45 f4             	mov    -0xc(%ebp),%eax
 833:	8b 55 ec             	mov    -0x14(%ebp),%edx
 836:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 839:	8b 45 f0             	mov    -0x10(%ebp),%eax
 83c:	a3 a4 0b 00 00       	mov    %eax,0xba4
      return (void*)(p + 1);
 841:	8b 45 f4             	mov    -0xc(%ebp),%eax
 844:	83 c0 08             	add    $0x8,%eax
 847:	eb 38                	jmp    881 <malloc+0xdc>
    }
    if(p == freep)
 849:	a1 a4 0b 00 00       	mov    0xba4,%eax
 84e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 851:	75 1b                	jne    86e <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 853:	8b 45 ec             	mov    -0x14(%ebp),%eax
 856:	89 04 24             	mov    %eax,(%esp)
 859:	e8 ef fe ff ff       	call   74d <morecore>
 85e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 861:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 865:	75 07                	jne    86e <malloc+0xc9>
        return 0;
 867:	b8 00 00 00 00       	mov    $0x0,%eax
 86c:	eb 13                	jmp    881 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 86e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 871:	89 45 f0             	mov    %eax,-0x10(%ebp)
 874:	8b 45 f4             	mov    -0xc(%ebp),%eax
 877:	8b 00                	mov    (%eax),%eax
 879:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 87c:	e9 70 ff ff ff       	jmp    7f1 <malloc+0x4c>
}
 881:	c9                   	leave  
 882:	c3                   	ret    
