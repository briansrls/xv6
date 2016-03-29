
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
   f:	c7 44 24 04 63 08 00 	movl   $0x863,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 79 04 00 00       	call   49c <printf>
    exit();
  23:	e8 e4 02 00 00       	call   30c <exit>
  }

  for(i = 1; i < argc; i++){
  28:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  2f:	00 
  30:	eb 4e                	jmp    80 <main+0x80>
    if(mkdir(argv[i]) < 0){
  32:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  36:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  40:	01 d0                	add    %edx,%eax
  42:	8b 00                	mov    (%eax),%eax
  44:	89 04 24             	mov    %eax,(%esp)
  47:	e8 28 03 00 00       	call   374 <mkdir>
  4c:	85 c0                	test   %eax,%eax
  4e:	79 2c                	jns    7c <main+0x7c>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
  50:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  54:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  5e:	01 d0                	add    %edx,%eax
  60:	8b 00                	mov    (%eax),%eax
  62:	89 44 24 08          	mov    %eax,0x8(%esp)
  66:	c7 44 24 04 7a 08 00 	movl   $0x87a,0x4(%esp)
  6d:	00 
  6e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  75:	e8 22 04 00 00       	call   49c <printf>
      break;
  7a:	eb 0d                	jmp    89 <main+0x89>
  if(argc < 2){
    printf(2, "Usage: mkdir files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
  7c:	ff 44 24 1c          	incl   0x1c(%esp)
  80:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  84:	3b 45 08             	cmp    0x8(%ebp),%eax
  87:	7c a9                	jl     32 <main+0x32>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
      break;
    }
  }

  exit();
  89:	e8 7e 02 00 00       	call   30c <exit>
  8e:	66 90                	xchg   %ax,%ax

00000090 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  90:	55                   	push   %ebp
  91:	89 e5                	mov    %esp,%ebp
  93:	57                   	push   %edi
  94:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  95:	8b 4d 08             	mov    0x8(%ebp),%ecx
  98:	8b 55 10             	mov    0x10(%ebp),%edx
  9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  9e:	89 cb                	mov    %ecx,%ebx
  a0:	89 df                	mov    %ebx,%edi
  a2:	89 d1                	mov    %edx,%ecx
  a4:	fc                   	cld    
  a5:	f3 aa                	rep stos %al,%es:(%edi)
  a7:	89 ca                	mov    %ecx,%edx
  a9:	89 fb                	mov    %edi,%ebx
  ab:	89 5d 08             	mov    %ebx,0x8(%ebp)
  ae:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  b1:	5b                   	pop    %ebx
  b2:	5f                   	pop    %edi
  b3:	5d                   	pop    %ebp
  b4:	c3                   	ret    

000000b5 <strcpy>:
#include "x86.h"
#include "signal.h"

char*
strcpy(char *s, char *t)
{
  b5:	55                   	push   %ebp
  b6:	89 e5                	mov    %esp,%ebp
  b8:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  bb:	8b 45 08             	mov    0x8(%ebp),%eax
  be:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  c1:	90                   	nop
  c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  c5:	8a 10                	mov    (%eax),%dl
  c7:	8b 45 08             	mov    0x8(%ebp),%eax
  ca:	88 10                	mov    %dl,(%eax)
  cc:	8b 45 08             	mov    0x8(%ebp),%eax
  cf:	8a 00                	mov    (%eax),%al
  d1:	84 c0                	test   %al,%al
  d3:	0f 95 c0             	setne  %al
  d6:	ff 45 08             	incl   0x8(%ebp)
  d9:	ff 45 0c             	incl   0xc(%ebp)
  dc:	84 c0                	test   %al,%al
  de:	75 e2                	jne    c2 <strcpy+0xd>
    ;
  return os;
  e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e3:	c9                   	leave  
  e4:	c3                   	ret    

000000e5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  e5:	55                   	push   %ebp
  e6:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  e8:	eb 06                	jmp    f0 <strcmp+0xb>
    p++, q++;
  ea:	ff 45 08             	incl   0x8(%ebp)
  ed:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  f0:	8b 45 08             	mov    0x8(%ebp),%eax
  f3:	8a 00                	mov    (%eax),%al
  f5:	84 c0                	test   %al,%al
  f7:	74 0e                	je     107 <strcmp+0x22>
  f9:	8b 45 08             	mov    0x8(%ebp),%eax
  fc:	8a 10                	mov    (%eax),%dl
  fe:	8b 45 0c             	mov    0xc(%ebp),%eax
 101:	8a 00                	mov    (%eax),%al
 103:	38 c2                	cmp    %al,%dl
 105:	74 e3                	je     ea <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 107:	8b 45 08             	mov    0x8(%ebp),%eax
 10a:	8a 00                	mov    (%eax),%al
 10c:	0f b6 d0             	movzbl %al,%edx
 10f:	8b 45 0c             	mov    0xc(%ebp),%eax
 112:	8a 00                	mov    (%eax),%al
 114:	0f b6 c0             	movzbl %al,%eax
 117:	89 d1                	mov    %edx,%ecx
 119:	29 c1                	sub    %eax,%ecx
 11b:	89 c8                	mov    %ecx,%eax
}
 11d:	5d                   	pop    %ebp
 11e:	c3                   	ret    

0000011f <strlen>:

uint
strlen(char *s)
{
 11f:	55                   	push   %ebp
 120:	89 e5                	mov    %esp,%ebp
 122:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 125:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 12c:	eb 03                	jmp    131 <strlen+0x12>
 12e:	ff 45 fc             	incl   -0x4(%ebp)
 131:	8b 55 fc             	mov    -0x4(%ebp),%edx
 134:	8b 45 08             	mov    0x8(%ebp),%eax
 137:	01 d0                	add    %edx,%eax
 139:	8a 00                	mov    (%eax),%al
 13b:	84 c0                	test   %al,%al
 13d:	75 ef                	jne    12e <strlen+0xf>
    ;
  return n;
 13f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 142:	c9                   	leave  
 143:	c3                   	ret    

00000144 <memset>:

void*
memset(void *dst, int c, uint n)
{
 144:	55                   	push   %ebp
 145:	89 e5                	mov    %esp,%ebp
 147:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 14a:	8b 45 10             	mov    0x10(%ebp),%eax
 14d:	89 44 24 08          	mov    %eax,0x8(%esp)
 151:	8b 45 0c             	mov    0xc(%ebp),%eax
 154:	89 44 24 04          	mov    %eax,0x4(%esp)
 158:	8b 45 08             	mov    0x8(%ebp),%eax
 15b:	89 04 24             	mov    %eax,(%esp)
 15e:	e8 2d ff ff ff       	call   90 <stosb>
  return dst;
 163:	8b 45 08             	mov    0x8(%ebp),%eax
}
 166:	c9                   	leave  
 167:	c3                   	ret    

00000168 <strchr>:

char*
strchr(const char *s, char c)
{
 168:	55                   	push   %ebp
 169:	89 e5                	mov    %esp,%ebp
 16b:	83 ec 04             	sub    $0x4,%esp
 16e:	8b 45 0c             	mov    0xc(%ebp),%eax
 171:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 174:	eb 12                	jmp    188 <strchr+0x20>
    if(*s == c)
 176:	8b 45 08             	mov    0x8(%ebp),%eax
 179:	8a 00                	mov    (%eax),%al
 17b:	3a 45 fc             	cmp    -0x4(%ebp),%al
 17e:	75 05                	jne    185 <strchr+0x1d>
      return (char*)s;
 180:	8b 45 08             	mov    0x8(%ebp),%eax
 183:	eb 11                	jmp    196 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 185:	ff 45 08             	incl   0x8(%ebp)
 188:	8b 45 08             	mov    0x8(%ebp),%eax
 18b:	8a 00                	mov    (%eax),%al
 18d:	84 c0                	test   %al,%al
 18f:	75 e5                	jne    176 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 191:	b8 00 00 00 00       	mov    $0x0,%eax
}
 196:	c9                   	leave  
 197:	c3                   	ret    

00000198 <gets>:

char*
gets(char *buf, int max)
{
 198:	55                   	push   %ebp
 199:	89 e5                	mov    %esp,%ebp
 19b:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 19e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1a5:	eb 42                	jmp    1e9 <gets+0x51>
    cc = read(0, &c, 1);
 1a7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1ae:	00 
 1af:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1b2:	89 44 24 04          	mov    %eax,0x4(%esp)
 1b6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1bd:	e8 62 01 00 00       	call   324 <read>
 1c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1c5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1c9:	7e 29                	jle    1f4 <gets+0x5c>
      break;
    buf[i++] = c;
 1cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1ce:	8b 45 08             	mov    0x8(%ebp),%eax
 1d1:	01 c2                	add    %eax,%edx
 1d3:	8a 45 ef             	mov    -0x11(%ebp),%al
 1d6:	88 02                	mov    %al,(%edx)
 1d8:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 1db:	8a 45 ef             	mov    -0x11(%ebp),%al
 1de:	3c 0a                	cmp    $0xa,%al
 1e0:	74 13                	je     1f5 <gets+0x5d>
 1e2:	8a 45 ef             	mov    -0x11(%ebp),%al
 1e5:	3c 0d                	cmp    $0xd,%al
 1e7:	74 0c                	je     1f5 <gets+0x5d>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ec:	40                   	inc    %eax
 1ed:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1f0:	7c b5                	jl     1a7 <gets+0xf>
 1f2:	eb 01                	jmp    1f5 <gets+0x5d>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1f4:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1f8:	8b 45 08             	mov    0x8(%ebp),%eax
 1fb:	01 d0                	add    %edx,%eax
 1fd:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 200:	8b 45 08             	mov    0x8(%ebp),%eax
}
 203:	c9                   	leave  
 204:	c3                   	ret    

00000205 <stat>:

int
stat(char *n, struct stat *st)
{
 205:	55                   	push   %ebp
 206:	89 e5                	mov    %esp,%ebp
 208:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 20b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 212:	00 
 213:	8b 45 08             	mov    0x8(%ebp),%eax
 216:	89 04 24             	mov    %eax,(%esp)
 219:	e8 2e 01 00 00       	call   34c <open>
 21e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 221:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 225:	79 07                	jns    22e <stat+0x29>
    return -1;
 227:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 22c:	eb 23                	jmp    251 <stat+0x4c>
  r = fstat(fd, st);
 22e:	8b 45 0c             	mov    0xc(%ebp),%eax
 231:	89 44 24 04          	mov    %eax,0x4(%esp)
 235:	8b 45 f4             	mov    -0xc(%ebp),%eax
 238:	89 04 24             	mov    %eax,(%esp)
 23b:	e8 24 01 00 00       	call   364 <fstat>
 240:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 243:	8b 45 f4             	mov    -0xc(%ebp),%eax
 246:	89 04 24             	mov    %eax,(%esp)
 249:	e8 e6 00 00 00       	call   334 <close>
  return r;
 24e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 251:	c9                   	leave  
 252:	c3                   	ret    

00000253 <atoi>:

int
atoi(const char *s)
{
 253:	55                   	push   %ebp
 254:	89 e5                	mov    %esp,%ebp
 256:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 259:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 260:	eb 21                	jmp    283 <atoi+0x30>
    n = n*10 + *s++ - '0';
 262:	8b 55 fc             	mov    -0x4(%ebp),%edx
 265:	89 d0                	mov    %edx,%eax
 267:	c1 e0 02             	shl    $0x2,%eax
 26a:	01 d0                	add    %edx,%eax
 26c:	d1 e0                	shl    %eax
 26e:	89 c2                	mov    %eax,%edx
 270:	8b 45 08             	mov    0x8(%ebp),%eax
 273:	8a 00                	mov    (%eax),%al
 275:	0f be c0             	movsbl %al,%eax
 278:	01 d0                	add    %edx,%eax
 27a:	83 e8 30             	sub    $0x30,%eax
 27d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 280:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 283:	8b 45 08             	mov    0x8(%ebp),%eax
 286:	8a 00                	mov    (%eax),%al
 288:	3c 2f                	cmp    $0x2f,%al
 28a:	7e 09                	jle    295 <atoi+0x42>
 28c:	8b 45 08             	mov    0x8(%ebp),%eax
 28f:	8a 00                	mov    (%eax),%al
 291:	3c 39                	cmp    $0x39,%al
 293:	7e cd                	jle    262 <atoi+0xf>
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
 2a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2a6:	8b 45 0c             	mov    0xc(%ebp),%eax
 2a9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2ac:	eb 10                	jmp    2be <memmove+0x24>
    *dst++ = *src++;
 2ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2b1:	8a 10                	mov    (%eax),%dl
 2b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2b6:	88 10                	mov    %dl,(%eax)
 2b8:	ff 45 fc             	incl   -0x4(%ebp)
 2bb:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2be:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 2c2:	0f 9f c0             	setg   %al
 2c5:	ff 4d 10             	decl   0x10(%ebp)
 2c8:	84 c0                	test   %al,%al
 2ca:	75 e2                	jne    2ae <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2cc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2cf:	c9                   	leave  
 2d0:	c3                   	ret    

000002d1 <trampoline>:
 2d1:	5a                   	pop    %edx
 2d2:	59                   	pop    %ecx
 2d3:	58                   	pop    %eax
 2d4:	03 25 04 00 00 00    	add    0x4,%esp
 2da:	c9                   	leave  
 2db:	c3                   	ret    

000002dc <signal>:
	"addl 4, %esp\n\t"
	"leave\n\t"
	"ret\n\t"
);
int signal(int signum, sighandler_t handler) 
{
 2dc:	55                   	push   %ebp
 2dd:	89 e5                	mov    %esp,%ebp
 2df:	83 ec 18             	sub    $0x18,%esp
	register_signal_handler(signum, handler, trampoline);
 2e2:	c7 44 24 08 d1 02 00 	movl   $0x2d1,0x8(%esp)
 2e9:	00 
 2ea:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ed:	89 44 24 04          	mov    %eax,0x4(%esp)
 2f1:	8b 45 08             	mov    0x8(%ebp),%eax
 2f4:	89 04 24             	mov    %eax,(%esp)
 2f7:	e8 b8 00 00 00       	call   3b4 <register_signal_handler>
	return 0;
 2fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
 301:	c9                   	leave  
 302:	c3                   	ret    
 303:	90                   	nop

00000304 <fork>:
 304:	b8 01 00 00 00       	mov    $0x1,%eax
 309:	cd 40                	int    $0x40
 30b:	c3                   	ret    

0000030c <exit>:
 30c:	b8 02 00 00 00       	mov    $0x2,%eax
 311:	cd 40                	int    $0x40
 313:	c3                   	ret    

00000314 <wait>:
 314:	b8 03 00 00 00       	mov    $0x3,%eax
 319:	cd 40                	int    $0x40
 31b:	c3                   	ret    

0000031c <pipe>:
 31c:	b8 04 00 00 00       	mov    $0x4,%eax
 321:	cd 40                	int    $0x40
 323:	c3                   	ret    

00000324 <read>:
 324:	b8 05 00 00 00       	mov    $0x5,%eax
 329:	cd 40                	int    $0x40
 32b:	c3                   	ret    

0000032c <write>:
 32c:	b8 10 00 00 00       	mov    $0x10,%eax
 331:	cd 40                	int    $0x40
 333:	c3                   	ret    

00000334 <close>:
 334:	b8 15 00 00 00       	mov    $0x15,%eax
 339:	cd 40                	int    $0x40
 33b:	c3                   	ret    

0000033c <kill>:
 33c:	b8 06 00 00 00       	mov    $0x6,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <exec>:
 344:	b8 07 00 00 00       	mov    $0x7,%eax
 349:	cd 40                	int    $0x40
 34b:	c3                   	ret    

0000034c <open>:
 34c:	b8 0f 00 00 00       	mov    $0xf,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <mknod>:
 354:	b8 11 00 00 00       	mov    $0x11,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <unlink>:
 35c:	b8 12 00 00 00       	mov    $0x12,%eax
 361:	cd 40                	int    $0x40
 363:	c3                   	ret    

00000364 <fstat>:
 364:	b8 08 00 00 00       	mov    $0x8,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret    

0000036c <link>:
 36c:	b8 13 00 00 00       	mov    $0x13,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret    

00000374 <mkdir>:
 374:	b8 14 00 00 00       	mov    $0x14,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <chdir>:
 37c:	b8 09 00 00 00       	mov    $0x9,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <dup>:
 384:	b8 0a 00 00 00       	mov    $0xa,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <getpid>:
 38c:	b8 0b 00 00 00       	mov    $0xb,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <sbrk>:
 394:	b8 0c 00 00 00       	mov    $0xc,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <sleep>:
 39c:	b8 0d 00 00 00       	mov    $0xd,%eax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret    

000003a4 <uptime>:
 3a4:	b8 0e 00 00 00       	mov    $0xe,%eax
 3a9:	cd 40                	int    $0x40
 3ab:	c3                   	ret    

000003ac <halt>:
 3ac:	b8 16 00 00 00       	mov    $0x16,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret    

000003b4 <register_signal_handler>:
 3b4:	b8 17 00 00 00       	mov    $0x17,%eax
 3b9:	cd 40                	int    $0x40
 3bb:	c3                   	ret    

000003bc <alarm>:
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
 3ef:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3f2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3f9:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3fd:	74 17                	je     416 <printint+0x2a>
 3ff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 403:	79 11                	jns    416 <printint+0x2a>
    neg = 1;
 405:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 40c:	8b 45 0c             	mov    0xc(%ebp),%eax
 40f:	f7 d8                	neg    %eax
 411:	89 45 ec             	mov    %eax,-0x14(%ebp)
 414:	eb 06                	jmp    41c <printint+0x30>
  } else {
    x = xx;
 416:	8b 45 0c             	mov    0xc(%ebp),%eax
 419:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 41c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 423:	8b 4d 10             	mov    0x10(%ebp),%ecx
 426:	8b 45 ec             	mov    -0x14(%ebp),%eax
 429:	ba 00 00 00 00       	mov    $0x0,%edx
 42e:	f7 f1                	div    %ecx
 430:	89 d0                	mov    %edx,%eax
 432:	8a 80 fc 0a 00 00    	mov    0xafc(%eax),%al
 438:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 43b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 43e:	01 ca                	add    %ecx,%edx
 440:	88 02                	mov    %al,(%edx)
 442:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 445:	8b 55 10             	mov    0x10(%ebp),%edx
 448:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 44b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 44e:	ba 00 00 00 00       	mov    $0x0,%edx
 453:	f7 75 d4             	divl   -0x2c(%ebp)
 456:	89 45 ec             	mov    %eax,-0x14(%ebp)
 459:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 45d:	75 c4                	jne    423 <printint+0x37>
  if(neg)
 45f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 463:	74 2c                	je     491 <printint+0xa5>
    buf[i++] = '-';
 465:	8d 55 dc             	lea    -0x24(%ebp),%edx
 468:	8b 45 f4             	mov    -0xc(%ebp),%eax
 46b:	01 d0                	add    %edx,%eax
 46d:	c6 00 2d             	movb   $0x2d,(%eax)
 470:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 473:	eb 1c                	jmp    491 <printint+0xa5>
    putc(fd, buf[i]);
 475:	8d 55 dc             	lea    -0x24(%ebp),%edx
 478:	8b 45 f4             	mov    -0xc(%ebp),%eax
 47b:	01 d0                	add    %edx,%eax
 47d:	8a 00                	mov    (%eax),%al
 47f:	0f be c0             	movsbl %al,%eax
 482:	89 44 24 04          	mov    %eax,0x4(%esp)
 486:	8b 45 08             	mov    0x8(%ebp),%eax
 489:	89 04 24             	mov    %eax,(%esp)
 48c:	e8 33 ff ff ff       	call   3c4 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 491:	ff 4d f4             	decl   -0xc(%ebp)
 494:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 498:	79 db                	jns    475 <printint+0x89>
    putc(fd, buf[i]);
}
 49a:	c9                   	leave  
 49b:	c3                   	ret    

0000049c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 49c:	55                   	push   %ebp
 49d:	89 e5                	mov    %esp,%ebp
 49f:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4a2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4a9:	8d 45 0c             	lea    0xc(%ebp),%eax
 4ac:	83 c0 04             	add    $0x4,%eax
 4af:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4b2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4b9:	e9 78 01 00 00       	jmp    636 <printf+0x19a>
    c = fmt[i] & 0xff;
 4be:	8b 55 0c             	mov    0xc(%ebp),%edx
 4c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4c4:	01 d0                	add    %edx,%eax
 4c6:	8a 00                	mov    (%eax),%al
 4c8:	0f be c0             	movsbl %al,%eax
 4cb:	25 ff 00 00 00       	and    $0xff,%eax
 4d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4d3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4d7:	75 2c                	jne    505 <printf+0x69>
      if(c == '%'){
 4d9:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4dd:	75 0c                	jne    4eb <printf+0x4f>
        state = '%';
 4df:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4e6:	e9 48 01 00 00       	jmp    633 <printf+0x197>
      } else {
        putc(fd, c);
 4eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4ee:	0f be c0             	movsbl %al,%eax
 4f1:	89 44 24 04          	mov    %eax,0x4(%esp)
 4f5:	8b 45 08             	mov    0x8(%ebp),%eax
 4f8:	89 04 24             	mov    %eax,(%esp)
 4fb:	e8 c4 fe ff ff       	call   3c4 <putc>
 500:	e9 2e 01 00 00       	jmp    633 <printf+0x197>
      }
    } else if(state == '%'){
 505:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 509:	0f 85 24 01 00 00    	jne    633 <printf+0x197>
      if(c == 'd'){
 50f:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 513:	75 2d                	jne    542 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 515:	8b 45 e8             	mov    -0x18(%ebp),%eax
 518:	8b 00                	mov    (%eax),%eax
 51a:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 521:	00 
 522:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 529:	00 
 52a:	89 44 24 04          	mov    %eax,0x4(%esp)
 52e:	8b 45 08             	mov    0x8(%ebp),%eax
 531:	89 04 24             	mov    %eax,(%esp)
 534:	e8 b3 fe ff ff       	call   3ec <printint>
        ap++;
 539:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 53d:	e9 ea 00 00 00       	jmp    62c <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 542:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 546:	74 06                	je     54e <printf+0xb2>
 548:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 54c:	75 2d                	jne    57b <printf+0xdf>
        printint(fd, *ap, 16, 0);
 54e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 551:	8b 00                	mov    (%eax),%eax
 553:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 55a:	00 
 55b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 562:	00 
 563:	89 44 24 04          	mov    %eax,0x4(%esp)
 567:	8b 45 08             	mov    0x8(%ebp),%eax
 56a:	89 04 24             	mov    %eax,(%esp)
 56d:	e8 7a fe ff ff       	call   3ec <printint>
        ap++;
 572:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 576:	e9 b1 00 00 00       	jmp    62c <printf+0x190>
      } else if(c == 's'){
 57b:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 57f:	75 43                	jne    5c4 <printf+0x128>
        s = (char*)*ap;
 581:	8b 45 e8             	mov    -0x18(%ebp),%eax
 584:	8b 00                	mov    (%eax),%eax
 586:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 589:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 58d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 591:	75 25                	jne    5b8 <printf+0x11c>
          s = "(null)";
 593:	c7 45 f4 96 08 00 00 	movl   $0x896,-0xc(%ebp)
        while(*s != 0){
 59a:	eb 1c                	jmp    5b8 <printf+0x11c>
          putc(fd, *s);
 59c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 59f:	8a 00                	mov    (%eax),%al
 5a1:	0f be c0             	movsbl %al,%eax
 5a4:	89 44 24 04          	mov    %eax,0x4(%esp)
 5a8:	8b 45 08             	mov    0x8(%ebp),%eax
 5ab:	89 04 24             	mov    %eax,(%esp)
 5ae:	e8 11 fe ff ff       	call   3c4 <putc>
          s++;
 5b3:	ff 45 f4             	incl   -0xc(%ebp)
 5b6:	eb 01                	jmp    5b9 <printf+0x11d>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5b8:	90                   	nop
 5b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5bc:	8a 00                	mov    (%eax),%al
 5be:	84 c0                	test   %al,%al
 5c0:	75 da                	jne    59c <printf+0x100>
 5c2:	eb 68                	jmp    62c <printf+0x190>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5c4:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5c8:	75 1d                	jne    5e7 <printf+0x14b>
        putc(fd, *ap);
 5ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5cd:	8b 00                	mov    (%eax),%eax
 5cf:	0f be c0             	movsbl %al,%eax
 5d2:	89 44 24 04          	mov    %eax,0x4(%esp)
 5d6:	8b 45 08             	mov    0x8(%ebp),%eax
 5d9:	89 04 24             	mov    %eax,(%esp)
 5dc:	e8 e3 fd ff ff       	call   3c4 <putc>
        ap++;
 5e1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5e5:	eb 45                	jmp    62c <printf+0x190>
      } else if(c == '%'){
 5e7:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5eb:	75 17                	jne    604 <printf+0x168>
        putc(fd, c);
 5ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5f0:	0f be c0             	movsbl %al,%eax
 5f3:	89 44 24 04          	mov    %eax,0x4(%esp)
 5f7:	8b 45 08             	mov    0x8(%ebp),%eax
 5fa:	89 04 24             	mov    %eax,(%esp)
 5fd:	e8 c2 fd ff ff       	call   3c4 <putc>
 602:	eb 28                	jmp    62c <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 604:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 60b:	00 
 60c:	8b 45 08             	mov    0x8(%ebp),%eax
 60f:	89 04 24             	mov    %eax,(%esp)
 612:	e8 ad fd ff ff       	call   3c4 <putc>
        putc(fd, c);
 617:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 61a:	0f be c0             	movsbl %al,%eax
 61d:	89 44 24 04          	mov    %eax,0x4(%esp)
 621:	8b 45 08             	mov    0x8(%ebp),%eax
 624:	89 04 24             	mov    %eax,(%esp)
 627:	e8 98 fd ff ff       	call   3c4 <putc>
      }
      state = 0;
 62c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 633:	ff 45 f0             	incl   -0x10(%ebp)
 636:	8b 55 0c             	mov    0xc(%ebp),%edx
 639:	8b 45 f0             	mov    -0x10(%ebp),%eax
 63c:	01 d0                	add    %edx,%eax
 63e:	8a 00                	mov    (%eax),%al
 640:	84 c0                	test   %al,%al
 642:	0f 85 76 fe ff ff    	jne    4be <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 648:	c9                   	leave  
 649:	c3                   	ret    
 64a:	66 90                	xchg   %ax,%ax

0000064c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 64c:	55                   	push   %ebp
 64d:	89 e5                	mov    %esp,%ebp
 64f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 652:	8b 45 08             	mov    0x8(%ebp),%eax
 655:	83 e8 08             	sub    $0x8,%eax
 658:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 65b:	a1 18 0b 00 00       	mov    0xb18,%eax
 660:	89 45 fc             	mov    %eax,-0x4(%ebp)
 663:	eb 24                	jmp    689 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 665:	8b 45 fc             	mov    -0x4(%ebp),%eax
 668:	8b 00                	mov    (%eax),%eax
 66a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 66d:	77 12                	ja     681 <free+0x35>
 66f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 672:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 675:	77 24                	ja     69b <free+0x4f>
 677:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67a:	8b 00                	mov    (%eax),%eax
 67c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 67f:	77 1a                	ja     69b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 681:	8b 45 fc             	mov    -0x4(%ebp),%eax
 684:	8b 00                	mov    (%eax),%eax
 686:	89 45 fc             	mov    %eax,-0x4(%ebp)
 689:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 68f:	76 d4                	jbe    665 <free+0x19>
 691:	8b 45 fc             	mov    -0x4(%ebp),%eax
 694:	8b 00                	mov    (%eax),%eax
 696:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 699:	76 ca                	jbe    665 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 69b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69e:	8b 40 04             	mov    0x4(%eax),%eax
 6a1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ab:	01 c2                	add    %eax,%edx
 6ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b0:	8b 00                	mov    (%eax),%eax
 6b2:	39 c2                	cmp    %eax,%edx
 6b4:	75 24                	jne    6da <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b9:	8b 50 04             	mov    0x4(%eax),%edx
 6bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bf:	8b 00                	mov    (%eax),%eax
 6c1:	8b 40 04             	mov    0x4(%eax),%eax
 6c4:	01 c2                	add    %eax,%edx
 6c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c9:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cf:	8b 00                	mov    (%eax),%eax
 6d1:	8b 10                	mov    (%eax),%edx
 6d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d6:	89 10                	mov    %edx,(%eax)
 6d8:	eb 0a                	jmp    6e4 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6da:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6dd:	8b 10                	mov    (%eax),%edx
 6df:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e2:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e7:	8b 40 04             	mov    0x4(%eax),%eax
 6ea:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f4:	01 d0                	add    %edx,%eax
 6f6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6f9:	75 20                	jne    71b <free+0xcf>
    p->s.size += bp->s.size;
 6fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fe:	8b 50 04             	mov    0x4(%eax),%edx
 701:	8b 45 f8             	mov    -0x8(%ebp),%eax
 704:	8b 40 04             	mov    0x4(%eax),%eax
 707:	01 c2                	add    %eax,%edx
 709:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 70f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 712:	8b 10                	mov    (%eax),%edx
 714:	8b 45 fc             	mov    -0x4(%ebp),%eax
 717:	89 10                	mov    %edx,(%eax)
 719:	eb 08                	jmp    723 <free+0xd7>
  } else
    p->s.ptr = bp;
 71b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 721:	89 10                	mov    %edx,(%eax)
  freep = p;
 723:	8b 45 fc             	mov    -0x4(%ebp),%eax
 726:	a3 18 0b 00 00       	mov    %eax,0xb18
}
 72b:	c9                   	leave  
 72c:	c3                   	ret    

0000072d <morecore>:

static Header*
morecore(uint nu)
{
 72d:	55                   	push   %ebp
 72e:	89 e5                	mov    %esp,%ebp
 730:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 733:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 73a:	77 07                	ja     743 <morecore+0x16>
    nu = 4096;
 73c:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 743:	8b 45 08             	mov    0x8(%ebp),%eax
 746:	c1 e0 03             	shl    $0x3,%eax
 749:	89 04 24             	mov    %eax,(%esp)
 74c:	e8 43 fc ff ff       	call   394 <sbrk>
 751:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 754:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 758:	75 07                	jne    761 <morecore+0x34>
    return 0;
 75a:	b8 00 00 00 00       	mov    $0x0,%eax
 75f:	eb 22                	jmp    783 <morecore+0x56>
  hp = (Header*)p;
 761:	8b 45 f4             	mov    -0xc(%ebp),%eax
 764:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 767:	8b 45 f0             	mov    -0x10(%ebp),%eax
 76a:	8b 55 08             	mov    0x8(%ebp),%edx
 76d:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 770:	8b 45 f0             	mov    -0x10(%ebp),%eax
 773:	83 c0 08             	add    $0x8,%eax
 776:	89 04 24             	mov    %eax,(%esp)
 779:	e8 ce fe ff ff       	call   64c <free>
  return freep;
 77e:	a1 18 0b 00 00       	mov    0xb18,%eax
}
 783:	c9                   	leave  
 784:	c3                   	ret    

00000785 <malloc>:

void*
malloc(uint nbytes)
{
 785:	55                   	push   %ebp
 786:	89 e5                	mov    %esp,%ebp
 788:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 78b:	8b 45 08             	mov    0x8(%ebp),%eax
 78e:	83 c0 07             	add    $0x7,%eax
 791:	c1 e8 03             	shr    $0x3,%eax
 794:	40                   	inc    %eax
 795:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 798:	a1 18 0b 00 00       	mov    0xb18,%eax
 79d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7a4:	75 23                	jne    7c9 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 7a6:	c7 45 f0 10 0b 00 00 	movl   $0xb10,-0x10(%ebp)
 7ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b0:	a3 18 0b 00 00       	mov    %eax,0xb18
 7b5:	a1 18 0b 00 00       	mov    0xb18,%eax
 7ba:	a3 10 0b 00 00       	mov    %eax,0xb10
    base.s.size = 0;
 7bf:	c7 05 14 0b 00 00 00 	movl   $0x0,0xb14
 7c6:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7cc:	8b 00                	mov    (%eax),%eax
 7ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d4:	8b 40 04             	mov    0x4(%eax),%eax
 7d7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7da:	72 4d                	jb     829 <malloc+0xa4>
      if(p->s.size == nunits)
 7dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7df:	8b 40 04             	mov    0x4(%eax),%eax
 7e2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7e5:	75 0c                	jne    7f3 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 7e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ea:	8b 10                	mov    (%eax),%edx
 7ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ef:	89 10                	mov    %edx,(%eax)
 7f1:	eb 26                	jmp    819 <malloc+0x94>
      else {
        p->s.size -= nunits;
 7f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f6:	8b 40 04             	mov    0x4(%eax),%eax
 7f9:	89 c2                	mov    %eax,%edx
 7fb:	2b 55 ec             	sub    -0x14(%ebp),%edx
 7fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 801:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 804:	8b 45 f4             	mov    -0xc(%ebp),%eax
 807:	8b 40 04             	mov    0x4(%eax),%eax
 80a:	c1 e0 03             	shl    $0x3,%eax
 80d:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 810:	8b 45 f4             	mov    -0xc(%ebp),%eax
 813:	8b 55 ec             	mov    -0x14(%ebp),%edx
 816:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 819:	8b 45 f0             	mov    -0x10(%ebp),%eax
 81c:	a3 18 0b 00 00       	mov    %eax,0xb18
      return (void*)(p + 1);
 821:	8b 45 f4             	mov    -0xc(%ebp),%eax
 824:	83 c0 08             	add    $0x8,%eax
 827:	eb 38                	jmp    861 <malloc+0xdc>
    }
    if(p == freep)
 829:	a1 18 0b 00 00       	mov    0xb18,%eax
 82e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 831:	75 1b                	jne    84e <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 833:	8b 45 ec             	mov    -0x14(%ebp),%eax
 836:	89 04 24             	mov    %eax,(%esp)
 839:	e8 ef fe ff ff       	call   72d <morecore>
 83e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 841:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 845:	75 07                	jne    84e <malloc+0xc9>
        return 0;
 847:	b8 00 00 00 00       	mov    $0x0,%eax
 84c:	eb 13                	jmp    861 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 84e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 851:	89 45 f0             	mov    %eax,-0x10(%ebp)
 854:	8b 45 f4             	mov    -0xc(%ebp),%eax
 857:	8b 00                	mov    (%eax),%eax
 859:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 85c:	e9 70 ff ff ff       	jmp    7d1 <malloc+0x4c>
}
 861:	c9                   	leave  
 862:	c3                   	ret    
