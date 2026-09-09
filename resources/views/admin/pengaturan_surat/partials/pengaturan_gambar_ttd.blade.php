<div class="tab-pane" id="gambar-ttd">
    <div class="box-body">
        <h4>Pengaturan Gambar Tanda Tangan Kades</h4>
        <div class="row">
            <div class="col-md-4">
                <div class="form-group">
                    <label>Upload Gambar TTD Kades (PNG Transparan)</label>
                    <input type="file" name="ttd_kades_file" class="form-control input-sm" accept=".png,.jpg,.jpeg">
                    @if(setting('ttd_kades_file'))
                        <div style="margin-top: 10px;">
                            <img src="{{ base_url(LOKASI_MEDIA . setting('ttd_kades_file')) }}" alt="TTD Kades" style="max-height: 100px; border: 1px dashed #ccc; padding: 5px;">
                        </div>
                    @endif
                </div>
            </div>
            <div class="col-md-2">
                <div class="form-group">
                    <label>Lebar (Width) - px</label>
                    <input type="number" name="ttd_kades_width" class="form-control input-sm" value="{{ setting('ttd_kades_width') ?? 100 }}">
                </div>
            </div>
            <div class="col-md-2">
                <div class="form-group">
                    <label>Tinggi (Height) - px</label>
                    <input type="number" name="ttd_kades_height" class="form-control input-sm" value="{{ setting('ttd_kades_height') ?? 50 }}">
                </div>
            </div>
            <div class="col-md-2">
                <div class="form-group">
                    <label>Posisi X (Geser Kanan/Kiri) - px</label>
                    <input type="number" name="ttd_kades_x" class="form-control input-sm" value="{{ setting('ttd_kades_x') ?? 0 }}" title="Nilai positif geser ke kanan, negatif geser ke kiri">
                </div>
            </div>
            <div class="col-md-2">
                <div class="form-group">
                    <label>Posisi Y (Geser Bawah/Atas) - px</label>
                    <input type="number" name="ttd_kades_y" class="form-control input-sm" value="{{ setting('ttd_kades_y') ?? 0 }}" title="Nilai positif geser ke bawah, negatif geser ke atas">
                </div>
            </div>
        </div>

        <hr>

        <h4>Pengaturan Gambar Stempel Desa</h4>
        <div class="row">
            <div class="col-md-4">
                <div class="form-group">
                    <label>Upload Gambar Stempel (PNG Transparan)</label>
                    <input type="file" name="stempel_desa_file" class="form-control input-sm" accept=".png,.jpg,.jpeg">
                    @if(setting('stempel_desa_file'))
                        <div style="margin-top: 10px;">
                            <img src="{{ base_url(LOKASI_MEDIA . setting('stempel_desa_file')) }}" alt="Stempel Desa" style="max-height: 100px; border: 1px dashed #ccc; padding: 5px;">
                        </div>
                    @endif
                </div>
            </div>
            <div class="col-md-2">
                <div class="form-group">
                    <label>Lebar (Width) - px</label>
                    <input type="number" name="stempel_desa_width" class="form-control input-sm" value="{{ setting('stempel_desa_width') ?? 80 }}">
                </div>
            </div>
            <div class="col-md-2">
                <div class="form-group">
                    <label>Tinggi (Height) - px</label>
                    <input type="number" name="stempel_desa_height" class="form-control input-sm" value="{{ setting('stempel_desa_height') ?? 80 }}">
                </div>
            </div>
            <div class="col-md-2">
                <div class="form-group">
                    <label>Posisi X (Geser Kanan/Kiri) - px</label>
                    <input type="number" name="stempel_desa_x" class="form-control input-sm" value="{{ setting('stempel_desa_x') ?? -20 }}">
                </div>
            </div>
            <div class="col-md-2">
                <div class="form-group">
                    <label>Posisi Y (Geser Bawah/Atas) - px</label>
                    <input type="number" name="stempel_desa_y" class="form-control input-sm" value="{{ setting('stempel_desa_y') ?? -10 }}">
                </div>
            </div>
        </div>
        
        <div class="alert alert-info" style="margin-top: 15px;">
            <p><i class="fa fa-info-circle"></i> <b>Informasi:</b> Gambar tanda tangan dan stempel akan dirender secara relatif (berada di sekitar/menumpuk blok teks Nama Kepala Desa). Gunakan Posisi X dan Y untuk menggeser gambar agar tidak menutupi nama Kades sepenuhnya.</p>
        </div>
    </div>
</div>
