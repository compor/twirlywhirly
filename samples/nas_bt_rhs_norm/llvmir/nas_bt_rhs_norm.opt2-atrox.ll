; ModuleID = 'nas_bt_rhs_norm.opt2.ll'
source_filename = "nas_bt_rhs_norm.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }

@grid_points = common dso_local global [3 x i32] zeroinitializer, align 4
@rhs = common dso_local local_unnamed_addr global [102 x [103 x [103 x [5 x double]]]] zeroinitializer, align 16
@.str.1 = private unnamed_addr constant [13 x i8] c"inputbt.data\00", align 1
@.str.2 = private unnamed_addr constant [2 x i8] c"r\00", align 1
@.str.4 = private unnamed_addr constant [8 x i8] c"%d%d%d\0A\00", align 1
@.str.6 = private unnamed_addr constant [20 x i8] c" Size: %4dx%4dx%4d\0A\00", align 1
@str = private unnamed_addr constant [58 x i8] c"\0A\0A NAS Parallel Benchmarks (NPB3.3-SER-C) - BT Benchmark\0A\00"
@str.8 = private unnamed_addr constant [53 x i8] c" No input file inputbt.data. Using compiled defaults\00"
@str.9 = private unnamed_addr constant [38 x i8] c" Reading from input file inputbt.data\00"

; Function Attrs: nounwind uwtable
define dso_local void @rhs_norm(double* nocapture %rms) local_unnamed_addr #0 !dbg !7 {
entry:
  %rms126 = bitcast double* %rms to i8*
  call void @llvm.memset.p0i8.i64(i8* align 8 %rms126, i8 0, i64 40, i1 false), !dbg !9
  %0 = load i32, i32* getelementptr inbounds ([3 x i32], [3 x i32]* @grid_points, i64 0, i64 2), align 4, !dbg !10, !tbaa !11
  %cmp2105 = icmp slt i32 %0, 3, !dbg !15
  br i1 %cmp2105, label %for.cond43.preheader.preheader, label %for.cond4.preheader.lr.ph, !dbg !16

for.cond4.preheader.lr.ph:                        ; preds = %entry
  %1 = load i32, i32* getelementptr inbounds ([3 x i32], [3 x i32]* @grid_points, i64 0, i64 1), align 4
  %cmp6102 = icmp slt i32 %1, 3
  %sub = add nsw i32 %0, -2
  %2 = load i32, i32* getelementptr inbounds ([3 x i32], [3 x i32]* @grid_points, i64 0, i64 0), align 4
  %cmp1099 = icmp slt i32 %2, 3
  %3 = add i32 %2, -1, !dbg !16
  %4 = add i32 %1, -1, !dbg !16
  %5 = sext i32 %sub to i64, !dbg !16
  %wide.trip.count119 = zext i32 %4 to i64
  %wide.trip.count = zext i32 %3 to i64
  br label %for.cond4.preheader, !dbg !16

for.cond4.preheader:                              ; preds = %for.inc37, %for.cond4.preheader.lr.ph
  %indvars.iv121 = phi i64 [ %indvars.iv.next122, %for.inc37 ], [ 1, %for.cond4.preheader.lr.ph ]
  br label %for.cond4.preheader.split, !dbg !17

for.cond4.preheader.split:                        ; preds = %for.cond4.preheader
  br i1 %cmp6102, label %for.inc37, label %for.cond8.preheader, !dbg !17

for.cond8.preheader:                              ; preds = %for.inc34, %for.cond4.preheader.split
  %indvars.iv117 = phi i64 [ %indvars.iv.next118, %for.inc34 ], [ 1, %for.cond4.preheader.split ]
  br label %for.cond8.preheader.split, !dbg !18

for.cond8.preheader.split:                        ; preds = %for.cond8.preheader
  br i1 %cmp1099, label %for.inc34, label %for.cond12.preheader, !dbg !18

for.cond12.preheader:                             ; preds = %for.inc31, %for.cond8.preheader.split
  %indvars.iv114 = phi i64 [ %indvars.iv.next115, %for.inc31 ], [ 1, %for.cond8.preheader.split ]
  br label %for.cond12.preheader.split, !dbg !19

for.cond12.preheader.split:                       ; preds = %for.cond12.preheader
  br label %for.body14, !dbg !19

for.body14:                                       ; preds = %for.body14.split, %for.cond12.preheader.split
  %indvars.iv111 = phi i64 [ 0, %for.cond12.preheader.split ], [ %indvars.iv.next112, %for.body14.split ]
  br label %for.body14.split, !dbg !20

