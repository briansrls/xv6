
_echo:     file format elf32-i386


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

  for(i = 1; i < argc; i++)
   9:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  10:	00 
  11:	eb 48                	jmp    5b <main+0x5b>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  13:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  17:	40                   	inc    %eax
  18:	3b 45 08             	cmp    0x8(%ebp),%eax
  1b:	7d 07                	jge    24 <main+0x24>
  1d:	b8 3f 08 00 00       	mov    $0x83f,%eax
  22:	eb 05                	jmp    29 <main+0x29>
  24:	b8 41 08 00 00       	mov    $0x841,%eax
  29:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  2d:	8d 0c 95 00 00 00 00 	lea    0x0(,%edx,4),%ecx
  34:	8b 55 0c             	mov    0xc(%ebp),%edx
  37:	01 ca                	add    %ecx,%edx
  39:	8b 12                	mov    (%edx),%edx
  3b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  3f:	89 54 24 08          	mov    %edx,0x8(%esp)
  43:	c7 44 24 04 43 08 00 	movl   $0x843,0x4(%esp)
  4a:	00 
  4b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  52:	e8 21 04 00 00       	call   478 <printf>
int
main(int argc, char *argv[])
{
  int i;

  for(i = 1; i < argc; i++)
  57:	ff 44 24 1c          	incl   0x1c(%esp)
  5b:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  5f:	3b 45 08             	cmp    0x8(%ebp),%eax
  62:	7c af                	jl     13 <main+0x13>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  exit();
  64:	e8 7f 02 00 00       	call   2e8 <exit>
  69:	66 90                	xchg   %ax,%ax
  6b:	90                   	nop

0000006c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  6c:	55                   	push   %ebp
  6d:	89 e5                	mov    %esp,%ebp
  6f:	57                   	push   %edi
  70:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  71:	8b 4d 08             	mov    0x8(%ebp),%ecx
  74:	8b 55 10             	mov    0x10(%ebp),%edx
  77:	8b 45 0c             	mov    0xc(%ebp),%eax
  7a:	89 cb                	mov    %ecx,%ebx
  7c:	89 df                	mov    %ebx,%edi
  7e:	89 d1                	mov    %edx,%ecx
  80:	fc                   	cld    
  81:	f3 aa                	rep stos %al,%es:(%edi)
  83:	89 ca                	mov    %ecx,%edx
  85:	89 fb                	mov    %edi,%ebx
  87:	89 5d 08             	mov    %ebx,0x8(%ebp)
  8a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  8d:	5b                   	pop    %ebx
  8e:	5f                   	pop    %edi
  8f:	5d                   	pop    %ebp
  90:	c3                   	ret    

00000091 <strcpy>:
#include "x86.h"
#include "signal.h"

char*
strcpy(char *s, char *t)
{
  91:	55                   	push   %ebp
  92:	89 e5                	mov    %esp,%ebp
  94:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  97:	8b 45 08             	mov    0x8(%ebp),%eax
  9a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  9d:	90                   	nop
  9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  a1:	8a 10                	mov    (%eax),%dl
  a3:	8b 45 08             	mov    0x8(%ebp),%eax
  a6:	88 10                	mov    %dl,(%eax)
  a8:	8b 45 08             	mov    0x8(%ebp),%eax
  ab:	8a 00                	mov    (%eax),%al
  ad:	84 c0                	test   %al,%al
  af:	0f 95 c0             	setne  %al
  b2:	ff 45 08             	incl   0x8(%ebp)
  b5:	ff 45 0c             	incl   0xc(%ebp)
  b8:	84 c0                	test   %al,%al
  ba:	75 e2                	jne    9e <strcpy+0xd>
    ;
  return os;
  bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  bf:	c9                   	leave  
  c0:	c3                   	ret    

000000c1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c1:	55                   	push   %ebp
  c2:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  c4:	eb 06                	jmp    cc <strcmp+0xb>
    p++, q++;
  c6:	ff 45 08             	incl   0x8(%ebp)
  c9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  cc:	8b 45 08             	mov    0x8(%ebp),%eax
  cf:	8a 00                	mov    (%eax),%al
  d1:	84 c0                	test   %al,%al
  d3:	74 0e                	je     e3 <strcmp+0x22>
  d5:	8b 45 08             	mov    0x8(%ebp),%eax
  d8:	8a 10                	mov    (%eax),%dl
  da:	8b 45 0c             	mov    0xc(%ebp),%eax
  dd:	8a 00                	mov    (%eax),%al
  df:	38 c2                	cmp    %al,%dl
  e1:	74 e3                	je     c6 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  e3:	8b 45 08             	mov    0x8(%ebp),%eax
  e6:	8a 00                	mov    (%eax),%al
  e8:	0f b6 d0             	movzbl %al,%edx
  eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  ee:	8a 00                	mov    (%eax),%al
  f0:	0f b6 c0             	movzbl %al,%eax
  f3:	89 d1                	mov    %edx,%ecx
  f5:	29 c1                	sub    %eax,%ecx
  f7:	89 c8                	mov    %ecx,%eax
}
  f9:	5d                   	pop    %ebp
  fa:	c3                   	ret    

000000fb <strlen>:

uint
strlen(char *s)
{
  fb:	55                   	push   %ebp
  fc:	89 e5                	mov    %esp,%ebp
  fe:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 101:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 108:	eb 03                	jmp    10d <strlen+0x12>
 10a:	ff 45 fc             	incl   -0x4(%ebp)
 10d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 110:	8b 45 08             	mov    0x8(%ebp),%eax
 113:	01 d0                	add    %edx,%eax
 115:	8a 00                	mov    (%eax),%al
 117:	84 c0                	test   %al,%al
 119:	75 ef                	jne    10a <strlen+0xf>
    ;
  return n;
 11b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 11e:	c9                   	leave  
 11f:	c3                   	ret    

00000120 <memset>:

void*
memset(void *dst, int c, uint n)
{
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
 123:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 126:	8b 45 10             	mov    0x10(%ebp),%eax
 129:	89 44 24 08          	mov    %eax,0x8(%esp)
 12d:	8b 45 0c             	mov    0xc(%ebp),%eax
 130:	89 44 24 04          	mov    %eax,0x4(%esp)
 134:	8b 45 08             	mov    0x8(%ebp),%eax
 137:	89 04 24             	mov    %eax,(%esp)
 13a:	e8 2d ff ff ff       	call   6c <stosb>
  return dst;
 13f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 142:	c9                   	leave  
 143:	c3                   	ret    

00000144 <strchr>:

char*
strchr(const char *s, char c)
{
 144:	55                   	push   %ebp
 145:	89 e5                	mov    %esp,%ebp
 147:	83 ec 04             	sub    $0x4,%esp
 14a:	8b 45 0c             	mov    0xc(%ebp),%eax
 14d:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 150:	eb 12                	jmp    164 <strchr+0x20>
    if(*s == c)
 152:	8b 45 08             	mov    0x8(%ebp),%eax
 155:	8a 00                	mov    (%eax),%al
 157:	3a 45 fc             	cmp    -0x4(%ebp),%al
 15a:	75 05                	jne    161 <strchr+0x1d>
      return (char*)s;
 15c:	8b 45 08             	mov    0x8(%ebp),%eax
 15f:	eb 11                	jmp    172 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 161:	ff 45 08             	incl   0x8(%ebp)
 164:	8b 45 08             	mov    0x8(%ebp),%eax
 167:	8a 00                	mov    (%eax),%al
 169:	84 c0                	test   %al,%al
 16b:	75 e5                	jne    152 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 16d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 172:	c9                   	leave  
 173:	c3                   	ret    

00000174 <gets>:

char*
gets(char *buf, int max)
{
 174:	55                   	push   %ebp
 175:	89 e5                	mov    %esp,%ebp
 177:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 17a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 181:	eb 42                	jmp    1c5 <gets+0x51>
    cc = read(0, &c, 1);
 183:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 18a:	00 
 18b:	8d 45 ef             	lea    -0x11(%ebp),%eax
 18e:	89 44 24 04          	mov    %eax,0x4(%esp)
 192:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 199:	e8 62 01 00 00       	call   300 <read>
 19e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1a1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1a5:	7e 29                	jle    1d0 <gets+0x5c>
      break;
    buf[i++] = c;
 1a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1aa:	8b 45 08             	mov    0x8(%ebp),%eax
 1ad:	01 c2                	add    %eax,%edx
 1af:	8a 45 ef             	mov    -0x11(%ebp),%al
 1b2:	88 02                	mov    %al,(%edx)
 1b4:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 1b7:	8a 45 ef             	mov    -0x11(%ebp),%al
 1ba:	3c 0a                	cmp    $0xa,%al
 1bc:	74 13                	je     1d1 <gets+0x5d>
 1be:	8a 45 ef             	mov    -0x11(%ebp),%al
 1c1:	3c 0d                	cmp    $0xd,%al
 1c3:	74 0c                	je     1d1 <gets+0x5d>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c8:	40                   	inc    %eax
 1c9:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1cc:	7c b5                	jl     183 <gets+0xf>
 1ce:	eb 01                	jmp    1d1 <gets+0x5d>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1d0:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1d4:	8b 45 08             	mov    0x8(%ebp),%eax
 1d7:	01 d0                	add    %edx,%eax
 1d9:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1dc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1df:	c9                   	leave  
 1e0:	c3                   	ret    

000001e1 <stat>:

int
stat(char *n, struct stat *st)
{
 1e1:	55                   	push   %ebp
 1e2:	89 e5                	mov    %esp,%ebp
 1e4:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1ee:	00 
 1ef:	8b 45 08             	mov    0x8(%ebp),%eax
 1f2:	89 04 24             	mov    %eax,(%esp)
 1f5:	e8 2e 01 00 00       	call   328 <open>
 1fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 201:	79 07                	jns    20a <stat+0x29>
    return -1;
 203:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 208:	eb 23                	jmp    22d <stat+0x4c>
  r = fstat(fd, st);
 20a:	8b 45 0c             	mov    0xc(%ebp),%eax
 20d:	89 44 24 04          	mov    %eax,0x4(%esp)
 211:	8b 45 f4             	mov    -0xc(%ebp),%eax
 214:	89 04 24             	mov    %eax,(%esp)
 217:	e8 24 01 00 00       	call   340 <fstat>
 21c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 21f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 222:	89 04 24             	mov    %eax,(%esp)
 225:	e8 e6 00 00 00       	call   310 <close>
  return r;
 22a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 22d:	c9                   	leave  
 22e:	c3                   	ret    

0000022f <atoi>:

int
atoi(const char *s)
{
 22f:	55                   	push   %ebp
 230:	89 e5                	mov    %esp,%ebp
 232:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 235:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 23c:	eb 21                	jmp    25f <atoi+0x30>
    n = n*10 + *s++ - '0';
 23e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 241:	89 d0                	mov    %edx,%eax
 243:	c1 e0 02             	shl    $0x2,%eax
 246:	01 d0                	add    %edx,%eax
 248:	d1 e0                	shl    %eax
 24a:	89 c2                	mov    %eax,%edx
 24c:	8b 45 08             	mov    0x8(%ebp),%eax
 24f:	8a 00                	mov    (%eax),%al
 251:	0f be c0             	movsbl %al,%eax
 254:	01 d0                	add    %edx,%eax
 256:	83 e8 30             	sub    $0x30,%eax
 259:	89 45 fc             	mov    %eax,-0x4(%ebp)
 25c:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 25f:	8b 45 08             	mov    0x8(%ebp),%eax
 262:	8a 00                	mov    (%eax),%al
 264:	3c 2f                	cmp    $0x2f,%al
 266:	7e 09                	jle    271 <atoi+0x42>
 268:	8b 45 08             	mov    0x8(%ebp),%eax
 26b:	8a 00                	mov    (%eax),%al
 26d:	3c 39                	cmp    $0x39,%al
 26f:	7e cd                	jle    23e <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 271:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 274:	c9                   	leave  
 275:	c3                   	ret    

00000276 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 276:	55                   	push   %ebp
 277:	89 e5                	mov    %esp,%ebp
 279:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 27c:	8b 45 08             	mov    0x8(%ebp),%eax
 27f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 282:	8b 45 0c             	mov    0xc(%ebp),%eax
 285:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 288:	eb 10                	jmp    29a <memmove+0x24>
    *dst++ = *src++;
 28a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 28d:	8a 10                	mov    (%eax),%dl
 28f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 292:	88 10                	mov    %dl,(%eax)
 294:	ff 45 fc             	incl   -0x4(%ebp)
 297:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 29a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 29e:	0f 9f c0             	setg   %al
 2a1:	ff 4d 10             	decl   0x10(%ebp)
 2a4:	84 c0                	test   %al,%al
 2a6:	75 e2                	jne    28a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2a8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2ab:	c9                   	leave  
 2ac:	c3                   	ret    

000002ad <trampoline>:
 2ad:	5a                   	pop    %edx
 2ae:	59                   	pop    %ecx
 2af:	58                   	pop    %eax
 2b0:	03 25 04 00 00 00    	add    0x4,%esp
 2b6:	c9                   	leave  
 2b7:	c3                   	ret    

000002b8 <signal>:
	"addl 4, %esp\n\t"
	"leave\n\t"
	"ret\n\t"
);
int signal(int signum, sighandler_t handler) 
{
 2b8:	55                   	push   %ebp
 2b9:	89 e5                	mov    %esp,%ebp
 2bb:	83 ec 18             	sub    $0x18,%esp
	register_signal_handler(signum, handler, trampoline);
 2be:	c7 44 24 08 ad 02 00 	movl   $0x2ad,0x8(%esp)
 2c5:	00 
 2c6:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c9:	89 44 24 04          	mov    %eax,0x4(%esp)
 2cd:	8b 45 08             	mov    0x8(%ebp),%eax
 2d0:	89 04 24             	mov    %eax,(%esp)
 2d3:	e8 b8 00 00 00       	call   390 <register_signal_handler>
	return 0;
 2d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2dd:	c9                   	leave  
 2de:	c3                   	ret    
 2df:	90                   	nop

000002e0 <fork>:
 2e0:	b8 01 00 00 00       	mov    $0x1,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <exit>:
 2e8:	b8 02 00 00 00       	mov    $0x2,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <wait>:
 2f0:	b8 03 00 00 00       	mov    $0x3,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <pipe>:
 2f8:	b8 04 00 00 00       	mov    $0x4,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <read>:
 300:	b8 05 00 00 00       	mov    $0x5,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <write>:
 308:	b8 10 00 00 00       	mov    $0x10,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <close>:
 310:	b8 15 00 00 00       	mov    $0x15,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <kill>:
 318:	b8 06 00 00 00       	mov    $0x6,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <exec>:
 320:	b8 07 00 00 00       	mov    $0x7,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <open>:
 328:	b8 0f 00 00 00       	mov    $0xf,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <mknod>:
 330:	b8 11 00 00 00       	mov    $0x11,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <unlink>:
 338:	b8 12 00 00 00       	mov    $0x12,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <fstat>:
 340:	b8 08 00 00 00       	mov    $0x8,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <link>:
 348:	b8 13 00 00 00       	mov    $0x13,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <mkdir>:
 350:	b8 14 00 00 00       	mov    $0x14,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <chdir>:
 358:	b8 09 00 00 00       	mov    $0x9,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <dup>:
 360:	b8 0a 00 00 00       	mov    $0xa,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <getpid>:
 368:	b8 0b 00 00 00       	mov    $0xb,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <sbrk>:
 370:	b8 0c 00 00 00       	mov    $0xc,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <sleep>:
 378:	b8 0d 00 00 00       	mov    $0xd,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <uptime>:
 380:	b8 0e 00 00 00       	mov    $0xe,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <halt>:
 388:	b8 16 00 00 00       	mov    $0x16,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <register_signal_handler>:
 390:	b8 17 00 00 00       	mov    $0x17,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <alarm>:
 398:	b8 18 00 00 00       	mov    $0x18,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3a0:	55                   	push   %ebp
 3a1:	89 e5                	mov    %esp,%ebp
 3a3:	83 ec 28             	sub    $0x28,%esp
 3a6:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a9:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3ac:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3b3:	00 
 3b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3b7:	89 44 24 04          	mov    %eax,0x4(%esp)
 3bb:	8b 45 08             	mov    0x8(%ebp),%eax
 3be:	89 04 24             	mov    %eax,(%esp)
 3c1:	e8 42 ff ff ff       	call   308 <write>
}
 3c6:	c9                   	leave  
 3c7:	c3                   	ret    

000003c8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3c8:	55                   	push   %ebp
 3c9:	89 e5                	mov    %esp,%ebp
 3cb:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3ce:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3d5:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3d9:	74 17                	je     3f2 <printint+0x2a>
 3db:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3df:	79 11                	jns    3f2 <printint+0x2a>
    neg = 1;
 3e1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3e8:	8b 45 0c             	mov    0xc(%ebp),%eax
 3eb:	f7 d8                	neg    %eax
 3ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3f0:	eb 06                	jmp    3f8 <printint+0x30>
  } else {
    x = xx;
 3f2:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3ff:	8b 4d 10             	mov    0x10(%ebp),%ecx
 402:	8b 45 ec             	mov    -0x14(%ebp),%eax
 405:	ba 00 00 00 00       	mov    $0x0,%edx
 40a:	f7 f1                	div    %ecx
 40c:	89 d0                	mov    %edx,%eax
 40e:	8a 80 ac 0a 00 00    	mov    0xaac(%eax),%al
 414:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 417:	8b 55 f4             	mov    -0xc(%ebp),%edx
 41a:	01 ca                	add    %ecx,%edx
 41c:	88 02                	mov    %al,(%edx)
 41e:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 421:	8b 55 10             	mov    0x10(%ebp),%edx
 424:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 427:	8b 45 ec             	mov    -0x14(%ebp),%eax
 42a:	ba 00 00 00 00       	mov    $0x0,%edx
 42f:	f7 75 d4             	divl   -0x2c(%ebp)
 432:	89 45 ec             	mov    %eax,-0x14(%ebp)
 435:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 439:	75 c4                	jne    3ff <printint+0x37>
  if(neg)
 43b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 43f:	74 2c                	je     46d <printint+0xa5>
    buf[i++] = '-';
 441:	8d 55 dc             	lea    -0x24(%ebp),%edx
 444:	8b 45 f4             	mov    -0xc(%ebp),%eax
 447:	01 d0                	add    %edx,%eax
 449:	c6 00 2d             	movb   $0x2d,(%eax)
 44c:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 44f:	eb 1c                	jmp    46d <printint+0xa5>
    putc(fd, buf[i]);
 451:	8d 55 dc             	lea    -0x24(%ebp),%edx
 454:	8b 45 f4             	mov    -0xc(%ebp),%eax
 457:	01 d0                	add    %edx,%eax
 459:	8a 00                	mov    (%eax),%al
 45b:	0f be c0             	movsbl %al,%eax
 45e:	89 44 24 04          	mov    %eax,0x4(%esp)
 462:	8b 45 08             	mov    0x8(%ebp),%eax
 465:	89 04 24             	mov    %eax,(%esp)
 468:	e8 33 ff ff ff       	call   3a0 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 46d:	ff 4d f4             	decl   -0xc(%ebp)
 470:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 474:	79 db                	jns    451 <printint+0x89>
    putc(fd, buf[i]);
}
 476:	c9                   	leave  
 477:	c3                   	ret    

00000478 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 478:	55                   	push   %ebp
 479:	89 e5                	mov    %esp,%ebp
 47b:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 47e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 485:	8d 45 0c             	lea    0xc(%ebp),%eax
 488:	83 c0 04             	add    $0x4,%eax
 48b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 48e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 495:	e9 78 01 00 00       	jmp    612 <printf+0x19a>
    c = fmt[i] & 0xff;
 49a:	8b 55 0c             	mov    0xc(%ebp),%edx
 49d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4a0:	01 d0                	add    %edx,%eax
 4a2:	8a 00                	mov    (%eax),%al
 4a4:	0f be c0             	movsbl %al,%eax
 4a7:	25 ff 00 00 00       	and    $0xff,%eax
 4ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4af:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4b3:	75 2c                	jne    4e1 <printf+0x69>
      if(c == '%'){
 4b5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4b9:	75 0c                	jne    4c7 <printf+0x4f>
        state = '%';
 4bb:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4c2:	e9 48 01 00 00       	jmp    60f <printf+0x197>
      } else {
        putc(fd, c);
 4c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4ca:	0f be c0             	movsbl %al,%eax
 4cd:	89 44 24 04          	mov    %eax,0x4(%esp)
 4d1:	8b 45 08             	mov    0x8(%ebp),%eax
 4d4:	89 04 24             	mov    %eax,(%esp)
 4d7:	e8 c4 fe ff ff       	call   3a0 <putc>
 4dc:	e9 2e 01 00 00       	jmp    60f <printf+0x197>
      }
    } else if(state == '%'){
 4e1:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4e5:	0f 85 24 01 00 00    	jne    60f <printf+0x197>
      if(c == 'd'){
 4eb:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4ef:	75 2d                	jne    51e <printf+0xa6>
        printint(fd, *ap, 10, 1);
 4f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4f4:	8b 00                	mov    (%eax),%eax
 4f6:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4fd:	00 
 4fe:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 505:	00 
 506:	89 44 24 04          	mov    %eax,0x4(%esp)
 50a:	8b 45 08             	mov    0x8(%ebp),%eax
 50d:	89 04 24             	mov    %eax,(%esp)
 510:	e8 b3 fe ff ff       	call   3c8 <printint>
        ap++;
 515:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 519:	e9 ea 00 00 00       	jmp    608 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 51e:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 522:	74 06                	je     52a <printf+0xb2>
 524:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 528:	75 2d                	jne    557 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 52a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 52d:	8b 00                	mov    (%eax),%eax
 52f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 536:	00 
 537:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 53e:	00 
 53f:	89 44 24 04          	mov    %eax,0x4(%esp)
 543:	8b 45 08             	mov    0x8(%ebp),%eax
 546:	89 04 24             	mov    %eax,(%esp)
 549:	e8 7a fe ff ff       	call   3c8 <printint>
        ap++;
 54e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 552:	e9 b1 00 00 00       	jmp    608 <printf+0x190>
      } else if(c == 's'){
 557:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 55b:	75 43                	jne    5a0 <printf+0x128>
        s = (char*)*ap;
 55d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 560:	8b 00                	mov    (%eax),%eax
 562:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 565:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 569:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 56d:	75 25                	jne    594 <printf+0x11c>
          s = "(null)";
 56f:	c7 45 f4 48 08 00 00 	movl   $0x848,-0xc(%ebp)
        while(*s != 0){
 576:	eb 1c                	jmp    594 <printf+0x11c>
          putc(fd, *s);
 578:	8b 45 f4             	mov    -0xc(%ebp),%eax
 57b:	8a 00                	mov    (%eax),%al
 57d:	0f be c0             	movsbl %al,%eax
 580:	89 44 24 04          	mov    %eax,0x4(%esp)
 584:	8b 45 08             	mov    0x8(%ebp),%eax
 587:	89 04 24             	mov    %eax,(%esp)
 58a:	e8 11 fe ff ff       	call   3a0 <putc>
          s++;
 58f:	ff 45 f4             	incl   -0xc(%ebp)
 592:	eb 01                	jmp    595 <printf+0x11d>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 594:	90                   	nop
 595:	8b 45 f4             	mov    -0xc(%ebp),%eax
 598:	8a 00                	mov    (%eax),%al
 59a:	84 c0                	test   %al,%al
 59c:	75 da                	jne    578 <printf+0x100>
 59e:	eb 68                	jmp    608 <printf+0x190>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5a0:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5a4:	75 1d                	jne    5c3 <printf+0x14b>
        putc(fd, *ap);
 5a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5a9:	8b 00                	mov    (%eax),%eax
 5ab:	0f be c0             	movsbl %al,%eax
 5ae:	89 44 24 04          	mov    %eax,0x4(%esp)
 5b2:	8b 45 08             	mov    0x8(%ebp),%eax
 5b5:	89 04 24             	mov    %eax,(%esp)
 5b8:	e8 e3 fd ff ff       	call   3a0 <putc>
        ap++;
 5bd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5c1:	eb 45                	jmp    608 <printf+0x190>
      } else if(c == '%'){
 5c3:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5c7:	75 17                	jne    5e0 <printf+0x168>
        putc(fd, c);
 5c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5cc:	0f be c0             	movsbl %al,%eax
 5cf:	89 44 24 04          	mov    %eax,0x4(%esp)
 5d3:	8b 45 08             	mov    0x8(%ebp),%eax
 5d6:	89 04 24             	mov    %eax,(%esp)
 5d9:	e8 c2 fd ff ff       	call   3a0 <putc>
 5de:	eb 28                	jmp    608 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5e0:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5e7:	00 
 5e8:	8b 45 08             	mov    0x8(%ebp),%eax
 5eb:	89 04 24             	mov    %eax,(%esp)
 5ee:	e8 ad fd ff ff       	call   3a0 <putc>
        putc(fd, c);
 5f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5f6:	0f be c0             	movsbl %al,%eax
 5f9:	89 44 24 04          	mov    %eax,0x4(%esp)
 5fd:	8b 45 08             	mov    0x8(%ebp),%eax
 600:	89 04 24             	mov    %eax,(%esp)
 603:	e8 98 fd ff ff       	call   3a0 <putc>
      }
      state = 0;
 608:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 60f:	ff 45 f0             	incl   -0x10(%ebp)
 612:	8b 55 0c             	mov    0xc(%ebp),%edx
 615:	8b 45 f0             	mov    -0x10(%ebp),%eax
 618:	01 d0                	add    %edx,%eax
 61a:	8a 00                	mov    (%eax),%al
 61c:	84 c0                	test   %al,%al
 61e:	0f 85 76 fe ff ff    	jne    49a <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 624:	c9                   	leave  
 625:	c3                   	ret    
 626:	66 90                	xchg   %ax,%ax

00000628 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 628:	55                   	push   %ebp
 629:	89 e5                	mov    %esp,%ebp
 62b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 62e:	8b 45 08             	mov    0x8(%ebp),%eax
 631:	83 e8 08             	sub    $0x8,%eax
 634:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 637:	a1 c8 0a 00 00       	mov    0xac8,%eax
 63c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 63f:	eb 24                	jmp    665 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 641:	8b 45 fc             	mov    -0x4(%ebp),%eax
 644:	8b 00                	mov    (%eax),%eax
 646:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 649:	77 12                	ja     65d <free+0x35>
 64b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 64e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 651:	77 24                	ja     677 <free+0x4f>
 653:	8b 45 fc             	mov    -0x4(%ebp),%eax
 656:	8b 00                	mov    (%eax),%eax
 658:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 65b:	77 1a                	ja     677 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 65d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 660:	8b 00                	mov    (%eax),%eax
 662:	89 45 fc             	mov    %eax,-0x4(%ebp)
 665:	8b 45 f8             	mov    -0x8(%ebp),%eax
 668:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 66b:	76 d4                	jbe    641 <free+0x19>
 66d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 670:	8b 00                	mov    (%eax),%eax
 672:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 675:	76 ca                	jbe    641 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 677:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67a:	8b 40 04             	mov    0x4(%eax),%eax
 67d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 684:	8b 45 f8             	mov    -0x8(%ebp),%eax
 687:	01 c2                	add    %eax,%edx
 689:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68c:	8b 00                	mov    (%eax),%eax
 68e:	39 c2                	cmp    %eax,%edx
 690:	75 24                	jne    6b6 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 692:	8b 45 f8             	mov    -0x8(%ebp),%eax
 695:	8b 50 04             	mov    0x4(%eax),%edx
 698:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69b:	8b 00                	mov    (%eax),%eax
 69d:	8b 40 04             	mov    0x4(%eax),%eax
 6a0:	01 c2                	add    %eax,%edx
 6a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a5:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ab:	8b 00                	mov    (%eax),%eax
 6ad:	8b 10                	mov    (%eax),%edx
 6af:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b2:	89 10                	mov    %edx,(%eax)
 6b4:	eb 0a                	jmp    6c0 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b9:	8b 10                	mov    (%eax),%edx
 6bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6be:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c3:	8b 40 04             	mov    0x4(%eax),%eax
 6c6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d0:	01 d0                	add    %edx,%eax
 6d2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6d5:	75 20                	jne    6f7 <free+0xcf>
    p->s.size += bp->s.size;
 6d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6da:	8b 50 04             	mov    0x4(%eax),%edx
 6dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e0:	8b 40 04             	mov    0x4(%eax),%eax
 6e3:	01 c2                	add    %eax,%edx
 6e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e8:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ee:	8b 10                	mov    (%eax),%edx
 6f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f3:	89 10                	mov    %edx,(%eax)
 6f5:	eb 08                	jmp    6ff <free+0xd7>
  } else
    p->s.ptr = bp;
 6f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fa:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6fd:	89 10                	mov    %edx,(%eax)
  freep = p;
 6ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
 702:	a3 c8 0a 00 00       	mov    %eax,0xac8
}
 707:	c9                   	leave  
 708:	c3                   	ret    

00000709 <morecore>:

static Header*
morecore(uint nu)
{
 709:	55                   	push   %ebp
 70a:	89 e5                	mov    %esp,%ebp
 70c:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 70f:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 716:	77 07                	ja     71f <morecore+0x16>
    nu = 4096;
 718:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 71f:	8b 45 08             	mov    0x8(%ebp),%eax
 722:	c1 e0 03             	shl    $0x3,%eax
 725:	89 04 24             	mov    %eax,(%esp)
 728:	e8 43 fc ff ff       	call   370 <sbrk>
 72d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 730:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 734:	75 07                	jne    73d <morecore+0x34>
    return 0;
 736:	b8 00 00 00 00       	mov    $0x0,%eax
 73b:	eb 22                	jmp    75f <morecore+0x56>
  hp = (Header*)p;
 73d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 740:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 743:	8b 45 f0             	mov    -0x10(%ebp),%eax
 746:	8b 55 08             	mov    0x8(%ebp),%edx
 749:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 74c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 74f:	83 c0 08             	add    $0x8,%eax
 752:	89 04 24             	mov    %eax,(%esp)
 755:	e8 ce fe ff ff       	call   628 <free>
  return freep;
 75a:	a1 c8 0a 00 00       	mov    0xac8,%eax
}
 75f:	c9                   	leave  
 760:	c3                   	ret    

00000761 <malloc>:

void*
malloc(uint nbytes)
{
 761:	55                   	push   %ebp
 762:	89 e5                	mov    %esp,%ebp
 764:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 767:	8b 45 08             	mov    0x8(%ebp),%eax
 76a:	83 c0 07             	add    $0x7,%eax
 76d:	c1 e8 03             	shr    $0x3,%eax
 770:	40                   	inc    %eax
 771:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 774:	a1 c8 0a 00 00       	mov    0xac8,%eax
 779:	89 45 f0             	mov    %eax,-0x10(%ebp)
 77c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 780:	75 23                	jne    7a5 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 782:	c7 45 f0 c0 0a 00 00 	movl   $0xac0,-0x10(%ebp)
 789:	8b 45 f0             	mov    -0x10(%ebp),%eax
 78c:	a3 c8 0a 00 00       	mov    %eax,0xac8
 791:	a1 c8 0a 00 00       	mov    0xac8,%eax
 796:	a3 c0 0a 00 00       	mov    %eax,0xac0
    base.s.size = 0;
 79b:	c7 05 c4 0a 00 00 00 	movl   $0x0,0xac4
 7a2:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a8:	8b 00                	mov    (%eax),%eax
 7aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b0:	8b 40 04             	mov    0x4(%eax),%eax
 7b3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7b6:	72 4d                	jb     805 <malloc+0xa4>
      if(p->s.size == nunits)
 7b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bb:	8b 40 04             	mov    0x4(%eax),%eax
 7be:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7c1:	75 0c                	jne    7cf <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 7c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c6:	8b 10                	mov    (%eax),%edx
 7c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7cb:	89 10                	mov    %edx,(%eax)
 7cd:	eb 26                	jmp    7f5 <malloc+0x94>
      else {
        p->s.size -= nunits;
 7cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d2:	8b 40 04             	mov    0x4(%eax),%eax
 7d5:	89 c2                	mov    %eax,%edx
 7d7:	2b 55 ec             	sub    -0x14(%ebp),%edx
 7da:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7dd:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e3:	8b 40 04             	mov    0x4(%eax),%eax
 7e6:	c1 e0 03             	shl    $0x3,%eax
 7e9:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ef:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7f2:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f8:	a3 c8 0a 00 00       	mov    %eax,0xac8
      return (void*)(p + 1);
 7fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 800:	83 c0 08             	add    $0x8,%eax
 803:	eb 38                	jmp    83d <malloc+0xdc>
    }
    if(p == freep)
 805:	a1 c8 0a 00 00       	mov    0xac8,%eax
 80a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 80d:	75 1b                	jne    82a <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 80f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 812:	89 04 24             	mov    %eax,(%esp)
 815:	e8 ef fe ff ff       	call   709 <morecore>
 81a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 81d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 821:	75 07                	jne    82a <malloc+0xc9>
        return 0;
 823:	b8 00 00 00 00       	mov    $0x0,%eax
 828:	eb 13                	jmp    83d <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 82a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 830:	8b 45 f4             	mov    -0xc(%ebp),%eax
 833:	8b 00                	mov    (%eax),%eax
 835:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 838:	e9 70 ff ff ff       	jmp    7ad <malloc+0x4c>
}
 83d:	c9                   	leave  
 83e:	c3                   	ret    
