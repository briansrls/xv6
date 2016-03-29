
_stressfs:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	57                   	push   %edi
   4:	56                   	push   %esi
   5:	53                   	push   %ebx
   6:	83 e4 f0             	and    $0xfffffff0,%esp
   9:	81 ec 30 02 00 00    	sub    $0x230,%esp
  int fd, i;
  char path[] = "stressfs0";
   f:	8d 94 24 1e 02 00 00 	lea    0x21e(%esp),%edx
  16:	bb a2 09 00 00       	mov    $0x9a2,%ebx
  1b:	b8 0a 00 00 00       	mov    $0xa,%eax
  20:	89 d7                	mov    %edx,%edi
  22:	89 de                	mov    %ebx,%esi
  24:	89 c1                	mov    %eax,%ecx
  26:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  char data[512];

  printf(1, "stressfs starting\n");
  28:	c7 44 24 04 7f 09 00 	movl   $0x97f,0x4(%esp)
  2f:	00 
  30:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  37:	e8 7c 05 00 00       	call   5b8 <printf>
  memset(data, 'a', sizeof(data));
  3c:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  43:	00 
  44:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  4b:	00 
  4c:	8d 44 24 1e          	lea    0x1e(%esp),%eax
  50:	89 04 24             	mov    %eax,(%esp)
  53:	e8 08 02 00 00       	call   260 <memset>

  for(i = 0; i < 4; i++)
  58:	c7 84 24 2c 02 00 00 	movl   $0x0,0x22c(%esp)
  5f:	00 00 00 00 
  63:	eb 10                	jmp    75 <main+0x75>
    if(fork() > 0)
  65:	e8 b6 03 00 00       	call   420 <fork>
  6a:	85 c0                	test   %eax,%eax
  6c:	7f 13                	jg     81 <main+0x81>
  char data[512];

  printf(1, "stressfs starting\n");
  memset(data, 'a', sizeof(data));

  for(i = 0; i < 4; i++)
  6e:	ff 84 24 2c 02 00 00 	incl   0x22c(%esp)
  75:	83 bc 24 2c 02 00 00 	cmpl   $0x3,0x22c(%esp)
  7c:	03 
  7d:	7e e6                	jle    65 <main+0x65>
  7f:	eb 01                	jmp    82 <main+0x82>
    if(fork() > 0)
      break;
  81:	90                   	nop

  printf(1, "write %d\n", i);
  82:	8b 84 24 2c 02 00 00 	mov    0x22c(%esp),%eax
  89:	89 44 24 08          	mov    %eax,0x8(%esp)
  8d:	c7 44 24 04 92 09 00 	movl   $0x992,0x4(%esp)
  94:	00 
  95:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  9c:	e8 17 05 00 00       	call   5b8 <printf>

  path[8] += i;
  a1:	8a 84 24 26 02 00 00 	mov    0x226(%esp),%al
  a8:	88 c2                	mov    %al,%dl
  aa:	8b 84 24 2c 02 00 00 	mov    0x22c(%esp),%eax
  b1:	01 d0                	add    %edx,%eax
  b3:	88 84 24 26 02 00 00 	mov    %al,0x226(%esp)
  fd = open(path, O_CREATE | O_RDWR);
  ba:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  c1:	00 
  c2:	8d 84 24 1e 02 00 00 	lea    0x21e(%esp),%eax
  c9:	89 04 24             	mov    %eax,(%esp)
  cc:	e8 97 03 00 00       	call   468 <open>
  d1:	89 84 24 28 02 00 00 	mov    %eax,0x228(%esp)
  for(i = 0; i < 20; i++)
  d8:	c7 84 24 2c 02 00 00 	movl   $0x0,0x22c(%esp)
  df:	00 00 00 00 
  e3:	eb 26                	jmp    10b <main+0x10b>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  e5:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  ec:	00 
  ed:	8d 44 24 1e          	lea    0x1e(%esp),%eax
  f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  f5:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
  fc:	89 04 24             	mov    %eax,(%esp)
  ff:	e8 44 03 00 00       	call   448 <write>

  printf(1, "write %d\n", i);

  path[8] += i;
  fd = open(path, O_CREATE | O_RDWR);
  for(i = 0; i < 20; i++)
 104:	ff 84 24 2c 02 00 00 	incl   0x22c(%esp)
 10b:	83 bc 24 2c 02 00 00 	cmpl   $0x13,0x22c(%esp)
 112:	13 
 113:	7e d0                	jle    e5 <main+0xe5>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  close(fd);
 115:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 11c:	89 04 24             	mov    %eax,(%esp)
 11f:	e8 2c 03 00 00       	call   450 <close>

  printf(1, "read\n");
 124:	c7 44 24 04 9c 09 00 	movl   $0x99c,0x4(%esp)
 12b:	00 
 12c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 133:	e8 80 04 00 00       	call   5b8 <printf>

  fd = open(path, O_RDONLY);
 138:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 13f:	00 
 140:	8d 84 24 1e 02 00 00 	lea    0x21e(%esp),%eax
 147:	89 04 24             	mov    %eax,(%esp)
 14a:	e8 19 03 00 00       	call   468 <open>
 14f:	89 84 24 28 02 00 00 	mov    %eax,0x228(%esp)
  for (i = 0; i < 20; i++)
 156:	c7 84 24 2c 02 00 00 	movl   $0x0,0x22c(%esp)
 15d:	00 00 00 00 
 161:	eb 26                	jmp    189 <main+0x189>
    read(fd, data, sizeof(data));
 163:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
 16a:	00 
 16b:	8d 44 24 1e          	lea    0x1e(%esp),%eax
 16f:	89 44 24 04          	mov    %eax,0x4(%esp)
 173:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 17a:	89 04 24             	mov    %eax,(%esp)
 17d:	e8 be 02 00 00       	call   440 <read>
  close(fd);

  printf(1, "read\n");

  fd = open(path, O_RDONLY);
  for (i = 0; i < 20; i++)
 182:	ff 84 24 2c 02 00 00 	incl   0x22c(%esp)
 189:	83 bc 24 2c 02 00 00 	cmpl   $0x13,0x22c(%esp)
 190:	13 
 191:	7e d0                	jle    163 <main+0x163>
    read(fd, data, sizeof(data));
  close(fd);
 193:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 19a:	89 04 24             	mov    %eax,(%esp)
 19d:	e8 ae 02 00 00       	call   450 <close>

  wait();
 1a2:	e8 89 02 00 00       	call   430 <wait>
  
  exit();
 1a7:	e8 7c 02 00 00       	call   428 <exit>