for.body14.split:                                 ; preds = %for.body14
  %arrayidx22 = getelementptr inbounds [102 x [103 x [103 x [5 x double]]]], [102 x [103 x [103 x [5 x double]]]]* @rhs, i64 0, i64 %indvars.iv121, i64 %indvars.iv117, i64 %indvars.iv114, i64 %indvars.iv111, !dbg !20
  %6 = load double, double* %arrayidx22, align 8, !dbg !20, !tbaa !21
  %arrayidx24 = getelementptr inbounds double, double* %rms, i64 %indvars.iv111, !dbg !23
  %7 = load double, double* %arrayidx24, align 8, !dbg !23, !tbaa !21
  %mul = fmul double %6, %6, !dbg !24
  %add25 = fadd double %7, %mul, !dbg !25
  store double %add25, double* %arrayidx24, align 8, !dbg !26, !tbaa !21
  %indvars.iv.next112 = add nuw nsw i64 %indvars.iv111, 1, !dbg !27
  %exitcond113 = icmp eq i64 %indvars.iv.next112, 5, !dbg !28
  br i1 %exitcond113, label %for.inc31, label %for.body14, !dbg !19, !llvm.loop !29

for.inc31:                                        ; preds = %for.body14.split
  %indvars.iv.next115 = add nuw nsw i64 %indvars.iv114, 1, !dbg !31
  %exitcond116 = icmp eq i64 %indvars.iv.next115, %wide.trip.count, !dbg !32
  br i1 %exitcond116, label %for.inc34, label %for.cond12.preheader, !dbg !18, !llvm.loop !33

for.inc34:                                        ; preds = %for.inc31, %for.cond8.preheader.split
  %indvars.iv.next118 = add nuw nsw i64 %indvars.iv117, 1, !dbg !35
  %exitcond120 = icmp eq i64 %indvars.iv.next118, %wide.trip.count119, !dbg !36
  br i1 %exitcond120, label %for.inc37, label %for.cond8.preheader, !dbg !17, !llvm.loop !37

for.inc37:                                        ; preds = %for.inc34, %for.cond4.preheader.split
  %indvars.iv.next122 = add nuw nsw i64 %indvars.iv121, 1, !dbg !39
  %cmp2 = icmp slt i64 %indvars.iv121, %5, !dbg !15
  br i1 %cmp2, label %for.cond4.preheader, label %for.cond43.preheader.preheader, !dbg !16, !llvm.loop !40

for.cond43.preheader.preheader:                   ; preds = %for.inc37, %entry
  br label %for.cond43.preheader, !dbg !42

for.cond43.preheader:                             ; preds = %for.end55.split, %for.cond43.preheader.preheader
  %indvars.iv108 = phi i64 [ %indvars.iv.next109, %for.end55.split ], [ 0, %for.cond43.preheader.preheader ]
  br label %for.cond43.preheader.split, !dbg !42

for.cond43.preheader.split:                       ; preds = %for.cond43.preheader
  %arrayidx47 = getelementptr inbounds double, double* %rms, i64 %indvars.iv108, !dbg !42
  %8 = load double, double* %arrayidx47, align 8, !dbg !42, !tbaa !21
  br label %for.body45, !dbg !43

for.body45:                                       ; preds = %for.body45.split, %for.cond43.preheader.split
  %indvars.iv = phi i64 [ 0, %for.cond43.preheader.split ], [ %indvars.iv.next, %for.body45.split ]
  %9 = phi double [ %8, %for.cond43.preheader.split ], [ %div, %for.body45.split ]
  br label %for.body45.split, !dbg !44

for.body45.split:                                 ; preds = %for.body45
  %arrayidx49 = getelementptr inbounds [3 x i32], [3 x i32]* @grid_points, i64 0, i64 %indvars.iv, !dbg !44
  %10 = load i32, i32* %arrayidx49, align 4, !dbg !44, !tbaa !11
  %sub50 = add nsw i32 %10, -2, !dbg !45
  %conv = sitofp i32 %sub50 to double, !dbg !46
  %div = fdiv double %9, %conv, !dbg !47
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1, !dbg !48
  %exitcond = icmp eq i64 %indvars.iv.next, 3, !dbg !49
  br i1 %exitcond, label %for.end55, label %for.body45, !dbg !43, !llvm.loop !50

for.end55:                                        ; preds = %for.body45.split
  store double %div, double* %arrayidx47, align 8, !dbg !52, !tbaa !21
  %call = tail call double @sqrt(double %div) #4, !dbg !53
  store double %call, double* %arrayidx47, align 8, !dbg !54, !tbaa !21
  br label %for.end55.split, !dbg !55

for.end55.split:                                  ; preds = %for.end55
  %indvars.iv.next109 = add nuw nsw i64 %indvars.iv108, 1, !dbg !55
  %exitcond110 = icmp eq i64 %indvars.iv.next109, 5, !dbg !56
  br i1 %exitcond110, label %for.end62, label %for.cond43.preheader, !dbg !57, !llvm.loop !58

for.end62:                                        ; preds = %for.end55.split
  ret void, !dbg !60
}

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64, i8* nocapture) #1

; Function Attrs: nounwind
declare dso_local double @sqrt(double) local_unnamed_addr #2

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64, i8* nocapture) #1

