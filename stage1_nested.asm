
_stage1_nested:     file format elf32-i386


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
   6:	c7 44 24 04 e4 08 00 	movl   $0x8e4,0x4(%esp)
   d:	00 
   e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  15:	e8 02 05 00 00       	call   51c <printf>
}
  1a:	c9                   	leave  
  1b:	c3                   	ret    

0000001c <handle_fpe>:

void handle_fpe(siginfo_t info)
{
  1c:	55                   	push   %ebp
  1d:	89 e5                	mov    %esp,%ebp
  1f:	83 ec 28             	sub    $0x28,%esp
	int i;

	printf(1, "Caught signal %d...\n", info.signum);
  22:	8b 45 08             	mov    0x8(%ebp),%eax
  25:	89 44 24 08          	mov    %eax,0x8(%esp)
  29:	c7 44 24 04 0d 09 00 	movl   $0x90d,0x4(%esp)
  30:	00 
  31:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  38:	e8 df 04 00 00       	call   51c <printf>

	for (i=0; i<10000000; i++) {
  3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  44:	eb 03                	jmp    49 <handle_fpe+0x2d>
  46:	ff 45 f4             	incl   -0xc(%ebp)
  49:	81 7d f4 7f 96 98 00 	cmpl   $0x98967f,-0xc(%ebp)
  50:	7e f4                	jle    46 <handle_fpe+0x2a>
		continue;
	}
}
  52:	c9                   	leave  
  53:	c3                   	ret    

00000054 <handle_alarm>:

void handle_alarm(siginfo_t info)
{
  54:	55                   	push   %ebp
  55:	89 e5                	mov    %esp,%ebp
  57:	83 ec 18             	sub    $0x18,%esp
	static int counter = 0;

	printf(1, "Caught signal %d...\n", info.signum);
  5a:	8b 45 08             	mov    0x8(%ebp),%eax
  5d:	89 44 24 08          	mov    %eax,0x8(%esp)
  61:	c7 44 24 04 0d 09 00 	movl   $0x90d,0x4(%esp)
  68:	00 
  69:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  70:	e8 a7 04 00 00       	call   51c <printf>

	if (counter >= 15) {
  75:	a1 08 0c 00 00       	mov    0xc08,%eax
  7a:	83 f8 0e             	cmp    $0xe,%eax
  7d:	7e 19                	jle    98 <handle_alarm+0x44>
		printf(1, "COMPLETED\n");
  7f:	c7 44 24 04 22 09 00 	movl   $0x922,0x4(%esp)
  86:	00 
  87:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8e:	e8 89 04 00 00       	call   51c <printf>
		exit();
  93:	e8 f4 02 00 00       	call   38c <exit>
	}

	counter++;
  98:	a1 08 0c 00 00       	mov    0xc08,%eax
  9d:	40                   	inc    %eax
  9e:	a3 08 0c 00 00       	mov    %eax,0xc08
	alarm(1);
  a3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  aa:	e8 8d 03 00 00       	call   43c <alarm>
}
  af:	c9                   	leave  
  b0:	c3                   	ret    

000000b1 <main>:

int main(int argc, char *argv[])
{
  b1:	55                   	push   %ebp
  b2:	89 e5                	mov    %esp,%ebp
  b4:	83 e4 f0             	and    $0xfffffff0,%esp
  b7:	83 ec 20             	sub    $0x20,%esp
	int x = 5, y = 0;
  ba:	c7 44 24 1c 05 00 00 	movl   $0x5,0x1c(%esp)
  c1:	00 
  c2:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  c9:	00 

	signal(SIGFPE, handle_fpe);
  ca:	c7 44 24 04 1c 00 00 	movl   $0x1c,0x4(%esp)
  d1:	00 
  d2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  d9:	e8 7e 02 00 00       	call   35c <signal>
	signal(SIGALRM, handle_alarm);
  de:	c7 44 24 04 54 00 00 	movl   $0x54,0x4(%esp)
  e5:	00 
  e6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  ed:	e8 6a 02 00 00       	call   35c <signal>

	alarm(1);
  f2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  f9:	e8 3e 03 00 00       	call   43c <alarm>

	x = x / y;
  fe:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 102:	99                   	cltd   
 103:	f7 7c 24 18          	idivl  0x18(%esp)
 107:	89 44 24 1c          	mov    %eax,0x1c(%esp)

	exit();
 10b:	e8 7c 02 00 00       	call   38c <exit>

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
 141:	90                   	nop
 142:	8b 45 0c             	mov    0xc(%ebp),%eax
 145:	8a 10                	mov    (%eax),%dl
 147:	8b 45 08             	mov    0x8(%ebp),%eax
 14a:	88 10                	mov    %dl,(%eax)
 14c:	8b 45 08             	mov    0x8(%ebp),%eax
 14f:	8a 00                	mov    (%eax),%al
 151:	84 c0                	test   %al,%al
 153:	0f 95 c0             	setne  %al
 156:	ff 45 08             	incl   0x8(%ebp)
 159:	ff 45 0c             	incl   0xc(%ebp)
 15c:	84 c0                	test   %al,%al
 15e:	75 e2                	jne    142 <strcpy+0xd>
    ;
  return os;
 160:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 163:	c9                   	leave  
 164:	c3                   	ret    

00000165 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 165:	55                   	push   %ebp
 166:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 168:	eb 06                	jmp    170 <strcmp+0xb>
    p++, q++;
 16a:	ff 45 08             	incl   0x8(%ebp)
 16d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 170:	8b 45 08             	mov    0x8(%ebp),%eax
 173:	8a 00                	mov    (%eax),%al
 175:	84 c0                	test   %al,%al
 177:	74 0e                	je     187 <strcmp+0x22>
 179:	8b 45 08             	mov    0x8(%ebp),%eax
 17c:	8a 10                	mov    (%eax),%dl
 17e:	8b 45 0c             	mov    0xc(%ebp),%eax
 181:	8a 00                	mov    (%eax),%al
 183:	38 c2                	cmp    %al,%dl
 185:	74 e3                	je     16a <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 187:	8b 45 08             	mov    0x8(%ebp),%eax
 18a:	8a 00                	mov    (%eax),%al
 18c:	0f b6 d0             	movzbl %al,%edx
 18f:	8b 45 0c             	mov    0xc(%ebp),%eax
 192:	8a 00                	mov    (%eax),%al
 194:	0f b6 c0             	movzbl %al,%eax
 197:	89 d1                	mov    %edx,%ecx
 199:	29 c1                	sub    %eax,%ecx
 19b:	89 c8                	mov    %ecx,%eax
}
 19d:	5d                   	pop    %ebp
 19e:	c3                   	ret    

0000019f <strlen>:

uint
strlen(char *s)
{
 19f:	55                   	push   %ebp
 1a0:	89 e5                	mov    %esp,%ebp
 1a2:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1ac:	eb 03                	jmp    1b1 <strlen+0x12>
 1ae:	ff 45 fc             	incl   -0x4(%ebp)
 1b1:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1b4:	8b 45 08             	mov    0x8(%ebp),%eax
 1b7:	01 d0                	add    %edx,%eax
 1b9:	8a 00                	mov    (%eax),%al
 1bb:	84 c0                	test   %al,%al
 1bd:	75 ef                	jne    1ae <strlen+0xf>
    ;
  return n;
 1bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1c2:	c9                   	leave  
 1c3:	c3                   	ret    

000001c4 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1c4:	55                   	push   %ebp
 1c5:	89 e5                	mov    %esp,%ebp
 1c7:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1ca:	8b 45 10             	mov    0x10(%ebp),%eax
 1cd:	89 44 24 08          	mov    %eax,0x8(%esp)
 1d1:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d4:	89 44 24 04          	mov    %eax,0x4(%esp)
 1d8:	8b 45 08             	mov    0x8(%ebp),%eax
 1db:	89 04 24             	mov    %eax,(%esp)
 1de:	e8 2d ff ff ff       	call   110 <stosb>
  return dst;
 1e3:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1e6:	c9                   	leave  
 1e7:	c3                   	ret    

000001e8 <strchr>:

char*
strchr(const char *s, char c)
{
 1e8:	55                   	push   %ebp
 1e9:	89 e5                	mov    %esp,%ebp
 1eb:	83 ec 04             	sub    $0x4,%esp
 1ee:	8b 45 0c             	mov    0xc(%ebp),%eax
 1f1:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1f4:	eb 12                	jmp    208 <strchr+0x20>
    if(*s == c)
 1f6:	8b 45 08             	mov    0x8(%ebp),%eax
 1f9:	8a 00                	mov    (%eax),%al
 1fb:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1fe:	75 05                	jne    205 <strchr+0x1d>
      return (char*)s;
 200:	8b 45 08             	mov    0x8(%ebp),%eax
 203:	eb 11                	jmp    216 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 205:	ff 45 08             	incl   0x8(%ebp)
 208:	8b 45 08             	mov    0x8(%ebp),%eax
 20b:	8a 00                	mov    (%eax),%al
 20d:	84 c0                	test   %al,%al
 20f:	75 e5                	jne    1f6 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 211:	b8 00 00 00 00       	mov    $0x0,%eax
}
 216:	c9                   	leave  
 217:	c3                   	ret    

00000218 <gets>:

char*
gets(char *buf, int max)
{
 218:	55                   	push   %ebp
 219:	89 e5                	mov    %esp,%ebp
 21b:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 21e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 225:	eb 42                	jmp    269 <gets+0x51>
    cc = read(0, &c, 1);
 227:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 22e:	00 
 22f:	8d 45 ef             	lea    -0x11(%ebp),%eax
 232:	89 44 24 04          	mov    %eax,0x4(%esp)
 236:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 23d:	e8 62 01 00 00       	call   3a4 <read>
 242:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 245:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 249:	7e 29                	jle    274 <gets+0x5c>
      break;
    buf[i++] = c;
 24b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 24e:	8b 45 08             	mov    0x8(%ebp),%eax
 251:	01 c2                	add    %eax,%edx
 253:	8a 45 ef             	mov    -0x11(%ebp),%al
 256:	88 02                	mov    %al,(%edx)
 258:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 25b:	8a 45 ef             	mov    -0x11(%ebp),%al
 25e:	3c 0a                	cmp    $0xa,%al
 260:	74 13                	je     275 <gets+0x5d>
 262:	8a 45 ef             	mov    -0x11(%ebp),%al
 265:	3c 0d                	cmp    $0xd,%al
 267:	74 0c                	je     275 <gets+0x5d>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 269:	8b 45 f4             	mov    -0xc(%ebp),%eax
 26c:	40                   	inc    %eax
 26d:	3b 45 0c             	cmp    0xc(%ebp),%eax
 270:	7c b5                	jl     227 <gets+0xf>
 272:	eb 01                	jmp    275 <gets+0x5d>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 274:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 275:	8b 55 f4             	mov    -0xc(%ebp),%edx
 278:	8b 45 08             	mov    0x8(%ebp),%eax
 27b:	01 d0                	add    %edx,%eax
 27d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 280:	8b 45 08             	mov    0x8(%ebp),%eax
}
 283:	c9                   	leave  
 284:	c3                   	ret    

00000285 <stat>:

int
stat(char *n, struct stat *st)
{
 285:	55                   	push   %ebp
 286:	89 e5                	mov    %esp,%ebp
 288:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 28b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 292:	00 
 293:	8b 45 08             	mov    0x8(%ebp),%eax
 296:	89 04 24             	mov    %eax,(%esp)
 299:	e8 2e 01 00 00       	call   3cc <open>
 29e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2a5:	79 07                	jns    2ae <stat+0x29>
    return -1;
 2a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2ac:	eb 23                	jmp    2d1 <stat+0x4c>
  r = fstat(fd, st);
 2ae:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b1:	89 44 24 04          	mov    %eax,0x4(%esp)
 2b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2b8:	89 04 24             	mov    %eax,(%esp)
 2bb:	e8 24 01 00 00       	call   3e4 <fstat>
 2c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2c6:	89 04 24             	mov    %eax,(%esp)
 2c9:	e8 e6 00 00 00       	call   3b4 <close>
  return r;
 2ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2d1:	c9                   	leave  
 2d2:	c3                   	ret    

000002d3 <atoi>:

int
atoi(const char *s)
{
 2d3:	55                   	push   %ebp
 2d4:	89 e5                	mov    %esp,%ebp
 2d6:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2d9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2e0:	eb 21                	jmp    303 <atoi+0x30>
    n = n*10 + *s++ - '0';
 2e2:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2e5:	89 d0                	mov    %edx,%eax
 2e7:	c1 e0 02             	shl    $0x2,%eax
 2ea:	01 d0                	add    %edx,%eax
 2ec:	d1 e0                	shl    %eax
 2ee:	89 c2                	mov    %eax,%edx
 2f0:	8b 45 08             	mov    0x8(%ebp),%eax
 2f3:	8a 00                	mov    (%eax),%al
 2f5:	0f be c0             	movsbl %al,%eax
 2f8:	01 d0                	add    %edx,%eax
 2fa:	83 e8 30             	sub    $0x30,%eax
 2fd:	89 45 fc             	mov    %eax,-0x4(%ebp)
 300:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 303:	8b 45 08             	mov    0x8(%ebp),%eax
 306:	8a 00                	mov    (%eax),%al
 308:	3c 2f                	cmp    $0x2f,%al
 30a:	7e 09                	jle    315 <atoi+0x42>
 30c:	8b 45 08             	mov    0x8(%ebp),%eax
 30f:	8a 00                	mov    (%eax),%al
 311:	3c 39                	cmp    $0x39,%al
 313:	7e cd                	jle    2e2 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 315:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 318:	c9                   	leave  
 319:	c3                   	ret    

0000031a <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 31a:	55                   	push   %ebp
 31b:	89 e5                	mov    %esp,%ebp
 31d:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 320:	8b 45 08             	mov    0x8(%ebp),%eax
 323:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 326:	8b 45 0c             	mov    0xc(%ebp),%eax
 329:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 32c:	eb 10                	jmp    33e <memmove+0x24>
    *dst++ = *src++;
 32e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 331:	8a 10                	mov    (%eax),%dl
 333:	8b 45 fc             	mov    -0x4(%ebp),%eax
 336:	88 10                	mov    %dl,(%eax)
 338:	ff 45 fc             	incl   -0x4(%ebp)
 33b:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 33e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 342:	0f 9f c0             	setg   %al
 345:	ff 4d 10             	decl   0x10(%ebp)
 348:	84 c0                	test   %al,%al
 34a:	75 e2                	jne    32e <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 34c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 34f:	c9                   	leave  
 350:	c3                   	ret    

00000351 <trampoline>:
 351:	5a                   	pop    %edx
 352:	59                   	pop    %ecx
 353:	58                   	pop    %eax
 354:	03 25 04 00 00 00    	add    0x4,%esp
 35a:	c9                   	leave  
 35b:	c3                   	ret    

0000035c <signal>:
	"addl 4, %esp\n\t"
	"leave\n\t"
	"ret\n\t"
);
int signal(int signum, sighandler_t handler) 
{
 35c:	55                   	push   %ebp
 35d:	89 e5                	mov    %esp,%ebp
 35f:	83 ec 18             	sub    $0x18,%esp
	register_signal_handler(signum, handler, trampoline);
 362:	c7 44 24 08 51 03 00 	movl   $0x351,0x8(%esp)
 369:	00 
 36a:	8b 45 0c             	mov    0xc(%ebp),%eax
 36d:	89 44 24 04          	mov    %eax,0x4(%esp)
 371:	8b 45 08             	mov    0x8(%ebp),%eax
 374:	89 04 24             	mov    %eax,(%esp)
 377:	e8 b8 00 00 00       	call   434 <register_signal_handler>
	return 0;
 37c:	b8 00 00 00 00       	mov    $0x0,%eax
}
 381:	c9                   	leave  
 382:	c3                   	ret    
 383:	90                   	nop

00000384 <fork>:
 384:	b8 01 00 00 00       	mov    $0x1,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <exit>:
 38c:	b8 02 00 00 00       	mov    $0x2,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <wait>:
 394:	b8 03 00 00 00       	mov    $0x3,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <pipe>:
 39c:	b8 04 00 00 00       	mov    $0x4,%eax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret    

000003a4 <read>:
 3a4:	b8 05 00 00 00       	mov    $0x5,%eax
 3a9:	cd 40                	int    $0x40
 3ab:	c3                   	ret    

000003ac <write>:
 3ac:	b8 10 00 00 00       	mov    $0x10,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret    

000003b4 <close>:
 3b4:	b8 15 00 00 00       	mov    $0x15,%eax
 3b9:	cd 40                	int    $0x40
 3bb:	c3                   	ret    

000003bc <kill>:
 3bc:	b8 06 00 00 00       	mov    $0x6,%eax
 3c1:	cd 40                	int    $0x40
 3c3:	c3                   	ret    

000003c4 <exec>:
 3c4:	b8 07 00 00 00       	mov    $0x7,%eax
 3c9:	cd 40                	int    $0x40
 3cb:	c3                   	ret    

000003cc <open>:
 3cc:	b8 0f 00 00 00       	mov    $0xf,%eax
 3d1:	cd 40                	int    $0x40
 3d3:	c3                   	ret    

000003d4 <mknod>:
 3d4:	b8 11 00 00 00       	mov    $0x11,%eax
 3d9:	cd 40                	int    $0x40
 3db:	c3                   	ret    

000003dc <unlink>:
 3dc:	b8 12 00 00 00       	mov    $0x12,%eax
 3e1:	cd 40                	int    $0x40
 3e3:	c3                   	ret    

000003e4 <fstat>:
 3e4:	b8 08 00 00 00       	mov    $0x8,%eax
 3e9:	cd 40                	int    $0x40
 3eb:	c3                   	ret    

000003ec <link>:
 3ec:	b8 13 00 00 00       	mov    $0x13,%eax
 3f1:	cd 40                	int    $0x40
 3f3:	c3                   	ret    

000003f4 <mkdir>:
 3f4:	b8 14 00 00 00       	mov    $0x14,%eax
 3f9:	cd 40                	int    $0x40
 3fb:	c3                   	ret    

000003fc <chdir>:
 3fc:	b8 09 00 00 00       	mov    $0x9,%eax
 401:	cd 40                	int    $0x40
 403:	c3                   	ret    

00000404 <dup>:
 404:	b8 0a 00 00 00       	mov    $0xa,%eax
 409:	cd 40                	int    $0x40
 40b:	c3                   	ret    

0000040c <getpid>:
 40c:	b8 0b 00 00 00       	mov    $0xb,%eax
 411:	cd 40                	int    $0x40
 413:	c3                   	ret    

00000414 <sbrk>:
 414:	b8 0c 00 00 00       	mov    $0xc,%eax
 419:	cd 40                	int    $0x40
 41b:	c3                   	ret    

0000041c <sleep>:
 41c:	b8 0d 00 00 00       	mov    $0xd,%eax
 421:	cd 40                	int    $0x40
 423:	c3                   	ret    

00000424 <uptime>:
 424:	b8 0e 00 00 00       	mov    $0xe,%eax
 429:	cd 40                	int    $0x40
 42b:	c3                   	ret    

0000042c <halt>:
 42c:	b8 16 00 00 00       	mov    $0x16,%eax
 431:	cd 40                	int    $0x40
 433:	c3                   	ret    

00000434 <register_signal_handler>:
 434:	b8 17 00 00 00       	mov    $0x17,%eax
 439:	cd 40                	int    $0x40
 43b:	c3                   	ret    

0000043c <alarm>:
 43c:	b8 18 00 00 00       	mov    $0x18,%eax
 441:	cd 40                	int    $0x40
 443:	c3                   	ret    

00000444 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 444:	55                   	push   %ebp
 445:	89 e5                	mov    %esp,%ebp
 447:	83 ec 28             	sub    $0x28,%esp
 44a:	8b 45 0c             	mov    0xc(%ebp),%eax
 44d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 450:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 457:	00 
 458:	8d 45 f4             	lea    -0xc(%ebp),%eax
 45b:	89 44 24 04          	mov    %eax,0x4(%esp)
 45f:	8b 45 08             	mov    0x8(%ebp),%eax
 462:	89 04 24             	mov    %eax,(%esp)
 465:	e8 42 ff ff ff       	call   3ac <write>
}
 46a:	c9                   	leave  
 46b:	c3                   	ret    

0000046c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 46c:	55                   	push   %ebp
 46d:	89 e5                	mov    %esp,%ebp
 46f:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 472:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 479:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 47d:	74 17                	je     496 <printint+0x2a>
 47f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 483:	79 11                	jns    496 <printint+0x2a>
    neg = 1;
 485:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 48c:	8b 45 0c             	mov    0xc(%ebp),%eax
 48f:	f7 d8                	neg    %eax
 491:	89 45 ec             	mov    %eax,-0x14(%ebp)
 494:	eb 06                	jmp    49c <printint+0x30>
  } else {
    x = xx;
 496:	8b 45 0c             	mov    0xc(%ebp),%eax
 499:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 49c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4a3:	8b 4d 10             	mov    0x10(%ebp),%ecx
 4a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4a9:	ba 00 00 00 00       	mov    $0x0,%edx
 4ae:	f7 f1                	div    %ecx
 4b0:	89 d0                	mov    %edx,%eax
 4b2:	8a 80 f0 0b 00 00    	mov    0xbf0(%eax),%al
 4b8:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 4bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4be:	01 ca                	add    %ecx,%edx
 4c0:	88 02                	mov    %al,(%edx)
 4c2:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 4c5:	8b 55 10             	mov    0x10(%ebp),%edx
 4c8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 4cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4ce:	ba 00 00 00 00       	mov    $0x0,%edx
 4d3:	f7 75 d4             	divl   -0x2c(%ebp)
 4d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4d9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4dd:	75 c4                	jne    4a3 <printint+0x37>
  if(neg)
 4df:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4e3:	74 2c                	je     511 <printint+0xa5>
    buf[i++] = '-';
 4e5:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4eb:	01 d0                	add    %edx,%eax
 4ed:	c6 00 2d             	movb   $0x2d,(%eax)
 4f0:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 4f3:	eb 1c                	jmp    511 <printint+0xa5>
    putc(fd, buf[i]);
 4f5:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4fb:	01 d0                	add    %edx,%eax
 4fd:	8a 00                	mov    (%eax),%al
 4ff:	0f be c0             	movsbl %al,%eax
 502:	89 44 24 04          	mov    %eax,0x4(%esp)
 506:	8b 45 08             	mov    0x8(%ebp),%eax
 509:	89 04 24             	mov    %eax,(%esp)
 50c:	e8 33 ff ff ff       	call   444 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 511:	ff 4d f4             	decl   -0xc(%ebp)
 514:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 518:	79 db                	jns    4f5 <printint+0x89>
    putc(fd, buf[i]);
}
 51a:	c9                   	leave  
 51b:	c3                   	ret    

