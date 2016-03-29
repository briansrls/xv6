
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   9:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  10:	00 
  11:	c7 04 24 ea 08 00 00 	movl   $0x8ea,(%esp)
  18:	e8 b3 03 00 00       	call   3d0 <open>
  1d:	85 c0                	test   %eax,%eax
  1f:	79 30                	jns    51 <main+0x51>
    mknod("console", 1, 1);
  21:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  28:	00 
  29:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  30:	00 
  31:	c7 04 24 ea 08 00 00 	movl   $0x8ea,(%esp)
  38:	e8 9b 03 00 00       	call   3d8 <mknod>
    open("console", O_RDWR);
  3d:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  44:	00 
  45:	c7 04 24 ea 08 00 00 	movl   $0x8ea,(%esp)
  4c:	e8 7f 03 00 00       	call   3d0 <open>
  }
  dup(0);  // stdout
  51:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  58:	e8 ab 03 00 00       	call   408 <dup>
  dup(0);  // stderr
  5d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  64:	e8 9f 03 00 00       	call   408 <dup>
  69:	eb 01                	jmp    6c <main+0x6c>
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  }
  6b:	90                   	nop
  }
  dup(0);  // stdout
  dup(0);  // stderr

  for(;;){
    printf(1, "init: starting sh\n");
  6c:	c7 44 24 04 f2 08 00 	movl   $0x8f2,0x4(%esp)
  73:	00 
  74:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  7b:	e8 a0 04 00 00       	call   520 <printf>
    pid = fork();
  80:	e8 03 03 00 00       	call   388 <fork>
  85:	89 44 24 1c          	mov    %eax,0x1c(%esp)
    if(pid < 0){
  89:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  8e:	79 19                	jns    a9 <main+0xa9>
      printf(1, "init: fork failed\n");
  90:	c7 44 24 04 05 09 00 	movl   $0x905,0x4(%esp)
  97:	00 
  98:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  9f:	e8 7c 04 00 00       	call   520 <printf>
      exit();
  a4:	e8 e7 02 00 00       	call   390 <exit>
    }
    if(pid == 0){
  a9:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  ae:	75 41                	jne    f1 <main+0xf1>
      exec("sh", argv);
  b0:	c7 44 24 04 9c 0b 00 	movl   $0xb9c,0x4(%esp)
  b7:	00 
  b8:	c7 04 24 e7 08 00 00 	movl   $0x8e7,(%esp)
  bf:	e8 04 03 00 00       	call   3c8 <exec>
      printf(1, "init: exec sh failed\n");
  c4:	c7 44 24 04 18 09 00 	movl   $0x918,0x4(%esp)
  cb:	00 
  cc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  d3:	e8 48 04 00 00       	call   520 <printf>
      exit();
  d8:	e8 b3 02 00 00       	call   390 <exit>
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  dd:	c7 44 24 04 2e 09 00 	movl   $0x92e,0x4(%esp)
  e4:	00 
  e5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  ec:	e8 2f 04 00 00       	call   520 <printf>
    if(pid == 0){
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  f1:	e8 a2 02 00 00       	call   398 <wait>
  f6:	89 44 24 18          	mov    %eax,0x18(%esp)
  fa:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  ff:	0f 88 66 ff ff ff    	js     6b <main+0x6b>
 105:	8b 44 24 18          	mov    0x18(%esp),%eax
 109:	3b 44 24 1c          	cmp    0x1c(%esp),%eax
 10d:	75 ce                	jne    dd <main+0xdd>
      printf(1, "zombie!\n");
  }
 10f:	e9 57 ff ff ff       	jmp    6b <main+0x6b>

00000114 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 114:	55                   	push   %ebp
 115:	89 e5                	mov    %esp,%ebp
 117:	57                   	push   %edi
 118:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 119:	8b 4d 08             	mov    0x8(%ebp),%ecx
 11c:	8b 55 10             	mov    0x10(%ebp),%edx
 11f:	8b 45 0c             	mov    0xc(%ebp),%eax
 122:	89 cb                	mov    %ecx,%ebx
 124:	89 df                	mov    %ebx,%edi
 126:	89 d1                	mov    %edx,%ecx
 128:	fc                   	cld    
 129:	f3 aa                	rep stos %al,%es:(%edi)
 12b:	89 ca                	mov    %ecx,%edx
 12d:	89 fb                	mov    %edi,%ebx
 12f:	89 5d 08             	mov    %ebx,0x8(%ebp)
 132:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 135:	5b                   	pop    %ebx
 136:	5f                   	pop    %edi
 137:	5d                   	pop    %ebp
 138:	c3                   	ret    

00000139 <strcpy>:
#include "x86.h"
#include "signal.h"

char*
strcpy(char *s, char *t)
{
 139:	55                   	push   %ebp
 13a:	89 e5                	mov    %esp,%ebp
 13c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 13f:	8b 45 08             	mov    0x8(%ebp),%eax
 142:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 145:	90                   	nop
 146:	8b 45 0c             	mov    0xc(%ebp),%eax
 149:	8a 10                	mov    (%eax),%dl
 14b:	8b 45 08             	mov    0x8(%ebp),%eax
 14e:	88 10                	mov    %dl,(%eax)
 150:	8b 45 08             	mov    0x8(%ebp),%eax
 153:	8a 00                	mov    (%eax),%al
 155:	84 c0                	test   %al,%al
 157:	0f 95 c0             	setne  %al
 15a:	ff 45 08             	incl   0x8(%ebp)
 15d:	ff 45 0c             	incl   0xc(%ebp)
 160:	84 c0                	test   %al,%al
 162:	75 e2                	jne    146 <strcpy+0xd>
    ;
  return os;
 164:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 167:	c9                   	leave  
 168:	c3                   	ret    

00000169 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 169:	55                   	push   %ebp
 16a:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 16c:	eb 06                	jmp    174 <strcmp+0xb>
    p++, q++;
 16e:	ff 45 08             	incl   0x8(%ebp)
 171:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 174:	8b 45 08             	mov    0x8(%ebp),%eax
 177:	8a 00                	mov    (%eax),%al
 179:	84 c0                	test   %al,%al
 17b:	74 0e                	je     18b <strcmp+0x22>
 17d:	8b 45 08             	mov    0x8(%ebp),%eax
 180:	8a 10                	mov    (%eax),%dl
 182:	8b 45 0c             	mov    0xc(%ebp),%eax
 185:	8a 00                	mov    (%eax),%al
 187:	38 c2                	cmp    %al,%dl
 189:	74 e3                	je     16e <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 18b:	8b 45 08             	mov    0x8(%ebp),%eax
 18e:	8a 00                	mov    (%eax),%al
 190:	0f b6 d0             	movzbl %al,%edx
 193:	8b 45 0c             	mov    0xc(%ebp),%eax
 196:	8a 00                	mov    (%eax),%al
 198:	0f b6 c0             	movzbl %al,%eax
 19b:	89 d1                	mov    %edx,%ecx
 19d:	29 c1                	sub    %eax,%ecx
 19f:	89 c8                	mov    %ecx,%eax
}
 1a1:	5d                   	pop    %ebp
 1a2:	c3                   	ret    

000001a3 <strlen>:

uint
strlen(char *s)
{
 1a3:	55                   	push   %ebp
 1a4:	89 e5                	mov    %esp,%ebp
 1a6:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1b0:	eb 03                	jmp    1b5 <strlen+0x12>
 1b2:	ff 45 fc             	incl   -0x4(%ebp)
 1b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1b8:	8b 45 08             	mov    0x8(%ebp),%eax
 1bb:	01 d0                	add    %edx,%eax
 1bd:	8a 00                	mov    (%eax),%al
 1bf:	84 c0                	test   %al,%al
 1c1:	75 ef                	jne    1b2 <strlen+0xf>
    ;
  return n;
 1c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1c6:	c9                   	leave  
 1c7:	c3                   	ret    

000001c8 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1c8:	55                   	push   %ebp
 1c9:	89 e5                	mov    %esp,%ebp
 1cb:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1ce:	8b 45 10             	mov    0x10(%ebp),%eax
 1d1:	89 44 24 08          	mov    %eax,0x8(%esp)
 1d5:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d8:	89 44 24 04          	mov    %eax,0x4(%esp)
 1dc:	8b 45 08             	mov    0x8(%ebp),%eax
 1df:	89 04 24             	mov    %eax,(%esp)
 1e2:	e8 2d ff ff ff       	call   114 <stosb>
  return dst;
 1e7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1ea:	c9                   	leave  
 1eb:	c3                   	ret    

000001ec <strchr>:

char*
strchr(const char *s, char c)
{
 1ec:	55                   	push   %ebp
 1ed:	89 e5                	mov    %esp,%ebp
 1ef:	83 ec 04             	sub    $0x4,%esp
 1f2:	8b 45 0c             	mov    0xc(%ebp),%eax
 1f5:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1f8:	eb 12                	jmp    20c <strchr+0x20>
    if(*s == c)
 1fa:	8b 45 08             	mov    0x8(%ebp),%eax
 1fd:	8a 00                	mov    (%eax),%al
 1ff:	3a 45 fc             	cmp    -0x4(%ebp),%al
 202:	75 05                	jne    209 <strchr+0x1d>
      return (char*)s;
 204:	8b 45 08             	mov    0x8(%ebp),%eax
 207:	eb 11                	jmp    21a <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 209:	ff 45 08             	incl   0x8(%ebp)
 20c:	8b 45 08             	mov    0x8(%ebp),%eax
 20f:	8a 00                	mov    (%eax),%al
 211:	84 c0                	test   %al,%al
 213:	75 e5                	jne    1fa <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 215:	b8 00 00 00 00       	mov    $0x0,%eax
}
 21a:	c9                   	leave  
 21b:	c3                   	ret    

0000021c <gets>:

char*
gets(char *buf, int max)
{
 21c:	55                   	push   %ebp
 21d:	89 e5                	mov    %esp,%ebp
 21f:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 222:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 229:	eb 42                	jmp    26d <gets+0x51>
    cc = read(0, &c, 1);
 22b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 232:	00 
 233:	8d 45 ef             	lea    -0x11(%ebp),%eax
 236:	89 44 24 04          	mov    %eax,0x4(%esp)
 23a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 241:	e8 62 01 00 00       	call   3a8 <read>
 246:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 249:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 24d:	7e 29                	jle    278 <gets+0x5c>
      break;
    buf[i++] = c;
 24f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 252:	8b 45 08             	mov    0x8(%ebp),%eax
 255:	01 c2                	add    %eax,%edx
 257:	8a 45 ef             	mov    -0x11(%ebp),%al
 25a:	88 02                	mov    %al,(%edx)
 25c:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 25f:	8a 45 ef             	mov    -0x11(%ebp),%al
 262:	3c 0a                	cmp    $0xa,%al
 264:	74 13                	je     279 <gets+0x5d>
 266:	8a 45 ef             	mov    -0x11(%ebp),%al
 269:	3c 0d                	cmp    $0xd,%al
 26b:	74 0c                	je     279 <gets+0x5d>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 26d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 270:	40                   	inc    %eax
 271:	3b 45 0c             	cmp    0xc(%ebp),%eax
 274:	7c b5                	jl     22b <gets+0xf>
 276:	eb 01                	jmp    279 <gets+0x5d>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 278:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 279:	8b 55 f4             	mov    -0xc(%ebp),%edx
 27c:	8b 45 08             	mov    0x8(%ebp),%eax
 27f:	01 d0                	add    %edx,%eax
 281:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 284:	8b 45 08             	mov    0x8(%ebp),%eax
}
 287:	c9                   	leave  
 288:	c3                   	ret    

00000289 <stat>:

int
stat(char *n, struct stat *st)
{
 289:	55                   	push   %ebp
 28a:	89 e5                	mov    %esp,%ebp
 28c:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 28f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 296:	00 
 297:	8b 45 08             	mov    0x8(%ebp),%eax
 29a:	89 04 24             	mov    %eax,(%esp)
 29d:	e8 2e 01 00 00       	call   3d0 <open>
 2a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2a9:	79 07                	jns    2b2 <stat+0x29>
    return -1;
 2ab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2b0:	eb 23                	jmp    2d5 <stat+0x4c>
  r = fstat(fd, st);
 2b2:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b5:	89 44 24 04          	mov    %eax,0x4(%esp)
 2b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2bc:	89 04 24             	mov    %eax,(%esp)
 2bf:	e8 24 01 00 00       	call   3e8 <fstat>
 2c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2ca:	89 04 24             	mov    %eax,(%esp)
 2cd:	e8 e6 00 00 00       	call   3b8 <close>
  return r;
 2d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2d5:	c9                   	leave  
 2d6:	c3                   	ret    

000002d7 <atoi>:

int
atoi(const char *s)
{
 2d7:	55                   	push   %ebp
 2d8:	89 e5                	mov    %esp,%ebp
 2da:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2e4:	eb 21                	jmp    307 <atoi+0x30>
    n = n*10 + *s++ - '0';
 2e6:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2e9:	89 d0                	mov    %edx,%eax
 2eb:	c1 e0 02             	shl    $0x2,%eax
 2ee:	01 d0                	add    %edx,%eax
 2f0:	d1 e0                	shl    %eax
 2f2:	89 c2                	mov    %eax,%edx
 2f4:	8b 45 08             	mov    0x8(%ebp),%eax
 2f7:	8a 00                	mov    (%eax),%al
 2f9:	0f be c0             	movsbl %al,%eax
 2fc:	01 d0                	add    %edx,%eax
 2fe:	83 e8 30             	sub    $0x30,%eax
 301:	89 45 fc             	mov    %eax,-0x4(%ebp)
 304:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 307:	8b 45 08             	mov    0x8(%ebp),%eax
 30a:	8a 00                	mov    (%eax),%al
 30c:	3c 2f                	cmp    $0x2f,%al
 30e:	7e 09                	jle    319 <atoi+0x42>
 310:	8b 45 08             	mov    0x8(%ebp),%eax
 313:	8a 00                	mov    (%eax),%al
 315:	3c 39                	cmp    $0x39,%al
 317:	7e cd                	jle    2e6 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 319:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 31c:	c9                   	leave  
 31d:	c3                   	ret    

0000031e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 31e:	55                   	push   %ebp
 31f:	89 e5                	mov    %esp,%ebp
 321:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 324:	8b 45 08             	mov    0x8(%ebp),%eax
 327:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 32a:	8b 45 0c             	mov    0xc(%ebp),%eax
 32d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 330:	eb 10                	jmp    342 <memmove+0x24>
    *dst++ = *src++;
 332:	8b 45 f8             	mov    -0x8(%ebp),%eax
 335:	8a 10                	mov    (%eax),%dl
 337:	8b 45 fc             	mov    -0x4(%ebp),%eax
 33a:	88 10                	mov    %dl,(%eax)
 33c:	ff 45 fc             	incl   -0x4(%ebp)
 33f:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 342:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 346:	0f 9f c0             	setg   %al
 349:	ff 4d 10             	decl   0x10(%ebp)
 34c:	84 c0                	test   %al,%al
 34e:	75 e2                	jne    332 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 350:	8b 45 08             	mov    0x8(%ebp),%eax
}
 353:	c9                   	leave  
 354:	c3                   	ret    

00000355 <trampoline>:
 355:	5a                   	pop    %edx
 356:	59                   	pop    %ecx
 357:	58                   	pop    %eax
 358:	03 25 04 00 00 00    	add    0x4,%esp
 35e:	c9                   	leave  
 35f:	c3                   	ret    

00000360 <signal>:
	"addl 4, %esp\n\t"
	"leave\n\t"
	"ret\n\t"
);
int signal(int signum, sighandler_t handler) 
{
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	83 ec 18             	sub    $0x18,%esp
	register_signal_handler(signum, handler, trampoline);
 366:	c7 44 24 08 55 03 00 	movl   $0x355,0x8(%esp)
 36d:	00 
 36e:	8b 45 0c             	mov    0xc(%ebp),%eax
 371:	89 44 24 04          	mov    %eax,0x4(%esp)
 375:	8b 45 08             	mov    0x8(%ebp),%eax
 378:	89 04 24             	mov    %eax,(%esp)
 37b:	e8 b8 00 00 00       	call   438 <register_signal_handler>
	return 0;
 380:	b8 00 00 00 00       	mov    $0x0,%eax
}
 385:	c9                   	leave  
 386:	c3                   	ret    
 387:	90                   	nop

00000388 <fork>:
 388:	b8 01 00 00 00       	mov    $0x1,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <exit>:
 390:	b8 02 00 00 00       	mov    $0x2,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <wait>:
 398:	b8 03 00 00 00       	mov    $0x3,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <pipe>:
 3a0:	b8 04 00 00 00       	mov    $0x4,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <read>:
 3a8:	b8 05 00 00 00       	mov    $0x5,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <write>:
 3b0:	b8 10 00 00 00       	mov    $0x10,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <close>:
 3b8:	b8 15 00 00 00       	mov    $0x15,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <kill>:
 3c0:	b8 06 00 00 00       	mov    $0x6,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <exec>:
 3c8:	b8 07 00 00 00       	mov    $0x7,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <open>:
 3d0:	b8 0f 00 00 00       	mov    $0xf,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <mknod>:
 3d8:	b8 11 00 00 00       	mov    $0x11,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <unlink>:
 3e0:	b8 12 00 00 00       	mov    $0x12,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    

000003e8 <fstat>:
 3e8:	b8 08 00 00 00       	mov    $0x8,%eax
 3ed:	cd 40                	int    $0x40
 3ef:	c3                   	ret    

000003f0 <link>:
 3f0:	b8 13 00 00 00       	mov    $0x13,%eax
 3f5:	cd 40                	int    $0x40
 3f7:	c3                   	ret    

000003f8 <mkdir>:
 3f8:	b8 14 00 00 00       	mov    $0x14,%eax
 3fd:	cd 40                	int    $0x40
 3ff:	c3                   	ret    

00000400 <chdir>:
 400:	b8 09 00 00 00       	mov    $0x9,%eax
 405:	cd 40                	int    $0x40
 407:	c3                   	ret    

00000408 <dup>:
 408:	b8 0a 00 00 00       	mov    $0xa,%eax
 40d:	cd 40                	int    $0x40
 40f:	c3                   	ret    

00000410 <getpid>:
 410:	b8 0b 00 00 00       	mov    $0xb,%eax
 415:	cd 40                	int    $0x40
 417:	c3                   	ret    

00000418 <sbrk>:
 418:	b8 0c 00 00 00       	mov    $0xc,%eax
 41d:	cd 40                	int    $0x40
 41f:	c3                   	ret    

00000420 <sleep>:
 420:	b8 0d 00 00 00       	mov    $0xd,%eax
 425:	cd 40                	int    $0x40
 427:	c3                   	ret    

00000428 <uptime>:
 428:	b8 0e 00 00 00       	mov    $0xe,%eax
 42d:	cd 40                	int    $0x40
 42f:	c3                   	ret    

00000430 <halt>:
 430:	b8 16 00 00 00       	mov    $0x16,%eax
 435:	cd 40                	int    $0x40
 437:	c3                   	ret    

00000438 <register_signal_handler>:
 438:	b8 17 00 00 00       	mov    $0x17,%eax
 43d:	cd 40                	int    $0x40
 43f:	c3                   	ret    

00000440 <alarm>:
 440:	b8 18 00 00 00       	mov    $0x18,%eax
 445:	cd 40                	int    $0x40
 447:	c3                   	ret    

00000448 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 448:	55                   	push   %ebp
 449:	89 e5                	mov    %esp,%ebp
 44b:	83 ec 28             	sub    $0x28,%esp
 44e:	8b 45 0c             	mov    0xc(%ebp),%eax
 451:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 454:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 45b:	00 
 45c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 45f:	89 44 24 04          	mov    %eax,0x4(%esp)
 463:	8b 45 08             	mov    0x8(%ebp),%eax
 466:	89 04 24             	mov    %eax,(%esp)
 469:	e8 42 ff ff ff       	call   3b0 <write>
}
 46e:	c9                   	leave  
 46f:	c3                   	ret    

00000470 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 470:	55                   	push   %ebp
 471:	89 e5                	mov    %esp,%ebp
 473:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 476:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 47d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 481:	74 17                	je     49a <printint+0x2a>
 483:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 487:	79 11                	jns    49a <printint+0x2a>
    neg = 1;
 489:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 490:	8b 45 0c             	mov    0xc(%ebp),%eax
 493:	f7 d8                	neg    %eax
 495:	89 45 ec             	mov    %eax,-0x14(%ebp)
 498:	eb 06                	jmp    4a0 <printint+0x30>
  } else {
    x = xx;
 49a:	8b 45 0c             	mov    0xc(%ebp),%eax
 49d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 4aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4ad:	ba 00 00 00 00       	mov    $0x0,%edx
 4b2:	f7 f1                	div    %ecx
 4b4:	89 d0                	mov    %edx,%eax
 4b6:	8a 80 a4 0b 00 00    	mov    0xba4(%eax),%al
 4bc:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 4bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4c2:	01 ca                	add    %ecx,%edx
 4c4:	88 02                	mov    %al,(%edx)
 4c6:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 4c9:	8b 55 10             	mov    0x10(%ebp),%edx
 4cc:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 4cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4d2:	ba 00 00 00 00       	mov    $0x0,%edx
 4d7:	f7 75 d4             	divl   -0x2c(%ebp)
 4da:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4dd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4e1:	75 c4                	jne    4a7 <printint+0x37>
  if(neg)
 4e3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4e7:	74 2c                	je     515 <printint+0xa5>
    buf[i++] = '-';
 4e9:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4ef:	01 d0                	add    %edx,%eax
 4f1:	c6 00 2d             	movb   $0x2d,(%eax)
 4f4:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 4f7:	eb 1c                	jmp    515 <printint+0xa5>
    putc(fd, buf[i]);
 4f9:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4ff:	01 d0                	add    %edx,%eax
 501:	8a 00                	mov    (%eax),%al
 503:	0f be c0             	movsbl %al,%eax
 506:	89 44 24 04          	mov    %eax,0x4(%esp)
 50a:	8b 45 08             	mov    0x8(%ebp),%eax
 50d:	89 04 24             	mov    %eax,(%esp)
 510:	e8 33 ff ff ff       	call   448 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 515:	ff 4d f4             	decl   -0xc(%ebp)
 518:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 51c:	79 db                	jns    4f9 <printint+0x89>
    putc(fd, buf[i]);
}
 51e:	c9                   	leave  
 51f:	c3                   	ret    

00000520 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 520:	55                   	push   %ebp
 521:	89 e5                	mov    %esp,%ebp
 523:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 526:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 52d:	8d 45 0c             	lea    0xc(%ebp),%eax
 530:	83 c0 04             	add    $0x4,%eax
 533:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 536:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 53d:	e9 78 01 00 00       	jmp    6ba <printf+0x19a>
    c = fmt[i] & 0xff;
 542:	8b 55 0c             	mov    0xc(%ebp),%edx
 545:	8b 45 f0             	mov    -0x10(%ebp),%eax
 548:	01 d0                	add    %edx,%eax
 54a:	8a 00                	mov    (%eax),%al
 54c:	0f be c0             	movsbl %al,%eax
 54f:	25 ff 00 00 00       	and    $0xff,%eax
 554:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 557:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 55b:	75 2c                	jne    589 <printf+0x69>
      if(c == '%'){
 55d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 561:	75 0c                	jne    56f <printf+0x4f>
        state = '%';
 563:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 56a:	e9 48 01 00 00       	jmp    6b7 <printf+0x197>
      } else {
        putc(fd, c);
 56f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 572:	0f be c0             	movsbl %al,%eax
 575:	89 44 24 04          	mov    %eax,0x4(%esp)
 579:	8b 45 08             	mov    0x8(%ebp),%eax
 57c:	89 04 24             	mov    %eax,(%esp)
 57f:	e8 c4 fe ff ff       	call   448 <putc>
 584:	e9 2e 01 00 00       	jmp    6b7 <printf+0x197>
      }
    } else if(state == '%'){
 589:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 58d:	0f 85 24 01 00 00    	jne    6b7 <printf+0x197>
      if(c == 'd'){
 593:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 597:	75 2d                	jne    5c6 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 599:	8b 45 e8             	mov    -0x18(%ebp),%eax
 59c:	8b 00                	mov    (%eax),%eax
 59e:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 5a5:	00 
 5a6:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 5ad:	00 
 5ae:	89 44 24 04          	mov    %eax,0x4(%esp)
 5b2:	8b 45 08             	mov    0x8(%ebp),%eax
 5b5:	89 04 24             	mov    %eax,(%esp)
 5b8:	e8 b3 fe ff ff       	call   470 <printint>
        ap++;
 5bd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5c1:	e9 ea 00 00 00       	jmp    6b0 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 5c6:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5ca:	74 06                	je     5d2 <printf+0xb2>
 5cc:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5d0:	75 2d                	jne    5ff <printf+0xdf>
        printint(fd, *ap, 16, 0);
 5d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5d5:	8b 00                	mov    (%eax),%eax
 5d7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 5de:	00 
 5df:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 5e6:	00 
 5e7:	89 44 24 04          	mov    %eax,0x4(%esp)
 5eb:	8b 45 08             	mov    0x8(%ebp),%eax
 5ee:	89 04 24             	mov    %eax,(%esp)
 5f1:	e8 7a fe ff ff       	call   470 <printint>
        ap++;
 5f6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5fa:	e9 b1 00 00 00       	jmp    6b0 <printf+0x190>
      } else if(c == 's'){
 5ff:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 603:	75 43                	jne    648 <printf+0x128>
        s = (char*)*ap;
 605:	8b 45 e8             	mov    -0x18(%ebp),%eax
 608:	8b 00                	mov    (%eax),%eax
 60a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 60d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 611:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 615:	75 25                	jne    63c <printf+0x11c>
          s = "(null)";
 617:	c7 45 f4 37 09 00 00 	movl   $0x937,-0xc(%ebp)
        while(*s != 0){
 61e:	eb 1c                	jmp    63c <printf+0x11c>
          putc(fd, *s);
 620:	8b 45 f4             	mov    -0xc(%ebp),%eax
 623:	8a 00                	mov    (%eax),%al
 625:	0f be c0             	movsbl %al,%eax
 628:	89 44 24 04          	mov    %eax,0x4(%esp)
 62c:	8b 45 08             	mov    0x8(%ebp),%eax
 62f:	89 04 24             	mov    %eax,(%esp)
 632:	e8 11 fe ff ff       	call   448 <putc>
          s++;
 637:	ff 45 f4             	incl   -0xc(%ebp)
 63a:	eb 01                	jmp    63d <printf+0x11d>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 63c:	90                   	nop
 63d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 640:	8a 00                	mov    (%eax),%al
 642:	84 c0                	test   %al,%al
 644:	75 da                	jne    620 <printf+0x100>
 646:	eb 68                	jmp    6b0 <printf+0x190>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 648:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 64c:	75 1d                	jne    66b <printf+0x14b>
        putc(fd, *ap);
 64e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 651:	8b 00                	mov    (%eax),%eax
 653:	0f be c0             	movsbl %al,%eax
 656:	89 44 24 04          	mov    %eax,0x4(%esp)
 65a:	8b 45 08             	mov    0x8(%ebp),%eax
 65d:	89 04 24             	mov    %eax,(%esp)
 660:	e8 e3 fd ff ff       	call   448 <putc>
        ap++;
 665:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 669:	eb 45                	jmp    6b0 <printf+0x190>
      } else if(c == '%'){
 66b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 66f:	75 17                	jne    688 <printf+0x168>
        putc(fd, c);
 671:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 674:	0f be c0             	movsbl %al,%eax
 677:	89 44 24 04          	mov    %eax,0x4(%esp)
 67b:	8b 45 08             	mov    0x8(%ebp),%eax
 67e:	89 04 24             	mov    %eax,(%esp)
 681:	e8 c2 fd ff ff       	call   448 <putc>
 686:	eb 28                	jmp    6b0 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 688:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 68f:	00 
 690:	8b 45 08             	mov    0x8(%ebp),%eax
 693:	89 04 24             	mov    %eax,(%esp)
 696:	e8 ad fd ff ff       	call   448 <putc>
        putc(fd, c);
 69b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 69e:	0f be c0             	movsbl %al,%eax
 6a1:	89 44 24 04          	mov    %eax,0x4(%esp)
 6a5:	8b 45 08             	mov    0x8(%ebp),%eax
 6a8:	89 04 24             	mov    %eax,(%esp)
 6ab:	e8 98 fd ff ff       	call   448 <putc>
      }
      state = 0;
 6b0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6b7:	ff 45 f0             	incl   -0x10(%ebp)
 6ba:	8b 55 0c             	mov    0xc(%ebp),%edx
 6bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6c0:	01 d0                	add    %edx,%eax
 6c2:	8a 00                	mov    (%eax),%al
 6c4:	84 c0                	test   %al,%al
 6c6:	0f 85 76 fe ff ff    	jne    542 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6cc:	c9                   	leave  
 6cd:	c3                   	ret    
 6ce:	66 90                	xchg   %ax,%ax

000006d0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6d0:	55                   	push   %ebp
 6d1:	89 e5                	mov    %esp,%ebp
 6d3:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6d6:	8b 45 08             	mov    0x8(%ebp),%eax
 6d9:	83 e8 08             	sub    $0x8,%eax
 6dc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6df:	a1 c0 0b 00 00       	mov    0xbc0,%eax
 6e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6e7:	eb 24                	jmp    70d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ec:	8b 00                	mov    (%eax),%eax
 6ee:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6f1:	77 12                	ja     705 <free+0x35>
 6f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6f9:	77 24                	ja     71f <free+0x4f>
 6fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fe:	8b 00                	mov    (%eax),%eax
 700:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 703:	77 1a                	ja     71f <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 705:	8b 45 fc             	mov    -0x4(%ebp),%eax
 708:	8b 00                	mov    (%eax),%eax
 70a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 70d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 710:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 713:	76 d4                	jbe    6e9 <free+0x19>
 715:	8b 45 fc             	mov    -0x4(%ebp),%eax
 718:	8b 00                	mov    (%eax),%eax
 71a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 71d:	76 ca                	jbe    6e9 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 71f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 722:	8b 40 04             	mov    0x4(%eax),%eax
 725:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 72c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72f:	01 c2                	add    %eax,%edx
 731:	8b 45 fc             	mov    -0x4(%ebp),%eax
 734:	8b 00                	mov    (%eax),%eax
 736:	39 c2                	cmp    %eax,%edx
 738:	75 24                	jne    75e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 73a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73d:	8b 50 04             	mov    0x4(%eax),%edx
 740:	8b 45 fc             	mov    -0x4(%ebp),%eax
 743:	8b 00                	mov    (%eax),%eax
 745:	8b 40 04             	mov    0x4(%eax),%eax
 748:	01 c2                	add    %eax,%edx
 74a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 750:	8b 45 fc             	mov    -0x4(%ebp),%eax
 753:	8b 00                	mov    (%eax),%eax
 755:	8b 10                	mov    (%eax),%edx
 757:	8b 45 f8             	mov    -0x8(%ebp),%eax
 75a:	89 10                	mov    %edx,(%eax)
 75c:	eb 0a                	jmp    768 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 75e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 761:	8b 10                	mov    (%eax),%edx
 763:	8b 45 f8             	mov    -0x8(%ebp),%eax
 766:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 768:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76b:	8b 40 04             	mov    0x4(%eax),%eax
 76e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 775:	8b 45 fc             	mov    -0x4(%ebp),%eax
 778:	01 d0                	add    %edx,%eax
 77a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 77d:	75 20                	jne    79f <free+0xcf>
    p->s.size += bp->s.size;
 77f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 782:	8b 50 04             	mov    0x4(%eax),%edx
 785:	8b 45 f8             	mov    -0x8(%ebp),%eax
 788:	8b 40 04             	mov    0x4(%eax),%eax
 78b:	01 c2                	add    %eax,%edx
 78d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 790:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 793:	8b 45 f8             	mov    -0x8(%ebp),%eax
 796:	8b 10                	mov    (%eax),%edx
 798:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79b:	89 10                	mov    %edx,(%eax)
 79d:	eb 08                	jmp    7a7 <free+0xd7>
  } else
    p->s.ptr = bp;
 79f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a2:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7a5:	89 10                	mov    %edx,(%eax)
  freep = p;
 7a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7aa:	a3 c0 0b 00 00       	mov    %eax,0xbc0
}
 7af:	c9                   	leave  
 7b0:	c3                   	ret    