; Function Attrs: nounwind uwtable
define dso_local i32 @main(i32 %argc, i8** nocapture readnone %argv) local_unnamed_addr #0 !dbg !61 {
entry:
  %xcr = alloca [5 x double], align 16
  %0 = bitcast [5 x double]* %xcr to i8*, !dbg !62
  call void @llvm.lifetime.start.p0i8(i64 40, i8* nonnull %0) #4, !dbg !62
  %puts = tail call i32 @puts(i8* getelementptr inbounds ([58 x i8], [58 x i8]* @str, i64 0, i64 0)), !dbg !63
  %call1 = tail call %struct._IO_FILE* @fopen(i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.1, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i64 0, i64 0)), !dbg !64
  %cmp = icmp eq %struct._IO_FILE* %call1, null, !dbg !65
  br i1 %cmp, label %if.else, label %if.then, !dbg !66

if.then:                                          ; preds = %entry
  %puts15 = tail call i32 @puts(i8* getelementptr inbounds ([38 x i8], [38 x i8]* @str.9, i64 0, i64 0)), !dbg !67
  br label %while.cond, !dbg !68

while.cond:                                       ; preds = %while.cond, %if.then
  %call3 = tail call i32 @fgetc(%struct._IO_FILE* nonnull %call1), !dbg !69
  %cmp4 = icmp eq i32 %call3, 10, !dbg !70
  br i1 %cmp4, label %while.end, label %while.cond, !dbg !68, !llvm.loop !71

while.end:                                        ; preds = %while.cond
  %call5 = tail call i32 (%struct._IO_FILE*, i8*, ...) @__isoc99_fscanf(%struct._IO_FILE* nonnull %call1, i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.4, i64 0, i64 0), i32* getelementptr inbounds ([3 x i32], [3 x i32]* @grid_points, i64 0, i64 0), i32* getelementptr inbounds ([3 x i32], [3 x i32]* @grid_points, i64 0, i64 1), i32* getelementptr inbounds ([3 x i32], [3 x i32]* @grid_points, i64 0, i64 2)) #4, !dbg !73
  %call6 = tail call i32 @fclose(%struct._IO_FILE* nonnull %call1), !dbg !74
  %.pre = load i32, i32* getelementptr inbounds ([3 x i32], [3 x i32]* @grid_points, i64 0, i64 0), align 4, !dbg !75, !tbaa !11
  %.pre16 = load i32, i32* getelementptr inbounds ([3 x i32], [3 x i32]* @grid_points, i64 0, i64 1), align 4, !dbg !76, !tbaa !11
  %.pre17 = load i32, i32* getelementptr inbounds ([3 x i32], [3 x i32]* @grid_points, i64 0, i64 2), align 4, !dbg !77, !tbaa !11
  br label %if.end, !dbg !78

if.else:                                          ; preds = %entry
  %puts14 = tail call i32 @puts(i8* getelementptr inbounds ([53 x i8], [53 x i8]* @str.8, i64 0, i64 0)), !dbg !79
  store i32 102, i32* getelementptr inbounds ([3 x i32], [3 x i32]* @grid_points, i64 0, i64 0), align 4, !dbg !80, !tbaa !11
  store i32 102, i32* getelementptr inbounds ([3 x i32], [3 x i32]* @grid_points, i64 0, i64 1), align 4, !dbg !81, !tbaa !11
  store i32 102, i32* getelementptr inbounds ([3 x i32], [3 x i32]* @grid_points, i64 0, i64 2), align 4, !dbg !82, !tbaa !11
  br label %if.end

if.end:                                           ; preds = %if.else, %while.end
  %1 = phi i32 [ 102, %if.else ], [ %.pre17, %while.end ], !dbg !77
  %2 = phi i32 [ 102, %if.else ], [ %.pre16, %while.end ], !dbg !76
  %3 = phi i32 [ 102, %if.else ], [ %.pre, %while.end ], !dbg !75
  %call8 = tail call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([20 x i8], [20 x i8]* @.str.6, i64 0, i64 0), i32 %3, i32 %2, i32 %1), !dbg !83
  %putchar = tail call i32 @putchar(i32 10), !dbg !84
  call void @llvm.memset.p0i8.i64(i8* nonnull align 16 %0, i8 0, i64 40, i1 false) #4, !dbg !85
  %4 = load i32, i32* getelementptr inbounds ([3 x i32], [3 x i32]* @grid_points, i64 0, i64 2), align 4, !dbg !87, !tbaa !11
  %cmp2105.i = icmp slt i32 %4, 3, !dbg !88
  br i1 %cmp2105.i, label %for.cond43.preheader.i.preheader, label %for.cond4.preheader.lr.ph.i, !dbg !89