0000051c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 51c:	55                   	push   %ebp
 51d:	89 e5                	mov    %esp,%ebp
 51f:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 522:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 529:	8d 45 0c             	lea    0xc(%ebp),%eax
 52c:	83 c0 04             	add    $0x4,%eax
 52f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 532:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 539:	e9 78 01 00 00       	jmp    6b6 <printf+0x19a>
    c = fmt[i] & 0xff;
 53e:	8b 55 0c             	mov    0xc(%ebp),%edx
 541:	8b 45 f0             	mov    -0x10(%ebp),%eax
 544:	01 d0                	add    %edx,%eax
 546:	8a 00                	mov    (%eax),%al
 548:	0f be c0             	movsbl %al,%eax
 54b:	25 ff 00 00 00       	and    $0xff,%eax
 550:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 553:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 557:	75 2c                	jne    585 <printf+0x69>
      if(c == '%'){
 559:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 55d:	75 0c                	jne    56b <printf+0x4f>
        state = '%';
 55f:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 566:	e9 48 01 00 00       	jmp    6b3 <printf+0x197>
      } else {
        putc(fd, c);
 56b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 56e:	0f be c0             	movsbl %al,%eax
 571:	89 44 24 04          	mov    %eax,0x4(%esp)
 575:	8b 45 08             	mov    0x8(%ebp),%eax
 578:	89 04 24             	mov    %eax,(%esp)
 57b:	e8 c4 fe ff ff       	call   444 <putc>
 580:	e9 2e 01 00 00       	jmp    6b3 <printf+0x197>
      }
    } else if(state == '%'){
 585:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 589:	0f 85 24 01 00 00    	jne    6b3 <printf+0x197>
      if(c == 'd'){
 58f:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 593:	75 2d                	jne    5c2 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 595:	8b 45 e8             	mov    -0x18(%ebp),%eax
 598:	8b 00                	mov    (%eax),%eax
 59a:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 5a1:	00 
 5a2:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 5a9:	00 
 5aa:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ae:	8b 45 08             	mov    0x8(%ebp),%eax
 5b1:	89 04 24             	mov    %eax,(%esp)
 5b4:	e8 b3 fe ff ff       	call   46c <printint>
        ap++;
 5b9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5bd:	e9 ea 00 00 00       	jmp    6ac <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 5c2:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5c6:	74 06                	je     5ce <printf+0xb2>
 5c8:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5cc:	75 2d                	jne    5fb <printf+0xdf>
        printint(fd, *ap, 16, 0);
 5ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5d1:	8b 00                	mov    (%eax),%eax
 5d3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 5da:	00 
 5db:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 5e2:	00 
 5e3:	89 44 24 04          	mov    %eax,0x4(%esp)
 5e7:	8b 45 08             	mov    0x8(%ebp),%eax
 5ea:	89 04 24             	mov    %eax,(%esp)
 5ed:	e8 7a fe ff ff       	call   46c <printint>
        ap++;
 5f2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5f6:	e9 b1 00 00 00       	jmp    6ac <printf+0x190>
      } else if(c == 's'){
 5fb:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5ff:	75 43                	jne    644 <printf+0x128>
        s = (char*)*ap;
 601:	8b 45 e8             	mov    -0x18(%ebp),%eax
 604:	8b 00                	mov    (%eax),%eax
 606:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 609:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 60d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 611:	75 25                	jne    638 <printf+0x11c>
          s = "(null)";
 613:	c7 45 f4 2d 09 00 00 	movl   $0x92d,-0xc(%ebp)
        while(*s != 0){
 61a:	eb 1c                	jmp    638 <printf+0x11c>
          putc(fd, *s);
 61c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 61f:	8a 00                	mov    (%eax),%al
 621:	0f be c0             	movsbl %al,%eax
 624:	89 44 24 04          	mov    %eax,0x4(%esp)
 628:	8b 45 08             	mov    0x8(%ebp),%eax
 62b:	89 04 24             	mov    %eax,(%esp)
 62e:	e8 11 fe ff ff       	call   444 <putc>
          s++;
 633:	ff 45 f4             	incl   -0xc(%ebp)
 636:	eb 01                	jmp    639 <printf+0x11d>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 638:	90                   	nop
 639:	8b 45 f4             	mov    -0xc(%ebp),%eax
 63c:	8a 00                	mov    (%eax),%al
 63e:	84 c0                	test   %al,%al
 640:	75 da                	jne    61c <printf+0x100>
 642:	eb 68                	jmp    6ac <printf+0x190>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 644:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 648:	75 1d                	jne    667 <printf+0x14b>
        putc(fd, *ap);
 64a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 64d:	8b 00                	mov    (%eax),%eax
 64f:	0f be c0             	movsbl %al,%eax
 652:	89 44 24 04          	mov    %eax,0x4(%esp)
 656:	8b 45 08             	mov    0x8(%ebp),%eax
 659:	89 04 24             	mov    %eax,(%esp)
 65c:	e8 e3 fd ff ff       	call   444 <putc>
        ap++;
 661:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 665:	eb 45                	jmp    6ac <printf+0x190>
      } else if(c == '%'){
 667:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 66b:	75 17                	jne    684 <printf+0x168>
        putc(fd, c);
 66d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 670:	0f be c0             	movsbl %al,%eax
 673:	89 44 24 04          	mov    %eax,0x4(%esp)
 677:	8b 45 08             	mov    0x8(%ebp),%eax
 67a:	89 04 24             	mov    %eax,(%esp)
 67d:	e8 c2 fd ff ff       	call   444 <putc>
 682:	eb 28                	jmp    6ac <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 684:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 68b:	00 
 68c:	8b 45 08             	mov    0x8(%ebp),%eax
 68f:	89 04 24             	mov    %eax,(%esp)
 692:	e8 ad fd ff ff       	call   444 <putc>
        putc(fd, c);
 697:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 69a:	0f be c0             	movsbl %al,%eax
 69d:	89 44 24 04          	mov    %eax,0x4(%esp)
 6a1:	8b 45 08             	mov    0x8(%ebp),%eax
 6a4:	89 04 24             	mov    %eax,(%esp)
 6a7:	e8 98 fd ff ff       	call   444 <putc>
      }
      state = 0;
 6ac:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6b3:	ff 45 f0             	incl   -0x10(%ebp)
 6b6:	8b 55 0c             	mov    0xc(%ebp),%edx
 6b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6bc:	01 d0                	add    %edx,%eax
 6be:	8a 00                	mov    (%eax),%al
 6c0:	84 c0                	test   %al,%al
 6c2:	0f 85 76 fe ff ff    	jne    53e <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6c8:	c9                   	leave  
 6c9:	c3                   	ret    
 6ca:	66 90                	xchg   %ax,%ax

000006cc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6cc:	55                   	push   %ebp
 6cd:	89 e5                	mov    %esp,%ebp
 6cf:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6d2:	8b 45 08             	mov    0x8(%ebp),%eax
 6d5:	83 e8 08             	sub    $0x8,%eax
 6d8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6db:	a1 14 0c 00 00       	mov    0xc14,%eax
 6e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6e3:	eb 24                	jmp    709 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e8:	8b 00                	mov    (%eax),%eax
 6ea:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6ed:	77 12                	ja     701 <free+0x35>
 6ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6f5:	77 24                	ja     71b <free+0x4f>
 6f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fa:	8b 00                	mov    (%eax),%eax
 6fc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6ff:	77 1a                	ja     71b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 701:	8b 45 fc             	mov    -0x4(%ebp),%eax
 704:	8b 00                	mov    (%eax),%eax
 706:	89 45 fc             	mov    %eax,-0x4(%ebp)
 709:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 70f:	76 d4                	jbe    6e5 <free+0x19>
 711:	8b 45 fc             	mov    -0x4(%ebp),%eax
 714:	8b 00                	mov    (%eax),%eax
 716:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 719:	76 ca                	jbe    6e5 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 71b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71e:	8b 40 04             	mov    0x4(%eax),%eax
 721:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 728:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72b:	01 c2                	add    %eax,%edx
 72d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 730:	8b 00                	mov    (%eax),%eax
 732:	39 c2                	cmp    %eax,%edx
 734:	75 24                	jne    75a <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 736:	8b 45 f8             	mov    -0x8(%ebp),%eax
 739:	8b 50 04             	mov    0x4(%eax),%edx
 73c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73f:	8b 00                	mov    (%eax),%eax
 741:	8b 40 04             	mov    0x4(%eax),%eax
 744:	01 c2                	add    %eax,%edx
 746:	8b 45 f8             	mov    -0x8(%ebp),%eax
 749:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 74c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74f:	8b 00                	mov    (%eax),%eax
 751:	8b 10                	mov    (%eax),%edx
 753:	8b 45 f8             	mov    -0x8(%ebp),%eax
 756:	89 10                	mov    %edx,(%eax)
 758:	eb 0a                	jmp    764 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 75a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75d:	8b 10                	mov    (%eax),%edx
 75f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 762:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 764:	8b 45 fc             	mov    -0x4(%ebp),%eax
 767:	8b 40 04             	mov    0x4(%eax),%eax
 76a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 771:	8b 45 fc             	mov    -0x4(%ebp),%eax
 774:	01 d0                	add    %edx,%eax
 776:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 779:	75 20                	jne    79b <free+0xcf>
    p->s.size += bp->s.size;
 77b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77e:	8b 50 04             	mov    0x4(%eax),%edx
 781:	8b 45 f8             	mov    -0x8(%ebp),%eax
 784:	8b 40 04             	mov    0x4(%eax),%eax
 787:	01 c2                	add    %eax,%edx
 789:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 78f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 792:	8b 10                	mov    (%eax),%edx
 794:	8b 45 fc             	mov    -0x4(%ebp),%eax
 797:	89 10                	mov    %edx,(%eax)
 799:	eb 08                	jmp    7a3 <free+0xd7>
  } else
    p->s.ptr = bp;
 79b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7a1:	89 10                	mov    %edx,(%eax)
  freep = p;
 7a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a6:	a3 14 0c 00 00       	mov    %eax,0xc14
}
 7ab:	c9                   	leave  
 7ac:	c3                   	ret    