000007b1 <morecore>:

static Header*
morecore(uint nu)
{
 7b1:	55                   	push   %ebp
 7b2:	89 e5                	mov    %esp,%ebp
 7b4:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7b7:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7be:	77 07                	ja     7c7 <morecore+0x16>
    nu = 4096;
 7c0:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7c7:	8b 45 08             	mov    0x8(%ebp),%eax
 7ca:	c1 e0 03             	shl    $0x3,%eax
 7cd:	89 04 24             	mov    %eax,(%esp)
 7d0:	e8 43 fc ff ff       	call   418 <sbrk>
 7d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7d8:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7dc:	75 07                	jne    7e5 <morecore+0x34>
    return 0;
 7de:	b8 00 00 00 00       	mov    $0x0,%eax
 7e3:	eb 22                	jmp    807 <morecore+0x56>
  hp = (Header*)p;
 7e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ee:	8b 55 08             	mov    0x8(%ebp),%edx
 7f1:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f7:	83 c0 08             	add    $0x8,%eax
 7fa:	89 04 24             	mov    %eax,(%esp)
 7fd:	e8 ce fe ff ff       	call   6d0 <free>
  return freep;
 802:	a1 c0 0b 00 00       	mov    0xbc0,%eax
}
 807:	c9                   	leave  
 808:	c3                   	ret    