for.cond4.preheader.lr.ph.i:                      ; preds = %if.end
  %5 = load i32, i32* getelementptr inbounds ([3 x i32], [3 x i32]* @grid_points, i64 0, i64 1), align 4
  %cmp6102.i = icmp slt i32 %5, 3
  %sub.i = add nsw i32 %4, -2
  %6 = load i32, i32* getelementptr inbounds ([3 x i32], [3 x i32]* @grid_points, i64 0, i64 0), align 4
  %cmp1099.i = icmp slt i32 %6, 3
  %7 = add i32 %6, -1, !dbg !89
  %8 = add i32 %5, -1, !dbg !89
  %9 = sext i32 %sub.i to i64, !dbg !89
  %wide.trip.count119.i = zext i32 %8 to i64
  %wide.trip.count.i = zext i32 %7 to i64
  br label %for.cond4.preheader.i, !dbg !89

for.cond4.preheader.i:                            ; preds = %for.inc37.i, %for.cond4.preheader.lr.ph.i
  %indvars.iv121.i = phi i64 [ %indvars.iv.next122.i, %for.inc37.i ], [ 1, %for.cond4.preheader.lr.ph.i ]
  br i1 %cmp6102.i, label %for.inc37.i, label %for.cond8.preheader.i, !dbg !90

for.cond8.preheader.i:                            ; preds = %for.inc34.i, %for.cond4.preheader.i
  %indvars.iv117.i = phi i64 [ %indvars.iv.next118.i, %for.inc34.i ], [ 1, %for.cond4.preheader.i ]
  br i1 %cmp1099.i, label %for.inc34.i, label %for.cond12.preheader.i, !dbg !91

for.cond12.preheader.i:                           ; preds = %for.inc31.i, %for.cond8.preheader.i
  %indvars.iv114.i = phi i64 [ %indvars.iv.next115.i, %for.inc31.i ], [ 1, %for.cond8.preheader.i ]
  br label %for.body14.i, !dbg !92

for.body14.i:                                     ; preds = %for.body14.i, %for.cond12.preheader.i
  %indvars.iv111.i = phi i64 [ 0, %for.cond12.preheader.i ], [ %indvars.iv.next112.i, %for.body14.i ]
  %arrayidx22.i = getelementptr inbounds [102 x [103 x [103 x [5 x double]]]], [102 x [103 x [103 x [5 x double]]]]* @rhs, i64 0, i64 %indvars.iv121.i, i64 %indvars.iv117.i, i64 %indvars.iv114.i, i64 %indvars.iv111.i, !dbg !93
  %10 = load double, double* %arrayidx22.i, align 8, !dbg !93, !tbaa !21
  %arrayidx24.i = getelementptr inbounds [5 x double], [5 x double]* %xcr, i64 0, i64 %indvars.iv111.i, !dbg !94
  %11 = load double, double* %arrayidx24.i, align 8, !dbg !94, !tbaa !21
  %mul.i = fmul double %10, %10, !dbg !95
  %add25.i = fadd double %11, %mul.i, !dbg !96
  store double %add25.i, double* %arrayidx24.i, align 8, !dbg !97, !tbaa !21
  %indvars.iv.next112.i = add nuw nsw i64 %indvars.iv111.i, 1, !dbg !98
  %exitcond113.i = icmp eq i64 %indvars.iv.next112.i, 5, !dbg !99
  br i1 %exitcond113.i, label %for.inc31.i, label %for.body14.i, !dbg !92, !llvm.loop !29

for.inc31.i:                                      ; preds = %for.body14.i
  %indvars.iv.next115.i = add nuw nsw i64 %indvars.iv114.i, 1, !dbg !100
  %exitcond116.i = icmp eq i64 %indvars.iv.next115.i, %wide.trip.count.i, !dbg !101
  br i1 %exitcond116.i, label %for.inc34.i, label %for.cond12.preheader.i, !dbg !91, !llvm.loop !33

for.inc34.i:                                      ; preds = %for.inc31.i, %for.cond8.preheader.i
  %indvars.iv.next118.i = add nuw nsw i64 %indvars.iv117.i, 1, !dbg !102
  %exitcond120.i = icmp eq i64 %indvars.iv.next118.i, %wide.trip.count119.i, !dbg !103
  br i1 %exitcond120.i, label %for.inc37.i, label %for.cond8.preheader.i, !dbg !90, !llvm.loop !37

for.inc37.i:                                      ; preds = %for.inc34.i, %for.cond4.preheader.i
  %indvars.iv.next122.i = add nuw nsw i64 %indvars.iv121.i, 1, !dbg !104
  %cmp2.i = icmp slt i64 %indvars.iv121.i, %9, !dbg !88
  br i1 %cmp2.i, label %for.cond4.preheader.i, label %for.cond43.preheader.i.preheader, !dbg !89, !llvm.loop !40

for.cond43.preheader.i.preheader:                 ; preds = %for.inc37.i, %if.end
  br label %for.cond43.preheader.i, !dbg !105

