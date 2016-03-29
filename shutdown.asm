
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
   6:	e8 21 03 00 00       	call   32c <halt>
	exit();
   b:	e8 7c 02 00 00       	call   28c <exit>

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
  41:	90                   	nop
  42:	8b 45 0c             	mov    0xc(%ebp),%eax
  45:	8a 10                	mov    (%eax),%dl
  47:	8b 45 08             	mov    0x8(%ebp),%eax
  4a:	88 10                	mov    %dl,(%eax)
  4c:	8b 45 08             	mov    0x8(%ebp),%eax
  4f:	8a 00                	mov    (%eax),%al
  51:	84 c0                	test   %al,%al
  53:	0f 95 c0             	setne  %al
  56:	ff 45 08             	incl   0x8(%ebp)
  59:	ff 45 0c             	incl   0xc(%ebp)
  5c:	84 c0                	test   %al,%al
  5e:	75 e2                	jne    42 <strcpy+0xd>
    ;
  return os;
  60:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  63:	c9                   	leave  
  64:	c3                   	ret    

00000065 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  65:	55                   	push   %ebp
  66:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  68:	eb 06                	jmp    70 <strcmp+0xb>
    p++, q++;
  6a:	ff 45 08             	incl   0x8(%ebp)
  6d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  70:	8b 45 08             	mov    0x8(%ebp),%eax
  73:	8a 00                	mov    (%eax),%al
  75:	84 c0                	test   %al,%al
  77:	74 0e                	je     87 <strcmp+0x22>
  79:	8b 45 08             	mov    0x8(%ebp),%eax
  7c:	8a 10                	mov    (%eax),%dl
  7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  81:	8a 00                	mov    (%eax),%al
  83:	38 c2                	cmp    %al,%dl
  85:	74 e3                	je     6a <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  87:	8b 45 08             	mov    0x8(%ebp),%eax
  8a:	8a 00                	mov    (%eax),%al
  8c:	0f b6 d0             	movzbl %al,%edx
  8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  92:	8a 00                	mov    (%eax),%al
  94:	0f b6 c0             	movzbl %al,%eax
  97:	89 d1                	mov    %edx,%ecx
  99:	29 c1                	sub    %eax,%ecx
  9b:	89 c8                	mov    %ecx,%eax
}
  9d:	5d                   	pop    %ebp
  9e:	c3                   	ret    

0000009f <strlen>:

uint
strlen(char *s)
{
  9f:	55                   	push   %ebp
  a0:	89 e5                	mov    %esp,%ebp
  a2:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  ac:	eb 03                	jmp    b1 <strlen+0x12>
  ae:	ff 45 fc             	incl   -0x4(%ebp)
  b1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  b4:	8b 45 08             	mov    0x8(%ebp),%eax
  b7:	01 d0                	add    %edx,%eax
  b9:	8a 00                	mov    (%eax),%al
  bb:	84 c0                	test   %al,%al
  bd:	75 ef                	jne    ae <strlen+0xf>
    ;
  return n;
  bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  c2:	c9                   	leave  
  c3:	c3                   	ret    

000000c4 <memset>:

void*
memset(void *dst, int c, uint n)
{
  c4:	55                   	push   %ebp
  c5:	89 e5                	mov    %esp,%ebp
  c7:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
  ca:	8b 45 10             	mov    0x10(%ebp),%eax
  cd:	89 44 24 08          	mov    %eax,0x8(%esp)
  d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  d8:	8b 45 08             	mov    0x8(%ebp),%eax
  db:	89 04 24             	mov    %eax,(%esp)
  de:	e8 2d ff ff ff       	call   10 <stosb>
  return dst;
  e3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  e6:	c9                   	leave  
  e7:	c3                   	ret    

000000e8 <strchr>:

char*
strchr(const char *s, char c)
{
  e8:	55                   	push   %ebp
  e9:	89 e5                	mov    %esp,%ebp
  eb:	83 ec 04             	sub    $0x4,%esp
  ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  f1:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
  f4:	eb 12                	jmp    108 <strchr+0x20>
    if(*s == c)
  f6:	8b 45 08             	mov    0x8(%ebp),%eax
  f9:	8a 00                	mov    (%eax),%al
  fb:	3a 45 fc             	cmp    -0x4(%ebp),%al
  fe:	75 05                	jne    105 <strchr+0x1d>
      return (char*)s;
 100:	8b 45 08             	mov    0x8(%ebp),%eax
 103:	eb 11                	jmp    116 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 105:	ff 45 08             	incl   0x8(%ebp)
 108:	8b 45 08             	mov    0x8(%ebp),%eax
 10b:	8a 00                	mov    (%eax),%al
 10d:	84 c0                	test   %al,%al
 10f:	75 e5                	jne    f6 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 111:	b8 00 00 00 00       	mov    $0x0,%eax
}
 116:	c9                   	leave  
 117:	c3                   	ret    

00000118 <gets>:

char*
gets(char *buf, int max)
{
 118:	55                   	push   %ebp
 119:	89 e5                	mov    %esp,%ebp
 11b:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 11e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 125:	eb 42                	jmp    169 <gets+0x51>
    cc = read(0, &c, 1);
 127:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 12e:	00 
 12f:	8d 45 ef             	lea    -0x11(%ebp),%eax
 132:	89 44 24 04          	mov    %eax,0x4(%esp)
 136:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 13d:	e8 62 01 00 00       	call   2a4 <read>
 142:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 145:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 149:	7e 29                	jle    174 <gets+0x5c>
      break;
    buf[i++] = c;
 14b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 14e:	8b 45 08             	mov    0x8(%ebp),%eax
 151:	01 c2                	add    %eax,%edx
 153:	8a 45 ef             	mov    -0x11(%ebp),%al
 156:	88 02                	mov    %al,(%edx)
 158:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 15b:	8a 45 ef             	mov    -0x11(%ebp),%al
 15e:	3c 0a                	cmp    $0xa,%al
 160:	74 13                	je     175 <gets+0x5d>
 162:	8a 45 ef             	mov    -0x11(%ebp),%al
 165:	3c 0d                	cmp    $0xd,%al
 167:	74 0c                	je     175 <gets+0x5d>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 169:	8b 45 f4             	mov    -0xc(%ebp),%eax
 16c:	40                   	inc    %eax
 16d:	3b 45 0c             	cmp    0xc(%ebp),%eax
 170:	7c b5                	jl     127 <gets+0xf>
 172:	eb 01                	jmp    175 <gets+0x5d>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 174:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 175:	8b 55 f4             	mov    -0xc(%ebp),%edx
 178:	8b 45 08             	mov    0x8(%ebp),%eax
 17b:	01 d0                	add    %edx,%eax
 17d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 180:	8b 45 08             	mov    0x8(%ebp),%eax
}
 183:	c9                   	leave  
 184:	c3                   	ret    

00000185 <stat>:

int
stat(char *n, struct stat *st)
{
 185:	55                   	push   %ebp
 186:	89 e5                	mov    %esp,%ebp
 188:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 18b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 192:	00 
 193:	8b 45 08             	mov    0x8(%ebp),%eax
 196:	89 04 24             	mov    %eax,(%esp)
 199:	e8 2e 01 00 00       	call   2cc <open>
 19e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1a5:	79 07                	jns    1ae <stat+0x29>
    return -1;
 1a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1ac:	eb 23                	jmp    1d1 <stat+0x4c>
  r = fstat(fd, st);
 1ae:	8b 45 0c             	mov    0xc(%ebp),%eax
 1b1:	89 44 24 04          	mov    %eax,0x4(%esp)
 1b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1b8:	89 04 24             	mov    %eax,(%esp)
 1bb:	e8 24 01 00 00       	call   2e4 <fstat>
 1c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c6:	89 04 24             	mov    %eax,(%esp)
 1c9:	e8 e6 00 00 00       	call   2b4 <close>
  return r;
 1ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1d1:	c9                   	leave  
 1d2:	c3                   	ret    

000001d3 <atoi>:

int
atoi(const char *s)
{
 1d3:	55                   	push   %ebp
 1d4:	89 e5                	mov    %esp,%ebp
 1d6:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 1d9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 1e0:	eb 21                	jmp    203 <atoi+0x30>
    n = n*10 + *s++ - '0';
 1e2:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1e5:	89 d0                	mov    %edx,%eax
 1e7:	c1 e0 02             	shl    $0x2,%eax
 1ea:	01 d0                	add    %edx,%eax
 1ec:	d1 e0                	shl    %eax
 1ee:	89 c2                	mov    %eax,%edx
 1f0:	8b 45 08             	mov    0x8(%ebp),%eax
 1f3:	8a 00                	mov    (%eax),%al
 1f5:	0f be c0             	movsbl %al,%eax
 1f8:	01 d0                	add    %edx,%eax
 1fa:	83 e8 30             	sub    $0x30,%eax
 1fd:	89 45 fc             	mov    %eax,-0x4(%ebp)
 200:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 203:	8b 45 08             	mov    0x8(%ebp),%eax
 206:	8a 00                	mov    (%eax),%al
 208:	3c 2f                	cmp    $0x2f,%al
 20a:	7e 09                	jle    215 <atoi+0x42>
 20c:	8b 45 08             	mov    0x8(%ebp),%eax
 20f:	8a 00                	mov    (%eax),%al
 211:	3c 39                	cmp    $0x39,%al
 213:	7e cd                	jle    1e2 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 215:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 218:	c9                   	leave  
 219:	c3                   	ret    

0000021a <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 21a:	55                   	push   %ebp
 21b:	89 e5                	mov    %esp,%ebp
 21d:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 220:	8b 45 08             	mov    0x8(%ebp),%eax
 223:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 226:	8b 45 0c             	mov    0xc(%ebp),%eax
 229:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 22c:	eb 10                	jmp    23e <memmove+0x24>
    *dst++ = *src++;
 22e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 231:	8a 10                	mov    (%eax),%dl
 233:	8b 45 fc             	mov    -0x4(%ebp),%eax
 236:	88 10                	mov    %dl,(%eax)
 238:	ff 45 fc             	incl   -0x4(%ebp)
 23b:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 23e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 242:	0f 9f c0             	setg   %al
 245:	ff 4d 10             	decl   0x10(%ebp)
 248:	84 c0                	test   %al,%al
 24a:	75 e2                	jne    22e <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 24c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 24f:	c9                   	leave  
 250:	c3                   	ret    

00000251 <trampoline>:
 251:	5a                   	pop    %edx
 252:	59                   	pop    %ecx
 253:	58                   	pop    %eax
 254:	03 25 04 00 00 00    	add    0x4,%esp
 25a:	c9                   	leave  
 25b:	c3                   	ret    

0000025c <signal>:
	"addl 4, %esp\n\t"
	"leave\n\t"
	"ret\n\t"
);
int signal(int signum, sighandler_t handler) 
{
 25c:	55                   	push   %ebp
 25d:	89 e5                	mov    %esp,%ebp
 25f:	83 ec 18             	sub    $0x18,%esp
	register_signal_handler(signum, handler, trampoline);
 262:	c7 44 24 08 51 02 00 	movl   $0x251,0x8(%esp)
 269:	00 
 26a:	8b 45 0c             	mov    0xc(%ebp),%eax
 26d:	89 44 24 04          	mov    %eax,0x4(%esp)
 271:	8b 45 08             	mov    0x8(%ebp),%eax
 274:	89 04 24             	mov    %eax,(%esp)
 277:	e8 b8 00 00 00       	call   334 <register_signal_handler>
	return 0;
 27c:	b8 00 00 00 00       	mov    $0x0,%eax
}
 281:	c9                   	leave  
 282:	c3                   	ret    
 283:	90                   	nop

00000284 <fork>:
 284:	b8 01 00 00 00       	mov    $0x1,%eax
 289:	cd 40                	int    $0x40
 28b:	c3                   	ret    

0000028c <exit>:
 28c:	b8 02 00 00 00       	mov    $0x2,%eax
 291:	cd 40                	int    $0x40
 293:	c3                   	ret    

00000294 <wait>:
 294:	b8 03 00 00 00       	mov    $0x3,%eax
 299:	cd 40                	int    $0x40
 29b:	c3                   	ret    

0000029c <pipe>:
 29c:	b8 04 00 00 00       	mov    $0x4,%eax
 2a1:	cd 40                	int    $0x40
 2a3:	c3                   	ret    

000002a4 <read>:
 2a4:	b8 05 00 00 00       	mov    $0x5,%eax
 2a9:	cd 40                	int    $0x40
 2ab:	c3                   	ret    

000002ac <write>:
 2ac:	b8 10 00 00 00       	mov    $0x10,%eax
 2b1:	cd 40                	int    $0x40
 2b3:	c3                   	ret    

000002b4 <close>:
 2b4:	b8 15 00 00 00       	mov    $0x15,%eax
 2b9:	cd 40                	int    $0x40
 2bb:	c3                   	ret    

000002bc <kill>:
 2bc:	b8 06 00 00 00       	mov    $0x6,%eax
 2c1:	cd 40                	int    $0x40
 2c3:	c3                   	ret    

000002c4 <exec>:
 2c4:	b8 07 00 00 00       	mov    $0x7,%eax
 2c9:	cd 40                	int    $0x40
 2cb:	c3                   	ret    

000002cc <open>:
 2cc:	b8 0f 00 00 00       	mov    $0xf,%eax
 2d1:	cd 40                	int    $0x40
 2d3:	c3                   	ret    

000002d4 <mknod>:
 2d4:	b8 11 00 00 00       	mov    $0x11,%eax
 2d9:	cd 40                	int    $0x40
 2db:	c3                   	ret    

000002dc <unlink>:
 2dc:	b8 12 00 00 00       	mov    $0x12,%eax
 2e1:	cd 40                	int    $0x40
 2e3:	c3                   	ret    

000002e4 <fstat>:
 2e4:	b8 08 00 00 00       	mov    $0x8,%eax
 2e9:	cd 40                	int    $0x40
 2eb:	c3                   	ret    

000002ec <link>:
 2ec:	b8 13 00 00 00       	mov    $0x13,%eax
 2f1:	cd 40                	int    $0x40
 2f3:	c3                   	ret    

000002f4 <mkdir>:
 2f4:	b8 14 00 00 00       	mov    $0x14,%eax
 2f9:	cd 40                	int    $0x40
 2fb:	c3                   	ret    

000002fc <chdir>:
 2fc:	b8 09 00 00 00       	mov    $0x9,%eax
 301:	cd 40                	int    $0x40
 303:	c3                   	ret    

00000304 <dup>:
 304:	b8 0a 00 00 00       	mov    $0xa,%eax
 309:	cd 40                	int    $0x40
 30b:	c3                   	ret    

0000030c <getpid>:
 30c:	b8 0b 00 00 00       	mov    $0xb,%eax
 311:	cd 40                	int    $0x40
 313:	c3                   	ret    

00000314 <sbrk>:
 314:	b8 0c 00 00 00       	mov    $0xc,%eax
 319:	cd 40                	int    $0x40
 31b:	c3                   	ret    

0000031c <sleep>:
 31c:	b8 0d 00 00 00       	mov    $0xd,%eax
 321:	cd 40                	int    $0x40
 323:	c3                   	ret    

00000324 <uptime>:
 324:	b8 0e 00 00 00       	mov    $0xe,%eax
 329:	cd 40                	int    $0x40
 32b:	c3                   	ret    

0000032c <halt>:
 32c:	b8 16 00 00 00       	mov    $0x16,%eax
 331:	cd 40                	int    $0x40
 333:	c3                   	ret    

00000334 <register_signal_handler>:
 334:	b8 17 00 00 00       	mov    $0x17,%eax
 339:	cd 40                	int    $0x40
 33b:	c3                   	ret    

0000033c <alarm>:
 33c:	b8 18 00 00 00       	mov    $0x18,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 344:	55                   	push   %ebp
 345:	89 e5                	mov    %esp,%ebp
 347:	83 ec 28             	sub    $0x28,%esp
 34a:	8b 45 0c             	mov    0xc(%ebp),%eax
 34d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 350:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 357:	00 
 358:	8d 45 f4             	lea    -0xc(%ebp),%eax
 35b:	89 44 24 04          	mov    %eax,0x4(%esp)
 35f:	8b 45 08             	mov    0x8(%ebp),%eax
 362:	89 04 24             	mov    %eax,(%esp)
 365:	e8 42 ff ff ff       	call   2ac <write>
}
 36a:	c9                   	leave  
 36b:	c3                   	ret    

0000036c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 36c:	55                   	push   %ebp
 36d:	89 e5                	mov    %esp,%ebp
 36f:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 372:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 379:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 37d:	74 17                	je     396 <printint+0x2a>
 37f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 383:	79 11                	jns    396 <printint+0x2a>
    neg = 1;
 385:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 38c:	8b 45 0c             	mov    0xc(%ebp),%eax
 38f:	f7 d8                	neg    %eax
 391:	89 45 ec             	mov    %eax,-0x14(%ebp)
 394:	eb 06                	jmp    39c <printint+0x30>
  } else {
    x = xx;
 396:	8b 45 0c             	mov    0xc(%ebp),%eax
 399:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 39c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3a3:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3a9:	ba 00 00 00 00       	mov    $0x0,%edx
 3ae:	f7 f1                	div    %ecx
 3b0:	89 d0                	mov    %edx,%eax
 3b2:	8a 80 48 0a 00 00    	mov    0xa48(%eax),%al
 3b8:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 3bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3be:	01 ca                	add    %ecx,%edx
 3c0:	88 02                	mov    %al,(%edx)
 3c2:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 3c5:	8b 55 10             	mov    0x10(%ebp),%edx
 3c8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 3cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3ce:	ba 00 00 00 00       	mov    $0x0,%edx
 3d3:	f7 75 d4             	divl   -0x2c(%ebp)
 3d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3d9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3dd:	75 c4                	jne    3a3 <printint+0x37>
  if(neg)
 3df:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3e3:	74 2c                	je     411 <printint+0xa5>
    buf[i++] = '-';
 3e5:	8d 55 dc             	lea    -0x24(%ebp),%edx
 3e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3eb:	01 d0                	add    %edx,%eax
 3ed:	c6 00 2d             	movb   $0x2d,(%eax)
 3f0:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 3f3:	eb 1c                	jmp    411 <printint+0xa5>
    putc(fd, buf[i]);
 3f5:	8d 55 dc             	lea    -0x24(%ebp),%edx
 3f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3fb:	01 d0                	add    %edx,%eax
 3fd:	8a 00                	mov    (%eax),%al
 3ff:	0f be c0             	movsbl %al,%eax
 402:	89 44 24 04          	mov    %eax,0x4(%esp)
 406:	8b 45 08             	mov    0x8(%ebp),%eax
 409:	89 04 24             	mov    %eax,(%esp)
 40c:	e8 33 ff ff ff       	call   344 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 411:	ff 4d f4             	decl   -0xc(%ebp)
 414:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 418:	79 db                	jns    3f5 <printint+0x89>
    putc(fd, buf[i]);
}
 41a:	c9                   	leave  
 41b:	c3                   	ret    

0000041c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 41c:	55                   	push   %ebp
 41d:	89 e5                	mov    %esp,%ebp
 41f:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 422:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 429:	8d 45 0c             	lea    0xc(%ebp),%eax
 42c:	83 c0 04             	add    $0x4,%eax
 42f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 432:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 439:	e9 78 01 00 00       	jmp    5b6 <printf+0x19a>
    c = fmt[i] & 0xff;
 43e:	8b 55 0c             	mov    0xc(%ebp),%edx
 441:	8b 45 f0             	mov    -0x10(%ebp),%eax
 444:	01 d0                	add    %edx,%eax
 446:	8a 00                	mov    (%eax),%al
 448:	0f be c0             	movsbl %al,%eax
 44b:	25 ff 00 00 00       	and    $0xff,%eax
 450:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 453:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 457:	75 2c                	jne    485 <printf+0x69>
      if(c == '%'){
 459:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 45d:	75 0c                	jne    46b <printf+0x4f>
        state = '%';
 45f:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 466:	e9 48 01 00 00       	jmp    5b3 <printf+0x197>
      } else {
        putc(fd, c);
 46b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 46e:	0f be c0             	movsbl %al,%eax
 471:	89 44 24 04          	mov    %eax,0x4(%esp)
 475:	8b 45 08             	mov    0x8(%ebp),%eax
 478:	89 04 24             	mov    %eax,(%esp)
 47b:	e8 c4 fe ff ff       	call   344 <putc>
 480:	e9 2e 01 00 00       	jmp    5b3 <printf+0x197>
      }
    } else if(state == '%'){
 485:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 489:	0f 85 24 01 00 00    	jne    5b3 <printf+0x197>
      if(c == 'd'){
 48f:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 493:	75 2d                	jne    4c2 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 495:	8b 45 e8             	mov    -0x18(%ebp),%eax
 498:	8b 00                	mov    (%eax),%eax
 49a:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4a1:	00 
 4a2:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4a9:	00 
 4aa:	89 44 24 04          	mov    %eax,0x4(%esp)
 4ae:	8b 45 08             	mov    0x8(%ebp),%eax
 4b1:	89 04 24             	mov    %eax,(%esp)
 4b4:	e8 b3 fe ff ff       	call   36c <printint>
        ap++;
 4b9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4bd:	e9 ea 00 00 00       	jmp    5ac <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 4c2:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4c6:	74 06                	je     4ce <printf+0xb2>
 4c8:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4cc:	75 2d                	jne    4fb <printf+0xdf>
        printint(fd, *ap, 16, 0);
 4ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4d1:	8b 00                	mov    (%eax),%eax
 4d3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 4da:	00 
 4db:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 4e2:	00 
 4e3:	89 44 24 04          	mov    %eax,0x4(%esp)
 4e7:	8b 45 08             	mov    0x8(%ebp),%eax
 4ea:	89 04 24             	mov    %eax,(%esp)
 4ed:	e8 7a fe ff ff       	call   36c <printint>
        ap++;
 4f2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4f6:	e9 b1 00 00 00       	jmp    5ac <printf+0x190>
      } else if(c == 's'){
 4fb:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 4ff:	75 43                	jne    544 <printf+0x128>
        s = (char*)*ap;
 501:	8b 45 e8             	mov    -0x18(%ebp),%eax
 504:	8b 00                	mov    (%eax),%eax
 506:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 509:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 50d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 511:	75 25                	jne    538 <printf+0x11c>
          s = "(null)";
 513:	c7 45 f4 e3 07 00 00 	movl   $0x7e3,-0xc(%ebp)
        while(*s != 0){
 51a:	eb 1c                	jmp    538 <printf+0x11c>
          putc(fd, *s);
 51c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 51f:	8a 00                	mov    (%eax),%al
 521:	0f be c0             	movsbl %al,%eax
 524:	89 44 24 04          	mov    %eax,0x4(%esp)
 528:	8b 45 08             	mov    0x8(%ebp),%eax
 52b:	89 04 24             	mov    %eax,(%esp)
 52e:	e8 11 fe ff ff       	call   344 <putc>
          s++;
 533:	ff 45 f4             	incl   -0xc(%ebp)
 536:	eb 01                	jmp    539 <printf+0x11d>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 538:	90                   	nop
 539:	8b 45 f4             	mov    -0xc(%ebp),%eax
 53c:	8a 00                	mov    (%eax),%al
 53e:	84 c0                	test   %al,%al
 540:	75 da                	jne    51c <printf+0x100>
 542:	eb 68                	jmp    5ac <printf+0x190>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 544:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 548:	75 1d                	jne    567 <printf+0x14b>
        putc(fd, *ap);
 54a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 54d:	8b 00                	mov    (%eax),%eax
 54f:	0f be c0             	movsbl %al,%eax
 552:	89 44 24 04          	mov    %eax,0x4(%esp)
 556:	8b 45 08             	mov    0x8(%ebp),%eax
 559:	89 04 24             	mov    %eax,(%esp)
 55c:	e8 e3 fd ff ff       	call   344 <putc>
        ap++;
 561:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 565:	eb 45                	jmp    5ac <printf+0x190>
      } else if(c == '%'){
 567:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 56b:	75 17                	jne    584 <printf+0x168>
        putc(fd, c);
 56d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 570:	0f be c0             	movsbl %al,%eax
 573:	89 44 24 04          	mov    %eax,0x4(%esp)
 577:	8b 45 08             	mov    0x8(%ebp),%eax
 57a:	89 04 24             	mov    %eax,(%esp)
 57d:	e8 c2 fd ff ff       	call   344 <putc>
 582:	eb 28                	jmp    5ac <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 584:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 58b:	00 
 58c:	8b 45 08             	mov    0x8(%ebp),%eax
 58f:	89 04 24             	mov    %eax,(%esp)
 592:	e8 ad fd ff ff       	call   344 <putc>
        putc(fd, c);
 597:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 59a:	0f be c0             	movsbl %al,%eax
 59d:	89 44 24 04          	mov    %eax,0x4(%esp)
 5a1:	8b 45 08             	mov    0x8(%ebp),%eax
 5a4:	89 04 24             	mov    %eax,(%esp)
 5a7:	e8 98 fd ff ff       	call   344 <putc>
      }
      state = 0;
 5ac:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5b3:	ff 45 f0             	incl   -0x10(%ebp)
 5b6:	8b 55 0c             	mov    0xc(%ebp),%edx
 5b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5bc:	01 d0                	add    %edx,%eax
 5be:	8a 00                	mov    (%eax),%al
 5c0:	84 c0                	test   %al,%al
 5c2:	0f 85 76 fe ff ff    	jne    43e <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5c8:	c9                   	leave  
 5c9:	c3                   	ret    
 5ca:	66 90                	xchg   %ax,%ax

000005cc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5cc:	55                   	push   %ebp
 5cd:	89 e5                	mov    %esp,%ebp
 5cf:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5d2:	8b 45 08             	mov    0x8(%ebp),%eax
 5d5:	83 e8 08             	sub    $0x8,%eax
 5d8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5db:	a1 64 0a 00 00       	mov    0xa64,%eax
 5e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5e3:	eb 24                	jmp    609 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5e8:	8b 00                	mov    (%eax),%eax
 5ea:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5ed:	77 12                	ja     601 <free+0x35>
 5ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5f2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5f5:	77 24                	ja     61b <free+0x4f>
 5f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5fa:	8b 00                	mov    (%eax),%eax
 5fc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5ff:	77 1a                	ja     61b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 601:	8b 45 fc             	mov    -0x4(%ebp),%eax
 604:	8b 00                	mov    (%eax),%eax
 606:	89 45 fc             	mov    %eax,-0x4(%ebp)
 609:	8b 45 f8             	mov    -0x8(%ebp),%eax
 60c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 60f:	76 d4                	jbe    5e5 <free+0x19>
 611:	8b 45 fc             	mov    -0x4(%ebp),%eax
 614:	8b 00                	mov    (%eax),%eax
 616:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 619:	76 ca                	jbe    5e5 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 61b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 61e:	8b 40 04             	mov    0x4(%eax),%eax
 621:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 628:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62b:	01 c2                	add    %eax,%edx
 62d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 630:	8b 00                	mov    (%eax),%eax
 632:	39 c2                	cmp    %eax,%edx
 634:	75 24                	jne    65a <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 636:	8b 45 f8             	mov    -0x8(%ebp),%eax
 639:	8b 50 04             	mov    0x4(%eax),%edx
 63c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63f:	8b 00                	mov    (%eax),%eax
 641:	8b 40 04             	mov    0x4(%eax),%eax
 644:	01 c2                	add    %eax,%edx
 646:	8b 45 f8             	mov    -0x8(%ebp),%eax
 649:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 64c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64f:	8b 00                	mov    (%eax),%eax
 651:	8b 10                	mov    (%eax),%edx
 653:	8b 45 f8             	mov    -0x8(%ebp),%eax
 656:	89 10                	mov    %edx,(%eax)
 658:	eb 0a                	jmp    664 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 65a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65d:	8b 10                	mov    (%eax),%edx
 65f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 662:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 664:	8b 45 fc             	mov    -0x4(%ebp),%eax
 667:	8b 40 04             	mov    0x4(%eax),%eax
 66a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 671:	8b 45 fc             	mov    -0x4(%ebp),%eax
 674:	01 d0                	add    %edx,%eax
 676:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 679:	75 20                	jne    69b <free+0xcf>
    p->s.size += bp->s.size;
 67b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67e:	8b 50 04             	mov    0x4(%eax),%edx
 681:	8b 45 f8             	mov    -0x8(%ebp),%eax
 684:	8b 40 04             	mov    0x4(%eax),%eax
 687:	01 c2                	add    %eax,%edx
 689:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 68f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 692:	8b 10                	mov    (%eax),%edx
 694:	8b 45 fc             	mov    -0x4(%ebp),%eax
 697:	89 10                	mov    %edx,(%eax)
 699:	eb 08                	jmp    6a3 <free+0xd7>
  } else
    p->s.ptr = bp;
 69b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6a1:	89 10                	mov    %edx,(%eax)
  freep = p;
 6a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a6:	a3 64 0a 00 00       	mov    %eax,0xa64
}
 6ab:	c9                   	leave  
 6ac:	c3                   	ret    

