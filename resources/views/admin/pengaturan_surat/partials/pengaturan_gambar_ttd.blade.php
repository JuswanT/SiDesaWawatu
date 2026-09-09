<div class="tab-pane" id="gambar-ttd">
    <div class="box-body">
        <div class="row">
            <div class="col-md-6">
                <h4>Pengaturan Gambar Tanda Tangan Kades</h4>
                <div class="form-group">
                    <label>Upload Gambar TTD Kades (PNG Transparan)</label>
                    <input type="file" name="ttd_kades_file" class="form-control input-sm" accept=".png,.jpg,.jpeg">
                    @if(setting('ttd_kades_file'))
                        <div style="margin-top: 5px;">
                            <small class="text-success"><i class="fa fa-check"></i> File terupload: {{ setting('ttd_kades_file') }}</small>
                        </div>
                    @endif
                </div>
                <div class="row">
                    <div class="col-md-3">
                        <div class="form-group">
                            <label>Lebar (px)</label>
                            <input type="number" name="ttd_kades_width" class="form-control input-sm" value="{{ setting('ttd_kades_width') ?? 100 }}">
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label>Tinggi (px)</label>
                            <input type="number" name="ttd_kades_height" class="form-control input-sm" value="{{ setting('ttd_kades_height') ?? 50 }}">
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label>Posisi X</label>
                            <input type="number" name="ttd_kades_x" class="form-control input-sm" value="{{ setting('ttd_kades_x') ?? 0 }}">
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label>Posisi Y</label>
                            <input type="number" name="ttd_kades_y" class="form-control input-sm" value="{{ setting('ttd_kades_y') ?? 0 }}">
                        </div>
                    </div>
                </div>

                <hr>

                <h4>Pengaturan Gambar Stempel Desa</h4>
                <div class="form-group">
                    <label>Upload Gambar Stempel (PNG Transparan)</label>
                    <input type="file" name="stempel_desa_file" class="form-control input-sm" accept=".png,.jpg,.jpeg">
                    @if(setting('stempel_desa_file'))
                        <div style="margin-top: 5px;">
                            <small class="text-success"><i class="fa fa-check"></i> File terupload: {{ setting('stempel_desa_file') }}</small>
                        </div>
                    @endif
                </div>
                <div class="row">
                    <div class="col-md-3">
                        <div class="form-group">
                            <label>Lebar (px)</label>
                            <input type="number" name="stempel_desa_width" class="form-control input-sm" value="{{ setting('stempel_desa_width') ?? 80 }}">
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label>Tinggi (px)</label>
                            <input type="number" name="stempel_desa_height" class="form-control input-sm" value="{{ setting('stempel_desa_height') ?? 80 }}">
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label>Posisi X</label>
                            <input type="number" name="stempel_desa_x" class="form-control input-sm" value="{{ setting('stempel_desa_x') ?? -20 }}">
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label>Posisi Y</label>
                            <input type="number" name="stempel_desa_y" class="form-control input-sm" value="{{ setting('stempel_desa_y') ?? -10 }}">
                        </div>
                    </div>
                </div>
                
                <div class="alert alert-info" style="margin-top: 15px;">
                    <p><i class="fa fa-info-circle"></i> <b>Informasi:</b> Anda dapat menggeser (drag) gambar secara langsung pada kotak pratinjau di samping untuk menyesuaikan posisinya secara otomatis.</p>
                </div>
            </div>
            
            <div class="col-md-6">
                <h4>Pratinjau Posisi TTD & Stempel</h4>
                <div style="border: 1px solid #ccc; background: white; padding: 40px; text-align: center; min-height: 300px; position: relative;">
                    <div style="position: relative; display: inline-block; text-align: center; padding-top: 20px;">
                        
                        <!-- Anchor Posisi (Simulasi Atas_nama) -->
                        <span style="position: relative;">
                            a.n. Kepala Desa
                            <br>Sekretaris Desa
                            
                            @if(setting('stempel_desa_file'))
                                <img id="preview-stempel" src="{{ base_url(LOKASI_MEDIA . setting('stempel_desa_file')) }}" style="position: absolute; width: {{ setting('stempel_desa_width') ?? 80 }}px; height: {{ setting('stempel_desa_height') ?? 80 }}px; left: {{ setting('stempel_desa_x') ?? -20 }}px; top: {{ setting('stempel_desa_y') ?? -10 }}px; cursor: move; border: 1px dashed rgba(0,0,255,0.5); z-index: 10;" title="Geser Stempel">
                            @endif

                            @if(setting('ttd_kades_file'))
                                <img id="preview-ttd" src="{{ base_url(LOKASI_MEDIA . setting('ttd_kades_file')) }}" style="position: absolute; width: {{ setting('ttd_kades_width') ?? 100 }}px; height: {{ setting('ttd_kades_height') ?? 50 }}px; left: {{ setting('ttd_kades_x') ?? 0 }}px; top: {{ setting('ttd_kades_y') ?? 0 }}px; cursor: move; border: 1px dashed rgba(255,0,0,0.5); z-index: 11;" title="Geser Tanda Tangan">
                            @endif
                        </span>
                        
                        <br><br><br><br>
                        <u><b>NAMA PENANDATANGAN</b></u>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

@push('scripts')
<script>
$(document).ready(function() {
    if ($.fn.draggable) {
        $('#preview-stempel').draggable({
            stop: function(event, ui) {
                $('input[name="stempel_desa_x"]').val(Math.round(ui.position.left));
                $('input[name="stempel_desa_y"]').val(Math.round(ui.position.top));
            }
        });

        $('#preview-ttd').draggable({
            stop: function(event, ui) {
                $('input[name="ttd_kades_x"]').val(Math.round(ui.position.left));
                $('input[name="ttd_kades_y"]').val(Math.round(ui.position.top));
            }
        });
    }

    $('input[name="ttd_kades_width"]').on('input', function() { $('#preview-ttd').css('width', $(this).val() + 'px'); });
    $('input[name="ttd_kades_height"]').on('input', function() { $('#preview-ttd').css('height', $(this).val() + 'px'); });
    $('input[name="ttd_kades_x"]').on('input', function() { $('#preview-ttd').css('left', $(this).val() + 'px'); });
    $('input[name="ttd_kades_y"]').on('input', function() { $('#preview-ttd').css('top', $(this).val() + 'px'); });

    $('input[name="stempel_desa_width"]').on('input', function() { $('#preview-stempel').css('width', $(this).val() + 'px'); });
    $('input[name="stempel_desa_height"]').on('input', function() { $('#preview-stempel').css('height', $(this).val() + 'px'); });
    $('input[name="stempel_desa_x"]').on('input', function() { $('#preview-stempel').css('left', $(this).val() + 'px'); });
    $('input[name="stempel_desa_y"]').on('input', function() { $('#preview-stempel').css('top', $(this).val() + 'px'); });
});
</script>
@endpush