for.cond43.preheader.i:                           ; preds = %for.end55.i, %for.cond43.preheader.i.preheader
  %indvars.iv108.i = phi i64 [ %indvars.iv.next109.i, %for.end55.i ], [ 0, %for.cond43.preheader.i.preheader ]
  %arrayidx47.i = getelementptr inbounds [5 x double], [5 x double]* %xcr, i64 0, i64 %indvars.iv108.i, !dbg !105
  %12 = load double, double* %arrayidx47.i, align 8, !dbg !105, !tbaa !21
  br label %for.body45.i, !dbg !106

for.body45.i:                                     ; preds = %for.body45.i, %for.cond43.preheader.i
  %indvars.iv.i = phi i64 [ 0, %for.cond43.preheader.i ], [ %indvars.iv.next.i, %for.body45.i ]
  %13 = phi double [ %12, %for.cond43.preheader.i ], [ %div.i, %for.body45.i ]
  %arrayidx49.i = getelementptr inbounds [3 x i32], [3 x i32]* @grid_points, i64 0, i64 %indvars.iv.i, !dbg !107
  %14 = load i32, i32* %arrayidx49.i, align 4, !dbg !107, !tbaa !11
  %sub50.i = add nsw i32 %14, -2, !dbg !108
  %conv.i = sitofp i32 %sub50.i to double, !dbg !109
  %div.i = fdiv double %13, %conv.i, !dbg !110
  %indvars.iv.next.i = add nuw nsw i64 %indvars.iv.i, 1, !dbg !111
  %exitcond.i = icmp eq i64 %indvars.iv.next.i, 3, !dbg !112
  br i1 %exitcond.i, label %for.end55.i, label %for.body45.i, !dbg !106, !llvm.loop !50

for.end55.i:                                      ; preds = %for.body45.i
  %call.i = tail call double @sqrt(double %div.i) #4, !dbg !113
  store double %call.i, double* %arrayidx47.i, align 8, !dbg !114, !tbaa !21
  %indvars.iv.next109.i = add nuw nsw i64 %indvars.iv108.i, 1, !dbg !115
  %exitcond110.i = icmp eq i64 %indvars.iv.next109.i, 5, !dbg !116
  br i1 %exitcond110.i, label %rhs_norm.exit, label %for.cond43.preheader.i, !dbg !117, !llvm.loop !58

rhs_norm.exit:                                    ; preds = %for.end55.i
  call void @llvm.lifetime.end.p0i8(i64 40, i8* nonnull %0) #4, !dbg !118
  ret i32 0, !dbg !119
}

; Function Attrs: nounwind
declare dso_local i32 @printf(i8* nocapture readonly, ...) local_unnamed_addr #2

; Function Attrs: nounwind
declare dso_local noalias %struct._IO_FILE* @fopen(i8* nocapture readonly, i8* nocapture readonly) local_unnamed_addr #2

; Function Attrs: nounwind
declare dso_local i32 @fgetc(%struct._IO_FILE* nocapture) local_unnamed_addr #2

declare dso_local i32 @__isoc99_fscanf(%struct._IO_FILE*, i8*, ...) local_unnamed_addr #3

; Function Attrs: nounwind
declare dso_local i32 @fclose(%struct._IO_FILE* nocapture) local_unnamed_addr #2

; Function Attrs: nounwind
declare i32 @puts(i8* nocapture readonly) local_unnamed_addr #4

; Function Attrs: nounwind
declare i32 @putchar(i32) local_unnamed_addr #4

; Function Attrs: argmemonly nounwind
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1) #1

; Function Attrs: nounwind uwtable
define void @rhs_norm_for.cond43.preheader.split.clone(double* %rms, i64 %indvars.iv108) #0 {
newFuncRoot:
  br label %for.cond43.preheader.split.clone, !dbg !42

exit:                                             ; preds = %for.end55.clone
  ret void

for.cond43.preheader.split.clone:                 ; preds = %newFuncRoot
  %arrayidx47.clone = getelementptr inbounds double, double* %rms, i64 %indvars.iv108, !dbg !42
  %0 = load double, double* %arrayidx47.clone, align 8, !dbg !42, !tbaa !21
  br label %for.body45.clone, !dbg !43

for.body45.clone:                                 ; preds = %for.body45.split.clone, %for.cond43.preheader.split.clone
  %indvars.iv.clone = phi i64 [ 0, %for.cond43.preheader.split.clone ], [ %indvars.iv.next.clone, %for.body45.split.clone ]
  %1 = phi double [ %0, %for.cond43.preheader.split.clone ], [ %div.clone, %for.body45.split.clone ]
  br label %for.body45.split.clone, !dbg !44

