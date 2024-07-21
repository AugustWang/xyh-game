
//������Ϣ
struct mountInfo
{
	int8   mountDataID;    //��������ID
	int8   level;          //����ȼ�
	int8   equiped;        //�����Ƿ�װ��,=0��ʾû��װ����!=0��ʾװ��
	int8   progress;      //���ﵱǰ��������
	int	benison_Value; // ���ﵱǰף��ֵ
};

//��ҵ�һ�δ�����UI����������Ϣ
struct U2GS_QueryMyMountInfo->
{
	int8	reserve;
};

//��ҵ�һ�δ�����UI����������Ϣ���ظ�
struct GS2U_QueryMyMountInfoResult<-
{
	vector<mountInfo> mounts; 
};

//������������������
struct GS2U_MountInfoUpdate<-
{
	mountInfo mounts;
};

//������������Ϣ
struct GS2U_MountOPResult<-
{
	int8  mountDataID;    //��������ID
	int	  result;		  //�����
};

//װ��������
struct U2GS_MountEquipRequest->
{
	int8  mountDataID;    //��������ID
};

//ȡ��װ��������
struct U2GS_Cancel_MountEquipRequest->
{
	int8	reserve;
};

//��������
struct U2GS_MountUpRequest->
{
	int8 reserve;
};

//ĳ�������
struct GS2U_MountUp<-
{
	int64	actorID;	//�������ID
	int8	mount_data_id;	//�������ID
};

//��������
struct U2GS_MountDownRequest->
{
	int8 reserve;
};

//ĳ�������
struct GS2U_MountDown<-
{
	int64	actorID;	//�������ID
};

//ι���������
struct U2GS_LevelUpRequest->
{
	int8  mountDataID;    //��������ID
	int8  isAuto;		 //�Ƿ��Զ���=0����!=0Ҫ
};

