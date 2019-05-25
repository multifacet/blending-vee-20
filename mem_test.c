#include<stdlib.h>
#include<stdio.h>
int main (int argc, char **argv[]){
	char *data;
	int bytes = (1024*1024);
	data = (char *) malloc(bytes);
    printf("%ld\n", sizeof(data));
	for(int i=0;i<bytes;i++){
		data[i] = 'h';
		//printf("%c",data[i]);
	}

	free(data);

	return 0;
}