000006ad <morecore>:

static Header*
morecore(uint nu)
{
 6ad:	55                   	push   %ebp
 6ae:	89 e5                	mov    %esp,%ebp
 6b0:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6b3:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6ba:	77 07                	ja     6c3 <morecore+0x16>
    nu = 4096;
 6bc:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6c3:	8b 45 08             	mov    0x8(%ebp),%eax
 6c6:	c1 e0 03             	shl    $0x3,%eax
 6c9:	89 04 24             	mov    %eax,(%esp)
 6cc:	e8 43 fc ff ff       	call   314 <sbrk>
 6d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6d4:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6d8:	75 07                	jne    6e1 <morecore+0x34>
    return 0;
 6da:	b8 00 00 00 00       	mov    $0x0,%eax
 6df:	eb 22                	jmp    703 <morecore+0x56>
  hp = (Header*)p;
 6e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6ea:	8b 55 08             	mov    0x8(%ebp),%edx
 6ed:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6f3:	83 c0 08             	add    $0x8,%eax
 6f6:	89 04 24             	mov    %eax,(%esp)
 6f9:	e8 ce fe ff ff       	call   5cc <free>
  return freep;
 6fe:	a1 64 0a 00 00       	mov    0xa64,%eax
}
 703:	c9                   	leave  
 704:	c3                   	ret    