000001ac <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1ac:	55                   	push   %ebp
 1ad:	89 e5                	mov    %esp,%ebp
 1af:	57                   	push   %edi
 1b0:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1b4:	8b 55 10             	mov    0x10(%ebp),%edx
 1b7:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ba:	89 cb                	mov    %ecx,%ebx
 1bc:	89 df                	mov    %ebx,%edi
 1be:	89 d1                	mov    %edx,%ecx
 1c0:	fc                   	cld    
 1c1:	f3 aa                	rep stos %al,%es:(%edi)
 1c3:	89 ca                	mov    %ecx,%edx
 1c5:	89 fb                	mov    %edi,%ebx
 1c7:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1ca:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1cd:	5b                   	pop    %ebx
 1ce:	5f                   	pop    %edi
 1cf:	5d                   	pop    %ebp
 1d0:	c3                   	ret    

000001d1 <strcpy>:
#include "x86.h"
#include "signal.h"

char*
strcpy(char *s, char *t)
{
 1d1:	55                   	push   %ebp
 1d2:	89 e5                	mov    %esp,%ebp
 1d4:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1d7:	8b 45 08             	mov    0x8(%ebp),%eax
 1da:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1dd:	90                   	nop
 1de:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e1:	8a 10                	mov    (%eax),%dl
 1e3:	8b 45 08             	mov    0x8(%ebp),%eax
 1e6:	88 10                	mov    %dl,(%eax)
 1e8:	8b 45 08             	mov    0x8(%ebp),%eax
 1eb:	8a 00                	mov    (%eax),%al
 1ed:	84 c0                	test   %al,%al
 1ef:	0f 95 c0             	setne  %al
 1f2:	ff 45 08             	incl   0x8(%ebp)
 1f5:	ff 45 0c             	incl   0xc(%ebp)
 1f8:	84 c0                	test   %al,%al
 1fa:	75 e2                	jne    1de <strcpy+0xd>
    ;
  return os;
 1fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1ff:	c9                   	leave  
 200:	c3                   	ret    

00000201 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 201:	55                   	push   %ebp
 202:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 204:	eb 06                	jmp    20c <strcmp+0xb>
    p++, q++;
 206:	ff 45 08             	incl   0x8(%ebp)
 209:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 20c:	8b 45 08             	mov    0x8(%ebp),%eax
 20f:	8a 00                	mov    (%eax),%al
 211:	84 c0                	test   %al,%al
 213:	74 0e                	je     223 <strcmp+0x22>
 215:	8b 45 08             	mov    0x8(%ebp),%eax
 218:	8a 10                	mov    (%eax),%dl
 21a:	8b 45 0c             	mov    0xc(%ebp),%eax
 21d:	8a 00                	mov    (%eax),%al
 21f:	38 c2                	cmp    %al,%dl
 221:	74 e3                	je     206 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 223:	8b 45 08             	mov    0x8(%ebp),%eax
 226:	8a 00                	mov    (%eax),%al
 228:	0f b6 d0             	movzbl %al,%edx
 22b:	8b 45 0c             	mov    0xc(%ebp),%eax
 22e:	8a 00                	mov    (%eax),%al
 230:	0f b6 c0             	movzbl %al,%eax
 233:	89 d1                	mov    %edx,%ecx
 235:	29 c1                	sub    %eax,%ecx
 237:	89 c8                	mov    %ecx,%eax
}
 239:	5d                   	pop    %ebp
 23a:	c3                   	ret    

0000023b <strlen>:

uint
strlen(char *s)
{
 23b:	55                   	push   %ebp
 23c:	89 e5                	mov    %esp,%ebp
 23e:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 241:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 248:	eb 03                	jmp    24d <strlen+0x12>
 24a:	ff 45 fc             	incl   -0x4(%ebp)
 24d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 250:	8b 45 08             	mov    0x8(%ebp),%eax
 253:	01 d0                	add    %edx,%eax
 255:	8a 00                	mov    (%eax),%al
 257:	84 c0                	test   %al,%al
 259:	75 ef                	jne    24a <strlen+0xf>
    ;
  return n;
 25b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 25e:	c9                   	leave  
 25f:	c3                   	ret    

00000260 <memset>:

void*
memset(void *dst, int c, uint n)
{
 260:	55                   	push   %ebp
 261:	89 e5                	mov    %esp,%ebp
 263:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 266:	8b 45 10             	mov    0x10(%ebp),%eax
 269:	89 44 24 08          	mov    %eax,0x8(%esp)
 26d:	8b 45 0c             	mov    0xc(%ebp),%eax
 270:	89 44 24 04          	mov    %eax,0x4(%esp)
 274:	8b 45 08             	mov    0x8(%ebp),%eax
 277:	89 04 24             	mov    %eax,(%esp)
 27a:	e8 2d ff ff ff       	call   1ac <stosb>
  return dst;
 27f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 282:	c9                   	leave  
 283:	c3                   	ret    

00000284 <strchr>:

char*
strchr(const char *s, char c)
{
 284:	55                   	push   %ebp
 285:	89 e5                	mov    %esp,%ebp
 287:	83 ec 04             	sub    $0x4,%esp
 28a:	8b 45 0c             	mov    0xc(%ebp),%eax
 28d:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 290:	eb 12                	jmp    2a4 <strchr+0x20>
    if(*s == c)
 292:	8b 45 08             	mov    0x8(%ebp),%eax
 295:	8a 00                	mov    (%eax),%al
 297:	3a 45 fc             	cmp    -0x4(%ebp),%al
 29a:	75 05                	jne    2a1 <strchr+0x1d>
      return (char*)s;
 29c:	8b 45 08             	mov    0x8(%ebp),%eax
 29f:	eb 11                	jmp    2b2 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2a1:	ff 45 08             	incl   0x8(%ebp)
 2a4:	8b 45 08             	mov    0x8(%ebp),%eax
 2a7:	8a 00                	mov    (%eax),%al
 2a9:	84 c0                	test   %al,%al
 2ab:	75 e5                	jne    292 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2b2:	c9                   	leave  
 2b3:	c3                   	ret    

000002b4 <gets>:

char*
gets(char *buf, int max)
{
 2b4:	55                   	push   %ebp
 2b5:	89 e5                	mov    %esp,%ebp
 2b7:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2c1:	eb 42                	jmp    305 <gets+0x51>
    cc = read(0, &c, 1);
 2c3:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 2ca:	00 
 2cb:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2ce:	89 44 24 04          	mov    %eax,0x4(%esp)
 2d2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 2d9:	e8 62 01 00 00       	call   440 <read>
 2de:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 2e1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2e5:	7e 29                	jle    310 <gets+0x5c>
      break;
    buf[i++] = c;
 2e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2ea:	8b 45 08             	mov    0x8(%ebp),%eax
 2ed:	01 c2                	add    %eax,%edx
 2ef:	8a 45 ef             	mov    -0x11(%ebp),%al
 2f2:	88 02                	mov    %al,(%edx)
 2f4:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 2f7:	8a 45 ef             	mov    -0x11(%ebp),%al
 2fa:	3c 0a                	cmp    $0xa,%al
 2fc:	74 13                	je     311 <gets+0x5d>
 2fe:	8a 45 ef             	mov    -0x11(%ebp),%al
 301:	3c 0d                	cmp    $0xd,%al
 303:	74 0c                	je     311 <gets+0x5d>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 305:	8b 45 f4             	mov    -0xc(%ebp),%eax
 308:	40                   	inc    %eax
 309:	3b 45 0c             	cmp    0xc(%ebp),%eax
 30c:	7c b5                	jl     2c3 <gets+0xf>
 30e:	eb 01                	jmp    311 <gets+0x5d>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 310:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 311:	8b 55 f4             	mov    -0xc(%ebp),%edx
 314:	8b 45 08             	mov    0x8(%ebp),%eax
 317:	01 d0                	add    %edx,%eax
 319:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 31c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 31f:	c9                   	leave  
 320:	c3                   	ret    

00000321 <stat>:

int
stat(char *n, struct stat *st)
{
 321:	55                   	push   %ebp
 322:	89 e5                	mov    %esp,%ebp
 324:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 327:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 32e:	00 
 32f:	8b 45 08             	mov    0x8(%ebp),%eax
 332:	89 04 24             	mov    %eax,(%esp)
 335:	e8 2e 01 00 00       	call   468 <open>
 33a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 33d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 341:	79 07                	jns    34a <stat+0x29>
    return -1;
 343:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 348:	eb 23                	jmp    36d <stat+0x4c>
  r = fstat(fd, st);
 34a:	8b 45 0c             	mov    0xc(%ebp),%eax
 34d:	89 44 24 04          	mov    %eax,0x4(%esp)
 351:	8b 45 f4             	mov    -0xc(%ebp),%eax
 354:	89 04 24             	mov    %eax,(%esp)
 357:	e8 24 01 00 00       	call   480 <fstat>
 35c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 35f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 362:	89 04 24             	mov    %eax,(%esp)
 365:	e8 e6 00 00 00       	call   450 <close>
  return r;
 36a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 36d:	c9                   	leave  
 36e:	c3                   	ret    

0000036f <atoi>:

int
atoi(const char *s)
{
 36f:	55                   	push   %ebp
 370:	89 e5                	mov    %esp,%ebp
 372:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 375:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 37c:	eb 21                	jmp    39f <atoi+0x30>
    n = n*10 + *s++ - '0';
 37e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 381:	89 d0                	mov    %edx,%eax
 383:	c1 e0 02             	shl    $0x2,%eax
 386:	01 d0                	add    %edx,%eax
 388:	d1 e0                	shl    %eax
 38a:	89 c2                	mov    %eax,%edx
 38c:	8b 45 08             	mov    0x8(%ebp),%eax
 38f:	8a 00                	mov    (%eax),%al
 391:	0f be c0             	movsbl %al,%eax
 394:	01 d0                	add    %edx,%eax
 396:	83 e8 30             	sub    $0x30,%eax
 399:	89 45 fc             	mov    %eax,-0x4(%ebp)
 39c:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 39f:	8b 45 08             	mov    0x8(%ebp),%eax
 3a2:	8a 00                	mov    (%eax),%al
 3a4:	3c 2f                	cmp    $0x2f,%al
 3a6:	7e 09                	jle    3b1 <atoi+0x42>
 3a8:	8b 45 08             	mov    0x8(%ebp),%eax
 3ab:	8a 00                	mov    (%eax),%al
 3ad:	3c 39                	cmp    $0x39,%al
 3af:	7e cd                	jle    37e <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 3b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3b4:	c9                   	leave  
 3b5:	c3                   	ret    

000003b6 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3b6:	55                   	push   %ebp
 3b7:	89 e5                	mov    %esp,%ebp
 3b9:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 3bc:	8b 45 08             	mov    0x8(%ebp),%eax
 3bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3c2:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3c8:	eb 10                	jmp    3da <memmove+0x24>
    *dst++ = *src++;
 3ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3cd:	8a 10                	mov    (%eax),%dl
 3cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3d2:	88 10                	mov    %dl,(%eax)
 3d4:	ff 45 fc             	incl   -0x4(%ebp)
 3d7:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3da:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 3de:	0f 9f c0             	setg   %al
 3e1:	ff 4d 10             	decl   0x10(%ebp)
 3e4:	84 c0                	test   %al,%al
 3e6:	75 e2                	jne    3ca <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 3e8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3eb:	c9                   	leave  
 3ec:	c3                   	ret    

000003ed <trampoline>:
 3ed:	5a                   	pop    %edx
 3ee:	59                   	pop    %ecx
 3ef:	58                   	pop    %eax
 3f0:	03 25 04 00 00 00    	add    0x4,%esp
 3f6:	c9                   	leave  
 3f7:	c3                   	ret    

000003f8 <signal>:
	"addl 4, %esp\n\t"
	"leave\n\t"
	"ret\n\t"
);
int signal(int signum, sighandler_t handler) 
{
 3f8:	55                   	push   %ebp
 3f9:	89 e5                	mov    %esp,%ebp
 3fb:	83 ec 18             	sub    $0x18,%esp
	register_signal_handler(signum, handler, trampoline);
 3fe:	c7 44 24 08 ed 03 00 	movl   $0x3ed,0x8(%esp)
 405:	00 
 406:	8b 45 0c             	mov    0xc(%ebp),%eax
 409:	89 44 24 04          	mov    %eax,0x4(%esp)
 40d:	8b 45 08             	mov    0x8(%ebp),%eax
 410:	89 04 24             	mov    %eax,(%esp)
 413:	e8 b8 00 00 00       	call   4d0 <register_signal_handler>
	return 0;
 418:	b8 00 00 00 00       	mov    $0x0,%eax
}
 41d:	c9                   	leave  
 41e:	c3                   	ret    
 41f:	90                   	nop

00000420 <fork>:
 420:	b8 01 00 00 00       	mov    $0x1,%eax
 425:	cd 40                	int    $0x40
 427:	c3                   	ret    

00000428 <exit>:
 428:	b8 02 00 00 00       	mov    $0x2,%eax
 42d:	cd 40                	int    $0x40
 42f:	c3                   	ret    

00000430 <wait>:
 430:	b8 03 00 00 00       	mov    $0x3,%eax
 435:	cd 40                	int    $0x40
 437:	c3                   	ret    

00000438 <pipe>:
 438:	b8 04 00 00 00       	mov    $0x4,%eax
 43d:	cd 40                	int    $0x40
 43f:	c3                   	ret    

00000440 <read>:
 440:	b8 05 00 00 00       	mov    $0x5,%eax
 445:	cd 40                	int    $0x40
 447:	c3                   	ret    

00000448 <write>:
 448:	b8 10 00 00 00       	mov    $0x10,%eax
 44d:	cd 40                	int    $0x40
 44f:	c3                   	ret    

00000450 <close>:
 450:	b8 15 00 00 00       	mov    $0x15,%eax
 455:	cd 40                	int    $0x40
 457:	c3                   	ret    

00000458 <kill>:
 458:	b8 06 00 00 00       	mov    $0x6,%eax
 45d:	cd 40                	int    $0x40
 45f:	c3                   	ret    

00000460 <exec>:
 460:	b8 07 00 00 00       	mov    $0x7,%eax
 465:	cd 40                	int    $0x40
 467:	c3                   	ret    

00000468 <open>:
 468:	b8 0f 00 00 00       	mov    $0xf,%eax
 46d:	cd 40                	int    $0x40
 46f:	c3                   	ret    

00000470 <mknod>:
 470:	b8 11 00 00 00       	mov    $0x11,%eax
 475:	cd 40                	int    $0x40
 477:	c3                   	ret    

00000478 <unlink>:
 478:	b8 12 00 00 00       	mov    $0x12,%eax
 47d:	cd 40                	int    $0x40
 47f:	c3                   	ret    

00000480 <fstat>:
 480:	b8 08 00 00 00       	mov    $0x8,%eax
 485:	cd 40                	int    $0x40
 487:	c3                   	ret    

00000488 <link>:
 488:	b8 13 00 00 00       	mov    $0x13,%eax
 48d:	cd 40                	int    $0x40
 48f:	c3                   	ret    

00000490 <mkdir>:
 490:	b8 14 00 00 00       	mov    $0x14,%eax
 495:	cd 40                	int    $0x40
 497:	c3                   	ret    

00000498 <chdir>:
 498:	b8 09 00 00 00       	mov    $0x9,%eax
 49d:	cd 40                	int    $0x40
 49f:	c3                   	ret    

000004a0 <dup>:
 4a0:	b8 0a 00 00 00       	mov    $0xa,%eax
 4a5:	cd 40                	int    $0x40
 4a7:	c3                   	ret    

000004a8 <getpid>:
 4a8:	b8 0b 00 00 00       	mov    $0xb,%eax
 4ad:	cd 40                	int    $0x40
 4af:	c3                   	ret    

000004b0 <sbrk>:
 4b0:	b8 0c 00 00 00       	mov    $0xc,%eax
 4b5:	cd 40                	int    $0x40
 4b7:	c3                   	ret    

000004b8 <sleep>:
 4b8:	b8 0d 00 00 00       	mov    $0xd,%eax
 4bd:	cd 40                	int    $0x40
 4bf:	c3                   	ret    

000004c0 <uptime>:
 4c0:	b8 0e 00 00 00       	mov    $0xe,%eax
 4c5:	cd 40                	int    $0x40
 4c7:	c3                   	ret    

000004c8 <halt>:
 4c8:	b8 16 00 00 00       	mov    $0x16,%eax
 4cd:	cd 40                	int    $0x40
 4cf:	c3                   	ret    

000004d0 <register_signal_handler>:
 4d0:	b8 17 00 00 00       	mov    $0x17,%eax
 4d5:	cd 40                	int    $0x40
 4d7:	c3                   	ret    

000004d8 <alarm>:
 4d8:	b8 18 00 00 00       	mov    $0x18,%eax
 4dd:	cd 40                	int    $0x40
 4df:	c3                   	ret    

000004e0 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4e0:	55                   	push   %ebp
 4e1:	89 e5                	mov    %esp,%ebp
 4e3:	83 ec 28             	sub    $0x28,%esp
 4e6:	8b 45 0c             	mov    0xc(%ebp),%eax
 4e9:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4ec:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4f3:	00 
 4f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4f7:	89 44 24 04          	mov    %eax,0x4(%esp)
 4fb:	8b 45 08             	mov    0x8(%ebp),%eax
 4fe:	89 04 24             	mov    %eax,(%esp)
 501:	e8 42 ff ff ff       	call   448 <write>
}
 506:	c9                   	leave  
 507:	c3                   	ret    

00000508 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 508:	55                   	push   %ebp
 509:	89 e5                	mov    %esp,%ebp
 50b:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 50e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 515:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 519:	74 17                	je     532 <printint+0x2a>
 51b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 51f:	79 11                	jns    532 <printint+0x2a>
    neg = 1;
 521:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 528:	8b 45 0c             	mov    0xc(%ebp),%eax
 52b:	f7 d8                	neg    %eax
 52d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 530:	eb 06                	jmp    538 <printint+0x30>
  } else {
    x = xx;
 532:	8b 45 0c             	mov    0xc(%ebp),%eax
 535:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 538:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 53f:	8b 4d 10             	mov    0x10(%ebp),%ecx
 542:	8b 45 ec             	mov    -0x14(%ebp),%eax
 545:	ba 00 00 00 00       	mov    $0x0,%edx
 54a:	f7 f1                	div    %ecx
 54c:	89 d0                	mov    %edx,%eax
 54e:	8a 80 14 0c 00 00    	mov    0xc14(%eax),%al
 554:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 557:	8b 55 f4             	mov    -0xc(%ebp),%edx
 55a:	01 ca                	add    %ecx,%edx
 55c:	88 02                	mov    %al,(%edx)
 55e:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 561:	8b 55 10             	mov    0x10(%ebp),%edx
 564:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 567:	8b 45 ec             	mov    -0x14(%ebp),%eax
 56a:	ba 00 00 00 00       	mov    $0x0,%edx
 56f:	f7 75 d4             	divl   -0x2c(%ebp)
 572:	89 45 ec             	mov    %eax,-0x14(%ebp)
 575:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 579:	75 c4                	jne    53f <printint+0x37>
  if(neg)
 57b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 57f:	74 2c                	je     5ad <printint+0xa5>
    buf[i++] = '-';
 581:	8d 55 dc             	lea    -0x24(%ebp),%edx
 584:	8b 45 f4             	mov    -0xc(%ebp),%eax
 587:	01 d0                	add    %edx,%eax
 589:	c6 00 2d             	movb   $0x2d,(%eax)
 58c:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 58f:	eb 1c                	jmp    5ad <printint+0xa5>
    putc(fd, buf[i]);
 591:	8d 55 dc             	lea    -0x24(%ebp),%edx
 594:	8b 45 f4             	mov    -0xc(%ebp),%eax
 597:	01 d0                	add    %edx,%eax
 599:	8a 00                	mov    (%eax),%al
 59b:	0f be c0             	movsbl %al,%eax
 59e:	89 44 24 04          	mov    %eax,0x4(%esp)
 5a2:	8b 45 08             	mov    0x8(%ebp),%eax
 5a5:	89 04 24             	mov    %eax,(%esp)
 5a8:	e8 33 ff ff ff       	call   4e0 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5ad:	ff 4d f4             	decl   -0xc(%ebp)
 5b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5b4:	79 db                	jns    591 <printint+0x89>
    putc(fd, buf[i]);
}
 5b6:	c9                   	leave  
 5b7:	c3                   	ret    

000005b8 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5b8:	55                   	push   %ebp
 5b9:	89 e5                	mov    %esp,%ebp
 5bb:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5be:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5c5:	8d 45 0c             	lea    0xc(%ebp),%eax
 5c8:	83 c0 04             	add    $0x4,%eax
 5cb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5ce:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5d5:	e9 78 01 00 00       	jmp    752 <printf+0x19a>
    c = fmt[i] & 0xff;
 5da:	8b 55 0c             	mov    0xc(%ebp),%edx
 5dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5e0:	01 d0                	add    %edx,%eax
 5e2:	8a 00                	mov    (%eax),%al
 5e4:	0f be c0             	movsbl %al,%eax
 5e7:	25 ff 00 00 00       	and    $0xff,%eax
 5ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5ef:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5f3:	75 2c                	jne    621 <printf+0x69>
      if(c == '%'){
 5f5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5f9:	75 0c                	jne    607 <printf+0x4f>
        state = '%';
 5fb:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 602:	e9 48 01 00 00       	jmp    74f <printf+0x197>
      } else {
        putc(fd, c);
 607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 60a:	0f be c0             	movsbl %al,%eax
 60d:	89 44 24 04          	mov    %eax,0x4(%esp)
 611:	8b 45 08             	mov    0x8(%ebp),%eax
 614:	89 04 24             	mov    %eax,(%esp)
 617:	e8 c4 fe ff ff       	call   4e0 <putc>
 61c:	e9 2e 01 00 00       	jmp    74f <printf+0x197>
      }
    } else if(state == '%'){
 621:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 625:	0f 85 24 01 00 00    	jne    74f <printf+0x197>
      if(c == 'd'){
 62b:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 62f:	75 2d                	jne    65e <printf+0xa6>
        printint(fd, *ap, 10, 1);
 631:	8b 45 e8             	mov    -0x18(%ebp),%eax
 634:	8b 00                	mov    (%eax),%eax
 636:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 63d:	00 
 63e:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 645:	00 
 646:	89 44 24 04          	mov    %eax,0x4(%esp)
 64a:	8b 45 08             	mov    0x8(%ebp),%eax
 64d:	89 04 24             	mov    %eax,(%esp)
 650:	e8 b3 fe ff ff       	call   508 <printint>
        ap++;
 655:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 659:	e9 ea 00 00 00       	jmp    748 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 65e:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 662:	74 06                	je     66a <printf+0xb2>
 664:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 668:	75 2d                	jne    697 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 66a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 66d:	8b 00                	mov    (%eax),%eax
 66f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 676:	00 
 677:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 67e:	00 
 67f:	89 44 24 04          	mov    %eax,0x4(%esp)
 683:	8b 45 08             	mov    0x8(%ebp),%eax
 686:	89 04 24             	mov    %eax,(%esp)
 689:	e8 7a fe ff ff       	call   508 <printint>
        ap++;
 68e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 692:	e9 b1 00 00 00       	jmp    748 <printf+0x190>
      } else if(c == 's'){
 697:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 69b:	75 43                	jne    6e0 <printf+0x128>
        s = (char*)*ap;
 69d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6a0:	8b 00                	mov    (%eax),%eax
 6a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6a5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6ad:	75 25                	jne    6d4 <printf+0x11c>
          s = "(null)";
 6af:	c7 45 f4 ac 09 00 00 	movl   $0x9ac,-0xc(%ebp)
        while(*s != 0){
 6b6:	eb 1c                	jmp    6d4 <printf+0x11c>
          putc(fd, *s);
 6b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6bb:	8a 00                	mov    (%eax),%al
 6bd:	0f be c0             	movsbl %al,%eax
 6c0:	89 44 24 04          	mov    %eax,0x4(%esp)
 6c4:	8b 45 08             	mov    0x8(%ebp),%eax
 6c7:	89 04 24             	mov    %eax,(%esp)
 6ca:	e8 11 fe ff ff       	call   4e0 <putc>
          s++;
 6cf:	ff 45 f4             	incl   -0xc(%ebp)
 6d2:	eb 01                	jmp    6d5 <printf+0x11d>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6d4:	90                   	nop
 6d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6d8:	8a 00                	mov    (%eax),%al
 6da:	84 c0                	test   %al,%al
 6dc:	75 da                	jne    6b8 <printf+0x100>
 6de:	eb 68                	jmp    748 <printf+0x190>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6e0:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6e4:	75 1d                	jne    703 <printf+0x14b>
        putc(fd, *ap);
 6e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6e9:	8b 00                	mov    (%eax),%eax
 6eb:	0f be c0             	movsbl %al,%eax
 6ee:	89 44 24 04          	mov    %eax,0x4(%esp)
 6f2:	8b 45 08             	mov    0x8(%ebp),%eax
 6f5:	89 04 24             	mov    %eax,(%esp)
 6f8:	e8 e3 fd ff ff       	call   4e0 <putc>
        ap++;
 6fd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 701:	eb 45                	jmp    748 <printf+0x190>
      } else if(c == '%'){
 703:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 707:	75 17                	jne    720 <printf+0x168>
        putc(fd, c);
 709:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 70c:	0f be c0             	movsbl %al,%eax
 70f:	89 44 24 04          	mov    %eax,0x4(%esp)
 713:	8b 45 08             	mov    0x8(%ebp),%eax
 716:	89 04 24             	mov    %eax,(%esp)
 719:	e8 c2 fd ff ff       	call   4e0 <putc>
 71e:	eb 28                	jmp    748 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 720:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 727:	00 
 728:	8b 45 08             	mov    0x8(%ebp),%eax
 72b:	89 04 24             	mov    %eax,(%esp)
 72e:	e8 ad fd ff ff       	call   4e0 <putc>
        putc(fd, c);
 733:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 736:	0f be c0             	movsbl %al,%eax
 739:	89 44 24 04          	mov    %eax,0x4(%esp)
 73d:	8b 45 08             	mov    0x8(%ebp),%eax
 740:	89 04 24             	mov    %eax,(%esp)
 743:	e8 98 fd ff ff       	call   4e0 <putc>
      }
      state = 0;
 748:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 74f:	ff 45 f0             	incl   -0x10(%ebp)
 752:	8b 55 0c             	mov    0xc(%ebp),%edx
 755:	8b 45 f0             	mov    -0x10(%ebp),%eax
 758:	01 d0                	add    %edx,%eax
 75a:	8a 00                	mov    (%eax),%al
 75c:	84 c0                	test   %al,%al
 75e:	0f 85 76 fe ff ff    	jne    5da <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 764:	c9                   	leave  
 765:	c3                   	ret    
 766:	66 90                	xchg   %ax,%ax

00000768 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 768:	55                   	push   %ebp
 769:	89 e5                	mov    %esp,%ebp
 76b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 76e:	8b 45 08             	mov    0x8(%ebp),%eax
 771:	83 e8 08             	sub    $0x8,%eax
 774:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 777:	a1 30 0c 00 00       	mov    0xc30,%eax
 77c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 77f:	eb 24                	jmp    7a5 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 781:	8b 45 fc             	mov    -0x4(%ebp),%eax
 784:	8b 00                	mov    (%eax),%eax
 786:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 789:	77 12                	ja     79d <free+0x35>
 78b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 78e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 791:	77 24                	ja     7b7 <free+0x4f>
 793:	8b 45 fc             	mov    -0x4(%ebp),%eax
 796:	8b 00                	mov    (%eax),%eax
 798:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 79b:	77 1a                	ja     7b7 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 79d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a0:	8b 00                	mov    (%eax),%eax
 7a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7ab:	76 d4                	jbe    781 <free+0x19>
 7ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b0:	8b 00                	mov    (%eax),%eax
 7b2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7b5:	76 ca                	jbe    781 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ba:	8b 40 04             	mov    0x4(%eax),%eax
 7bd:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c7:	01 c2                	add    %eax,%edx
 7c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7cc:	8b 00                	mov    (%eax),%eax
 7ce:	39 c2                	cmp    %eax,%edx
 7d0:	75 24                	jne    7f6 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d5:	8b 50 04             	mov    0x4(%eax),%edx
 7d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7db:	8b 00                	mov    (%eax),%eax
 7dd:	8b 40 04             	mov    0x4(%eax),%eax
 7e0:	01 c2                	add    %eax,%edx
 7e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e5:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7eb:	8b 00                	mov    (%eax),%eax
 7ed:	8b 10                	mov    (%eax),%edx
 7ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f2:	89 10                	mov    %edx,(%eax)
 7f4:	eb 0a                	jmp    800 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f9:	8b 10                	mov    (%eax),%edx
 7fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7fe:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 800:	8b 45 fc             	mov    -0x4(%ebp),%eax
 803:	8b 40 04             	mov    0x4(%eax),%eax
 806:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 80d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 810:	01 d0                	add    %edx,%eax
 812:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 815:	75 20                	jne    837 <free+0xcf>
    p->s.size += bp->s.size;
 817:	8b 45 fc             	mov    -0x4(%ebp),%eax
 81a:	8b 50 04             	mov    0x4(%eax),%edx
 81d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 820:	8b 40 04             	mov    0x4(%eax),%eax
 823:	01 c2                	add    %eax,%edx
 825:	8b 45 fc             	mov    -0x4(%ebp),%eax
 828:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 82b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 82e:	8b 10                	mov    (%eax),%edx
 830:	8b 45 fc             	mov    -0x4(%ebp),%eax
 833:	89 10                	mov    %edx,(%eax)
 835:	eb 08                	jmp    83f <free+0xd7>
  } else
    p->s.ptr = bp;
 837:	8b 45 fc             	mov    -0x4(%ebp),%eax
 83a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 83d:	89 10                	mov    %edx,(%eax)
  freep = p;
 83f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 842:	a3 30 0c 00 00       	mov    %eax,0xc30
}
 847:	c9                   	leave  
 848:	c3                   	ret    

00000849 <morecore>:

static Header*
morecore(uint nu)
{
 849:	55                   	push   %ebp
 84a:	89 e5                	mov    %esp,%ebp
 84c:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 84f:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 856:	77 07                	ja     85f <morecore+0x16>
    nu = 4096;
 858:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 85f:	8b 45 08             	mov    0x8(%ebp),%eax
 862:	c1 e0 03             	shl    $0x3,%eax
 865:	89 04 24             	mov    %eax,(%esp)
 868:	e8 43 fc ff ff       	call   4b0 <sbrk>
 86d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 870:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 874:	75 07                	jne    87d <morecore+0x34>
    return 0;
 876:	b8 00 00 00 00       	mov    $0x0,%eax
 87b:	eb 22                	jmp    89f <morecore+0x56>
  hp = (Header*)p;
 87d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 880:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 883:	8b 45 f0             	mov    -0x10(%ebp),%eax
 886:	8b 55 08             	mov    0x8(%ebp),%edx
 889:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 88c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 88f:	83 c0 08             	add    $0x8,%eax
 892:	89 04 24             	mov    %eax,(%esp)
 895:	e8 ce fe ff ff       	call   768 <free>
  return freep;
 89a:	a1 30 0c 00 00       	mov    0xc30,%eax
}
 89f:	c9                   	leave  
 8a0:	c3                   	ret    

000008a1 <malloc>:

void*
malloc(uint nbytes)
{
 8a1:	55                   	push   %ebp
 8a2:	89 e5                	mov    %esp,%ebp
 8a4:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8a7:	8b 45 08             	mov    0x8(%ebp),%eax
 8aa:	83 c0 07             	add    $0x7,%eax
 8ad:	c1 e8 03             	shr    $0x3,%eax
 8b0:	40                   	inc    %eax
 8b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8b4:	a1 30 0c 00 00       	mov    0xc30,%eax
 8b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8bc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8c0:	75 23                	jne    8e5 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 8c2:	c7 45 f0 28 0c 00 00 	movl   $0xc28,-0x10(%ebp)
 8c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8cc:	a3 30 0c 00 00       	mov    %eax,0xc30
 8d1:	a1 30 0c 00 00       	mov    0xc30,%eax
 8d6:	a3 28 0c 00 00       	mov    %eax,0xc28
    base.s.size = 0;
 8db:	c7 05 2c 0c 00 00 00 	movl   $0x0,0xc2c
 8e2:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8e8:	8b 00                	mov    (%eax),%eax
 8ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f0:	8b 40 04             	mov    0x4(%eax),%eax
 8f3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8f6:	72 4d                	jb     945 <malloc+0xa4>
      if(p->s.size == nunits)
 8f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8fb:	8b 40 04             	mov    0x4(%eax),%eax
 8fe:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 901:	75 0c                	jne    90f <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 903:	8b 45 f4             	mov    -0xc(%ebp),%eax
 906:	8b 10                	mov    (%eax),%edx
 908:	8b 45 f0             	mov    -0x10(%ebp),%eax
 90b:	89 10                	mov    %edx,(%eax)
 90d:	eb 26                	jmp    935 <malloc+0x94>
      else {
        p->s.size -= nunits;
 90f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 912:	8b 40 04             	mov    0x4(%eax),%eax
 915:	89 c2                	mov    %eax,%edx
 917:	2b 55 ec             	sub    -0x14(%ebp),%edx
 91a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 91d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 920:	8b 45 f4             	mov    -0xc(%ebp),%eax
 923:	8b 40 04             	mov    0x4(%eax),%eax
 926:	c1 e0 03             	shl    $0x3,%eax
 929:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 92c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 92f:	8b 55 ec             	mov    -0x14(%ebp),%edx
 932:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 935:	8b 45 f0             	mov    -0x10(%ebp),%eax
 938:	a3 30 0c 00 00       	mov    %eax,0xc30
      return (void*)(p + 1);
 93d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 940:	83 c0 08             	add    $0x8,%eax
 943:	eb 38                	jmp    97d <malloc+0xdc>
    }
    if(p == freep)
 945:	a1 30 0c 00 00       	mov    0xc30,%eax
 94a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 94d:	75 1b                	jne    96a <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 94f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 952:	89 04 24             	mov    %eax,(%esp)
 955:	e8 ef fe ff ff       	call   849 <morecore>
 95a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 95d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 961:	75 07                	jne    96a <malloc+0xc9>
        return 0;
 963:	b8 00 00 00 00       	mov    $0x0,%eax
 968:	eb 13                	jmp    97d <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 96a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 96d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 970:	8b 45 f4             	mov    -0xc(%ebp),%eax
 973:	8b 00                	mov    (%eax),%eax
 975:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 978:	e9 70 ff ff ff       	jmp    8ed <malloc+0x4c>
}
 97d:	c9                   	leave  
 97e:	c3                   	ret    