000007ad <morecore>:

static Header*
morecore(uint nu)
{
 7ad:	55                   	push   %ebp
 7ae:	89 e5                	mov    %esp,%ebp
 7b0:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7b3:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7ba:	77 07                	ja     7c3 <morecore+0x16>
    nu = 4096;
 7bc:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7c3:	8b 45 08             	mov    0x8(%ebp),%eax
 7c6:	c1 e0 03             	shl    $0x3,%eax
 7c9:	89 04 24             	mov    %eax,(%esp)
 7cc:	e8 43 fc ff ff       	call   414 <sbrk>
 7d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7d4:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7d8:	75 07                	jne    7e1 <morecore+0x34>
    return 0;
 7da:	b8 00 00 00 00       	mov    $0x0,%eax
 7df:	eb 22                	jmp    803 <morecore+0x56>
  hp = (Header*)p;
 7e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ea:	8b 55 08             	mov    0x8(%ebp),%edx
 7ed:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f3:	83 c0 08             	add    $0x8,%eax
 7f6:	89 04 24             	mov    %eax,(%esp)
 7f9:	e8 ce fe ff ff       	call   6cc <free>
  return freep;
 7fe:	a1 14 0c 00 00       	mov    0xc14,%eax
}
 803:	c9                   	leave  
 804:	c3                   	ret    