00000705 <malloc>:

void*
malloc(uint nbytes)
{
 705:	55                   	push   %ebp
 706:	89 e5                	mov    %esp,%ebp
 708:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 70b:	8b 45 08             	mov    0x8(%ebp),%eax
 70e:	83 c0 07             	add    $0x7,%eax
 711:	c1 e8 03             	shr    $0x3,%eax
 714:	40                   	inc    %eax
 715:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 718:	a1 64 0a 00 00       	mov    0xa64,%eax
 71d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 720:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 724:	75 23                	jne    749 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 726:	c7 45 f0 5c 0a 00 00 	movl   $0xa5c,-0x10(%ebp)
 72d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 730:	a3 64 0a 00 00       	mov    %eax,0xa64
 735:	a1 64 0a 00 00       	mov    0xa64,%eax
 73a:	a3 5c 0a 00 00       	mov    %eax,0xa5c
    base.s.size = 0;
 73f:	c7 05 60 0a 00 00 00 	movl   $0x0,0xa60
 746:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 749:	8b 45 f0             	mov    -0x10(%ebp),%eax
 74c:	8b 00                	mov    (%eax),%eax
 74e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 751:	8b 45 f4             	mov    -0xc(%ebp),%eax
 754:	8b 40 04             	mov    0x4(%eax),%eax
 757:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 75a:	72 4d                	jb     7a9 <malloc+0xa4>
      if(p->s.size == nunits)
 75c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 75f:	8b 40 04             	mov    0x4(%eax),%eax
 762:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 765:	75 0c                	jne    773 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 767:	8b 45 f4             	mov    -0xc(%ebp),%eax
 76a:	8b 10                	mov    (%eax),%edx
 76c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 76f:	89 10                	mov    %edx,(%eax)
 771:	eb 26                	jmp    799 <malloc+0x94>
      else {
        p->s.size -= nunits;
 773:	8b 45 f4             	mov    -0xc(%ebp),%eax
 776:	8b 40 04             	mov    0x4(%eax),%eax
 779:	89 c2                	mov    %eax,%edx
 77b:	2b 55 ec             	sub    -0x14(%ebp),%edx
 77e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 781:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 784:	8b 45 f4             	mov    -0xc(%ebp),%eax
 787:	8b 40 04             	mov    0x4(%eax),%eax
 78a:	c1 e0 03             	shl    $0x3,%eax
 78d:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 790:	8b 45 f4             	mov    -0xc(%ebp),%eax
 793:	8b 55 ec             	mov    -0x14(%ebp),%edx
 796:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 799:	8b 45 f0             	mov    -0x10(%ebp),%eax
 79c:	a3 64 0a 00 00       	mov    %eax,0xa64
      return (void*)(p + 1);
 7a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a4:	83 c0 08             	add    $0x8,%eax
 7a7:	eb 38                	jmp    7e1 <malloc+0xdc>
    }
    if(p == freep)
 7a9:	a1 64 0a 00 00       	mov    0xa64,%eax
 7ae:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7b1:	75 1b                	jne    7ce <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 7b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7b6:	89 04 24             	mov    %eax,(%esp)
 7b9:	e8 ef fe ff ff       	call   6ad <morecore>
 7be:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7c5:	75 07                	jne    7ce <malloc+0xc9>
        return 0;
 7c7:	b8 00 00 00 00       	mov    $0x0,%eax
 7cc:	eb 13                	jmp    7e1 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d7:	8b 00                	mov    (%eax),%eax
 7d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 7dc:	e9 70 ff ff ff       	jmp    751 <malloc+0x4c>
}
 7e1:	c9                   	leave  
 7e2:	c3                   	ret    