for.body45.split.clone:                           ; preds = %for.body45.clone
  %arrayidx49.clone = getelementptr inbounds [3 x i32], [3 x i32]* @grid_points, i64 0, i64 %indvars.iv.clone, !dbg !44
  %2 = load i32, i32* %arrayidx49.clone, align 4, !dbg !44, !tbaa !11
  %sub50.clone = add nsw i32 %2, -2, !dbg !45
  %conv.clone = sitofp i32 %sub50.clone to double, !dbg !46
  %div.clone = fdiv double %1, %conv.clone, !dbg !47
  %indvars.iv.next.clone = add nuw nsw i64 %indvars.iv.clone, 1, !dbg !48
  %exitcond.clone = icmp eq i64 %indvars.iv.next.clone, 3, !dbg !49
  br i1 %exitcond.clone, label %for.end55.clone, label %for.body45.clone, !dbg !43, !llvm.loop !50

for.end55.clone:                                  ; preds = %for.body45.split.clone
  store double %div.clone, double* %arrayidx47.clone, align 8, !dbg !52, !tbaa !21
  %call.clone = tail call double @sqrt(double %div.clone) #4, !dbg !53
  store double %call.clone, double* %arrayidx47.clone, align 8, !dbg !54, !tbaa !21
  br label %exit, !dbg !55
}

; Function Attrs: nounwind uwtable
define void @rhs_norm_for.cond4.preheader.split.clone(i1 %cmp6102, i1 %cmp1099, i64 %wide.trip.count119, i64 %indvars.iv121, double* %rms, i64 %wide.trip.count) #0 {
newFuncRoot:
  br label %for.cond4.preheader.split.clone, !dbg !17

exit:                                             ; preds = %for.inc34.clone, %for.cond4.preheader.split.clone
  ret void

for.cond4.preheader.split.clone:                  ; preds = %newFuncRoot
  br i1 %cmp6102, label %exit, label %for.cond8.preheader.clone, !dbg !17

for.cond8.preheader.clone:                        ; preds = %for.inc34.clone, %for.cond4.preheader.split.clone
  %indvars.iv117.clone = phi i64 [ %indvars.iv.next118.clone, %for.inc34.clone ], [ 1, %for.cond4.preheader.split.clone ]
  br label %for.cond8.preheader.split.clone, !dbg !18

for.cond8.preheader.split.clone:                  ; preds = %for.cond8.preheader.clone
  br i1 %cmp1099, label %for.inc34.clone, label %for.cond12.preheader.clone, !dbg !18

for.inc34.clone:                                  ; preds = %for.inc31.clone, %for.cond8.preheader.split.clone
  %indvars.iv.next118.clone = add nuw nsw i64 %indvars.iv117.clone, 1, !dbg !35
  %exitcond120.clone = icmp eq i64 %indvars.iv.next118.clone, %wide.trip.count119, !dbg !36
  br i1 %exitcond120.clone, label %exit, label %for.cond8.preheader.clone, !dbg !17, !llvm.loop !37

for.cond12.preheader.clone:                       ; preds = %for.inc31.clone, %for.cond8.preheader.split.clone
  %indvars.iv114.clone = phi i64 [ %indvars.iv.next115.clone, %for.inc31.clone ], [ 1, %for.cond8.preheader.split.clone ]
  br label %for.cond12.preheader.split.clone, !dbg !19

for.cond12.preheader.split.clone:                 ; preds = %for.cond12.preheader.clone
  br label %for.body14.clone, !dbg !19

for.body14.clone:                                 ; preds = %for.body14.split.clone, %for.cond12.preheader.split.clone
  %indvars.iv111.clone = phi i64 [ 0, %for.cond12.preheader.split.clone ], [ %indvars.iv.next112.clone, %for.body14.split.clone ]
  br label %for.body14.split.clone, !dbg !20

for.body14.split.clone:                           ; preds = %for.body14.clone
  %arrayidx22.clone = getelementptr inbounds [102 x [103 x [103 x [5 x double]]]], [102 x [103 x [103 x [5 x double]]]]* @rhs, i64 0, i64 %indvars.iv121, i64 %indvars.iv117.clone, i64 %indvars.iv114.clone, i64 %indvars.iv111.clone, !dbg !20
  %0 = load double, double* %arrayidx22.clone, align 8, !dbg !20, !tbaa !21
  %arrayidx24.clone = getelementptr inbounds double, double* %rms, i64 %indvars.iv111.clone, !dbg !23
  %1 = load double, double* %arrayidx24.clone, align 8, !dbg !23, !tbaa !21
  %mul.clone = fmul double %0, %0, !dbg !24
  %add25.clone = fadd double %1, %mul.clone, !dbg !25
  store double %add25.clone, double* %arrayidx24.clone, align 8, !dbg !26, !tbaa !21
  %indvars.iv.next112.clone = add nuw nsw i64 %indvars.iv111.clone, 1, !dbg !27
  %exitcond113.clone = icmp eq i64 %indvars.iv.next112.clone, 5, !dbg !28
  br i1 %exitcond113.clone, label %for.inc31.clone, label %for.body14.clone, !dbg !19, !llvm.loop !29

