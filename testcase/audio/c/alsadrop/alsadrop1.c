//alsadrop1 testcase
// compile with 
//gcc -oalsadrop1 -lasound -lpthread -g alsadrop1.c

#include <alsa/asoundlib.h>
#include <pthread.h>
#include <sys/time.h>
#define samplefrequ 44100

int16_t bufa[samplefrequ]; //1 second f1
int16_t bufb[samplefrequ]; //1 second f2
pthread_cond_t cond = PTHREAD_COND_INITIALIZER;
pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
void* buf;
snd_pcm_t *pcm;

void*
threadexe(void* param){
 snd_pcm_sframes_t frameswritten;
 int i1,i2,i3;
 void* buf1;

 i1 = sizeof(bufa)/sizeof(bufa[0]);
 frameswritten = 0;
 i3 = 0;
 while (1){
  pthread_mutex_lock(&mutex);
  printf("++waitstart\n");
  pthread_cond_wait(&cond,&mutex);
  printf("!!signaled\n");
  buf1 = buf;
  pthread_mutex_unlock(&mutex);
  frameswritten = snd_pcm_writei(pcm,buf1,i1);
  printf("%d %p %d\n",i3,buf1,frameswritten);
  i3++;
 } 
 return NULL;
}

int main()
{
 int i1,i2;
 char* dev;
 snd_pcm_hw_params_t *params = NULL;
 unsigned int rate = samplefrequ;
 snd_pcm_sframes_t frameswritten;
 pthread_t thread;
 struct timeval t1,t2;

 for(i1=0;i1 < samplefrequ;i1++){
  bufa[i1] = 0x4000 * (2*((i1 / 40) % 2)-1);
  bufb[i1] = 0x4000 * (2*((i1 / 41) % 2)-1);
 }

 dev = "sysdefault"; //alsa direct      ->> overlapping sound
// dev = "default";  //over pulsaudio   ->> OK
 if (snd_pcm_open(&pcm,dev, SND_PCM_STREAM_PLAYBACK, 0)){
  printf("Can not open pcm %s",dev);
  goto error;
 }
 snd_pcm_hw_params_malloc(&params);
 if (!params){
  goto error;
 };
 if (snd_pcm_hw_params_any(pcm, params)<0){
  goto error;
 };
 if (snd_pcm_hw_params_set_access(pcm,params,SND_PCM_ACCESS_RW_INTERLEAVED)){
  goto error;
 };
 if (snd_pcm_hw_params_set_format(pcm,params,SND_PCM_FORMAT_S16_LE)){
  goto error;
 };
 if (snd_pcm_hw_params_set_rate_near(pcm,params,&rate,0)){
  goto error;
 };
 if (snd_pcm_hw_params_set_channels(pcm,params,1)){
  goto error;
 };
 if (snd_pcm_hw_params(pcm,params)){
  goto error;
 };
 if (snd_pcm_prepare(pcm)){
  goto error;
 };
 snd_pcm_nonblock(pcm,0);
 mutex.__data.__kind = PTHREAD_MUTEX_RECURSIVE; 
 
 if (pthread_create(&thread,NULL,&threadexe,NULL)){
  goto error;
 }
 while(1){
  pthread_mutex_lock(&mutex);
  if (buf == bufa){
   buf = bufb;
  }
  else{
   buf = bufa;
  }
  gettimeofday(&t1,NULL);
  pthread_mutex_unlock(&mutex);
  printf("--- %p signal\n",buf);
  pthread_cond_signal(&cond);
  usleep(700000);
  printf("<<<drop\n");
  snd_pcm_drop(pcm);
  snd_pcm_drain(pcm);
  gettimeofday(&t2,NULL);
  printf("<<<drain %ims\n",(t2.tv_sec-t1.tv_sec)*1000+
                            (t2.tv_usec-t1.tv_usec)/1000);
  i2 = snd_pcm_prepare(pcm);
  printf("<<<prepare %d\n",i2);
 }
 return 0;
error:
 return 1;
}