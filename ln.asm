
_ln:     file format elf32-i386


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
   6:	83 ec 10             	sub    $0x10,%esp
  if(argc != 3){
   9:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
   d:	74 19                	je     28 <main+0x28>
    printf(2, "Usage: ln old new\n");
   f:	c7 44 24 04 4f 08 00 	movl   $0x84f,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 65 04 00 00       	call   488 <printf>
    exit();
  23:	e8 d0 02 00 00       	call   2f8 <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  28:	8b 45 0c             	mov    0xc(%ebp),%eax
  2b:	83 c0 08             	add    $0x8,%eax
  2e:	8b 10                	mov    (%eax),%edx
  30:	8b 45 0c             	mov    0xc(%ebp),%eax
  33:	83 c0 04             	add    $0x4,%eax
  36:	8b 00                	mov    (%eax),%eax
  38:	89 54 24 04          	mov    %edx,0x4(%esp)
  3c:	89 04 24             	mov    %eax,(%esp)
  3f:	e8 14 03 00 00       	call   358 <link>
  44:	85 c0                	test   %eax,%eax
  46:	79 2c                	jns    74 <main+0x74>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  48:	8b 45 0c             	mov    0xc(%ebp),%eax
  4b:	83 c0 08             	add    $0x8,%eax
  4e:	8b 10                	mov    (%eax),%edx
  50:	8b 45 0c             	mov    0xc(%ebp),%eax
  53:	83 c0 04             	add    $0x4,%eax
  56:	8b 00                	mov    (%eax),%eax
  58:	89 54 24 0c          	mov    %edx,0xc(%esp)
  5c:	89 44 24 08          	mov    %eax,0x8(%esp)
  60:	c7 44 24 04 62 08 00 	movl   $0x862,0x4(%esp)
  67:	00 
  68:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  6f:	e8 14 04 00 00       	call   488 <printf>
  exit();
  74:	e8 7f 02 00 00       	call   2f8 <exit>
  79:	66 90                	xchg   %ax,%ax
  7b:	90                   	nop

0000007c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  7c:	55                   	push   %ebp
  7d:	89 e5                	mov    %esp,%ebp
  7f:	57                   	push   %edi
  80:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  81:	8b 4d 08             	mov    0x8(%ebp),%ecx
  84:	8b 55 10             	mov    0x10(%ebp),%edx
  87:	8b 45 0c             	mov    0xc(%ebp),%eax
  8a:	89 cb                	mov    %ecx,%ebx
  8c:	89 df                	mov    %ebx,%edi
  8e:	89 d1                	mov    %edx,%ecx
  90:	fc                   	cld    
  91:	f3 aa                	rep stos %al,%es:(%edi)
  93:	89 ca                	mov    %ecx,%edx
  95:	89 fb                	mov    %edi,%ebx
  97:	89 5d 08             	mov    %ebx,0x8(%ebp)
  9a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  9d:	5b                   	pop    %ebx
  9e:	5f                   	pop    %edi
  9f:	5d                   	pop    %ebp
  a0:	c3                   	ret    

000000a1 <strcpy>:
#include "x86.h"
#include "signal.h"

char*
strcpy(char *s, char *t)
{
  a1:	55                   	push   %ebp
  a2:	89 e5                	mov    %esp,%ebp
  a4:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  a7:	8b 45 08             	mov    0x8(%ebp),%eax
  aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  ad:	90                   	nop
  ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  b1:	8a 10                	mov    (%eax),%dl
  b3:	8b 45 08             	mov    0x8(%ebp),%eax
  b6:	88 10                	mov    %dl,(%eax)
  b8:	8b 45 08             	mov    0x8(%ebp),%eax
  bb:	8a 00                	mov    (%eax),%al
  bd:	84 c0                	test   %al,%al
  bf:	0f 95 c0             	setne  %al
  c2:	ff 45 08             	incl   0x8(%ebp)
  c5:	ff 45 0c             	incl   0xc(%ebp)
  c8:	84 c0                	test   %al,%al
  ca:	75 e2                	jne    ae <strcpy+0xd>
    ;
  return os;
  cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  cf:	c9                   	leave  
  d0:	c3                   	ret    

000000d1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  d1:	55                   	push   %ebp
  d2:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  d4:	eb 06                	jmp    dc <strcmp+0xb>
    p++, q++;
  d6:	ff 45 08             	incl   0x8(%ebp)
  d9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  dc:	8b 45 08             	mov    0x8(%ebp),%eax
  df:	8a 00                	mov    (%eax),%al
  e1:	84 c0                	test   %al,%al
  e3:	74 0e                	je     f3 <strcmp+0x22>
  e5:	8b 45 08             	mov    0x8(%ebp),%eax
  e8:	8a 10                	mov    (%eax),%dl
  ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  ed:	8a 00                	mov    (%eax),%al
  ef:	38 c2                	cmp    %al,%dl
  f1:	74 e3                	je     d6 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  f3:	8b 45 08             	mov    0x8(%ebp),%eax
  f6:	8a 00                	mov    (%eax),%al
  f8:	0f b6 d0             	movzbl %al,%edx
  fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  fe:	8a 00                	mov    (%eax),%al
 100:	0f b6 c0             	movzbl %al,%eax
 103:	89 d1                	mov    %edx,%ecx
 105:	29 c1                	sub    %eax,%ecx
 107:	89 c8                	mov    %ecx,%eax
}
 109:	5d                   	pop    %ebp
 10a:	c3                   	ret    

0000010b <strlen>:

uint
strlen(char *s)
{
 10b:	55                   	push   %ebp
 10c:	89 e5                	mov    %esp,%ebp
 10e:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 111:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 118:	eb 03                	jmp    11d <strlen+0x12>
 11a:	ff 45 fc             	incl   -0x4(%ebp)
 11d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 120:	8b 45 08             	mov    0x8(%ebp),%eax
 123:	01 d0                	add    %edx,%eax
 125:	8a 00                	mov    (%eax),%al
 127:	84 c0                	test   %al,%al
 129:	75 ef                	jne    11a <strlen+0xf>
    ;
  return n;
 12b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 12e:	c9                   	leave  
 12f:	c3                   	ret    

00000130 <memset>:

void*
memset(void *dst, int c, uint n)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
 133:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 136:	8b 45 10             	mov    0x10(%ebp),%eax
 139:	89 44 24 08          	mov    %eax,0x8(%esp)
 13d:	8b 45 0c             	mov    0xc(%ebp),%eax
 140:	89 44 24 04          	mov    %eax,0x4(%esp)
 144:	8b 45 08             	mov    0x8(%ebp),%eax
 147:	89 04 24             	mov    %eax,(%esp)
 14a:	e8 2d ff ff ff       	call   7c <stosb>
  return dst;
 14f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 152:	c9                   	leave  
 153:	c3                   	ret    

00000154 <strchr>:

char*
strchr(const char *s, char c)
{
 154:	55                   	push   %ebp
 155:	89 e5                	mov    %esp,%ebp
 157:	83 ec 04             	sub    $0x4,%esp
 15a:	8b 45 0c             	mov    0xc(%ebp),%eax
 15d:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 160:	eb 12                	jmp    174 <strchr+0x20>
    if(*s == c)
 162:	8b 45 08             	mov    0x8(%ebp),%eax
 165:	8a 00                	mov    (%eax),%al
 167:	3a 45 fc             	cmp    -0x4(%ebp),%al
 16a:	75 05                	jne    171 <strchr+0x1d>
      return (char*)s;
 16c:	8b 45 08             	mov    0x8(%ebp),%eax
 16f:	eb 11                	jmp    182 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 171:	ff 45 08             	incl   0x8(%ebp)
 174:	8b 45 08             	mov    0x8(%ebp),%eax
 177:	8a 00                	mov    (%eax),%al
 179:	84 c0                	test   %al,%al
 17b:	75 e5                	jne    162 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 17d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 182:	c9                   	leave  
 183:	c3                   	ret    

00000184 <gets>:

char*
gets(char *buf, int max)
{
 184:	55                   	push   %ebp
 185:	89 e5                	mov    %esp,%ebp
 187:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 18a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 191:	eb 42                	jmp    1d5 <gets+0x51>
    cc = read(0, &c, 1);
 193:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 19a:	00 
 19b:	8d 45 ef             	lea    -0x11(%ebp),%eax
 19e:	89 44 24 04          	mov    %eax,0x4(%esp)
 1a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1a9:	e8 62 01 00 00       	call   310 <read>
 1ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1b5:	7e 29                	jle    1e0 <gets+0x5c>
      break;
    buf[i++] = c;
 1b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1ba:	8b 45 08             	mov    0x8(%ebp),%eax
 1bd:	01 c2                	add    %eax,%edx
 1bf:	8a 45 ef             	mov    -0x11(%ebp),%al
 1c2:	88 02                	mov    %al,(%edx)
 1c4:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 1c7:	8a 45 ef             	mov    -0x11(%ebp),%al
 1ca:	3c 0a                	cmp    $0xa,%al
 1cc:	74 13                	je     1e1 <gets+0x5d>
 1ce:	8a 45 ef             	mov    -0x11(%ebp),%al
 1d1:	3c 0d                	cmp    $0xd,%al
 1d3:	74 0c                	je     1e1 <gets+0x5d>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d8:	40                   	inc    %eax
 1d9:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1dc:	7c b5                	jl     193 <gets+0xf>
 1de:	eb 01                	jmp    1e1 <gets+0x5d>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1e0:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1e4:	8b 45 08             	mov    0x8(%ebp),%eax
 1e7:	01 d0                	add    %edx,%eax
 1e9:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1ec:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1ef:	c9                   	leave  
 1f0:	c3                   	ret    

000001f1 <stat>:

int
stat(char *n, struct stat *st)
{
 1f1:	55                   	push   %ebp
 1f2:	89 e5                	mov    %esp,%ebp
 1f4:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1fe:	00 
 1ff:	8b 45 08             	mov    0x8(%ebp),%eax
 202:	89 04 24             	mov    %eax,(%esp)
 205:	e8 2e 01 00 00       	call   338 <open>
 20a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 20d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 211:	79 07                	jns    21a <stat+0x29>
    return -1;
 213:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 218:	eb 23                	jmp    23d <stat+0x4c>
  r = fstat(fd, st);
 21a:	8b 45 0c             	mov    0xc(%ebp),%eax
 21d:	89 44 24 04          	mov    %eax,0x4(%esp)
 221:	8b 45 f4             	mov    -0xc(%ebp),%eax
 224:	89 04 24             	mov    %eax,(%esp)
 227:	e8 24 01 00 00       	call   350 <fstat>
 22c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 22f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 232:	89 04 24             	mov    %eax,(%esp)
 235:	e8 e6 00 00 00       	call   320 <close>
  return r;
 23a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 23d:	c9                   	leave  
 23e:	c3                   	ret    

0000023f <atoi>:

int
atoi(const char *s)
{
 23f:	55                   	push   %ebp
 240:	89 e5                	mov    %esp,%ebp
 242:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 245:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 24c:	eb 21                	jmp    26f <atoi+0x30>
    n = n*10 + *s++ - '0';
 24e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 251:	89 d0                	mov    %edx,%eax
 253:	c1 e0 02             	shl    $0x2,%eax
 256:	01 d0                	add    %edx,%eax
 258:	d1 e0                	shl    %eax
 25a:	89 c2                	mov    %eax,%edx
 25c:	8b 45 08             	mov    0x8(%ebp),%eax
 25f:	8a 00                	mov    (%eax),%al
 261:	0f be c0             	movsbl %al,%eax
 264:	01 d0                	add    %edx,%eax
 266:	83 e8 30             	sub    $0x30,%eax
 269:	89 45 fc             	mov    %eax,-0x4(%ebp)
 26c:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 26f:	8b 45 08             	mov    0x8(%ebp),%eax
 272:	8a 00                	mov    (%eax),%al
 274:	3c 2f                	cmp    $0x2f,%al
 276:	7e 09                	jle    281 <atoi+0x42>
 278:	8b 45 08             	mov    0x8(%ebp),%eax
 27b:	8a 00                	mov    (%eax),%al
 27d:	3c 39                	cmp    $0x39,%al
 27f:	7e cd                	jle    24e <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 281:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 284:	c9                   	leave  
 285:	c3                   	ret    

00000286 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 286:	55                   	push   %ebp
 287:	89 e5                	mov    %esp,%ebp
 289:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 28c:	8b 45 08             	mov    0x8(%ebp),%eax
 28f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 292:	8b 45 0c             	mov    0xc(%ebp),%eax
 295:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 298:	eb 10                	jmp    2aa <memmove+0x24>
    *dst++ = *src++;
 29a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 29d:	8a 10                	mov    (%eax),%dl
 29f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2a2:	88 10                	mov    %dl,(%eax)
 2a4:	ff 45 fc             	incl   -0x4(%ebp)
 2a7:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2aa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 2ae:	0f 9f c0             	setg   %al
 2b1:	ff 4d 10             	decl   0x10(%ebp)
 2b4:	84 c0                	test   %al,%al
 2b6:	75 e2                	jne    29a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2b8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2bb:	c9                   	leave  
 2bc:	c3                   	ret    

000002bd <trampoline>:
 2bd:	5a                   	pop    %edx
 2be:	59                   	pop    %ecx
 2bf:	58                   	pop    %eax
 2c0:	03 25 04 00 00 00    	add    0x4,%esp
 2c6:	c9                   	leave  
 2c7:	c3                   	ret    

000002c8 <signal>:
	"addl 4, %esp\n\t"
	"leave\n\t"
	"ret\n\t"
);
int signal(int signum, sighandler_t handler) 
{
 2c8:	55                   	push   %ebp
 2c9:	89 e5                	mov    %esp,%ebp
 2cb:	83 ec 18             	sub    $0x18,%esp
	register_signal_handler(signum, handler, trampoline);
 2ce:	c7 44 24 08 bd 02 00 	movl   $0x2bd,0x8(%esp)
 2d5:	00 
 2d6:	8b 45 0c             	mov    0xc(%ebp),%eax
 2d9:	89 44 24 04          	mov    %eax,0x4(%esp)
 2dd:	8b 45 08             	mov    0x8(%ebp),%eax
 2e0:	89 04 24             	mov    %eax,(%esp)
 2e3:	e8 b8 00 00 00       	call   3a0 <register_signal_handler>
	return 0;
 2e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2ed:	c9                   	leave  
 2ee:	c3                   	ret    
 2ef:	90                   	nop

000002f0 <fork>:
 2f0:	b8 01 00 00 00       	mov    $0x1,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <exit>:
 2f8:	b8 02 00 00 00       	mov    $0x2,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <wait>:
 300:	b8 03 00 00 00       	mov    $0x3,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <pipe>:
 308:	b8 04 00 00 00       	mov    $0x4,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <read>:
 310:	b8 05 00 00 00       	mov    $0x5,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <write>:
 318:	b8 10 00 00 00       	mov    $0x10,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <close>:
 320:	b8 15 00 00 00       	mov    $0x15,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <kill>:
 328:	b8 06 00 00 00       	mov    $0x6,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <exec>:
 330:	b8 07 00 00 00       	mov    $0x7,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <open>:
 338:	b8 0f 00 00 00       	mov    $0xf,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <mknod>:
 340:	b8 11 00 00 00       	mov    $0x11,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <unlink>:
 348:	b8 12 00 00 00       	mov    $0x12,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <fstat>:
 350:	b8 08 00 00 00       	mov    $0x8,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <link>:
 358:	b8 13 00 00 00       	mov    $0x13,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <mkdir>:
 360:	b8 14 00 00 00       	mov    $0x14,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <chdir>:
 368:	b8 09 00 00 00       	mov    $0x9,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <dup>:
 370:	b8 0a 00 00 00       	mov    $0xa,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <getpid>:
 378:	b8 0b 00 00 00       	mov    $0xb,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <sbrk>:
 380:	b8 0c 00 00 00       	mov    $0xc,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <sleep>:
 388:	b8 0d 00 00 00       	mov    $0xd,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <uptime>:
 390:	b8 0e 00 00 00       	mov    $0xe,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <halt>:
 398:	b8 16 00 00 00       	mov    $0x16,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <register_signal_handler>:
 3a0:	b8 17 00 00 00       	mov    $0x17,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <alarm>:
 3a8:	b8 18 00 00 00       	mov    $0x18,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3b0:	55                   	push   %ebp
 3b1:	89 e5                	mov    %esp,%ebp
 3b3:	83 ec 28             	sub    $0x28,%esp
 3b6:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b9:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3bc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3c3:	00 
 3c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3c7:	89 44 24 04          	mov    %eax,0x4(%esp)
 3cb:	8b 45 08             	mov    0x8(%ebp),%eax
 3ce:	89 04 24             	mov    %eax,(%esp)
 3d1:	e8 42 ff ff ff       	call   318 <write>
}
 3d6:	c9                   	leave  
 3d7:	c3                   	ret    

000003d8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3d8:	55                   	push   %ebp
 3d9:	89 e5                	mov    %esp,%ebp
 3db:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3de:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3e5:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3e9:	74 17                	je     402 <printint+0x2a>
 3eb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3ef:	79 11                	jns    402 <printint+0x2a>
    neg = 1;
 3f1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3f8:	8b 45 0c             	mov    0xc(%ebp),%eax
 3fb:	f7 d8                	neg    %eax
 3fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
 400:	eb 06                	jmp    408 <printint+0x30>
  } else {
    x = xx;
 402:	8b 45 0c             	mov    0xc(%ebp),%eax
 405:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 408:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 40f:	8b 4d 10             	mov    0x10(%ebp),%ecx
 412:	8b 45 ec             	mov    -0x14(%ebp),%eax
 415:	ba 00 00 00 00       	mov    $0x0,%edx
 41a:	f7 f1                	div    %ecx
 41c:	89 d0                	mov    %edx,%eax
 41e:	8a 80 dc 0a 00 00    	mov    0xadc(%eax),%al
 424:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 427:	8b 55 f4             	mov    -0xc(%ebp),%edx
 42a:	01 ca                	add    %ecx,%edx
 42c:	88 02                	mov    %al,(%edx)
 42e:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 431:	8b 55 10             	mov    0x10(%ebp),%edx
 434:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 437:	8b 45 ec             	mov    -0x14(%ebp),%eax
 43a:	ba 00 00 00 00       	mov    $0x0,%edx
 43f:	f7 75 d4             	divl   -0x2c(%ebp)
 442:	89 45 ec             	mov    %eax,-0x14(%ebp)
 445:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 449:	75 c4                	jne    40f <printint+0x37>
  if(neg)
 44b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 44f:	74 2c                	je     47d <printint+0xa5>
    buf[i++] = '-';
 451:	8d 55 dc             	lea    -0x24(%ebp),%edx
 454:	8b 45 f4             	mov    -0xc(%ebp),%eax
 457:	01 d0                	add    %edx,%eax
 459:	c6 00 2d             	movb   $0x2d,(%eax)
 45c:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 45f:	eb 1c                	jmp    47d <printint+0xa5>
    putc(fd, buf[i]);
 461:	8d 55 dc             	lea    -0x24(%ebp),%edx
 464:	8b 45 f4             	mov    -0xc(%ebp),%eax
 467:	01 d0                	add    %edx,%eax
 469:	8a 00                	mov    (%eax),%al
 46b:	0f be c0             	movsbl %al,%eax
 46e:	89 44 24 04          	mov    %eax,0x4(%esp)
 472:	8b 45 08             	mov    0x8(%ebp),%eax
 475:	89 04 24             	mov    %eax,(%esp)
 478:	e8 33 ff ff ff       	call   3b0 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 47d:	ff 4d f4             	decl   -0xc(%ebp)
 480:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 484:	79 db                	jns    461 <printint+0x89>
    putc(fd, buf[i]);
}
 486:	c9                   	leave  
 487:	c3                   	ret    

00000488 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 488:	55                   	push   %ebp
 489:	89 e5                	mov    %esp,%ebp
 48b:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 48e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 495:	8d 45 0c             	lea    0xc(%ebp),%eax
 498:	83 c0 04             	add    $0x4,%eax
 49b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 49e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4a5:	e9 78 01 00 00       	jmp    622 <printf+0x19a>
    c = fmt[i] & 0xff;
 4aa:	8b 55 0c             	mov    0xc(%ebp),%edx
 4ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4b0:	01 d0                	add    %edx,%eax
 4b2:	8a 00                	mov    (%eax),%al
 4b4:	0f be c0             	movsbl %al,%eax
 4b7:	25 ff 00 00 00       	and    $0xff,%eax
 4bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4bf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4c3:	75 2c                	jne    4f1 <printf+0x69>
      if(c == '%'){
 4c5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4c9:	75 0c                	jne    4d7 <printf+0x4f>
        state = '%';
 4cb:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4d2:	e9 48 01 00 00       	jmp    61f <printf+0x197>
      } else {
        putc(fd, c);
 4d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4da:	0f be c0             	movsbl %al,%eax
 4dd:	89 44 24 04          	mov    %eax,0x4(%esp)
 4e1:	8b 45 08             	mov    0x8(%ebp),%eax
 4e4:	89 04 24             	mov    %eax,(%esp)
 4e7:	e8 c4 fe ff ff       	call   3b0 <putc>
 4ec:	e9 2e 01 00 00       	jmp    61f <printf+0x197>
      }
    } else if(state == '%'){
 4f1:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4f5:	0f 85 24 01 00 00    	jne    61f <printf+0x197>
      if(c == 'd'){
 4fb:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4ff:	75 2d                	jne    52e <printf+0xa6>
        printint(fd, *ap, 10, 1);
 501:	8b 45 e8             	mov    -0x18(%ebp),%eax
 504:	8b 00                	mov    (%eax),%eax
 506:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 50d:	00 
 50e:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 515:	00 
 516:	89 44 24 04          	mov    %eax,0x4(%esp)
 51a:	8b 45 08             	mov    0x8(%ebp),%eax
 51d:	89 04 24             	mov    %eax,(%esp)
 520:	e8 b3 fe ff ff       	call   3d8 <printint>
        ap++;
 525:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 529:	e9 ea 00 00 00       	jmp    618 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 52e:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 532:	74 06                	je     53a <printf+0xb2>
 534:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 538:	75 2d                	jne    567 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 53a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 53d:	8b 00                	mov    (%eax),%eax
 53f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 546:	00 
 547:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 54e:	00 
 54f:	89 44 24 04          	mov    %eax,0x4(%esp)
 553:	8b 45 08             	mov    0x8(%ebp),%eax
 556:	89 04 24             	mov    %eax,(%esp)
 559:	e8 7a fe ff ff       	call   3d8 <printint>
        ap++;
 55e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 562:	e9 b1 00 00 00       	jmp    618 <printf+0x190>
      } else if(c == 's'){
 567:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 56b:	75 43                	jne    5b0 <printf+0x128>
        s = (char*)*ap;
 56d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 570:	8b 00                	mov    (%eax),%eax
 572:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 575:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 579:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 57d:	75 25                	jne    5a4 <printf+0x11c>
          s = "(null)";
 57f:	c7 45 f4 76 08 00 00 	movl   $0x876,-0xc(%ebp)
        while(*s != 0){
 586:	eb 1c                	jmp    5a4 <printf+0x11c>
          putc(fd, *s);
 588:	8b 45 f4             	mov    -0xc(%ebp),%eax
 58b:	8a 00                	mov    (%eax),%al
 58d:	0f be c0             	movsbl %al,%eax
 590:	89 44 24 04          	mov    %eax,0x4(%esp)
 594:	8b 45 08             	mov    0x8(%ebp),%eax
 597:	89 04 24             	mov    %eax,(%esp)
 59a:	e8 11 fe ff ff       	call   3b0 <putc>
          s++;
 59f:	ff 45 f4             	incl   -0xc(%ebp)
 5a2:	eb 01                	jmp    5a5 <printf+0x11d>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5a4:	90                   	nop
 5a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5a8:	8a 00                	mov    (%eax),%al
 5aa:	84 c0                	test   %al,%al
 5ac:	75 da                	jne    588 <printf+0x100>
 5ae:	eb 68                	jmp    618 <printf+0x190>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5b0:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5b4:	75 1d                	jne    5d3 <printf+0x14b>
        putc(fd, *ap);
 5b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5b9:	8b 00                	mov    (%eax),%eax
 5bb:	0f be c0             	movsbl %al,%eax
 5be:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c2:	8b 45 08             	mov    0x8(%ebp),%eax
 5c5:	89 04 24             	mov    %eax,(%esp)
 5c8:	e8 e3 fd ff ff       	call   3b0 <putc>
        ap++;
 5cd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5d1:	eb 45                	jmp    618 <printf+0x190>
      } else if(c == '%'){
 5d3:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5d7:	75 17                	jne    5f0 <printf+0x168>
        putc(fd, c);
 5d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5dc:	0f be c0             	movsbl %al,%eax
 5df:	89 44 24 04          	mov    %eax,0x4(%esp)
 5e3:	8b 45 08             	mov    0x8(%ebp),%eax
 5e6:	89 04 24             	mov    %eax,(%esp)
 5e9:	e8 c2 fd ff ff       	call   3b0 <putc>
 5ee:	eb 28                	jmp    618 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5f0:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5f7:	00 
 5f8:	8b 45 08             	mov    0x8(%ebp),%eax
 5fb:	89 04 24             	mov    %eax,(%esp)
 5fe:	e8 ad fd ff ff       	call   3b0 <putc>
        putc(fd, c);
 603:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 606:	0f be c0             	movsbl %al,%eax
 609:	89 44 24 04          	mov    %eax,0x4(%esp)
 60d:	8b 45 08             	mov    0x8(%ebp),%eax
 610:	89 04 24             	mov    %eax,(%esp)
 613:	e8 98 fd ff ff       	call   3b0 <putc>
      }
      state = 0;
 618:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 61f:	ff 45 f0             	incl   -0x10(%ebp)
 622:	8b 55 0c             	mov    0xc(%ebp),%edx
 625:	8b 45 f0             	mov    -0x10(%ebp),%eax
 628:	01 d0                	add    %edx,%eax
 62a:	8a 00                	mov    (%eax),%al
 62c:	84 c0                	test   %al,%al
 62e:	0f 85 76 fe ff ff    	jne    4aa <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 634:	c9                   	leave  
 635:	c3                   	ret    
 636:	66 90                	xchg   %ax,%ax

00000638 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 638:	55                   	push   %ebp
 639:	89 e5                	mov    %esp,%ebp
 63b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 63e:	8b 45 08             	mov    0x8(%ebp),%eax
 641:	83 e8 08             	sub    $0x8,%eax
 644:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 647:	a1 f8 0a 00 00       	mov    0xaf8,%eax
 64c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 64f:	eb 24                	jmp    675 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 651:	8b 45 fc             	mov    -0x4(%ebp),%eax
 654:	8b 00                	mov    (%eax),%eax
 656:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 659:	77 12                	ja     66d <free+0x35>
 65b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 661:	77 24                	ja     687 <free+0x4f>
 663:	8b 45 fc             	mov    -0x4(%ebp),%eax
 666:	8b 00                	mov    (%eax),%eax
 668:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 66b:	77 1a                	ja     687 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 66d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 670:	8b 00                	mov    (%eax),%eax
 672:	89 45 fc             	mov    %eax,-0x4(%ebp)
 675:	8b 45 f8             	mov    -0x8(%ebp),%eax
 678:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 67b:	76 d4                	jbe    651 <free+0x19>
 67d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 680:	8b 00                	mov    (%eax),%eax
 682:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 685:	76 ca                	jbe    651 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 687:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68a:	8b 40 04             	mov    0x4(%eax),%eax
 68d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 694:	8b 45 f8             	mov    -0x8(%ebp),%eax
 697:	01 c2                	add    %eax,%edx
 699:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69c:	8b 00                	mov    (%eax),%eax
 69e:	39 c2                	cmp    %eax,%edx
 6a0:	75 24                	jne    6c6 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a5:	8b 50 04             	mov    0x4(%eax),%edx
 6a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ab:	8b 00                	mov    (%eax),%eax
 6ad:	8b 40 04             	mov    0x4(%eax),%eax
 6b0:	01 c2                	add    %eax,%edx
 6b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b5:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bb:	8b 00                	mov    (%eax),%eax
 6bd:	8b 10                	mov    (%eax),%edx
 6bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c2:	89 10                	mov    %edx,(%eax)
 6c4:	eb 0a                	jmp    6d0 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c9:	8b 10                	mov    (%eax),%edx
 6cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ce:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d3:	8b 40 04             	mov    0x4(%eax),%eax
 6d6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e0:	01 d0                	add    %edx,%eax
 6e2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6e5:	75 20                	jne    707 <free+0xcf>
    p->s.size += bp->s.size;
 6e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ea:	8b 50 04             	mov    0x4(%eax),%edx
 6ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f0:	8b 40 04             	mov    0x4(%eax),%eax
 6f3:	01 c2                	add    %eax,%edx
 6f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f8:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fe:	8b 10                	mov    (%eax),%edx
 700:	8b 45 fc             	mov    -0x4(%ebp),%eax
 703:	89 10                	mov    %edx,(%eax)
 705:	eb 08                	jmp    70f <free+0xd7>
  } else
    p->s.ptr = bp;
 707:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 70d:	89 10                	mov    %edx,(%eax)
  freep = p;
 70f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 712:	a3 f8 0a 00 00       	mov    %eax,0xaf8
}
 717:	c9                   	leave  
 718:	c3                   	ret    

00000719 <morecore>:

static Header*
morecore(uint nu)
{
 719:	55                   	push   %ebp
 71a:	89 e5                	mov    %esp,%ebp
 71c:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 71f:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 726:	77 07                	ja     72f <morecore+0x16>
    nu = 4096;
 728:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 72f:	8b 45 08             	mov    0x8(%ebp),%eax
 732:	c1 e0 03             	shl    $0x3,%eax
 735:	89 04 24             	mov    %eax,(%esp)
 738:	e8 43 fc ff ff       	call   380 <sbrk>
 73d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 740:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 744:	75 07                	jne    74d <morecore+0x34>
    return 0;
 746:	b8 00 00 00 00       	mov    $0x0,%eax
 74b:	eb 22                	jmp    76f <morecore+0x56>
  hp = (Header*)p;
 74d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 750:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 753:	8b 45 f0             	mov    -0x10(%ebp),%eax
 756:	8b 55 08             	mov    0x8(%ebp),%edx
 759:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 75c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 75f:	83 c0 08             	add    $0x8,%eax
 762:	89 04 24             	mov    %eax,(%esp)
 765:	e8 ce fe ff ff       	call   638 <free>
  return freep;
 76a:	a1 f8 0a 00 00       	mov    0xaf8,%eax
}
 76f:	c9                   	leave  
 770:	c3                   	ret    

00000771 <malloc>:

void*
malloc(uint nbytes)
{
 771:	55                   	push   %ebp
 772:	89 e5                	mov    %esp,%ebp
 774:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 777:	8b 45 08             	mov    0x8(%ebp),%eax
 77a:	83 c0 07             	add    $0x7,%eax
 77d:	c1 e8 03             	shr    $0x3,%eax
 780:	40                   	inc    %eax
 781:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 784:	a1 f8 0a 00 00       	mov    0xaf8,%eax
 789:	89 45 f0             	mov    %eax,-0x10(%ebp)
 78c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 790:	75 23                	jne    7b5 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 792:	c7 45 f0 f0 0a 00 00 	movl   $0xaf0,-0x10(%ebp)
 799:	8b 45 f0             	mov    -0x10(%ebp),%eax
 79c:	a3 f8 0a 00 00       	mov    %eax,0xaf8
 7a1:	a1 f8 0a 00 00       	mov    0xaf8,%eax
 7a6:	a3 f0 0a 00 00       	mov    %eax,0xaf0
    base.s.size = 0;
 7ab:	c7 05 f4 0a 00 00 00 	movl   $0x0,0xaf4
 7b2:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b8:	8b 00                	mov    (%eax),%eax
 7ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c0:	8b 40 04             	mov    0x4(%eax),%eax
 7c3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7c6:	72 4d                	jb     815 <malloc+0xa4>
      if(p->s.size == nunits)
 7c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cb:	8b 40 04             	mov    0x4(%eax),%eax
 7ce:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7d1:	75 0c                	jne    7df <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 7d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d6:	8b 10                	mov    (%eax),%edx
 7d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7db:	89 10                	mov    %edx,(%eax)
 7dd:	eb 26                	jmp    805 <malloc+0x94>
      else {
        p->s.size -= nunits;
 7df:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e2:	8b 40 04             	mov    0x4(%eax),%eax
 7e5:	89 c2                	mov    %eax,%edx
 7e7:	2b 55 ec             	sub    -0x14(%ebp),%edx
 7ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ed:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f3:	8b 40 04             	mov    0x4(%eax),%eax
 7f6:	c1 e0 03             	shl    $0x3,%eax
 7f9:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ff:	8b 55 ec             	mov    -0x14(%ebp),%edx
 802:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 805:	8b 45 f0             	mov    -0x10(%ebp),%eax
 808:	a3 f8 0a 00 00       	mov    %eax,0xaf8
      return (void*)(p + 1);
 80d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 810:	83 c0 08             	add    $0x8,%eax
 813:	eb 38                	jmp    84d <malloc+0xdc>
    }
    if(p == freep)
 815:	a1 f8 0a 00 00       	mov    0xaf8,%eax
 81a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 81d:	75 1b                	jne    83a <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 81f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 822:	89 04 24             	mov    %eax,(%esp)
 825:	e8 ef fe ff ff       	call   719 <morecore>
 82a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 82d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 831:	75 07                	jne    83a <malloc+0xc9>
        return 0;
 833:	b8 00 00 00 00       	mov    $0x0,%eax
 838:	eb 13                	jmp    84d <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 83a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 840:	8b 45 f4             	mov    -0xc(%ebp),%eax
 843:	8b 00                	mov    (%eax),%eax
 845:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 848:	e9 70 ff ff ff       	jmp    7bd <malloc+0x4c>
}
 84d:	c9                   	leave  
 84e:	c3                   	ret    
