//
//  CoreWrapperC.c
//  CloudOnMobile
//

#include "CoreWrapperC.h"
#include "TcpClient/TcpClient.h"

extern void coreDidDownlodFile(const char*);

void set_shared_core_callbacks(void){
  callback_did_download_file_funptr = coreDidDownlodFile;
}
