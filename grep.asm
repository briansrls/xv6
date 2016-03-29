
_grep:     file format elf32-i386


Disassembly of section .text:

00000000 <grep>:
char buf[1024];
int match(char*, char*);

void
grep(char *pattern, int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  int n, m;
  char *p, *q;
  
  m = 0;
   6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
   d:	e9 c6 00 00 00       	jmp    d8 <grep+0xd8>
    m += n;
  12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  15:	01 45 f4             	add    %eax,-0xc(%ebp)
    buf[m] = '\0';
  18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1b:	05 80 0e 00 00       	add    $0xe80,%eax
  20:	c6 00 00             	movb   $0x0,(%eax)
    p = buf;
  23:	c7 45 f0 80 0e 00 00 	movl   $0xe80,-0x10(%ebp)
    while((q = strchr(p, '\n')) != 0){
  2a:	eb 4f                	jmp    7b <grep+0x7b>
      *q = 0;
  2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  2f:	c6 00 00             	movb   $0x0,(%eax)
      if(match(pattern, p)){
  32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  35:	89 44 24 04          	mov    %eax,0x4(%esp)
  39:	8b 45 08             	mov    0x8(%ebp),%eax
  3c:	89 04 24             	mov    %eax,(%esp)
  3f:	e8 bd 01 00 00       	call   201 <match>
  44:	85 c0                	test   %eax,%eax
  46:	74 2c                	je     74 <grep+0x74>
        *q = '\n';
  48:	8b 45 e8             	mov    -0x18(%ebp),%eax
  4b:	c6 00 0a             	movb   $0xa,(%eax)
        write(1, p, q+1 - p);
  4e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  51:	40                   	inc    %eax
  52:	89 c2                	mov    %eax,%edx
  54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  57:	89 d1                	mov    %edx,%ecx
  59:	29 c1                	sub    %eax,%ecx
  5b:	89 c8                	mov    %ecx,%eax
  5d:	89 44 24 08          	mov    %eax,0x8(%esp)
  61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  64:	89 44 24 04          	mov    %eax,0x4(%esp)
  68:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  6f:	e8 7c 05 00 00       	call   5f0 <write>
      }
      p = q+1;
  74:	8b 45 e8             	mov    -0x18(%ebp),%eax
  77:	40                   	inc    %eax
  78:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
    m += n;
    buf[m] = '\0';
    p = buf;
    while((q = strchr(p, '\n')) != 0){
  7b:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  82:	00 
  83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  86:	89 04 24             	mov    %eax,(%esp)
  89:	e8 9e 03 00 00       	call   42c <strchr>
  8e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  91:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  95:	75 95                	jne    2c <grep+0x2c>
        *q = '\n';
        write(1, p, q+1 - p);
      }
      p = q+1;
    }
    if(p == buf)
  97:	81 7d f0 80 0e 00 00 	cmpl   $0xe80,-0x10(%ebp)
  9e:	75 07                	jne    a7 <grep+0xa7>
      m = 0;
  a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(m > 0){
  a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  ab:	7e 2b                	jle    d8 <grep+0xd8>
      m -= p - buf;
  ad:	ba 80 0e 00 00       	mov    $0xe80,%edx
  b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  b5:	89 d1                	mov    %edx,%ecx
  b7:	29 c1                	sub    %eax,%ecx
  b9:	89 c8                	mov    %ecx,%eax
  bb:	01 45 f4             	add    %eax,-0xc(%ebp)
      memmove(buf, p, m);
  be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  c1:	89 44 24 08          	mov    %eax,0x8(%esp)
  c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  cc:	c7 04 24 80 0e 00 00 	movl   $0xe80,(%esp)
  d3:	e8 86 04 00 00       	call   55e <memmove>
{
  int n, m;
  char *p, *q;
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
  d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  db:	ba ff 03 00 00       	mov    $0x3ff,%edx
  e0:	89 d1                	mov    %edx,%ecx
  e2:	29 c1                	sub    %eax,%ecx
  e4:	89 c8                	mov    %ecx,%eax
  e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  e9:	81 c2 80 0e 00 00    	add    $0xe80,%edx
  ef:	89 44 24 08          	mov    %eax,0x8(%esp)
  f3:	89 54 24 04          	mov    %edx,0x4(%esp)
  f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  fa:	89 04 24             	mov    %eax,(%esp)
  fd:	e8 e6 04 00 00       	call   5e8 <read>
 102:	89 45 ec             	mov    %eax,-0x14(%ebp)
 105:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 109:	0f 8f 03 ff ff ff    	jg     12 <grep+0x12>
    if(m > 0){
      m -= p - buf;
      memmove(buf, p, m);
    }
  }
}
 10f:	c9                   	leave  
 110:	c3                   	ret    

00000111 <main>:

int
main(int argc, char *argv[])
{
 111:	55                   	push   %ebp
 112:	89 e5                	mov    %esp,%ebp
 114:	83 e4 f0             	and    $0xfffffff0,%esp
 117:	83 ec 20             	sub    $0x20,%esp
  int fd, i;
  char *pattern;
  
  if(argc <= 1){
 11a:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 11e:	7f 19                	jg     139 <main+0x28>
    printf(2, "usage: grep pattern [file ...]\n");
 120:	c7 44 24 04 28 0b 00 	movl   $0xb28,0x4(%esp)
 127:	00 
 128:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 12f:	e8 2c 06 00 00       	call   760 <printf>
    exit();
 134:	e8 97 04 00 00       	call   5d0 <exit>
  }
  pattern = argv[1];
 139:	8b 45 0c             	mov    0xc(%ebp),%eax
 13c:	8b 40 04             	mov    0x4(%eax),%eax
 13f:	89 44 24 18          	mov    %eax,0x18(%esp)
  
  if(argc <= 2){
 143:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
 147:	7f 19                	jg     162 <main+0x51>
    grep(pattern, 0);
 149:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 150:	00 
 151:	8b 44 24 18          	mov    0x18(%esp),%eax
 155:	89 04 24             	mov    %eax,(%esp)
 158:	e8 a3 fe ff ff       	call   0 <grep>
    exit();
 15d:	e8 6e 04 00 00       	call   5d0 <exit>
  }

  for(i = 2; i < argc; i++){
 162:	c7 44 24 1c 02 00 00 	movl   $0x2,0x1c(%esp)
 169:	00 
 16a:	e9 80 00 00 00       	jmp    1ef <main+0xde>
    if((fd = open(argv[i], 0)) < 0){
 16f:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 173:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 17a:	8b 45 0c             	mov    0xc(%ebp),%eax
 17d:	01 d0                	add    %edx,%eax
 17f:	8b 00                	mov    (%eax),%eax
 181:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 188:	00 
 189:	89 04 24             	mov    %eax,(%esp)
 18c:	e8 7f 04 00 00       	call   610 <open>
 191:	89 44 24 14          	mov    %eax,0x14(%esp)
 195:	83 7c 24 14 00       	cmpl   $0x0,0x14(%esp)
 19a:	79 2f                	jns    1cb <main+0xba>
      printf(1, "grep: cannot open %s\n", argv[i]);
 19c:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 1a0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 1a7:	8b 45 0c             	mov    0xc(%ebp),%eax
 1aa:	01 d0                	add    %edx,%eax
 1ac:	8b 00                	mov    (%eax),%eax
 1ae:	89 44 24 08          	mov    %eax,0x8(%esp)
 1b2:	c7 44 24 04 48 0b 00 	movl   $0xb48,0x4(%esp)
 1b9:	00 
 1ba:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1c1:	e8 9a 05 00 00       	call   760 <printf>
      exit();
 1c6:	e8 05 04 00 00       	call   5d0 <exit>
    }
    grep(pattern, fd);
 1cb:	8b 44 24 14          	mov    0x14(%esp),%eax
 1cf:	89 44 24 04          	mov    %eax,0x4(%esp)
 1d3:	8b 44 24 18          	mov    0x18(%esp),%eax
 1d7:	89 04 24             	mov    %eax,(%esp)
 1da:	e8 21 fe ff ff       	call   0 <grep>
    close(fd);
 1df:	8b 44 24 14          	mov    0x14(%esp),%eax
 1e3:	89 04 24             	mov    %eax,(%esp)
 1e6:	e8 0d 04 00 00       	call   5f8 <close>
  if(argc <= 2){
    grep(pattern, 0);
    exit();
  }

  for(i = 2; i < argc; i++){
 1eb:	ff 44 24 1c          	incl   0x1c(%esp)
 1ef:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 1f3:	3b 45 08             	cmp    0x8(%ebp),%eax
 1f6:	0f 8c 73 ff ff ff    	jl     16f <main+0x5e>
      exit();
    }
    grep(pattern, fd);
    close(fd);
  }
  exit();
 1fc:	e8 cf 03 00 00       	call   5d0 <exit>

00000201 <match>:
int matchhere(char*, char*);
int matchstar(int, char*, char*);

int
match(char *re, char *text)
{
 201:	55                   	push   %ebp
 202:	89 e5                	mov    %esp,%ebp
 204:	83 ec 18             	sub    $0x18,%esp
  if(re[0] == '^')
 207:	8b 45 08             	mov    0x8(%ebp),%eax
 20a:	8a 00                	mov    (%eax),%al
 20c:	3c 5e                	cmp    $0x5e,%al
 20e:	75 17                	jne    227 <match+0x26>
    return matchhere(re+1, text);
 210:	8b 45 08             	mov    0x8(%ebp),%eax
 213:	8d 50 01             	lea    0x1(%eax),%edx
 216:	8b 45 0c             	mov    0xc(%ebp),%eax
 219:	89 44 24 04          	mov    %eax,0x4(%esp)
 21d:	89 14 24             	mov    %edx,(%esp)
 220:	e8 37 00 00 00       	call   25c <matchhere>
 225:	eb 33                	jmp    25a <match+0x59>
  do{  // must look at empty string
    if(matchhere(re, text))
 227:	8b 45 0c             	mov    0xc(%ebp),%eax
 22a:	89 44 24 04          	mov    %eax,0x4(%esp)
 22e:	8b 45 08             	mov    0x8(%ebp),%eax
 231:	89 04 24             	mov    %eax,(%esp)
 234:	e8 23 00 00 00       	call   25c <matchhere>
 239:	85 c0                	test   %eax,%eax
 23b:	74 07                	je     244 <match+0x43>
      return 1;
 23d:	b8 01 00 00 00       	mov    $0x1,%eax
 242:	eb 16                	jmp    25a <match+0x59>
  }while(*text++ != '\0');
 244:	8b 45 0c             	mov    0xc(%ebp),%eax
 247:	8a 00                	mov    (%eax),%al
 249:	84 c0                	test   %al,%al
 24b:	0f 95 c0             	setne  %al
 24e:	ff 45 0c             	incl   0xc(%ebp)
 251:	84 c0                	test   %al,%al
 253:	75 d2                	jne    227 <match+0x26>
  return 0;
 255:	b8 00 00 00 00       	mov    $0x0,%eax
}
 25a:	c9                   	leave  
 25b:	c3                   	ret    

0000025c <matchhere>:

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
 25c:	55                   	push   %ebp
 25d:	89 e5                	mov    %esp,%ebp
 25f:	83 ec 18             	sub    $0x18,%esp
  if(re[0] == '\0')
 262:	8b 45 08             	mov    0x8(%ebp),%eax
 265:	8a 00                	mov    (%eax),%al
 267:	84 c0                	test   %al,%al
 269:	75 0a                	jne    275 <matchhere+0x19>
    return 1;
 26b:	b8 01 00 00 00       	mov    $0x1,%eax
 270:	e9 8c 00 00 00       	jmp    301 <matchhere+0xa5>
  if(re[1] == '*')
 275:	8b 45 08             	mov    0x8(%ebp),%eax
 278:	40                   	inc    %eax
 279:	8a 00                	mov    (%eax),%al
 27b:	3c 2a                	cmp    $0x2a,%al
 27d:	75 23                	jne    2a2 <matchhere+0x46>
    return matchstar(re[0], re+2, text);
 27f:	8b 45 08             	mov    0x8(%ebp),%eax
 282:	8d 48 02             	lea    0x2(%eax),%ecx
 285:	8b 45 08             	mov    0x8(%ebp),%eax
 288:	8a 00                	mov    (%eax),%al
 28a:	0f be c0             	movsbl %al,%eax
 28d:	8b 55 0c             	mov    0xc(%ebp),%edx
 290:	89 54 24 08          	mov    %edx,0x8(%esp)
 294:	89 4c 24 04          	mov    %ecx,0x4(%esp)
 298:	89 04 24             	mov    %eax,(%esp)
 29b:	e8 63 00 00 00       	call   303 <matchstar>
 2a0:	eb 5f                	jmp    301 <matchhere+0xa5>
  if(re[0] == '$' && re[1] == '\0')
 2a2:	8b 45 08             	mov    0x8(%ebp),%eax
 2a5:	8a 00                	mov    (%eax),%al
 2a7:	3c 24                	cmp    $0x24,%al
 2a9:	75 19                	jne    2c4 <matchhere+0x68>
 2ab:	8b 45 08             	mov    0x8(%ebp),%eax
 2ae:	40                   	inc    %eax
 2af:	8a 00                	mov    (%eax),%al
 2b1:	84 c0                	test   %al,%al
 2b3:	75 0f                	jne    2c4 <matchhere+0x68>
    return *text == '\0';
 2b5:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b8:	8a 00                	mov    (%eax),%al
 2ba:	84 c0                	test   %al,%al
 2bc:	0f 94 c0             	sete   %al
 2bf:	0f b6 c0             	movzbl %al,%eax
 2c2:	eb 3d                	jmp    301 <matchhere+0xa5>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
 2c4:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c7:	8a 00                	mov    (%eax),%al
 2c9:	84 c0                	test   %al,%al
 2cb:	74 2f                	je     2fc <matchhere+0xa0>
 2cd:	8b 45 08             	mov    0x8(%ebp),%eax
 2d0:	8a 00                	mov    (%eax),%al
 2d2:	3c 2e                	cmp    $0x2e,%al
 2d4:	74 0e                	je     2e4 <matchhere+0x88>
 2d6:	8b 45 08             	mov    0x8(%ebp),%eax
 2d9:	8a 10                	mov    (%eax),%dl
 2db:	8b 45 0c             	mov    0xc(%ebp),%eax
 2de:	8a 00                	mov    (%eax),%al
 2e0:	38 c2                	cmp    %al,%dl
 2e2:	75 18                	jne    2fc <matchhere+0xa0>
    return matchhere(re+1, text+1);
 2e4:	8b 45 0c             	mov    0xc(%ebp),%eax
 2e7:	8d 50 01             	lea    0x1(%eax),%edx
 2ea:	8b 45 08             	mov    0x8(%ebp),%eax
 2ed:	40                   	inc    %eax
 2ee:	89 54 24 04          	mov    %edx,0x4(%esp)
 2f2:	89 04 24             	mov    %eax,(%esp)
 2f5:	e8 62 ff ff ff       	call   25c <matchhere>
 2fa:	eb 05                	jmp    301 <matchhere+0xa5>
  return 0;
 2fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
 301:	c9                   	leave  
 302:	c3                   	ret    

00000303 <matchstar>:

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
 303:	55                   	push   %ebp
 304:	89 e5                	mov    %esp,%ebp
 306:	83 ec 18             	sub    $0x18,%esp
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
 309:	8b 45 10             	mov    0x10(%ebp),%eax
 30c:	89 44 24 04          	mov    %eax,0x4(%esp)
 310:	8b 45 0c             	mov    0xc(%ebp),%eax
 313:	89 04 24             	mov    %eax,(%esp)
 316:	e8 41 ff ff ff       	call   25c <matchhere>
 31b:	85 c0                	test   %eax,%eax
 31d:	74 07                	je     326 <matchstar+0x23>
      return 1;
 31f:	b8 01 00 00 00       	mov    $0x1,%eax
 324:	eb 29                	jmp    34f <matchstar+0x4c>
  }while(*text!='\0' && (*text++==c || c=='.'));
 326:	8b 45 10             	mov    0x10(%ebp),%eax
 329:	8a 00                	mov    (%eax),%al
 32b:	84 c0                	test   %al,%al
 32d:	74 1b                	je     34a <matchstar+0x47>
 32f:	8b 45 10             	mov    0x10(%ebp),%eax
 332:	8a 00                	mov    (%eax),%al
 334:	0f be c0             	movsbl %al,%eax
 337:	3b 45 08             	cmp    0x8(%ebp),%eax
 33a:	0f 94 c0             	sete   %al
 33d:	ff 45 10             	incl   0x10(%ebp)
 340:	84 c0                	test   %al,%al
 342:	75 c5                	jne    309 <matchstar+0x6>
 344:	83 7d 08 2e          	cmpl   $0x2e,0x8(%ebp)
 348:	74 bf                	je     309 <matchstar+0x6>
  return 0;
 34a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 34f:	c9                   	leave  
 350:	c3                   	ret    
 351:	66 90                	xchg   %ax,%ax
 353:	90                   	nop

00000354 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 354:	55                   	push   %ebp
 355:	89 e5                	mov    %esp,%ebp
 357:	57                   	push   %edi
 358:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 359:	8b 4d 08             	mov    0x8(%ebp),%ecx
 35c:	8b 55 10             	mov    0x10(%ebp),%edx
 35f:	8b 45 0c             	mov    0xc(%ebp),%eax
 362:	89 cb                	mov    %ecx,%ebx
 364:	89 df                	mov    %ebx,%edi
 366:	89 d1                	mov    %edx,%ecx
 368:	fc                   	cld    
 369:	f3 aa                	rep stos %al,%es:(%edi)
 36b:	89 ca                	mov    %ecx,%edx
 36d:	89 fb                	mov    %edi,%ebx
 36f:	89 5d 08             	mov    %ebx,0x8(%ebp)
 372:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 375:	5b                   	pop    %ebx
 376:	5f                   	pop    %edi
 377:	5d                   	pop    %ebp
 378:	c3                   	ret    

00000379 <strcpy>:
#include "x86.h"
#include "signal.h"

char*
strcpy(char *s, char *t)
{
 379:	55                   	push   %ebp
 37a:	89 e5                	mov    %esp,%ebp
 37c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 37f:	8b 45 08             	mov    0x8(%ebp),%eax
 382:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 385:	90                   	nop
 386:	8b 45 0c             	mov    0xc(%ebp),%eax
 389:	8a 10                	mov    (%eax),%dl
 38b:	8b 45 08             	mov    0x8(%ebp),%eax
 38e:	88 10                	mov    %dl,(%eax)
 390:	8b 45 08             	mov    0x8(%ebp),%eax
 393:	8a 00                	mov    (%eax),%al
 395:	84 c0                	test   %al,%al
 397:	0f 95 c0             	setne  %al
 39a:	ff 45 08             	incl   0x8(%ebp)
 39d:	ff 45 0c             	incl   0xc(%ebp)
 3a0:	84 c0                	test   %al,%al
 3a2:	75 e2                	jne    386 <strcpy+0xd>
    ;
  return os;
 3a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3a7:	c9                   	leave  
 3a8:	c3                   	ret    

000003a9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3a9:	55                   	push   %ebp
 3aa:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 3ac:	eb 06                	jmp    3b4 <strcmp+0xb>
    p++, q++;
 3ae:	ff 45 08             	incl   0x8(%ebp)
 3b1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3b4:	8b 45 08             	mov    0x8(%ebp),%eax
 3b7:	8a 00                	mov    (%eax),%al
 3b9:	84 c0                	test   %al,%al
 3bb:	74 0e                	je     3cb <strcmp+0x22>
 3bd:	8b 45 08             	mov    0x8(%ebp),%eax
 3c0:	8a 10                	mov    (%eax),%dl
 3c2:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c5:	8a 00                	mov    (%eax),%al
 3c7:	38 c2                	cmp    %al,%dl
 3c9:	74 e3                	je     3ae <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 3cb:	8b 45 08             	mov    0x8(%ebp),%eax
 3ce:	8a 00                	mov    (%eax),%al
 3d0:	0f b6 d0             	movzbl %al,%edx
 3d3:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d6:	8a 00                	mov    (%eax),%al
 3d8:	0f b6 c0             	movzbl %al,%eax
 3db:	89 d1                	mov    %edx,%ecx
 3dd:	29 c1                	sub    %eax,%ecx
 3df:	89 c8                	mov    %ecx,%eax
}
 3e1:	5d                   	pop    %ebp
 3e2:	c3                   	ret    

000003e3 <strlen>:

uint
strlen(char *s)
{
 3e3:	55                   	push   %ebp
 3e4:	89 e5                	mov    %esp,%ebp
 3e6:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3f0:	eb 03                	jmp    3f5 <strlen+0x12>
 3f2:	ff 45 fc             	incl   -0x4(%ebp)
 3f5:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3f8:	8b 45 08             	mov    0x8(%ebp),%eax
 3fb:	01 d0                	add    %edx,%eax
 3fd:	8a 00                	mov    (%eax),%al
 3ff:	84 c0                	test   %al,%al
 401:	75 ef                	jne    3f2 <strlen+0xf>
    ;
  return n;
 403:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 406:	c9                   	leave  
 407:	c3                   	ret    

00000408 <memset>:

void*
memset(void *dst, int c, uint n)
{
 408:	55                   	push   %ebp
 409:	89 e5                	mov    %esp,%ebp
 40b:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 40e:	8b 45 10             	mov    0x10(%ebp),%eax
 411:	89 44 24 08          	mov    %eax,0x8(%esp)
 415:	8b 45 0c             	mov    0xc(%ebp),%eax
 418:	89 44 24 04          	mov    %eax,0x4(%esp)
 41c:	8b 45 08             	mov    0x8(%ebp),%eax
 41f:	89 04 24             	mov    %eax,(%esp)
 422:	e8 2d ff ff ff       	call   354 <stosb>
  return dst;
 427:	8b 45 08             	mov    0x8(%ebp),%eax
}
 42a:	c9                   	leave  
 42b:	c3                   	ret    

0000042c <strchr>:

char*
strchr(const char *s, char c)
{
 42c:	55                   	push   %ebp
 42d:	89 e5                	mov    %esp,%ebp
 42f:	83 ec 04             	sub    $0x4,%esp
 432:	8b 45 0c             	mov    0xc(%ebp),%eax
 435:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 438:	eb 12                	jmp    44c <strchr+0x20>
    if(*s == c)
 43a:	8b 45 08             	mov    0x8(%ebp),%eax
 43d:	8a 00                	mov    (%eax),%al
 43f:	3a 45 fc             	cmp    -0x4(%ebp),%al
 442:	75 05                	jne    449 <strchr+0x1d>
      return (char*)s;
 444:	8b 45 08             	mov    0x8(%ebp),%eax
 447:	eb 11                	jmp    45a <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 449:	ff 45 08             	incl   0x8(%ebp)
 44c:	8b 45 08             	mov    0x8(%ebp),%eax
 44f:	8a 00                	mov    (%eax),%al
 451:	84 c0                	test   %al,%al
 453:	75 e5                	jne    43a <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 455:	b8 00 00 00 00       	mov    $0x0,%eax
}
 45a:	c9                   	leave  
 45b:	c3                   	ret    

0000045c <gets>:

char*
gets(char *buf, int max)
{
 45c:	55                   	push   %ebp
 45d:	89 e5                	mov    %esp,%ebp
 45f:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 462:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 469:	eb 42                	jmp    4ad <gets+0x51>
    cc = read(0, &c, 1);
 46b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 472:	00 
 473:	8d 45 ef             	lea    -0x11(%ebp),%eax
 476:	89 44 24 04          	mov    %eax,0x4(%esp)
 47a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 481:	e8 62 01 00 00       	call   5e8 <read>
 486:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 489:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 48d:	7e 29                	jle    4b8 <gets+0x5c>
      break;
    buf[i++] = c;
 48f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 492:	8b 45 08             	mov    0x8(%ebp),%eax
 495:	01 c2                	add    %eax,%edx
 497:	8a 45 ef             	mov    -0x11(%ebp),%al
 49a:	88 02                	mov    %al,(%edx)
 49c:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 49f:	8a 45 ef             	mov    -0x11(%ebp),%al
 4a2:	3c 0a                	cmp    $0xa,%al
 4a4:	74 13                	je     4b9 <gets+0x5d>
 4a6:	8a 45 ef             	mov    -0x11(%ebp),%al
 4a9:	3c 0d                	cmp    $0xd,%al
 4ab:	74 0c                	je     4b9 <gets+0x5d>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4b0:	40                   	inc    %eax
 4b1:	3b 45 0c             	cmp    0xc(%ebp),%eax
 4b4:	7c b5                	jl     46b <gets+0xf>
 4b6:	eb 01                	jmp    4b9 <gets+0x5d>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 4b8:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 4b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4bc:	8b 45 08             	mov    0x8(%ebp),%eax
 4bf:	01 d0                	add    %edx,%eax
 4c1:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 4c4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4c7:	c9                   	leave  
 4c8:	c3                   	ret    

000004c9 <stat>:

int
stat(char *n, struct stat *st)
{
 4c9:	55                   	push   %ebp
 4ca:	89 e5                	mov    %esp,%ebp
 4cc:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4cf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 4d6:	00 
 4d7:	8b 45 08             	mov    0x8(%ebp),%eax
 4da:	89 04 24             	mov    %eax,(%esp)
 4dd:	e8 2e 01 00 00       	call   610 <open>
 4e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 4e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4e9:	79 07                	jns    4f2 <stat+0x29>
    return -1;
 4eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4f0:	eb 23                	jmp    515 <stat+0x4c>
  r = fstat(fd, st);
 4f2:	8b 45 0c             	mov    0xc(%ebp),%eax
 4f5:	89 44 24 04          	mov    %eax,0x4(%esp)
 4f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4fc:	89 04 24             	mov    %eax,(%esp)
 4ff:	e8 24 01 00 00       	call   628 <fstat>
 504:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 507:	8b 45 f4             	mov    -0xc(%ebp),%eax
 50a:	89 04 24             	mov    %eax,(%esp)
 50d:	e8 e6 00 00 00       	call   5f8 <close>
  return r;
 512:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 515:	c9                   	leave  
 516:	c3                   	ret    

00000517 <atoi>:

int
atoi(const char *s)
{
 517:	55                   	push   %ebp
 518:	89 e5                	mov    %esp,%ebp
 51a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 51d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 524:	eb 21                	jmp    547 <atoi+0x30>
    n = n*10 + *s++ - '0';
 526:	8b 55 fc             	mov    -0x4(%ebp),%edx
 529:	89 d0                	mov    %edx,%eax
 52b:	c1 e0 02             	shl    $0x2,%eax
 52e:	01 d0                	add    %edx,%eax
 530:	d1 e0                	shl    %eax
 532:	89 c2                	mov    %eax,%edx
 534:	8b 45 08             	mov    0x8(%ebp),%eax
 537:	8a 00                	mov    (%eax),%al
 539:	0f be c0             	movsbl %al,%eax
 53c:	01 d0                	add    %edx,%eax
 53e:	83 e8 30             	sub    $0x30,%eax
 541:	89 45 fc             	mov    %eax,-0x4(%ebp)
 544:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 547:	8b 45 08             	mov    0x8(%ebp),%eax
 54a:	8a 00                	mov    (%eax),%al
 54c:	3c 2f                	cmp    $0x2f,%al
 54e:	7e 09                	jle    559 <atoi+0x42>
 550:	8b 45 08             	mov    0x8(%ebp),%eax
 553:	8a 00                	mov    (%eax),%al
 555:	3c 39                	cmp    $0x39,%al
 557:	7e cd                	jle    526 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 559:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 55c:	c9                   	leave  
 55d:	c3                   	ret    

0000055e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 55e:	55                   	push   %ebp
 55f:	89 e5                	mov    %esp,%ebp
 561:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 564:	8b 45 08             	mov    0x8(%ebp),%eax
 567:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 56a:	8b 45 0c             	mov    0xc(%ebp),%eax
 56d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 570:	eb 10                	jmp    582 <memmove+0x24>
    *dst++ = *src++;
 572:	8b 45 f8             	mov    -0x8(%ebp),%eax
 575:	8a 10                	mov    (%eax),%dl
 577:	8b 45 fc             	mov    -0x4(%ebp),%eax
 57a:	88 10                	mov    %dl,(%eax)
 57c:	ff 45 fc             	incl   -0x4(%ebp)
 57f:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 582:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 586:	0f 9f c0             	setg   %al
 589:	ff 4d 10             	decl   0x10(%ebp)
 58c:	84 c0                	test   %al,%al
 58e:	75 e2                	jne    572 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 590:	8b 45 08             	mov    0x8(%ebp),%eax
}
 593:	c9                   	leave  
 594:	c3                   	ret    

00000595 <trampoline>:
 595:	5a                   	pop    %edx
 596:	59                   	pop    %ecx
 597:	58                   	pop    %eax
 598:	03 25 04 00 00 00    	add    0x4,%esp
 59e:	c9                   	leave  
 59f:	c3                   	ret    

000005a0 <signal>:
	"addl 4, %esp\n\t"
	"leave\n\t"
	"ret\n\t"
);
int signal(int signum, sighandler_t handler) 
{
 5a0:	55                   	push   %ebp
 5a1:	89 e5                	mov    %esp,%ebp
 5a3:	83 ec 18             	sub    $0x18,%esp
	register_signal_handler(signum, handler, trampoline);
 5a6:	c7 44 24 08 95 05 00 	movl   $0x595,0x8(%esp)
 5ad:	00 
 5ae:	8b 45 0c             	mov    0xc(%ebp),%eax
 5b1:	89 44 24 04          	mov    %eax,0x4(%esp)
 5b5:	8b 45 08             	mov    0x8(%ebp),%eax
 5b8:	89 04 24             	mov    %eax,(%esp)
 5bb:	e8 b8 00 00 00       	call   678 <register_signal_handler>
	return 0;
 5c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
 5c5:	c9                   	leave  
 5c6:	c3                   	ret    
 5c7:	90                   	nop

000005c8 <fork>:
 5c8:	b8 01 00 00 00       	mov    $0x1,%eax
 5cd:	cd 40                	int    $0x40
 5cf:	c3                   	ret    

000005d0 <exit>:
 5d0:	b8 02 00 00 00       	mov    $0x2,%eax
 5d5:	cd 40                	int    $0x40
 5d7:	c3                   	ret    

000005d8 <wait>:
 5d8:	b8 03 00 00 00       	mov    $0x3,%eax
 5dd:	cd 40                	int    $0x40
 5df:	c3                   	ret    

000005e0 <pipe>:
 5e0:	b8 04 00 00 00       	mov    $0x4,%eax
 5e5:	cd 40                	int    $0x40
 5e7:	c3                   	ret    

000005e8 <read>:
 5e8:	b8 05 00 00 00       	mov    $0x5,%eax
 5ed:	cd 40                	int    $0x40
 5ef:	c3                   	ret    

000005f0 <write>:
 5f0:	b8 10 00 00 00       	mov    $0x10,%eax
 5f5:	cd 40                	int    $0x40
 5f7:	c3                   	ret    

000005f8 <close>:
 5f8:	b8 15 00 00 00       	mov    $0x15,%eax
 5fd:	cd 40                	int    $0x40
 5ff:	c3                   	ret    

00000600 <kill>:
 600:	b8 06 00 00 00       	mov    $0x6,%eax
 605:	cd 40                	int    $0x40
 607:	c3                   	ret    

00000608 <exec>:
 608:	b8 07 00 00 00       	mov    $0x7,%eax
 60d:	cd 40                	int    $0x40
 60f:	c3                   	ret    

00000610 <open>:
 610:	b8 0f 00 00 00       	mov    $0xf,%eax
 615:	cd 40                	int    $0x40
 617:	c3                   	ret    

00000618 <mknod>:
 618:	b8 11 00 00 00       	mov    $0x11,%eax
 61d:	cd 40                	int    $0x40
 61f:	c3                   	ret    

00000620 <unlink>:
 620:	b8 12 00 00 00       	mov    $0x12,%eax
 625:	cd 40                	int    $0x40
 627:	c3                   	ret    

00000628 <fstat>:
 628:	b8 08 00 00 00       	mov    $0x8,%eax
 62d:	cd 40                	int    $0x40
 62f:	c3                   	ret    

00000630 <link>:
 630:	b8 13 00 00 00       	mov    $0x13,%eax
 635:	cd 40                	int    $0x40
 637:	c3                   	ret    

00000638 <mkdir>:
 638:	b8 14 00 00 00       	mov    $0x14,%eax
 63d:	cd 40                	int    $0x40
 63f:	c3                   	ret    

00000640 <chdir>:
 640:	b8 09 00 00 00       	mov    $0x9,%eax
 645:	cd 40                	int    $0x40
 647:	c3                   	ret    

00000648 <dup>:
 648:	b8 0a 00 00 00       	mov    $0xa,%eax
 64d:	cd 40                	int    $0x40
 64f:	c3                   	ret    

00000650 <getpid>:
 650:	b8 0b 00 00 00       	mov    $0xb,%eax
 655:	cd 40                	int    $0x40
 657:	c3                   	ret    

00000658 <sbrk>:
 658:	b8 0c 00 00 00       	mov    $0xc,%eax
 65d:	cd 40                	int    $0x40
 65f:	c3                   	ret    

00000660 <sleep>:
 660:	b8 0d 00 00 00       	mov    $0xd,%eax
 665:	cd 40                	int    $0x40
 667:	c3                   	ret    

00000668 <uptime>:
 668:	b8 0e 00 00 00       	mov    $0xe,%eax
 66d:	cd 40                	int    $0x40
 66f:	c3                   	ret    

00000670 <halt>:
 670:	b8 16 00 00 00       	mov    $0x16,%eax
 675:	cd 40                	int    $0x40
 677:	c3                   	ret    

00000678 <register_signal_handler>:
 678:	b8 17 00 00 00       	mov    $0x17,%eax
 67d:	cd 40                	int    $0x40
 67f:	c3                   	ret    

00000680 <alarm>:
 680:	b8 18 00 00 00       	mov    $0x18,%eax
 685:	cd 40                	int    $0x40
 687:	c3                   	ret    

00000688 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 688:	55                   	push   %ebp
 689:	89 e5                	mov    %esp,%ebp
 68b:	83 ec 28             	sub    $0x28,%esp
 68e:	8b 45 0c             	mov    0xc(%ebp),%eax
 691:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 694:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 69b:	00 
 69c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 69f:	89 44 24 04          	mov    %eax,0x4(%esp)
 6a3:	8b 45 08             	mov    0x8(%ebp),%eax
 6a6:	89 04 24             	mov    %eax,(%esp)
 6a9:	e8 42 ff ff ff       	call   5f0 <write>
}
 6ae:	c9                   	leave  
 6af:	c3                   	ret    

000006b0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6b0:	55                   	push   %ebp
 6b1:	89 e5                	mov    %esp,%ebp
 6b3:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 6b6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 6bd:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 6c1:	74 17                	je     6da <printint+0x2a>
 6c3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 6c7:	79 11                	jns    6da <printint+0x2a>
    neg = 1;
 6c9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 6d0:	8b 45 0c             	mov    0xc(%ebp),%eax
 6d3:	f7 d8                	neg    %eax
 6d5:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6d8:	eb 06                	jmp    6e0 <printint+0x30>
  } else {
    x = xx;
 6da:	8b 45 0c             	mov    0xc(%ebp),%eax
 6dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 6e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 6e7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 6ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6ed:	ba 00 00 00 00       	mov    $0x0,%edx
 6f2:	f7 f1                	div    %ecx
 6f4:	89 d0                	mov    %edx,%eax
 6f6:	8a 80 44 0e 00 00    	mov    0xe44(%eax),%al
 6fc:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 6ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
 702:	01 ca                	add    %ecx,%edx
 704:	88 02                	mov    %al,(%edx)
 706:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 709:	8b 55 10             	mov    0x10(%ebp),%edx
 70c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 70f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 712:	ba 00 00 00 00       	mov    $0x0,%edx
 717:	f7 75 d4             	divl   -0x2c(%ebp)
 71a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 71d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 721:	75 c4                	jne    6e7 <printint+0x37>
  if(neg)
 723:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 727:	74 2c                	je     755 <printint+0xa5>
    buf[i++] = '-';
 729:	8d 55 dc             	lea    -0x24(%ebp),%edx
 72c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 72f:	01 d0                	add    %edx,%eax
 731:	c6 00 2d             	movb   $0x2d,(%eax)
 734:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 737:	eb 1c                	jmp    755 <printint+0xa5>
    putc(fd, buf[i]);
 739:	8d 55 dc             	lea    -0x24(%ebp),%edx
 73c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 73f:	01 d0                	add    %edx,%eax
 741:	8a 00                	mov    (%eax),%al
 743:	0f be c0             	movsbl %al,%eax
 746:	89 44 24 04          	mov    %eax,0x4(%esp)
 74a:	8b 45 08             	mov    0x8(%ebp),%eax
 74d:	89 04 24             	mov    %eax,(%esp)
 750:	e8 33 ff ff ff       	call   688 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 755:	ff 4d f4             	decl   -0xc(%ebp)
 758:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 75c:	79 db                	jns    739 <printint+0x89>
    putc(fd, buf[i]);
}
 75e:	c9                   	leave  
 75f:	c3                   	ret    

00000760 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 760:	55                   	push   %ebp
 761:	89 e5                	mov    %esp,%ebp
 763:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 766:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 76d:	8d 45 0c             	lea    0xc(%ebp),%eax
 770:	83 c0 04             	add    $0x4,%eax
 773:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 776:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 77d:	e9 78 01 00 00       	jmp    8fa <printf+0x19a>
    c = fmt[i] & 0xff;
 782:	8b 55 0c             	mov    0xc(%ebp),%edx
 785:	8b 45 f0             	mov    -0x10(%ebp),%eax
 788:	01 d0                	add    %edx,%eax
 78a:	8a 00                	mov    (%eax),%al
 78c:	0f be c0             	movsbl %al,%eax
 78f:	25 ff 00 00 00       	and    $0xff,%eax
 794:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 797:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 79b:	75 2c                	jne    7c9 <printf+0x69>
      if(c == '%'){
 79d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7a1:	75 0c                	jne    7af <printf+0x4f>
        state = '%';
 7a3:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 7aa:	e9 48 01 00 00       	jmp    8f7 <printf+0x197>
      } else {
        putc(fd, c);
 7af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7b2:	0f be c0             	movsbl %al,%eax
 7b5:	89 44 24 04          	mov    %eax,0x4(%esp)
 7b9:	8b 45 08             	mov    0x8(%ebp),%eax
 7bc:	89 04 24             	mov    %eax,(%esp)
 7bf:	e8 c4 fe ff ff       	call   688 <putc>
 7c4:	e9 2e 01 00 00       	jmp    8f7 <printf+0x197>
      }
    } else if(state == '%'){
 7c9:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 7cd:	0f 85 24 01 00 00    	jne    8f7 <printf+0x197>
      if(c == 'd'){
 7d3:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 7d7:	75 2d                	jne    806 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 7d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7dc:	8b 00                	mov    (%eax),%eax
 7de:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 7e5:	00 
 7e6:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 7ed:	00 
 7ee:	89 44 24 04          	mov    %eax,0x4(%esp)
 7f2:	8b 45 08             	mov    0x8(%ebp),%eax
 7f5:	89 04 24             	mov    %eax,(%esp)
 7f8:	e8 b3 fe ff ff       	call   6b0 <printint>
        ap++;
 7fd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 801:	e9 ea 00 00 00       	jmp    8f0 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 806:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 80a:	74 06                	je     812 <printf+0xb2>
 80c:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 810:	75 2d                	jne    83f <printf+0xdf>
        printint(fd, *ap, 16, 0);
 812:	8b 45 e8             	mov    -0x18(%ebp),%eax
 815:	8b 00                	mov    (%eax),%eax
 817:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 81e:	00 
 81f:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 826:	00 
 827:	89 44 24 04          	mov    %eax,0x4(%esp)
 82b:	8b 45 08             	mov    0x8(%ebp),%eax
 82e:	89 04 24             	mov    %eax,(%esp)
 831:	e8 7a fe ff ff       	call   6b0 <printint>
        ap++;
 836:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 83a:	e9 b1 00 00 00       	jmp    8f0 <printf+0x190>
      } else if(c == 's'){
 83f:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 843:	75 43                	jne    888 <printf+0x128>
        s = (char*)*ap;
 845:	8b 45 e8             	mov    -0x18(%ebp),%eax
 848:	8b 00                	mov    (%eax),%eax
 84a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 84d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 851:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 855:	75 25                	jne    87c <printf+0x11c>
          s = "(null)";
 857:	c7 45 f4 5e 0b 00 00 	movl   $0xb5e,-0xc(%ebp)
        while(*s != 0){
 85e:	eb 1c                	jmp    87c <printf+0x11c>
          putc(fd, *s);
 860:	8b 45 f4             	mov    -0xc(%ebp),%eax
 863:	8a 00                	mov    (%eax),%al
 865:	0f be c0             	movsbl %al,%eax
 868:	89 44 24 04          	mov    %eax,0x4(%esp)
 86c:	8b 45 08             	mov    0x8(%ebp),%eax
 86f:	89 04 24             	mov    %eax,(%esp)
 872:	e8 11 fe ff ff       	call   688 <putc>
          s++;
 877:	ff 45 f4             	incl   -0xc(%ebp)
 87a:	eb 01                	jmp    87d <printf+0x11d>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 87c:	90                   	nop
 87d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 880:	8a 00                	mov    (%eax),%al
 882:	84 c0                	test   %al,%al
 884:	75 da                	jne    860 <printf+0x100>
 886:	eb 68                	jmp    8f0 <printf+0x190>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 888:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 88c:	75 1d                	jne    8ab <printf+0x14b>
        putc(fd, *ap);
 88e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 891:	8b 00                	mov    (%eax),%eax
 893:	0f be c0             	movsbl %al,%eax
 896:	89 44 24 04          	mov    %eax,0x4(%esp)
 89a:	8b 45 08             	mov    0x8(%ebp),%eax
 89d:	89 04 24             	mov    %eax,(%esp)
 8a0:	e8 e3 fd ff ff       	call   688 <putc>
        ap++;
 8a5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8a9:	eb 45                	jmp    8f0 <printf+0x190>
      } else if(c == '%'){
 8ab:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 8af:	75 17                	jne    8c8 <printf+0x168>
        putc(fd, c);
 8b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8b4:	0f be c0             	movsbl %al,%eax
 8b7:	89 44 24 04          	mov    %eax,0x4(%esp)
 8bb:	8b 45 08             	mov    0x8(%ebp),%eax
 8be:	89 04 24             	mov    %eax,(%esp)
 8c1:	e8 c2 fd ff ff       	call   688 <putc>
 8c6:	eb 28                	jmp    8f0 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 8c8:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 8cf:	00 
 8d0:	8b 45 08             	mov    0x8(%ebp),%eax
 8d3:	89 04 24             	mov    %eax,(%esp)
 8d6:	e8 ad fd ff ff       	call   688 <putc>
        putc(fd, c);
 8db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8de:	0f be c0             	movsbl %al,%eax
 8e1:	89 44 24 04          	mov    %eax,0x4(%esp)
 8e5:	8b 45 08             	mov    0x8(%ebp),%eax
 8e8:	89 04 24             	mov    %eax,(%esp)
 8eb:	e8 98 fd ff ff       	call   688 <putc>
      }
      state = 0;
 8f0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 8f7:	ff 45 f0             	incl   -0x10(%ebp)
 8fa:	8b 55 0c             	mov    0xc(%ebp),%edx
 8fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 900:	01 d0                	add    %edx,%eax
 902:	8a 00                	mov    (%eax),%al
 904:	84 c0                	test   %al,%al
 906:	0f 85 76 fe ff ff    	jne    782 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 90c:	c9                   	leave  
 90d:	c3                   	ret    
 90e:	66 90                	xchg   %ax,%ax

00000910 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 910:	55                   	push   %ebp
 911:	89 e5                	mov    %esp,%ebp
 913:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 916:	8b 45 08             	mov    0x8(%ebp),%eax
 919:	83 e8 08             	sub    $0x8,%eax
 91c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 91f:	a1 68 0e 00 00       	mov    0xe68,%eax
 924:	89 45 fc             	mov    %eax,-0x4(%ebp)
 927:	eb 24                	jmp    94d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 929:	8b 45 fc             	mov    -0x4(%ebp),%eax
 92c:	8b 00                	mov    (%eax),%eax
 92e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 931:	77 12                	ja     945 <free+0x35>
 933:	8b 45 f8             	mov    -0x8(%ebp),%eax
 936:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 939:	77 24                	ja     95f <free+0x4f>
 93b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 93e:	8b 00                	mov    (%eax),%eax
 940:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 943:	77 1a                	ja     95f <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 945:	8b 45 fc             	mov    -0x4(%ebp),%eax
 948:	8b 00                	mov    (%eax),%eax
 94a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 94d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 950:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 953:	76 d4                	jbe    929 <free+0x19>
 955:	8b 45 fc             	mov    -0x4(%ebp),%eax
 958:	8b 00                	mov    (%eax),%eax
 95a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 95d:	76 ca                	jbe    929 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 95f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 962:	8b 40 04             	mov    0x4(%eax),%eax
 965:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 96c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 96f:	01 c2                	add    %eax,%edx
 971:	8b 45 fc             	mov    -0x4(%ebp),%eax
 974:	8b 00                	mov    (%eax),%eax
 976:	39 c2                	cmp    %eax,%edx
 978:	75 24                	jne    99e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 97a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 97d:	8b 50 04             	mov    0x4(%eax),%edx
 980:	8b 45 fc             	mov    -0x4(%ebp),%eax
 983:	8b 00                	mov    (%eax),%eax
 985:	8b 40 04             	mov    0x4(%eax),%eax
 988:	01 c2                	add    %eax,%edx
 98a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 98d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 990:	8b 45 fc             	mov    -0x4(%ebp),%eax
 993:	8b 00                	mov    (%eax),%eax
 995:	8b 10                	mov    (%eax),%edx
 997:	8b 45 f8             	mov    -0x8(%ebp),%eax
 99a:	89 10                	mov    %edx,(%eax)
 99c:	eb 0a                	jmp    9a8 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 99e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9a1:	8b 10                	mov    (%eax),%edx
 9a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9a6:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 9a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ab:	8b 40 04             	mov    0x4(%eax),%eax
 9ae:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 9b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b8:	01 d0                	add    %edx,%eax
 9ba:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9bd:	75 20                	jne    9df <free+0xcf>
    p->s.size += bp->s.size;
 9bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9c2:	8b 50 04             	mov    0x4(%eax),%edx
 9c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9c8:	8b 40 04             	mov    0x4(%eax),%eax
 9cb:	01 c2                	add    %eax,%edx
 9cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9d0:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9d6:	8b 10                	mov    (%eax),%edx
 9d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9db:	89 10                	mov    %edx,(%eax)
 9dd:	eb 08                	jmp    9e7 <free+0xd7>
  } else
    p->s.ptr = bp;
 9df:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9e2:	8b 55 f8             	mov    -0x8(%ebp),%edx
 9e5:	89 10                	mov    %edx,(%eax)
  freep = p;
 9e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ea:	a3 68 0e 00 00       	mov    %eax,0xe68
}
 9ef:	c9                   	leave  
 9f0:	c3                   	ret    

000009f1 <morecore>:

static Header*
morecore(uint nu)
{
 9f1:	55                   	push   %ebp
 9f2:	89 e5                	mov    %esp,%ebp
 9f4:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 9f7:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 9fe:	77 07                	ja     a07 <morecore+0x16>
    nu = 4096;
 a00:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 a07:	8b 45 08             	mov    0x8(%ebp),%eax
 a0a:	c1 e0 03             	shl    $0x3,%eax
 a0d:	89 04 24             	mov    %eax,(%esp)
 a10:	e8 43 fc ff ff       	call   658 <sbrk>
 a15:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 a18:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 a1c:	75 07                	jne    a25 <morecore+0x34>
    return 0;
 a1e:	b8 00 00 00 00       	mov    $0x0,%eax
 a23:	eb 22                	jmp    a47 <morecore+0x56>
  hp = (Header*)p;
 a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a28:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 a2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a2e:	8b 55 08             	mov    0x8(%ebp),%edx
 a31:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 a34:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a37:	83 c0 08             	add    $0x8,%eax
 a3a:	89 04 24             	mov    %eax,(%esp)
 a3d:	e8 ce fe ff ff       	call   910 <free>
  return freep;
 a42:	a1 68 0e 00 00       	mov    0xe68,%eax
}
 a47:	c9                   	leave  
 a48:	c3                   	ret    

00000a49 <malloc>:

void*
malloc(uint nbytes)
{
 a49:	55                   	push   %ebp
 a4a:	89 e5                	mov    %esp,%ebp
 a4c:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a4f:	8b 45 08             	mov    0x8(%ebp),%eax
 a52:	83 c0 07             	add    $0x7,%eax
 a55:	c1 e8 03             	shr    $0x3,%eax
 a58:	40                   	inc    %eax
 a59:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a5c:	a1 68 0e 00 00       	mov    0xe68,%eax
 a61:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a64:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a68:	75 23                	jne    a8d <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 a6a:	c7 45 f0 60 0e 00 00 	movl   $0xe60,-0x10(%ebp)
 a71:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a74:	a3 68 0e 00 00       	mov    %eax,0xe68
 a79:	a1 68 0e 00 00       	mov    0xe68,%eax
 a7e:	a3 60 0e 00 00       	mov    %eax,0xe60
    base.s.size = 0;
 a83:	c7 05 64 0e 00 00 00 	movl   $0x0,0xe64
 a8a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a90:	8b 00                	mov    (%eax),%eax
 a92:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a95:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a98:	8b 40 04             	mov    0x4(%eax),%eax
 a9b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a9e:	72 4d                	jb     aed <malloc+0xa4>
      if(p->s.size == nunits)
 aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aa3:	8b 40 04             	mov    0x4(%eax),%eax
 aa6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 aa9:	75 0c                	jne    ab7 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aae:	8b 10                	mov    (%eax),%edx
 ab0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ab3:	89 10                	mov    %edx,(%eax)
 ab5:	eb 26                	jmp    add <malloc+0x94>
      else {
        p->s.size -= nunits;
 ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aba:	8b 40 04             	mov    0x4(%eax),%eax
 abd:	89 c2                	mov    %eax,%edx
 abf:	2b 55 ec             	sub    -0x14(%ebp),%edx
 ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ac5:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 ac8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 acb:	8b 40 04             	mov    0x4(%eax),%eax
 ace:	c1 e0 03             	shl    $0x3,%eax
 ad1:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ad7:	8b 55 ec             	mov    -0x14(%ebp),%edx
 ada:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 add:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ae0:	a3 68 0e 00 00       	mov    %eax,0xe68
      return (void*)(p + 1);
 ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ae8:	83 c0 08             	add    $0x8,%eax
 aeb:	eb 38                	jmp    b25 <malloc+0xdc>
    }
    if(p == freep)
 aed:	a1 68 0e 00 00       	mov    0xe68,%eax
 af2:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 af5:	75 1b                	jne    b12 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 af7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 afa:	89 04 24             	mov    %eax,(%esp)
 afd:	e8 ef fe ff ff       	call   9f1 <morecore>
 b02:	89 45 f4             	mov    %eax,-0xc(%ebp)
 b05:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b09:	75 07                	jne    b12 <malloc+0xc9>
        return 0;
 b0b:	b8 00 00 00 00       	mov    $0x0,%eax
 b10:	eb 13                	jmp    b25 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b15:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b1b:	8b 00                	mov    (%eax),%eax
 b1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 b20:	e9 70 ff ff ff       	jmp    a95 <malloc+0x4c>
}
 b25:	c9                   	leave  
 b26:	c3                   	ret    
