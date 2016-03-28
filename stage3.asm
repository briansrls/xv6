
_stage3:     file format elf32-i386


Disassembly of section .text:

00000000 <handle_signal>:
#include "signal.h"

static int count = 0;

void handle_signal(siginfo_t info)
{	
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 10             	sub    $0x10,%esp
	count++;
   6:	a1 6c 09 00 00       	mov    0x96c,%eax
   b:	83 c0 01             	add    $0x1,%eax
   e:	a3 6c 09 00 00       	mov    %eax,0x96c
	if(count>=100000){
  13:	a1 6c 09 00 00       	mov    0x96c,%eax
  18:	3d 9f 86 01 00       	cmp    $0x1869f,%eax
  1d:	7e 2f                	jle    4e <handle_signal+0x4e>
	int* ptr = &(info.signum);
  1f:	8d 45 08             	lea    0x8(%ebp),%eax
  22:	89 45 f8             	mov    %eax,-0x8(%ebp)
	int i;
	for(i=0; i<5; i++){
  25:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  2c:	eb 0d                	jmp    3b <handle_signal+0x3b>
	ptr+= (int)sizeof(&ptr)/4;
  2e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  31:	83 c0 04             	add    $0x4,%eax
  34:	89 45 f8             	mov    %eax,-0x8(%ebp)
{	
	count++;
	if(count>=100000){
	int* ptr = &(info.signum);
	int i;
	for(i=0; i<5; i++){
  37:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  3b:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  3f:	7e ed                	jle    2e <handle_signal+0x2e>
	ptr+= (int)sizeof(&ptr)/4;
	}
	//printf(1, "Size of element: %d\n", (int)sizeof(&info.signum)*10);
	(*ptr) += (int)sizeof(&ptr)/4;	
  41:	8b 45 f8             	mov    -0x8(%ebp),%eax
  44:	8b 55 f8             	mov    -0x8(%ebp),%edx
  47:	8b 12                	mov    (%edx),%edx
  49:	83 c2 01             	add    $0x1,%edx
  4c:	89 10                	mov    %edx,(%eax)
	}
		
}
  4e:	c9                   	leave  
  4f:	c3                   	ret    

00000050 <main>:
int main(int argc, char *argv[])
{
  50:	55                   	push   %ebp
  51:	89 e5                	mov    %esp,%ebp
  53:	83 e4 f0             	and    $0xfffffff0,%esp
  56:	83 ec 30             	sub    $0x30,%esp

	int time_init;
        int time_end;
        int time_total;
        int time_avg;
        int x = 5;
  59:	c7 44 24 28 05 00 00 	movl   $0x5,0x28(%esp)
  60:	00 
        int y = 0;
  61:	c7 44 24 2c 00 00 00 	movl   $0x0,0x2c(%esp)
  68:	00 
	
        time_init = uptime();
  69:	e8 d6 03 00 00       	call   444 <uptime>
  6e:	89 44 24 18          	mov    %eax,0x18(%esp)
        signal(SIGFPE, handle_signal);
  72:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  79:	00 
  7a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  81:	e8 f4 02 00 00       	call   37a <signal>
        x = x / y;
  86:	8b 44 24 28          	mov    0x28(%esp),%eax
  8a:	89 c2                	mov    %eax,%edx
  8c:	c1 fa 1f             	sar    $0x1f,%edx
  8f:	f7 7c 24 2c          	idivl  0x2c(%esp)
  93:	89 44 24 28          	mov    %eax,0x28(%esp)
        time_end = uptime();
  97:	e8 a8 03 00 00       	call   444 <uptime>
  9c:	89 44 24 1c          	mov    %eax,0x1c(%esp)
        time_total = time_end - time_init;
  a0:	8b 44 24 18          	mov    0x18(%esp),%eax
  a4:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  a8:	89 d1                	mov    %edx,%ecx
  aa:	29 c1                	sub    %eax,%ecx
  ac:	89 c8                	mov    %ecx,%eax
  ae:	89 44 24 20          	mov    %eax,0x20(%esp)
        //this is in mticks, where one tick is 10^-6 mticks.
	time_avg = time_total*10;
  b2:	8b 54 24 20          	mov    0x20(%esp),%edx
  b6:	89 d0                	mov    %edx,%eax
  b8:	c1 e0 02             	shl    $0x2,%eax
  bb:	01 d0                	add    %edx,%eax
  bd:	01 c0                	add    %eax,%eax
  bf:	89 44 24 24          	mov    %eax,0x24(%esp)

        printf(1, "Traps Performed: %d\n", 100000);
  c3:	c7 44 24 08 a0 86 01 	movl   $0x186a0,0x8(%esp)
  ca:	00 
  cb:	c7 44 24 04 07 09 00 	movl   $0x907,0x4(%esp)
  d2:	00 
  d3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  da:	e8 61 04 00 00       	call   540 <printf>
        printf(1, "Total Elapsed Time: %d\n", time_total);
  df:	8b 44 24 20          	mov    0x20(%esp),%eax
  e3:	89 44 24 08          	mov    %eax,0x8(%esp)
  e7:	c7 44 24 04 1c 09 00 	movl   $0x91c,0x4(%esp)
  ee:	00 
  ef:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  f6:	e8 45 04 00 00       	call   540 <printf>
        printf(1, "Average Time Per Trap: %d\n", time_avg);
  fb:	8b 44 24 24          	mov    0x24(%esp),%eax
  ff:	89 44 24 08          	mov    %eax,0x8(%esp)
 103:	c7 44 24 04 34 09 00 	movl   $0x934,0x4(%esp)
 10a:	00 
 10b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 112:	e8 29 04 00 00       	call   540 <printf>

        exit();
 117:	e8 90 02 00 00       	call   3ac <exit>

0000011c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 11c:	55                   	push   %ebp
 11d:	89 e5                	mov    %esp,%ebp
 11f:	57                   	push   %edi
 120:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 121:	8b 4d 08             	mov    0x8(%ebp),%ecx
 124:	8b 55 10             	mov    0x10(%ebp),%edx
 127:	8b 45 0c             	mov    0xc(%ebp),%eax
 12a:	89 cb                	mov    %ecx,%ebx
 12c:	89 df                	mov    %ebx,%edi
 12e:	89 d1                	mov    %edx,%ecx
 130:	fc                   	cld    
 131:	f3 aa                	rep stos %al,%es:(%edi)
 133:	89 ca                	mov    %ecx,%edx
 135:	89 fb                	mov    %edi,%ebx
 137:	89 5d 08             	mov    %ebx,0x8(%ebp)
 13a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 13d:	5b                   	pop    %ebx
 13e:	5f                   	pop    %edi
 13f:	5d                   	pop    %ebp
 140:	c3                   	ret    

00000141 <strcpy>:
#include "x86.h"
#include "signal.h"

char*
strcpy(char *s, char *t)
{
 141:	55                   	push   %ebp
 142:	89 e5                	mov    %esp,%ebp
 144:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 147:	8b 45 08             	mov    0x8(%ebp),%eax
 14a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 14d:	8b 45 0c             	mov    0xc(%ebp),%eax
 150:	0f b6 10             	movzbl (%eax),%edx
 153:	8b 45 08             	mov    0x8(%ebp),%eax
 156:	88 10                	mov    %dl,(%eax)
 158:	8b 45 08             	mov    0x8(%ebp),%eax
 15b:	0f b6 00             	movzbl (%eax),%eax
 15e:	84 c0                	test   %al,%al
 160:	0f 95 c0             	setne  %al
 163:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 167:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 16b:	84 c0                	test   %al,%al
 16d:	75 de                	jne    14d <strcpy+0xc>
    ;
  return os;
 16f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 172:	c9                   	leave  
 173:	c3                   	ret    

00000174 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 174:	55                   	push   %ebp
 175:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 177:	eb 08                	jmp    181 <strcmp+0xd>
    p++, q++;
 179:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 17d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 181:	8b 45 08             	mov    0x8(%ebp),%eax
 184:	0f b6 00             	movzbl (%eax),%eax
 187:	84 c0                	test   %al,%al
 189:	74 10                	je     19b <strcmp+0x27>
 18b:	8b 45 08             	mov    0x8(%ebp),%eax
 18e:	0f b6 10             	movzbl (%eax),%edx
 191:	8b 45 0c             	mov    0xc(%ebp),%eax
 194:	0f b6 00             	movzbl (%eax),%eax
 197:	38 c2                	cmp    %al,%dl
 199:	74 de                	je     179 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 19b:	8b 45 08             	mov    0x8(%ebp),%eax
 19e:	0f b6 00             	movzbl (%eax),%eax
 1a1:	0f b6 d0             	movzbl %al,%edx
 1a4:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a7:	0f b6 00             	movzbl (%eax),%eax
 1aa:	0f b6 c0             	movzbl %al,%eax
 1ad:	89 d1                	mov    %edx,%ecx
 1af:	29 c1                	sub    %eax,%ecx
 1b1:	89 c8                	mov    %ecx,%eax
}
 1b3:	5d                   	pop    %ebp
 1b4:	c3                   	ret    

000001b5 <strlen>:

uint
strlen(char *s)
{
 1b5:	55                   	push   %ebp
 1b6:	89 e5                	mov    %esp,%ebp
 1b8:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1bb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1c2:	eb 04                	jmp    1c8 <strlen+0x13>
 1c4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 1cb:	03 45 08             	add    0x8(%ebp),%eax
 1ce:	0f b6 00             	movzbl (%eax),%eax
 1d1:	84 c0                	test   %al,%al
 1d3:	75 ef                	jne    1c4 <strlen+0xf>
    ;
  return n;
 1d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1d8:	c9                   	leave  
 1d9:	c3                   	ret    

000001da <memset>:

void*
memset(void *dst, int c, uint n)
{
 1da:	55                   	push   %ebp
 1db:	89 e5                	mov    %esp,%ebp
 1dd:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1e0:	8b 45 10             	mov    0x10(%ebp),%eax
 1e3:	89 44 24 08          	mov    %eax,0x8(%esp)
 1e7:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ea:	89 44 24 04          	mov    %eax,0x4(%esp)
 1ee:	8b 45 08             	mov    0x8(%ebp),%eax
 1f1:	89 04 24             	mov    %eax,(%esp)
 1f4:	e8 23 ff ff ff       	call   11c <stosb>
  return dst;
 1f9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1fc:	c9                   	leave  
 1fd:	c3                   	ret    

000001fe <strchr>:

char*
strchr(const char *s, char c)
{
 1fe:	55                   	push   %ebp
 1ff:	89 e5                	mov    %esp,%ebp
 201:	83 ec 04             	sub    $0x4,%esp
 204:	8b 45 0c             	mov    0xc(%ebp),%eax
 207:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 20a:	eb 14                	jmp    220 <strchr+0x22>
    if(*s == c)
 20c:	8b 45 08             	mov    0x8(%ebp),%eax
 20f:	0f b6 00             	movzbl (%eax),%eax
 212:	3a 45 fc             	cmp    -0x4(%ebp),%al
 215:	75 05                	jne    21c <strchr+0x1e>
      return (char*)s;
 217:	8b 45 08             	mov    0x8(%ebp),%eax
 21a:	eb 13                	jmp    22f <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 21c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 220:	8b 45 08             	mov    0x8(%ebp),%eax
 223:	0f b6 00             	movzbl (%eax),%eax
 226:	84 c0                	test   %al,%al
 228:	75 e2                	jne    20c <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 22a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 22f:	c9                   	leave  
 230:	c3                   	ret    

00000231 <gets>:

char*
gets(char *buf, int max)
{
 231:	55                   	push   %ebp
 232:	89 e5                	mov    %esp,%ebp
 234:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 237:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 23e:	eb 44                	jmp    284 <gets+0x53>
    cc = read(0, &c, 1);
 240:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 247:	00 
 248:	8d 45 ef             	lea    -0x11(%ebp),%eax
 24b:	89 44 24 04          	mov    %eax,0x4(%esp)
 24f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 256:	e8 69 01 00 00       	call   3c4 <read>
 25b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(cc < 1)
 25e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 262:	7e 2d                	jle    291 <gets+0x60>
      break;
    buf[i++] = c;
 264:	8b 45 f0             	mov    -0x10(%ebp),%eax
 267:	03 45 08             	add    0x8(%ebp),%eax
 26a:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 26e:	88 10                	mov    %dl,(%eax)
 270:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    if(c == '\n' || c == '\r')
 274:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 278:	3c 0a                	cmp    $0xa,%al
 27a:	74 16                	je     292 <gets+0x61>
 27c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 280:	3c 0d                	cmp    $0xd,%al
 282:	74 0e                	je     292 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 284:	8b 45 f0             	mov    -0x10(%ebp),%eax
 287:	83 c0 01             	add    $0x1,%eax
 28a:	3b 45 0c             	cmp    0xc(%ebp),%eax
 28d:	7c b1                	jl     240 <gets+0xf>
 28f:	eb 01                	jmp    292 <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 291:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 292:	8b 45 f0             	mov    -0x10(%ebp),%eax
 295:	03 45 08             	add    0x8(%ebp),%eax
 298:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 29b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 29e:	c9                   	leave  
 29f:	c3                   	ret    

000002a0 <stat>:

int
stat(char *n, struct stat *st)
{
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2a6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2ad:	00 
 2ae:	8b 45 08             	mov    0x8(%ebp),%eax
 2b1:	89 04 24             	mov    %eax,(%esp)
 2b4:	e8 33 01 00 00       	call   3ec <open>
 2b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0)
 2bc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2c0:	79 07                	jns    2c9 <stat+0x29>
    return -1;
 2c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2c7:	eb 23                	jmp    2ec <stat+0x4c>
  r = fstat(fd, st);
 2c9:	8b 45 0c             	mov    0xc(%ebp),%eax
 2cc:	89 44 24 04          	mov    %eax,0x4(%esp)
 2d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 2d3:	89 04 24             	mov    %eax,(%esp)
 2d6:	e8 29 01 00 00       	call   404 <fstat>
 2db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  close(fd);
 2de:	8b 45 f0             	mov    -0x10(%ebp),%eax
 2e1:	89 04 24             	mov    %eax,(%esp)
 2e4:	e8 eb 00 00 00       	call   3d4 <close>
  return r;
 2e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 2ec:	c9                   	leave  
 2ed:	c3                   	ret    

000002ee <atoi>:

int
atoi(const char *s)
{
 2ee:	55                   	push   %ebp
 2ef:	89 e5                	mov    %esp,%ebp
 2f1:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2f4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2fb:	eb 24                	jmp    321 <atoi+0x33>
    n = n*10 + *s++ - '0';
 2fd:	8b 55 fc             	mov    -0x4(%ebp),%edx
 300:	89 d0                	mov    %edx,%eax
 302:	c1 e0 02             	shl    $0x2,%eax
 305:	01 d0                	add    %edx,%eax
 307:	01 c0                	add    %eax,%eax
 309:	89 c2                	mov    %eax,%edx
 30b:	8b 45 08             	mov    0x8(%ebp),%eax
 30e:	0f b6 00             	movzbl (%eax),%eax
 311:	0f be c0             	movsbl %al,%eax
 314:	8d 04 02             	lea    (%edx,%eax,1),%eax
 317:	83 e8 30             	sub    $0x30,%eax
 31a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 31d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 321:	8b 45 08             	mov    0x8(%ebp),%eax
 324:	0f b6 00             	movzbl (%eax),%eax
 327:	3c 2f                	cmp    $0x2f,%al
 329:	7e 0a                	jle    335 <atoi+0x47>
 32b:	8b 45 08             	mov    0x8(%ebp),%eax
 32e:	0f b6 00             	movzbl (%eax),%eax
 331:	3c 39                	cmp    $0x39,%al
 333:	7e c8                	jle    2fd <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 335:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 338:	c9                   	leave  
 339:	c3                   	ret    

0000033a <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 33a:	55                   	push   %ebp
 33b:	89 e5                	mov    %esp,%ebp
 33d:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 340:	8b 45 08             	mov    0x8(%ebp),%eax
 343:	89 45 f8             	mov    %eax,-0x8(%ebp)
  src = vsrc;
 346:	8b 45 0c             	mov    0xc(%ebp),%eax
 349:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0)
 34c:	eb 13                	jmp    361 <memmove+0x27>
    *dst++ = *src++;
 34e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 351:	0f b6 10             	movzbl (%eax),%edx
 354:	8b 45 f8             	mov    -0x8(%ebp),%eax
 357:	88 10                	mov    %dl,(%eax)
 359:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 35d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 361:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 365:	0f 9f c0             	setg   %al
 368:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 36c:	84 c0                	test   %al,%al
 36e:	75 de                	jne    34e <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 370:	8b 45 08             	mov    0x8(%ebp),%eax
}
 373:	c9                   	leave  
 374:	c3                   	ret    

00000375 <trampoline>:
 375:	5a                   	pop    %edx
 376:	59                   	pop    %ecx
 377:	58                   	pop    %eax
 378:	c9                   	leave  
 379:	c3                   	ret    

0000037a <signal>:
//	"addl 4, %esp\n\t"
	"leave\n\t"
	"ret\n\t"
);
int signal(int signum, sighandler_t handler) 
{
 37a:	55                   	push   %ebp
 37b:	89 e5                	mov    %esp,%ebp
 37d:	83 ec 18             	sub    $0x18,%esp
	register_signal_handler(signum, handler, trampoline);
 380:	c7 44 24 08 75 03 00 	movl   $0x375,0x8(%esp)
 387:	00 
 388:	8b 45 0c             	mov    0xc(%ebp),%eax
 38b:	89 44 24 04          	mov    %eax,0x4(%esp)
 38f:	8b 45 08             	mov    0x8(%ebp),%eax
 392:	89 04 24             	mov    %eax,(%esp)
 395:	e8 ba 00 00 00       	call   454 <register_signal_handler>
	return 0;
 39a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 39f:	c9                   	leave  
 3a0:	c3                   	ret    
 3a1:	90                   	nop
 3a2:	90                   	nop
 3a3:	90                   	nop

000003a4 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3a4:	b8 01 00 00 00       	mov    $0x1,%eax
 3a9:	cd 40                	int    $0x40
 3ab:	c3                   	ret    

000003ac <exit>:
SYSCALL(exit)
 3ac:	b8 02 00 00 00       	mov    $0x2,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret    

000003b4 <wait>:
SYSCALL(wait)
 3b4:	b8 03 00 00 00       	mov    $0x3,%eax
 3b9:	cd 40                	int    $0x40
 3bb:	c3                   	ret    

000003bc <pipe>:
SYSCALL(pipe)
 3bc:	b8 04 00 00 00       	mov    $0x4,%eax
 3c1:	cd 40                	int    $0x40
 3c3:	c3                   	ret    

000003c4 <read>:
SYSCALL(read)
 3c4:	b8 05 00 00 00       	mov    $0x5,%eax
 3c9:	cd 40                	int    $0x40
 3cb:	c3                   	ret    

000003cc <write>:
SYSCALL(write)
 3cc:	b8 10 00 00 00       	mov    $0x10,%eax
 3d1:	cd 40                	int    $0x40
 3d3:	c3                   	ret    

000003d4 <close>:
SYSCALL(close)
 3d4:	b8 15 00 00 00       	mov    $0x15,%eax
 3d9:	cd 40                	int    $0x40
 3db:	c3                   	ret    

000003dc <kill>:
SYSCALL(kill)
 3dc:	b8 06 00 00 00       	mov    $0x6,%eax
 3e1:	cd 40                	int    $0x40
 3e3:	c3                   	ret    

000003e4 <exec>:
SYSCALL(exec)
 3e4:	b8 07 00 00 00       	mov    $0x7,%eax
 3e9:	cd 40                	int    $0x40
 3eb:	c3                   	ret    

000003ec <open>:
SYSCALL(open)
 3ec:	b8 0f 00 00 00       	mov    $0xf,%eax
 3f1:	cd 40                	int    $0x40
 3f3:	c3                   	ret    

000003f4 <mknod>:
SYSCALL(mknod)
 3f4:	b8 11 00 00 00       	mov    $0x11,%eax
 3f9:	cd 40                	int    $0x40
 3fb:	c3                   	ret    

000003fc <unlink>:
SYSCALL(unlink)
 3fc:	b8 12 00 00 00       	mov    $0x12,%eax
 401:	cd 40                	int    $0x40
 403:	c3                   	ret    

00000404 <fstat>:
SYSCALL(fstat)
 404:	b8 08 00 00 00       	mov    $0x8,%eax
 409:	cd 40                	int    $0x40
 40b:	c3                   	ret    

0000040c <link>:
SYSCALL(link)
 40c:	b8 13 00 00 00       	mov    $0x13,%eax
 411:	cd 40                	int    $0x40
 413:	c3                   	ret    

00000414 <mkdir>:
SYSCALL(mkdir)
 414:	b8 14 00 00 00       	mov    $0x14,%eax
 419:	cd 40                	int    $0x40
 41b:	c3                   	ret    

0000041c <chdir>:
SYSCALL(chdir)
 41c:	b8 09 00 00 00       	mov    $0x9,%eax
 421:	cd 40                	int    $0x40
 423:	c3                   	ret    

00000424 <dup>:
SYSCALL(dup)
 424:	b8 0a 00 00 00       	mov    $0xa,%eax
 429:	cd 40                	int    $0x40
 42b:	c3                   	ret    

0000042c <getpid>:
SYSCALL(getpid)
 42c:	b8 0b 00 00 00       	mov    $0xb,%eax
 431:	cd 40                	int    $0x40
 433:	c3                   	ret    

00000434 <sbrk>:
SYSCALL(sbrk)
 434:	b8 0c 00 00 00       	mov    $0xc,%eax
 439:	cd 40                	int    $0x40
 43b:	c3                   	ret    

0000043c <sleep>:
SYSCALL(sleep)
 43c:	b8 0d 00 00 00       	mov    $0xd,%eax
 441:	cd 40                	int    $0x40
 443:	c3                   	ret    

00000444 <uptime>:
SYSCALL(uptime)
 444:	b8 0e 00 00 00       	mov    $0xe,%eax
 449:	cd 40                	int    $0x40
 44b:	c3                   	ret    

0000044c <halt>:
SYSCALL(halt)
 44c:	b8 16 00 00 00       	mov    $0x16,%eax
 451:	cd 40                	int    $0x40
 453:	c3                   	ret    

00000454 <register_signal_handler>:
SYSCALL(register_signal_handler)
 454:	b8 17 00 00 00       	mov    $0x17,%eax
 459:	cd 40                	int    $0x40
 45b:	c3                   	ret    

0000045c <alarm>:
SYSCALL(alarm)
 45c:	b8 18 00 00 00       	mov    $0x18,%eax
 461:	cd 40                	int    $0x40
 463:	c3                   	ret    

00000464 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 464:	55                   	push   %ebp
 465:	89 e5                	mov    %esp,%ebp
 467:	83 ec 28             	sub    $0x28,%esp
 46a:	8b 45 0c             	mov    0xc(%ebp),%eax
 46d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 470:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 477:	00 
 478:	8d 45 f4             	lea    -0xc(%ebp),%eax
 47b:	89 44 24 04          	mov    %eax,0x4(%esp)
 47f:	8b 45 08             	mov    0x8(%ebp),%eax
 482:	89 04 24             	mov    %eax,(%esp)
 485:	e8 42 ff ff ff       	call   3cc <write>
}
 48a:	c9                   	leave  
 48b:	c3                   	ret    

0000048c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 48c:	55                   	push   %ebp
 48d:	89 e5                	mov    %esp,%ebp
 48f:	53                   	push   %ebx
 490:	83 ec 44             	sub    $0x44,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 493:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 49a:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 49e:	74 17                	je     4b7 <printint+0x2b>
 4a0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4a4:	79 11                	jns    4b7 <printint+0x2b>
    neg = 1;
 4a6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4ad:	8b 45 0c             	mov    0xc(%ebp),%eax
 4b0:	f7 d8                	neg    %eax
 4b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4b5:	eb 06                	jmp    4bd <printint+0x31>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4b7:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }

  i = 0;
 4bd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  do{
    buf[i++] = digits[x % base];
 4c4:	8b 4d ec             	mov    -0x14(%ebp),%ecx
 4c7:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4cd:	ba 00 00 00 00       	mov    $0x0,%edx
 4d2:	f7 f3                	div    %ebx
 4d4:	89 d0                	mov    %edx,%eax
 4d6:	0f b6 80 58 09 00 00 	movzbl 0x958(%eax),%eax
 4dd:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
 4e1:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  }while((x /= base) != 0);
 4e5:	8b 45 10             	mov    0x10(%ebp),%eax
 4e8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 4eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4ee:	ba 00 00 00 00       	mov    $0x0,%edx
 4f3:	f7 75 d4             	divl   -0x2c(%ebp)
 4f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4fd:	75 c5                	jne    4c4 <printint+0x38>
  if(neg)
 4ff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 503:	74 2a                	je     52f <printint+0xa3>
    buf[i++] = '-';
 505:	8b 45 ec             	mov    -0x14(%ebp),%eax
 508:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)
 50d:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)

  while(--i >= 0)
 511:	eb 1d                	jmp    530 <printint+0xa4>
    putc(fd, buf[i]);
 513:	8b 45 ec             	mov    -0x14(%ebp),%eax
 516:	0f b6 44 05 dc       	movzbl -0x24(%ebp,%eax,1),%eax
 51b:	0f be c0             	movsbl %al,%eax
 51e:	89 44 24 04          	mov    %eax,0x4(%esp)
 522:	8b 45 08             	mov    0x8(%ebp),%eax
 525:	89 04 24             	mov    %eax,(%esp)
 528:	e8 37 ff ff ff       	call   464 <putc>
 52d:	eb 01                	jmp    530 <printint+0xa4>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 52f:	90                   	nop
 530:	83 6d ec 01          	subl   $0x1,-0x14(%ebp)
 534:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 538:	79 d9                	jns    513 <printint+0x87>
    putc(fd, buf[i]);
}
 53a:	83 c4 44             	add    $0x44,%esp
 53d:	5b                   	pop    %ebx
 53e:	5d                   	pop    %ebp
 53f:	c3                   	ret    

00000540 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 540:	55                   	push   %ebp
 541:	89 e5                	mov    %esp,%ebp
 543:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 546:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 54d:	8d 45 0c             	lea    0xc(%ebp),%eax
 550:	83 c0 04             	add    $0x4,%eax
 553:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i = 0; fmt[i]; i++){
 556:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 55d:	e9 7e 01 00 00       	jmp    6e0 <printf+0x1a0>
    c = fmt[i] & 0xff;
 562:	8b 55 0c             	mov    0xc(%ebp),%edx
 565:	8b 45 ec             	mov    -0x14(%ebp),%eax
 568:	8d 04 02             	lea    (%edx,%eax,1),%eax
 56b:	0f b6 00             	movzbl (%eax),%eax
 56e:	0f be c0             	movsbl %al,%eax
 571:	25 ff 00 00 00       	and    $0xff,%eax
 576:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(state == 0){
 579:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 57d:	75 2c                	jne    5ab <printf+0x6b>
      if(c == '%'){
 57f:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 583:	75 0c                	jne    591 <printf+0x51>
        state = '%';
 585:	c7 45 f0 25 00 00 00 	movl   $0x25,-0x10(%ebp)
 58c:	e9 4b 01 00 00       	jmp    6dc <printf+0x19c>
      } else {
        putc(fd, c);
 591:	8b 45 e8             	mov    -0x18(%ebp),%eax
 594:	0f be c0             	movsbl %al,%eax
 597:	89 44 24 04          	mov    %eax,0x4(%esp)
 59b:	8b 45 08             	mov    0x8(%ebp),%eax
 59e:	89 04 24             	mov    %eax,(%esp)
 5a1:	e8 be fe ff ff       	call   464 <putc>
 5a6:	e9 31 01 00 00       	jmp    6dc <printf+0x19c>
      }
    } else if(state == '%'){
 5ab:	83 7d f0 25          	cmpl   $0x25,-0x10(%ebp)
 5af:	0f 85 27 01 00 00    	jne    6dc <printf+0x19c>
      if(c == 'd'){
 5b5:	83 7d e8 64          	cmpl   $0x64,-0x18(%ebp)
 5b9:	75 2d                	jne    5e8 <printf+0xa8>
        printint(fd, *ap, 10, 1);
 5bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5be:	8b 00                	mov    (%eax),%eax
 5c0:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 5c7:	00 
 5c8:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 5cf:	00 
 5d0:	89 44 24 04          	mov    %eax,0x4(%esp)
 5d4:	8b 45 08             	mov    0x8(%ebp),%eax
 5d7:	89 04 24             	mov    %eax,(%esp)
 5da:	e8 ad fe ff ff       	call   48c <printint>
        ap++;
 5df:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 5e3:	e9 ed 00 00 00       	jmp    6d5 <printf+0x195>
      } else if(c == 'x' || c == 'p'){
 5e8:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
 5ec:	74 06                	je     5f4 <printf+0xb4>
 5ee:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
 5f2:	75 2d                	jne    621 <printf+0xe1>
        printint(fd, *ap, 16, 0);
 5f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5f7:	8b 00                	mov    (%eax),%eax
 5f9:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 600:	00 
 601:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 608:	00 
 609:	89 44 24 04          	mov    %eax,0x4(%esp)
 60d:	8b 45 08             	mov    0x8(%ebp),%eax
 610:	89 04 24             	mov    %eax,(%esp)
 613:	e8 74 fe ff ff       	call   48c <printint>
        ap++;
 618:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 61c:	e9 b4 00 00 00       	jmp    6d5 <printf+0x195>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 621:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
 625:	75 46                	jne    66d <printf+0x12d>
        s = (char*)*ap;
 627:	8b 45 f4             	mov    -0xc(%ebp),%eax
 62a:	8b 00                	mov    (%eax),%eax
 62c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ap++;
 62f:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
        if(s == 0)
 633:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 637:	75 27                	jne    660 <printf+0x120>
          s = "(null)";
 639:	c7 45 e4 4f 09 00 00 	movl   $0x94f,-0x1c(%ebp)
        while(*s != 0){
 640:	eb 1f                	jmp    661 <printf+0x121>
          putc(fd, *s);
 642:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 645:	0f b6 00             	movzbl (%eax),%eax
 648:	0f be c0             	movsbl %al,%eax
 64b:	89 44 24 04          	mov    %eax,0x4(%esp)
 64f:	8b 45 08             	mov    0x8(%ebp),%eax
 652:	89 04 24             	mov    %eax,(%esp)
 655:	e8 0a fe ff ff       	call   464 <putc>
          s++;
 65a:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 65e:	eb 01                	jmp    661 <printf+0x121>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 660:	90                   	nop
 661:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 664:	0f b6 00             	movzbl (%eax),%eax
 667:	84 c0                	test   %al,%al
 669:	75 d7                	jne    642 <printf+0x102>
 66b:	eb 68                	jmp    6d5 <printf+0x195>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 66d:	83 7d e8 63          	cmpl   $0x63,-0x18(%ebp)
 671:	75 1d                	jne    690 <printf+0x150>
        putc(fd, *ap);
 673:	8b 45 f4             	mov    -0xc(%ebp),%eax
 676:	8b 00                	mov    (%eax),%eax
 678:	0f be c0             	movsbl %al,%eax
 67b:	89 44 24 04          	mov    %eax,0x4(%esp)
 67f:	8b 45 08             	mov    0x8(%ebp),%eax
 682:	89 04 24             	mov    %eax,(%esp)
 685:	e8 da fd ff ff       	call   464 <putc>
        ap++;
 68a:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 68e:	eb 45                	jmp    6d5 <printf+0x195>
      } else if(c == '%'){
 690:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 694:	75 17                	jne    6ad <printf+0x16d>
        putc(fd, c);
 696:	8b 45 e8             	mov    -0x18(%ebp),%eax
 699:	0f be c0             	movsbl %al,%eax
 69c:	89 44 24 04          	mov    %eax,0x4(%esp)
 6a0:	8b 45 08             	mov    0x8(%ebp),%eax
 6a3:	89 04 24             	mov    %eax,(%esp)
 6a6:	e8 b9 fd ff ff       	call   464 <putc>
 6ab:	eb 28                	jmp    6d5 <printf+0x195>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6ad:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 6b4:	00 
 6b5:	8b 45 08             	mov    0x8(%ebp),%eax
 6b8:	89 04 24             	mov    %eax,(%esp)
 6bb:	e8 a4 fd ff ff       	call   464 <putc>
        putc(fd, c);
 6c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6c3:	0f be c0             	movsbl %al,%eax
 6c6:	89 44 24 04          	mov    %eax,0x4(%esp)
 6ca:	8b 45 08             	mov    0x8(%ebp),%eax
 6cd:	89 04 24             	mov    %eax,(%esp)
 6d0:	e8 8f fd ff ff       	call   464 <putc>
      }
      state = 0;
 6d5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6dc:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 6e0:	8b 55 0c             	mov    0xc(%ebp),%edx
 6e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6e6:	8d 04 02             	lea    (%edx,%eax,1),%eax
 6e9:	0f b6 00             	movzbl (%eax),%eax
 6ec:	84 c0                	test   %al,%al
 6ee:	0f 85 6e fe ff ff    	jne    562 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6f4:	c9                   	leave  
 6f5:	c3                   	ret    
 6f6:	90                   	nop
 6f7:	90                   	nop

000006f8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6f8:	55                   	push   %ebp
 6f9:	89 e5                	mov    %esp,%ebp
 6fb:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6fe:	8b 45 08             	mov    0x8(%ebp),%eax
 701:	83 e8 08             	sub    $0x8,%eax
 704:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 707:	a1 78 09 00 00       	mov    0x978,%eax
 70c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 70f:	eb 24                	jmp    735 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 711:	8b 45 fc             	mov    -0x4(%ebp),%eax
 714:	8b 00                	mov    (%eax),%eax
 716:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 719:	77 12                	ja     72d <free+0x35>
 71b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 721:	77 24                	ja     747 <free+0x4f>
 723:	8b 45 fc             	mov    -0x4(%ebp),%eax
 726:	8b 00                	mov    (%eax),%eax
 728:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 72b:	77 1a                	ja     747 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 72d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 730:	8b 00                	mov    (%eax),%eax
 732:	89 45 fc             	mov    %eax,-0x4(%ebp)
 735:	8b 45 f8             	mov    -0x8(%ebp),%eax
 738:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 73b:	76 d4                	jbe    711 <free+0x19>
 73d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 740:	8b 00                	mov    (%eax),%eax
 742:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 745:	76 ca                	jbe    711 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 747:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74a:	8b 40 04             	mov    0x4(%eax),%eax
 74d:	c1 e0 03             	shl    $0x3,%eax
 750:	89 c2                	mov    %eax,%edx
 752:	03 55 f8             	add    -0x8(%ebp),%edx
 755:	8b 45 fc             	mov    -0x4(%ebp),%eax
 758:	8b 00                	mov    (%eax),%eax
 75a:	39 c2                	cmp    %eax,%edx
 75c:	75 24                	jne    782 <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 75e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 761:	8b 50 04             	mov    0x4(%eax),%edx
 764:	8b 45 fc             	mov    -0x4(%ebp),%eax
 767:	8b 00                	mov    (%eax),%eax
 769:	8b 40 04             	mov    0x4(%eax),%eax
 76c:	01 c2                	add    %eax,%edx
 76e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 771:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 774:	8b 45 fc             	mov    -0x4(%ebp),%eax
 777:	8b 00                	mov    (%eax),%eax
 779:	8b 10                	mov    (%eax),%edx
 77b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77e:	89 10                	mov    %edx,(%eax)
 780:	eb 0a                	jmp    78c <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 782:	8b 45 fc             	mov    -0x4(%ebp),%eax
 785:	8b 10                	mov    (%eax),%edx
 787:	8b 45 f8             	mov    -0x8(%ebp),%eax
 78a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 78c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78f:	8b 40 04             	mov    0x4(%eax),%eax
 792:	c1 e0 03             	shl    $0x3,%eax
 795:	03 45 fc             	add    -0x4(%ebp),%eax
 798:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 79b:	75 20                	jne    7bd <free+0xc5>
    p->s.size += bp->s.size;
 79d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a0:	8b 50 04             	mov    0x4(%eax),%edx
 7a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a6:	8b 40 04             	mov    0x4(%eax),%eax
 7a9:	01 c2                	add    %eax,%edx
 7ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ae:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b4:	8b 10                	mov    (%eax),%edx
 7b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b9:	89 10                	mov    %edx,(%eax)
 7bb:	eb 08                	jmp    7c5 <free+0xcd>
  } else
    p->s.ptr = bp;
 7bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c0:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7c3:	89 10                	mov    %edx,(%eax)
  freep = p;
 7c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c8:	a3 78 09 00 00       	mov    %eax,0x978
}
 7cd:	c9                   	leave  
 7ce:	c3                   	ret    

000007cf <morecore>:

static Header*
morecore(uint nu)
{
 7cf:	55                   	push   %ebp
 7d0:	89 e5                	mov    %esp,%ebp
 7d2:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7d5:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7dc:	77 07                	ja     7e5 <morecore+0x16>
    nu = 4096;
 7de:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7e5:	8b 45 08             	mov    0x8(%ebp),%eax
 7e8:	c1 e0 03             	shl    $0x3,%eax
 7eb:	89 04 24             	mov    %eax,(%esp)
 7ee:	e8 41 fc ff ff       	call   434 <sbrk>
 7f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(p == (char*)-1)
 7f6:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
 7fa:	75 07                	jne    803 <morecore+0x34>
    return 0;
 7fc:	b8 00 00 00 00       	mov    $0x0,%eax
 801:	eb 22                	jmp    825 <morecore+0x56>
  hp = (Header*)p;
 803:	8b 45 f0             	mov    -0x10(%ebp),%eax
 806:	89 45 f4             	mov    %eax,-0xc(%ebp)
  hp->s.size = nu;
 809:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80c:	8b 55 08             	mov    0x8(%ebp),%edx
 80f:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 812:	8b 45 f4             	mov    -0xc(%ebp),%eax
 815:	83 c0 08             	add    $0x8,%eax
 818:	89 04 24             	mov    %eax,(%esp)
 81b:	e8 d8 fe ff ff       	call   6f8 <free>
  return freep;
 820:	a1 78 09 00 00       	mov    0x978,%eax
}
 825:	c9                   	leave  
 826:	c3                   	ret    

00000827 <malloc>:

void*
malloc(uint nbytes)
{
 827:	55                   	push   %ebp
 828:	89 e5                	mov    %esp,%ebp
 82a:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 82d:	8b 45 08             	mov    0x8(%ebp),%eax
 830:	83 c0 07             	add    $0x7,%eax
 833:	c1 e8 03             	shr    $0x3,%eax
 836:	83 c0 01             	add    $0x1,%eax
 839:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((prevp = freep) == 0){
 83c:	a1 78 09 00 00       	mov    0x978,%eax
 841:	89 45 f0             	mov    %eax,-0x10(%ebp)
 844:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 848:	75 23                	jne    86d <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 84a:	c7 45 f0 70 09 00 00 	movl   $0x970,-0x10(%ebp)
 851:	8b 45 f0             	mov    -0x10(%ebp),%eax
 854:	a3 78 09 00 00       	mov    %eax,0x978
 859:	a1 78 09 00 00       	mov    0x978,%eax
 85e:	a3 70 09 00 00       	mov    %eax,0x970
    base.s.size = 0;
 863:	c7 05 74 09 00 00 00 	movl   $0x0,0x974
 86a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 86d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 870:	8b 00                	mov    (%eax),%eax
 872:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(p->s.size >= nunits){
 875:	8b 45 ec             	mov    -0x14(%ebp),%eax
 878:	8b 40 04             	mov    0x4(%eax),%eax
 87b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 87e:	72 4d                	jb     8cd <malloc+0xa6>
      if(p->s.size == nunits)
 880:	8b 45 ec             	mov    -0x14(%ebp),%eax
 883:	8b 40 04             	mov    0x4(%eax),%eax
 886:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 889:	75 0c                	jne    897 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 88b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 88e:	8b 10                	mov    (%eax),%edx
 890:	8b 45 f0             	mov    -0x10(%ebp),%eax
 893:	89 10                	mov    %edx,(%eax)
 895:	eb 26                	jmp    8bd <malloc+0x96>
      else {
        p->s.size -= nunits;
 897:	8b 45 ec             	mov    -0x14(%ebp),%eax
 89a:	8b 40 04             	mov    0x4(%eax),%eax
 89d:	89 c2                	mov    %eax,%edx
 89f:	2b 55 f4             	sub    -0xc(%ebp),%edx
 8a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8a5:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8ab:	8b 40 04             	mov    0x4(%eax),%eax
 8ae:	c1 e0 03             	shl    $0x3,%eax
 8b1:	01 45 ec             	add    %eax,-0x14(%ebp)
        p->s.size = nunits;
 8b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
 8ba:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c0:	a3 78 09 00 00       	mov    %eax,0x978
      return (void*)(p + 1);
 8c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8c8:	83 c0 08             	add    $0x8,%eax
 8cb:	eb 38                	jmp    905 <malloc+0xde>
    }
    if(p == freep)
 8cd:	a1 78 09 00 00       	mov    0x978,%eax
 8d2:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 8d5:	75 1b                	jne    8f2 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 8d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8da:	89 04 24             	mov    %eax,(%esp)
 8dd:	e8 ed fe ff ff       	call   7cf <morecore>
 8e2:	89 45 ec             	mov    %eax,-0x14(%ebp)
 8e5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 8e9:	75 07                	jne    8f2 <malloc+0xcb>
        return 0;
 8eb:	b8 00 00 00 00       	mov    $0x0,%eax
 8f0:	eb 13                	jmp    905 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8fb:	8b 00                	mov    (%eax),%eax
 8fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 900:	e9 70 ff ff ff       	jmp    875 <malloc+0x4e>
}
 905:	c9                   	leave  
 906:	c3                   	ret    
