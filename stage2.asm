
_stage2:     file format elf32-i386


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
   6:	c7 44 24 04 80 08 00 	movl   $0x880,0x4(%esp)
   d:	00 
   e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  15:	e8 9e 04 00 00       	call   4b8 <printf>
}
  1a:	c9                   	leave  
  1b:	c3                   	ret    

0000001c <handle_signal>:

void handle_signal(siginfo_t info)
{
  1c:	55                   	push   %ebp
  1d:	89 e5                	mov    %esp,%ebp
    __asm__ ("movl $0x0,%ecx\n\t");
  1f:	b9 00 00 00 00       	mov    $0x0,%ecx
    flag = 1;
  24:	c7 05 bc 0b 00 00 01 	movl   $0x1,0xbbc
  2b:	00 00 00 
} 
  2e:	5d                   	pop    %ebp
  2f:	c3                   	ret    

00000030 <main>:

int main(void)
{
  30:	55                   	push   %ebp
  31:	89 e5                	mov    %esp,%ebp
  33:	83 e4 f0             	and    $0xfffffff0,%esp
  36:	83 ec 10             	sub    $0x10,%esp
    register int ecx asm ("%ecx");
    
    signal(SIGALRM, handle_signal);
  39:	c7 44 24 04 1c 00 00 	movl   $0x1c,0x4(%esp)
  40:	00 
  41:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  48:	e8 ab 02 00 00       	call   2f8 <signal>

    ecx = 5;
  4d:	b9 05 00 00 00       	mov    $0x5,%ecx

    alarm(1);
  52:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  59:	e8 7a 03 00 00       	call   3d8 <alarm>

    while(!flag);
  5e:	90                   	nop
  5f:	a1 bc 0b 00 00       	mov    0xbbc,%eax
  64:	85 c0                	test   %eax,%eax
  66:	74 f7                	je     5f <main+0x2f>

    if (ecx == 5)
  68:	89 c8                	mov    %ecx,%eax
  6a:	83 f8 05             	cmp    $0x5,%eax
  6d:	75 1c                	jne    8b <main+0x5b>
        printf(1, "TEST PASSED: Final value of ecx is %d...\n", ecx);
  6f:	89 c8                	mov    %ecx,%eax
  71:	89 44 24 08          	mov    %eax,0x8(%esp)
  75:	c7 44 24 04 ac 08 00 	movl   $0x8ac,0x4(%esp)
  7c:	00 
  7d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  84:	e8 2f 04 00 00       	call   4b8 <printf>
  89:	eb 1a                	jmp    a5 <main+0x75>
    else
        printf(1, "TEST FAILED: Final value of ecx is %d...\n", ecx);
  8b:	89 c8                	mov    %ecx,%eax
  8d:	89 44 24 08          	mov    %eax,0x8(%esp)
  91:	c7 44 24 04 d8 08 00 	movl   $0x8d8,0x4(%esp)
  98:	00 
  99:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  a0:	e8 13 04 00 00       	call   4b8 <printf>

    exit();
  a5:	e8 7e 02 00 00       	call   328 <exit>
  aa:	66 90                	xchg   %ax,%ax

000000ac <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  ac:	55                   	push   %ebp
  ad:	89 e5                	mov    %esp,%ebp
  af:	57                   	push   %edi
  b0:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  b4:	8b 55 10             	mov    0x10(%ebp),%edx
  b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  ba:	89 cb                	mov    %ecx,%ebx
  bc:	89 df                	mov    %ebx,%edi
  be:	89 d1                	mov    %edx,%ecx
  c0:	fc                   	cld    
  c1:	f3 aa                	rep stos %al,%es:(%edi)
  c3:	89 ca                	mov    %ecx,%edx
  c5:	89 fb                	mov    %edi,%ebx
  c7:	89 5d 08             	mov    %ebx,0x8(%ebp)
  ca:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  cd:	5b                   	pop    %ebx
  ce:	5f                   	pop    %edi
  cf:	5d                   	pop    %ebp
  d0:	c3                   	ret    

000000d1 <strcpy>:
#include "x86.h"
#include "signal.h"

char*
strcpy(char *s, char *t)
{
  d1:	55                   	push   %ebp
  d2:	89 e5                	mov    %esp,%ebp
  d4:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  d7:	8b 45 08             	mov    0x8(%ebp),%eax
  da:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  dd:	90                   	nop
  de:	8b 45 0c             	mov    0xc(%ebp),%eax
  e1:	8a 10                	mov    (%eax),%dl
  e3:	8b 45 08             	mov    0x8(%ebp),%eax
  e6:	88 10                	mov    %dl,(%eax)
  e8:	8b 45 08             	mov    0x8(%ebp),%eax
  eb:	8a 00                	mov    (%eax),%al
  ed:	84 c0                	test   %al,%al
  ef:	0f 95 c0             	setne  %al
  f2:	ff 45 08             	incl   0x8(%ebp)
  f5:	ff 45 0c             	incl   0xc(%ebp)
  f8:	84 c0                	test   %al,%al
  fa:	75 e2                	jne    de <strcpy+0xd>
    ;
  return os;
  fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  ff:	c9                   	leave  
 100:	c3                   	ret    

00000101 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 101:	55                   	push   %ebp
 102:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 104:	eb 06                	jmp    10c <strcmp+0xb>
    p++, q++;
 106:	ff 45 08             	incl   0x8(%ebp)
 109:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 10c:	8b 45 08             	mov    0x8(%ebp),%eax
 10f:	8a 00                	mov    (%eax),%al
 111:	84 c0                	test   %al,%al
 113:	74 0e                	je     123 <strcmp+0x22>
 115:	8b 45 08             	mov    0x8(%ebp),%eax
 118:	8a 10                	mov    (%eax),%dl
 11a:	8b 45 0c             	mov    0xc(%ebp),%eax
 11d:	8a 00                	mov    (%eax),%al
 11f:	38 c2                	cmp    %al,%dl
 121:	74 e3                	je     106 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 123:	8b 45 08             	mov    0x8(%ebp),%eax
 126:	8a 00                	mov    (%eax),%al
 128:	0f b6 d0             	movzbl %al,%edx
 12b:	8b 45 0c             	mov    0xc(%ebp),%eax
 12e:	8a 00                	mov    (%eax),%al
 130:	0f b6 c0             	movzbl %al,%eax
 133:	89 d1                	mov    %edx,%ecx
 135:	29 c1                	sub    %eax,%ecx
 137:	89 c8                	mov    %ecx,%eax
}
 139:	5d                   	pop    %ebp
 13a:	c3                   	ret    

0000013b <strlen>:

uint
strlen(char *s)
{
 13b:	55                   	push   %ebp
 13c:	89 e5                	mov    %esp,%ebp
 13e:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 141:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 148:	eb 03                	jmp    14d <strlen+0x12>
 14a:	ff 45 fc             	incl   -0x4(%ebp)
 14d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 150:	8b 45 08             	mov    0x8(%ebp),%eax
 153:	01 d0                	add    %edx,%eax
 155:	8a 00                	mov    (%eax),%al
 157:	84 c0                	test   %al,%al
 159:	75 ef                	jne    14a <strlen+0xf>
    ;
  return n;
 15b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 15e:	c9                   	leave  
 15f:	c3                   	ret    

00000160 <memset>:

void*
memset(void *dst, int c, uint n)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 166:	8b 45 10             	mov    0x10(%ebp),%eax
 169:	89 44 24 08          	mov    %eax,0x8(%esp)
 16d:	8b 45 0c             	mov    0xc(%ebp),%eax
 170:	89 44 24 04          	mov    %eax,0x4(%esp)
 174:	8b 45 08             	mov    0x8(%ebp),%eax
 177:	89 04 24             	mov    %eax,(%esp)
 17a:	e8 2d ff ff ff       	call   ac <stosb>
  return dst;
 17f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 182:	c9                   	leave  
 183:	c3                   	ret    

00000184 <strchr>:

char*
strchr(const char *s, char c)
{
 184:	55                   	push   %ebp
 185:	89 e5                	mov    %esp,%ebp
 187:	83 ec 04             	sub    $0x4,%esp
 18a:	8b 45 0c             	mov    0xc(%ebp),%eax
 18d:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 190:	eb 12                	jmp    1a4 <strchr+0x20>
    if(*s == c)
 192:	8b 45 08             	mov    0x8(%ebp),%eax
 195:	8a 00                	mov    (%eax),%al
 197:	3a 45 fc             	cmp    -0x4(%ebp),%al
 19a:	75 05                	jne    1a1 <strchr+0x1d>
      return (char*)s;
 19c:	8b 45 08             	mov    0x8(%ebp),%eax
 19f:	eb 11                	jmp    1b2 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1a1:	ff 45 08             	incl   0x8(%ebp)
 1a4:	8b 45 08             	mov    0x8(%ebp),%eax
 1a7:	8a 00                	mov    (%eax),%al
 1a9:	84 c0                	test   %al,%al
 1ab:	75 e5                	jne    192 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1b2:	c9                   	leave  
 1b3:	c3                   	ret    

000001b4 <gets>:

char*
gets(char *buf, int max)
{
 1b4:	55                   	push   %ebp
 1b5:	89 e5                	mov    %esp,%ebp
 1b7:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1c1:	eb 42                	jmp    205 <gets+0x51>
    cc = read(0, &c, 1);
 1c3:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1ca:	00 
 1cb:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1ce:	89 44 24 04          	mov    %eax,0x4(%esp)
 1d2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1d9:	e8 62 01 00 00       	call   340 <read>
 1de:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1e1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1e5:	7e 29                	jle    210 <gets+0x5c>
      break;
    buf[i++] = c;
 1e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1ea:	8b 45 08             	mov    0x8(%ebp),%eax
 1ed:	01 c2                	add    %eax,%edx
 1ef:	8a 45 ef             	mov    -0x11(%ebp),%al
 1f2:	88 02                	mov    %al,(%edx)
 1f4:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 1f7:	8a 45 ef             	mov    -0x11(%ebp),%al
 1fa:	3c 0a                	cmp    $0xa,%al
 1fc:	74 13                	je     211 <gets+0x5d>
 1fe:	8a 45 ef             	mov    -0x11(%ebp),%al
 201:	3c 0d                	cmp    $0xd,%al
 203:	74 0c                	je     211 <gets+0x5d>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 205:	8b 45 f4             	mov    -0xc(%ebp),%eax
 208:	40                   	inc    %eax
 209:	3b 45 0c             	cmp    0xc(%ebp),%eax
 20c:	7c b5                	jl     1c3 <gets+0xf>
 20e:	eb 01                	jmp    211 <gets+0x5d>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 210:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 211:	8b 55 f4             	mov    -0xc(%ebp),%edx
 214:	8b 45 08             	mov    0x8(%ebp),%eax
 217:	01 d0                	add    %edx,%eax
 219:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 21c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 21f:	c9                   	leave  
 220:	c3                   	ret    

00000221 <stat>:

int
stat(char *n, struct stat *st)
{
 221:	55                   	push   %ebp
 222:	89 e5                	mov    %esp,%ebp
 224:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 227:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 22e:	00 
 22f:	8b 45 08             	mov    0x8(%ebp),%eax
 232:	89 04 24             	mov    %eax,(%esp)
 235:	e8 2e 01 00 00       	call   368 <open>
 23a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 23d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 241:	79 07                	jns    24a <stat+0x29>
    return -1;
 243:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 248:	eb 23                	jmp    26d <stat+0x4c>
  r = fstat(fd, st);
 24a:	8b 45 0c             	mov    0xc(%ebp),%eax
 24d:	89 44 24 04          	mov    %eax,0x4(%esp)
 251:	8b 45 f4             	mov    -0xc(%ebp),%eax
 254:	89 04 24             	mov    %eax,(%esp)
 257:	e8 24 01 00 00       	call   380 <fstat>
 25c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 25f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 262:	89 04 24             	mov    %eax,(%esp)
 265:	e8 e6 00 00 00       	call   350 <close>
  return r;
 26a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 26d:	c9                   	leave  
 26e:	c3                   	ret    

0000026f <atoi>:

int
atoi(const char *s)
{
 26f:	55                   	push   %ebp
 270:	89 e5                	mov    %esp,%ebp
 272:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 275:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 27c:	eb 21                	jmp    29f <atoi+0x30>
    n = n*10 + *s++ - '0';
 27e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 281:	89 d0                	mov    %edx,%eax
 283:	c1 e0 02             	shl    $0x2,%eax
 286:	01 d0                	add    %edx,%eax
 288:	d1 e0                	shl    %eax
 28a:	89 c2                	mov    %eax,%edx
 28c:	8b 45 08             	mov    0x8(%ebp),%eax
 28f:	8a 00                	mov    (%eax),%al
 291:	0f be c0             	movsbl %al,%eax
 294:	01 d0                	add    %edx,%eax
 296:	83 e8 30             	sub    $0x30,%eax
 299:	89 45 fc             	mov    %eax,-0x4(%ebp)
 29c:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 29f:	8b 45 08             	mov    0x8(%ebp),%eax
 2a2:	8a 00                	mov    (%eax),%al
 2a4:	3c 2f                	cmp    $0x2f,%al
 2a6:	7e 09                	jle    2b1 <atoi+0x42>
 2a8:	8b 45 08             	mov    0x8(%ebp),%eax
 2ab:	8a 00                	mov    (%eax),%al
 2ad:	3c 39                	cmp    $0x39,%al
 2af:	7e cd                	jle    27e <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2b4:	c9                   	leave  
 2b5:	c3                   	ret    

000002b6 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2b6:	55                   	push   %ebp
 2b7:	89 e5                	mov    %esp,%ebp
 2b9:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2bc:	8b 45 08             	mov    0x8(%ebp),%eax
 2bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2c2:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2c8:	eb 10                	jmp    2da <memmove+0x24>
    *dst++ = *src++;
 2ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2cd:	8a 10                	mov    (%eax),%dl
 2cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2d2:	88 10                	mov    %dl,(%eax)
 2d4:	ff 45 fc             	incl   -0x4(%ebp)
 2d7:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2da:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 2de:	0f 9f c0             	setg   %al
 2e1:	ff 4d 10             	decl   0x10(%ebp)
 2e4:	84 c0                	test   %al,%al
 2e6:	75 e2                	jne    2ca <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2e8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2eb:	c9                   	leave  
 2ec:	c3                   	ret    

000002ed <trampoline>:
 2ed:	5a                   	pop    %edx
 2ee:	59                   	pop    %ecx
 2ef:	58                   	pop    %eax
 2f0:	03 25 04 00 00 00    	add    0x4,%esp
 2f6:	c9                   	leave  
 2f7:	c3                   	ret    

000002f8 <signal>:
	"addl 4, %esp\n\t"
	"leave\n\t"
	"ret\n\t"
);
int signal(int signum, sighandler_t handler) 
{
 2f8:	55                   	push   %ebp
 2f9:	89 e5                	mov    %esp,%ebp
 2fb:	83 ec 18             	sub    $0x18,%esp
	register_signal_handler(signum, handler, trampoline);
 2fe:	c7 44 24 08 ed 02 00 	movl   $0x2ed,0x8(%esp)
 305:	00 
 306:	8b 45 0c             	mov    0xc(%ebp),%eax
 309:	89 44 24 04          	mov    %eax,0x4(%esp)
 30d:	8b 45 08             	mov    0x8(%ebp),%eax
 310:	89 04 24             	mov    %eax,(%esp)
 313:	e8 b8 00 00 00       	call   3d0 <register_signal_handler>
	return 0;
 318:	b8 00 00 00 00       	mov    $0x0,%eax
}
 31d:	c9                   	leave  
 31e:	c3                   	ret    
 31f:	90                   	nop

00000320 <fork>:
 320:	b8 01 00 00 00       	mov    $0x1,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <exit>:
 328:	b8 02 00 00 00       	mov    $0x2,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <wait>:
 330:	b8 03 00 00 00       	mov    $0x3,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <pipe>:
 338:	b8 04 00 00 00       	mov    $0x4,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <read>:
 340:	b8 05 00 00 00       	mov    $0x5,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <write>:
 348:	b8 10 00 00 00       	mov    $0x10,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <close>:
 350:	b8 15 00 00 00       	mov    $0x15,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <kill>:
 358:	b8 06 00 00 00       	mov    $0x6,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <exec>:
 360:	b8 07 00 00 00       	mov    $0x7,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <open>:
 368:	b8 0f 00 00 00       	mov    $0xf,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <mknod>:
 370:	b8 11 00 00 00       	mov    $0x11,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <unlink>:
 378:	b8 12 00 00 00       	mov    $0x12,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <fstat>:
 380:	b8 08 00 00 00       	mov    $0x8,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <link>:
 388:	b8 13 00 00 00       	mov    $0x13,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <mkdir>:
 390:	b8 14 00 00 00       	mov    $0x14,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <chdir>:
 398:	b8 09 00 00 00       	mov    $0x9,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <dup>:
 3a0:	b8 0a 00 00 00       	mov    $0xa,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <getpid>:
 3a8:	b8 0b 00 00 00       	mov    $0xb,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <sbrk>:
 3b0:	b8 0c 00 00 00       	mov    $0xc,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <sleep>:
 3b8:	b8 0d 00 00 00       	mov    $0xd,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <uptime>:
 3c0:	b8 0e 00 00 00       	mov    $0xe,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <halt>:
 3c8:	b8 16 00 00 00       	mov    $0x16,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <register_signal_handler>:
 3d0:	b8 17 00 00 00       	mov    $0x17,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <alarm>:
 3d8:	b8 18 00 00 00       	mov    $0x18,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3e0:	55                   	push   %ebp
 3e1:	89 e5                	mov    %esp,%ebp
 3e3:	83 ec 28             	sub    $0x28,%esp
 3e6:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e9:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3ec:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3f3:	00 
 3f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3f7:	89 44 24 04          	mov    %eax,0x4(%esp)
 3fb:	8b 45 08             	mov    0x8(%ebp),%eax
 3fe:	89 04 24             	mov    %eax,(%esp)
 401:	e8 42 ff ff ff       	call   348 <write>
}
 406:	c9                   	leave  
 407:	c3                   	ret    

00000408 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 408:	55                   	push   %ebp
 409:	89 e5                	mov    %esp,%ebp
 40b:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 40e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 415:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 419:	74 17                	je     432 <printint+0x2a>
 41b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 41f:	79 11                	jns    432 <printint+0x2a>
    neg = 1;
 421:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 428:	8b 45 0c             	mov    0xc(%ebp),%eax
 42b:	f7 d8                	neg    %eax
 42d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 430:	eb 06                	jmp    438 <printint+0x30>
  } else {
    x = xx;
 432:	8b 45 0c             	mov    0xc(%ebp),%eax
 435:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 438:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 43f:	8b 4d 10             	mov    0x10(%ebp),%ecx
 442:	8b 45 ec             	mov    -0x14(%ebp),%eax
 445:	ba 00 00 00 00       	mov    $0x0,%edx
 44a:	f7 f1                	div    %ecx
 44c:	89 d0                	mov    %edx,%eax
 44e:	8a 80 a8 0b 00 00    	mov    0xba8(%eax),%al
 454:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 457:	8b 55 f4             	mov    -0xc(%ebp),%edx
 45a:	01 ca                	add    %ecx,%edx
 45c:	88 02                	mov    %al,(%edx)
 45e:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 461:	8b 55 10             	mov    0x10(%ebp),%edx
 464:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 467:	8b 45 ec             	mov    -0x14(%ebp),%eax
 46a:	ba 00 00 00 00       	mov    $0x0,%edx
 46f:	f7 75 d4             	divl   -0x2c(%ebp)
 472:	89 45 ec             	mov    %eax,-0x14(%ebp)
 475:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 479:	75 c4                	jne    43f <printint+0x37>
  if(neg)
 47b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 47f:	74 2c                	je     4ad <printint+0xa5>
    buf[i++] = '-';
 481:	8d 55 dc             	lea    -0x24(%ebp),%edx
 484:	8b 45 f4             	mov    -0xc(%ebp),%eax
 487:	01 d0                	add    %edx,%eax
 489:	c6 00 2d             	movb   $0x2d,(%eax)
 48c:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 48f:	eb 1c                	jmp    4ad <printint+0xa5>
    putc(fd, buf[i]);
 491:	8d 55 dc             	lea    -0x24(%ebp),%edx
 494:	8b 45 f4             	mov    -0xc(%ebp),%eax
 497:	01 d0                	add    %edx,%eax
 499:	8a 00                	mov    (%eax),%al
 49b:	0f be c0             	movsbl %al,%eax
 49e:	89 44 24 04          	mov    %eax,0x4(%esp)
 4a2:	8b 45 08             	mov    0x8(%ebp),%eax
 4a5:	89 04 24             	mov    %eax,(%esp)
 4a8:	e8 33 ff ff ff       	call   3e0 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4ad:	ff 4d f4             	decl   -0xc(%ebp)
 4b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4b4:	79 db                	jns    491 <printint+0x89>
    putc(fd, buf[i]);
}
 4b6:	c9                   	leave  
 4b7:	c3                   	ret    

000004b8 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4b8:	55                   	push   %ebp
 4b9:	89 e5                	mov    %esp,%ebp
 4bb:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4be:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4c5:	8d 45 0c             	lea    0xc(%ebp),%eax
 4c8:	83 c0 04             	add    $0x4,%eax
 4cb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4ce:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4d5:	e9 78 01 00 00       	jmp    652 <printf+0x19a>
    c = fmt[i] & 0xff;
 4da:	8b 55 0c             	mov    0xc(%ebp),%edx
 4dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4e0:	01 d0                	add    %edx,%eax
 4e2:	8a 00                	mov    (%eax),%al
 4e4:	0f be c0             	movsbl %al,%eax
 4e7:	25 ff 00 00 00       	and    $0xff,%eax
 4ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4ef:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4f3:	75 2c                	jne    521 <printf+0x69>
      if(c == '%'){
 4f5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4f9:	75 0c                	jne    507 <printf+0x4f>
        state = '%';
 4fb:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 502:	e9 48 01 00 00       	jmp    64f <printf+0x197>
      } else {
        putc(fd, c);
 507:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 50a:	0f be c0             	movsbl %al,%eax
 50d:	89 44 24 04          	mov    %eax,0x4(%esp)
 511:	8b 45 08             	mov    0x8(%ebp),%eax
 514:	89 04 24             	mov    %eax,(%esp)
 517:	e8 c4 fe ff ff       	call   3e0 <putc>
 51c:	e9 2e 01 00 00       	jmp    64f <printf+0x197>
      }
    } else if(state == '%'){
 521:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 525:	0f 85 24 01 00 00    	jne    64f <printf+0x197>
      if(c == 'd'){
 52b:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 52f:	75 2d                	jne    55e <printf+0xa6>
        printint(fd, *ap, 10, 1);
 531:	8b 45 e8             	mov    -0x18(%ebp),%eax
 534:	8b 00                	mov    (%eax),%eax
 536:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 53d:	00 
 53e:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 545:	00 
 546:	89 44 24 04          	mov    %eax,0x4(%esp)
 54a:	8b 45 08             	mov    0x8(%ebp),%eax
 54d:	89 04 24             	mov    %eax,(%esp)
 550:	e8 b3 fe ff ff       	call   408 <printint>
        ap++;
 555:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 559:	e9 ea 00 00 00       	jmp    648 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 55e:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 562:	74 06                	je     56a <printf+0xb2>
 564:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 568:	75 2d                	jne    597 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 56a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 56d:	8b 00                	mov    (%eax),%eax
 56f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 576:	00 
 577:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 57e:	00 
 57f:	89 44 24 04          	mov    %eax,0x4(%esp)
 583:	8b 45 08             	mov    0x8(%ebp),%eax
 586:	89 04 24             	mov    %eax,(%esp)
 589:	e8 7a fe ff ff       	call   408 <printint>
        ap++;
 58e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 592:	e9 b1 00 00 00       	jmp    648 <printf+0x190>
      } else if(c == 's'){
 597:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 59b:	75 43                	jne    5e0 <printf+0x128>
        s = (char*)*ap;
 59d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5a0:	8b 00                	mov    (%eax),%eax
 5a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5a5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5ad:	75 25                	jne    5d4 <printf+0x11c>
          s = "(null)";
 5af:	c7 45 f4 02 09 00 00 	movl   $0x902,-0xc(%ebp)
        while(*s != 0){
 5b6:	eb 1c                	jmp    5d4 <printf+0x11c>
          putc(fd, *s);
 5b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5bb:	8a 00                	mov    (%eax),%al
 5bd:	0f be c0             	movsbl %al,%eax
 5c0:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c4:	8b 45 08             	mov    0x8(%ebp),%eax
 5c7:	89 04 24             	mov    %eax,(%esp)
 5ca:	e8 11 fe ff ff       	call   3e0 <putc>
          s++;
 5cf:	ff 45 f4             	incl   -0xc(%ebp)
 5d2:	eb 01                	jmp    5d5 <printf+0x11d>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5d4:	90                   	nop
 5d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5d8:	8a 00                	mov    (%eax),%al
 5da:	84 c0                	test   %al,%al
 5dc:	75 da                	jne    5b8 <printf+0x100>
 5de:	eb 68                	jmp    648 <printf+0x190>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5e0:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5e4:	75 1d                	jne    603 <printf+0x14b>
        putc(fd, *ap);
 5e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e9:	8b 00                	mov    (%eax),%eax
 5eb:	0f be c0             	movsbl %al,%eax
 5ee:	89 44 24 04          	mov    %eax,0x4(%esp)
 5f2:	8b 45 08             	mov    0x8(%ebp),%eax
 5f5:	89 04 24             	mov    %eax,(%esp)
 5f8:	e8 e3 fd ff ff       	call   3e0 <putc>
        ap++;
 5fd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 601:	eb 45                	jmp    648 <printf+0x190>
      } else if(c == '%'){
 603:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 607:	75 17                	jne    620 <printf+0x168>
        putc(fd, c);
 609:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 60c:	0f be c0             	movsbl %al,%eax
 60f:	89 44 24 04          	mov    %eax,0x4(%esp)
 613:	8b 45 08             	mov    0x8(%ebp),%eax
 616:	89 04 24             	mov    %eax,(%esp)
 619:	e8 c2 fd ff ff       	call   3e0 <putc>
 61e:	eb 28                	jmp    648 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 620:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 627:	00 
 628:	8b 45 08             	mov    0x8(%ebp),%eax
 62b:	89 04 24             	mov    %eax,(%esp)
 62e:	e8 ad fd ff ff       	call   3e0 <putc>
        putc(fd, c);
 633:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 636:	0f be c0             	movsbl %al,%eax
 639:	89 44 24 04          	mov    %eax,0x4(%esp)
 63d:	8b 45 08             	mov    0x8(%ebp),%eax
 640:	89 04 24             	mov    %eax,(%esp)
 643:	e8 98 fd ff ff       	call   3e0 <putc>
      }
      state = 0;
 648:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 64f:	ff 45 f0             	incl   -0x10(%ebp)
 652:	8b 55 0c             	mov    0xc(%ebp),%edx
 655:	8b 45 f0             	mov    -0x10(%ebp),%eax
 658:	01 d0                	add    %edx,%eax
 65a:	8a 00                	mov    (%eax),%al
 65c:	84 c0                	test   %al,%al
 65e:	0f 85 76 fe ff ff    	jne    4da <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 664:	c9                   	leave  
 665:	c3                   	ret    
 666:	66 90                	xchg   %ax,%ax

00000668 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 668:	55                   	push   %ebp
 669:	89 e5                	mov    %esp,%ebp
 66b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 66e:	8b 45 08             	mov    0x8(%ebp),%eax
 671:	83 e8 08             	sub    $0x8,%eax
 674:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 677:	a1 c8 0b 00 00       	mov    0xbc8,%eax
 67c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 67f:	eb 24                	jmp    6a5 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 681:	8b 45 fc             	mov    -0x4(%ebp),%eax
 684:	8b 00                	mov    (%eax),%eax
 686:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 689:	77 12                	ja     69d <free+0x35>
 68b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 691:	77 24                	ja     6b7 <free+0x4f>
 693:	8b 45 fc             	mov    -0x4(%ebp),%eax
 696:	8b 00                	mov    (%eax),%eax
 698:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 69b:	77 1a                	ja     6b7 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 69d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a0:	8b 00                	mov    (%eax),%eax
 6a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6ab:	76 d4                	jbe    681 <free+0x19>
 6ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b0:	8b 00                	mov    (%eax),%eax
 6b2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6b5:	76 ca                	jbe    681 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ba:	8b 40 04             	mov    0x4(%eax),%eax
 6bd:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c7:	01 c2                	add    %eax,%edx
 6c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cc:	8b 00                	mov    (%eax),%eax
 6ce:	39 c2                	cmp    %eax,%edx
 6d0:	75 24                	jne    6f6 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d5:	8b 50 04             	mov    0x4(%eax),%edx
 6d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6db:	8b 00                	mov    (%eax),%eax
 6dd:	8b 40 04             	mov    0x4(%eax),%eax
 6e0:	01 c2                	add    %eax,%edx
 6e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e5:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6eb:	8b 00                	mov    (%eax),%eax
 6ed:	8b 10                	mov    (%eax),%edx
 6ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f2:	89 10                	mov    %edx,(%eax)
 6f4:	eb 0a                	jmp    700 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f9:	8b 10                	mov    (%eax),%edx
 6fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fe:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 700:	8b 45 fc             	mov    -0x4(%ebp),%eax
 703:	8b 40 04             	mov    0x4(%eax),%eax
 706:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 70d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 710:	01 d0                	add    %edx,%eax
 712:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 715:	75 20                	jne    737 <free+0xcf>
    p->s.size += bp->s.size;
 717:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71a:	8b 50 04             	mov    0x4(%eax),%edx
 71d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 720:	8b 40 04             	mov    0x4(%eax),%eax
 723:	01 c2                	add    %eax,%edx
 725:	8b 45 fc             	mov    -0x4(%ebp),%eax
 728:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 72b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72e:	8b 10                	mov    (%eax),%edx
 730:	8b 45 fc             	mov    -0x4(%ebp),%eax
 733:	89 10                	mov    %edx,(%eax)
 735:	eb 08                	jmp    73f <free+0xd7>
  } else
    p->s.ptr = bp;
 737:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 73d:	89 10                	mov    %edx,(%eax)
  freep = p;
 73f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 742:	a3 c8 0b 00 00       	mov    %eax,0xbc8
}
 747:	c9                   	leave  
 748:	c3                   	ret    

00000749 <morecore>:

static Header*
morecore(uint nu)
{
 749:	55                   	push   %ebp
 74a:	89 e5                	mov    %esp,%ebp
 74c:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 74f:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 756:	77 07                	ja     75f <morecore+0x16>
    nu = 4096;
 758:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 75f:	8b 45 08             	mov    0x8(%ebp),%eax
 762:	c1 e0 03             	shl    $0x3,%eax
 765:	89 04 24             	mov    %eax,(%esp)
 768:	e8 43 fc ff ff       	call   3b0 <sbrk>
 76d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 770:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 774:	75 07                	jne    77d <morecore+0x34>
    return 0;
 776:	b8 00 00 00 00       	mov    $0x0,%eax
 77b:	eb 22                	jmp    79f <morecore+0x56>
  hp = (Header*)p;
 77d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 780:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 783:	8b 45 f0             	mov    -0x10(%ebp),%eax
 786:	8b 55 08             	mov    0x8(%ebp),%edx
 789:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 78c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 78f:	83 c0 08             	add    $0x8,%eax
 792:	89 04 24             	mov    %eax,(%esp)
 795:	e8 ce fe ff ff       	call   668 <free>
  return freep;
 79a:	a1 c8 0b 00 00       	mov    0xbc8,%eax
}
 79f:	c9                   	leave  
 7a0:	c3                   	ret    

000007a1 <malloc>:

void*
malloc(uint nbytes)
{
 7a1:	55                   	push   %ebp
 7a2:	89 e5                	mov    %esp,%ebp
 7a4:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7a7:	8b 45 08             	mov    0x8(%ebp),%eax
 7aa:	83 c0 07             	add    $0x7,%eax
 7ad:	c1 e8 03             	shr    $0x3,%eax
 7b0:	40                   	inc    %eax
 7b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7b4:	a1 c8 0b 00 00       	mov    0xbc8,%eax
 7b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7bc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7c0:	75 23                	jne    7e5 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 7c2:	c7 45 f0 c0 0b 00 00 	movl   $0xbc0,-0x10(%ebp)
 7c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7cc:	a3 c8 0b 00 00       	mov    %eax,0xbc8
 7d1:	a1 c8 0b 00 00       	mov    0xbc8,%eax
 7d6:	a3 c0 0b 00 00       	mov    %eax,0xbc0
    base.s.size = 0;
 7db:	c7 05 c4 0b 00 00 00 	movl   $0x0,0xbc4
 7e2:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e8:	8b 00                	mov    (%eax),%eax
 7ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f0:	8b 40 04             	mov    0x4(%eax),%eax
 7f3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7f6:	72 4d                	jb     845 <malloc+0xa4>
      if(p->s.size == nunits)
 7f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fb:	8b 40 04             	mov    0x4(%eax),%eax
 7fe:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 801:	75 0c                	jne    80f <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 803:	8b 45 f4             	mov    -0xc(%ebp),%eax
 806:	8b 10                	mov    (%eax),%edx
 808:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80b:	89 10                	mov    %edx,(%eax)
 80d:	eb 26                	jmp    835 <malloc+0x94>
      else {
        p->s.size -= nunits;
 80f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 812:	8b 40 04             	mov    0x4(%eax),%eax
 815:	89 c2                	mov    %eax,%edx
 817:	2b 55 ec             	sub    -0x14(%ebp),%edx
 81a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 820:	8b 45 f4             	mov    -0xc(%ebp),%eax
 823:	8b 40 04             	mov    0x4(%eax),%eax
 826:	c1 e0 03             	shl    $0x3,%eax
 829:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 82c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82f:	8b 55 ec             	mov    -0x14(%ebp),%edx
 832:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 835:	8b 45 f0             	mov    -0x10(%ebp),%eax
 838:	a3 c8 0b 00 00       	mov    %eax,0xbc8
      return (void*)(p + 1);
 83d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 840:	83 c0 08             	add    $0x8,%eax
 843:	eb 38                	jmp    87d <malloc+0xdc>
    }
    if(p == freep)
 845:	a1 c8 0b 00 00       	mov    0xbc8,%eax
 84a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 84d:	75 1b                	jne    86a <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 84f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 852:	89 04 24             	mov    %eax,(%esp)
 855:	e8 ef fe ff ff       	call   749 <morecore>
 85a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 85d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 861:	75 07                	jne    86a <malloc+0xc9>
        return 0;
 863:	b8 00 00 00 00       	mov    $0x0,%eax
 868:	eb 13                	jmp    87d <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 86a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 870:	8b 45 f4             	mov    -0xc(%ebp),%eax
 873:	8b 00                	mov    (%eax),%eax
 875:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 878:	e9 70 ff ff ff       	jmp    7ed <malloc+0x4c>
}
 87d:	c9                   	leave  
 87e:	c3                   	ret    