for.inc31.clone:                                  ; preds = %for.body14.split.clone
  %indvars.iv.next115.clone = add nuw nsw i64 %indvars.iv114.clone, 1, !dbg !31
  %exitcond116.clone = icmp eq i64 %indvars.iv.next115.clone, %wide.trip.count, !dbg !32
  br i1 %exitcond116.clone, label %for.inc34.clone, label %for.cond12.preheader.clone, !dbg !18, !llvm.loop !33
}

attributes #0 = { nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind }
attributes #2 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!3, !4, !5}
!llvm.ident = !{!6}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "clang version 7.0.0 (https://github.com/llvm-mirror/clang.git 0513b409d5e34b2d2a28ae21b6d620cc52de0e57) (https://github.com/llvm-mirror/llvm.git 65ce2e56889af84e8be8e311f484a4dfe4b62d7a)", isOptimized: true, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!1 = !DIFile(filename: "nas_bt_rhs_norm.c", directory: "/home/vasich/Desktop/nas_bt_rhs_norm")
!2 = !{}
!3 = !{i32 2, !"Dwarf Version", i32 4}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{!"clang version 7.0.0 (https://github.com/llvm-mirror/clang.git 0513b409d5e34b2d2a28ae21b6d620cc52de0e57) (https://github.com/llvm-mirror/llvm.git 65ce2e56889af84e8be8e311f484a4dfe4b62d7a)"}
!7 = distinct !DISubprogram(name: "rhs_norm", scope: !1, file: !1, line: 16, type: !8, isLocal: false, isDefinition: true, scopeLine: 16, flags: DIFlagPrototyped, isOptimized: true, unit: !0, retainedNodes: !2)
!8 = !DISubroutineType(types: !2)
!9 = !DILocation(line: 21, column: 12, scope: !7)
!10 = !DILocation(line: 24, column: 20, scope: !7)
!11 = !{!12, !12, i64 0}
!12 = !{!"int", !13, i64 0}
!13 = !{!"omnipotent char", !14, i64 0}
!14 = !{!"Simple C/C++ TBAA"}
!15 = !DILocation(line: 24, column: 17, scope: !7)
!16 = !DILocation(line: 24, column: 3, scope: !7)
!17 = !DILocation(line: 25, column: 5, scope: !7)
!18 = !DILocation(line: 26, column: 7, scope: !7)
!19 = !DILocation(line: 27, column: 9, scope: !7)
!20 = !DILocation(line: 28, column: 17, scope: !7)
!21 = !{!22, !22, i64 0}
!22 = !{!"double", !13, i64 0}
!23 = !DILocation(line: 29, column: 20, scope: !7)
!24 = !DILocation(line: 29, column: 33, scope: !7)
!25 = !DILocation(line: 29, column: 27, scope: !7)
!26 = !DILocation(line: 29, column: 18, scope: !7)
!27 = !DILocation(line: 27, column: 29, scope: !7)
!28 = !DILocation(line: 27, column: 23, scope: !7)
!29 = distinct !{!29, !19, !30}
!30 = !DILocation(line: 30, column: 9, scope: !7)
!31 = !DILocation(line: 26, column: 45, scope: !7)
!32 = !DILocation(line: 26, column: 21, scope: !7)
!33 = distinct !{!33, !18, !34}
!34 = !DILocation(line: 31, column: 7, scope: !7)
!35 = !DILocation(line: 25, column: 43, scope: !7)
!36 = !DILocation(line: 25, column: 19, scope: !7)
!37 = distinct !{!37, !17, !38}
!38 = !DILocation(line: 32, column: 5, scope: !7)
!39 = !DILocation(line: 24, column: 41, scope: !7)
!40 = distinct !{!40, !16, !41}
!41 = !DILocation(line: 33, column: 3, scope: !7)
!42 = !DILocation(line: 0, scope: !7)
!43 = !DILocation(line: 36, column: 5, scope: !7)
!44 = !DILocation(line: 37, column: 34, scope: !7)
!45 = !DILocation(line: 37, column: 49, scope: !7)
!46 = !DILocation(line: 37, column: 25, scope: !7)
!47 = !DILocation(line: 37, column: 23, scope: !7)
!48 = !DILocation(line: 36, column: 25, scope: !7)
!49 = !DILocation(line: 36, column: 19, scope: !7)
!50 = distinct !{!50, !43, !51}
!51 = !DILocation(line: 38, column: 5, scope: !7)
!52 = !DILocation(line: 37, column: 14, scope: !7)
!53 = !DILocation(line: 39, column: 14, scope: !7)
!54 = !DILocation(line: 39, column: 12, scope: !7)
!55 = !DILocation(line: 35, column: 23, scope: !7)
!56 = !DILocation(line: 35, column: 17, scope: !7)
!57 = !DILocation(line: 35, column: 3, scope: !7)
!58 = distinct !{!58, !57, !59}
!59 = !DILocation(line: 40, column: 3, scope: !7)
!60 = !DILocation(line: 41, column: 1, scope: !7)
!61 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 43, type: !8, isLocal: false, isDefinition: true, scopeLine: 43, flags: DIFlagPrototyped, isOptimized: true, unit: !0, retainedNodes: !2)
!62 = !DILocation(line: 45, column: 3, scope: !61)
!63 = !DILocation(line: 47, column: 3, scope: !61)
!64 = !DILocation(line: 49, column: 13, scope: !61)
!65 = !DILocation(line: 49, column: 41, scope: !61)
!66 = !DILocation(line: 49, column: 7, scope: !61)
!67 = !DILocation(line: 51, column: 5, scope: !61)
!68 = !DILocation(line: 52, column: 5, scope: !61)
!69 = !DILocation(line: 52, column: 12, scope: !61)
!70 = !DILocation(line: 52, column: 22, scope: !61)
!71 = distinct !{!71, !68, !72}
!72 = !DILocation(line: 53, column: 7, scope: !61)
!73 = !DILocation(line: 54, column: 14, scope: !61)
!74 = !DILocation(line: 56, column: 5, scope: !61)
!75 = !DILocation(line: 64, column: 34, scope: !61)
!76 = !DILocation(line: 64, column: 50, scope: !61)
!77 = !DILocation(line: 65, column: 10, scope: !61)
!78 = !DILocation(line: 57, column: 3, scope: !61)
!79 = !DILocation(line: 58, column: 5, scope: !61)
!80 = !DILocation(line: 59, column: 20, scope: !61)
!81 = !DILocation(line: 60, column: 20, scope: !61)
!82 = !DILocation(line: 61, column: 20, scope: !61)
!83 = !DILocation(line: 64, column: 3, scope: !61)
!84 = !DILocation(line: 66, column: 3, scope: !61)
!85 = !DILocation(line: 21, column: 12, scope: !7, inlinedAt: !86)
!86 = distinct !DILocation(line: 68, column: 3, scope: !61)
!87 = !DILocation(line: 24, column: 20, scope: !7, inlinedAt: !86)
!88 = !DILocation(line: 24, column: 17, scope: !7, inlinedAt: !86)
!89 = !DILocation(line: 24, column: 3, scope: !7, inlinedAt: !86)
!90 = !DILocation(line: 25, column: 5, scope: !7, inlinedAt: !86)
!91 = !DILocation(line: 26, column: 7, scope: !7, inlinedAt: !86)
!92 = !DILocation(line: 27, column: 9, scope: !7, inlinedAt: !86)
!93 = !DILocation(line: 28, column: 17, scope: !7, inlinedAt: !86)
!94 = !DILocation(line: 29, column: 20, scope: !7, inlinedAt: !86)
!95 = !DILocation(line: 29, column: 33, scope: !7, inlinedAt: !86)
!96 = !DILocation(line: 29, column: 27, scope: !7, inlinedAt: !86)
!97 = !DILocation(line: 29, column: 18, scope: !7, inlinedAt: !86)
!98 = !DILocation(line: 27, column: 29, scope: !7, inlinedAt: !86)
!99 = !DILocation(line: 27, column: 23, scope: !7, inlinedAt: !86)
!100 = !DILocation(line: 26, column: 45, scope: !7, inlinedAt: !86)
!101 = !DILocation(line: 26, column: 21, scope: !7, inlinedAt: !86)
!102 = !DILocation(line: 25, column: 43, scope: !7, inlinedAt: !86)
!103 = !DILocation(line: 25, column: 19, scope: !7, inlinedAt: !86)
!104 = !DILocation(line: 24, column: 41, scope: !7, inlinedAt: !86)
!105 = !DILocation(line: 0, scope: !7, inlinedAt: !86)
!106 = !DILocation(line: 36, column: 5, scope: !7, inlinedAt: !86)
!107 = !DILocation(line: 37, column: 34, scope: !7, inlinedAt: !86)
!108 = !DILocation(line: 37, column: 49, scope: !7, inlinedAt: !86)
!109 = !DILocation(line: 37, column: 25, scope: !7, inlinedAt: !86)
!110 = !DILocation(line: 37, column: 23, scope: !7, inlinedAt: !86)
!111 = !DILocation(line: 36, column: 25, scope: !7, inlinedAt: !86)
!112 = !DILocation(line: 36, column: 19, scope: !7, inlinedAt: !86)
!113 = !DILocation(line: 39, column: 14, scope: !7, inlinedAt: !86)
!114 = !DILocation(line: 39, column: 12, scope: !7, inlinedAt: !86)
!115 = !DILocation(line: 35, column: 23, scope: !7, inlinedAt: !86)
!116 = !DILocation(line: 35, column: 17, scope: !7, inlinedAt: !86)
!117 = !DILocation(line: 35, column: 3, scope: !7, inlinedAt: !86)
!118 = !DILocation(line: 71, column: 1, scope: !61)
!119 = !DILocation(line: 70, column: 3, scope: !61)