00000809 <malloc>:

void*
malloc(uint nbytes)
{
 809:	55                   	push   %ebp
 80a:	89 e5                	mov    %esp,%ebp
 80c:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 80f:	8b 45 08             	mov    0x8(%ebp),%eax
 812:	83 c0 07             	add    $0x7,%eax
 815:	c1 e8 03             	shr    $0x3,%eax
 818:	40                   	inc    %eax
 819:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 81c:	a1 c0 0b 00 00       	mov    0xbc0,%eax
 821:	89 45 f0             	mov    %eax,-0x10(%ebp)
 824:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 828:	75 23                	jne    84d <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 82a:	c7 45 f0 b8 0b 00 00 	movl   $0xbb8,-0x10(%ebp)
 831:	8b 45 f0             	mov    -0x10(%ebp),%eax
 834:	a3 c0 0b 00 00       	mov    %eax,0xbc0
 839:	a1 c0 0b 00 00       	mov    0xbc0,%eax
 83e:	a3 b8 0b 00 00       	mov    %eax,0xbb8
    base.s.size = 0;
 843:	c7 05 bc 0b 00 00 00 	movl   $0x0,0xbbc
 84a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 84d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 850:	8b 00                	mov    (%eax),%eax
 852:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 855:	8b 45 f4             	mov    -0xc(%ebp),%eax
 858:	8b 40 04             	mov    0x4(%eax),%eax
 85b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 85e:	72 4d                	jb     8ad <malloc+0xa4>
      if(p->s.size == nunits)
 860:	8b 45 f4             	mov    -0xc(%ebp),%eax
 863:	8b 40 04             	mov    0x4(%eax),%eax
 866:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 869:	75 0c                	jne    877 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 86b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86e:	8b 10                	mov    (%eax),%edx
 870:	8b 45 f0             	mov    -0x10(%ebp),%eax
 873:	89 10                	mov    %edx,(%eax)
 875:	eb 26                	jmp    89d <malloc+0x94>
      else {
        p->s.size -= nunits;
 877:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87a:	8b 40 04             	mov    0x4(%eax),%eax
 87d:	89 c2                	mov    %eax,%edx
 87f:	2b 55 ec             	sub    -0x14(%ebp),%edx
 882:	8b 45 f4             	mov    -0xc(%ebp),%eax
 885:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 888:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88b:	8b 40 04             	mov    0x4(%eax),%eax
 88e:	c1 e0 03             	shl    $0x3,%eax
 891:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 894:	8b 45 f4             	mov    -0xc(%ebp),%eax
 897:	8b 55 ec             	mov    -0x14(%ebp),%edx
 89a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 89d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a0:	a3 c0 0b 00 00       	mov    %eax,0xbc0
      return (void*)(p + 1);
 8a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a8:	83 c0 08             	add    $0x8,%eax
 8ab:	eb 38                	jmp    8e5 <malloc+0xdc>
    }
    if(p == freep)
 8ad:	a1 c0 0b 00 00       	mov    0xbc0,%eax
 8b2:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8b5:	75 1b                	jne    8d2 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 8b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8ba:	89 04 24             	mov    %eax,(%esp)
 8bd:	e8 ef fe ff ff       	call   7b1 <morecore>
 8c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8c9:	75 07                	jne    8d2 <malloc+0xc9>
        return 0;
 8cb:	b8 00 00 00 00       	mov    $0x0,%eax
 8d0:	eb 13                	jmp    8e5 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8db:	8b 00                	mov    (%eax),%eax
 8dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8e0:	e9 70 ff ff ff       	jmp    855 <malloc+0x4c>
}
 8e5:	c9                   	leave  
 8e6:	c3                   	ret    