00000805 <malloc>:

void*
malloc(uint nbytes)
{
 805:	55                   	push   %ebp
 806:	89 e5                	mov    %esp,%ebp
 808:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 80b:	8b 45 08             	mov    0x8(%ebp),%eax
 80e:	83 c0 07             	add    $0x7,%eax
 811:	c1 e8 03             	shr    $0x3,%eax
 814:	40                   	inc    %eax
 815:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 818:	a1 14 0c 00 00       	mov    0xc14,%eax
 81d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 820:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 824:	75 23                	jne    849 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 826:	c7 45 f0 0c 0c 00 00 	movl   $0xc0c,-0x10(%ebp)
 82d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 830:	a3 14 0c 00 00       	mov    %eax,0xc14
 835:	a1 14 0c 00 00       	mov    0xc14,%eax
 83a:	a3 0c 0c 00 00       	mov    %eax,0xc0c
    base.s.size = 0;
 83f:	c7 05 10 0c 00 00 00 	movl   $0x0,0xc10
 846:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 849:	8b 45 f0             	mov    -0x10(%ebp),%eax
 84c:	8b 00                	mov    (%eax),%eax
 84e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 851:	8b 45 f4             	mov    -0xc(%ebp),%eax
 854:	8b 40 04             	mov    0x4(%eax),%eax
 857:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 85a:	72 4d                	jb     8a9 <malloc+0xa4>
      if(p->s.size == nunits)
 85c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85f:	8b 40 04             	mov    0x4(%eax),%eax
 862:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 865:	75 0c                	jne    873 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 867:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86a:	8b 10                	mov    (%eax),%edx
 86c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 86f:	89 10                	mov    %edx,(%eax)
 871:	eb 26                	jmp    899 <malloc+0x94>
      else {
        p->s.size -= nunits;
 873:	8b 45 f4             	mov    -0xc(%ebp),%eax
 876:	8b 40 04             	mov    0x4(%eax),%eax
 879:	89 c2                	mov    %eax,%edx
 87b:	2b 55 ec             	sub    -0x14(%ebp),%edx
 87e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 881:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 884:	8b 45 f4             	mov    -0xc(%ebp),%eax
 887:	8b 40 04             	mov    0x4(%eax),%eax
 88a:	c1 e0 03             	shl    $0x3,%eax
 88d:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 890:	8b 45 f4             	mov    -0xc(%ebp),%eax
 893:	8b 55 ec             	mov    -0x14(%ebp),%edx
 896:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 899:	8b 45 f0             	mov    -0x10(%ebp),%eax
 89c:	a3 14 0c 00 00       	mov    %eax,0xc14
      return (void*)(p + 1);
 8a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a4:	83 c0 08             	add    $0x8,%eax
 8a7:	eb 38                	jmp    8e1 <malloc+0xdc>
    }
    if(p == freep)
 8a9:	a1 14 0c 00 00       	mov    0xc14,%eax
 8ae:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8b1:	75 1b                	jne    8ce <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 8b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8b6:	89 04 24             	mov    %eax,(%esp)
 8b9:	e8 ef fe ff ff       	call   7ad <morecore>
 8be:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8c5:	75 07                	jne    8ce <malloc+0xc9>
        return 0;
 8c7:	b8 00 00 00 00       	mov    $0x0,%eax
 8cc:	eb 13                	jmp    8e1 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d7:	8b 00                	mov    (%eax),%eax
 8d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8dc:	e9 70 ff ff ff       	jmp    851 <malloc+0x4c>
}
 8e1:	c9                   	leave  
 8e2:	c3                   	ret    
